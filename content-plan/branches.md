# SmileScape Dental Clinic — Branches Planning File

> **Phase:** Stage 1 → Phase C (Local SEO)
> **Schema:** Schema_Overview §3.2 — `seo_branches` table
> **Date:** 2026-05-11
> **Branch count:** 2 | **Brand scope:** ['smile-scape']
> **Bible reference:** Part 4.4 (Type B Branch Landing), Part 10.5 (Local SEO), Part 14.6 (Hospital format)

---

## Branch Master Table

> Schema per `seo_branches` (§3.2). Fields marked TBD pending operator data collection (Google Business Profile registration, address verification, GPS pinning).

| # | Branch Slug | Branch Name | Type | City | Address | Postal | Lat | Lng | Phone | Email | GBP Place ID | Transit | Sitemap Node | Brand Scope |
|---|-------------|-------------|------|------|---------|--------|-----|-----|-------|-------|--------------|---------|--------------|-------------|
| 1 | smilescape-rattanathibet | SmileScape สาขารัตนาธิเบศร์ | primary | นนทบุรี | TBD | TBD | TBD | TBD | TBD | TBD | TBD | MRT สีม่วง สถานีรัตนาธิเบศร์ | 8.2 | ['smile-scape'] |
| 2 | smilescape-srinakarin | SmileScape สาขาศรีนครินทร์ | primary | กรุงเทพฯ | TBD | TBD | TBD | TBD | TBD | TBD | TBD | MRT สีเหลือง (สวนหลวง ร.9) | 8.3 | ['smile-scape'] |

---

## Multilingual Branch Names (`canonical_names` jsonb)

### smilescape-rattanathibet

```json
{
  "th": "SmileScape สาขารัตนาธิเบศร์",
  "en": "SmileScape Rattanathibet Branch"
}
```

**Aliases:**
- สาขานนทบุรี
- SmileScape นนทบุรี
- คลินิกรากฟันเทียมนนทบุรี
- SmileScape MRT Purple Line

### smilescape-srinakarin

```json
{
  "th": "SmileScape สาขาศรีนครินทร์",
  "en": "SmileScape Srinakarin Branch"
}
```

**Aliases:**
- สาขาศรีนครินทร์
- SmileScape Bangkok
- SmileScape สวนหลวง ร.9
- คลินิกรากฟันเทียมศรีนครินทร์
- SmileScape MRT Yellow Line

---

## Opening Hours (`opening_hours` jsonb — OpeningHoursSpecification format)

> Same hours assumed for both branches pending operator confirmation. Update per-branch if hours differ.

```json
{
  "@type": "OpeningHoursSpecification",
  "dayOfWeek": ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
  "opens": "TBD",
  "closes": "TBD",
  "_note": "Operator to confirm. Dental clinic norm in Thailand: 09:00-20:00, possibly closed one weekday."
}
```

---

## Services at Branch (`services_at_branch` text[])

> Cross-reference to entity slugs in `entities.md`. All services assumed available at both branches unless flagged. Validate at operator review.

### Universal services (both branches)

- dental-implant
- single-tooth-implant
- multiple-implants
- all-on-x / all-on-4 / all-on-6
- guided-bone-regeneration
- bone-grafting
- sinus-lift
- sausage-technique
- soft-tissue-management
- clear-aligner / trioclear-aligner
- damon-system
- digital-smile-design
- dental-veneer / porcelain-veneer
- zirconia-crown
- root-canal-treatment
- tooth-extraction
- wisdom-tooth-removal
- dental-filling
- periodontitis (treatment)
- peri-implantitis (treatment)

### Branch-specific (TBD)

- Per-branch differentiation pending operator input (e.g., if certain advanced procedures only at one branch)

---

## Schema:LocalBusiness Markup Templates

### Template A — รัตนาธิเบศร์ branch

```jsonld
{
  "@context": "https://schema.org",
  "@type": ["Dentist", "MedicalBusiness", "LocalBusiness"],
  "@id": "https://smilescape.dental/รัตนาธิเบศร์#location",
  "name": "SmileScape สาขารัตนาธิเบศร์",
  "alternateName": ["SmileScape Rattanathibet", "SmileScape นนทบุรี"],
  "parentOrganization": {
    "@id": "https://smilescape.dental/#organization"
  },
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "TBD",
    "addressLocality": "นนทบุรี",
    "addressRegion": "นนทบุรี",
    "postalCode": "TBD",
    "addressCountry": "TH"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "TBD",
    "longitude": "TBD"
  },
  "telephone": "TBD",
  "publicAccess": true,
  "isAccessibleForFree": true,
  "priceRange": "฿฿",
  "medicalSpecialty": ["Dentistry", "Implantology", "Periodontics", "Orthodontics"],
  "availableService": ["dental-implant", "all-on-x", "guided-bone-regeneration", "..."],
  "openingHoursSpecification": { "$ref": "TBD" },
  "publicTransportAccess": "MRT Purple Line — Rattanathibet Station"
}
```

### Template B — ศรีนครินทร์ branch

```jsonld
{
  "@context": "https://schema.org",
  "@type": ["Dentist", "MedicalBusiness", "LocalBusiness"],
  "@id": "https://smilescape.dental/ศรีนครินทร์#location",
  "name": "SmileScape สาขาศรีนครินทร์",
  "alternateName": ["SmileScape Srinakarin", "SmileScape สวนหลวง ร.9"],
  "parentOrganization": {
    "@id": "https://smilescape.dental/#organization"
  },
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "TBD",
    "addressLocality": "กรุงเทพมหานคร",
    "addressRegion": "กรุงเทพมหานคร",
    "postalCode": "TBD",
    "addressCountry": "TH"
  },
  "geo": {
    "@type": "GeoCoordinates",
    "latitude": "TBD",
    "longitude": "TBD"
  },
  "telephone": "TBD",
  "publicAccess": true,
  "isAccessibleForFree": true,
  "priceRange": "฿฿",
  "medicalSpecialty": ["Dentistry", "Implantology", "Periodontics", "Orthodontics"],
  "publicTransportAccess": "MRT Yellow Line"
}
```

---

## Geo-Keyword Seed (Local SEO)

> Geo modifiers used in sitemap section 8.2 + 8.3 + future T18 programmatic local pages. Volume enrichment pending DataForSEO at Stage 1.5.

### รัตนาธิเบศร์ branch — geo terms

| Geo Term | Search Intent | Used In |
|----------|---------------|---------|
| รากฟันเทียมนนทบุรี | Commercial — direct treatment lookup | 8.2.2 + T18 candidates |
| ทำฟันนนทบุรี | Navigational/Commercial — broad clinic lookup | 8.2.3 |
| จัดฟันนนทบุรี | Commercial — ortho lookup | 8.2.4 |
| คลินิกทำฟันใกล้ MRT สีม่วง | Navigational — transit-based | 8.2.5 |
| คลินิกทันตกรรมรัตนาธิเบศร์ | Navigational | T18 candidates |
| ทันตแพทย์รัตนาธิเบศร์ | Navigational | T18 candidates |

### ศรีนครินทร์ branch — geo terms

| Geo Term | Search Intent | Used In |
|----------|---------------|---------|
| รากฟันเทียมศรีนครินทร์ | Commercial — direct treatment lookup | 8.3.2 + T18 candidates |
| ทำฟันศรีนครินทร์ | Navigational/Commercial | 8.3.3 |
| จัดฟันศรีนครินทร์ | Commercial — ortho lookup | 8.3.4 |
| คลินิกทำฟันใกล้ MRT สีเหลือง | Navigational — transit-based | 8.3.5 |
| คลินิกทันตกรรมศรีนครินทร์ | Navigational | T18 candidates |
| รากฟันเทียมสวนหลวง ร.9 | Commercial — hyper-local | T18 candidates |

---

## T18 Programmatic Local Seeding (Future Phase)

> Per Bible Part 4.4 + DR-022 Layer 2 (Volume-Driven). Matrix expansion pending DataForSEO volume validation at Stage 1.5.

**Proposed matrix:** Hero services × Branches

| Hero Service Slug | × รัตนาธิเบศร์ | × ศรีนครินทร์ |
|-------------------|----------------|---------------|
| dental-implant | รากฟันเทียมรัตนาธิเบศร์ | รากฟันเทียมศรีนครินทร์ |
| all-on-x | All-on-X รัตนาธิเบศร์ | All-on-X ศรีนครินทร์ |
| sausage-technique | Sausage Technique รัตนาธิเบศร์ | Sausage Technique ศรีนครินทร์ |
| clear-aligner | จัดฟันใสรัตนาธิเบศร์ | จัดฟันใสศรีนครินทร์ |
| guided-bone-regeneration | GBR เสริมกระดูกรัตนาธิเบศร์ | GBR เสริมกระดูกศรีนครินทร์ |

**Activation criteria (per DR-022 Layer 2):**
- Min volume: 50 searches/month per query
- KD: ≤ 40 (preference)
- CPC: existing commercial signal
- Uniqueness: each page must have ≥ 60% unique content (not boilerplate clone)

**Status:** Not yet added to sitemap. Wait for keyword volume data → operator decision on which services to activate per branch.

---

## EUG Pre-flight Notes (Stage 1.5)

Validation checks before flat-load to Supabase:

- [ ] `branch_slug` uniqueness across federation — confirm `smilescape-rattanathibet` and `smilescape-srinakarin` not reused by other EYWA brands
- [ ] `parent_notion_id` will be backfilled at Phase 2 (Two-Phase Sync) — Notion ID of `smilescape-dental-clinic` parent
- [ ] GPS coordinates (lat/lng) must be valid before `geo_point` PostGIS computation
- [ ] `gbp_place_id` requires Google Business Profile activation (operator action)
- [ ] `services_at_branch[]` cross-reference: validate all listed slugs exist in `entities.md`
- [ ] Opening hours format must match OpeningHoursSpecification schema (validated by Jsonb CHECK constraint)
- [ ] Entity row in `entities.md` for each branch (`smilescape-rattanathibet`, `smilescape-srinakarin`) must have `Type=Organization`, `Schema.org=Dentist`

---

## Operator Action Items

Before Stage 1.5 DB load — operator must collect:

**Per branch:**
- [ ] Full street address
- [ ] Postal code
- [ ] GPS latitude/longitude (Google Maps pin)
- [ ] Primary phone number
- [ ] Branch email (if differs from main)
- [ ] Google Business Profile registration → obtain `gbp_place_id`
- [ ] Opening hours (per day of week)
- [ ] Branch photos for GBP + schema:image

**Cross-branch:**
- [ ] Confirm service availability (any services only at one branch?)
- [ ] Confirm parking/accessibility details
- [ ] Confirm payment methods accepted

---

## Cross-References

- Branch entity rows: `entities.md` — cluster `brand-doctor-authority`, rows #6 (รัตนาธิเบศร์), #7 (ศรีนครินทร์)
- Branch relationships: `relationships.md` — section K (part_of), `smilescape-{branch} → part_of → smilescape-dental-clinic`
- Branch landing pages: `sitemap.md` — sections 8.1 (Contact Hub), 8.2 (รัตนาธิเบศร์), 8.3 (ศรีนครินทร์)
- Brand config branches array: `brand-config.json:132-143`

---

*Phase C local SEO planning. Per Schema_Overview §3.2 + Bible Part 10.5. Feeds Stage 1.5 → `seo_brand_branches` table.*
