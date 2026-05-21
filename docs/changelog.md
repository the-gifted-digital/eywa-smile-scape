# SmileScape Brand Repo — Changelog

## [2026-05-21 EVE] — Round 4 Q-Clinic SSO Cluster (Insurance & Access)

**By:** Operator-driven request "อยากให้มีเรื่องราวทุกมุมเกี่ยวกับประกันสังคม" + DFS reconnaissance
**Files updated:**
- `brand-config.json` — v1.5 → v1.6. Added `insurance_acceptance` block. **SSO Q-Clinic = TRUE (operator confirmed)** — direct billing, patient ไม่ต้องสำรองจ่าย. Annual cap 900 baht (operator to verify if 1,200 updated cap applies). Denture caps 1,500-4,400 baht/5yr by type. บัตรทอง / ราชการ acceptance TBD.
- `content-plan/clusters.md` — 18 → 19 clusters / 8 → 9 domains. NEW Domain I: Insurance & Access. NEW cluster: `insurance-coverage-th`.
- `content-plan/entities.md` — 139 → 144 entities (+5 R4). New Concept entities: `social-security-dental-benefit`, `sso-direct-billing-q-clinic` (brand-scope ['smile-scape'] = SmileScape's Q-Clinic differentiator), `universal-coverage-th` (บัตรทอง), `civil-servant-dental-benefit` (ราชการ/CGA), `private-dental-insurance-th`.
- `content-plan/relationships.md` — 171 → 184 edges (+13 R4). U section: Q-Clinic → SmileScape brand + branches (smilescape-rattanathibet + smilescape-srinakarin), SSO covers scaling/filling/extraction/wisdom-tooth/denture, alternative_to bait + civil servant + private, related_to dental-implant (upsell pathway — NOT covered).
- `content-plan/sitemap.md` — ~544p → ~569p (+25 R4). **Block R (3.12 SSO Service Hub):** +6 pages — hero positioning around Q-Clinic direct billing (3.12.2 Tier B). **Block S (5.13 expansion):** +13 pages — 10-page SSO sub-hub (900 บาท cap / scaling-filling-extraction / dentures / wisdom tooth / vs บัตรทอง / unemployment scenarios / ม.33-39-40 / family coverage / how-to-reimburse / Q-Clinic explainer) + ราชการ + private insurance + tax deduction. **Block T (Branch SSO 8.2.6 + 8.3.6):** +2 pages — local SSO landing for รัตนาธิเบศร์ + ศรีนครินทร์ branches. **Block U (Section 6 Insights):** +4 pages — 6.2.7 Insurance Insights ×3 (overview / Q-Clinic explainer / receipt requirements) + 6.5.5 SSO FAQ.
- `content-plan/egp-output-summary.md` — Round 4 expansion note + recount.
- `docs/changelog.md` — this entry.
- `README.md` — page count 544 → ~569 + pending operator: บัตรทอง/ราชการ acceptance + annual cap verification.

**DFS reconnaissance findings (Round 4):**
- ⭐ **คลินิก ทำฟัน ประกันสังคม [city]** — multi-city long-tail pattern (10-30/mo each in ลพบุรี/ลำปาง/ภูเก็ต/ดอนเมือง) → confirms branch-level SSO pages capture local intent
- ⭐ **ทำฟัน ประกันสังคม ไม่ต้องสำรองจ่าย** — high-intent navigational keyword → critical Q-Clinic positioning differentiator
- 📊 **ประกันสังคม 900** — 110/mo TH LOW competition (with declining trend May 2025 480 → Apr 2026 20 suggesting recent cap change awareness)
- 📊 **ประกันสังคม ทำฟัน ปลอมได้ไหม** — 30/mo TH commercial intent → denture coverage page priority
- 📊 **ประกันสังคม ทำฟัน 1200** — 10/mo transactional → cap year referenced in new cap or specific procedure cost
- 📊 **มีประกันสังคม ใช้บัตรทอง ทำฟัน ได้ไหม** — 10-30/mo → cross-coverage education opportunity
- 📊 **สามีข้าราชการ ภรรยาประกันสังคม ทำฟัน** — 10/mo → family/spousal coverage long-tail
- 📊 **ว่างงาน เบิกค่าทำฟัน ประกันสังคม** — active intent → ม.39 unemployment scenarios

**Strategic frame (Round 4):**
- **Q-Clinic positioning** = key differentiator most clinics either don't advertise or don't qualify for. SmileScape captures booking signal directly.
- Educational long-tail (5.13.2.1-10) builds topical authority + AI citation surface for "ประกันสังคมทำฟัน" Knowledge Graph
- **Conversion bridge** — Section 3.12.5 explicit upsell pathway "ทำพื้นฐานด้วยประกัน + ต่อยอด Implant/Aesthetic" — turns SSO entrants into premium service candidates
- Cross-coverage content (vs บัตรทอง / vs ราชการ / vs ประกันชีวิต) = unique angle, low competition

**Pending operator actions (added Round 4):**
- บัตรทอง / 30 บาท — SmileScape acceptance status + billing modality (affects 5.13.2.5 content)
- ราชการ / CGA (กรมบัญชีกลาง) — direct billing capability (affects 5.13.5)
- Private insurance — accepted insurer list (AIA / Cigna / Allianz / Muang Thai / etc.) (affects 5.13.6)
- Annual SSO cap verification — 900 vs 1,200 บาท (2026 status — affects 5.13.2.1 main content)
- Q-Clinic registration number (สำหรับ verify ที่หน้า website)

---

## [2026-05-21 PM] — Round 3 DFS-Informed Expansion (Peri-Implantitis Service + Gold Crown + ZBL Framework + Scaling Goldmine)

**By:** Operator-driven batch + DFS reconnaissance (4 batches, ~30 keywords TH locale)
**Files updated:**
- `brand-config.json` — v1.4 → v1.5. Added `clinical_protocols[0]` Zero Bone Loss Concept (Tomas Linkevicius framework — separate from signature_offerings per SS-DR-008). Extended `specialty_focus` with peri_implantitis_treatment, pediatric_dentistry, endodontics_specialist, sedation_dentistry (reflects R2 service additions).
- `content-plan/entities.md` — 131 → 139 entities (+8 R3). New: zero-bone-loss-concept (Concept, brand-scope smile-scape), dr-tomas-linkevicius (Person, external authority), gold-crown (Treatment — DFS 320/mo TH validated), peri-implantitis-treatment (Procedure), implantoplasty (Procedure), regenerative-peri-implantitis-surgery (Procedure), resective-peri-implantitis-surgery (Procedure), dental-laser-therapy (Procedure).
- `content-plan/relationships.md` — 151 → 171 edges (+20 R3). T1: ZBL Brand Framework edges (9) — evidenced_by Linkevicius, related_to dental-implant/warranty/SMILE-DNA/Family-Standard/keratinized-mucosa, dr-woraphat→ZBL+Linkevicius. T2: Peri-Implantitis Service edges (9). T3: Gold Crown edges (2).
- `content-plan/sitemap.md` — ~525p → ~544p (+19 R3). **Block N (Peri-Implantitis Service 3.7.7):** +10p hub + 9 sub-pages (Diagnosis / Non-surgical / Surgical / Regenerative / Resective / Implantoplasty / Laser / Decision tree / Maintenance) — DFS-validated 140/mo TH. **Block O (Gold Crown 3.4.4.4):** +2p (service page + 6.2.4.13 comparison) — DFS-validated 320/mo TH LOW competition. **Block P (Zero Bone Loss Framework):** +2p (2.1.6 brand framework page + 6.4.14 Linkevicius evidence summary) — DFS confirms low direct volume (20/mo), used as E-E-A-T anchor not traffic target. **Block Q (ขูดหินปูน cluster expansion 3.6.1):** +5p long-tail pages — DFS-discovered 12,100/mo TH LOW competition (R3 traffic goldmine). Plus header counts updated + Section 6 master structure recalc.
- `content-plan/egp-output-summary.md` — Round 3 expansion note + updated final tally (18 clusters / 139 entities / 171 edges / 5 signature offerings + 1 clinical protocol).
- `docs/decision-records.md` — Added **SS-DR-008** Zero Bone Loss Concept as Brand Clinical Framework (vs Signature Offering — operator decision). Rationale: ZBL = philosophy/approach, not a named procedure/technique like Sausage/Densah/Soft Tissue.
- `README.md` — page count 525 → ~544. Added pending operator: หมอแฮม Linkevicius training credential.
- `docs/changelog.md` — this entry.

**DFS reconnaissance findings (Round 3):**
- ✅ **peri-implantitis** 140/mo TH LOW competition → justifies dedicated service hub
- ✅ **gold crown** 320/mo TH LOW (CPC 6.75) → validates dedicated page (English term dominates; Thai variants returned no DFS data)
- ✅ **zero bone loss concept** 20/mo TH MEDIUM → confirms E-E-A-T anchor not traffic target
- ✅ **acteon** 90/mo TH LOW (CPC 1.88) → R2 brand-anchor approach validated
- 🎯 **ขูดหินปูน** 12,100/mo TH LOW (CPC 0.43) → MAJOR cluster opportunity discovered → Block Q added (5 long-tail pages)
- 📊 **ฟอกสีฟัน** 3,600/mo TH HIGH (89) → R2 Cool Light positioning validated as competitive niche
- 📊 **airflow** 1,600/mo TH LOW → ambiguous keyword (multi-meaning), R2 placement holds
- ⚠️ Many Thai service phrases returned NULL data (likely <50/mo OR DFS gap) — does not necessarily mean zero demand

**Strategic frame (Round 3):**
- ZBL chose Brand Framework over Signature Offering #6 — preserves meaning of "signature technique" (named procedures). ZBL joins SMILE DNA + Family Standard as brand triad.
- ขูดหินปูน goldmine discovery shows DFS-informed planning value before Phase next full DFS batch.
- Authority anchors (Urban / Huwais / Linkevicius / Kern) all in place — SmileScape "Global Mastery" claim now has 4 referenceable masters supporting Dr. Woraphat's credentials.

**Pending operator actions (added Round 3):**
- หมอแฮม Linkevicius training credential / Zero Bone Loss textbook ownership (for Section 2.2.2 + brand-config clinical_protocols[0] anchor)
- Peri-Implantitis specialist credential (if Periodontist on team)
- Gold crown supplier / lab confirmation (which gold alloy: noble/high-noble/PFM)

---

## [2026-05-21] — Round 2 Sitemap Expansion + Section 6 Restructure + Densah Signature

**By:** Operator-driven batch (10-point feedback + technique deep-dive + Section 6 restructure)
**Files updated:**
- `content-plan/sitemap.md` — ~414p → ~525p (+111). Added Section 3.9 Pediatric (13p), 3.10 Sedation/GA (8p), 3.11 Endo Specialist (10p). Expanded 3.2.9.4 Sinus Lift with Densah (+2), 3.2.9.5 Ridge Aug with RPM (+2), 3.2.9.7 Soft Tissue D-2 Hybrid (+13: 3 sub-hubs + 10 standalone Urban + named techniques), 3.4.7 Whitening with Cool Light (+3), 3.5.3 PSL clarification (+4), 3.5.8 Orthognathic Surgery (+9), 3.6.1 Scaling with Airflow (+3), 3.8.6 Torus Removal/Alveoloplasty (+5). Section 2.2 added Endo + Pediatric teams (+2). Section 4 rebrand: 4.2.1 → Acteon CBCT, 4.2.2 → 3Shape TRIOS. Added 4.4.4 Densah Bur, 4.4.5 Airflow, 4.9 Cosmetic Tech / Cool Light unit. Section 5 added 5.1.8 tooth-loss urgency hook, 5.10.7-8 jaw asymmetry, 5.11.5-9 gum concern hooks → world-class soft tissue funnel. **Section 6 restructured** into 6 sub-sections per operator decision: 6.1 Clinical Guides (Pillar) / 6.2 Clinical Insights (long-tail SEO, 78p) / 6.3 Glossary / 6.4 Clinical Evidence & Research Summaries (NEW, 14p) / 6.5 FAQ Knowledge Hub (NEW, 5p) / 6.6 Case-based Learning (NEW, 10p) — total 121p L5.
- `brand-config.json` — v1.3 → v1.4. Implant brands: Osstem out, Neodent in (Brazil, Straumann Group, value_premium). Signature offering #5 added: Internal Sinus Lift with Densah (Osseodensification, Salah Huwais authority). Soft tissue signature note expanded to include Urban techniques.
- `content-plan/entities.md` — 83 → 131 entities (+48 in R2). +3 specialty clusters (pediatric-dentistry 10, endodontics-specialist 7, dental-anesthesia 4). +5 bone-regen entities (densah-bur, osseodensification, internal-sinus-lift, lateral-window-sinus-lift, rpm-membrane). +9 soft-tissue entities (strip-graft, ice-berg, garage, vipct, caf, tunneling, vista, tcaf, black-triangle). +4 tech entities (acteon-cbct, trios-intraoral-scanner, airflow-air-polishing, cool-light-whitening-unit). +2 ortho (orthognathic-surgery, passive-self-ligating). +3 oral surgery (torus-removal, alveoloplasty, tuberectomy). Osstem-implant removed → replaced by neodent-implant.
- `content-plan/clusters.md` — 15 → 18 clusters across 8 domains. New Domain H: Specialty Services (pediatric / endo / anesthesia).
- `content-plan/relationships.md` — 101 → 151 edges (+50). New parent_of hierarchies for specialty clusters. New uses edges for Densah/RPM/microscope. New evidenced_by edges anchoring Urban + Huwais authority. Osstem→Neodent edge swap.
- `content-plan/egp-output-summary.md` — recalc all counts (cluster 18, entity 131, edge 151), updated domain coverage + entity type distribution + signature systems summary (5 instead of 4 — added Densah).
- `docs/decision-records.md` — SS-DR-001 updated (Osstem out / Neodent in / 4-tier brand strategy). **SS-DR-007 added** (Densah/Osseodensification as Signature Offering #5).
- `README.md` — page count ~414 → ~525. Added operator pending action: Dr. Woraphat Versah training credential confirmation for Densah signature anchor.
- `docs/changelog.md` — this entry.

**Trigger:** Operator review of 414p sitemap → 10-point feedback (Osstem swap, Neodent add, pediatric coverage, airflow scaling, cool light whitening, 3Shape IOS, Acteon CBCT, orthognathic surgery, GA dentistry, endodontist specialist) + soft tissue technique deep-dive (Urban Strip Graft/Ice Berg/Garage + classic CAF/Tunneling/VISTA/TCAF/VIPCT) + bone regen RPM membrane + Densah/Osseodensification signature decision + tooth-loss urgency + PSL clarification + black triangle + gum funnel concerns + Section 6 restructure.

**Strategic frame:**
- D-2 Hybrid soft tissue (13 pages) selected after explicit thin-page vs authority-strength trade-off analysis — operator delegated decision per content-quality-can-sustain-page evaluation per technique.
- Densah promoted to Signature #5 — pending operator confirmation of หมอแฮม Versah training certificate / Huwais workshop attendance.

**Pending operator actions (added Round 2):**
- Dr. Woraphat Versah training / Huwais workshop credential (for Section 2.2.2 + brand-config.json signature #5 anchor)
- Pediatric Team / Endodontist Team specialist names + credentials (for Section 2.2.9 + 2.2.10)
- Verify Neodent brand inventory (which series — GM / Drive / Easy Cone)
- Verify 3Shape TRIOS model (TRIOS 5 / TRIOS 4 / TRIOS Move)
- Verify Acteon CBCT model (X-Mind Trium / X-Mind Prime)

## [2026-05-12 PM] — Spec Stack Paired Batch Lock (v3.19 / v1.15 / v1.5 LOCKED / v1.13 / v1.13)

**By:** EYWA Protocol paired batch lock — operator-approved early lock (99.99%-Google-aligned assessment)
**Files updated:**
- `brand-config.json` — `eywa_spec_snapshot` block bumped: Bible 3.15→3.19, Schema 1.11→1.15, Templates DRAFT v1.3→v1.5 LOCKED, Handover 1.9→1.13, DR 1.9→1.13. DR-013/014/019/020/021/022 moved from proposed→locked (prior opt-in DR-020/021/022 now formalized). DR-026 + DR-027 added as proposed.

**Trigger:** Spec commits 1d347a4 (DR-013), e8c502a (DR-014), efd09cc (DR-019/020/021/022 paired batch).

**Impact on SmileScape:** SmileScape was the Lean Phase B field test — DR-022 lock validates the pattern. Content_Templates LOCKED at v1.5 (T1-T22) formalizes the templates used in 414p sitemap. DR-021 internal linking schema now available for Stage 1.5 entry (12 page_master linking cols + seo_page_internal_links junction).

## [2026-05-10] — Repo Bootstrap

Initialized eywa-smile-scape brand repo with full structure mirroring VTH BioDent layout.

**Files created:**
- `README.md` — brand overview + folder map
- `brand-config.json` — federation config (v1.0)
- `docs/brand-concept.md` — synthesized brand identity v1.0 (~13 sections)
- `docs/decision-records.md` — 6 brand-specific DRs locked (SS-DR-001..006)
- `docs/changelog.md` — this file

**Files migrated from legacy:**
- `content-plan/sitemap.md` — 414p WIP (pending client feedback)
- `docs/source-concept.md` — operator's original concept (preserved)
- `docs/research-deep-dive.md` — research from April 2026
- `docs/master-example-peri-implantitis.html` — sample content reference
- `docs/seo-playbook-original.html` — earlier SEO playbook
- `theme/brand-assets/` — 3 logo files (primary transparent + secondary + scaled)

**Folder structure created:**
```
docs/{signature-programs/}
content-plan/{archive/}
content-drafts/{pillar-pages, supporting-pages, citations}/
theme/{brand-assets, custom-css, elementor-templates-overrides}/
deployment/{acf-overrides/}
multilingual/
reports/
```

**Stage status (per EYWA Handover v1.6):**
- Phase A (Brand Understanding): ✅ DONE — brand-concept.md complete
- Phase B (Research): 🟡 PARTIAL — research-deep-dive.md done, full KW pending DataForSEO
- Phase B.2 (Citation Pool Seeding): ❌ NOT STARTED
- Phase C (Entity Genesis): ❌ NOT STARTED
- Phase D (Cluster & Domain): ❌ NOT STARTED
- Phase E (Sitemap): 🟡 IN PROGRESS — 414p WIP, pending client feedback
- Stage 1 Gate: ❌ NOT REACHED
- Stage 1.5 Migration: ❌ NOT STARTED (blocked by DR-021 lock 2026-06-07)
- Stage 2 Content Production: ❌ NOT STARTED

**Pending operator actions:**
1. Client feedback on 414p sitemap
2. Doctor Praeo full credentials
3. Branch addresses + contact details
4. Implant brand inventory completeness check
5. Technology inventory check
6. KW research data (DataForSEO)

---

*Initialized 2026-05-10 by Architect from operator's pre-EYWA work + memory synthesis*
