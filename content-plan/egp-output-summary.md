# SmileScape Dental Clinic — EGP Output Summary (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis) — COMPLETE + Round 2 expansion 2026-05-21
> **Date:** 2026-05-12 (initial) / 2026-05-21 (Round 2)
> **Bible ref:** v3.19 Part 2.6 — Entity Genesis Protocol (EGP)
> **Schema ref:** v1.15 (37 tables — DR-024 ext + DR-025 Local SEO restored)
> **Handover ref:** v1.13 §7.4 — Phase C Deliverables
> **DR snapshot:** Locked DR-001..025 / Proposed DR-026, DR-027 / Brand-specific SS-DR-001..007

---

## Output File Index

| File | Status | Description |
|------|--------|-------------|
| `clusters.md` | ✅ DONE (R2 expanded) | 18 clusters across 8 domains (+3 specialty clusters in R2: pediatric / endo / anesthesia) |
| `entities.md` | ✅ DONE (R2 expanded) | 131 entities, 12-column schema, types per Bible Appendix A.1 (+48 in R2) |
| `relationships.md` | ✅ DONE (R2 expanded) | 151 edges, 10 edge types, slug-based (+50 in R2) |
| `branches.md` | ✅ DONE | 2 branches per Schema v1.15 §3.2 — `seo_branches` ~40 cols (DR-025) |
| `reviews.md` | ✅ SKELETON | Per Schema v1.15 §3.5 — `seo_reviews` (Flow E1 ingest at Stage 1.5) |
| `directory-listings.md` | ✅ SKELETON | Per Schema v1.15 §3.6 — `seo_directory_listings` (~50/branch, Flow E3 audit) |
| `gbp-posts.md` | ✅ SKELETON | Per Schema v1.15 §3.7 — `seo_gbp_posts` (~40 posts/yr seed, Flow E2/E4) |
| `egp-output-summary.md` | ✅ DONE | This file |

> **Stage 1.5 entity extension binding (DR-024):** Condition entities (14) → `seo_entity_condition` (ICD-10 already in entities.md, SNOMED/MeSH/prevalence_thailand populated at flat-load). Product (9) → `seo_entity_product`. Anatomy (6) → `seo_entity_anatomy` (FMA/UBERON IDs added at flat-load). Organization (3) → `seo_entity_organization`. No Phase C schema change required.

---

## Domain Coverage (Round 2)

| Domain ID | Domain Name | Clusters | Entities | Brand Scope |
|-----------|-------------|----------|----------|-------------|
| A | Dental Implant | 4 | 24 | ['*'] (Neodent replaced Osstem in R2) |
| B | Bone Regeneration | 2 | 16 | ['*'] mixed (+5 in R2: densah-bur, osseodensification, internal-sinus-lift, lateral-window-sinus-lift, rpm-membrane) |
| C | Full-Arch Rehabilitation | 1 | 6 | ['*'] |
| D | Aesthetic & Cosmetic | 1 | 6 | ['*'] |
| E | Orthodontics | 1 | 7 | ['*'] mixed (+2 in R2: orthognathic-surgery, passive-self-ligating) |
| F | Periodontics & Gum | 2 | 18 | ['*'] mixed (+9 in R2: strip-graft, ice-berg, garage, vipct, caf, tunneling, vista, tcaf, black-triangle) |
| G | Cross-Cutting | 4 | 26 | ['*'] + ['smile-scape'] (+4 in R2: acteon-cbct, trios, airflow, cool-light-unit) |
| H | Specialty Services | 3 | 21 | ['*'] (NEW in R2: pediatric-dentistry 10 + endodontics-specialist 7 + dental-anesthesia 4) |
| **Total** | — | **18** | **131** (was 83) | — |

**Plus +3 entities into general-restorative cluster:** torus-removal, alveoloplasty, tuberectomy (R2)

---

## Entity Type Distribution (Round 2 — Bible Appendix A.1 15-Type Master List)

| Type | Count | % | Key Entities |
|------|-------|---|---|
| Treatment | 32 | 24% | dental-implant, all-on-x, clear-aligner, pediatric-dentistry, pediatric-crown, fluoride-treatment, internal-bleaching |
| Procedure | 44 | 34% | sausage-technique, osseodensification, internal-sinus-lift, strip-graft, ice-berg, garage, caf, tunneling, vista, tcaf, vipct, orthognathic-surgery, apicoectomy, conscious-sedation, ga-dentistry, torus-removal, alveoloplasty |
| Condition | 16 | 12% | tooth-loss, alveolar-bone-loss, periodontitis, peri-implantitis, malocclusion, black-triangle, cracked-tooth, dental-anxiety |
| Product | 9 | 7% | blue-diamond-implant, neodent-implant (was osstem), straumann-implant, titanium, zirconia, trioclear, damon-system, bone-graft-substitute |
| Concept | 7 | 5% | osseointegration, ortho-implant-sequencing, smile-dna, family-standard, lifetime-implant-warranty, passive-self-ligating, behavior-management |
| Anatomy | 6 | 5% | alveolar-bone, mandible, maxilla, maxillary-sinus, peri-implant-mucosa, keratinized-mucosa |
| Device | 13 | 10% | cbct-3d-scan, acteon-cbct, intraoral-scanner, trios-intraoral-scanner, surgical-guide, cad-cam, ptfe-membrane, rpm-membrane, densah-bur, airflow-air-polishing, cool-light-whitening-unit, endodontic-microscope, space-maintainer, habit-appliance, rotary-endodontic-system |
| Organization | 3 | 2% | smilescape-dental-clinic, smilescape-rattanathibet, smilescape-srinakarin |
| Person | 1 | 1% | dr-woraphat-jarangkul |
| **Total** | **131** | **100%** | — |

> All types from the spec 15-type master list (`condition` / `symptom` / `procedure` / `treatment` / `device` / `concept` / `product` / `drug` / `ingredient` / `anatomy` / `specialty` / `lab_test` / `biomarker` / `person` / `organization`). Unused for SmileScape: Symptom, Drug, Ingredient, Specialty, Lab_test, Biomarker.

---

## Brand Scope Split (Round 2)

| Scope | Entities | % | Notes |
|-------|----------|---|-------|
| ['*'] — Universal | 110 | 84% | Reusable across all EYWA dental brands (incl. R2: pediatric / endo / anesthesia + classic soft tissue techniques + general procedures) |
| ['smile-scape'] — Brand-specific | 21 | 16% | SmileScape-only: Blue Diamond, Neodent (R2), Sausage Technique, Strip Graft / Ice Berg / Garage (R2 Urban signatures), Densah Bur / Osseodensification / Internal Sinus Lift (R2 Huwais signature), Soft Tissue Management, TrioClear, Damon, Acteon CBCT (R2), 3Shape TRIOS (R2), Cool Light Whitening (R2), SmileScape Clinic + 2 branches, Dr. Woraphat, SMILE DNA, Family Standard, Lifetime Warranty |

---

## Relationship Coverage (Round 2)

| Edge Type | Count | % |
|-----------|-------|---|
| parent_of | 48 | 32% |
| treats | 28 | 19% |
| uses | 26 | 17% |
| related_to | 23 | 15% |
| part_of | 10 | 7% |
| alternative_to | 7 | 5% |
| requires_assessment | 5 | 3% |
| subtype_of | 5 | 3% |
| evidenced_by | 8 | 5% |
| symptom_of | 3 | 2% |
| **Total** | **151** (+50 in R2) | **100%** |

- Bidirectional edges: 28 (19%)
- Entity coverage: 125/131 (95.4%) — 6 orphans accepted (teeth-whitening, dental-filling, immediate-loading, behavior-management, torus-removal, alveoloplasty, tuberectomy — phase D wiring)
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

## Signature System Summary (SmileScape Differentiators — Round 2)

| Signature System | Slug | Authority Source | Citation Anchor |
|-----------------|------|-----------------|-----------------|
| Blue Diamond Implant System | blue-diamond-implant | Korean implant manufacturer | P1-C1 (category evidence) |
| Sausage Technique | sausage-technique | Dr. Istvan Urban — HU Berlin | P2-C2, P2-C3 (Urban 2009, 2016) |
| Soft Tissue Management (Urban + Kern) | soft-tissue-management | Dr. Kern (Brazil) + Dr. Urban (Hungary) | P5-C1 (Benic 2014) + Urban masterclass — Strip Graft / Ice Berg / Garage |
| **Internal Sinus Lift with Densah Bur (Osseodensification)** 🆕 | internal-sinus-lift-densah | Dr. Salah Huwais (Versah USA) | Huwais 2017+ (Osseodensification evidence base — P-Huwais entry) |
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

*Round 2 expansion (2026-05-21) — +3 clusters / +48 entities / +50 edges. SmileScape now has 5 signature offerings (added Densah/Osseodensification). Sitemap ~525 pages (was 414). Awaiting operator confirmation on Dr. Woraphat Versah training credential before locking Section 2.2.2 Densah authority anchor.*

*Round 3 expansion (2026-05-21) — DFS-informed batch. +8 entities (zero-bone-loss-concept, dr-tomas-linkevicius, gold-crown, peri-implantitis-treatment, implantoplasty, regenerative-peri-implantitis-surgery, resective-peri-implantitis-surgery, dental-laser-therapy) / +20 edges. Total: 18 clusters / 139 entities / 171 edges. **Zero Bone Loss added as clinical_protocols[0]** in brand-config (Brand Framework — separate from signature_offerings because ZBL = philosophy/protocol, not named-technique). DFS-validated additions: Peri-Implantitis service (140/mo TH), Gold Crown (320/mo TH), ขูดหินปูน cluster expansion (12,100/mo TH LOW competition — Round 3 traffic discovery). Sitemap ~544 pages (was 525 at R2). Pending: หมอแฮม Linkevicius training credential confirmation.*

*Round 4 expansion (2026-05-21) — Q-Clinic SSO Cluster. **+1 cluster** (insurance-coverage-th under new Domain I: Insurance & Access) / **+5 entities** (social-security-dental-benefit, sso-direct-billing-q-clinic [brand-scope smile-scape], universal-coverage-th, civil-servant-dental-benefit, private-dental-insurance-th) / **+13 edges**. Total: **19 clusters / 144 entities / 184 edges**. **Q-Clinic Direct Billing confirmed** (R4 operator decision) → "ไม่ต้องสำรองจ่าย" hero positioning. brand-config.json v1.5→v1.6 + `insurance_acceptance` block added. DFS findings: local intent strong (จังหวัด-specific clinic searches), Q-Clinic terminology hot, annual cap 900/1,200 baht awareness high. Sitemap ~569 pages (was 544 at R3). Pending: บัตรทอง + ราชการ direct billing acceptance confirmation + annual cap year verification.*
