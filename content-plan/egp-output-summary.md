# SmileScape Dental Clinic — EGP Output Summary (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis) — COMPLETE
> **Date:** 2026-05-12
> **Bible ref:** v3.15 Part 2.6 — Entity Genesis Protocol (EGP)
> **Schema ref:** v1.11 (37 tables — DR-024 ext + DR-025 Local SEO restored)
> **Handover ref:** v1.9 §7.4 — Phase C Deliverables
> **DR snapshot:** Locked DR-001..018 + DR-024 + DR-025 / Proposed DR-013/014/019/020/021/022

---

## Output File Index

| File | Status | Description |
|------|--------|-------------|
| `clusters.md` | ✅ DONE | 15 clusters across 7 domains |
| `entities.md` | ✅ DONE | 83 entities, 12-column schema, types per Bible Appendix A.1 |
| `relationships.md` | ✅ DONE | 101 edges, 10 edge types, slug-based |
| `branches.md` | ✅ DONE | 2 branches per Schema v1.11 §3.2 — `seo_branches` ~40 cols (DR-025) |
| `reviews.md` | ✅ SKELETON | Per Schema v1.11 §3.5 — `seo_reviews` (Flow E1 ingest at Stage 1.5) |
| `directory-listings.md` | ✅ SKELETON | Per Schema v1.11 §3.6 — `seo_directory_listings` (~50/branch, Flow E3 audit) |
| `gbp-posts.md` | ✅ SKELETON | Per Schema v1.11 §3.7 — `seo_gbp_posts` (~40 posts/yr seed, Flow E2/E4) |
| `egp-output-summary.md` | ✅ DONE | This file |

> **Stage 1.5 entity extension binding (DR-024):** Condition entities (14) → `seo_entity_condition` (ICD-10 already in entities.md, SNOMED/MeSH/prevalence_thailand populated at flat-load). Product (9) → `seo_entity_product`. Anatomy (6) → `seo_entity_anatomy` (FMA/UBERON IDs added at flat-load). Organization (3) → `seo_entity_organization`. No Phase C schema change required.

---

## Domain Coverage

| Domain ID | Domain Name | Clusters | Entities | Brand Scope |
|-----------|-------------|----------|----------|-------------|
| A | Dental Implant | 4 | 24 | ['*'] |
| B | Bone Regeneration | 2 | 11 | ['*'] mixed |
| C | Full-Arch Rehabilitation | 1 | 6 | ['*'] |
| D | Aesthetic & Cosmetic | 1 | 6 | ['*'] |
| E | Orthodontics | 1 | 5 | ['*'] mixed |
| F | Periodontics & Gum | 2 | 9 | ['*'] mixed |
| G | Cross-Cutting | 4 | 22 | ['*'] + ['smile-scape'] |
| **Total** | — | **15** | **83** | — |

---

## Entity Type Distribution (Bible Appendix A.1 15-Type Master List)

| Type | Count | % | Key Entities |
|------|-------|---|---|
| Treatment | 21 | 26% | dental-implant, all-on-x, all-on-4, overdenture, clear-aligner |
| Procedure | 18 | 22% | guided-bone-regeneration, sausage-technique, digital-implant-planning, sinus-lift |
| Condition | 14 | 17% | tooth-loss, alveolar-bone-loss, periodontitis, peri-implantitis, malocclusion |
| Product | 9 | 11% | blue-diamond-implant, osstem-implant, straumann-implant, titanium, zirconia |
| Concept | 6 | 7% | osseointegration, ortho-implant-sequencing, smile-dna, family-standard, lifetime-implant-warranty |
| Anatomy | 6 | 7% | alveolar-bone, mandible, maxilla, maxillary-sinus, peri-implant-mucosa |
| Device | 5 | 6% | cbct-3d-scan, surgical-guide, intraoral-scanner, cad-cam, ptfe-membrane |
| Organization | 3 | 4% | smilescape-dental-clinic, smilescape-rattanathibet, smilescape-srinakarin |
| Person | 1 | 1% | dr-woraphat-jarangkul |
| **Total** | **83** | **100%** | — |

> All types from the spec 15-type master list (`condition` / `symptom` / `procedure` / `treatment` / `device` / `concept` / `product` / `drug` / `ingredient` / `anatomy` / `specialty` / `lab_test` / `biomarker` / `person` / `organization`). Unused for SmileScape: Symptom, Drug, Ingredient, Specialty, Lab_test, Biomarker.

---

## Brand Scope Split

| Scope | Entities | % | Notes |
|-------|----------|---|-------|
| ['*'] — Universal | 71 | 86% | Reusable across all EYWA dental brands |
| ['smile-scape'] — Brand-specific | 12 | 14% | SmileScape-only: Blue Diamond, Sausage Technique, Soft Tissue Management, TrioClear, Damon, SmileScape Clinic + 2 branches (รัตนาธิเบศร์, ศรีนครินทร์), Dr. Woraphat, SMILE DNA, Family Standard, Lifetime Warranty |

---

## Relationship Coverage

| Edge Type | Count | % |
|-----------|-------|---|
| parent_of | 34 | 34% |
| treats | 15 | 15% |
| uses | 15 | 15% |
| related_to | 11 | 11% |
| part_of | 8 | 8% |
| alternative_to | 7 | 7% |
| requires_assessment | 5 | 5% |
| symptom_of | 3 | 3% |
| evidenced_by | 2 | 2% |
| subtype_of | 1 | 1% |
| **Total** | **101** | **100%** |

- Bidirectional edges: 18 (18%)
- Entity coverage: 80/83 (96.4%) — 3 orphans accepted (teeth-whitening, dental-filling, immediate-loading)
- All From/To columns use entity slug per §5.6 spec

---

## ICD-10 Coverage

| ICD-10 Code | Condition | Count |
|-------------|-----------|-------|
| K08.409 | Partial tooth loss, unspecified | 2 entities |
| K08.101 | Complete tooth loss, unspecified | 1 entity |
| K06.3 | Alveolar bone loss | 3 entities (parent + 2 subtypes) |
| K05.10 | Chronic gingivitis | 1 entity |
| K05.30 | Chronic periodontitis | 1 entity |
| K06.010 | Gingival recession | 1 entity |
| M27.62 | Peri-implantitis (post-osseointegration biological failure) | 1 entity |
| M26.4 | Malocclusion | 2 entities |
| K02.9 | Dental caries, unspecified | 2 entities |
| K04.0 | Pulpitis | 1 entity |
| K01.1 | Embedded teeth | 1 entity |
| S02.5XXA | Fracture of tooth, initial encounter | 1 entity |
| — (no ICD-10) | Non-disease entities | 56 entities |

---

## Pillar-Cluster Mapping Check

| Pillar | Cluster(s) Linked | Primary Entity |
|--------|-------------------|----------------|
| 3.2 | dental-implant-core | dental-implant |
| 3.2.9 | bone-regeneration-gbr | guided-bone-regeneration |
| 3.2.9.3 | bone-regeneration-gbr | sausage-technique |
| 3.2.9.7 | gum-soft-tissue | soft-tissue-management |
| 3.3 | all-on-x-full-arch | all-on-x |
| 3.4 | smile-design-cosmetic | digital-smile-design |
| 3.5 | clear-aligner-orthodontics | clear-aligner |
| 3.6 | general-restorative | root-canal-treatment |
| 3.7 | periodontics-perio-disease | periodontitis |
| 4.5 | implant-systems-brands, implant-materials | blue-diamond-implant, titanium |
| 5.1 | patient-conditions-tooth-loss | tooth-loss |
| 5.2 | patient-conditions-bone | alveolar-bone-loss |
| 3.1 | digital-technology-diagnostics | cbct-3d-scan |
| — | dental-anatomy | alveolar-bone |
| 2.1 | brand-doctor-authority | smilescape-dental-clinic |

---

## Local SEO Summary (Branches)

| Branch Slug | Display Name | City | Sitemap Hub | Transit | Schema.org | Data Status |
|-------------|--------------|------|-------------|---------|------------|-------------|
| smilescape-rattanathibet | SmileScape สาขารัตนาธิเบศร์ | นนทบุรี | 8.2 | MRT สีม่วง | Dentist + LocalBusiness | TBD (address/GPS/phone) |
| smilescape-srinakarin | SmileScape สาขาศรีนครินทร์ | กรุงเทพฯ | 8.3 | MRT สีเหลือง | Dentist + LocalBusiness | TBD (address/GPS/phone) |

**Branch coverage:**
- 2 Organization-type entities + 2 `part_of` edges → smilescape-dental-clinic
- 5 geo-keyword pages already in sitemap section 8.2 + 5 in section 8.3
- T18 Programmatic Local matrix (5 hero services × 2 branches = 10 candidate pages) seeded in `branches.md`, awaiting DataForSEO volume validation

> Full schema per `seo_brand_branches` (Schema_Overview §3.2) — see `branches.md` for address/GPS/phone collection and schema:LocalBusiness templates.

---

## Signature System Summary (SmileScape Differentiators)

| Signature System | Slug | Authority Source | Citation Anchor |
|-----------------|------|-----------------|-----------------|
| Blue Diamond Implant System | blue-diamond-implant | Korean implant manufacturer | P1-C1 (category evidence) |
| Sausage Technique | sausage-technique | Dr. Urban — HU Berlin | P2-C2, P2-C3 (Urban 2009, 2016) |
| Soft Tissue Management | soft-tissue-management | Dr. Kern — ILAPEO Brazil | P5-C1 (Benic 2014) |
| Lifetime Implant Warranty | lifetime-implant-warranty | SmileScape internal policy | — |

---

## EUG Pre-flight Checklist (Stage 1.5)

To run before flat-load to Supabase:

**Entity Graph (Stage 1.5 step 2 — Entity Genesis flat-load):**

- [ ] `eug_preflight_check()` — slug uniqueness across all 83 entities
- [ ] Branch slug uniqueness — `smilescape-rattanathibet` + `smilescape-srinakarin` across federation
- [ ] Cross-federation collision check: `dental-implant`, `clear-aligner`, `all-on-x` (universal slugs)
- [ ] ICD-10 code deduplication: K06.3 appears on 3 entities — verify intentional (parent + subtypes)
- [ ] M26.4 appears on 2 entities (clear-aligner + malocclusion) — verify intentional
- [ ] brand_scope=['smile-scape'] entities: confirm 12 entities not in federation universal pool
- [ ] Confirm `smilescape-dental-clinic` uses schema:additionalType = MedicalBusiness + MedicalClinic

**Entity Extensions (Stage 1.5 step 3 — DR-024 binding):**

- [ ] `seo_entity_condition` — populate 14 Condition rows (SNOMED CT, MeSH, prevalence_thailand[], severity_levels[], symptoms[], related_anatomy_fps[], treatment_drugs_fps[], treatment_procedures_fps[], affected_age_groups[])
- [ ] `seo_entity_product` — populate 9 Product rows (Blue Diamond, Osstem, Straumann, TrioClear, Damon + materials)
- [ ] `seo_entity_anatomy` — populate 6 Anatomy rows (FMA ID, UBERON ID, body_system='digestive/skeletal', parent_anatomy_fp hierarchy, affected_by_conditions_fps[])
- [ ] `seo_entity_organization` — populate 3 Organization rows (1 clinic + 2 branches with Wikidata Q-numbers, sameAs cross-refs)

**Local SEO Tables (Stage 1.5 step 3 — DR-025 binding):**

- [ ] `seo_branches` — 2 rows from `branches.md` (~40 cols, operator data required: address/GPS/phone/GBP/wongnai/medical_license_no)
- [ ] `seo_reviews` — empty initial; Flow E1 first run after `gbp_place_id` set
- [ ] `seo_directory_listings` — pre-seed ~10 Tier 1 rows (2 branches × 5 directories) with `status='pending'`
- [ ] `seo_gbp_posts` — empty initial; campaign calendar drafted in `gbp-posts.md` (Phase F)

---

## Phase C → Phase D Handover Notes

**What Phase D (Content Brief) needs from Phase C:**
1. Primary Entity column in `sitemap.md` — to be filled by matching pillar pages to entity slugs
2. Citation-to-entity linking — 11 citations in `citation-pool-seed.md` (P1-C1 through P5-C1) become entity nodes in Phase D graph expansion
3. `evidenced_by` edges will expand from 2 → ~20 once citation entities are created
4. `keyword-seed-list.md` keyword clusters (C1–C16) should map to entity slugs in `entities.md` — done at brief-writing stage
5. Orphan entities (Teeth Whitening, Dental Filling) — assign supporting content briefs in Phase D

**Operator action items before Stage 1.5:**
- Fill brand-config.json TBD fields (founding year, address, phone, social media handles)
- Compile Tier-5 internal case data for citation-pool-seed.md (clinic case series)
- Verify Blue Diamond Implant System product specs (warranty terms, exact model names)
- Confirm Dr. Woraphat Jarangkul credentials (graduation year, Mahidol medal details)

---

*Phase C complete. 4 files delivered. Ready for Stage 1.5 EUG preflight → Supabase flat-load. Per Handover §7.4 + Bible Part 2.6.*
