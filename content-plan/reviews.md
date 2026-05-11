# SmileScape Dental Clinic — Reviews Planning File

> **Phase:** Stage 1 → Phase C (Local SEO — Skeleton)
> **Schema:** Schema_Overview v1.11 §3.5 — `seo_reviews` table 🆕 v1.11
> **Date:** 2026-05-12
> **Status:** Schema skeleton — review data populated at Stage 1.5 via n8n Flow E1 (every 6h GBP sync)
> **Bible reference:** Part 10.5 (Local SEO), Part 17.6 GROUP E Flow E1, Part 23.4 (Editorial Review), Appendix B.5 Table 25
> **DR reference:** DR-025 Locked 2026-05-12
> **PDPA critical:** Reviews may contain personal data — `pdpa_risk_flag` + legal review required before public response (PDPA B.E. 2562 / 2019)

---

## Purpose

Multi-platform review aggregation across Google Business Profile, Wongnai, Facebook, Google Maps, Pantip, Apple Maps. Centralized store for:
- Sentiment analysis + topic extraction
- PDPA-safe response workflow (legal review before public reply)
- Quality monitoring + KPI tracking (Bible Part 16)
- Multi-branch performance comparison

---

## Source Platforms (in scope)

| Platform | `source_platform` value | Priority | Notes |
|----------|------------------------|----------|-------|
| Google Business Profile | `gbp` | **Critical** | Day 1 — Flow E1 auto-sync |
| Wongnai | `wongnai` | **Critical** | TH dental-critical platform |
| Facebook | `facebook` | High | Page reviews + recommendations |
| Google Maps | `google_maps` | High | Often same as GBP — dedupe via `source_review_id` |
| Pantip | `pantip` | Medium | Mentions/threads (not formal reviews) |
| Apple Maps | `apple_maps` | Medium | iOS user reviews |
| TripAdvisor | `tripadvisor` | Low | Not typical for dental |
| Manual entry | `manual` | Backfill | Historical/offline reviews |

---

## Response Workflow

```
1. Flow E1 ingests → seo_reviews row created with response_status='pending'
2. Auto-flag rules:
   - rating ≤ 3.0 → response_priority='urgent'
   - pdpa_risk_flag=true → require legal_review
3. Draft → response_status='drafted' (assigned to response_drafted_by_fp)
4. Legal Review (if pdpa_risk_flag) → response_legal_reviewed=true
5. Approve → response_status='approved'
6. Publish via Flow E2/manual → response_status='published'
   ↳ responded_at + responded_by_fp set
```

**Response priority rules:**

| Trigger | Priority | SLA |
|---------|----------|-----|
| Rating 1-2 | urgent | < 24h |
| Rating 3 | high | < 48h |
| Rating 4-5 (negative tone) | normal | < 7d |
| Rating 5 (positive) | low | < 14d (thank-you reply) |

---

## PDPA Risk Flagging

`pdpa_risk_flag = true` when reviewer mentions:
- Specific medical condition (e.g., "ผมเป็นเบาหวานแล้วทำรากเทียม...")
- Specific staff names (other than approved public faces)
- Treatment outcome with identifying detail
- Photos of patient face/intraoral

**Action:** Block public response until legal review. `response_status='legal_review'` → `response_legal_reviewed=true` before publish.

---

## NLP / Analytics (auto-populated by Flow E1)

| Field | Source | Use |
|-------|--------|-----|
| `detected_topics[]` | OpenAI extractor | Service mentioned, staff praised, complaint category |
| `sentiment` | NLP classifier | positive / neutral / negative / mixed |
| `sentiment_score` | NLP confidence | -1.000 to 1.000 |
| `mentioned_entities_fps[]` | Entity linker | Auto-detect entity mentions (e.g., "Sausage Technique", "All-on-4") → links to `seo_entity_graph` |
| `mentioned_doctors_fps[]` | Author linker | Auto-detect doctor mentions → `seo_authors_reviewers` |

---

## Topic Taxonomy (Seed — refined post-launch)

Expected review topics for SmileScape (dental implant clinic):

**Service mentions:**
- รากฟันเทียม / dental-implant
- All-on-X / ฟันทั้งปาก / all-on-x
- จัดฟันใส / clear-aligner
- เสริมกระดูก / GBR / bone-grafting

**Staff praise:**
- หมอแฮม (Dr. Woraphat) — Lead Implantologist
- หมอแพรว (Dr. Pitchapa) — Co-Founder
- Front desk / clinic staff (anonymized in response)

**Quality dimensions:**
- ความเชี่ยวชาญแพทย์ (expertise)
- เทคโนโลยี (technology — CBCT, Digital Smile Design)
- บรรยากาศคลินิก (ambience)
- บริการ (service)
- ราคา/ความคุ้มค่า (price/value)
- ระยะเวลารักษา (treatment duration)
- ความเจ็บปวด (pain — usually praise for flapless surgery)

**Complaint categories** (response-critical):
- รอนาน (waiting time)
- ค่าใช้จ่ายเกินคาด (cost surprise)
- ผลลัพธ์ไม่เป็นไปตามคาด (outcome dissatisfaction — PDPA-sensitive)
- การสื่อสาร (communication)

---

## Review Volume Estimate (TH dental clinic baseline)

| Branch | Year 1 estimate | Year 2 estimate | Notes |
|--------|----------------|-----------------|-------|
| smilescape-rattanathibet | ~50-100 | ~150-300 | Lower volume — newer branch, MRT Purple area |
| smilescape-srinakarin | ~50-100 | ~150-300 | Bangkok exposure but competitive market |

> Per `seo_reviews` table notes: TH clinic avg ~50-200/yr

---

## Branch-Level Aggregation (auto-updated on `seo_branches`)

n8n Flow E1 updates parent `seo_branches` row after each batch:

| Branch row field | Source | Refresh |
|-----------------|--------|---------|
| `gbp_review_count` | COUNT(reviews where source_platform='gbp') | Every 6h |
| `gbp_avg_rating` | AVG(rating where source_platform='gbp') | Every 6h |
| `gbp_last_synced_at` | NOW() at flow end | Every 6h |

---

## Verification & Anti-Spam

| Field | Use |
|-------|-----|
| `is_verified_customer` | Cross-check vs CRM (if available) — verified=stronger signal |
| `is_flagged` | Internal flag: fake / spam / competitor review |
| `flag_reason` | Justification text |
| `flag_reported_at` | When reported to source platform for removal |

**Anti-spam triggers:**
- Reviewer with 0 other reviews + 1-star rating → manual review
- Review text matching competitor patterns
- Reviewer profile created < 7 days before posting
- Identical text across multiple branches/brands → flag all

---

## EUG Pre-flight Notes (Stage 1.5)

- [ ] Unique constraint: (`source_platform`, `source_review_id`) — dedupe across syncs
- [ ] `rating` CHECK 1.0-5.0
- [ ] `source_platform` ∈ allowed CHECK list
- [ ] `response_status` ∈ allowed CHECK list
- [ ] `branch_id` FK valid (cascade delete on branch removal)
- [ ] Initial state: empty table — Flow E1 first run after GBP `gbp_place_id` set
- [ ] PDPA training for response team (Bible Part 23.4)

---

## Operator Action Items

- [ ] GBP claim + verification for both branches → enables Flow E1 ingestion
- [ ] Wongnai claim per branch → manual review backfill (Flow E1 covers GBP only initially)
- [ ] Facebook Page setup + reviews enabled
- [ ] Legal review SOP documented (PDPA response protocol)
- [ ] Response template library (per topic × per rating tier)
- [ ] Response team training (Bible Part 23.4 Editorial Review standards)
- [ ] Define `flag_reason` taxonomy for anti-spam

---

## n8n Flow E1 Integration

```
Flow E1: GBP Reviews Sync
Trigger: Cron every 6h
Steps:
1. For each branch where status='active' AND gbp_place_id IS NOT NULL:
2.   Fetch GBP reviews via API (since last_synced_at)
3.   For each review:
       - INSERT (if source_review_id not seen) with response_status='pending'
       - UPDATE if existing (rating/text changes are rare but possible)
       - Run NLP on review_text → detected_topics, sentiment, mentioned_entities_fps
       - Auto-set response_priority based on rating
4. UPDATE seo_branches:
       - gbp_review_count = COUNT(gbp reviews for this branch)
       - gbp_avg_rating = AVG(rating)
       - gbp_last_synced_at = NOW()
5. Notify Notion if response_priority='urgent'
```

---

## Cross-References

- Branch master: `branches.md` — `gbp_review_count` + `gbp_avg_rating` updated here
- Entity mentions: `entities.md` — `mentioned_entities_fps[]` resolves to entity slugs
- Doctor mentions: pending `seo_authors_reviewers` planning file
- Schema migration: `010_create_seo_reviews.sql` (DR-025)

---

*Phase C local SEO skeleton — schema reference only. Operator data + Flow E1 activation at Stage 1.5. Per Schema v1.11 §3.5 + DR-025.*
