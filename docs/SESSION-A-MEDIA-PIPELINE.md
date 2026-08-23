# SmileScape — Session A: Media / DAM Pipeline Spec

**Date:** 2026-06-07
**Status:** Draft for review (architecture locked with operator; build pending infra enablement)
**Owners:** Session A (media/storage) — feeds Session B (Supabase schema + data load)
**Decision records:** Implements **DR-035** (binaries on Cloudflare, Supabase stores URL only). Adds **SS-DR-015** (media/DAM pipeline) + **SS-DR-016** (patient-image consent lifecycle & auto-expiry).

---

## 0) TL;DR

- **Source of truth for humans = Notion** (Media Library DB). The team (operator + content team) adds images + metadata there.
- **Automation glue = n8n** (already in stack). Two flows: (A) sync Notion → R2 + Supabase; (B) daily consent-expiry sweep.
- **Binary storage + delivery = Cloudflare R2** behind `cdn.smilescapeclinic.com`, transformed on-the-fly via Image Transformations (`/cdn-cgi/image/...`).
- **App source of truth = Supabase `media_assets`** (structured record, not bare URL). Astro reads the `servable_media` view at build.
- **Patient images get a consent lifecycle.** Each row can be flagged `is_patient_image`; if so it requires consent fields + either "use forever" or an expiry date. When consent lapses, the **daily sweep quarantines the R2 object (URL → 404) + purges edge cache + rebuilds** — the image disappears from the site with no human in the loop. This is the legal-safety backstop (PDPA).

**Scope note:** This pipeline is for the **production site (722 pages)**. The current MVP Google-Ads landing page (`go.smilescapeclinic.com/lp/dental-implant/`) keeps its committed assets as-is — it is **out of scope** and will not be migrated.

---

## 1) Architecture

```
  ┌─────────────────────────────┐
  │ Notion — "Media Library" DB │   ← humans manage here (operator + content team)
  │  image + alt TH/EN + entity │
  │  + patient/consent fields   │
  └──────────────┬──────────────┘
                 │  (status = Pending / changed)
                 ▼
  ┌─────────────────────────────┐        Flow A (sync)
  │ n8n                         │  ① download binary from Notion
  │                             │  ② validate (alt, consent rules)
  │                             │  ③ upload → R2 (stable key)
  │                             │  ④ upsert → Supabase media_assets
  │                             │  ⑤ write back CDN URL + Supabase id → Notion
  │                             │  ⑥ trigger rebuild (debounced)
  └──────┬───────────────┬──────┘
         │               │
         ▼               ▼
  ┌─────────────┐  ┌──────────────────────────┐
  │ Cloudflare  │  │ Supabase media_assets      │  ← app source of truth
  │ R2 bucket   │  │  + view: servable_media    │
  │ smilescape- │  └─────────────┬──────────────┘
  │ media       │                │ (build-time query, expired excluded)
  │             │                ▼
  │ cdn.smile.. │◄──────  Astro build → HTML → Workers (go. / apex)
  └─────────────┘   /cdn-cgi/image/ transforms (webp/avif, responsive)

  ┌─────────────────────────────┐        Flow B (daily 00:05 ICT)
  │ n8n expiry sweep            │  for each patient image past expiry / revoked:
  │                             │   • copy R2 obj → _quarantine/, delete original (URL→404)
  │                             │   • purge Cloudflare cache for the URL
  │                             │   • Supabase status=expired, expired_at=now
  │                             │   • Notion status=Expired
  │                             │  then: rebuild (cosmetic HTML cleanup) + notify team
  └─────────────────────────────┘
```

**Why route through n8n + R2 instead of using Notion file URLs directly:** Notion file URLs are temporary S3 links (expire ~1 hour) and cannot be served on a production site. The binary must be copied to R2 to get a permanent URL.

---

## 2) Infra layer — Cloudflare R2 + delivery

| Item | Value |
|---|---|
| Bucket | `smilescape-media` (single bucket, organised by prefix) |
| Public domain | `cdn.smilescapeclinic.com` (R2 custom domain — DNS already on Cloudflare → auto cert) |
| Transforms | Image Transformations enabled on the zone → `/cdn-cgi/image/width=…,format=auto,quality=…/…` |
| Originals | Always stored; transforms are derived at delivery (do not pre-resize) |
| Account | `naphannop.n@gmail.com` · account id `2f63643b89b055e52141605ed9fdd06d` |

### One-time setup (needs operator dashboard action — ⚠️ blockers)
1. **Enable R2** in the Cloudflare dashboard (accept terms). *(Currently error 10042 "enable R2" — wrangler can't create buckets until this is done.)*
2. `npx wrangler r2 bucket create smilescape-media`
3. R2 → bucket → Settings → **Public access → Connect custom domain** → `cdn.smilescapeclinic.com`
4. Speed → Optimization → **Image Transformations** → enable "Resize images from this zone"
5. R2 → **Manage R2 API Tokens** → create an S3 token (Object Read & Write) for n8n
6. Create a scoped **Cloudflare API token** for cache purge (Zone → Cache Purge) for n8n

---

## 3) Taxonomy & naming convention

Prefix by **entity type** (matches the 166-entity model). Human-readable, lowercase, kebab-case, ASCII — never rename after publish (URLs are referenced in Supabase + cached).

```
smilescape-media/
├── doctors/{doctor-slug}/{slug}.{ext}            # dr-haam.webp, dr-praew.webp
├── branches/{branch-slug}/{slug}.{ext}           # branch-01-exterior.webp
├── brands/{brand-slug}/{slug}.{ext}              # blue-diamond-logo.webp, megagen.webp
├── treatments/{treatment-slug}/{slug}.{ext}      # all-on-4/hero.webp
├── procedures/{procedure-slug}/{slug}.{ext}
├── conditions/{condition-slug}/{slug}.{ext}
├── tech/{equipment-slug}/{slug}.{ext}            # cbct-scanner.webp
├── cases/{treatment-slug}/case-{NNNN}-{state}.{ext}   # ⚠ PATIENT IMAGES
│                                                  # case-0007-before.webp / -after / -during
├── clinic/{slug}.{ext}                            # general / marketing
├── brand-assets/{slug}.{ext}                      # logos, og images, favicons
└── _quarantine/...                                # expired patient images (auto-moved)
```

**Rules**
- `media_type` in the DB mirrors the top-level prefix.
- Cases use zero-padded sequence + state suffix (`before` / `after` / `during` / `xray`).
- Immutability: if an image's pixels change, upload a **new key** (`…-v2.webp`) rather than overwriting — Cloudflare caches aggressively and patient images must be auditable.
- Example delivery URL:
  `https://cdn.smilescapeclinic.com/cdn-cgi/image/width=800,format=auto,quality=80/cases/dental-implant/case-0007-before.webp`

---

## 4) Data model — Supabase `media_assets`

This is the **contract** Session B adopts. Bare URL columns on entity/page rows are *not* used; everything points at this table.

```sql
-- enums via check constraints (flexible; promote to pg enums later if desired)
create table media_assets (
  id                uuid primary key default gen_random_uuid(),

  -- storage / delivery
  r2_key            text not null unique,         -- cases/dental-implant/case-0007-before.webp
  cdn_url           text not null,                -- https://cdn.smilescapeclinic.com/<r2_key>

  -- descriptive / SEO (bilingual mandatory)
  title             text,
  alt_th            text not null,
  alt_en            text not null,
  caption_th        text,
  caption_en        text,

  -- classification
  media_type        text not null
                      check (media_type in
                        ('doctor','branch','brand','treatment','procedure',
                         'condition','tech','case','clinic','brand_asset','other')),
  mime_type         text not null,                -- image/webp, image/jpeg, video/mp4
  width             int,
  height            int,
  file_size_bytes   bigint,

  -- relations  (entity_id = entities slug; FK added in Session B once entities table exists)
  entity_id         text,

  -- publish lifecycle
  status            text not null default 'pending'
                      check (status in ('pending','active','expired','revoked','archived')),

  -- ── patient / consent block (SS-DR-016) ──────────────────────────────
  is_patient_image  boolean not null default false,
  consent_status    text check (consent_status in ('obtained','pending','revoked')),
  consent_doc_url   text,                          -- signed consent form (R2 private / Box)
  consent_obtained_at date,
  usage_perpetual   boolean,                       -- true = ใช้ได้ตลอดไป ; false = มีวันหมดอายุ
  usage_expires_at  date,                          -- required when usage_perpetual = false
  patient_ref       text,                          -- pseudonymised ref (NEVER patient name/PII)

  -- provenance / audit
  source            text,                          -- 'notion' | 'batch-upload' | 'wp-migration'
  credit            text,
  notion_page_id    text unique,
  created_at        timestamptz not null default now(),
  updated_at        timestamptz not null default now(),
  expired_at        timestamptz,                   -- set by the sweep when removed

  -- integrity guards: a patient image can't go live without consent + a usage rule
  constraint patient_consent_required check (
    not is_patient_image
    or (consent_status is not null and usage_perpetual is not null)
  ),
  constraint patient_expiry_required check (
    not is_patient_image
    or usage_perpetual is true
    or usage_expires_at is not null
  )
);

create index media_assets_entity_idx       on media_assets (entity_id);
create index media_assets_type_idx         on media_assets (media_type);
create index media_assets_status_idx       on media_assets (status);
create index media_assets_expiry_idx       on media_assets (usage_expires_at)
                                            where is_patient_image and not usage_perpetual;

-- auto-update updated_at
create or replace function set_updated_at() returns trigger as $$
begin new.updated_at = now(); return new; end $$ language plpgsql;
create trigger media_assets_updated_at before update on media_assets
  for each row execute function set_updated_at();
```

### The serving gate (build-time belt)

Astro queries **only** this view — expired/unconsented patient images can never be selected, even between sweeps.

```sql
create view servable_media as
select *
from media_assets
where status = 'active'
  and (
    not is_patient_image
    or (
      consent_status = 'obtained'
      and (usage_perpetual is true or usage_expires_at >= current_date)
    )
  );
```

### Field dictionary (the ones that need explaining)

| Field | Meaning |
|---|---|
| `is_patient_image` | The toggle. `true` → the consent block is enforced by DB constraints. |
| `consent_status` | `obtained` is the only value that lets a patient image be served. |
| `consent_doc_url` | Link to the signed consent document (stored privately, not on the CDN). |
| `usage_perpetual` | `true` = licensed forever. `false` = time-limited → `usage_expires_at` required. |
| `usage_expires_at` | Last date the patient image may appear. The sweep removes it after this date. |
| `patient_ref` | A pseudonymised id only — never store the patient's name here (PDPA data-minimisation). |
| `status` | `revoked` (consent withdrawn) is also caught by the sweep, same as expiry. |

---

## 5) Notion — "SmileScape · Media Library" DB

Human management surface. Properties map 1:1 to `media_assets`.

| Notion property | Type | → `media_assets` |
|---|---|---|
| Name | Title | `title` |
| Image | Files & media | (binary → uploaded to R2 by n8n) |
| Alt (TH) | Text | `alt_th` *(required)* |
| Alt (EN) | Text | `alt_en` *(required)* |
| Caption TH / EN | Text | `caption_th` / `caption_en` |
| Media Type | Select | `media_type` |
| Entity | Relation → Entities DB (or Text slug) | `entity_id` |
| Status | Select: Pending · Active · Expired · Revoked · Archived | `status` |
| Patient image? | Checkbox | `is_patient_image` |
| Consent status | Select: Obtained · Pending · Revoked | `consent_status` |
| Consent doc | Files / URL | `consent_doc_url` |
| Consent date | Date | `consent_obtained_at` |
| Use forever? | Checkbox | `usage_perpetual` |
| Use until | Date | `usage_expires_at` |
| Patient ref | Text | `patient_ref` |
| CDN URL | URL *(written by n8n)* | `cdn_url` |
| R2 Key | Text *(written by n8n)* | `r2_key` |
| Supabase ID | Text *(written by n8n)* | `id` |
| Synced at | Date *(written by n8n)* | — |

### Notion guardrails (formulas — Notion can't enforce conditional-required, so we surface it)

- **`⚠ Consent check`** (formula): if `Patient image?` and (`Consent status` ≠ "Obtained" or (`Use forever?` is false and `Use until` is empty)) → `"❌ incomplete"` else `"✅"`. n8n refuses to set Status = Active when this is `❌`.
- **`Days left`** (formula): `dateBetween(prop("Use until"), now(), "days")` → countdown for non-perpetual patient images.

### Recommended views
- **To sync** — `Status = Pending`
- **Live patient images** — `Patient image? = true AND Status = Active`
- **Expiring ≤ 30 days** — `Days left ≤ 30 AND Status = Active` (renew consent before auto-removal)
- **Quarantined / Expired** — `Status in (Expired, Revoked)`

---

## 6) n8n flows

> **Built (scaffolds):** [`docs/n8n/`](n8n/) — `wf1-media-sync.json`, `wf2-media-expiry-sweep.json`, `README.md` (setup + node-by-node). Import & verify against your n8n version (n8n-mcp was unavailable to auto-validate).
>
> **Multi-account design (1 Supabase ← N Notion accounts):** workflows are **account-agnostic, single instances** — NOT split per account. Account routing is data-driven: the `notion_workspace` column + a CONFIG list, with the Notion token chosen by expression `Bearer {{ $vars['NOTION_TOKEN_'+workspace] }}` (HTTP Request, not the native Notion node). Adding account #3 = 1 CONFIG row + 1 variable, no logic change. Gotchas: `r2_key` must be namespaced by workspace/brand (unique-collision); upsert key = `notion_id`.

### Flow A — Sync (Notion → R2 → Supabase)
**Trigger:** Notion change / poll every ~5 min for rows where `Status = Pending` or updated since last run, *or* a manual "Sync" button.
1. Validate: `Alt (TH)`, `Alt (EN)` present; if `Patient image?` → `⚠ Consent check` must be `✅`. Invalid → leave `Status = Pending`, set a flag, notify, skip.
2. Download the binary from the Notion file URL.
3. Probe `mime`, `width`, `height`, `file_size`.
4. Compute the R2 key from `Media Type` + `Entity` + slug (Section 3). If the key exists with identical bytes → skip upload.
5. `PUT` to R2 (S3 API).
6. `upsert` into `media_assets` keyed on `notion_page_id`.
7. Write back to Notion: `CDN URL`, `R2 Key`, `Supabase ID`, `Synced at`, `Status = Active`.
8. Trigger a rebuild (debounced/batched — see §7).

### Flow B — Daily consent-expiry sweep (schedule 00:05 ICT) — **the legal-safety mechanism**
1. Query Supabase:
   ```sql
   select * from media_assets
   where is_patient_image
     and status = 'active'
     and ( (usage_perpetual = false and usage_expires_at < current_date)
           or consent_status = 'revoked' );
   ```
2. For each row:
   - **R2:** copy object → `_quarantine/<original-key>`, then delete the original key → live URL returns **404 immediately**.
   - **Cache:** purge Cloudflare cache for `cdn_url` (so the edge stops serving the cached copy).
   - **Supabase:** `status = 'expired'` (or `'revoked'`), `expired_at = now()`.
   - **Notion:** `Status = Expired`.
3. If anything changed → trigger a rebuild (removes the now-broken `<img>` references from HTML — cosmetic).
4. Notify the team (LINE / email / Notion) with the list of removed images.

> **Key property:** the R2 quarantine + cache purge in step 2 is what satisfies PDPA — the patient's image becomes unreachable the moment the sweep runs, regardless of HTML build state, caches, or bookmarks. The rebuild (step 3) is only cosmetic cleanup and may even be deferred to the nightly build.

### Flow C — Expiry warning (optional, weekly) 
Query patient images with `Days left ≤ 30` → notify the team so consent can be renewed before auto-removal (avoids surprise takedowns).

### Retention
A separate monthly job hard-deletes objects under `_quarantine/` older than **30 days** (grace window in case consent is renewed). Audit row stays in Supabase.

---

## 7) Rebuild trigger (gap to close)

Today the site deploys **manually** (`npm run build && wrangler deploy` from local). Data-driven auto-rebuild needs a CI path:
- **Recommended:** GitHub Actions deploy workflow with triggers: `push`, nightly `schedule`, and `workflow_dispatch`. n8n calls the GitHub API (`workflow_dispatch`) after sync / expiry. The nightly `schedule` is the safety net.
- Because **R2 quarantine already makes expired patient images unreachable**, the rebuild is *not* on the legal-critical path — it can lag to the nightly build without risk. CI can be set up after the core pipeline lands.

---

## 8) Astro consumption

- Build-time: fetch `servable_media` from Supabase (service/anon read key).
- Render: pick `alt_th` / `alt_en` by locale; emit `width`/`height` for CLS; lazy-load below the fold, eager + `fetchpriority=high` for the LCP hero.
- Responsive helper builds `srcset` via Image Transformations:
  ```
  /cdn-cgi/image/width=400,format=auto,quality=80/<r2_key>   400w
  /cdn-cgi/image/width=768,format=auto,quality=80/<r2_key>   768w
  /cdn-cgi/image/width=1024,format=auto,quality=80/<r2_key> 1024w
  /cdn-cgi/image/width=1600,format=auto,quality=80/<r2_key> 1600w
  ```
- Defensive: if a referenced asset 404s (quarantined between build and request), render a neutral placeholder — never a broken patient image.

---

## 9) Image standards
- Store originals; serve `format=auto` (webp/avif negotiated), `quality≈80`.
- `alt_th` + `alt_en` mandatory (DB `not null`) — bilingual site.
- `width`/`height` always recorded → CLS-safe markup.
- `ImageObject` schema for hero / case images where useful.
- Patient images: consent-gated (SS-DR-016); never indexed without consent; filenames carry no patient identity.

---

## 10) Secrets / env needed (for n8n + CI)
- R2 S3 token (access key id + secret)
- Supabase URL + service role key
- Notion integration token + Media Library DB id
- Cloudflare API token (cache purge, zone-scoped)
- GitHub PAT / App token for `workflow_dispatch` (when CI is set up)

---

## 11) Build order (checklist)
- [ ] **Operator:** enable R2 + Image Transformations (dashboard) — *blocker*
- [ ] Create bucket `smilescape-media` + bind `cdn.smilescapeclinic.com`
- [ ] Create `media_assets` table + `servable_media` view in Supabase (coordinate with Session B)
- [ ] Create the Notion "Media Library" DB (properties + formulas + views) — *can be done via Notion API now*
- [ ] Build n8n Flow A (sync) + Flow B (expiry sweep)
- [ ] Wire Astro data layer to `servable_media` + the srcset helper
- [ ] Set up CI deploy + `workflow_dispatch` for auto-rebuild (after core pipeline)
- [ ] Backfill: load production images through Notion (NOT the MVP LP assets)

---

## 12) Open questions for the operator
1. **Entity link in Notion** — relation to a real Entities DB, or a plain slug text field for now? (depends on whether the Entities DB lands in Notion first)
2. **Consent docs storage** — keep signed forms in R2 (private prefix), Box, or the existing clinic system? `consent_doc_url` just needs a stable link.
3. **Notion DB location** — which workspace/teamspace + which Notion connection (`notion-gifted` vs `notion-marketing-vt`)?
4. **Default consent window** — when "Use forever?" is unchecked, is there a standard default (e.g., 2 years) we pre-fill?

---

## 13) Build status / live IDs (updated 2026-06-07)

### ✅ notion-marketing-vt — "Media Library" DB created
Multi-brand version, under **Knowledge Graph → SUPER DATABASE**. Created via the official Notion connector (SQL DDL); the raw-API `create-a-data-source` wrapper returns `invalid_request_url` and cannot create databases.

| | value |
|---|---|
| Database id | `656514e1-274f-4ea5-8aab-576d66858a27` |
| Data source | `collection://20e248f7-4b65-44eb-bfd4-90dac48a79d7` |
| Parent page | Knowledge Graph `35fdc4e2-1689-80d2-856b-e888d5c7ae2c` |
| Properties | 27 (25 fields + 2 formulas) |
| `Brand` relation → | [DB 1.1] Brand Database `2a3dc4e2-1689-80d1-bb2f-000bd19abc4d` |
| `Entity` relation → | Entity Graph `434d8053-62be-4ff1-8d42-f503f2e07741` |
| Formulas | `Consent Check` (✅ ok / ❌ incomplete / —), `Days Left` (countdown string) |
| Views | `To sync` (Status=Pending) · `Live patient images` (gallery, Patient=✓ & Active, cover=Image) · `Expiring (soonest first)` (Patient=✓ & Active & not-perpetual, sort Use until ASC) · `Quarantined / Expired` (Status=Expired OR Revoked) |
| Template rows | 2 `[TEMPLATE]` rows — a non-patient asset (Consent Check "—") and a patient case with time-limited consent (Consent Check "✅ ok" + Days Left). Use as the pattern to copy to gifted; delete before go-live. |

> The "Expiring ≤30 days" view should filter on the **`Use until`** date property (on-or-before today+30 + Patient image? = true), since `Days Left` is a display string, not a number.

### ⛔ notion-gifted ("The Gifted Synapse") — blocked
SmileScape's real account. Cannot build yet:
1. The integration (`GIFTED X CLAUDE`) has **no shared pages** — workspace search returns empty. → share a parent page (e.g. a Knowledge Graph / home page) with the bot.
2. **No Entity Graph / Brand Database** present (or shared) to relate to. → either create those DBs in gifted first, or build Media Library there with `Entity`/`Brand` as plain text initially.
3. The gifted **raw-API create endpoint is broken** (same `invalid_request_url`); there is no official SQL-DDL connector bound to this account. → connect the official Notion MCP to the gifted workspace to enable DB creation.

**To replicate on gifted:** unblock 1–3 above, then run the same DDL recipe (Section 4/5) with gifted's own Entity Graph / Brand Database data-source ids.

### 🔁 Supabase reconciliation — the §4 `media_assets` schema is superseded
The live Supabase project **"GTGT"** (`lffcbeszjqzioobqfdav`) is a mature **Spec v1.22** SEO schema (~40 `seo_*` tables, Session B). The standalone `media_assets` table in §4 must be re-cast to that schema's conventions:

| §4 (generic spec) | Reality in GTGT |
|---|---|
| `media_assets` | **`seo_media_assets`** (`seo_` prefix) |
| `entity_id → entities` | `entity_id → seo_entity_graph(id)` + FKs to `brands`, `seo_branches`, `seo_authors_reviewers`, `seo_website_page_master` |
| (no identity cols) | **DR-008** `fingerprint` + `fingerprint_display_name` + `media_slug` + `notion_id`/`notion_database_id`/`notion_workspace`/`notion_synced_at` |
| (no RLS) | RLS on + policy `eywa_authenticated_full_access` (ALL/authenticated/true) |
| view `servable_media` | `seo_servable_media` |
| — | audit row in `seo_schema_changes` (DR-037 + spec v1.23, **proposed**) |

➡️ **Conventions-compliant draft:** [`docs/sql/seo_media_assets.draft.sql`](sql/seo_media_assets.draft.sql) — **review-only, NOT applied.** Route the apply through Session B (validate brands FK + assign real DR/Spec numbers + Group/Tier).

⚠️ **Pre-existing security advisory (GTGT):** RLS is disabled on `seo_brand_centers`, `_archive_legacy_entity_graph_20260607`, `_archive_legacy_pages_20260607` — anon key can read/write all rows. Not from this work; surfaced for the operator/Session B to remediate (enable RLS + policies, or drop the two archive tables).
