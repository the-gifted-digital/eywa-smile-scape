# SmileScape — Supabase Flat-Load Log (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav`. Brand: Smile Scape Clinic (`brands.id=c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25`, slug `smile-scape-clinic`, fp `brnd_8314A55613F44453`). Fresh load (0 content rows). Method: parse content-plan/*.md → SQL → run via SQL Editor → Claude validates via MCP.

## Conventions
- brand_scope = slug array; planning `smile-scape` normalized → `smile-scape-clinic`; `['*']` universal.
- Triggers auto-set fingerprint/display/brand_scope_id/name → leave NULL. entity_fingerprint=slug; entity_type lowercase. notion_id NULL.
- MERGE tables (2nd dental brand): entities ON CONFLICT(entity_fingerprint); citations dedup on slug/doi/pmid. page_fingerprint=`smilescape-{node}`; keyword fp=`smile scape clinic::{loc}::{lang}::{kw}`.

## Progress
| Phase | Table | Rows | Status |
|---|---|---|---|
| 00 | `seo_topic_cluster_master` | 20 | ✅ loaded + validated (fp_ok 20, sync_state flat_loaded 20, with_parent 4, brand_scoped 1) |
| 01 | `seo_entity_graph` | +113 net-new | ✅ loaded + validated (present_of_ours 163, +113 → global 369, ss_badcase 0, stray_scope 0). NOTE: legacy entities purged externally (722→256 federation baseline); legacy_capitalized now 0 (spec-pure). 341 universal + 27 ss-excl + 1 deezy-excl. |
| 02 | entity extensions | full coverage | ✅ loaded + validated (entities==ext: condition 63=63, procedure 68=68, anatomy 15=15; symptom/drug no-op). product+device deferred. |
| 03 | `seo_citations` | +90 | ✅ loaded + validated (ours_present 90, fp_ok 90, tier 1-6 all, authors arrays, global 48→138; 13 tier-5 brand-internal). 3 skipped (2 DOI + 1 PMID already in pool). FIX: `authors` is text[] → array literal. |
| 04 | `seo_authors_reviewers` + assignments | 2 (+2) | ✅ loaded + validated (auth_ fp; แฮม medical_director/primary fp→dr-woraphat-jarangkul, แพรว medical_director/secondary). FIX: `board_certifications` is jsonb → jsonb array. |
| 05 | `seo_branches` | 2 (partial) | ✅ loaded + validated (brch_ fp; รัตนาธิเบศร์ primary, ศรีนครินทร์ secondary; org_linked both true). addr/phone/geo/license NULL → operator UPDATE later. |
| 06 | `seo_website_page_master` | 722 stub | ✅ loaded + validated (722; `page_` fp all 722; with_entity 721, with_cluster 718, orphan_entity 3 = orthodontic-intervention [flagged]). Deezy 689 untouched (VitalSleep legacy pages purged externally). NOTE: page auto-fp prefix is `page_` (spec said `pg_` — doc typo). |
| 10 | `seo_x_ads_keywords_contextual_master` | 525 seed | ✅ loaded + validated (ss_keywords 525, fp_ok 525; fp `smile scape clinic::🇹🇭 th – thailand::🇹🇭 th – thai::{kw}`). → hand off to DataForSEO full run for metric/SERP/intent enrichment. |

## ✅ LOAD COMPLETE — 2026-06-07
All 8 files loaded + MCP-validated. Final SmileScape footprint on GTGT:
- clusters **20** · entities **+113 net-new** (graph 369; 27 ss-exclusive) · entity-ext full coverage (cond/proc/anat) · citations **+90** (pool 138; 13 tier-5 internal) · authors **2** (+2 assignments) · branches **2** (partial) · pages **722** stub · keywords **525** seed.
- **Brand isolation verified:** Deezy pages 689 untouched; citations pool 48→138 (+90 only); no other-brand rows modified (all inserts append-only `ON CONFLICT`/`NOT EXISTS`).
- **Security advisors:** 0 new findings from this load (pure DML). 111 WARN + 3 ERROR are pre-existing/schema-level; the 3 ERROR are RLS-disabled on `_archive_legacy_*` backup tables created by the external legacy cleanup (federation housekeeping, not ours).

### Next (deferred — not this session)
relationships (edge-vocab + evidence) · page↔citation + internal-links (Phase F) · product/device ext (enum) · programmatic templates (Wave 1B) · **keyword enrichment → DataForSEO** · branch addr/geo/phone/license UPDATE (operator batch) · Notion sync (n8n) · image URLs (Cloudflare) · resolve `orthodontic-intervention` entity (3 orphan pages).

## Flags
- Author slug: entities.md `dr-woraphat-jarangkul` (Woraphat) vs CV `dr-worapat-jarangkul.md` (Worapat) — **RESOLVED**: keep entity/`author_fp` slug `dr-woraphat-jarangkul`; display name "Worapat" per CV.
- Shared-entity type mismatch (e.g. ceramic-implant product vs treatment): existing row wins (ON CONFLICT).
- Entities pre-load diff: 163 authored = 50 already-exist (`['*']` shared) + **113 net-new** to insert.
- หมอแพรว has NO Person entity in entities.md (only woraphat + tomas); loaded as author only (`author_fp` NULL).
- Pages: parser yields **722 unique** (721 entity-bearing + `6.2` hub). Official audit "726" double-counts 4 section-6 hub-index rows (6.1/6.3/6.4/6.6 also exist as 7-col page rows) → de-duped.
- Page orphan ref: `orthodontic-intervention` ×3 pages (3.5.4/.5/.7, R17 rename) — entity not in entities.md → expect `orphan_entity=3`. Phase F: add entity or remap.
- Citations: 93 parsed; 2 DOIs already in shared pool (`10.1016/j.jdent.2019.03.008`, `10.1111/j.1600-0501.2012.02546.x`) → **91 net-new**. `citation_type` mostly `other` (bare grade letters / `—` / retrospectives) — Phase F enrich. Only 11 of 93 carry a DOI (md DOI/URL column sparse).
- Keywords: 525 unique (after dropping 21 `[service]`/`[BRAND]`/`[condition]` template placeholders). Source doc claimed ~680 (loose).
- Source counts vs handover: entities **163** (not 166/167); pages **722 unique** (not 726).

## 2026-07-09 — Wave 1+2 backfill (post-review) + page-node divergence FOUND

Continues the flat-load. Files: `11_relationships.sql`, `12_pages_enrich.sql`, `gen_relationships.py`, `gen_pages_enrich.py`, `BACKFILL-PLAN.md`.

- **Entities (delta):** +3 R18/R22 entities that missed the 2026-06-07 load (`dental-scaling`, `frenectomy`, `oral-pathology`) + procedure ext. +orphan resolve: `orthodontic-intervention` (3 pages) remapped → shared `orthodontic-treatment` (EUG reuse). Graph now clean for those pages.
- **Wave 1 — `seo_entity_relationships`:** +255 edges inserted (263 parsed from `content-plan/relationships.md`; 8 pre-existing universal skipped). 181 universal + 74 ss-scoped. FK orphan 0/0. Grand total 833→1088 (+255 only; no other-brand rows touched). Fixed source bug: `endodontics-specialist` (cluster slug) → `endodontist` (entity) in relationships.md.
- **Wave 2 — `seo_website_page_master` structural:** node_tier + funnel_stage (from R26 sitemap) + sitemap_section + crawl_depth + parent_page_fp (derived in-SQL from sitemap_node_id). **Updated 667 / 722.** Tier A baseline = 14 (≈2.1%, pre-DFS).
  - Correction to BACKFILL-PLAN assumption: sitemap Funnel column is NOT `—`/TBD — it carries real top/mid/bottom per row → loaded. Page Type column is placeholder (`A` for 651/722) → still skipped for Phase F.

### ⚠️ FINDING — page-node divergence (55 rows), needs Wave 2b reconciliation
The 2026-06-07 page load ran from the PRE-review sitemap (branch `sitemap-review-r18-21` R18–R26 was only merged to main 2026-07-09). Result: **55 DB page rows carry stale pre-R18/R22 node IDs** that no longer exist in the canonical R26 sitemap, and **55 canonical R26 nodes have no DB row** (symmetric). Examples of stale DB-only: `3.5.8.x` (Orthognathic — R22 moved to 3.10.8.x), `3.4.5/3.4.7.x` (whitening pre-R19), `3.6.1.x` (scaling long-tail), `3.9.7–13`, `6.2`, `6.2.5.10`. Full list: `/tmp/db_nodes.txt` (session-local) / re-derivable via `node_tier is null` after Wave 2.
- These 55 were NOT enriched (correctly — they map to different content now). NOT fabricated.
- **Recommended Wave 2b (needs operator OK — involves DELETE):** delete the 55 stale SS page rows (no dependents: SS has 0 page_citations / 0 internal_links), then re-run `06_pages.sql` (idempotent) to insert the 55 new R26 nodes as stubs, then re-run `12_pages_enrich.sql` → 722/722. Safe because content moved, not just renumbered — a pure rename would mis-map entities.

## 2026-07-09 (cont) — Wave 2b DONE: full page-node reconciliation to R26

Executed the reconciliation. Turned out BIGGER than the initial 55-row finding: R18–R22 didn't just add/remove nodes, it **reordered whole Section-3 categories** (e.g. 3.4 Cosmetic→General, 3.5 Ortho→Restorative, 3.6→Endo, 3.9↔3.11, 3.10 Sedation→Ortho, 3.12→Sedation). Many node NUMBERS survived while their CONTENT moved.

Steps run (all via MCP, idempotent SQL committed):
1. **DELETE 55 stale** rows (nodes vanished from R26; 0 dependents) — `node_tier is null` after Wave 2 = exact stale set.
2. **`06b_pages_delta.sql`** — insert the 55 NEW R26 nodes as stubs (regenerated from R26 sitemap; entities pre-verified present). → 722 rows, 722 with entity.
3. **re-run `12_pages_enrich.sql`** → 722/722 node_tier + funnel + section + crawl_depth; parent 647.
4. **`13_pages_resync.sql`** — resync page_name + primary_entity_fp for **127 surviving-but-moved nodes** (77 entity changes + 106 name changes, union 127) to canonical R26; then re-derive cluster.

**Final state (validated): 722 pages · orphan_entity 0 · cluster 722/722 · tier 722/722 · Deezy 690 untouched.** Section counts match R26 header exactly: §1=1 §2=26 §3=242 §4=44 §5=193 §6=163 §7=38 §8=15.

`06_pages.sql` also regenerated from R26 (was built from pre-review sitemap) so the file set now reproduces the canonical state from scratch: 00→06→06b→10→11→12→13.

### Residual (Phase F, unchanged): page_type/slug/seo_title/target_keyword_fp still deferred; keyword enrichment via DFS = Stage-1-Gate.

## 2026-07-09 (cont) — Wave 4 (partial): page_type SEMANTIC derivation + column-semantics fix

**Column-meaning traced to source.** `page_type` was being conflated with the A/B/C/D tier. Original schema dict `archive/Schema_Overview_EYWA_v1_8.md` settles it: L992/L1143 `node_tier` = tier A/B/C/D (CHECK); L995 `page_type` = SEMANTIC category ('pillar'/'service'/'doctor_profile'/…). Current spec v1_23 agrees. **So the sitemap's "Page Type" A/B column is a legacy placeholder — NOT the DB page_type.** (Federation data bug found: VTH BioDent stored tier letters in `page_type`, 696 rows → flagged for re-derivation, not ours to fix here.)

- **`14_page_type.sql`** — derived `page_type` for all 722 SmileScape pages from entity_type + section + hub/leaf (deterministic, DFS-independent). Distribution: knowledge_article 163 · service_page 222 · condition_pillar 109 · technology_page 67 · evidence_case 38 · supporting 36 · procedure_pillar 33 · about 23 · local_landing 12 · pillar 9 · doctor_profile 6 · branch_landing 2 · home 1 · contact 1. **722/722.**
- **Live `COMMENT ON COLUMN`** added to GTGT `seo_website_page_master` (page_type, node_tier, schema_markup_type, page_intent_type) so any brand inspecting the DB sees the correct semantics — migration `clarify_page_master_column_semantics_page_type_vs_node_tier`.
- **Protocol updated + pushed** (eywa-protocol-spec `538c584`): Schema_Overview v1_23 "Page taxonomy" now spells out page_type vs node_tier vs node_tier_strategy as three independent axes + the VTH bug note.

### Still Phase F (unchanged): slug / seo_title / target_keyword_fp / internal-links / page↔citations. DFS keyword batch = Stage-1 Gate.
