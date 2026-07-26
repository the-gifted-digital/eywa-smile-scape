# SmileScape Dental Clinic — Branches Planning File

> **Phase:** Stage 1 → Phase C (Local SEO)
> **Schema:** Schema_Overview v1.11 §3.2 — `seo_branches` table (~40 columns, enhanced per DR-025)
> **Date:** 2026-05-12
> **Branch count:** 2 | **Brand scope:** ['smile-scape']
> **Bible reference:** Part 4.4 (Type B Branch Landing), Part 10.5 (Local SEO), Part 14.6 (Hospital format), Part 17.6 GROUP E (n8n Flows E1-E4)
> **DR reference:** DR-025 Locked 2026-05-12

---

## Branch Master Table (Core Identity)

| # | Branch Slug | Branch Name | is_primary | Status | Brand Scope |
|---|-------------|-------------|------------|--------|-------------|
| 1 | smilescape-rattanathibet | SmileScape สาขารัตนาธิเบศร์ | true | active | ['smile-scape'] |
| 2 | smilescape-srinakarin | SmileScape สาขาศรีนครินทร์ | false | active | ['smile-scape'] |

> `organization_entity_id` FK → `seo_entity_graph.id` populated at Stage 1.5 from `entities.md`:
> - smilescape-rattanathibet → links to `smilescape-rattanathibet` Organization entity (#6 in brand-doctor-authority cluster)
> - smilescape-srinakarin → links to `smilescape-srinakarin` Organization entity (#7)

---

## NAP (Name / Address / Phone) — Canonical Source

> Bible Part 10.5 NAP canonical rule: this table is the single source of truth. All directory listings (`seo_directory_listings`) audit against these values.

### smilescape-rattanathibet

| Field | Value | Status |
|-------|-------|--------|
| `business_name_legal` | TBD (จะใส่ชื่อจดทะเบียน DBD) | Operator action |
| `business_name_brand` | SmileScape สาขารัตนาธิเบศร์ | ✅ Set |
| `street_address` | TBD | Operator action |
| `address` (free-form) | TBD | Operator action |
| `district` (แขวง/ตำบล) | TBD | Operator action |
| `city` (จังหวัด/อำเภอ) | นนทบุรี | ✅ Set |
| `region` (ภาค) | นนทบุรี | ✅ Set |
| `country_code` | TH | ✅ Set |
| `postal_code` | TBD | Operator action |
| `formatted_address` | TBD (auto-computed from Google geocoding) | Stage 1.5 |
| `phone` | TBD (E.164 format: +66...) | Operator action |
| `email` | TBD | Operator action |
| `line_id` | TBD (LINE OA ID) | Operator action |
| `website_url` | https://smilescapeclinic.com/รัตนาธิเบศร์ | ✅ Set |

### smilescape-srinakarin

| Field | Value | Status |
|-------|-------|--------|
| `business_name_legal` | TBD (จะใส่ชื่อจดทะเบียน DBD) | Operator action |
| `business_name_brand` | SmileScape สาขาศรีนครินทร์ | ✅ Set |
| `street_address` | TBD | Operator action |
| `address` (free-form) | TBD | Operator action |
| `district` (แขวง/ตำบล) | TBD (อาจเป็นสวนหลวง ร.9 area) | Operator action |
| `city` | กรุงเทพมหานคร | ✅ Set |
| `region` | กรุงเทพมหานคร | ✅ Set |
| `country_code` | TH | ✅ Set |
| `postal_code` | TBD | Operator action |
| `formatted_address` | TBD | Stage 1.5 |
| `phone` | TBD | Operator action |
| `email` | TBD | Operator action |
| `line_id` | TBD | Operator action |
| `website_url` | https://smilescapeclinic.com/ศรีนครินทร์ | ✅ Set |

---

## Geo Coordinates

| Branch | Latitude | Longitude | Plus Code | Transit |
|--------|----------|-----------|-----------|---------|
| smilescape-rattanathibet | TBD | TBD | TBD | MRT สีม่วง สถานีรัตนาธิเบศร์ |
| smilescape-srinakarin | TBD | TBD | TBD | MRT สีเหลือง (สวนหลวง ร.9) |

> `geo_point` = PostGIS computed from lat/lng. `plus_code` from Google geocoding API.

---

## Opening Hours

### `opening_hours` jsonb (OpeningHoursSpecification format)

```json
{
  "@type": "OpeningHoursSpecification",
  "dayOfWeek": ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"],
  "opens": "TBD",
  "closes": "TBD",
  "_note": "Operator confirmation pending. TH dental clinic norm 09:00-20:00; many close 1 weekday."
}
```

### `special_hours` jsonb (Schema.org specialOpeningHoursSpecification)

Format: array of date-specific exceptions (closed days, holidays, extended hours)

```json
[
  {
    "@type": "OpeningHoursSpecification",
    "validFrom": "TBD",
    "validThrough": "TBD",
    "opens": "TBD",
    "closes": "TBD",
    "_note": "e.g., Songkran closure, NYE special hours"
  }
]
```

> Operator to define annual holiday calendar at Stage 1.5.

---

## Services / Staff / Equipment at Branch

### `services_offered_fps[]` (FK → `seo_entity_graph.fingerprint`)

Both branches offer the universal SmileScape service catalog. Slugs reference `entities.md`:

**Implant & Bone:**
- dental-implant / single-tooth-implant / multiple-implant / implant-supported-bridge / overdenture
- all-on-x / all-on-4 / all-on-6 / zygomatic-implant / full-arch-immediate-loading
- guided-bone-regeneration / sausage-technique / bone-grafting / sinus-lift / ridge-augmentation / socket-preservation / vertical-bone-augmentation
- soft-tissue-management / connective-tissue-graft

**General + Cosmetic + Ortho + Perio:**
- dental-veneer / porcelain-veneer / dental-crown / zirconia-crown / teeth-whitening / digital-smile-design / gum-contouring
- clear-aligner / trioclear-aligner / damon-system
- root-canal-treatment / tooth-extraction / wisdom-tooth-removal / dental-filling / removable-denture
- periodontitis (treatment) / peri-implantitis (treatment) / gum-recession (treatment)

**Surgical Procedures:**
- immediate-implant / immediate-loading / flapless-surgery / guided-surgery

### `specialties_at_branch[]`

```json
["general_dentistry", "implantology", "oral_surgery", "periodontics", "orthodontics", "prosthodontics", "cosmetic_dentistry"]
```

### `doctors_at_branch_fps[]` (FK → `seo_authors_reviewers.fingerprint`)

| Branch | Doctors | Notes |
|--------|---------|-------|
| smilescape-rattanathibet | TBD (likely both founders + visiting specialists) | Operator action — confirm rotation |
| smilescape-srinakarin | TBD (likely both founders + visiting specialists) | Operator action — confirm rotation |

> Currently mapped doctors in `entities.md`: `dr-woraphat-jarangkul` (หมอแฮม). Co-Founder `ทพญ. พิชชาภา ผุดผ่อง (หมอแพรว)` pending entity creation (Stage 1.5).

### `equipment_at_branch_fps[]` (FK → `seo_entity_graph.fingerprint` type=device)

Both branches assumed equipped with:
- cbct-3d-scan
- intraoral-scanner
- surgical-guide
- cad-cam
- ptfe-membrane (consumable for GBR)

> Operator action: confirm equipment per-branch — some advanced equipment may only be at one branch.

---

## Google Business Profile

| Field | smilescape-rattanathibet | smilescape-srinakarin | Status |
|-------|--------------------------|-----------------------|--------|
| `gbp_place_id` | TBD | TBD | Operator action — GBP registration |
| `gbp_account_id` | TBD | TBD | Operator action |
| `gbp_categories[]` | ["Dental Implants Periodontist", "Dental Clinic", "Cosmetic Dentist"] | (same) | Proposed default; operator to confirm |
| `gbp_review_count` | 0 (initial) | 0 (initial) | Auto-synced via Flow E1 every 6h |
| `gbp_avg_rating` | NULL | NULL | Auto-synced |
| `gbp_last_synced_at` | NULL | NULL | Set by Flow E1 first run |

---

## Other Directories (Cross-platform listings)

| Platform | smilescape-rattanathibet | smilescape-srinakarin | Notes |
|----------|--------------------------|-----------------------|-------|
| Apple Business Connect (`apple_maps_id`) | TBD | TBD | iOS users — Apple Maps |
| Facebook Page (`facebook_page_url`) | TBD | TBD | TH market — high engagement |
| Wongnai (`wongnai_url` + `wongnai_id`) | TBD | TBD | TH-critical for clinic reviews |

> Full directory list → `directory-listings.md` for NAP audit tracking.

---

## Schema.org / LocalBusiness

### `local_business_schema_type`

Both branches → **`DentalClinic`** (preferred over generic MedicalClinic per Bible Part 14.6 — clinic-specific)

CHECK constraint allows: `LocalBusiness` / `MedicalClinic` / `DentalClinic` / `Hospital` / `BeautySalon` / `HealthAndBeautyBusiness` / `MedicalBusiness` / `Physician`

### Multilingual `canonical_names` jsonb

**smilescape-rattanathibet:**
```json
{
  "th": "SmileScape สาขารัตนาธิเบศร์",
  "en": "SmileScape Rattanathibet Branch",
  "_aliases": ["สาขานนทบุรี", "SmileScape นนทบุรี", "คลินิกรากฟันเทียมนนทบุรี"]
}
```

**smilescape-srinakarin:**
```json
{
  "th": "SmileScape สาขาศรีนครินทร์",
  "en": "SmileScape Srinakarin Branch",
  "_aliases": ["สาขาศรีนครินทร์", "SmileScape Bangkok", "SmileScape สวนหลวง ร.9", "คลินิกรากฟันเทียมศรีนครินทร์"]
}
```

---

## Photos

| Field | smilescape-rattanathibet | smilescape-srinakarin |
|-------|--------------------------|-----------------------|
| `primary_photo_url` | TBD | TBD |
| `exterior_photos[]` | TBD (≥3 recommended) | TBD |
| `interior_photos[]` | TBD (≥10 — reception, treatment room, CBCT room, sterilization) | TBD |

> Used in: schema:LocalBusiness `image`, GBP profile photos, branch landing page hero.

---

## Compliance / Legal

| Field | smilescape-rattanathibet | smilescape-srinakarin |
|-------|--------------------------|-----------------------|
| `business_registration_no` (DBD) | TBD | TBD |
| `medical_license_no` (กรมสนับสนุนบริการสุขภาพ) | TBD | TBD |
| `opened_date` | TBD | TBD |
| `closed_date` | NULL (active) | NULL (active) |

---

## Schema:LocalBusiness JSON-LD Templates

### Template — รัตนาธิเบศร์

```jsonld
{
  "@context": "https://schema.org",
  "@type": "DentalClinic",
  "@id": "https://smilescapeclinic.com/รัตนาธิเบศร์#location",
  "name": "SmileScape สาขารัตนาธิเบศร์",
  "alternateName": ["SmileScape Rattanathibet", "SmileScape นนทบุรี"],
  "legalName": "TBD",
  "parentOrganization": {
    "@type": "MedicalOrganization",
    "@id": "https://smilescapeclinic.com/#organization",
    "name": "SmileScape Dental Clinic"
  },
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "TBD",
    "addressLocality": "TBD (แขวง)",
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
  "email": "TBD",
  "url": "https://smilescapeclinic.com/รัตนาธิเบศร์",
  "image": "TBD",
  "priceRange": "฿฿",
  "medicalSpecialty": ["Dentistry", "Implantology", "Periodontics", "Orthodontics", "Prosthodontics", "OralSurgery"],
  "availableService": "{see services_offered_fps[] above}",
  "openingHoursSpecification": "{see opening_hours jsonb}",
  "publicTransportAccess": "MRT Purple Line — Rattanathibet Station"
}
```

### Template — ศรีนครินทร์

Same structure as above with `addressLocality` and `addressRegion` adjusted for Bangkok, `publicTransportAccess` = "MRT Yellow Line — Suan Luang Rama 9 area".

---

## Geo-Keyword Seed (Local SEO)

> Mapped to sitemap section 8.2 + 8.3 + future T18 programmatic local pages. Volume enrichment pending DataForSEO at Stage 1.5.

### รัตนาธิเบศร์ branch

| Geo Term | Search Intent | Used In |
|----------|---------------|---------|
| รากฟันเทียมนนทบุรี | Commercial — direct treatment lookup | 8.2.2 + T18 |
| ทำฟันนนทบุรี | Navigational/Commercial | 8.2.3 |
| จัดฟันนนทบุรี | Commercial — ortho lookup | 8.2.4 |
| คลินิกทำฟันใกล้ MRT สีม่วง | Navigational — transit-based | 8.2.5 |
| คลินิกทันตกรรมรัตนาธิเบศร์ | Navigational | T18 |
| ทันตแพทย์รัตนาธิเบศร์ | Navigational | T18 |

### ศรีนครินทร์ branch

| Geo Term | Search Intent | Used In |
|----------|---------------|---------|
| รากฟันเทียมศรีนครินทร์ | Commercial — direct treatment lookup | 8.3.2 + T18 |
| ทำฟันศรีนครินทร์ | Navigational/Commercial | 8.3.3 |
| จัดฟันศรีนครินทร์ | Commercial — ortho lookup | 8.3.4 |
| คลินิกทำฟันใกล้ MRT สีเหลือง | Navigational — transit-based | 8.3.5 |
| คลินิกทันตกรรมศรีนครินทร์ | Navigational | T18 |
| รากฟันเทียมสวนหลวง ร.9 | Commercial — hyper-local | T18 |

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
- Uniqueness: each page must have ≥ 60% unique content

**Status:** Not yet added to sitemap. Wait for keyword volume data → operator decision.

---

## n8n Flow Integration (Bible Part 17.6 GROUP E)

| Flow | Frequency | Updates |
|------|-----------|---------|
| **E1** GBP Reviews Sync | Every 6h | INSERTs new reviews → `seo_reviews`; UPDATEs `gbp_review_count` + `gbp_avg_rating` here |
| **E2** GBP Posts Publish | On-demand | Publishes from `seo_gbp_posts` to GBP API |
| **E3** NAP Audit | Weekly | Compares `seo_directory_listings` vs canonical NAP here; flags inconsistencies |
| **E4** GBP Posts Metrics | Daily | Fetches views/clicks → `seo_gbp_posts` |

---

## EUG Pre-flight Notes (Stage 1.5)

Validation checks before flat-load to Supabase:

- [ ] `branch_slug` uniqueness across federation — confirm `smilescape-rattanathibet` and `smilescape-srinakarin` not reused by other EYWA brands
- [ ] `is_primary=true` unique per brand_id (CHECK constraint) — `smilescape-rattanathibet` flagged primary
- [ ] `status` value ∈ {'active','closed','temp_closed','pending_opening'}
- [ ] `local_business_schema_type` ∈ allowed CHECK list — using `DentalClinic`
- [ ] `organization_entity_id` FK valid — both branches link to entity rows in entities.md
- [ ] `parent_notion_id` will be backfilled at Phase 2 Notion sync
- [ ] GPS lat/lng valid before `geo_point` PostGIS computation
- [ ] `gbp_place_id` requires GBP activation (operator action)
- [ ] `services_offered_fps[]` cross-reference: all slugs exist in `entities.md`
- [ ] `opening_hours` jsonb matches OpeningHoursSpecification schema (CHECK constraint)

---

## Operator Action Items

**Per branch — must collect before Stage 1.5:**

- [ ] Full street address + district + postal code
- [ ] GPS latitude/longitude (Google Maps pin) → Plus Code auto-derived
- [ ] Primary phone (E.164 format)
- [ ] Branch email
- [ ] LINE Official Account ID
- [ ] Google Business Profile registration → obtain `gbp_place_id` + `gbp_account_id`
- [ ] Opening hours per day of week
- [ ] Special hours / holiday calendar (annual)
- [ ] Branch photos: 1 primary + ≥3 exterior + ≥10 interior
- [ ] Apple Business Connect registration → `apple_maps_id`
- [ ] Facebook Page URL
- [ ] Wongnai listing claim → URL + ID
- [ ] DBD business registration number (`business_registration_no`)
- [ ] Medical license number (`medical_license_no`)
- [ ] Branch opening date (`opened_date`)

**Cross-branch:**

- [ ] Confirm doctor rotation per branch (which days at รัตนาธิเบศร์ vs ศรีนครินทร์)
- [ ] Confirm service availability (any advanced services only at one branch?)
- [ ] Confirm equipment per branch (CBCT, intraoral scanner, CAD/CAM at both?)
- [ ] Co-Founder entity creation (ทพญ. พิชชาภา ผุดผ่อง / Pitchapa Phudphong) — pending specialty/credentials

---

## Cross-References

- Branch entity rows: `entities.md` — cluster `brand-doctor-authority`, rows #6 (รัตนาธิเบศร์), #7 (ศรีนครินทร์)
- Branch relationships: `relationships.md` — section K (part_of), each branch → smilescape-dental-clinic
- Branch landing pages: `sitemap.md` — sections 8.1 (Contact Hub), 8.2 (รัตนาธิเบศร์), 8.3 (ศรีนครินทร์)
- Brand config branches array: `brand-config.json:132-143`
- Reviews aggregation: `reviews.md` — multi-platform review collection per branch
- Directory listings: `directory-listings.md` — NAP audit tracking per branch
- GBP posts: `gbp-posts.md` — content calendar per branch

---

*Phase C local SEO planning. Per Schema v1.11 §3.2 + Bible Part 10.5 + DR-025. Feeds Stage 1.5 → `seo_branches` table (~40 cols).*
