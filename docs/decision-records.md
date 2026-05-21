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

## Future Brand-Specific DRs (placeholders)

- SS-DR-009: Sub-brand strategy for "รากฟันเทียม by SmileScape" Facebook page
- SS-DR-010: Multilingual launch decision (TH only initially → EN when?)
- SS-DR-011: International medical tourism positioning (vs domestic-first focus)
- SS-DR-012: Cross-brand link governance (DR-021 once locked)

---

*Initialized 2026-05-10 from operator's earlier session decisions*
