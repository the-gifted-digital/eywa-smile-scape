# SmileScape Dental Clinic — Entity Graph (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis) + Round 2 expansion (2026-05-21)
> **Schema:** §5.3 — 12 columns per entity
> **Date:** 2026-05-11 (initial) / 2026-05-21 (Round 2 — Pediatric/Endo/Anesthesia + Densah + Soft Tissue D-2 Hybrid)
> **EUG Note:** Slugs normalized to kebab-case. `eug_preflight_check()` to run at Stage 1.5 flat-load.
> **Citation linking:** Anchoring citations referenced as `P{pillar}-C{#}` matching `citation-pool-seed.md`.

---

## Entity Type Distribution

| Type | Count | Notes |
|------|-------|-------|
| Treatment | 40 | + 1 R11 (direct-print-clear-aligner Signature #6) + orthodontic-treatment (R27 shared reuse) |
| Procedure | 52 | + dental-scaling (R18) + frenectomy + oral-pathology (R22) + peri-implantitis-treatment et al. (R3) |
| Condition | 27 | + 11 R5 concerns (dental-caries, white-spot-lesion, root-caries, dental-abscess, bruxism, tmj-disorder, halitosis, xerostomia, tooth-fracture, dry-socket, pregnancy-gingivitis) |
| Product | 9 | (unchanged R3) |
| Concept | 16 | + in-house-aligner-lab + thermoformed-aligner (R11) |
| Anatomy | 6 | (unchanged) |
| Device | 16 | + 3 R11 (photopolymer-resin-tc85 + aligner-attachment + 3d-printer-aligner) |
| Organization | 3 | (unchanged) |
| Person | 2 | + dr-tomas-linkevicius (R3 — external authority anchor) |
| **Total** | **167** | (R27: +orthodontic-treatment shared reuse = 167. R22: +frenectomy +oral-pathology = 166. R18: +dental-scaling = 164. R13 recount: 163 rows) |

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
| 2 | Neodent Implant | neodent-implant | Product | MedicalDevice | dental-implant | — | Mature | 4.5.2 | Neodent, Grand Morse, GM, Neodent GM, Brazilian implant, Straumann Group | ['smile-scape'] | Brazil-origin, Straumann Group subsidiary. GM (Grand Morse) connection. Value-premium tier. Backed by Straumann research pipeline. |
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
| 7 | Vertical Bone Augmentation | vertical-bone-augmentation | Procedure | MedicalProcedure | guided-bone-regeneration | — | Mature | 3.2.9.5.2 | การเสริมกระดูกในแนวตั้ง, vertical ridge augmentation, VRA, VBA + RPM | ['*'] | For severe vertical bone deficiency. Urban's specialty. Citation: P2-C2 (Urban 2009 — 5.5mm mean gain). Uses RPM Membrane for Vertical reconstruction |
| 8 | RPM Membrane | rpm-membrane | Device | MedicalDevice | guided-bone-regeneration | — | Growing | 3.2.9.5.2 | Reinforced Permanent Membrane, titanium-reinforced membrane, RPM | ['*'] | Used in vertical bone graft. Non-resorbable + titanium frame for space maintenance |
| 9 | Densah Bur System | densah-bur | Device | MedicalDevice | — | — | Growing | 4.4.4 | Densah, Versah bur, osseodensification bur, Huwais bur | ['smile-scape'] | SmileScape signature device (Signature Offering #5). Versah-manufactured. CCW rotation = bone densification (non-subtractive). Authority: Dr. Salah Huwais |
| 10 | Osseodensification | osseodensification | Procedure | MedicalProcedure | — | — | Growing | 4.4.4 | Osseodensification, densah technique, bone densification | ['smile-scape'] | Authority: Salah Huwais (Versah). Non-subtractive bone preparation — increases primary stability + enables minimally invasive sinus elevation |
| 11 | Internal Sinus Lift (Crestal) | internal-sinus-lift | Procedure | MedicalProcedure | sinus-lift | — | Growing | 3.2.9.4.2 | crestal sinus lift, transcrestal sinus lift, internal sinus elevation, Summer's technique evolved | ['smile-scape'] | Minimally invasive sinus floor elevation via crestal approach. Used with Densah Bur for densification. Signature Offering #5 anchor |
| 12 | Lateral Window Sinus Lift | lateral-window-sinus-lift | Procedure | MedicalProcedure | sinus-lift | — | Mature | 3.2.9.4.1 | lateral approach sinus lift, Caldwell-Luc sinus lift | ['*'] | Traditional sinus elevation via lateral wall access. For larger augmentation needs (>5mm) |

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
| 5 | Dental Caries | dental-caries | Condition | MedicalCondition | — | K02.9 | Mature | 5.6.2 | ฟันผุ, tooth decay, cavity | ['*'] | DFS 22,200/mo TH LOW (R5 traffic goldmine). Re-tier hub to Tier A. Parent condition for white-spot-lesion / root-caries |
| 6 | White Spot Lesion | white-spot-lesion | Condition | MedicalCondition | dental-caries | K02.51 | Mature | 5.6.2.1 | จุดขาวฟัน, early caries, incipient lesion | ['*'] | Reversible early caries — Fluoride treatment can remineralize |
| 7 | Root Caries | root-caries | Condition | MedicalCondition | dental-caries | K02.2 | Mature | 5.6.2.6 | ฟันผุที่รากฟัน, gingival caries | ['*'] | Senior patient concern — Xerostomia + Gum recession exposes root |
| 8 | Dental Abscess | dental-abscess | Condition | MedicalCondition | — | K04.6 | Mature | 5.6.3.2 | ฝีเหงือก, ฟันบวม, periodontal abscess, periapical abscess | ['*'] | DFS เหงือกบวม 22,200/mo TH + เลือดออกตามไรฟัน 6,600/mo combined ~28.8k/mo LOW (R5 goldmine) |
| 9 | Bruxism | bruxism | Condition | MedicalCondition | — | F45.8 | Mature | 5.15.1 | นอนกัดฟัน, ขบฟัน, sleep bruxism, awake bruxism | ['*'] | Common cause of tooth wear + TMJ pain. Treatment: night guard / splint / Botox |
| 10 | TMJ Disorder | tmj-disorder | Condition | MedicalCondition | — | M26.62 | Mature | 5.15 | ข้อต่อขากรรไกร, TMD, jaw joint disorder, TMJ pain | ['*'] | Multifactorial — bruxism + malocclusion + stress + trauma |
| 11 | Halitosis | halitosis | Condition | MedicalCondition | — | R19.6 | Mature | 5.17 | กลิ่นปาก, bad breath, น้ำลายเหม็น | ['*'] | DFS 590/mo TH MEDIUM (R5). Multifactorial — perio + tongue + xerostomia + systemic |
| 12 | Xerostomia (Dry Mouth) | xerostomia | Condition | MedicalCondition | — | K11.7 | Mature | 5.18 | ปากแห้ง, น้ำลายน้อย, dry mouth | ['*'] | DFS 1,900/mo TH LOW (R5). Causes: meds (200+ implicated), Sjögren's, radiation, aging |
| 13 | Tooth Fracture | tooth-fracture | Condition | MedicalCondition | — | S02.5XXA | Mature | 5.16 | ฟันแตก, ฟันบิ่น, ฟันสึก, tooth fracture, dental trauma | ['*'] | DFS combined ~6.6k/mo TH LOW (R5). Includes Attrition / Abfraction / Erosion / Fracture / Cracked Tooth |
| 14 | Dry Socket (Alveolar Osteitis) | dry-socket | Condition | MedicalCondition | tooth-extraction | M27.3 | Mature | 5.19.4 | ภาวะแทรกซ้อนหลังถอนฟัน, alveolar osteitis, fibrinolytic alveolitis | ['*'] | Post-extraction complication — blood clot loss, exposed bone. Severe pain 2-5 days post-op |
| 15 | Pregnancy Gingivitis | pregnancy-gingivitis | Condition | MedicalCondition | gingivitis | K05.10 | Mature | 5.20.4 | เหงือกบวมตอนตั้งครรภ์, hormonal gingivitis | ['*'] | Hormonal-induced gum inflammation. Common 60-75% pregnancies. Treatment in Q2 trimester safest |

---

---

## smile-design-cosmetic: Smile Design & Cosmetic Dentistry

**Brand Scope:** ['*']
**Pillar Page:** 3.4
**Domain:** D: Aesthetic & Cosmetic

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Digital Smile Design | digital-smile-design | Procedure | MedicalProcedure | — | — | Growing | 3.9.1 | DSD, ออกแบบรอยยิ้มดิจิทัล, smile design, digital smile | ['*'] | Digital pre-visualization of smile outcome before treatment |
| 2 | Dental Veneer | dental-veneer | Treatment | MedicalProcedure | — | — | Mature | 3.9.2 | วีเนียร์, porcelain veneer, veneer ฟัน, composite veneer | ['*'] | Thin ceramic shell over tooth surface |
| 3 | Porcelain Veneer | porcelain-veneer | Treatment | MedicalProcedure | dental-veneer | — | Mature | 3.9.2.1 | วีเนียร์พอร์ซเลน, ceramic veneer | ['*'] | Premium — longer lasting than composite. R21: 3.4.2→3.4.2.1 (veneer sub-hub; parent dental-veneer = 3.4.2 hub, DFS veneer 2,400/mo) |
| 4 | Teeth Whitening | teeth-whitening | Treatment | MedicalProcedure | — | — | Mature | 3.9.3 | ฟอกสีฟัน, tooth bleaching, ฟันขาว | ['*'] | R19: renumber 3.4.7→3.4.4. Anchors whitening cluster (Cool Light/Home/Walking Bleach). Device cool-light-whitening-unit @ Tech 4.9.1 |
| 5 | Dental Crown | dental-crown | Treatment | MedicalDevice | — | — | Mature | 3.5.1 | ครอบฟัน, tooth cap, crown | ['*'] | R18: moved 3.4.4→3.14.1 (Restorative section). Also anchors bridge 3.14.2 + inlay/onlay 3.14.3 |
| 6 | Zirconia Crown | zirconia-crown | Treatment | MedicalDevice | dental-crown | — | Mature | 3.5.1.1 | ครอบฟันเซอร์โคเนีย, zirconia cap | ['*'] | All-ceramic crown — high aesthetic + strength. R18: 3.4.4.1→3.14.1.1 |
| 7 | Gold Crown | gold-crown | Treatment | MedicalDevice | dental-crown | — | Mature | 3.5.1.4 | ครอบฟันทอง, ครอบฟันทองคำ, gold crown, ครอบฟันโลหะมีค่า, ทองครอบฟัน | ['*'] | Premium metal-ceramic / full-cast gold crown. Long lifespan, biocompatibility, posterior teeth preference. Traditional Asian luxury anchor. DFS volume: gold crown 320/mo TH LOW competition (R3-validated). R18: 3.4.4.4→3.14.1.4 |

---

## gum-soft-tissue: Gum & Soft Tissue Management

**Brand Scope:** ['*']
**Pillar Page:** 3.2.9.7
**Domain:** F: Periodontics & Gum

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Soft Tissue Management | soft-tissue-management | Procedure | MedicalProcedure | — | — | Growing | 3.2.9.7 | การจัดการเนื้อเยื่ออ่อน, gum management, soft tissue surgery, perio aesthetics | ['smile-scape'] | Studied with Dr. Ricardo Kern (Brazil). Pink aesthetic protocol. Citation: P5-C1 (Benic 2014) |
| 2 | Gum Contouring | gum-contouring | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.9.4 | ตกแต่งเหงือก, gummy smile correction, gingivoplasty | ['*'] | Reshaping gum line for aesthetic purposes. R19: renumber 3.4.8→3.4.5 |
| 3 | Connective Tissue Graft | connective-tissue-graft | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.2.9.7 | ปลูกถ่ายเนื้อเยื่อ, CTG, subepithelial connective tissue graft | ['*'] | Gum recession correction around implants |
| 4 | Peri-Implant Mucosa | peri-implant-mucosa | Anatomy | AnatomicalStructure | — | — | Mature | 3.2.9.7 | เนื้อเยื่อรอบรากเทียม, peri-implant tissue | ['*'] | Soft tissue surrounding implant — key aesthetic determinant |
| 5 | Keratinized Mucosa | keratinized-mucosa | Anatomy | AnatomicalStructure | peri-implant-mucosa | — | Mature | 3.7.5 | เนื้อเยื่อแข็ง, keratinized gingiva, attached gingiva | ['*'] | Adequate band required for long-term peri-implant health |
| 6 | Strip Graft | strip-graft | Procedure | MedicalProcedure | soft-tissue-management | — | Growing | 3.2.9.7.1.3 | Urban strip graft, modified strip graft | ['smile-scape'] | Dr. Istvan Urban signature technique for keratinized tissue augmentation. Studied directly by Dr. Woraphat |
| 7 | Ice Berg / Ice Cube Technique | ice-berg-technique | Procedure | MedicalProcedure | soft-tissue-management | — | Growing | 3.2.9.7.2.1 | Ice Berg technique, Ice Cube technique, Urban thickness graft | ['smile-scape'] | Dr. Istvan Urban signature for gingival thickness augmentation. Biomaterial-shaped technique |
| 8 | Garage Technique | garage-technique | Procedure | MedicalProcedure | soft-tissue-management | — | Growing | 3.2.9.7.2.2 | Urban garage technique, papilla preservation graft | ['smile-scape'] | Dr. Istvan Urban signature — papilla preservation in implant zones |
| 9 | VIPCT — Vascularized Interpositional Periosteal CT | vipct | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.2.9.7.2.3 | VIPCT, vascularized graft, periosteal CT graft, Sclar graft | ['*'] | Vascularized interpositional periosteal connective tissue graft. Popularized by Sclar/Zucchelli |
| 10 | Coronally Advanced Flap (CAF) | caf | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.2.9.7.3.1 | CAF, coronally advanced flap, Zucchelli technique | ['*'] | Gold standard root coverage. 40+ years literature |
| 11 | Tunneling Technique | tunneling-technique | Procedure | MedicalProcedure | soft-tissue-management | — | Mature | 3.2.9.7.3.2 | tunneling, tunnel approach, Allen tunnel, Zabalegui tunnel | ['*'] | Minimally invasive root coverage. Allen 1994 / Zabalegui 1999 |
| 12 | VISTA Technique | vista-technique | Procedure | MedicalProcedure | soft-tissue-management | — | Growing | 3.2.9.7.3.3 | VISTA, Vestibular Incision Subperiosteal Tunnel Access, Zadeh VISTA | ['*'] | Zadeh 2011 named technique — minimal incision multiple root coverage |
| 13 | Tunneled CAF (TCAF) | tcaf | Procedure | MedicalProcedure | soft-tissue-management | — | Growing | 3.2.9.7.3.4 | TCAF, tunneled coronally advanced flap, hybrid CAF | ['*'] | Hybrid technique combining tunneling + CAF — for advanced root coverage |
| 14 | Black Triangle | black-triangle | Condition | MedicalCondition | — | — | Mature | 5.11.5 | ช่องว่างระหว่างเหงือก, gingival embrasure, open interdental space | ['*'] | Triangular gap between teeth due to papilla loss. Aesthetic concern requiring soft tissue intervention |

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
| 4 | Peri-Implantitis | peri-implantitis | Condition | MedicalCondition | periodontitis | M27.62 | Mature | 3.7.7 | การติดเชื้อรอบรากเทียม, implant infection, peri-implant disease | ['*'] | Implant-site infection — major threat to implant longevity. PP-14. DFS: peri-implantitis 140/mo TH LOW competition (R3-validated → dedicated service hub 3.7.7) |
| 5 | Peri-Implantitis Treatment | peri-implantitis-treatment | Procedure | MedicalProcedure | peri-implantitis | M27.62 | Growing | 3.7.7 | รักษา peri-implantitis, peri-implantitis surgery, peri-implant infection treatment | ['*'] | Multi-modality service: non-surgical decontamination + surgical access + regenerative/resective + implantoplasty + laser. Salvage vs explantation decision tree. Dedicated service R3 |
| 6 | Implantoplasty | implantoplasty | Procedure | MedicalProcedure | peri-implantitis-treatment | — | Growing | 3.7.7.6 | implantoplasty, implant surface modification, รากเทียมปรับผิว | ['*'] | Mechanical smoothing of exposed implant threads — reduces biofilm retention |
| 7 | Regenerative Peri-Implantitis Surgery | regenerative-peri-implantitis-surgery | Procedure | MedicalProcedure | peri-implantitis-treatment | — | Growing | 3.7.7.4 | regenerative peri-implant surgery, peri-implant bone graft, GBR rescue | ['*'] | Bone grafting around failing implant to restore bone support |
| 8 | Resective Peri-Implantitis Surgery | resective-peri-implantitis-surgery | Procedure | MedicalProcedure | peri-implantitis-treatment | — | Mature | 3.7.7.5 | resective peri-implant surgery, apically positioned flap | ['*'] | Bone reshaping + apical repositioning — for advanced defects where regeneration not predictable |
| 9 | Dental Laser Therapy | dental-laser-therapy | Procedure | MedicalProcedure | — | — | Growing | 3.7.7.7 | dental laser, Er:YAG laser, diode laser, photobiomodulation | ['*'] | Adjunctive therapy in periodontics + peri-implantitis. Decontamination + healing acceleration |

---

## clear-aligner-orthodontics: Clear Aligner & Orthodontics

**Brand Scope:** ['*']
**Pillar Page:** 3.5
**Domain:** E: Orthodontics

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Clear Aligner | clear-aligner | Treatment | MedicalProcedure | — | M26.4 | Mature | 3.10.1 | จัดฟันใส, invisible braces, aligner, transparent aligner | ['*'] | Removable clear aligner system. Citation: P4-C1 (Alhamwi 2024) |
| 2 | TrioClear Aligner System | trioclear-aligner | Product | MedicalDevice | clear-aligner | — | Growing | 4.6.1 | TrioClear, TrioClear Progressive, จัดฟันใส TrioClear | ['smile-scape'] | Modern Dental (HK). Progressive force design. NOT Invisalign. |
| 3 | Damon Self-Ligating System | damon-system | Product | MedicalDevice | — | — | Mature | 4.6.2 | Damon, Damon Q, Damon Clear, self-ligating braces, จัดฟัน Damon | ['smile-scape'] | Passive self-ligation — lower friction, fewer adjustments |
| 4 | Malocclusion | malocclusion | Condition | MedicalCondition | — | M26.4 | Mature | 3.10 | ฟันเรียงไม่ตรง, crowded teeth, misaligned teeth, jaw mismatch | ['*'] | Primary indication for orthodontic treatment |
| 5 | Orthodontic-Implant Sequencing | ortho-implant-sequencing | Concept | MedicalProcedure | malocclusion | — | Growing | 3.10.6 | จัดฟันก่อนรากฟันเทียม, ortho before implant, interdisciplinary planning | ['*'] | SmileScape differentiator — interdisciplinary specialty combo |
| 6 | Orthognathic Surgery | orthognathic-surgery | Procedure | MedicalProcedure | malocclusion | — | Mature | 3.10.8 | ผ่าตัดขากรรไกร, จัดฟันร่วมผ่าตัด, jaw surgery, BSSO, Le Fort I, bimaxillary surgery | ['*'] | Combined ortho + surgical for skeletal Class II/III + facial asymmetry. SmileScape interdisciplinary service |
| 7 | Passive Self-Ligating (PSL) | passive-self-ligating | Concept | MedicalDevice | damon-system | — | Growing | 3.10.3.1 | PSL, passive self-ligating braces, จัดฟัน PSL, Damon PSL | ['*'] | Brackets with sliding doors that don't bind archwire. Damon Q (metal) / Damon Clear (ceramic) |
| 8 | Direct Print Clear Aligner | direct-print-clear-aligner | Treatment | MedicalProcedure | clear-aligner | M26.4 | Growing | 3.10.1.2 | Direct Print Aligner, 3D printed aligner, in-house aligner, photopolymer aligner | ['smile-scape'] | **Signature Offering #6 (R11)**. In-house 3D direct-print manufacturing. Subtype of clear-aligner. Authority: Graphy TC-85DAC + Tera Harz TC-85 FDA-cleared photopolymers. 6 PubMed citations 2021-2025. Key differentiator: fewer attachments vs thermoformed (Invisalign/TrioClear) |
| 9 | In-House Aligner Lab | in-house-aligner-lab | Concept | — | smilescape-dental-clinic | — | Growing | 4.6.0 | คลินิกผลิตจัดฟันใสเอง, in-house aligner production | ['smile-scape'] | SmileScape's in-clinic aligner manufacturing capability. Same-day production. Customizable mid-treatment. R11 Signature anchor |
| 10 | Photopolymer Resin TC-85 | photopolymer-resin-tc85 | Product | — | direct-print-clear-aligner | — | Growing | 4.6.0.2 | Graphy TC-85DAC, Tera Harz TC-85, photopolymer aligner resin, FDA-cleared aligner material | ['smile-scape'] | FDA-cleared photopolymer for direct-print aligner. Operator confirm which brand SmileScape uses (Graphy vs Tera Harz vs other). Citation: PMID 42076391 (Tera Harz TC-85 specific) |
| 11 | Aligner Attachment | aligner-attachment | Device | MedicalDevice | clear-aligner | — | Mature | 3.10.1.5 | attachment, composite attachment, aligner button | ['*'] | Composite tooth-bonded buttons for thermoformed aligner retention. R11 Direct Print uses FEWER of these due to built-in features |
| 12 | 3D Printer (Aligner) | 3d-printer-aligner | Device | MedicalDevice | in-house-aligner-lab | — | Growing | 4.6.0.1 | Asiga Pro4K, SprintRay Pro95, Formlabs Form 3B+, dental 3D printer | ['smile-scape'] | Photopolymer 3D printer for direct-print aligner. Specific model TBD operator confirm |
| 13 | Thermoformed Aligner | thermoformed-aligner | Concept | MedicalProcedure | clear-aligner | — | Mature | 3.10.1.4 | thermoformed aligner, vacuum-formed aligner, traditional aligner, Invisalign-style aligner | ['*'] | Traditional aligner production: thermoform plastic over 3D-printed model. Used by Invisalign, TrioClear, ClearCorrect. Comparison anchor for Direct Print differentiation content |
| 14 | Orthodontic Treatment | orthodontic-treatment | Treatment | MedicalProcedure | — | M26.4 | Mature | 3.10.4 | จัดฟัน, orthodontics, braces, จัดฟันเหล็ก, จัดฟันผู้ใหญ่ | ['*'] | R27 (2026-07-09): shared universal entity — already in federation graph; adopted per EUG (Search Before Create) to resolve R17 orphan `orthodontic-intervention` (3.10.4/.5/.7 remapped) |

---

## general-restorative: General Restorative Dentistry

**Brand Scope:** ['*']
**Pillar Page:** 3.6
**Domain:** A: Dental Implant (supporting)

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Root Canal Treatment | root-canal-treatment | Treatment | MedicalProcedure | — | K04.0 | Mature | 3.6 | รักษารากฟัน, endodontic treatment, RCT | ['*'] | Alternative to extraction when tooth can be saved. R18: 3.6.5 stub removed → canonical home Section 3.11 Endodontics |
| 2 | Tooth Extraction | tooth-extraction | Procedure | MedicalProcedure | — | K08.409 | Mature | 3.4.3 | ถอนฟัน, tooth removal | ['*'] | Often precedes implant placement |
| 3 | Wisdom Tooth Removal | wisdom-tooth-removal | Procedure | MedicalProcedure | tooth-extraction | K01.1 | Mature | 3.4.4 | ผ่าฟันคุด, impacted wisdom tooth removal, third molar extraction | ['*'] | |
| 4 | Dental Filling | dental-filling | Treatment | MedicalProcedure | — | K02.9 | Mature | 3.4.2 | อุดฟัน, composite filling, tooth filling | ['*'] | |
| 5 | Removable Denture | removable-denture | Treatment | MedicalDevice | — | — | Mature | 3.5.4 | ฟันปลอมถอดได้, complete denture, partial denture | ['*'] | Often starting point before All-on-X conversion. R18: moved 3.6.6→3.14.4 (Restorative & Prosthetic) |
| 6 | Torus Removal | torus-removal | Procedure | MedicalProcedure | — | — | Mature | 3.8.6 | ตัดปุ่มกระดูก, torus mandibularis removal, torus palatinus removal, exostosis removal | ['*'] | Surgical removal of bony exostosis (mandibular/palatal torus). Often pre-prosthetic |
| 7 | Alveoloplasty | alveoloplasty | Procedure | MedicalProcedure | — | — | Mature | 3.8.6.4 | ปรับสันกระดูก, alveolar ridge recontouring, ridge reduction | ['*'] | Reshaping alveolar bone for prosthesis or implant fit |
| 8 | Maxillary Tuberosity Reduction | tuberectomy | Procedure | MedicalProcedure | alveoloplasty | — | Mature | 3.8.6.3 | ปรับปุ่มกระดูกหลังฟันบน, maxillary tuberosity surgery | ['*'] | Reducing posterior maxillary bony prominence — pre-prosthetic or pre-implant |
| 9 | Dental Scaling & Prophylaxis | dental-scaling | Procedure | MedicalProcedure | — | K03.6 | Mature | 3.4.1 | ขูดหินปูน, ขูดหินปูน ราคา, dental scaling, dental cleaning, prophylaxis, tartar removal, ขูดหินปูน เจ็บไหม, scaling root planing | ['*'] | R18 NEW (#164). DFS goldmine 12,100/mo TH LOW competition — anchors General cleaning cluster (8 long-tail pages). Previously mis-tagged as dental-filling. SRP for early perio also under periodontitis |
| 10 | Frenectomy | frenectomy | Procedure | MedicalProcedure | — | — | Mature | 3.8.4 | ตัดเอ็นยึดลิ้น, frenectomy, ตัดพังผืดใต้ลิ้น, lingual frenectomy, labial frenectomy, ลิ้นติด | ['*'] | R22 NEW (#165). Soft-tissue release of lingual/labial frenum (tongue-tie / lip-tie). Was mis-tagged tooth-extraction |
| 11 | Oral Pathology Surgery | oral-pathology | Procedure | MedicalProcedure | — | — | Mature | 3.8.2 | ผ่าตัดเนื้องอกในช่องปาก, oral pathology, ผ่าตัดซีสต์, cyst removal, oral lesion removal, biopsy | ['*'] | R22 NEW (#166). Surgical removal/biopsy of oral lesions, tumors, cysts (anchors 3.8.2 + 3.8.3). Was mis-tagged tooth-extraction |

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
| 6 | Acteon CBCT | acteon-cbct | Device | MedicalDevice | cbct-3d-scan | — | Mature | 4.2.1 | Acteon X-Mind Trium, Acteon CBCT, X-Mind Trium 3D | ['smile-scape'] | SmileScape CBCT brand — Acteon (France). X-Mind Trium series. Low-dose protocol. 3D + Pano + Ceph all-in-one |
| 7 | 3Shape TRIOS Intraoral Scanner | trios-intraoral-scanner | Device | MedicalDevice | intraoral-scanner | — | Mature | 4.2.2 | 3Shape TRIOS, TRIOS 5, TRIOS scanner, 3Shape IOS | ['smile-scape'] | SmileScape IOS brand — 3Shape (Denmark). TRIOS 5 wireless. Realcolor. <50μm accuracy. Chairside CAD/CAM workflow |
| 8 | Airflow Air Polishing System | airflow-air-polishing | Device | MedicalDevice | — | — | Growing | 4.4.5 | Airflow, EMS Airflow, air polishing, ขูดหินปูน Airflow, GBT | ['*'] | Air-water-powder system for biofilm and stain removal. Patient-friendly alternative to ultrasonic |
| 9 | Cool Light Whitening Unit | cool-light-whitening-unit | Device | MedicalDevice | — | — | Growing | 4.9.1 | Cool Light, cool light whitening, LED whitening lamp | ['smile-scape'] | In-office whitening with cool-light activation. No heat → reduces sensitivity. SmileScape signature whitening method |

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

## pediatric-dentistry: Pediatric Dentistry — ทันตกรรมเด็ก

**Brand Scope:** ['*']
**Pillar Page:** 3.9
**Domain:** H: Specialty Services

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Pediatric Dentistry | pediatric-dentistry | Treatment | MedicalProcedure | — | — | Mature | 3.11 | ทันตกรรมเด็ก, kids dentistry, pediatric dental care | ['*'] | Specialty branch — covers all dental care for children 0-12 |
| 2 | Pediatric Pulpotomy | pediatric-pulpotomy | Procedure | MedicalProcedure | pediatric-dentistry | K04.0 | Mature | 3.11.6 | รักษารากฟันน้ำนม, pulpotomy, pulpectomy, baby tooth pulp | ['*'] | Pulp therapy for primary teeth — vital pulp therapy or pulpectomy |
| 3 | Pediatric Crown | pediatric-crown | Treatment | MedicalDevice | dental-crown | — | Mature | 3.11.7 | ครอบฟันเด็ก, stainless steel crown, SSC, zirconia pediatric crown | ['*'] | SS or zirconia crown for primary molars after pulp therapy or extensive caries |
| 4 | Fluoride Treatment | fluoride-treatment | Treatment | MedicalProcedure | pediatric-dentistry | — | Mature | 3.11.4 | เคลือบฟลูออไรด์, fluoride varnish, topical fluoride | ['*'] | Caries prevention — varnish, gel, or rinse application |
| 5 | Pit & Fissure Sealant | pit-fissure-sealant | Treatment | MedicalProcedure | pediatric-dentistry | — | Mature | 3.11.5 | เคลือบหลุมร่องฟัน, dental sealant, occlusal sealant | ['*'] | Resin coating on permanent molars to prevent occlusal caries |
| 6 | Space Maintainer | space-maintainer | Device | MedicalDevice | pediatric-dentistry | — | Mature | 3.11.8 | เครื่องมือกันฟันล้ม, space maintainer, band & loop, lingual arch | ['*'] | Maintains arch length after premature primary tooth loss |
| 7 | Behavior Management (Pediatric) | behavior-management | Concept | — | pediatric-dentistry | — | Mature | 3.11.11 | จัดการพฤติกรรมเด็ก, tell-show-do, behavior guidance | ['*'] | Communication/behavioral techniques for treating fearful pediatric patients |
| 8 | Early Orthodontic Intervention | early-orthodontic-intervention | Treatment | MedicalProcedure | pediatric-dentistry | M26.4 | Growing | 3.11.12 | จัดฟันเด็ก, interceptive ortho, Phase I orthodontics, ortho intervention | ['*'] | Phase I orthodontics — corrects developing malocclusion in mixed dentition |
| 9 | Habit Appliance | habit-appliance | Device | MedicalDevice | pediatric-dentistry | — | Mature | 3.11.10 | เครื่องมือแก้นิสัย, thumb sucking appliance, tongue crib | ['*'] | Appliance to break harmful oral habits (thumb sucking, tongue thrust) |
| 10 | Pediatric Extraction | pediatric-extraction | Procedure | MedicalProcedure | tooth-extraction | K08.409 | Mature | 3.11.9 | ถอนฟันน้ำนม, primary tooth extraction, baby tooth removal | ['*'] | Extraction of primary teeth — timing and technique differ from permanent |

---

## endodontics-specialist: Endodontics by Specialist — รักษารากฟันโดยทันตแพทย์เฉพาะทาง

**Brand Scope:** ['*']
**Pillar Page:** 3.11
**Domain:** H: Specialty Services

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Endodontic Microscope | endodontic-microscope | Device | MedicalDevice | — | — | Growing | 3.6.4 | dental operating microscope, DOM, endodontic OM | ['*'] | High-magnification microscope for endodontic precision. Standard-of-care for specialists |
| 2 | Root Canal Retreatment | root-canal-retreatment | Procedure | MedicalProcedure | root-canal-treatment | K04.0 | Mature | 3.6.2 | รักษารากฟันซ้ำ, endo retreatment, root canal redo | ['*'] | Treatment of previously root-canaled tooth that failed |
| 3 | Apicoectomy | apicoectomy | Procedure | MedicalProcedure | root-canal-treatment | K04.0 | Mature | 3.6.3 | ผ่าตัดปลายราก, root-end surgery, apical surgery, surgical endodontics | ['*'] | Surgical removal of root apex + retrograde filling — last-resort to save tooth |
| 4 | Internal Bleaching | internal-bleaching | Treatment | MedicalProcedure | root-canal-treatment | — | Mature | 3.6.6 | ฟอกฟันตายภายใน, intracoronal bleaching, walking bleach, non-vital bleaching | ['*'] | Bleaching from inside non-vital tooth — for darkened endo-treated teeth |
| 5 | Cracked Tooth | cracked-tooth | Condition | MedicalCondition | — | S02.5XXA | Mature | 3.6.7 | ฟันร้าว, cracked tooth syndrome, vertical root fracture | ['*'] | Diagnosis challenge — endo specialist tools required to confirm |
| 6 | Pulp Regeneration | pulp-regeneration | Procedure | MedicalProcedure | root-canal-treatment | — | Emerging | 3.6.8 | regenerative endodontics, REP, revascularization, apexogenesis | ['*'] | Newer technique for immature permanent teeth — promotes pulp tissue regrowth |
| 7 | Rotary Endodontic System | rotary-endodontic-system | Device | MedicalDevice | — | — | Mature | 3.6.5 | rotary file, reciprocating endo, NiTi rotary | ['*'] | Mechanized files for canal preparation — faster + more consistent than hand instrumentation |

---

## dental-anesthesia: Sedation & GA Dentistry — ดมยาสลบทำฟัน

**Brand Scope:** ['*']
**Pillar Page:** 3.10
**Domain:** H: Specialty Services

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Conscious Sedation | conscious-sedation | Procedure | MedicalProcedure | — | — | Mature | 3.12.1 | sedation dentistry, minimal sedation, oral sedation, nitrous oxide | ['*'] | Mild sedation — patient awake but relaxed. Nitrous oxide / oral sedation routes |
| 2 | General Anesthesia Dentistry | ga-dentistry | Procedure | MedicalProcedure | — | — | Mature | 3.12.3 | ดมยาสลบทำฟัน, dental general anesthesia, GA dentistry, IV anesthesia | ['*'] | Full unconsciousness for complex/anxious patients. Requires anesthesiologist + monitoring |
| 3 | IV Sedation | iv-sedation | Procedure | MedicalProcedure | conscious-sedation | — | Mature | 3.12.2 | intravenous sedation, moderate sedation, twilight sedation | ['*'] | Moderate sedation via IV — between conscious and GA |
| 4 | Dental Anxiety / Phobia | dental-anxiety | Condition | MedicalCondition | — | F40.218 | Mature | 5.4 | กลัวหมอฟัน, dental phobia, odontophobia | ['*'] | Common reason for sedation dentistry referral |

---

## demographic-dentistry: Demographic-Specific Dentistry — ทันตกรรมสำหรับคนเฉพาะกลุ่ม

**Brand Scope:** ['*']
**Pillar Page:** 3.13
**Domain:** H: Specialty Services

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Geriatric Dentistry | geriatric-dentistry | Treatment | MedicalProcedure | — | — | Mature | 3.13.1 | ทันตกรรมผู้สูงอายุ, ทำฟันผู้สูงอายุ, senior dentistry | ['*'] | DFS 70/mo TH LOW (R8). Demographic-specific service section. Anchor for aging-Thailand strategic positioning |
| 2 | Pregnancy Dental Care | pregnancy-dental-care | Treatment | MedicalProcedure | — | — | Mature | 3.13.2 | ทันตกรรมหญิงตั้งครรภ์, ทำฟันคนท้อง, prenatal dental | ['*'] | Service-side. Q2 trimester safest. Companion to 5.20 concern cluster + pregnancy-gingivitis condition entity |
| 3 | Medical-Compromised Dentistry | medical-compromised-dentistry | Treatment | MedicalProcedure | — | — | Mature | 3.13.3 | ทันตกรรมผู้ป่วยโรคเรื้อรัง, special medical considerations dentistry | ['*'] | Service-side for chronic disease patients. Companion to 5.8 medical comorbidity concerns |
| 4 | Bedridden Patient Dentistry | bedridden-dentistry | Treatment | MedicalProcedure | geriatric-dentistry | — | Growing | — | ทำฟันผู้ป่วยติดเตียง, home visit dentistry, ทำฟันที่บ้าน | ['*'] | R9: SmileScape does NOT offer this service — entity kept for federation reuse (universal scope). Sitemap page 3.13.1.2 deleted in R9 |
| 5 | Medical Clearance Protocol | medical-clearance-protocol | Concept | — | medical-compromised-dentistry | — | Mature | 3.13.3.8 | ใบรับรองแพทย์, pre-operative medical clearance | ['*'] | Pre-op screening for medical-compromised patients before invasive dental procedures |
| 6 | Special Needs Dentistry | special-needs-dentistry | Treatment | MedicalProcedure | — | — | Growing | 3.13.4 | ทันตกรรมสำหรับผู้ป่วยพิเศษ, Autism dentistry, dementia dentistry, special care dentistry | ['*'] | Service for patients with special behavioral/cognitive needs. Often paired with sedation (3.10) |

---

## insurance-coverage-th: Insurance Coverage Thailand — ประกันสังคม / บัตรทอง / ราชการ / เอกชน

**Brand Scope:** ['*'] mixed (sso-direct-billing-q-clinic is ['smile-scape'])
**Pillar Page:** 3.12
**Domain:** I: Insurance & Access

| # | Entity Name | Slug | Type | Schema.org | Parent (text) | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes |
|---|-------------|------|------|------------|---------------|--------|-----------|--------------|---------|-------------|-------|
| 1 | Social Security Dental Benefit (TH) | social-security-dental-benefit | Concept | — | — | — | Mature | 5.13.2 | ประกันสังคมทำฟัน, สิทธิ์ประกันสังคมทำฟัน, SSO dental, ม.33 ทำฟัน | ['*'] | Thai SSO Article 33/39/40 dental benefit. Annual cap 900 baht (operator confirm if updated to 1,200). Covers scaling/filling/extraction/wisdom-tooth + separate denture cap 1,500-4,400 baht/5yr |
| 2 | Q-Clinic Direct Billing (SSO) | sso-direct-billing-q-clinic | Concept | — | social-security-dental-benefit | — | Growing | 3.14.1 | ไม่ต้องสำรองจ่าย, Q-Clinic, SSO direct bill, ทำฟันไม่ต้องสำรองจ่าย | ['smile-scape'] | SmileScape Q-Clinic status (R4-confirmed). Direct billing model — patient pays only out-of-pocket excess. Key conversion differentiator |
| 3 | Universal Coverage (บัตรทอง / 30 บาท) | universal-coverage-th | Concept | — | — | — | Mature | 5.13.2.5 | บัตรทอง, 30 บาท, สปสช, UCS, universal coverage | ['*'] | NHSO scheme — distinct from SSO. Often confused with SSO; comparison content valuable. Operator to confirm SmileScape acceptance |
| 4 | Civil Servant Medical Benefit (CGA) | civil-servant-dental-benefit | Concept | — | — | — | Mature | 5.13.5 | ราชการเบิกค่าทำฟัน, ข้าราชการ ทำฟัน, กรมบัญชีกลาง, CGA | ['*'] | Comptroller General's Dept scheme for govt employees + family. Direct billing acceptance TBD |
| 5 | Private Health Insurance (TH Dental) | private-dental-insurance-th | Concept | — | — | — | Mature | 5.13.6 | ประกันสุขภาพเอกชน ทำฟัน, AIA dental, Cigna dental | ['*'] | Private insurer dental rider — reimbursement model typically. Receipt + medical certificate required |

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
| 6 | SmileScape สาขารัตนาธิเบศร์ | smilescape-rattanathibet | Organization | Dentist | smilescape-dental-clinic | — | Growing | 8.2 | สาขารัตนาธิเบศร์, SmileScape Rattanathibet, SmileScape นนทบุรี, สาขานนทบุรี, MRT สีม่วง | ['smile-scape'] | Primary branch. Transit: MRT สีม่วง สถานีรัตนาธิเบศร์. Full address/GPS/phone TBD. See `branches.md`. schema:LocalBusiness + Dentist |
| 7 | SmileScape สาขาศรีนครินทร์ | smilescape-srinakarin | Organization | Dentist | smilescape-dental-clinic | — | Growing | 8.3 | สาขาศรีนครินทร์, SmileScape Srinakarin, SmileScape สวนหลวง ร.9, MRT สีเหลือง | ['smile-scape'] | Primary branch. Transit: MRT สีเหลือง. Full address/GPS/phone TBD. See `branches.md`. schema:LocalBusiness + Dentist |
| 8 | Zero Bone Loss Concept | zero-bone-loss-concept | Concept | — | smilescape-dental-clinic | — | Growing | 2.1.6 | Zero Bone Loss, ZBL Protocol, Linkevicius Protocol, ZBL Concept | ['smile-scape'] | Brand clinical framework (R3). Authority: Dr. Tomas Linkevicius (Lithuania, 2009+ research, 2019 Quintessence textbook). Pairs with SMILE DNA + Family Standard as brand triad. Subcrestal placement / platform switching / tissue-level abutment / cement-screw retention / KM ≥2mm / maintenance protocol. Pending operator: หมอแฮม Linkevicius training credential. DFS volume: zero bone loss concept 20/mo (E-E-A-T anchor, not traffic target) |
| 9 | Dr. Tomas Linkevicius | dr-tomas-linkevicius | Person | Physician | — | — | Mature | — | Tomas Linkevicius, Linkevicius, Linkevichus, Vilnius Implant | ['*'] | External authority anchor — Lithuanian implant specialist, author "Zero Bone Loss Concept" (Quintessence 2019). Referenced for E-E-A-T in implant content. DFS: linkevicius 10/mo TH |

---

## EUG Pre-flight Notes (for Stage 1.5)

Key alias collision risks to check before DB load:
- `clear-aligner` may collide with any other dental brand in federation using same slug → verify `brand_scope=['*']` is correct
- `dental-implant` is category-level entity → check not duplicate of more specific entities
- `all-on-x` — multiple names used across brands; verify slug normalization
- `smilescape-dental-clinic` — brand-specific, scope=['smile-scape'] → low collision risk
- `neodent-implant` (new) — brand-scope=['smile-scape'] per SS-DR-001 Round 2; verify NOT already universal
- `densah-bur` + `osseodensification` + `internal-sinus-lift` (new) — brand-scope=['smile-scape'] tied to Signature Offering #5
- Urban signature techniques `strip-graft` / `ice-berg-technique` / `garage-technique` — brand-scope=['smile-scape']; cross-check potential federation collision with future EYWA dental brands
- New Specialty cluster slugs (`pediatric-dentistry`, `endodontics-specialist`, `dental-anesthesia`) — verify cluster-name vs entity-name disambiguation (cluster slug ≠ entity slug)

---

*Phase C output — Entity Genesis. Per Handover §5.3 + Bible Part 2.6. EUG preflight at Stage 1.5.*
*Round 2 expansion (2026-05-21) — +48 entities for Pediatric/Endo/Anesthesia services + Densah signature + Soft Tissue D-2 Hybrid + Tech rebrand (Acteon/3Shape/Airflow/Cool Light).*
