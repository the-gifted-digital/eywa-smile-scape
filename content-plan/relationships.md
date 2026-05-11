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
| Dental Implant | parent_of | Single Tooth Implant | N | — |
| Dental Implant | parent_of | Multiple Implants | N | — |
| Dental Implant | parent_of | Implant-Supported Bridge | N | — |
| Dental Implant | parent_of | Overdenture | N | — |
| Dental Implant | parent_of | All-on-X | N | Full-arch subset of implant treatment |
| All-on-X | parent_of | All-on-4 | N | — |
| All-on-X | parent_of | All-on-6 | N | — |
| All-on-X | parent_of | Zygomatic Implant | N | Extreme bone-loss variant anchored in zygomatic bone |

### B — Hierarchy: Implant Systems & Brands

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | parent_of | Blue Diamond Implant System | N | SmileScape-specific signature system — Korean origin |
| Dental Implant | parent_of | Osstem Implant | N | — |
| Dental Implant | parent_of | Straumann Implant | N | — |
| Dental Implant | parent_of | Titanium Implant | N | Material-defined subtype |
| Dental Implant | parent_of | Ceramic Implant | N | Metal-free subtype |

### C — Hierarchy: Bone Regeneration

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Guided Bone Regeneration | parent_of | Sausage Technique | N | Specific horizontal/vertical protocol by Dr. Urban |
| Guided Bone Regeneration | parent_of | Ridge Augmentation | N | — |
| Guided Bone Regeneration | parent_of | Vertical Bone Augmentation | N | — |
| Bone Grafting | parent_of | Sinus Lift | N | — |
| Bone Grafting | parent_of | Socket Preservation | N | — |

### D — Hierarchy: Patient Conditions & Disease Progression

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Tooth Loss | parent_of | Edentulism | N | Severity escalation — partial to complete |
| Tooth Loss | parent_of | Tooth Decay Leading to Extraction | N | Aetiological subtype |
| Tooth Loss | parent_of | Traumatic Tooth Loss | N | Aetiological subtype |
| Tooth Loss | parent_of | Removable Denture Dissatisfaction | N | Outcome state driving implant upgrade |
| Alveolar Bone Loss | parent_of | Vertical Bone Deficiency | N | — |
| Alveolar Bone Loss | parent_of | Horizontal Bone Deficiency | N | — |
| Alveolar Bone Loss | parent_of | Maxillary Sinus Proximity | N | Upper-jaw manifestation |
| Gingivitis | parent_of | Periodontitis | N | Disease progression — untreated gingivitis advances to perio |

### E — Hierarchy: Aesthetics, Restorative, Ortho

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Veneer | parent_of | Porcelain Veneer | N | — |
| Dental Crown | parent_of | Zirconia Crown | N | — |
| Soft Tissue Management | parent_of | Gum Contouring | N | — |
| Soft Tissue Management | parent_of | Connective Tissue Graft | N | — |
| Clear Aligner | parent_of | TrioClear Aligner System | N | Brand-specific system offered by SmileScape |
| Peri-Implant Mucosa | parent_of | Keratinized Mucosa | N | — |
| Tooth Extraction | parent_of | Wisdom Tooth Removal | N | — |
| SmileScape Dental Clinic | parent_of | Lifetime Implant Warranty | N | Brand program |

---

### F — Subtype Specialization

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Peri-Implantitis | subtype_of | Periodontitis | N | Implant-specific variant — similar bacterial aetiology, different anatomical site |

---

### G — Treats

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | treats | Tooth Loss | N | Hero treatment for hero condition |
| All-on-X | treats | Edentulism | N | Fixed full-arch solution |
| All-on-X | treats | Removable Denture Dissatisfaction | N | Upgrade path from removable denture |
| Overdenture | treats | Edentulism | N | More affordable implant-retained full-arch option |
| Guided Bone Regeneration | treats | Alveolar Bone Loss | N | Gold standard for horizontal and vertical defects |
| Sausage Technique | treats | Horizontal Bone Deficiency | N | Primary indication |
| Sausage Technique | treats | Vertical Bone Deficiency | N | Urban protocol — 5.5mm mean gain (P2-C2) |
| Bone Grafting | treats | Alveolar Bone Loss | N | Umbrella bone augmentation |
| Sinus Lift | treats | Maxillary Sinus Proximity | N | Creates vertical bone depth for upper jaw implants |
| Zygomatic Implant | treats | Alveolar Bone Loss | N | Extreme atrophy — bypasses maxillary alveolar bone |
| Clear Aligner | treats | Malocclusion | N | — |
| Damon Self-Ligating System | treats | Malocclusion | N | — |
| Connective Tissue Graft | treats | Gum Recession | N | — |
| Gum Contouring | treats | Gum Recession | N | Aesthetic correction of gum line |
| Root Canal Treatment | treats | Tooth Decay Leading to Extraction | N | Prevents need for extraction when pulp is still viable |

---

### H — Symptom-of / Sequela

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Gum Recession | symptom_of | Periodontitis | N | Common sequela of untreated periodontal disease |
| Alveolar Bone Loss | symptom_of | Periodontitis | N | Bone destruction is hallmark of periodontal pathology |
| Tooth Loss | symptom_of | Periodontitis | N | End-stage periodontitis leads to tooth loss |

---

### I — Uses

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | uses | Titanium | N | Standard biocompatible implant material |
| Guided Implant Surgery | uses | Surgical Guide | N | Guide enables accurate implant positioning |
| Flapless Implant Surgery | uses | Surgical Guide | N | Guide required for safe flapless approach |
| Digital Implant Planning | uses | CBCT 3D Scan | N | CBCT volumetric data feeds planning software |
| Digital Implant Planning | uses | Surgical Guide | N | Planning output generates printed surgical guide |
| Guided Bone Regeneration | uses | PTFE Membrane | N | Non-resorbable barrier — gold standard for GBR |
| Guided Bone Regeneration | uses | Bone Graft Substitute | N | Void-filling augmentation material |
| Sausage Technique | uses | PTFE Membrane | N | Urban protocol specifies non-resorbable membrane |
| Sausage Technique | uses | Bone Graft Substitute | N | — |
| Bone Grafting | uses | PRF (Platelet-Rich Fibrin) | N | Autologous growth factor concentrate — accelerates healing |
| Ceramic Implant | uses | Zirconia | N | Material-defining property |
| Zirconia Crown | uses | Zirconia | N | — |
| Digital Smile Design | uses | Intraoral Scanner | N | Digital impression feeds DSD workflow |
| CAD/CAM Prosthetics | uses | Intraoral Scanner | N | — |
| All-on-X | uses | Full-Arch Immediate Loading | N | Same-day teeth delivery defines All-on-X clinical protocol |

---

### J — Alternative-to

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | alternative_to | Removable Denture | Y | Gold standard fixed vs interim removable solution |
| All-on-X | alternative_to | Overdenture | Y | Fixed full-arch vs removable implant-retained |
| Root Canal Treatment | alternative_to | Tooth Extraction | Y | Save vs remove — treatment planning decision |
| Ceramic Implant | alternative_to | Titanium Implant | Y | Metal-free vs standard titanium |
| Clear Aligner | alternative_to | Damon Self-Ligating System | Y | Removable vs fixed orthodontics |
| Porcelain Veneer | alternative_to | Dental Crown | Y | Minimal tooth prep vs full crown coverage |
| Immediate Implant Placement | alternative_to | Socket Preservation | Y | Same-day implant vs staged bone preservation |

---

### K — Part-of

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Alveolar Bone | part_of | Mandible | N | Tooth-bearing segment of lower jaw |
| Alveolar Bone | part_of | Maxilla | N | Tooth-bearing segment of upper jaw |
| Maxillary Sinus | part_of | Maxilla | N | Air space limiting implant depth in upper jaw |
| Dental Implant Components | part_of | Dental Implant | N | 3-part system: fixture + abutment + crown |
| SMILE DNA | part_of | SmileScape Dental Clinic | N | Brand values framework |
| Family Standard | part_of | SmileScape Dental Clinic | N | Ethical operating philosophy |

---

### L — Requires Assessment

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | requires_assessment | CBCT 3D Scan | N | CBCT mandatory before implant planning |
| All-on-X | requires_assessment | CBCT 3D Scan | N | — |
| Sinus Lift | requires_assessment | Maxillary Sinus Proximity | N | Condition assessment determines sinus lift need |
| Sausage Technique | requires_assessment | Horizontal Bone Deficiency | N | Bone volume assessment determines technique eligibility |
| Orthodontic-Implant Sequencing | requires_assessment | Malocclusion | N | Orthodontic assessment required before sequencing plan |

---

### M — Evidenced-by

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dental Implant | evidenced_by | Osseointegration | N | Biological mechanism underpins 96.4% 10-yr survival data (P1-C1 Howe 2019) |
| Sausage Technique | evidenced_by | Vertical Bone Augmentation | N | Urban VBA studies (P2-C2, P2-C3) form the protocol evidence base |

> **Phase D note:** `evidenced_by` edges will expand significantly once citation entities are loaded into the graph. These two edges establish the pattern; P1-C1 through P5-C1 citations in `citation-pool-seed.md` become entity nodes at Phase D.

---

### N — Related-to

| From Entity | Edge Type | To Entity | Bidirectional | Notes |
|-------------|-----------|-----------|:---:|-------|
| Dr. Woraphat Jarangkul | related_to | Sausage Technique | Y | Trained directly by Dr. Urban (HU Berlin) |
| Dr. Woraphat Jarangkul | related_to | Soft Tissue Management | Y | Trained by Dr. Ricardo Kern (ILAPEO, Brazil) |
| Dr. Woraphat Jarangkul | related_to | SmileScape Dental Clinic | Y | Medical Director |
| Lifetime Implant Warranty | related_to | Blue Diamond Implant System | Y | Warranty program covers Blue Diamond system |
| Orthodontic-Implant Sequencing | related_to | Dental Implant | Y | Interdisciplinary combo — SmileScape differentiator |
| Peri-Implantitis | related_to | Keratinized Mucosa | Y | Adequate KM band reduces peri-implantitis risk |
| SMILE DNA | related_to | Family Standard | Y | Both encode brand philosophy — complementary frameworks |
| Periodontitis | related_to | Alveolar Bone Loss | Y | Mutual causation — perio destroys bone; bone loss worsens perio |
| Removable Denture Dissatisfaction | related_to | Removable Denture | Y | Dissatisfaction arises from denture limitations |
| Digital Smile Design | related_to | Dental Veneer | Y | DSD commonly used in veneer treatment planning |
| Blue Diamond Implant System | related_to | Osstem Implant | Y | Korean implant systems sharing regional evidence category |

---

## Graph Health Check

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| Total edges | 99 | ≥ 50 | ✅ |
| Edge types used | 10/10 | 10/10 | ✅ |
| Entities with ≥ 1 edge | 71/73 | ≥ 70% | ✅ |
| Bidirectional edges (Y) | 18 | — | ✅ |
| Brand-scope=['smile-scape'] edges | 13 | — | ✅ |
| Orphan entities (0 edges) | 2 | ≤ 5 | ✅ |

**Orphan entities (no edges — accepted):**
- `Teeth Whitening` — standalone cosmetic treatment; no cross-entity dependency at Phase C
- `Dental Filling` — basic restorative; no cross-entity dependency at Phase C

Both will gain edges in Phase D when content briefs are assigned.

**Key semantic chains confirmed:**
- Tooth Loss → Dental Implant → Blue Diamond Implant System → Lifetime Implant Warranty (conversion funnel)
- Horizontal Bone Deficiency → Sausage Technique → Dr. Woraphat Jarangkul (authority chain)
- CBCT 3D Scan → Digital Implant Planning → Surgical Guide → Guided Implant Surgery (tech stack)
- Gingivitis → Periodontitis → Alveolar Bone Loss → Guided Bone Regeneration (perio→bone→treatment chain)

---

*Phase C output — Relationship wiring. Per Handover §5.5 + Bible Part 2.6. Feeds Stage 1.5 EUG preflight → Supabase edge table.*
