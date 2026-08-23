# Media Pipeline — Setup Checklist (do these, then I deploy/test the n8n workflows)

Account context: Cloudflare `naphannop.n@gmail.com` (account id `2f63643b89b055e52141605ed9fdd06d`) · Supabase project **GTGT** `lffcbeszjqzioobqfdav` · n8n `nexorcus.app.n8n.cloud` · zone `smilescapeclinic.com`.

> **Legend:** 🔴 blocker for WF1 (sync) · 🟠 blocker for WF2 (expiry sweep) · 🟢 nice-to-have / later (gifted).
> ⚠️ Secrets (service keys, API tokens) → paste into **n8n Variables/Credentials only**, never into the repo or chat.

---

## A) Cloudflare — R2 + delivery

- [ ] **A1 🔴 Enable R2.** dash.cloudflare.com → **R2** → *Enable / Purchase R2* (accept terms; a card may be required even on the free tier — usage at clinic scale ≈ $0).
- [ ] **A2 🔴 Create bucket.** R2 → *Create bucket* → name **`smilescape-media`** → location **APAC** (closest to TH). *(Or just do A1, tell me, and I'll create it via wrangler.)*
- [ ] **A3 🔴 Bind CDN domain.** R2 → `smilescape-media` → **Settings → Public access → Custom Domains → Connect Domain** → `cdn.smilescapeclinic.com`. DNS is on Cloudflare → record + cert auto-provision.
- [ ] **A4 🔴 Enable Image Transformations.** dash → **smilescapeclinic.com** zone → **Images → Transformations** (or Speed → Optimization) → enable *Resize images / Transform via URL* for the zone. (Lets `/cdn-cgi/image/...` resize on the fly.)
- [ ] **A5 🔴 R2 S3 API token.** R2 → **Manage R2 API Tokens → Create API Token** → permission **Object Read & Write**, scoped to bucket `smilescape-media`. Copy: **Access Key ID**, **Secret Access Key**, and the **S3 endpoint** `https://2f63643b89b055e52141605ed9fdd06d.r2.cloudflarestorage.com`.
- [ ] **A6 🟠 Cache-purge API token.** dash → **My Profile → API Tokens → Create Token → Custom** → permission **Zone : Cache Purge : Purge**, zone resource = `smilescapeclinic.com`. Copy the token. *(WF2 purges the cached patient image on expiry.)*
- [ ] **A7 🟠 Zone ID.** dash → `smilescapeclinic.com` → **Overview** → right sidebar → copy **Zone ID**.

## B) Notion — integration token (marketing-vt now, gifted later)

- [ ] **B1 🔴 Get/confirm an internal integration token for marketing-vt.** notion.so/profile/integrations → create (or reuse) an **internal integration** (e.g. "SmileScape Media — n8n") in the marketing-vt workspace → copy its **Internal Integration Secret**.
- [ ] **B2 🔴 Share the Media Library DB with that integration.** Open the **Media Library** DB → ••• → **Connections → Add** → your integration. (Sync reads rows + patches the same pages — DB access is enough.)
- [ ] **B3 🟢 Gifted — later.** After the gifted Media Library exists (needs: share a page with `GIFTED X CLAUDE` + connect the official Notion MCP to gifted so I can build the DB): repeat B1–B2 in gifted, then set `NOTION_TOKEN_gifted` + the gifted `dataSourceId` in WF1 CONFIG.

## C) Supabase — keys + table

- [ ] **C1 🔴 Service key.** Supabase → project **GTGT** → **Settings → API → `service_role` secret** → copy. (Server-side only.)
- [ ] **C2 🔴 URL** = `https://lffcbeszjqzioobqfdav.supabase.co` (already known).
- [ ] **C3 🔴 Apply `seo_media_assets`.** Route `docs/sql/seo_media_assets.draft.sql` through **Session B** (confirm brands FK + DR/Spec numbers). Workflows write to `public.seo_media_assets` via PostgREST.

## D) n8n — variables + credential

- [ ] **D1 🔴 Create Variables** (Settings → **Variables**). *No Variables on your plan? tell me — we switch to the Supabase-config or env-var variant.*

  | Variable | Value / source |
  |---|---|
  | `NOTION_TOKEN_marketing_vt` | B1 secret |
  | `SUPABASE_URL` | `https://lffcbeszjqzioobqfdav.supabase.co` |
  | `SUPABASE_SERVICE_KEY` | C1 secret |
  | `R2_BUCKET` | `smilescape-media` |
  | `R2_ACCOUNT_ID` | `2f63643b89b055e52141605ed9fdd06d` |
  | `CF_ZONE_ID` | A7 |
  | `CF_API_TOKEN` | A6 token |
  | `NOTION_TOKEN_gifted` | (later, B3) |

- [ ] **D2 🔴 Create an S3 credential** (for the R2 nodes): Access Key ID + Secret = A5, **Region** `auto`, **Endpoint** = A5 endpoint, **Force Path Style** = ON.

## E) Deploy + test (my part)

- [ ] **E1** You: reconnect the **`n8n-mcp`** MCP server (then say "ต่อแล้ว") **OR** create an **n8n API key** (Settings → n8n API) and send it.
- [ ] **E2** Me: deploy `wf1-media-sync.json` + `wf2-media-expiry-sweep.json` (wire the S3 credential, confirm Variable names).
- [ ] **E3** Me + you: add 1 real test image row in Notion (Status=Pending) → run WF1 manually → verify it lands in R2 + `seo_media_assets` + the row flips to Active with a CDN URL. Then test WF2 with a back-dated `Use until`.

---

### ✅ Minimum to fire WF1 (marketing-vt) right now
A1–A5 · B1–B2 · C1–C3 · D1 (skip `CF_*`/gifted) · D2 · E1.
**WF2** additionally needs A6, A7. **gifted** needs B3 (after its DB is built).
