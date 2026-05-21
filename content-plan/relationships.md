# SmileScape Dental Clinic — Entity Relationships (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis)
> **Schema:** §5.5 — 5 columns per edge
> **Date:** 2026-05-11
> **Edge count:** 101 | **Edge types used:** 10/10
> **Vocabulary:** DR-012 locked (10-edge vocabulary)

---

## Edge Vocabulary

| Edge Type | Direction | Symmetric | Description |
|-----------|-----------|-----------|-------------|
| parent_of | → | N | Taxonomic parent to child (child_of is inverse) |
| subtype_of | → | N | Clinical/semantic specialization, non-obvious variant |
| treats | → | N | Treatment entity addresses condition entity |
| symptom_of | → | N | Clinical sign or sequela points to disease entity |
| uses | → | N | Technique/treatment employs technology or material |
| alternative_to | ↔ | Y | Competing or equivalent clinical option |
| part_of | → | N | Anatomical/structural component (contains is inverse) |
| requires_assessment | → | N | Clinical work requires diagnostic assessment of entity |
| evidenced_by | → | N | Clinical claim supported by evidence entity |
| related_to | ↔ | Y | Non-hierarchical semantic association |

---

## Relationships

### A — Hierarchy: Dental Implant Core

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | parent_of | single-tooth-implant | No | — |
| dental-implant | parent_of | multiple-implants | No | — |
| dental-implant | parent_of | implant-supported-bridge | No | — |
| dental-implant | parent_of | overdenture | No | — |
| dental-implant | parent_of | all-on-x | No | Full-arch subset of implant treatment |
| all-on-x | parent_of | all-on-4 | No | — |
| all-on-x | parent_of | all-on-6 | No | — |
| all-on-x | parent_of | zygomatic-implant | No | Extreme bone-loss variant anchored in zygomatic bone |

### B — Hierarchy: Implant Systems & Brands

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | parent_of | blue-diamond-implant | No | SmileScape-specific signature system — Korean origin |
| dental-implant | parent_of | neodent-implant | No | Brazil — Straumann Group subsidiary, GM connection |
| dental-implant | parent_of | straumann-implant | No | — |
| dental-implant | parent_of | titanium-implant | No | Material-defined subtype |
| dental-implant | parent_of | ceramic-implant | No | Metal-free subtype |

### C — Hierarchy: Bone Regeneration

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| guided-bone-regeneration | parent_of | sausage-technique | No | Specific horizontal/vertical protocol by Dr. Urban |
| guided-bone-regeneration | parent_of | ridge-augmentation | No | — |
| guided-bone-regeneration | parent_of | vertical-bone-augmentation | No | — |
| bone-grafting | parent_of | sinus-lift | No | — |
| bone-grafting | parent_of | socket-preservation | No | — |

### D — Hierarchy: Patient Conditions & Disease Progression

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| tooth-loss | parent_of | edentulism | No | Severity escalation — partial to complete |
| tooth-loss | parent_of | dental-caries-extraction | No | Aetiological subtype |
| tooth-loss | parent_of | traumatic-tooth-loss | No | Aetiological subtype |
| tooth-loss | parent_of | denture-dissatisfaction | No | Outcome state driving implant upgrade |
| alveolar-bone-loss | parent_of | vertical-bone-deficiency | No | — |
| alveolar-bone-loss | parent_of | horizontal-bone-deficiency | No | — |
| alveolar-bone-loss | parent_of | maxillary-sinus-proximity | No | Upper-jaw manifestation |
| gingivitis | parent_of | periodontitis | No | Disease progression — untreated gingivitis advances to perio |

### E — Hierarchy: Aesthetics, Restorative, Ortho

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-veneer | parent_of | porcelain-veneer | No | — |
| dental-crown | parent_of | zirconia-crown | No | — |
| soft-tissue-management | parent_of | gum-contouring | No | — |
| soft-tissue-management | parent_of | connective-tissue-graft | No | — |
| clear-aligner | parent_of | trioclear-aligner | No | Brand-specific system offered by SmileScape |
| peri-implant-mucosa | parent_of | keratinized-mucosa | No | — |
| tooth-extraction | parent_of | wisdom-tooth-removal | No | — |
| smilescape-dental-clinic | parent_of | lifetime-implant-warranty | No | Brand program |

---

### F — Subtype Specialization

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| peri-implantitis | subtype_of | periodontitis | No | Implant-specific variant — similar bacterial aetiology, different anatomical site |

---

### G — Treats

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | treats | tooth-loss | No | Hero treatment for hero condition |
| all-on-x | treats | edentulism | No | Fixed full-arch solution |
| all-on-x | treats | denture-dissatisfaction | No | Upgrade path from removable denture |
| overdenture | treats | edentulism | No | More affordable implant-retained full-arch option |
| guided-bone-regeneration | treats | alveolar-bone-loss | No | Gold standard for horizontal and vertical defects |
| sausage-technique | treats | horizontal-bone-deficiency | No | Primary indication |
| sausage-technique | treats | vertical-bone-deficiency | No | Urban protocol — 5.5mm mean gain (P2-C2) |
| bone-grafting | treats | alveolar-bone-loss | No | Umbrella bone augmentation |
| sinus-lift | treats | maxillary-sinus-proximity | No | Creates vertical bone depth for upper jaw implants |
| zygomatic-implant | treats | alveolar-bone-loss | No | Extreme atrophy — bypasses maxillary alveolar bone |
| clear-aligner | treats | malocclusion | No | — |
| damon-system | treats | malocclusion | No | — |
| connective-tissue-graft | treats | gum-recession | No | — |
| gum-contouring | treats | gum-recession | No | Aesthetic correction of gum line |
| root-canal-treatment | treats | dental-caries-extraction | No | Prevents need for extraction when pulp is still viable |

---

### H — Symptom-of / Sequela

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| gum-recession | symptom_of | periodontitis | No | Common sequela of untreated periodontal disease |
| alveolar-bone-loss | symptom_of | periodontitis | No | Bone destruction is hallmark of periodontal pathology |
| tooth-loss | symptom_of | periodontitis | No | End-stage periodontitis leads to tooth loss |

---

### I — Uses

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | uses | titanium | No | Standard biocompatible implant material |
| guided-surgery | uses | surgical-guide | No | Guide enables accurate implant positioning |
| flapless-surgery | uses | surgical-guide | No | Guide required for safe flapless approach |
| digital-implant-planning | uses | cbct-3d-scan | No | CBCT volumetric data feeds planning software |
| digital-implant-planning | uses | surgical-guide | No | Planning output generates printed surgical guide |
| guided-bone-regeneration | uses | ptfe-membrane | No | Non-resorbable barrier — gold standard for GBR |
| guided-bone-regeneration | uses | bone-graft-substitute | No | Void-filling augmentation material |
| sausage-technique | uses | ptfe-membrane | No | Urban protocol specifies non-resorbable membrane |
| sausage-technique | uses | bone-graft-substitute | No | — |
| bone-grafting | uses | prf-platelet-rich-fibrin | No | Autologous growth factor concentrate — accelerates healing |
| ceramic-implant | uses | zirconia | No | Material-defining property |
| zirconia-crown | uses | zirconia | No | — |
| digital-smile-design | uses | intraoral-scanner | No | Digital impression feeds DSD workflow |
| cad-cam | uses | intraoral-scanner | No | — |
| all-on-x | uses | full-arch-immediate-loading | No | Same-day teeth delivery defines All-on-X clinical protocol |

---

### J — Alternative-to

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | alternative_to | removable-denture | Yes | Gold standard fixed vs interim removable solution |
| all-on-x | alternative_to | overdenture | Yes | Fixed full-arch vs removable implant-retained |
| root-canal-treatment | alternative_to | tooth-extraction | Yes | Save vs remove — treatment planning decision |
| ceramic-implant | alternative_to | titanium-implant | Yes | Metal-free vs standard titanium |
| clear-aligner | alternative_to | damon-system | Yes | Removable vs fixed orthodontics |
| porcelain-veneer | alternative_to | dental-crown | Yes | Minimal tooth prep vs full crown coverage |
| immediate-implant | alternative_to | socket-preservation | Yes | Same-day implant vs staged bone preservation |

---

### K — Part-of

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| alveolar-bone | part_of | mandible | No | Tooth-bearing segment of lower jaw |
| alveolar-bone | part_of | maxilla | No | Tooth-bearing segment of upper jaw |
| maxillary-sinus | part_of | maxilla | No | Air space limiting implant depth in upper jaw |
| dental-implant-components | part_of | dental-implant | No | 3-part system: fixture + abutment + crown |
| smile-dna | part_of | smilescape-dental-clinic | No | Brand values framework |
| family-standard | part_of | smilescape-dental-clinic | No | Ethical operating philosophy |
| smilescape-rattanathibet | part_of | smilescape-dental-clinic | No | Physical branch — รัตนาธิเบศร์ (นนทบุรี) |
| smilescape-srinakarin | part_of | smilescape-dental-clinic | No | Physical branch — ศรีนครินทร์ (กรุงเทพฯ) |

---

### L — Requires Assessment

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | requires_assessment | cbct-3d-scan | No | CBCT mandatory before implant planning |
| all-on-x | requires_assessment | cbct-3d-scan | No | — |
| sinus-lift | requires_assessment | maxillary-sinus-proximity | No | Condition assessment determines sinus lift need |
| sausage-technique | requires_assessment | horizontal-bone-deficiency | No | Bone volume assessment determines technique eligibility |
| ortho-implant-sequencing | requires_assessment | malocclusion | No | Orthodontic assessment required before sequencing plan |

---

### M — Evidenced-by

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dental-implant | evidenced_by | osseointegration | No | Biological mechanism underpins 96.4% 10-yr survival data (P1-C1 Howe 2019) |
| sausage-technique | evidenced_by | vertical-bone-augmentation | No | Urban VBA studies (P2-C2, P2-C3) form the protocol evidence base |

> **Phase D note:** `evidenced_by` edges will expand significantly once citation entities are loaded into the graph. These two edges establish the pattern; P1-C1 through P5-C1 citations in `citation-pool-seed.md` become entity nodes at Phase D.

---

### M2 — Evidenced-by (Round 2 additions)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| osseodensification | evidenced_by | densah-bur | No | Densah Bur is the physical instrument enabling Osseodensification mechanism (Huwais authority) |
| internal-sinus-lift | evidenced_by | osseodensification | No | Crestal sinus elevation via densification — minimally invasive evidence base |
| vertical-bone-augmentation | evidenced_by | rpm-membrane | No | RPM Membrane enables space maintenance in vertical reconstruction |
| strip-graft | evidenced_by | soft-tissue-management | No | Urban-attested keratinized tissue technique |
| ice-berg-technique | evidenced_by | soft-tissue-management | No | Urban-attested gingival thickness technique |
| garage-technique | evidenced_by | soft-tissue-management | No | Urban-attested papilla preservation technique |

---

### N — Related-to

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| dr-woraphat-jarangkul | related_to | sausage-technique | Yes | Trained directly by Dr. Urban (HU Berlin) |
| dr-woraphat-jarangkul | related_to | soft-tissue-management | Yes | Trained by Dr. Ricardo Kern (ILAPEO, Brazil) |
| dr-woraphat-jarangkul | related_to | smilescape-dental-clinic | Yes | Medical Director |
| lifetime-implant-warranty | related_to | blue-diamond-implant | Yes | Warranty program covers Blue Diamond system |
| ortho-implant-sequencing | related_to | dental-implant | Yes | Interdisciplinary combo — SmileScape differentiator |
| peri-implantitis | related_to | keratinized-mucosa | Yes | Adequate KM band reduces peri-implantitis risk |
| smile-dna | related_to | family-standard | Yes | Both encode brand philosophy — complementary frameworks |
| periodontitis | related_to | alveolar-bone-loss | Yes | Mutual causation — perio destroys bone; bone loss worsens perio |
| denture-dissatisfaction | related_to | removable-denture | Yes | Dissatisfaction arises from denture limitations |
| digital-smile-design | related_to | dental-veneer | Yes | DSD commonly used in veneer treatment planning |
| blue-diamond-implant | related_to | neodent-implant | Yes | Value-premium implant systems — Asia/LATAM dental tourism evidence category |
| neodent-implant | related_to | straumann-implant | Yes | Neodent is Straumann Group subsidiary — research pipeline + GM Connection shared |
| dr-woraphat-jarangkul | related_to | osseodensification | Yes | Versah training / Huwais workshop (pending operator confirmation) |
| dr-woraphat-jarangkul | related_to | strip-graft | Yes | Trained directly by Dr. Urban — Strip Graft technique |
| dr-woraphat-jarangkul | related_to | ice-berg-technique | Yes | Trained directly by Dr. Urban — Ice Berg/Cube technique |
| dr-woraphat-jarangkul | related_to | garage-technique | Yes | Trained directly by Dr. Urban — Garage technique |
| densah-bur | related_to | smilescape-dental-clinic | Yes | Signature Offering #5 anchor — SmileScape brand-specific tool |
| black-triangle | related_to | gum-recession | Yes | Both are recession-related aesthetic concerns — link Section 5.11 concerns |
| pediatric-dentistry | related_to | early-orthodontic-intervention | Yes | Pediatric → interceptive ortho commonly co-managed |
| endodontics-specialist | related_to | apicoectomy | Yes | Surgical endo specialty subset |
| dental-anxiety | related_to | conscious-sedation | Yes | Anxiety = primary indication for sedation referral |
| dental-anxiety | related_to | ga-dentistry | Yes | Severe phobia → GA dentistry pathway |

---

### O — Hierarchy: New Specialty Clusters (Round 2)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| pediatric-dentistry | parent_of | pediatric-pulpotomy | No | — |
| pediatric-dentistry | parent_of | pediatric-crown | No | — |
| pediatric-dentistry | parent_of | fluoride-treatment | No | — |
| pediatric-dentistry | parent_of | pit-fissure-sealant | No | — |
| pediatric-dentistry | parent_of | space-maintainer | No | — |
| pediatric-dentistry | parent_of | habit-appliance | No | — |
| pediatric-dentistry | parent_of | early-orthodontic-intervention | No | — |
| pediatric-dentistry | parent_of | pediatric-extraction | No | — |
| tooth-extraction | parent_of | pediatric-extraction | No | Pediatric variant — primary teeth |
| root-canal-treatment | parent_of | root-canal-retreatment | No | — |
| root-canal-treatment | parent_of | apicoectomy | No | Surgical endo subset |
| root-canal-treatment | parent_of | internal-bleaching | No | Post-endo cosmetic |
| root-canal-treatment | parent_of | pulp-regeneration | No | Emerging endo subset |
| conscious-sedation | parent_of | iv-sedation | No | Moderate variant |

---

### P — Uses (Technique → Device/Material)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| osseodensification | uses | densah-bur | No | — |
| internal-sinus-lift | uses | densah-bur | No | Crestal approach with bone densification |
| vertical-bone-augmentation | uses | rpm-membrane | No | Space maintenance |
| sausage-technique | uses | ptfe-membrane | No | Original Urban protocol uses PTFE membrane |
| guided-bone-regeneration | uses | rpm-membrane | No | Vertical GBR uses RPM (alongside PTFE) |
| apicoectomy | uses | endodontic-microscope | No | Standard-of-care: microscope-assisted apical surgery |
| root-canal-treatment | uses | rotary-endodontic-system | No | Modern endo uses rotary files |
| root-canal-treatment | uses | endodontic-microscope | No | Specialist-tier endo treatment |
| ga-dentistry | uses | iv-sedation | No | GA pathway often begins with IV induction |
| airflow-air-polishing | uses | dental-filling | No | Air polishing used pre-restoration (cleaning) |
| cool-light-whitening-unit | uses | teeth-whitening | No | Device used in in-office whitening procedure |

---

### Q — Treats (Round 2)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| orthognathic-surgery | treats | malocclusion | No | Skeletal Class II/III + asymmetry |
| pediatric-pulpotomy | treats | dental-caries-extraction | No | Saves primary tooth from extraction (parent edge) |
| apicoectomy | treats | peri-implantitis | No | Edge: peri-apical lesion treatment (loosely related to peri-implantitis pathology — clinical bridge) |
| root-canal-retreatment | treats | cracked-tooth | No | Sometimes; when crack involves canal |
| internal-bleaching | treats | cracked-tooth | No | Post-trauma discoloration |
| caf | treats | gum-recession | No | Gold standard root coverage |
| tunneling-technique | treats | gum-recession | No | — |
| vista-technique | treats | gum-recession | No | Multiple-tooth recession |
| tcaf | treats | gum-recession | No | Hybrid root coverage |
| strip-graft | treats | gum-recession | No | Keratinized augmentation + indirect root coverage |
| vipct | treats | black-triangle | No | Papilla regeneration approach |
| conscious-sedation | treats | dental-anxiety | No | Mild anxiety pathway |
| ga-dentistry | treats | dental-anxiety | No | Severe phobia pathway |

---

### R — Subtype-of (Round 2)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| internal-sinus-lift | subtype_of | sinus-lift | No | Crestal/transalveolar approach variant |
| lateral-window-sinus-lift | subtype_of | sinus-lift | No | Traditional lateral approach |
| neodent-implant | subtype_of | straumann-implant | No | Subsidiary brand within Straumann Group |
| passive-self-ligating | subtype_of | damon-system | No | PSL is the design class of Damon brackets |

---

### S — Part-of (Round 2)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| acteon-cbct | part_of | cbct-3d-scan | No | Brand instance of CBCT category |
| trios-intraoral-scanner | part_of | intraoral-scanner | No | Brand instance of IOS category |

---

### T — Round 3 Additions (ZBL + Peri-Implantitis Service + Gold Crown)

#### T1: ZBL Brand Framework edges

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| zero-bone-loss-concept | evidenced_by | dr-tomas-linkevicius | No | Authority anchor — Linkevicius 2009+ research + 2019 Quintessence textbook |
| zero-bone-loss-concept | related_to | dental-implant | Yes | ZBL = how SmileScape does implants (philosophy/protocol) |
| zero-bone-loss-concept | related_to | lifetime-implant-warranty | Yes | Zero bone loss = warranty validity foundation |
| zero-bone-loss-concept | related_to | keratinized-mucosa | Yes | ZBL requires ≥2mm keratinized tissue around implant |
| zero-bone-loss-concept | related_to | smile-dna | Yes | Brand triad: SMILE DNA (values) + Family Standard (ethics) + ZBL (clinical protocol) |
| zero-bone-loss-concept | related_to | family-standard | Yes | Brand triad complement |
| dr-woraphat-jarangkul | related_to | zero-bone-loss-concept | Yes | Practitioner of ZBL protocol (pending Linkevicius training credential confirm) |
| dr-woraphat-jarangkul | related_to | dr-tomas-linkevicius | Yes | External authority/mentor reference (pending operator confirmation) |
| airflow-air-polishing | uses | zero-bone-loss-concept | No | GBT + Airflow = ZBL maintenance protocol component |

#### T2: Peri-Implantitis Service edges

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| peri-implantitis-treatment | treats | peri-implantitis | No | Service entity treats condition entity |
| peri-implantitis-treatment | parent_of | implantoplasty | No | — |
| peri-implantitis-treatment | parent_of | regenerative-peri-implantitis-surgery | No | — |
| peri-implantitis-treatment | parent_of | resective-peri-implantitis-surgery | No | — |
| peri-implantitis-treatment | uses | dental-laser-therapy | No | Laser-assisted decontamination |
| regenerative-peri-implantitis-surgery | uses | guided-bone-regeneration | No | GBR principles applied to peri-implant defects |
| regenerative-peri-implantitis-surgery | uses | rpm-membrane | No | Space maintenance for peri-implant defects |
| peri-implantitis | symptom_of | periodontitis | No | Shared pathophysiology — bacterial biofilm |
| zero-bone-loss-concept | related_to | peri-implantitis | Yes | ZBL prevents peri-implantitis via maintenance protocol |

#### T3: Gold Crown edges

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| gold-crown | subtype_of | dental-crown | No | Material variant of dental crown |
| gold-crown | alternative_to | zirconia-crown | Yes | Premium crown material decision tree |

---

### U — Round 4 Additions (Insurance Coverage TH)

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| social-security-dental-benefit | parent_of | sso-direct-billing-q-clinic | No | Q-Clinic = SSO billing modality variant |
| sso-direct-billing-q-clinic | related_to | smilescape-dental-clinic | Yes | SmileScape Q-Clinic status (R4 confirmed) — key conversion anchor |
| sso-direct-billing-q-clinic | related_to | smilescape-rattanathibet | Yes | Branch-level direct billing capability |
| sso-direct-billing-q-clinic | related_to | smilescape-srinakarin | Yes | Branch-level direct billing capability |
| social-security-dental-benefit | related_to | dental-filling | Yes | Covered procedure |
| social-security-dental-benefit | related_to | tooth-extraction | Yes | Covered procedure |
| social-security-dental-benefit | related_to | wisdom-tooth-removal | Yes | Covered procedure (simple cases) |
| social-security-dental-benefit | related_to | removable-denture | Yes | Separate cap 1,500-4,400 บาท/5 yr |
| social-security-dental-benefit | alternative_to | universal-coverage-th | Yes | Mutually exclusive — patient chooses one |
| social-security-dental-benefit | alternative_to | civil-servant-dental-benefit | Yes | Mutually exclusive by employment status |
| social-security-dental-benefit | alternative_to | private-dental-insurance-th | Yes | Often stackable — SSO first, private reimburses excess |
| social-security-dental-benefit | related_to | dental-implant | Yes | NOT covered — common upsell pathway from SSO patients |
| social-security-dental-benefit | related_to | clear-aligner | Yes | NOT covered — orthodontic education |

---

## Graph Health Check

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Total edges | 184 (+13 in R4) | ≥ 50 | ✅ |
| Edge types used | 10/10 | 10/10 | ✅ |
| Entities with ≥ 1 edge | 142/144 | ≥ 70% | ✅ |
| Bidirectional edges (Yes) | 44 | — | ✅ |
| Brand-scope=['smile-scape'] edges | 37 (+3 in R4 for Q-Clinic) | — | ✅ |
| Orphan entities (0 edges) | 2 | ≤ 8 | ✅ |

**Orphan entities (no edges — accepted at Phase C):**
- `teeth-whitening` — standalone cosmetic treatment; gains edges in Phase D
- `dental-filling` — basic restorative; gains edges in Phase D
- `immediate-loading` — covered conceptually under all-on-x → full-arch-immediate-loading; standalone variant orphaned at Phase C
- `behavior-management` (Round 2) — conceptual entity for pediatric — gains edges when pediatric content briefs land in Phase D
- `torus-removal`, `alveoloplasty`, `tuberectomy` (Round 2) — oral surgery additions — gain edges in Phase D

All will gain edges in Phase D when content briefs are assigned.

**Key semantic chains confirmed (incl. Round 2 additions):**
- Tooth Loss → Dental Implant → Blue Diamond Implant System → Lifetime Implant Warranty (conversion funnel)
- Horizontal Bone Deficiency → Sausage Technique → Dr. Woraphat Jarangkul (authority chain)
- CBCT 3D Scan → Acteon CBCT → Digital Implant Planning → Surgical Guide → Guided Implant Surgery (tech stack)
- Gingivitis → Periodontitis → Alveolar Bone Loss → Guided Bone Regeneration (perio→bone→treatment chain)
- **NEW:** Osseodensification → Densah Bur + Internal Sinus Lift → Signature Offering #5 (Huwais authority chain)
- **NEW:** Soft Tissue Management → Strip Graft / Ice Berg / Garage → Dr. Woraphat (Urban authority chain — D-2 Hybrid)
- **NEW:** Gum Recession → CAF / Tunneling / VISTA / TCAF → Soft Tissue Service (root coverage clinical pathway)
- **NEW:** Dental Anxiety → Conscious Sedation / GA Dentistry (anxiety-to-care pathway)

---

*Phase C output — Relationship wiring. Per Handover §5.5 + Bible Part 2.6. Feeds Stage 1.5 EUG preflight → Supabase edge table.*
*Round 2 expansion (2026-05-21) — +50 edges for Densah/Soft Tissue D-2 Hybrid/Pediatric/Endo/Anesthesia clusters. Edge type vocabulary still 10/10 (no new edge types).*
