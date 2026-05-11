# SmileScape Dental Clinic — Topic Clusters (Planning File)

> **Phase:** Stage 1 → Phase C (Entity Genesis)
> **Schema:** §5.4 — 6 columns
> **Date:** 2026-05-11
> **Cluster count:** 15 | **Domain count:** 7

---

## Domain Index

| Domain ID | Domain Name | Primary Service | Cluster Count |
|-----------|-------------|----------------|---------------|
| A | Dental Implant | Hero Service | 4 |
| B | Bone Regeneration | Signature Technique | 2 |
| C | Full-Arch Rehabilitation | Signature Treatment | 1 |
| D | Aesthetic & Cosmetic Dentistry | Supporting | 1 |
| E | Orthodontics | Supporting | 1 |
| F | Periodontics & Gum | Supporting + Perio-Implant | 2 |
| G | Cross-Cutting (Anatomy, Tech, Materials, Authority) | Infrastructure | 4 |

---

## Cluster Master Table

| Cluster ID | Cluster Name | Domain | Parent Cluster (text) | Pillar Page | Brand Scope |
|------------|--------------|--------|----------------------|-------------|-------------|
| dental-implant-core | Dental Implant — Core Procedure | A: Dental Implant | — | 3.2 | ['*'] |
| implant-systems-brands | Implant Systems & Brands | A: Dental Implant | dental-implant-core | 4.5 | ['*'] |
| all-on-x-full-arch | All-on-X Full-Arch Rehabilitation | C: Full-Arch Rehabilitation | dental-implant-core | 3.3 | ['*'] |
| patient-conditions-tooth-loss | Patient Conditions — Tooth Loss | A: Dental Implant | — | 5.1 | ['*'] |
| bone-regeneration-gbr | Bone Regeneration & GBR | B: Bone Regeneration | — | 3.2.9 | ['*'] |
| patient-conditions-bone | Patient Conditions — Bone Deficiency | B: Bone Regeneration | patient-conditions-tooth-loss | 5.2 | ['*'] |
| smile-design-cosmetic | Smile Design & Cosmetic Dentistry | D: Aesthetic & Cosmetic | — | 3.4 | ['*'] |
| gum-soft-tissue | Gum & Soft Tissue Management | F: Periodontics & Gum | — | 3.2.9.7 | ['*'] |
| periodontics-perio-disease | Periodontics & Gum Disease | F: Periodontics & Gum | gum-soft-tissue | 3.7 | ['*'] |
| clear-aligner-orthodontics | Clear Aligner & Orthodontics | E: Orthodontics | — | 3.5 | ['*'] |
| general-restorative | General Restorative Dentistry | A: Dental Implant | — | 3.6 | ['*'] |
| digital-technology-diagnostics | Digital Technology & Diagnostics | G: Cross-Cutting | — | 3.1 | ['*'] |
| implant-materials | Implant Materials & Biomaterials | G: Cross-Cutting | — | 4.5 | ['*'] |
| dental-anatomy | Dental Anatomy & Physiology | G: Cross-Cutting | — | — | ['*'] |
| brand-doctor-authority | Brand, Doctor & Authority Entities | G: Cross-Cutting | — | 2.1 | ['smile-scape'] |

---

## Pillar-Supporting Ratio Check

> Target per Phase D: pillar-to-supporting ratio 8-25 per cluster

| Cluster | Pillar Entities | Supporting Entities | Ratio OK? |
|---------|----------------|---------------------|-----------|
| dental-implant-core | 3 | 6 | ✅ |
| implant-systems-brands | 4 | 4 | ✅ |
| all-on-x-full-arch | 4 | 4 | ✅ |
| patient-conditions-tooth-loss | 4 | 2 | ✅ |
| bone-regeneration-gbr | 4 | 4 | ✅ |
| patient-conditions-bone | 3 | 2 | ✅ |
| smile-design-cosmetic | 3 | 4 | ✅ |
| gum-soft-tissue | 3 | 3 | ✅ |
| periodontics-perio-disease | 4 | 2 | ✅ |
| clear-aligner-orthodontics | 3 | 3 | ✅ |
| general-restorative | 3 | 3 | ✅ |
| digital-technology-diagnostics | 3 | 4 | ✅ |
| implant-materials | 3 | 3 | ✅ |
| dental-anatomy | 3 | 2 | ✅ |
| brand-doctor-authority | 5 | 0 | ✅ |

---

## Cross-Brand Federation Note

Clusters with `brand_scope=['*']` are **universal** — entities may be reused across other EYWA dental brands (if any enter portfolio). Cluster `brand-doctor-authority` is `brand_scope=['smile-scape']` — SmileScape-specific persons, concepts, and programs.

---

*Phase C output — feeds `entities.md` and `relationships.md`. Per Handover §5.4 + Bible Part 2.6.*
