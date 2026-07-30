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

## 2026-07-16 — Wave 10b: Deezy tidy-up + ext_devices resolution + cross-brand handovers

**Deezy (done for them, at operator request):**
- Filled the 9 rows they left NULL — citations +6 (42→**48**), relationships +3 (137→**140**). Both joined their own batches.
- Prefixed every Deezy row `deezy-dental:` across all 11 shared tables. **`bare_left = 0` everywhere** — no ambiguous paths remain in the federation.

**⚠️ Trap caught: "bare path = Deezy" was FALSE.** VTH also wrote one bare-path row — `orthodontic-treatment→cephalometric-analysis` (`2026-07-08 07:40`, inside VTH's 07:31–07:43 batch, `brand_scope=['vth-biodent']`). A blanket prefix would have relabelled it Deezy. Re-tagged `vth-biodent:content-plan/relationships.md` (the only VTH row touched).

**✅ `seo_entity_devices` 13:39 batch RESOLVED — and it taught us the real rule.** The 30 "Deezy" + 8 NULL rows share one timestamp to the microsecond (`13:39:25.546608`) = **a single INSERT** that copied `load_source` **from the entity row** (`select entity_fingerprint, load_source from seo_entity_graph where entity_type='device'`). The split reflects the entities' origin, not the runner: Deezy's 30 entities had a path → inherited it; SmileScape's 8 were NULL then → inherited NULL. Operator confirmed the blue-diamond gang is SmileScape's 100% → tagged `smile-scape-clinic:` (`blue-diamond-implant`, `neodent-implant`, `trioclear-aligner`, `photopolymer-resin-tc85`, `prf-platelet-rich-fibrin`, `titanium`, `zirconia`, `bone-graft-substitute`). This also explains why SS's original load-log said *"product+device deferred"*.

**📌 Rule established for the EXTENSION tables:** `load_source` **mirrors the parent entity's** `load_source` — read it as *"whose entity this extends"*, not *"who ran the script"*. Verified across all 6 ext tables: **0 mismatches** vs parent entity. SmileScape ext totals now: procedures 41 · condition 13 · **devices 8** · anatomy 3.

**Final federation state — every shared row is brand-attributable:**
| | smile-scape-clinic | deezy-dental | vth-biodent | bare | NULL (VTH, untagged) |
|---|---|---|---|---|---|
| entity_graph | 117 | 257 | — | **0** | 339 |
| entity_relationships | 255 | 140 | 1 | **0** | 691 |
| citations | 90 | 48 | — | **0** | 48 |
| topic_cluster_master | 19 | 16 | — | **0** | 23 |
| authors_reviewers | 2 | 1 | — | **0** | 1 |
| ext (proc/cond/dev/anat/symp/drug) | 41/13/8/3/0/0 | 30/50/30/12/7/4 | — | **0** | 76/58/22/6/13/5 |

**Handovers written (uncommitted — both repos have team WIP on feature branches):**
- `eywa-deezy/docs/HANDOVER-load-source-provenance.md` — short: what was done for them, the ext-mirror precedent, fix generators, + the 51-entity definition disagreements as governance (incl. `maxilla.schema_org_type` empty, ICD precision).
- `eywa-vth-biodent/docs/HANDOVER-load-source-provenance.md` — full: the convention, their exact footprint + ready SQL, the 4 traps (date≠brand · their bare-path row · devices 22-not-30 · ext-mirror rule), the `page_type` tier-letters bug (696 rows), and how to run their own cluster-collision audit.

## 2026-07-16 — Wave 12: page_master completion — every keyword-independent column filled — `22_page_master_completion.sql`

Operator spotted the gaps; conventions reverse-engineered from **Deezy (689/689 filled = the reference)**. All 722 SS pages now have:
- **`content_format` = TEMPLATE CODE** (answer to "เติมอะไร"): T5 222 · T6 148 · T1 109 · T4 67 · T8 38 · T12 34 · T2 33 · T16 28 · T11 24 · T18 10 · T9 7 · T10 2. **This is where the T1–T22 template binding lives** (Deezy stores T1/T2b/…/T19 here) — the seo_programmatic_templates registry remains a separate, still-empty catalog table.
- `conversion_event_primary/secondary` — `line_follow`/`[call_click]` (LINE-first); branch/local/contact pages inverted.
- `required_min_inbound/outbound` (DR-021): A=3/2 · B=2/2 · C=1/1 · D=1/1.
- `auto_suggested_word_count_target` — tier × template-family (knowledge 2300→1550 · service 1800→1200, mirrors Deezy's matrix).
- `link_role` (primary_hub 96 / cluster_spoke / supporting) · `anchor_strategy_mode` (branded/partial/topical/generic) · `review_cycle` (A quarterly · B semiannual · else annual) · `robots_directive` 'index, follow' · `priority` XML 1.0/0.8/0.6/0.4 · `link_priority` 10/9/7/5/4.
- `parent_page_name` 647 + `primary_entity_name` 722 — denormalizations that never auto-populated (no trigger does it; Deezy's primary_entity_name is 0 too — presumably Notion-sync fills it; we filled directly).
- **`related_entities_fps` 722/722, avg 5.5/page** — derived from `seo_entity_relationships` edges (both directions, edge-type ranked, cap 8; cluster-mates fallback cap 4). Deezy avg 6.8.

**Still empty by design:** keyword set (`target_keyword_fp`/`semantic_keywords_fps`/`page_intent_type`) → operator is firing DFS now · Phase-F content (slug/title/meta/brief/canonical) · DR-030 compliance flags (NULL federation-wide — a compliance-review output, not derivable) · ops (notion_id/published_date/viability_assessment).

## 2026-07-16 — Wave 13: shared-table completion (non-keyword) — `23_shared_tables_completion.sql`

Audited every SS non-page table against **Deezy (the reference complete brand)**. Rule: a column is a real gap only if Deezy populated it; anything Deezy left NULL is not baseline → not fabricated.

**Filled:**
- `seo_topic_cluster_master.hierarchy_level` — 0=root (15) / 1=has-parent (4). (descriptions is `{}` empty on Deezy too → non-gap; cluster_facet Deezy-NULL → skip.)
- `seo_branches` arrays (both branches): **services_offered_fps 41 · specialties_at_branch 7 · equipment_at_branch_fps 5 · doctors_at_branch_fps 2** (แฮม+แพรว). Authored in branches.md; all 41 service + 5 equip slugs verified in entity_graph. Deezy left these NULL — this makes SS *more* complete, not fabricated. (doctors/equipment per-branch rotation still an operator refine.)

**Confirmed NOT baseline (Deezy left NULL too → left alone, would be fabrication):** entity_graph wikidata_id/mesh_id/entity_subtype (Deezy: icd 45/257, schema_org 205/257 — partial is normal) · relationships edge_strength/edge_evidence_citation/medical_reviewer_fp · entity-extension clinical fields (cpt/recovery/contraindications/… = Phase-F clinical enrichment) · cluster descriptions/facet.

**Empty tables — status:**
- `seo_programmatic_templates` = **0 across the WHOLE federation** (no brand registered T1–T22). Shared-infra gap, not SmileScape's lane — flagged, not filled.
- `seo_page_citations` / `seo_editorial_reviews` = Phase F / Stage 2. `seo_reviews`/`seo_directory_listings`/`seo_gbp_posts` = n8n Flows E1–E4 (operator infra). `seo_media_assets` = R2/DAM migration.

**DFS status (operator running):** `seo_x_ads_keywords_contextual_master` — 215/525 now carry search_intent + qualitative_kd (~41%, landing in batches). Keyword-dependent page_master columns (target_keyword_fp/semantic_keywords/page_intent_type) + tier recompute wait for the full batch.

## 2026-07-16 (cont) — Wave 14: keyword↔entity↔page binding + tier recompute — Stage 1 Gate CLOSED

Operator ran the DFS full keyword batch (525/525 keywords enriched with volume/CPC/competition/priority in `seo_x_ads_keywords_monthly_market_snapshot`) — this wave connects that data to entities and pages. `24_keyword_entity_binding.sql`.

**Method (operator-directed, relevance-first):** grounded in `content-plan/keyword-seed-list.md` (operator's own cluster→subgroup→sitemap-anchor structure), NOT raw alias/volume fuzzy-matching — auto-alias-match alone only covered 100/525 (19%). Rule stated by operator: *"sitemap structure is the source of truth for what a page is about — relevance decides entity, not volume; a page keeps its DR-022 volume-immune identity even at volume=0 if the structure says it belongs."* Built a rule-based classifier (34 seed-list subgroups, per-keyword regex overrides for precision splits — e.g. peri-implantitis / osseointegration / internal vs lateral sinus lift / implant-supported-bridge vs multiple-implants) — verified against DB with a dry-run before writing.

**Exclusions (operator-approved):**
- **"Other Aligner Brands"** (cluster 6D — zenyum, clearcorrect, spark aligner) — operator: take out entirely, no comparison content planned. 6 keywords left `primary_entity_fp = NULL` by design. **These 6 are the ONLY intentional NULLs.**
- Cluster 16 geo-modifier templates (`[service] กรุงเทพ`) — not real keywords, skipped at parse.
- **Osstem/Dentium — n/a (no such keywords in the batch).** Osstem was removed from the brand lineup back in **SS-DR-001 Round 2** (Neodent added in its place, 2026-05-21), so the current `keyword-seed-list.md` and the DFS batch contain **zero** Osstem/Dentium keywords. Nothing to exclude.

**⚠️ Correction (self-caught 2026-07-17 during operator review) — provenance narrative only, DB state was always correct:**
An earlier version of this entry claimed the 10 Neodent keywords were *"DFS-discovered, not in the original seed-list"* and listed *"Osstem/Dentium (cluster 5C)"* as an exclusion. **Both are wrong.** In the live `content-plan/keyword-seed-list.md`, cluster **5C is Neodent (Value-Premium)** — Osstem only appears in the *archived* `content-plan/archive/keyword-research-dump.md` (5C = Osstem, pre-SS-DR-001-R2). What actually happened: the classifier's exclusion list still carried a stale `exclude 5C = Osstem` rule inherited from that archived dump, so it wrongly dropped the Neodent seed keywords on the first pass; they surfaced in the 16-unmapped audit and were correctly bound to `neodent-implant`. **Verified end-state:** all of cluster 5 maps correctly (5A Blue Diamond→blue-diamond-implant, 5B Straumann→straumann-implant, 5C Neodent→neodent-implant, 5D Ceramic→ceramic-implant, 5E generic-comparison→dental-implant) and **zero** Osstem keywords exist. Only the write-up was off; no data change needed.

**Results:**
- **Wave 14a** keyword→entity: **519/525 bound** (98.9%). Left-NULL 6 = exactly the 6D exclusions, confirmed zero accidental drops.
- **Wave 14b** page↔keyword: `target_keyword_fp` set on **67 anchor pages** (1 per entity — best-tier/shallowest-depth page owns the slot due to the UNIQUE constraint on `target_keyword_fp`; other pages sharing that entity get `semantic_keywords_fps` instead). `semantic_keywords_fps` populated on **484 pages** total. `ad_landing_page_fp` reverse-pointer set on the top-priority keyword per entity.
- **Wave 14c** tier recompute (promote-only vs the existing structural floor, never demoted): **21 nodes promoted** — 10→A (3.4.1 scaling-hub, 3.4.4 wisdom-tooth, 3.5 restorative-hub, 3.6 root-canal-hub, 3.9.2 veneer-hub, 3.10.4 braces, 3.11 pediatric-hub, 3.11.3 primary-filling, 4.6.0.6 aligner-comparison, 5.19 post-op-hub) + 11→B. Tier A 14→**24**, distribution now A:24 · B:115 · C:432 · D:151 (722 total).
- `content-plan/sitemap.md` back-filled to match (Round 27 note + 21 tier cells) — commit `a63c497`.

**🎯 STAGE 1 GATE CLOSED.** Keyword research is fully integrated: metrics (DFS) → relevance (entity) → destination (page) → priority (tier). Phase F content briefing can now proceed with `target_keyword_fp` as ground truth per anchor page.

## 2026-07-31 — Wave 15: full keyword re-assignment per Keyword_Assignment_SOP v1.1 (supersedes Wave 14)

`eywa-protocol-spec/Keyword_Assignment_SOP_v1_0.md` (universal, locked 2026-07-28, field-tested on VTH) post-dates Wave 14. Audited Wave 14 against it — **failed multiple hard rules**: 16 service pages held `X ราคา` as primary (§8.3 กฎเหล็ก), 146 pages over the semantic cap (max 89 vs 8–15, §6.3), 655 pages null-target with no `flag_review` (§3/§6.4.4), 0/67 `viability_assessment` logged (§11), no intent×page-type gate (§5), no relevance ladder. Wave 14's method (1 top-priority kw per entity → anchor + dump the rest as semantic on every sibling) is not the SOP method. Operator approved a full rebuild + reuse of the existing per-service price pages (operator: brands may position slightly differently, same principle — SOP §8 model adapted, no new §8.10 hub since 5.13 cost-hub + 13 per-service price pages already exist in R26).

**Engine** (`26_matcher.py` → generates `26_keyword_reassign_sop.sql`): page-driven injective greedy per entity. Page roles by page_type (knowledge/local/brand) then name (price) then service; brand→price→service→knowledge→local processing order so hubs claim the entity HEAD term and price pages claim `X ราคา`. Eligibility gates: §8.3 (non-price page never takes `X ราคา` primary), §9 (local needs geo, geo reserved to local), §6 (knowledge = informational only), §4 blacklist B3-year/B6-cheap/B10-forum never primary. Head-ness by char length (Thai no-space compounds fool token count — SOP L13). Semantics capped 8–15/10/6 by role, each kw semantic on ≤3 pages, never a primary elsewhere (Q7). `viability_assessment` built DB-side from the live snapshot. v0 primaries carry `viability.v0_note='dfs_blank_awaiting_gsc'` (§7/L8); brand-entity v0 → `keyword_use_as='brand_nav'`.

**Result:** 350 primaries (was 67) · 372 pages `flag_review='kw-none'` (supply < demand — dental-implant alone = 108 pages / 89 kw; SOP §3/L2 = leave empty + flag, never force-fill) · 105 pages with capped semantics (max 14) · 350 viability logged · price routing verified (3.4.1.4←`ขูดหินปูน ราคา` v15350, hub 3.4.1←`ขูดหินปูน` v12325; 3.2.4←`รากฟันเทียม ราคา`; home←`สไมล์สเคป`). **307 of 350 primaries are v0** — expected: Thai long-tail mostly returns DFS-blank (L8), relevance-first keeps them (DR-022).

**QA gates §10 — all pass:** Q1 dup 0 · Q2 blacklist-primary 0 · Q3 knowledge-commercial 0 · Q4 local-no-geo 0 · Q6 v0-unflagged 0 · Q7 primary-as-semantic 0 · semantic-kw->3-pages 0.

**Deferred (noted, not auto-done):** R2/R3 fallback for the 372 kw-none pages (SOP §3 optional; deliberately not force-filled per L2) · SERP-overlap §8.3 verification (SmileScape has no own SERP; §8.2/8.3 policy default applied) · Q8 cannibalization (needs SERP). Backup for revert: `_ss_kw_backup_wave14` / `_ss_kwrow_backup_wave14`.
