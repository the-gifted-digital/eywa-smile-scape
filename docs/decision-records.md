# SmileScape — Brand-Specific Decision Records

> **Scope:** Decisions specific to SmileScape Dental Clinic. For universal EYWA decisions, see `eywa-protocol-spec/DECISION_RECORDS.md`.

**Format:** Reverse chronological (newest first)

---

## [SS-DR-001] — Implant Brand Strategy: Blue Diamond as Hero (2026-04-08 / Updated 2026-05-21)

**Status:** Locked (operator confirmed) — Updated Round 2 (Osstem out, Neodent in)
**Bible Reference:** Brand-specific (no universal DR conflict)

**Context:**
SmileScape needs to position implant offering across price tiers without confusing patients or undermining premium options.

**Decision (Round 2):**
4-tier implant brand offering with Blue Diamond as hero — **Osstem removed, Neodent added (2026-05-21)**:

```yaml
hero_tier: Blue Diamond (Korea, value-premium, lifetime warranty, 29,900 THB starting)
value_premium_tier: Neodent (Brazil, Straumann Group subsidiary, GM Connection)  # NEW R2
premium_tier: Straumann (Switzerland, top-tier reputation)
specialty_tier: Ceramic Implant (metal-free, premium for sensitive patients/front teeth)
# REMOVED R2: Osstem/Dentium — clinic does not use
```

**Rationale (Round 2 update):**
- Blue Diamond = best value-quality ratio in Thai market
- Neodent = strategic addition giving Straumann-Group evidence-backing at value-premium price (clinic uses, not Osstem)
- Lifetime warranty + 0% installment = strong promo hook
- Multi-tier maintains optionality without diluting hero message
- Removing Osstem reflects actual clinic inventory + sharpens the 4-brand offering

---

## [SS-DR-002] — Section 3 vs Section 4 Brand Naming Pattern (2026-04-08)

**Status:** Locked
**Companion to:** EYWA DR-007 (URL Structure)

**Decision:**
- **Section 3 (Services):** ไม่เอ่ยยี่ห้อ — นำด้วยวิธีการ (patient-language)
  - Example: "การฝังรากเทียม" not "Blue Diamond Implant"
- **Section 4 (Technology):** ยี่ห้อ OK — tech specs + comparison
  - Example: "Blue Diamond / Neodent / Straumann / Ceramic"  *(Round 2: Osstem → Neodent)*
- **Section 6 (Knowledge):** ดัก brand search intent
  - Example: "Blue Diamond คืออะไร?", "เปรียบเทียบ Blue Diamond vs Neodent"  *(Round 2)*

**Apply to:** Both Implant brands AND Orthodontics brands (TrioClear / Damon)

---

## [SS-DR-003] — TrioClear ≠ Invisalign (Brand Disambiguation) (2026-04-08)

**Status:** Locked

**Decision:**
TrioClear is a distinct premium aligner brand (Modern Dental HK), NOT a generic Invisalign alternative.

**Required content rules:**
- Always specify: TrioClear features = progressive, TrioDim Force, multi-layer
- Never imply equivalence to Invisalign
- Section 6 (Knowledge) should have dedicated "TrioClear vs Invisalign comparison" page

---

## [SS-DR-004] — Founders Treatment in Sitemap (2026-04-08)

**Status:** Locked

**Decision:**
- หมอแฮม + หมอแพรว → under Section 2.2 Clinical Team (NOT separate Founder section)
- Founders page (2.2.1) = Tier A — เล่าเรื่องร่วมสามีภรรยา (spousal partnership angle)
- Credentials per doctor = in-page sections within profile (NOT separate URLs)

**Rationale:** Family-warmth brand persona benefits from joint founder story; avoids over-fragmenting URL structure.

---

## [SS-DR-005] — Bone Grafting Sub-techniques as In-Page Sections (2026-04-08)

**Status:** Locked

**Decision:**
- Bone Graft types / Sinus lift approaches / Soft tissue types = in-page sections
- NOT separate URLs (avoid thin-page risk per Bible §4.14 / DR-016)
- PRF → in-page of Bone Grafting page
- Piezoelectric → Section 4 (Technology)

---

## [SS-DR-006] — Ceramic Implant as Premium Differentiator (2026-04-08)

**Status:** Locked

**Decision:**
Ceramic Implant gets dedicated Tier B page positioning as **premium differentiator**, not just an option.

**Positioning:**
- Metal-free = unique selling point in Thai market
- Target audience: ฟันหน้า aesthetic, คนแพ้โลหะ, holistic-minded patients
- Higher margin than Blue Diamond
- Positioned ABOVE Straumann in some narratives (specialty > generic premium)

---

## [SS-DR-007] — Densah/Osseodensification as Signature Offering #5 (2026-05-21)

**Status:** Locked (operator confirmed)
**Companion to:** SS-DR-001 (Implant Brand Strategy) / Bible v3.19 Signature Offerings framework

**Context:**
Round 2 sitemap expansion identified Internal Sinus Lift with Densah Bur (Osseodensification by Salah Huwais) as a genuine SmileScape capability — clinic uses Densah burs for minimally invasive crestal sinus elevation + bone density boost. This is a named-authority technique with global reputation (Versah training pipeline), parallel in strategic value to Sausage Technique (Urban) and Soft Tissue Management (Kern + Urban).

**Decision:**
Promote Internal Sinus Lift with Densah Bur to **Signature Offering #5** in `brand-config.json`. Authority anchor: Dr. Salah Huwais (Versah, USA).

**Implications:**
- `brand-config.json` `signature_offerings[4]` entry added with `_operator_action_required` flag for Dr. Woraphat Versah training credential
- Entity `densah-bur` (Device) + `osseodensification` (Procedure) + `internal-sinus-lift` (Procedure) — all `brand_scope=['smile-scape']`
- Sitemap 3.2.9.4.2 (sub-page of Sinus Lift) + Tech section 4.4.4 (Densah Bur System) = anchored URLs
- Knowledge: Section 6.2.1.14 (Implant Insights) + Section 6.4.12 (Evidence Summary: Huwais 2017+) = E-E-A-T support
- Pending operator data: Dr. Woraphat Versah training certificate / Huwais workshop attendance — required to write Section 2.2.2 หมอแฮม credentials with this anchor

**Rationale:**
- Real capability (clinic uses, not aspirational)
- Authority anchor available — Salah Huwais peer-reviewed evidence base since 2017
- Minimally invasive positioning supports patient-comfort narrative (Family Standard brand value)
- Parallel pattern to Sausage Technique = 5 named signature techniques is the right portfolio depth for "Global Mastery" claim

---

## [SS-DR-008] — Zero Bone Loss Concept as Brand Clinical Framework (2026-05-21)

**Status:** Locked (operator confirmed via Round 3 trade-off — chose Brand Framework over Signature Offering)
**Companion to:** SS-DR-007 (Densah Signature #5) — distinguishes Framework vs Technique categorization

**Context:**
Round 3 sitemap expansion identified Tomas Linkevicius's "Zero Bone Loss Concept" (Quintessence 2019 textbook + 2009+ research) as a clinical framework that SmileScape adopts. DFS validation: direct keyword volume very low (zero bone loss concept 20/mo TH, linkevicius 10/mo) — not a traffic target but a strong E-E-A-T authority anchor.

**Decision:**
Treat ZBL as **clinical_protocols[0]** in `brand-config.json` — separate from `signature_offerings`. Rationale:

- **Signature Offering** = named procedure/technique we perform (Sausage, Densah, Soft Tissue protocols, Blue Diamond)
- **Clinical Protocol** = philosophy/approach that informs HOW we perform implants (ZBL)

ZBL joins SMILE DNA (values) + Family Standard (ethics) as the brand triad — each is a framework, not a technique.

**Implications:**
- `brand-config.json` `clinical_protocols[0]` entry with core_principles array + `_operator_action_required` flag for หมอแฮม Linkevicius training credential
- Entity `zero-bone-loss-concept` (Concept, brand-scope=['smile-scape']) + `dr-tomas-linkevicius` (Person, brand-scope=['*'] — external authority)
- Sitemap page 2.1.6 "Our Protocol: Zero Bone Loss by Tomas Linkevicius" (Tier B brand authority page)
- Section 6.4.14 Linkevicius 2009-2020 Evidence Summary
- 9 cross-cluster edges woven: ZBL related_to dental-implant / lifetime-warranty / smile-dna / family-standard / keratinized-mucosa / peri-implantitis (prevention) + evidenced_by dr-tomas-linkevicius + dr-woraphat-jarangkul related_to ZBL + linkevicius
- Pending operator: หมอแฮม Linkevicius training certificate / textbook ownership confirmation — required to write 2.1.6 + Section 2.2.2 credentials

**Rationale (vs Signature Offering #6 alternative):**
- ZBL is not a procedure SmileScape "does" — it's a way SmileScape "thinks"
- Dilution risk: adding ZBL to signature_offerings would dilute the meaning of "signature technique" (which currently = named procedures with attendable masterclasses)
- Better categorization: framework triad position (alongside SMILE DNA + Family Standard) gives ZBL its proper weight without misclassifying

---

## [SS-DR-009] — FAQ Canonical Source Decision: Section 6.5 = Single Home (2026-05-21)

**Status:** Locked (operator confirmed Round 7)
**Companion to:** DR-021 internal linking schema + DR-019 evidence backing

**Context:**
Initial Section 6 restructure (Round 2) placed FAQ in **two locations** that caused overlap and confusion:
- Section 5.9 — Concern-context FAQ (5 pages organized by service)
- Section 6.5 — Knowledge-context FAQ (5 pages organized by topic)

In practice, same Q&A could land in both places (e.g., "ฝังรากเทียมเจ็บไหม?" fits 5.9.1 Implant FAQ AND 6.5.2 Safety FAQ). This caused:
1. Duplicate Q&A potential = split SEO weight
2. AI citation surface fragmented = Knowledge Graph confusion
3. DR-021 reciprocal-detection ambiguity (which FAQ to link to from service page?)
4. Operator content writer confusion = inconsistent FAQ placement

**Decision:**
**Section 6.5 = Single Canonical FAQ Home.** Section 5.9 deprecated.

Structure:
```
6.5     FAQ Knowledge Hub — Master (canonical) — 29 pages
6.5.1   FAQ by Service (10 sub-pages) — Implant / All-on-X / Ortho / Veneer/Crown / Pediatric / Endo / Sedation / Peri-Implantitis / Bone Graft / Soft Tissue
6.5.2   FAQ by Concern (6 sub-pages) — Safety/Risk / Timeline / After-care / Pain-Emergency / Aesthetics / Decision-making
6.5.3   FAQ by Patient Group (4 sub-pages) — Senior / Pregnancy / Pediatric / Medical Comorbidities
6.5.4   FAQ Cost & Insurance (5 sub-pages) — Price-Payment / Installment 0% / SSO / UCS-CGA-Private / Tax Deduction
6.5.5   FAQ Quick Reference (2 sub-pages) — Top 10 + Voice Search Speakable
```

**Implications:**
- `brand-config.json` `content_strategy.faq_canonical_location = "section_6.5"` (v1.7)
- All Section 3 services + Section 5 concerns + Section 8 contact pages link to 6.5.x sub-pages for Q&A
- Schema.org `FAQPage` markup on every 6.5.x leaf page
- Section 6.5.5.2 Voice Search uses Schema.org `Speakable` extension
- DR-021 internal linking pattern: every page that needs FAQ has exactly ONE 6.5.x target

**Rationale:**
- **AI citation surface unified** — Knowledge Graph has clear FAQ entity anchor
- **DR-021 reciprocal-detection clean** — source page → 6.5.x → back to source (predictable pattern)
- **Operator clarity** — Content team writes FAQ in ONE place
- **No SEO weight split** — single canonical URL per Q&A type
- **Voice Search ready** — dedicated Speakable layer at 6.5.5.2
- **Funnel-aware** — Section 5 (Concerns) + Section 3 (Services) both funnel to canonical FAQ — clean architecture, not duplicate destinations

**Pages affected:**
- DELETE: 5.9 + 5.9.1-5.9.5 (6 pages)
- EXPAND: 6.5 from 6 → 29 pages (+23)
- Net: +17 pages
- Link patterns updated across Sections 3, 5, 8

---

## [SS-DR-010] — Direct Print In-House Clear Aligner as Signature Offering #6 (2026-05-22)

**Status:** Locked (operator confirmed Round 11)
**Companion to:** SS-DR-007 (Densah Signature #5) — distinguishes signature_technology vs signature_technique categorization

**Context:**
SmileScape has in-house clear aligner manufacturing using 3D direct-print technology (photopolymer resin — Graphy TC-85DAC or Tera Harz TC-85 — FDA-cleared, operator to confirm specific brand). This is UNIQUE in TH value-premium dental market (most clinics outsource to TrioClear / Invisalign / ClearCorrect thermoformed labs).

PubMed evidence base (6 studies 2021-2025) confirms:
- Direct Print outcomes comparable or better than thermoformed
- Fewer composite attachments needed (built-in retention features)
- Variable thickness per region
- Same-day production capability

**Decision:**
**Direct Print In-House Aligner = Signature Offering #6** in `brand-config.json`. Type: `signature_technology` (distinct from signature_technique like Sausage/Soft Tissue, and signature_treatment like Blue Diamond/All-on-X).

5 existing Signatures + 1 new = **6 Signature Offerings total:**
1. Blue Diamond Implant System (signature_treatment, hero)
2. Sausage Technique (signature_technique, Urban authority)
3. All-on-X Immediate Loading (signature_treatment, ILAPEO)
4. Soft Tissue Management (signature_technique, Kern + Urban)
5. Internal Sinus Lift with Densah (signature_technique, Huwais authority) — SS-DR-007
6. **Direct Print Clear Aligner (signature_technology, in-house manufacturing)** — SS-DR-010 (R11)

**Implications:**
- `brand-config.json` `signature_offerings[5]` entry (v1.11)
- Entity `direct-print-clear-aligner` (Treatment, brand-scope=['smile-scape']) + 5 supporting entities (in-house-aligner-lab, photopolymer-resin-tc85, 3d-printer-aligner, aligner-attachment, thermoformed-aligner for comparison)
- Sitemap Section 3.5.1 promoted to Tier A sub-hub with 10 sub-pages (Direct Print as 3.5.1.2 Signature)
- Section 4.6.0 In-House Aligner Lab Tech sub-hub (6 pages) — equipment + workflow + QC
- Section 6.2.5 Knowledge (+3 Direct Print insights)
- Section 6.4.15 Pillar 16 Evidence Summary
- 15 new edges (subtype/alternative/uses/evidenced_by chains)
- Citation Pool Pillar 16 (8 citations + brand Tier 5)

**Rationale:**
- **Unique TH market positioning** — no other value-premium clinic offers in-house direct-print currently
- **Real capability** (operator confirmed clinic has equipment + workflow)
- **Strong evidence base** (6 PubMed studies + FDA-cleared materials)
- **Premium positioning support** — fewer attachments + same-day = differentiated patient experience
- **Cost control** — in-house vs outsourced TrioClear license fees
- **Parallel to Densah Signature #5 pattern** — named-technology with manufacturer + authority + evidence

**Pending operator (R11):**
- Confirm 3D printer model (Asiga / SprintRay / Formlabs)
- Confirm photopolymer brand (Graphy TC-85DAC / Tera Harz TC-85 / other)
- Confirm production volume + warranty terms + lab certification
- Confirm หมอแฮม role in in-house lab (Medical Director oversight)

---

## Future Brand-Specific DRs (placeholders)

- SS-DR-011: Sub-brand strategy for "รากฟันเทียม by SmileScape" Facebook page
- SS-DR-012: Multilingual launch decision (TH only initially → EN when?)
- SS-DR-013: International medical tourism positioning (vs domestic-first focus)
- SS-DR-014: Cross-brand link governance (DR-021 once locked)

---

*Initialized 2026-05-10 from operator's earlier session decisions*
