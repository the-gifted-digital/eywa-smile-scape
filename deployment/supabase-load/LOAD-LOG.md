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

## 2026-07-09 (cont) — Wave 5: internal-link graph (DR-021) — 2306 planned links

**`15_internal_links.sql`** — deterministic structural link graph (no DFS, no content drafting; all `status='planned'`, `implemented=false`, anchor_text = target page_name, refined to authored anchors at Phase F). Mirrors VTH BioDent's model.
- **L1 breadcrumb 1580** — each page → every ancestor (recursive on parent_page_fp) + home. role=primary_hub, pri 9.
- **L2 hub→spoke 660** — parent → each direct child (647) + 13 orphan-closers. role=cluster_spoke, pri 7.
- **L3 curated cross-cluster 66** — the operator's "→ link X.Y" annotations parsed from sitemap.md (100% resolved). role=cross_cluster, pri 6.
- **L4 orphan-close** — 13 top-level pages (2.4/2.5/4.1/4.8/5.22/6.2.6.x/6.2.7.x/7.1/8.1 — parent is a non-materialized section root) linked from nearest existing ancestor (else home).

**Validated: 2306 links · FK 0 bad from/to · orphans 0 (every page ≥1 inbound) · avg inbound 3.2/page · home_inbound 721 · auto-reciprocal flagged 1294 · VTH 4901 + Deezy 4197 untouched.**

Deferred to Phase F: authored topical anchor_text variants + full contextual body links (entity-relationship-derived cross-links from the 255 edges can seed more) + flip status planned→live at publish.

## 2026-07-09 (cont) — Wave 6: node_tier_strategy + schema_markup_type · Wave 7 finding

**`16_page_strategy_schema.sql`** — two deterministic page_master fields (722/722):
- `node_tier_strategy` (hub/leaf role): spoke 613 · pillar 62 · hub 34 · supporting 13.
- `schema_markup_type` (schema.org primary type from page_type): MedicalProcedure 255 · Article 201 · MedicalCondition 109 · MedicalDevice 67 · WebPage 37 · AboutPage 23 · Dentist 14 · MedicalWebPage 9 · Physician 6 · ContactPage 1. NOTE live col is single `text`, not `text[]` (drift from v1_8).

### Wave 7 (`seo_page_citations`) — RE-SCOPED to Phase F (was mis-estimated as deterministic)
Investigation: 0 edges carry `edge_evidence_citation` FK; only ~23 `evidenced_by` entity edges exist, citing pillar codes (P2-C2, P15…) as FREE TEXT + raw PMIDs; citation_slug uses pillar codes (p2-c2) so a crosswalk is *possible* but sparse + fragile. Decisive: **`content-plan/citation-pool-seed.md` itself scopes page↔citation linking to "Phase F step 3 — per-page depth research during content writing"**, and a `seo_page_citations` row requires `citation_purpose` + `supports_claim` + anchor (content-briefing outputs). The Stage-1 evidence layer is correctly the 23 `evidenced_by` ENTITY edges (already in `seo_entity_relationships`). → **`seo_page_citations` stays empty until Phase F. Not force-filled.**

## 2026-07-09 (cont) — Wave 8: founders/doctors complete (หมอแฮม + หมอแพรว) — `17_doctors.sql`

Resolved the long-standing "หมอแพรว = author-only" gap (she had a seo_authors_reviewers row since Wave 04 but no graph entity):
- **+Person entity `dr-pitchapa-phudphong`** (person/Physician, brand-doctor-authority) — mirrors dr-woraphat-jarangkul. SS person entities now **2** (แฮม + แพรว).
- **doctor_assignment linked** — her `author_fp` NULL → `dr-pitchapa-phudphong` (assignments_null now 0).
- **profile page 2.2.3** re-pointed org-placeholder → her entity; re-derived to page_type=doctor_profile / schema=Physician / cluster=brand-doctor-authority (doctor_profile pages 6→7).
- entities.md (#10, Person 2→3) + sitemap.md 2.2.3 synced on `main` (commit 47e9bd4).

Author rows: both founders already carried full name / canonical_names / credential_types / specialties / primary_specialty / bio / short_bio (แพรว also board_certifications). CV rich data (education/publications/awards/experience) has no author-table columns — it lives in `web/src/data/doctors.json` for the T9 doctor-profile PAGE (Phase F render). **Still operator-pending:** `medical_license_number` (not in CV source), `photo_url`, `email` (personal only — must not publish per doctors.json _meta warning). หมอแฮม `board_certifications` genuinely empty (M.Sc. + certificates, no board diploma).

## 2026-07-09 (cont) — Wave 8b: board-cert re-verify + .md/json back-fill
- **หมอแฮม board_certifications re-checked** against full CV (`docs/team/dr-worapat-jarangkul.md`): confirmed **no board diploma** — highest OMS credential is a *Certificate* in Oral & Maxillofacial Surgery (Chulalongkorn 2018) + dual M.Sc. (Mahidol + Duisburg-Essen). Set `board_certifications` null → `[]` (verified-empty, distinct from unknown). หมอแพรว keeps her Thai Board OMFS Diploma (2023). 0 SS authors now null-board.
- **Back-filled source files:** `web/src/data/doctors.json` — added `"entities_slug": "dr-pitchapa-phudphong"` to หมอแพรว (mirrors หมอแฮม, marks her registered entity). `docs/team/README.md` — added SEO-entity registration note + board-cert clarification. (These previously-untracked source-of-truth files are now committed.)
- Per operator (2026-07-09): `medical_license_number` = skip (not blocking) · `photo_url` = to follow.

## 2026-07-09 (cont) — Wave 6: node_tier_strategy + schema_markup_type (derived) · page_citations = Phase F

**`19_page_master_derived.sql`** — two structural columns derived from existing data (no DFS):
- `node_tier_strategy` (hub/leaf role) from parent + has-children: **pillar 62 · hub 34 · spoke 613 · supporting 13** = 722/722.
- `schema_markup_type` (text[]) mapped from `page_type` → schema.org types (e.g. condition_pillar→{MedicalCondition,MedicalWebPage}, service_page→{MedicalProcedure,WebPage}, doctor_profile→{Physician,ProfilePage}, branch_landing→{Dentist,WebPage}). 722/722.

**`seo_page_citations` — NOT loaded (correctly deferred to Phase F).** Investigated: the junction needs `citation_purpose` (supporting_evidence/statistic/guideline_reference/…) + `supports_claim` + `citation_anchor_text` + `inline_position` — i.e. *which source backs which claim at which spot on which page* = an editorial decision made when the page body is written, not derivable from structure. The `evidenced_by` edges give only **entity-level** anchors and mostly reference a whole pillar (P6/P13/P14/P15) rather than a specific citation (only 4 edges carry a P#-C# code; 3 of those citations exist: p2-c2/p2-c3/p5-c1). Entity-level evidence is already captured in `seo_entity_relationships` (26 evidenced_by edges); the 90-citation pool is ready to attach during Stage-2 content authoring. Bulk-mapping now would fabricate page-level specificity — skipped by design.

## 2026-07-16 — Wave 10: load-source provenance tagging (SmileScape) — `20_load_source_provenance.sql`

**Convention adopted (operator-approved):** `load_source = '<brand-slug>:<repo-relative source path>'` on the cross-brand SHARED tables. Prefixing the brand keeps Deezy's rows untouched and makes provenance traceable. (`load_source` = *which brand's load created this row*; distinct from `brand_scope` = *who may use it*. Brand-OWNED tables — page_master, branches — use brand_id/brand_name instead and need no tagging.)

Root problem found: Deezy wrote a **bare file path** (`content-plan/entities.md`) — every brand has that same path → ambiguous. SmileScape's generators never set `load_source` at all → all NULL.

**Tagged (SmileScape only, this round). Identified by insert-batch timestamp, cross-checked to LOAD-LOG counts:**
| table | SmileScape | Deezy (bare path) | NULL |
|---|---|---|---|
| seo_entity_graph | **117** | 257 | 339 |
| seo_entity_relationships | **255** | 138 | 694 |
| seo_citations | **90** | 42 | 54 |
| seo_topic_cluster_master | **19** | 16 | 23 |
| seo_authors_reviewers | **2** | 1 | 1 |
| seo_entity_procedures | **41** | 30 | 76 |
| seo_entity_condition | **13** | 50 | 58 |
| seo_entity_anatomy | **3** | 12 | 6 |
| ext_devices / symptom / drug | 0 (SS created none) | 30/7/4 | 30/13/5 |

⚠️ **Gotcha for the next brand:** `seo_entity_relationships` — SS's batch (2026-07-08 **18:54**, 255) shares its DATE with VTH's batches (07:31–07:43, 692). Must separate by minute, not date.
⚠️ **"NULL = VTH" is ~99%, not 100%** — 9 Deezy stragglers are NULL (6 citations @2026-06-06 · 1 rel @2026-07-06 · 2 rel @2026-06-07 23:06, payer topic). Reliable rule: **VTH = created_at >= 2026-07-07**; NULL before that = Deezy. Left untouched per operator (SmileScape-only this round).

**TODO (next brand):** teach the generators to emit `load_source` at insert time so this never needs back-filling again.

## 2026-07-16 — Phase 2 COLLISION AUDIT (report) + Wave 11 fix — `21_page_cluster_remap.sql`

**Audit (SmileScape's files held as source of truth, compared against the merged tables):**
- `entities.md` = 168 entities → all 168 present in DB. **117 created by SmileScape · 51 created by DEEZY · 0 VTH.**
- **All 51 Deezy-created entities differ from SmileScape's authored definition — every single one:**
  - `topic_cluster_id` — **51/51** (the two brands use entirely different cluster taxonomies)
  - `schema_org_type` ~18 (SS `MedicalProcedure` vs Deezy `MedicalTherapy`; `maxilla` SS `AnatomicalStructure` vs Deezy NULL)
  - `entity_type` ~13 (`ceramic-implant` treatment/device · `cad-cam`,`intraoral-scanner` device/technology · `pediatric-dentistry`,`geriatric-dentistry` treatment/specialty)
  - `parent_entity_fp` ~12 (`all-on-4` all-on-x/dental-implant · `peri-implantitis` periodontitis/dental-implant)
  - `icd_10_code` ~17 — some are real clinical disagreements (`bruxism` F45.8 vs G47.63 · `malocclusion` M26.4 vs K07.4 · `peri-implantitis` M27.62 vs T85.69); many are precision (SS billable-level K02.9/K05.30 vs Deezy category K02/K05.3). **Neither brand is uniformly right** — Deezy's G47.63 fits their sleep/airway context.
  - `brand_scope` 1 (`damon-system`: SS says brand-exclusive, DB says universal)
- `clusters.md` 20 → 19 loaded; **`pediatric-dentistry` collided with Deezy's identically-named cluster** (legit shared slug).
- `relationships.md` 263 unique → 255 loaded (8 pre-existing). `citation-pool-seed.md` 93 → 90 (3 DOI/PMID dupes).

**🔴 Downstream impact found: 387 of 722 SmileScape pages (54%) were sitting in DEEZY's clusters** (implant-dentistry 161 · orthodontics 43 · preventive-general 36 · periodontics-gum 33 · cosmetic-dentistry 25 · …), because `06_pages.sql` copies `page.cluster_id` from the shared entity row.

**Root cause (structural):** `topic_cluster_id` is a SINGLE field on a SHARED entity → an entity can live in only one brand's taxonomy; the second brand to load always loses. A reload would reproduce this exactly — `ON CONFLICT DO NOTHING` *is* "share if duplicate".

**Wave 11 fix applied (operator-approved option B):** page.cluster_id now derives from SmileScape's OWN authored entity→cluster map, not from the shared entity row. **335 → 722/722 on SS clusters · foreign 387 → 0 · null 0.** Zero rows of Deezy/VTH/any entity touched. Reversible.

**Raised to protocol governance (NOT actioned here):**
1. `topic_cluster` should be **per-brand** (junction `entity × brand → cluster`) — one shared entity legitimately belongs to different clusters per brand.
2. **Who owns the canonical definition** (entity_type / schema_org_type / ICD-10) of a shared entity when two brands disagree? Today it's just "whoever loaded first".
