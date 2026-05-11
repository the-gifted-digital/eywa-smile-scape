# SmileScape Dental Clinic — Entity Relationships (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis)
> **Schema:** §5.5 — 5 columns per edge
> **Date:** 2026-05-11
> **Edge count:** 99 | **Edge types used:** 10/10
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
| dental-implant | parent_of | osstem-implant | No | — |
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
| blue-diamond-implant | related_to | osstem-implant | Yes | Korean implant systems sharing regional evidence category |

---

## Graph Health Check

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Total edges | 99 | ≥ 50 | ✅ |
| Edge types used | 10/10 | 10/10 | ✅ |
| Entities with ≥ 1 edge | 78/81 | ≥ 70% | ✅ |
| Bidirectional edges (Yes) | 18 | — | ✅ |
| Brand-scope=['smile-scape'] edges | 13 | — | ✅ |
| Orphan entities (0 edges) | 3 | ≤ 5 | ✅ |

**Orphan entities (no edges — accepted):**
- `teeth-whitening` — standalone cosmetic treatment; no cross-entity dependency at Phase C
- `dental-filling` — basic restorative; no cross-entity dependency at Phase C
- `immediate-loading` — covered conceptually under all-on-x → full-arch-immediate-loading; standalone variant orphaned at Phase C

All three will gain edges in Phase D when content briefs are assigned.

**Key semantic chains confirmed:**
- Tooth Loss → Dental Implant → Blue Diamond Implant System → Lifetime Implant Warranty (conversion funnel)
- Horizontal Bone Deficiency → Sausage Technique → Dr. Woraphat Jarangkul (authority chain)
- CBCT 3D Scan → Digital Implant Planning → Surgical Guide → Guided Implant Surgery (tech stack)
- Gingivitis → Periodontitis → Alveolar Bone Loss → Guided Bone Regeneration (perio→bone→treatment chain)

---

*Phase C output — Relationship wiring. Per Handover §5.5 + Bible Part 2.6. Feeds Stage 1.5 EUG preflight → Supabase edge table.*
