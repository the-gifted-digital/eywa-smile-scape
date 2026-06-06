# SmileScape → Supabase Stage-1.5 Flat-Load — Design Spec

> **Date:** 2026-06-07 · **Author:** operator + Claude (brainstorming session) · **Status:** approved, pre-implementation
> **Session B** of the 2026-06-07 handover (`docs/HANDOVER-2026-06-07.md`).
> **Supersedes** the handover's stale "write migrations for ~41 tables" framing — the schema already exists (see §1).

---

## 1. Context — verified live state (not assumed)

- **Target DB:** Supabase project **GTGT** `lffcbeszjqzioobqfdav` (org `Gifted` `hzjgoqcnsfqhwgkxgqsx`), Postgres 17, region ap-northeast-1. Reached via Supabase MCP (`5814a0fb-…`).
- **Schema is already built & live** — 39 EYWA tables / 9 groups, **Schema v1.21**, all RLS-enabled (`eywa_authenticated_full_access`). Migrations manifest: `repos/eywa-protocol-spec/migrations/README.md`. **We do NOT create or alter schema.**
- **Shared multi-brand DB** — 16 brands already registered. Other brands hold data (Deezy Dental + VitalSleep have pages; the entity graph holds 722 rows across brands incl. universal `['*']` entities).
- **SmileScape brand row exists, content = 0:** `brands` row `Smile Scape Clinic` — `id = c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25`, `brand_slug = smile-scape-clinic`, `fingerprint = brnd_8314A55613F44453`, `status = active`. Verified **0** rows for SmileScape in `seo_entity_graph` / `seo_website_page_master` / `seo_branches` / `seo_topic_cluster_master`. → clean **fresh load** for this brand.
- **Reference implementation:** Deezy Dental was flat-loaded via the same DB on 2026-06-07. Pattern + conventions live in `repos/brands/eywa-deezy/deployment/supabase-load/` (`RUN-ORDER.md`, `LOAD-LOG.md`, `gen_*.py`, `NN_*.sql`). **This load mirrors Deezy.**

## 2. Goal / non-goals

**Goal.** Load SmileScape's Stage-1 planning data (`content-plan/*.md`) into the live EYWA tables, scoped to brand `smile-scape-clinic`, using the proven Deezy "Path A" method.

**Non-goals (this session).** No schema DDL. No content-body authoring (Phase F). No keyword metric enrichment (→ DataForSEO). No Notion sync (→ n8n). No image binaries (→ Cloudflare / Session A; Supabase stores URLs only per DR-035). No touching other brands' rows.

## 3. Method (decided) — Path A, Deezy-style

1. **Parse** each `content-plan/*.md` with a small deterministic Python parser → emits a numbered `.sql` file (parser prints parse-stats: counts, dupes, skips).
2. **Commit** the generated `.sql` to `deployment/supabase-load/`.
3. **Run** each file in order via **Supabase Dashboard → SQL Editor** (operator copy-pastes, clicks Run). Each file ends with a `returning …` / validation `SELECT`.
4. **Validate** — operator says "ran NN done" → Claude runs count/FK/orphan/isolation checks via MCP and confirms ✅ before the next file.
5. **Strict numbered order** (FK + reference dependencies). No skipping ahead.

Rationale: proven on Deezy the same day; low token cost (SQL body never re-streamed through chat); committed `.sql` is auditable & re-runnable; SQL Editor handles the big files (`06_pages`, `10_keywords`) that are too heavy to apply inline via MCP.

## 4. Scope (decided) — Deezy-parity flat-load

### 4.1 In scope (load this session)

| # (file) | Source | Target table | Rows (planned) | Brand scope |
|---|---|---|---|---|
| `00_clusters` | `clusters.md` | `seo_topic_cluster_master` | **20** | `['*']` univ. / `['smile-scape-clinic']` for `brand-doctor-authority` |
| `01_entities` | `entities.md` | `seo_entity_graph` | **163 authored → MERGE** (insert net-new only; see §6) | mostly `['*']`, brand-specific `['smile-scape-clinic']` |
| `02_entity_extensions` | (from graph) | `seo_entity_condition` / `seo_entity_symptom` / `seo_entity_anatomy` / `seo_entity_procedures` / `seo_entity_drug` | ~**82** (`INSERT..SELECT` by lowercase `entity_type`: condition 27 + procedure 49 + anatomy 6 + symptom/drug if any) | — |
| `03_citations` | `citation-pool-seed.md` | `seo_citations` | ~**50** (dedup on pmid/doi) | `['*']` (shared academic pool) |
| `04_authors` | `docs/team/*.md` + `entities.md` persons | `seo_authors_reviewers` + `seo_doctor_assignments` | **2** doctors (หมอแฮม + หมอแพรว) + assignments | brand |
| `05_branches` | `branches.md` | `seo_branches` | **2** (PARTIAL — see §6) | brand |
| `06_pages` | `sitemap.md` | `seo_website_page_master` | ~**726** (minimal STUB) | brand |
| `10_keywords` | `keyword-seed-list.md` | `seo_x_ads_keywords_contextual_master` | N (SEED only → hand to DFS) | brand |

### 4.2 Deferred (out of scope — same deferrals as Deezy)

| Item | Blocked / waiting on |
|---|---|
| `seo_entity_relationships` (~101 edges) | ⚠️ edge-vocab mismatch (`parent_of/subtype_of/uses/alternative_to/requires_assessment/evidenced_by` vs DR-013 live CHECK `child_of/part_of/related_to/treats/treated_by/causes/caused_by/contraindicates/symptom_of/diagnoses/prevents/risk_factor_for`) **+** `trg_validate_edge_evidence` requires per-edge `edge_evidence_citation` (and `medical_reviewer_signoff` for `contraindicates`). Needs vocab-map + evidence policy. Hierarchy is partly captured via `parent_entity_fp` on the graph, so not blocking. |
| `seo_entity_product` (9) + `seo_entity_devices` (16) | product CHECK = consumer enum {skincare/supplement/medical_device_otc/cosmetic/wellness_product/food_drink/medical_food} — no fit for clinician-placed dental devices. Mirror Deezy → defer. (Devices are a trivial later add: `seo_entity_devices` needs only `entity_fp`.) |
| `seo_page_citations` (junction) | Phase F (per-page citations authored during content writing). |
| `seo_page_internal_links` (junction) | Phase F (needs page hierarchy `parent_page_fp` + relationships). |
| `seo_programmatic_templates` | Wave 1B (programmatic §-generation). |
| keyword metrics / SERP / intent | DataForSEO full run enriches after seed load. |
| Notion mirror (`notion_id`, sync_state) | Phase-2 n8n flows (§18.5). Leave `notion_id` NULL. |
| image URLs | Cloudflare / Session A (DR-035: URL-only in Supabase). |
| branch enrichment (addr / geo / phone / license) | operator data batch → `UPDATE` later. |
| doctor credential detail | `docs/team/*.md` already present; richer fields backfilled via `UPDATE` if/when expanded. |

## 5. Conventions (from Deezy `LOAD-LOG.md`, operator-confirmed + schema-verified)

- **`brand_scope`** = text[] of brand slugs. **Normalize planning's `smile-scape` → `smile-scape-clinic`** on load (so `trg_brand_scope_names` resolves `brand_scope_id`/`brand_scope_name`). `['*']` = universal/shared across the federation.
- **Fingerprints** (`clst_` / `ent_` / `pg_` / `cite_` / `brch_` / `auth_` / `docasg_` + `{ULID16}`) and `*_display_name` are **auto-generated by INSERT triggers → leave NULL**. `brand_scope_id` / `brand_scope_name` auto-filled.
- **`entity_fingerprint`** (legacy, NOT NULL + globally UNIQUE) = the **kebab-case slug**. `parent_entity_fp`, `primary_entity_fp` = slug text-refs (no FK enforcement). `entity_type` = **lowercase** enum (planning files are Title Case → lowercase on load).
- **`page_fingerprint`** = `smilescape-{sitemap_node}` (deterministic, unique; key for future 07/09 junctions).
- **`branch_fingerprint`** = branch slug. **`brand_id` on `seo_branches` = the UUID** `c93a5e7b-…` (matches Deezy's `seo_branches.brand_id` uuid usage); `brand_slug` = `smile-scape-clinic`. (Note: `seo_website_page_master.brand_id` is **text** = `smile-scape-clinic`, per Deezy.)
- **`notion_id` = NULL** everywhere (Phase-2 sync). Clusters get `sync_state='flat_loaded'` (graph has no sync_state col).
- **`status`** = `'Planned'` (pages), `'active'` (branches), matching existing rows.
- **Idempotency:** every file uses `ON CONFLICT (<natural key>) DO NOTHING` → safe to re-run. Natural keys: cluster id, `entity_fingerprint`, `citation_slug`, `branch_fingerprint`, `page_fingerprint`, keyword fingerprint, ext `entity_fp`.

## 6. Key design points specific to SmileScape

### 6.1 Entity MERGE (the one real difference from Deezy)
Deezy was the *first* brand to use slug-as-`entity_fingerprint`, so all 256 inserted with zero collision. SmileScape is the **second dental brand** → many universal `['*']` entities already exist (verified: of 21 sampled slugs, 10 already exist — `dental-implant`, `bone-grafting`, `sinus-lift`, `all-on-4/6`, `osseointegration`, `straumann-implant`, `titanium-implant`, `ceramic-implant`, `immediate-implant`). `entity_fingerprint` is globally UNIQUE → a naive insert fails.

**Rule:** `01_entities` = `INSERT … ON CONFLICT (entity_fingerprint) DO NOTHING`.
- Existing `['*']` entities → skipped & **reused** (their `['*']` scope already covers SmileScape).
- Net-new entities (SmileScape-specific: `blue-diamond-implant`, `neodent-implant` [as `['smile-scape-clinic']` per SS-DR-001], `smilescape-dental-clinic`, `smile-dna`, `family-standard`, `zero-bone-loss-concept`, doctors; + universals Deezy lacked: `all-on-x`, `single-tooth-implant`, `overdenture`, `zygomatic-implant`, `guided-bone-regeneration`, …) → inserted.
- **Pre-load diff** (MCP): report `X already-exist / Y net-new` from the 163 → this Y is the expected insert count for validation.
- **Type-mismatch on a shared slug** (e.g. `ceramic-implant` exists as `product`, SmileScape lists it Treatment): existing row wins (DO NOTHING) → flag in LOAD-LOG, do not overwrite.
- Brand-exclusive collisions with another brand: none expected (Deezy's only exclusive entity was `aaci`). If any appear in the diff → flag for operator, don't auto-merge `brand_scope`.

### 6.2 Branches — partial load
`branches.md` has NAP mostly `TBD` (operator action). Load only what's real: `branch_fingerprint`(=slug), `brand_id`(uuid), `brand_slug`, `branch_name`, `branch_slug`, `business_name_brand`, `city`, `region`, `country_code`, `website_url`, `status='active'`, `local_business_schema_type='DentalClinic'`. NULL: `street_address`/`full_address`/`latitude`/`longitude`/`postal_code`/`phone`/`email`/`line_id`/`medical_license_no` → `UPDATE` later. **Pre-insert check:** verify `seo_branches` NOT-NULL columns; if `full_address`/`lat`/`lng` are NOT NULL, fill safe placeholders or the load fails (Deezy ⚠️1). `organization_entity_id` FK → set from the 2 Organization entities (`smilescape-rattanathibet` / `smilescape-srinakarin`) after entities load — hence branches run **after** entities.

### 6.3 Authors — both doctors
Load both: **หมอแฮม** (`dr-woraphat-jarangkul`, Medical Director / lead reviewer) and **หมอแพรว** (`dr-pitchapa-phudphong`, Co-Founder). Source: `docs/team/dr-worapat-jarangkul.md` + `docs/team/dr-pitchapa-phudphong.md` (+ `entities.md` person rows). **Exclude `dr-tomas-linkevicius`** — external E-E-A-T authority anchor → stays a `Person` entity in the graph only, not an author/reviewer. ⚠️ **Slug reconciliation:** `entities.md` uses `dr-woraphat-jarangkul`; team file is `dr-worapat-jarangkul.md` (worapat vs woraphat). Pick one canonical slug and make `seo_authors_reviewers` ↔ `entities.md` ↔ `seo_doctor_assignments` agree; record the choice in LOAD-LOG.

### 6.4 Sitemap → page stub
7-column model (`# / Page Name / Layer / Tier / Funnel / Page Type / Primary Entity`). Parser (port of Deezy `gen_pages.py`): keep only rows whose first cell is a pure dotted node (`^\d+(\.\d+)*$`); strip depth-arrows/markers from name; `primary_entity_fp` = col 7 (slug or NULL). Stub columns only: `page_fingerprint`, `page_name`, `sitemap_node_id`, `primary_entity_fp`, `cluster_id`, `status='Planned'`, `brand_id='smile-scape-clinic'`, `brand_name='Smile Scape Clinic'`. URLs/slug/CPT/T-template/`parent_page_fp` deferred (need keyword research). **Rebuild the section→cluster fallback map for SmileScape's 8 sections** (1 HOME / 2 OUR UNIQUENESS / 3 SERVICES / 4 TECHNOLOGY / 5 TREATMENT BY CONCERNS / 6 KNOWLEDGE / 7 CASE STUDIES / 8 CONTACT); authoritative cluster comes from a post-insert `UPDATE` joining `primary_entity_fp` → `seo_entity_graph.topic_cluster_id`.

## 7. RUN-ORDER (strict, dependency-ordered)

```
00_clusters.sql          seo_topic_cluster_master         (no deps)
01_entities.sql          seo_entity_graph                 (refs clusters via topic_cluster_id; MERGE)
02_entity_extensions.sql cond/symptom/anatomy/procedures/drug   (INSERT..SELECT from graph)
03_citations.sql         seo_citations                    (no deps; ['*'])
04_authors.sql           seo_authors_reviewers + seo_doctor_assignments
05_branches.sql          seo_branches                     (org FK → entities)
06_pages.sql             seo_website_page_master          (refs clusters + entities by slug)
10_keywords.sql          seo_x_ads_keywords_contextual_master  (seed; → DFS)
```

## 8. Artifacts (created in this repo)

New folder **`deployment/supabase-load/`**:
- Parsers: `gen_clusters.py`, `gen_entities.py`, `gen_citations.py`, `gen_branches.py`, `gen_pages.py`, `gen_keywords.py` (md → .sql; print parse-stats).
- Static/hand-written: `02_entity_extensions.sql` (`INSERT..SELECT`), `04_authors.sql`.
- Generated SQL: `00…10_*.sql` (committed).
- `RUN-ORDER.md` (operator how-to + table + status) and `LOAD-LOG.md` (conventions, progress, flagged items).

## 9. Validation (Claude via MCP, after each file)

- `count(*)` vs expected (for entities: vs the §6.1 net-new diff, not 163).
- FK / orphan: cluster refs resolve, `primary_entity_fp` resolves (or NULL), no bad `cluster_id`.
- Fingerprints populated (`*_` prefix) on inserted rows.
- **Brand-isolation guard:** snapshot per-brand counts before/after; assert rows for brands ≠ `smile-scape-clinic` are unchanged (citations `['*']` + reused `['*']` entities are append-only / untouched).
- Thai text intact (spot-check aliases/names).
- `brand_scope` normalized (no stray `smile-scape`).

## 10. Safeguards (shared production DB)

- Strict numbered order; atomic per-file inserts (all-or-nothing → a failed file inserts nothing).
- `ON CONFLICT DO NOTHING` re-run safety; on a half-fail, stop and ask Claude (don't blind re-run).
- No `UPDATE`/`DELETE` outside `brand = 'smile-scape-clinic'`. Shared `['*']` rows are append-only — never modify another brand's data.
- Run `get_advisors` (security) once after the load completes.

## 11. Open items / flags

1. **Entity count** = **163** (R13 recount; the handover's "166/167" is stale).
2. **Page count** ≈ **726** (R17 count-audit; a "730 actual" note exists — parser yields the exact authored count).
3. **Author slug** worapat vs woraphat — reconcile (§6.3).
4. **Type-mismatch** shared entities (§6.1) — log, don't overwrite.
5. **`seo_branches` NOT-NULL preflight** before `05` (§6.2).
6. **Devices/product ext** deferred — easy later add if operator wants `seo_entity_devices`.
