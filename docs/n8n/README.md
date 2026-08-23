# n8n — Media Pipeline Workflows (multi-account Notion → R2 → Supabase)

**Status:** Importable scaffolds — **verify on import** (n8n-mcp was unavailable to auto-validate; node `typeVersion`/params may need a nudge to match your n8n version).
**Implements:** SS-DR-015 (pipeline) + SS-DR-016 (consent lifecycle, L2). See `../SESSION-A-MEDIA-PIPELINE.md` + `../sql/seo_media_assets.draft.sql`.

---

## The multi-account principle (the whole point)

1 Supabase (GTGT) ← **N** Notion accounts (marketing-vt + gifted + future). We do **NOT** split workflows per account. Instead:

- **Logic is written once.** Account-specific bits (Notion token, database id) are **parameters chosen at runtime**.
- **Routing key = `notion_workspace`** (a column on `seo_media_assets`, and an iteration field in the sync loop). Adding account #3 = **one row in CONFIG + one variable**, no logic change.
- **Dynamic token (key enabler):** the native Notion node binds one credential per node, so we call the **Notion REST API via HTTP Request** and inject the token by expression:
  ```
  Authorization: Bearer {{ $vars['NOTION_TOKEN_' + $json.workspace] }}
  ```
  One node serves every account.

```
CONFIG (Code node, 1 place):
  [ { workspace:"marketing_vt", dataSourceId:"20e248f7-4b65-44eb-bfd4-90dac48a79d7" },
    { workspace:"gifted",       dataSourceId:"<gifted media library data source id>" } ]
  token read from n8n Variable  NOTION_TOKEN_<workspace>
```

---

## Setup (do this before import works)

### 1. n8n Variables (Settings → Variables) — token storage (option 1)
| Variable | Value |
|---|---|
| `NOTION_TOKEN_marketing_vt` | Notion internal integration token for marketing-vt |
| `NOTION_TOKEN_gifted` | Notion internal integration token for gifted |
| `SUPABASE_URL` | `https://lffcbeszjqzioobqfdav.supabase.co` |
| `SUPABASE_SERVICE_KEY` | Supabase **service-role** key (server-side only) |
| `R2_ACCOUNT_ID` | `2f63643b89b055e52141605ed9fdd06d` |
| `R2_BUCKET` | `smilescape-media` |
| `CF_ZONE_ID` | zone id for `smilescapeclinic.com` |
| `CF_API_TOKEN` | Cloudflare token w/ Cache Purge (zone) |

> No n8n Variables on your plan? → **option 3:** put the same key/values in a small Supabase `seo_notion_sources` config table and read it in the CONFIG node instead. Or fall back to a Switch → 2 credential nodes. The rest of the workflow is identical.

### 2. n8n Credentials
- **S3 (R2):** create an "S3" credential — endpoint `https://<R2_ACCOUNT_ID>.r2.cloudflarestorage.com`, region `auto`, access key id + secret from R2 → *Manage R2 API Tokens*. (Used by the S3 nodes; R2 is S3-compatible.)
- (Notion, Supabase, Cloudflare all go through HTTP Request + Variables above — no extra credentials needed.)

### 3. Cloudflare prerequisites (operator dashboard)
- Enable R2, create bucket `smilescape-media`, bind `cdn.smilescapeclinic.com`, enable Image Transformations. (Blocker — see main spec §2.)

### 4. Supabase
- Apply `../sql/seo_media_assets.draft.sql` (route via Session B). The workflows write to `public.seo_media_assets` via PostgREST.

---

## WF1 — `wf1-media-sync.json` (Notion → R2 → Supabase)

Trigger: Schedule (every 5 min). Per account → query Pending rows → per row: validate → download → R2 upload → Supabase upsert → Notion writeback.

| # | Node | What it does | Key config / expression |
|---|---|---|---|
| 1 | Schedule Trigger | every 5 min | interval: minutes=5 |
| 2 | Code — CONFIG | list accounts (1 item per account) | returns `[{workspace,dataSourceId}]` |
| 3 | HTTP — Query Notion | POST data_sources/{id}/query, Status=Pending | `Bearer {{ $vars['NOTION_TOKEN_'+$json.workspace] }}`, `Notion-Version: 2025-09-03` |
| 4 | Code — Explode rows | one item per Notion page, carry `workspace`,`notion_page_id`,props | maps `results[]` |
| 5 | IF — valid? | alt_th & alt_en present; if patient → consent ok | else → No-Op (stays Pending) |
| 6 | HTTP — Download image | GET the Notion file url → binary | response: file |
| 7 | S3 — Upload to R2 | putObject bucket=`{{ $vars.R2_BUCKET }}` key=`{{ $json.r2_key }}` | r2_key namespaced by workspace/brand (gotcha #1) |
| 8 | HTTP — Upsert Supabase | POST rest/v1/seo_media_assets?on_conflict=notion_id | `Prefer: resolution=merge-duplicates`; stamps `notion_workspace`,`notion_id`,`cdn_url`,`r2_key` |
| 9 | HTTP — Writeback Notion | PATCH pages/{notion_page_id}: CDN URL, R2 Key, Supabase ID, Status=Active, Synced at | token by `workspace` |

**r2_key convention (gotcha #1):** `{{ $json.workspace_brand }}/{{mediaType}}/{{slug}}.webp` — must include brand/workspace so the two accounts never collide on the unique `r2_key`.
**upsert key (gotcha #2):** `notion_id` (Notion page UUID, globally unique).

---

## WF2 — `wf2-media-expiry-sweep.json` (daily consent enforcement, L2)

Trigger: Schedule (daily 00:05 ICT). Supabase-driven → mostly account-agnostic; only the Notion writeback routes by the stored `notion_workspace`.

| # | Node | What it does | Key config |
|---|---|---|---|
| 1 | Schedule Trigger | daily 00:05 | triggerAtHour=0, minute=5 |
| 2 | HTTP — Query expiring | GET seo_media_assets where patient & active & (expired OR consent revoked) | PostgREST `or=(...)`, today=`{{ $now.toFormat('yyyy-MM-dd') }}` |
| 3 | S3 — Copy → _quarantine/ | copyObject key → `_quarantine/<key>` | preserves binary for grace window |
| 4 | S3 — Delete original | deleteObject key → live URL 404 | **the legal backstop** |
| 5 | HTTP — Purge CF cache | POST zones/{zone}/purge_cache `{files:[cdn_url]}` | stops edge serving cached copy |
| 6 | HTTP — Update Supabase | PATCH status=expired, expired_at=now | |
| 7 | HTTP — Writeback Notion | PATCH page Status=Expired | token by `notion_workspace` (per row) |
| 8 | (optional) Notify | LINE/email list of removed images | |

> **Why L2 is safe even before CI rebuild:** steps 3–5 make the patient image unreachable the moment the sweep runs — independent of the static site build. A nightly rebuild (separate) just cleans the now-broken `<img>` reference from HTML.

---

## ⚠️ Validation caveat
These JSONs are **scaffolds authored without n8n-mcp validation**. On import, expect to: confirm node `typeVersion`s, re-select the S3 credential, and sanity-check HTTP body shapes against your n8n version. The **topology + expressions + endpoints are the durable value** — node param drift is a quick fix in the editor.
