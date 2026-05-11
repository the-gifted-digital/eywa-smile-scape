# SmileScape Dental Clinic — Entity Graph (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis)
> **Schema:** §5.3 — 12 columns per entity
> **Date:** 2026-05-11
> **EUG Note:** Slugs normalized to kebab-case. `eug_preflight_check()` to run at Stage 1.5 flat-load.
> **Citation linking:** Anchoring citations referenced as `P{pillar}-C{#}` matching `citation-pool-seed.md`.

---

## Entity Type Distribution

| Type | Count | Notes |
|------|-------|-------|
| Treatment | 21 | Long-term/behavioral therapies + restorative work |
| Procedure | 18 | One-time clinical procedures (incl. signature techniques) |
| Condition | 14 | Patient-facing diseases + bone deficiency states |
| Product | 9 | Implant systems, aligner brands, biomaterials |
| Concept | 6 | Abstract clinical/brand concepts (incl. SMILE DNA, warranty) |
| Anatomy | 6 | Bone, gum, sinus, jaw anatomical structures |
| Device | 5 | CBCT, scanners, surgical guide, PTFE membrane |
| Organization | 1 | SmileScape Dental Clinic |
| Person | 1 | Dr. Woraphat Jarangkul |
| **Total** | **81** | |

---

## Entity Type Vocabulary (Bible Part 2.5, Appendix A.1)

Valid types — spec 15-type master list (Title Case in planning files; maps 1:1 to lowercase DB `entity_type`):

`Condition` / `Symptom` / `Procedure` / `Treatment` / `Device` / `Concept` / `Product` / `Drug` / `Ingredient` / `Anatomy` / `Specialty` / `Lab_test` / `Biomarker` / `Person` / `Organization`

---

## dental-implant-core: Dental Implant — Core Procedure

**Brand Scope:** ['*']
**Pillar Page:** 3.2
**Domain:** A: Dental Implant

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Dental Implant | dental-implant | Treatment | MedicalProcedure | — | — | Mature | 3.2 | รากฟันเทียม, implant, tooth implant, endosseous implant | ['*'] | Hero entity — anchors entire implant domain. Citation: P1-C1 (Howe 2019, 96.4% 10-yr survival) |
| 2 | Single Tooth Implant | single-tooth-implant | Treatment | MedicalProcedure | dental-implant | — | Mature | 3.2.8.1 | รากฟันเทียมซี่เดียว, single implant, 1 implant | ['*'] | Most common entry case |
| 3 | Multiple Implants | multiple-implants | Treatment | MedicalProcedure | dental-implant | — | Mature | 3.2.8.2 | รากฟันเทียมหลายซี่, multiple tooth implants | ['*'] | 2+ implants, non-full-arch |
| 4 | Immediate Implant Placement | immediate-implant | Procedure | MedicalProcedure | dental-implant | — | Mature | 3.2.8.5 | ถอนฟันฝังรากทันที, same-day implant, immediate placement | ['*'] | Extraction + implant same session |
| 5 | Immediate Loading | immediate-loading | Procedure | MedicalProcedure | dental-implant | — | Mature | 3.2.8.6 | ใส่ฟันทันทีหลังผ่าตัด, same-day teeth, provisional loading | ['*'] | Temporary crown placed same day as implant. Citation: P3-C3 (Cheng 2020) |
| 6 | Osseointegration | osseointegration | Concept | MedicalCondition | dental-implant | — | Mature | 3.2.1 | การติดกับกระดูก, bone-implant integration | ['*'] | Biological fusion of titanium implant with alveolar bone — foundation of implant longevity |
| 7 | Flapless Implant Surgery | flapless-surgery | Procedure | MedicalProcedure | dental-implant | — | Growing | 3.2.6 | ผ่าตัดไม่เปิดแผล, flapless technique, keyhole implant | ['*'] | Minimally invasive — less pain, faster healing |
| 8 | Guided Implant Surgery | guided-surgery | Procedure | MedicalProcedure | dental-implant | — | Growing | 3.2.7 | การผ่าตัดแบบ guided, surgical guide technique | ['*'] | Uses surgical guide from 3D planning for precise implant placement |
| 9 | Implant-Supported Bridge | implant-supported-bridge | Treatment | MedicalProcedure | dental-implant | — | Mature | 3.2.8.8 | สะพานฟันบนรากเทียม, implant bridge | ['*'] | Multiple missing teeth with fewer implants |

---

## implant-systems-brands: Implant Systems & Brands

**Brand Scope:** ['*']
**Pillar Page:** 4.5
**Domain:** A: Dental Implant

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Blue Diamond Implant System | blue-diamond-implant | Product | MedicalDevice | dental-implant | — | Growing | 4.5.1 | Blue Diamond, Korean implant, ระบบรากเทียม Blue Diamond | ['smile-scape'] | SmileScape hero implant. Korea origin. Lifetime warranty. Starting 29,900 THB. Citation: P1-C1 (survival data supports Korean implant category) |
| 2 | Osstem Implant | osstem-implant | Product | MedicalDevice | dental-implant | — | Mature | 4.5.2 | Osstem, TS III, SS II, Osstem TS | ['*'] | Market leader in Asia. Established evidence base. |
| 3 | Straumann Implant | straumann-implant | Product | MedicalDevice | dental-implant | — | Mature | 4.5.3 | Straumann SLActive, BLT, BLX, Swiss implant | ['*'] | Premium Swiss brand. Extensive clinical evidence. Citation: P1-C3 (Pjetursson 2012) |
| 4 | Ceramic Implant | ceramic-implant | Treatment | MedicalDevice | dental-implant | — | Emerging | 4.5.4 | Zirconia implant, รากฟันเทียมเซรามิก, metal-free implant, ceramic root | ['*'] | Metal-free option for allergic patients + anterior aesthetics |
| 5 | Titanium Implant | titanium-implant | Treatment | MedicalDevice | dental-implant | — | Mature | 3.2.8.10 | ไทเทเนียม, titanium root, standard implant | ['*'] | Standard implant material — 30+ year track record |

---

## bone-regeneration-gbr: Bone Regeneration & GBR

**Brand Scope:** ['*']
**Pillar Page:** 3.2.9
**Domain:** B: Bone Regeneration

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Guided Bone Regeneration | guided-bone-regeneration | Procedure | MedicalProcedure | — | — | Mature | 3.2.9.2 | GBR, เสริมกระดูกแบบ GBR, bone regeneration membrane | ['*'] | Gold standard for dehiscence + horizontal defects. Citation: P2-C1 (Buser/Urban 2023, 35yr review) |
| 2 | Sausage Technique | sausage-technique | Procedure | MedicalProcedure | guided-bone-regeneration | — | Growing | 3.2.9.3 | เทคนิคไส้กรอก, Urban technique, horizontal ridge augmentation | ['smile-scape'] | Dr. Urban's horizontal ridge augmentation protocol. Studied directly by Dr. Woraphat. Citation: P2-C2 (Urban 2009), P2-C3 (Urban 2016) |
| 3 | Bone Grafting | bone-grafting | Treatment | MedicalProcedure | — | — | Mature | 3.2.9.1 | ปลูกถ่ายกระดูก, bone graft, bone transplant, autograft | ['*'] | Umbrella for all bone augmentation procedures. Citation: P2-C4 (Milinkovic 2014) |
| 4 | Sinus Lift | sinus-lift | Procedure | MedicalProcedure | bone-grafting | — | Mature | 3.2.9.4 | ยกพื้นไซนัส, sinus augmentation, maxillary sinus lift | ['*'] | Upper jaw — insufficient vertical bone below sinus floor |
| 5 | Ridge Augmentation | ridge-augmentation | Procedure | MedicalProcedure | guided-bone-regeneration | — | Mature | 3.2.9.5 | เสริมสันกระดูก, alveolar ridge augmentation | ['*'] | Horizontal + vertical ridge reconstruction |
| 6 | Socket Preservation | socket-preservation | Procedure | MedicalProcedure | bone-grafting | — | Mature | 3.2.9.6 | รักษาเบ้ากระดูก, alveolar socket preservation, ridge preservation | ['*'] | Placed at time of extraction to prevent bone resorption |
| 7 | Vertical Bone Augmentation | vertical-bone-augmentation | Procedure | MedicalProcedure | guided-bone-regeneration | — | Mature | 3.2.9.2 | การเสริมกระดูกในแนวตั้ง, vertical ridge augmentation, VRA | ['*'] | For severe vertical bone deficiency. Urban's specialty. Citation: P2-C2 (Urban 2009 — 5.5mm mean gain) |

---

## all-on-x-full-arch: All-on-X Full-Arch Rehabilitation

**Brand Scope:** ['*']
**Pillar Page:** 3.3
**Domain:** C: Full-Arch Rehabilitation

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | All-on-X | all-on-x | Treatment | MedicalProcedure | dental-implant | — | Mature | 3.3 | All-on-4, All-on-6, ฟันทั้งปาก, full arch implant, คืนฟันทั้งปาก | ['*'] | Full-arch fixed restoration on 4-6 implants. Citation: P3-C1 (Abdunabi 2019), P3-C2 (Tsigarida 2021) |
| 2 | All-on-4 | all-on-4 | Treatment | MedicalProcedure | all-on-x | — | Mature | 3.2.8.3 | All on 4, ฟันทั้งปาก 4 ราก, All-on-Four | ['*'] | 4 implants support full-arch fixed prosthesis |
| 3 | All-on-6 | all-on-6 | Treatment | MedicalProcedure | all-on-x | — | Mature | 3.2.8.4 | All on 6, ฟันทั้งปาก 6 ราก | ['*'] | 6 implants — more support, recommended for upper jaw |
| 4 | Full-Arch Immediate Loading | full-arch-immediate-loading | Procedure | MedicalProcedure | all-on-x | — | Mature | 3.3.3 | immediate function, teeth in a day, ใส่ฟันทันที All-on-X | ['*'] | Same-day function for edentulous patients. Citation: P3-C1 (Abdunabi 2019) |
| 5 | Overdenture | overdenture | Treatment | MedicalProcedure | dental-implant | — | Mature | 3.2.8.7 | implant-retained denture, ฟันปลอมบนรากเทียม | ['*'] | Removable prosthesis retained by implants — more affordable than fixed |
| 6 | Zygomatic Implant | zygomatic-implant | Treatment | MedicalProcedure | all-on-x | — | Growing | 3.2.8.9 | รากฟันเทียมกระดูกโหนกแก้ม, zygomatic implant, cheekbone implant | ['*'] | Extreme bone loss cases — anchors in zygomatic bone |

---

## patient-conditions-tooth-loss: Patient Conditions — Tooth Loss

**Brand Scope:** ['*']
**Pillar Page:** 5.1
**Domain:** A: Dental Implant

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Tooth Loss | tooth-loss | Condition | MedicalCondition | — | K08.409 | Mature | 5.1 | ฟันหลุด, สูญเสียฟัน, missing tooth, tooth missing | ['*'] | Primary concern driving implant need. PP-1 in patient-journey.md |
| 2 | Edentulism | edentulism | Condition | MedicalCondition | tooth-loss | K08.101 | Mature | 5.1.3 | ฟันหลุดทั้งปาก, complete tooth loss, edentulous, ไม่มีฟัน | ['*'] | Complete tooth loss — All-on-X primary candidate |
| 3 | Tooth Decay Leading to Extraction | dental-caries-extraction | Condition | MedicalCondition | tooth-loss | K02.9 | Mature | 5.1.6 | ฟันผุจนต้องถอน, severe decay extraction | ['*'] | Most common cause of tooth loss in Thailand |
| 4 | Traumatic Tooth Loss | traumatic-tooth-loss | Condition | MedicalCondition | tooth-loss | S02.5XXA | Growing | 5.1.5 | ฟันหักจากอุบัติเหตุ, tooth fracture trauma, avulsed tooth | ['*'] | Accident/trauma → immediate implant candidate |
| 5 | Removable Denture Dissatisfaction | denture-dissatisfaction | Condition | MedicalCondition | tooth-loss | — | Mature | 5.3 | ฟันปลอมหลวม, ฟันปลอมไม่พอใจ, loose denture, denture problems | ['*'] | Major conversion trigger → All-on-X / Overdenture upgrade |

---

## patient-conditions-bone: Patient Conditions — Bone Deficiency

**Brand Scope:** ['*']
**Pillar Page:** 5.2
**Domain:** B: Bone Regeneration

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Alveolar Bone Loss | alveolar-bone-loss | Condition | MedicalCondition | — | K06.3 | Mature | 5.2 | กระดูกขากรรไกรละลาย, bone resorption, กระดูกไม่พอ | ['*'] | Most common reason patients think they "can't have implants" — key educational topic. PP-4 |
| 2 | Vertical Bone Deficiency | vertical-bone-deficiency | Condition | MedicalCondition | alveolar-bone-loss | K06.3 | Mature | 5.2.2 | กระดูกในแนวตั้งไม่พอ, vertical bone loss | ['*'] | Sausage Technique primary indication |
| 3 | Horizontal Bone Deficiency | horizontal-bone-deficiency | Condition | MedicalCondition | alveolar-bone-loss | K06.3 | Mature | 5.2.1 | กระดูกในแนวนอนไม่พอ, narrow ridge, thin ridge | ['*'] | GBR + Sausage Technique indication |
| 4 | Maxillary Sinus Proximity | maxillary-sinus-proximity | Condition | MedicalCondition | alveolar-bone-loss | — | Mature | 5.2.1 | ไซนัสอยู่ใกล้, insufficient upper jaw bone | ['*'] | Upper jaw posterior bone loss → Sinus Lift indication |

---

## smile-design-cosmetic: Smile Design & Cosmetic Dentistry

**Brand Scope:** ['*']
**Pillar Page:** 3.4
**Domain:** D: Aesthetic & Cosmetic

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Digital Smile Design | digital-smile-design | Procedure | MedicalProcedure | — | — | Growing | 3.4.1 | DSD, ออกแบบรอยยิ้มดิจิทัล, smile design, digital smile | ['*'] | Digital pre-visualization of smile outcome before treatment |
| 2 | Dental Veneer | dental-veneer | Treatment | MedicalProcedure | — | — | Mature | 3.4.2 | วีเนียร์, porcelain veneer, veneer ฟัน, composite veneer | ['*'] | Thin ceramic shell over tooth surface |
| 3 | Porcelain Veneer | porcelain-veneer | Treatment | MedicalProcedure | dental-veneer | — | Mature | 3.4.2 | วีเนียร์พอร์ซเลน, ceramic veneer | ['*'] | Premium — longer lasting than composite |
| 4 | Teeth Whitening | teeth-whitening | Treatment | MedicalProcedure | — | — | Mature | 3.4.7 | ฟอกสีฟัน, tooth bleaching, ฟันขาว | ['*'] | |
| 5 | Dental Crown | dental-crown | Treatment | MedicalDevice | — | — | Mature | 3.4.4 | ครอบฟัน, tooth cap, crown | ['*'] | |
| 6 | Zirconia Crown | zirconia-crown | Treatment | MedicalDevice | dental-crown | — | Mature | 3.4.4.1 | ครอบฟันเซอร์โคเนีย, zirconia cap | ['*'] | All-ceramic crown — high aesthetic + strength |

---

## gum-soft-tissue: Gum & Soft Tissue Management

**Brand Scope:** ['*']
**Pillar Page:** 3.2.9.7
**Domain:** F: Periodontics & Gum

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Soft Tissue Management | soft-tissue-management | Procedure | MedicalProcedure | — | — | Growing | 3.2.9.7 | การจัดการเนื้อเยื่ออ่อน, gum management, soft tissue surgery, perio aesthetics | ['smile-scape'] | Studied with Dr. Ricardo Kern (Brazil). Pink aesthetic protocol. Citation: P5-C1 (Benic 2014) |
| 2 | Gum Contouring | gum-contouring | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.4.8 | ตกแต่งเหงือก, gummy smile correction, gingivoplasty | ['*'] | Reshaping gum line for aesthetic purposes |
| 3 | Connective Tissue Graft | connective-tissue-graft | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.2.9.7 | ปลูกถ่ายเนื้อเยื่อ, CTG, subepithelial connective tissue graft | ['*'] | Gum recession correction around implants |
| 4 | Peri-Implant Mucosa | peri-implant-mucosa | Anatomy | AnatomicalStructure | — | — | Mature | 3.2.9.7 | เนื้อเยื่อรอบรากเทียม, peri-implant tissue | ['*'] | Soft tissue surrounding implant — key aesthetic determinant |
| 5 | Keratinized Mucosa | keratinized-mucosa | Anatomy | AnatomicalStructure | peri-implant-mucosa | — | Mature | 3.7.5 | เนื้อเยื่อแข็ง, keratinized gingiva, attached gingiva | ['*'] | Adequate band required for long-term peri-implant health |

---

## periodontics-perio-disease: Periodontics & Gum Disease

**Brand Scope:** ['*']
**Pillar Page:** 3.7
**Domain:** F: Periodontics & Gum

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Gingivitis | gingivitis | Condition | MedicalCondition | — | K05.10 | Mature | 3.7.1 | เหงือกอักเสบ, gum inflammation, bleeding gums | ['*'] | Early gum disease — reversible |
| 2 | Periodontitis | periodontitis | Condition | MedicalCondition | gingivitis | K05.30 | Mature | 3.7.2 | โรคปริทันต์, periodontal disease, gum disease, โรคเหงือก | ['*'] | Major cause of tooth loss. Must treat before implant. |
| 3 | Gum Recession | gum-recession | Condition | MedicalCondition | periodontitis | K06.010 | Mature | 3.7.4 | เหงือกร่น, receding gums | ['*'] | Exposes root, affects aesthetics, complicates implant |
| 4 | Peri-Implantitis | peri-implantitis | Condition | MedicalCondition | periodontitis | M27.62 | Mature | 3.2.10.9 | การติดเชื้อรอบรากเทียม, implant infection, peri-implant disease | ['*'] | Implant-site infection — major threat to implant longevity. PP-14 |

---

## clear-aligner-orthodontics: Clear Aligner & Orthodontics

**Brand Scope:** ['*']
**Pillar Page:** 3.5
**Domain:** E: Orthodontics

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Clear Aligner | clear-aligner | Treatment | MedicalProcedure | — | M26.4 | Mature | 3.5.1 | จัดฟันใส, invisible braces, aligner, transparent aligner | ['*'] | Removable clear aligner system. Citation: P4-C1 (Alhamwi 2024) |
| 2 | TrioClear Aligner System | trioclear-aligner | Product | MedicalDevice | clear-aligner | — | Growing | 4.6.1 | TrioClear, TrioClear Progressive, จัดฟันใส TrioClear | ['smile-scape'] | Modern Dental (HK). Progressive force design. NOT Invisalign. |
| 3 | Damon Self-Ligating System | damon-system | Product | MedicalDevice | — | — | Mature | 4.6.2 | Damon, Damon Q, Damon Clear, self-ligating braces, จัดฟัน Damon | ['smile-scape'] | Passive self-ligation — lower friction, fewer adjustments |
| 4 | Malocclusion | malocclusion | Condition | MedicalCondition | — | M26.4 | Mature | 3.5 | ฟันเรียงไม่ตรง, crowded teeth, misaligned teeth, jaw mismatch | ['*'] | Primary indication for orthodontic treatment |
| 5 | Orthodontic-Implant Sequencing | ortho-implant-sequencing | Concept | MedicalProcedure | malocclusion | — | Growing | 3.5.6 | จัดฟันก่อนรากฟันเทียม, ortho before implant, interdisciplinary planning | ['*'] | SmileScape differentiator — interdisciplinary specialty combo |

---

## general-restorative: General Restorative Dentistry

**Brand Scope:** ['*']
**Pillar Page:** 3.6
**Domain:** A: Dental Implant (supporting)

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Root Canal Treatment | root-canal-treatment | Treatment | MedicalProcedure | — | K04.0 | Mature | 3.6.5 | รักษารากฟัน, endodontic treatment, RCT | ['*'] | Alternative to extraction when tooth can be saved |
| 2 | Tooth Extraction | tooth-extraction | Procedure | MedicalProcedure | — | K08.409 | Mature | 3.6.3 | ถอนฟัน, tooth removal | ['*'] | Often precedes implant placement |
| 3 | Wisdom Tooth Removal | wisdom-tooth-removal | Procedure | MedicalProcedure | tooth-extraction | K01.1 | Mature | 3.6.4 | ผ่าฟันคุด, impacted wisdom tooth removal, third molar extraction | ['*'] | |
| 4 | Dental Filling | dental-filling | Treatment | MedicalProcedure | — | K02.9 | Mature | 3.6.2 | อุดฟัน, composite filling, tooth filling | ['*'] | |
| 5 | Removable Denture | removable-denture | Treatment | MedicalDevice | — | — | Mature | 3.6.6 | ฟันปลอมถอดได้, complete denture, partial denture | ['*'] | Often starting point before All-on-X conversion |

---

## digital-technology-diagnostics: Digital Technology & Diagnostics

**Brand Scope:** ['*']
**Pillar Page:** 3.1
**Domain:** G: Cross-Cutting

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | CBCT 3D Scan | cbct-3d-scan | Device | MedicalDevice | — | — | Mature | 4.2.1 | เอกซเรย์ 3 มิติ, cone beam CT, CBCT, 3D X-ray | ['*'] | Essential for implant planning — reveals bone volume, nerve position |
| 2 | Digital Implant Planning | digital-implant-planning | Procedure | MedicalProcedure | cbct-3d-scan | — | Mature | 4.3.1 | วางแผนรากฟันเทียมดิจิทัล, 3D implant planning, virtual implant | ['*'] | Software-based 3D placement planning from CBCT data |
| 3 | Surgical Guide | surgical-guide | Device | MedicalDevice | digital-implant-planning | — | Growing | 4.3.2 | เทมเพลตนำทางผ่าตัด, implant guide, stent | ['*'] | 3D-printed guide for precise implant positioning during surgery |
| 4 | Intraoral Scanner | intraoral-scanner | Device | MedicalDevice | — | — | Mature | 4.2.2 | เครื่องสแกนในปาก, digital impression, IOS | ['*'] | Replaces traditional impression material |
| 5 | CAD/CAM Prosthetics | cad-cam | Device | MedicalDevice | — | — | Mature | 4.7.1 | CAD CAM, computer-aided design crown, ผลิตครอบฟันดิจิทัล | ['*'] | Computer-designed and milled crowns/prosthetics |

---

## implant-materials: Implant Materials & Biomaterials

**Brand Scope:** ['*']
**Pillar Page:** 4.5
**Domain:** G: Cross-Cutting

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Titanium | titanium | Product | — | — | — | Mature | 4.5.5 | ไทเทเนียม, Ti-6Al-4V, titanium alloy | ['*'] | Standard implant material — biocompatible, 30+ year record |
| 2 | Zirconia | zirconia | Product | — | — | — | Growing | 4.5.4 | เซรามิก, zirconia oxide, ZrO2, ซิรโคเนีย | ['*'] | Ceramic material for metal-free implants + prosthetics |
| 3 | Bone Graft Substitute | bone-graft-substitute | Product | — | — | — | Mature | 3.2.9.1 | วัสดุปลูกถ่ายกระดูก, allograft, xenograft, bone substitute | ['*'] | Augments or replaces autogenous bone in GBR |
| 4 | PTFE Membrane | ptfe-membrane | Device | MedicalDevice | guided-bone-regeneration | — | Mature | 3.2.9.2 | เมมเบรน PTFE, non-resorbable membrane, Teflon membrane, e-PTFE | ['*'] | Non-resorbable barrier — gold standard for vertical GBR |
| 5 | PRF (Platelet-Rich Fibrin) | prf-platelet-rich-fibrin | Product | MedicalDevice | — | — | Growing | 4.4.2 | เกล็ดเลือดเข้มข้น, PRF, platelet concentrate, growth factor | ['*'] | Patient's own blood concentrate — accelerates healing |

---

## dental-anatomy: Dental Anatomy & Physiology

**Brand Scope:** ['*']
**Pillar Page:** —
**Domain:** G: Cross-Cutting

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Alveolar Bone | alveolar-bone | Anatomy | AnatomicalStructure | — | — | Mature | 5.2 | กระดูกขากรรไกร, jawbone, alveolar ridge | ['*'] | Bone housing tooth sockets — resorbs after tooth loss |
| 2 | Mandible | mandible | Anatomy | AnatomicalStructure | alveolar-bone | — | Mature | — | ขากรรไกรล่าง, lower jaw | ['*'] | Lower jaw — houses lower teeth implants |
| 3 | Maxilla | maxilla | Anatomy | AnatomicalStructure | alveolar-bone | — | Mature | — | ขากรรไกรบน, upper jaw | ['*'] | Upper jaw — sinus proximity is key challenge |
| 4 | Dental Implant Components | dental-implant-components | Concept | — | dental-implant | — | Mature | 3.2.1 | ส่วนประกอบรากฟันเทียม, implant fixture, abutment, crown | ['*'] | 3-part system: fixture (in bone) + abutment + crown |
| 5 | Maxillary Sinus | maxillary-sinus | Anatomy | AnatomicalStructure | maxilla | — | Mature | 3.2.9.4 | ไซนัสบน, paranasal sinus, sinus floor | ['*'] | Limits upper jaw implant depth — requires Sinus Lift when too close |

---

## brand-doctor-authority: Brand, Doctor & Authority Entities

**Brand Scope:** ['smile-scape']
**Pillar Page:** 2.1
**Domain:** G: Cross-Cutting

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | SmileScape Dental Clinic | smilescape-dental-clinic | Organization | Dentist | — | — | Growing | 1 | SmileScape, Smile Scape Clinic, คลินิกทันตกรรม สไมล์สเคป | ['smile-scape'] | Primary brand entity. schema:additionalType = MedicalBusiness + MedicalClinic |
| 2 | Dr. Woraphat Jarangkul | dr-woraphat-jarangkul | Person | Physician | smilescape-dental-clinic | — | Growing | 2.2.2 | หมอแฮม, ทพ.วรภัทร จรางกุล, Dr. Ham, Lead Implantologist SmileScape | ['smile-scape'] | Medical Director. Mahidol gold medal. Dual M.Sc. Implantology. Trained: Urban (HU) + Kern (BR) + ILAPEO (BR) |
| 3 | SMILE DNA | smile-dna | Concept | — | smilescape-dental-clinic | — | Growing | 2.1.3 | SMILE ค่านิยม, Sincere Mastery Integrity Lifelong-Learning Efficiency | ['smile-scape'] | Brand values framework: S-M-I-L-E |
| 4 | Family Standard | family-standard | Concept | — | smilescape-dental-clinic | — | Growing | 2.1.4 | The Family Standard, ถ้าไม่กล้าทำให้พ่อแม่, family care philosophy | ['smile-scape'] | Brand ethical anchor: "We don't treat patients in ways we wouldn't treat our own parents" |
| 5 | Lifetime Implant Warranty | lifetime-implant-warranty | Concept | — | smilescape-dental-clinic | — | Growing | 2.3.3 | รับประกันตลอดชีพ, lifetime warranty, implant guarantee | ['smile-scape'] | SmileScape's competitive differentiator vs LDC (10-yr) and SmileSeasons (TBD) |

---

## EUG Pre-flight Notes (for Stage 1.5)

Key alias collision risks to check before DB load:
- `clear-aligner` may collide with any other dental brand in federation using same slug → verify `brand_scope=['*']` is correct
- `dental-implant` is category-level entity → check not duplicate of more specific entities- `all-on-x` — multiple names used across brands; verify slug normalization
- `smilescape-dental-clinic` — brand-specific, scope=['smile-scape'] → low collision risk

---

*Phase C output — Entity Genesis. Per Handover §5.3 + Bible Part 2.6. EUG preflight at Stage 1.5.*
