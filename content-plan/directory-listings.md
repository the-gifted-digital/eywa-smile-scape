# SmileScape Dental Clinic — Directory Listings Planning File

> **Phase:** Stage 1 → Phase C (Local SEO — Skeleton)
> **Schema:** Schema_Overview v1.11 §3.6 — `seo_directory_listings` table 🆕 v1.11
> **Date:** 2026-05-12
> **Status:** Schema skeleton + directory inventory — claim/audit at Stage 1.5 via n8n Flow E3 (weekly NAP audit)
> **Bible reference:** Part 10.5 (Local SEO), Part 17.6 GROUP E Flow E3 (NAP Audit), Appendix B.5 Table 26
> **DR reference:** DR-025 Locked 2026-05-12

> ⚠️ **Distinct from `seo_citations`:** This table tracks **NAP citations / directory listings** (Local SEO). `seo_citations` (Phase B output `citation-pool-seed.md`) tracks **academic citations** (PubMed DOI). Do not conflate.

---

## Purpose

NAP (Name / Address / Phone) consistency tracker across ~50 local directories per branch. Auto-detects inconsistencies via fuzzy matching against canonical NAP in `seo_branches`. Powers Flow E3 weekly audit + citation acquisition workflow.

---

## Directory Categories

| `directory_category` | Definition | Authority weight |
|---------------------|------------|------------------|
| `major_search` | Google / Bing / Apple Maps | 90-100 |
| `thai_local` | Wongnai / Pantip / Yellow Pages TH / LINE OA | 70-90 |
| `industry_specific` | RateMDs / Healthgrades dental directories | 60-80 |
| `social` | Facebook / Instagram business listings | 50-70 |
| `mapping` | OpenStreetMap / Foursquare / Waze | 40-60 |

---

## Target Directory Inventory (per branch)

> Status pending operator claim. Each branch will have its own row per directory.

### Tier 1 — Must Claim (Day 1)

| Directory Name | `directory_slug` | Category | TH-specific | Authority | Notes |
|---------------|------------------|----------|-------------|-----------|-------|
| Google Business Profile | `gbp` | major_search | No | 100 | NAP master mirror — Flow E1 sync |
| Wongnai | `wongnai` | thai_local | **Yes** | 85 | TH dental-critical for reviews |
| Apple Business Connect | `apple-maps` | major_search | No | 80 | iOS user discovery |
| Facebook Business Page | `facebook` | social | No | 75 | TH high engagement |
| LINE Official Account | `line-oa` | thai_local | **Yes** | 70 | TH messaging-first culture |

### Tier 2 — Should Claim (within Quarter 1)

| Directory Name | `directory_slug` | Category | TH-specific | Authority | Notes |
|---------------|------------------|----------|-------------|-----------|-------|
| Bing Places | `bing-places` | major_search | No | 60 | Microsoft Edge users |
| Foursquare | `foursquare` | mapping | No | 55 | Apple Maps data feed |
| Yellow Pages TH | `yellowpages-th` | thai_local | **Yes** | 50 | Legacy TH business directory |
| Pantip Business | `pantip` | thai_local | **Yes** | 60 | TH forum mentions (informal) |
| Instagram Business | `instagram` | social | No | 65 | Visual content + reviews |

### Tier 3 — Optional / Industry-specific

| Directory Name | `directory_slug` | Category | TH-specific | Authority | Notes |
|---------------|------------------|----------|-------------|-----------|-------|
| Whitecoat (Asia medical) | `whitecoat` | industry_specific | No | 50 | dental-specific cross-region |
| Doctoroncall | `doctoroncall` | industry_specific | No | 45 | Asia medical directory |
| OpenStreetMap | `osm` | mapping | No | 40 | Wikidata-linkable |
| Waze Local | `waze` | mapping | No | 45 | TH driver app |
| Trustpilot | `trustpilot` | major_search | No | 55 | Generic review |

---

## NAP Consistency Scoring

> Auto-computed by Flow E3 per `seo_branches` canonical NAP.

| Score | Auto-computed | Inconsistency threshold |
|-------|---------------|------------------------|
| `name_match_score` | Fuzzy match vs `business_name_brand` | < 0.95 = inconsistent |
| `address_match_score` | Fuzzy match vs `formatted_address` | < 0.95 |
| `phone_match_score` | Normalized digit match vs `phone` | < 1.00 (exact) |
| `website_match_score` | URL match vs `website_url` | < 1.00 |
| `nap_match_score` | GENERATED ALWAYS AS avg of name + address + phone | < 0.95 → flag |
| `has_inconsistency` | GENERATED ALWAYS AS (nap_match_score < 0.95) | true → action item |

**Inconsistency severity:**

| `inconsistency_severity` | Definition | Action |
|-------------------------|------------|--------|
| `critical` | Wrong phone or address | Immediate fix — affects callbacks/visits |
| `moderate` | Name variation (e.g., "SmileScape" vs "Smile Scape Clinic") | Schedule fix in 1 week |
| `minor` | Formatting only (spaces, punctuation) | Batch fix in monthly audit |

---

## Listing Status Workflow

```
Discovery → Pending claim → Verification → Live → (Audit cycle weekly)
                ↓
             Unclaimed (high-authority → auto-create Notion task)
```

| `status` | Definition |
|----------|------------|
| `pending` | Newly discovered, not yet attempted |
| `live` | Active listing — included in Flow E3 audit |
| `rejected` | Platform rejected (e.g., duplicate report) |
| `duplicate` | Found duplicate listing on same platform — needs merge |
| `unlisted` | Removed by platform or operator |

| `claim_status` | Definition |
|---------------|------------|
| `unclaimed` | Discovered listing not yet claimed |
| `in_progress` | Claim submitted, awaiting verification |
| `claimed` | Verified — operator controls |
| `verification_failed` | Postcard/phone verification failed — retry needed |

---

## Discovery Sources

| `found_via` | Method |
|-------------|--------|
| `manual_audit` | Operator-added |
| `gbp_insights` | GBP "where customers found you" data |
| `whitespark` | Whitespark Citation Tracker tool |
| `brightlocal` | BrightLocal Citation Tracker tool |
| `discovered_search` | Manual Google search for brand name + city |

---

## Initial Inventory Estimate (per branch)

| Tier | Count per branch | Total (2 branches) |
|------|------------------|--------------------|
| Tier 1 (must claim) | 5 | 10 rows |
| Tier 2 (should claim) | 5 | 10 rows |
| Tier 3 (optional) | 5-10 | 10-20 rows |
| Discovered ad-hoc | ~10-30 | ~20-60 rows |
| **Total** | **~25-50** | **~50-100 rows** |

> Per `seo_directory_listings` table notes: avg ~50 directories tracked per branch

---

## EUG Pre-flight Notes (Stage 1.5)

- [ ] Unique constraint: (`branch_id`, `directory_slug`) — no duplicate row per branch+directory pair
- [ ] `status` ∈ {'live','pending','rejected','duplicate','unlisted'}
- [ ] `claim_status` ∈ {'claimed','unclaimed','in_progress','verification_failed'}
- [ ] `inconsistency_severity` ∈ {'critical','moderate','minor'} or NULL
- [ ] `branch_id` FK valid (cascade delete on branch removal)
- [ ] `next_verification_due` populated for `status='live'` rows
- [ ] `nap_match_score` GENERATED column — verify CHECK constraint on computed expression
- [ ] Initial state: ~10 Tier 1 rows pre-seeded (one per branch × 5 directories), `status='pending'`

---

## Operator Action Items

**Phase 0 — Listing acquisition:**

- [ ] Tier 1 claim sequence (per branch):
  1. GBP claim + verification
  2. Wongnai listing claim
  3. Apple Business Connect registration
  4. Facebook Business Page setup
  5. LINE Official Account setup
- [ ] Tier 2 claim sequence (within Q1):
  1. Bing Places
  2. Foursquare
  3. Yellow Pages TH
  4. Pantip Business
  5. Instagram Business

**Phase 1 — NAP discipline:**

- [ ] Document canonical NAP per branch (see `branches.md` NAP section)
- [ ] Use Wongnai listing as TH-market secondary canonical (some directories sync from Wongnai)
- [ ] Train operator on NAP discipline: any address/phone change must update `seo_branches` first → then propagate to all listings within 1 week

**Phase 2 — Audit setup:**

- [ ] Configure Flow E3 to run weekly per active branch
- [ ] Set `next_verification_due` initial values
- [ ] Define `claim_reason` taxonomy for Notion task auto-creation on `claim_status='unclaimed' AND directory_authority_score >= 70`

---

## n8n Flow E3 Integration

```
Flow E3: NAP Audit
Trigger: Cron weekly
Steps:
1. For each seo_directory_listings row where status='live':
2.   Fetch current listing data from directory (scrape/API)
3.   Compute fuzzy match vs seo_branches canonical NAP:
       - name_match_score, address_match_score, phone_match_score, website_match_score
       - nap_match_score auto-computed (GENERATED column)
       - has_inconsistency auto-flagged
4. UPDATE last_verified_at = NOW()
5. UPDATE next_verification_due = NOW() + 7 days
6. If has_inconsistency=true → Notion task created (operator notification)
7. If claim_status='unclaimed' AND directory_authority_score >= 70 → Notion task: "Claim {directory_name}"
```

---

## Cross-References

- Branch canonical NAP: `branches.md` — single source of truth
- Citation pool (academic): `citation-pool-seed.md` — distinct workflow
- Schema migration: `011_create_seo_directory_listings.sql` (DR-025)
- Wongnai branch URL/ID: `branches.md` — `wongnai_url` + `wongnai_id` cached on parent branch row

---

*Phase C local SEO skeleton — directory inventory + claim plan. Operator-driven acquisition + Flow E3 weekly audit at Stage 1.5. Per Schema v1.11 §3.6 + DR-025.*
