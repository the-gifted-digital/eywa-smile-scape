# SmileScape — Brand-Specific Decision Records

> **Scope:** Decisions specific to SmileScape Dental Clinic. For universal EYWA decisions, see `eywa-protocol-spec/DECISION_RECORDS.md`.

**Format:** Reverse chronological (newest first)

---

## [SS-DR-001] — Implant Brand Strategy: Blue Diamond as Hero (2026-04-08)

**Status:** Locked (operator confirmed)
**Bible Reference:** Brand-specific (no universal DR conflict)

**Context:**
SmileScape needs to position implant offering across price tiers without confusing patients or undermining premium options.

**Decision:**
3-tier implant brand offering with Blue Diamond as hero:

```yaml
hero_tier: Blue Diamond (Korea, value-premium, lifetime warranty, 29,900 THB starting)
premium_tier: Straumann (Switzerland, top-tier reputation)
specialty_tier: Ceramic Implant (metal-free, premium for sensitive patients/front teeth)
value_tier: Osstem/Dentium (Korea, entry-level clear option)
```

**Rationale:**
- Blue Diamond = best value-quality ratio in Thai market
- Lifetime warranty + 0% installment = strong promo hook
- Multi-tier maintains optionality without diluting hero message

---

## [SS-DR-002] — Section 3 vs Section 4 Brand Naming Pattern (2026-04-08)

**Status:** Locked
**Companion to:** EYWA DR-007 (URL Structure)

**Decision:**
- **Section 3 (Services):** ไม่เอ่ยยี่ห้อ — นำด้วยวิธีการ (patient-language)
  - Example: "การฝังรากเทียม" not "Blue Diamond Implant"
- **Section 4 (Technology):** ยี่ห้อ OK — tech specs + comparison
  - Example: "Blue Diamond / Osstem / Straumann / Ceramic"
- **Section 6 (Knowledge):** ดัก brand search intent
  - Example: "Blue Diamond คืออะไร?", "เปรียบเทียบ Blue Diamond vs Osstem"

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

## Future Brand-Specific DRs (placeholders)

- SS-DR-007: Sub-brand strategy for "รากฟันเทียม by SmileScape" Facebook page
- SS-DR-008: Multilingual launch decision (TH only initially → EN when?)
- SS-DR-009: International medical tourism positioning (vs domestic-first focus)
- SS-DR-010: Cross-brand link governance (DR-021 once locked)

---

*Initialized 2026-05-10 from operator's earlier session decisions*
