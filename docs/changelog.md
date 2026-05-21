# SmileScape Brand Repo — Changelog

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
