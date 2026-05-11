# SmileScape Dental Clinic — GBP Posts Planning File

> **Phase:** Stage 1 → Phase C (Local SEO — Skeleton)
> **Schema:** Schema_Overview v1.11 §3.7 — `seo_gbp_posts` table 🆕 v1.11
> **Date:** 2026-05-12
> **Status:** Schema skeleton + campaign calendar template — content authored at Stage 1.5 / Phase F
> **Bible reference:** Part 10.5 (Local SEO), Part 17.6 GROUP E Flow E2 (Publish), Flow E4 (Metrics Sync), Appendix B.5 Table 27
> **DR reference:** DR-025 Locked 2026-05-12

> ⚠️ **Local archive critical:** GBP posts auto-expire after 6 months — without this table, historical campaign data is lost. Multi-branch campaigns coordinated via `batch_id` (same content across N branches).

---

## Purpose

Google Business Profile Posts content calendar + local archive. Supports:
- Multi-branch campaign coordination (same offer/event published to both branches)
- Approval workflow before publish (PDPA + medical advertising compliance)
- Performance tracking (views/clicks/conversions via Flow E4)
- Historical archive (GBP wipes posts at 6 months)

---

## Post Types

| `post_type` | Use case | Required fields | GBP duration |
|-------------|----------|-----------------|--------------|
| `standard` | General content / education | title + body + cta_type | 6 months |
| `event` | Open house, workshop, free consultation day | event_start_at + event_end_at | Until event ends |
| `offer` | Promotion / discount / package | offer_coupon_code + offer_terms + offer_redeem_url | offer_validity |
| `product` | Treatment package as product (e.g., All-on-X package) | product_name + product_price_min/max | 6 months |
| `covid_update` | Health/safety advisories (legacy) | body | 6 months |

---

## CTA Types

| `cta_type` | Use case |
|-----------|----------|
| `book` | "จองคิวปรึกษาฟรี" — primary CTA for SmileScape |
| `learn_more` | "อ่านรายละเอียด" — links to landing page |
| `sign_up` | "สมัครรับสิทธิพิเศษ" — newsletter / waitlist |
| `call` | "โทรหาเรา" — direct phone tap |
| `order` | (not typical for clinic) |
| `shop` | (not typical for clinic) |
| `none` | Pure informational |

---

## Content Limits (GBP spec)

| Field | Max length | Notes |
|-------|-----------|-------|
| `title` | 58 chars | Truncated in Google Search snippet |
| `body` | 1500 chars | Thai language counted per character |
| `photo_url` | 1 primary | Recommended ratio 4:3 or 16:9 |
| `video_url` | 1 optional | <100MB, <30s preferred |

---

## Approval Workflow

```
Draft → Pending Review → Approved → Scheduled → Published
                ↓                                    ↓
            Rejected                            Expired/Archived
```

| `status` | Definition |
|----------|------------|
| `draft` | Operator writing |
| `scheduled` | Approved + queued (`scheduled_for` set) |
| `publishing` | Flow E2 in-flight |
| `published` | Live on GBP — `gbp_post_id` set |
| `expired` | Auto-expired by GBP (>6 months) |
| `failed` | Flow E2 error — see `gbp_api_response` |
| `archived` | Operator manually retired |

| `approval_status` | Definition |
|------------------|------------|
| `pending` | Awaiting review |
| `approved` | Cleared for publish (`approved_by_fp` + `approved_at` set) |
| `rejected` | Blocked (`rejection_reason` set) |

**Approval triggers:**
- Medical claims content → require legal + medical director review
- Pricing/offers → require commercial director review
- Multi-branch (`batch_id` set) → single approval applies to all batched posts

---

## Multi-Branch Campaigns

`batch_id` (uuid) groups same content across multiple branches:
1. Operator creates 1 master post in Notion
2. n8n duplicates to N branch rows with shared `batch_id`
3. Single approval → all batch rows status updated together
4. Flow E2 publishes to each branch's GBP independently

**`campaign_id` / `campaign_name`** group multi-post sequences (e.g., "Q3-2026 Implant Awareness Series" with weekly posts over 12 weeks).

---

## Campaign Calendar Seed (Year 1)

> Proposed quarterly cadence — finalize at Stage 1.5 / Phase F. All posts target both branches via `batch_id`.

### Q1 — Brand Introduction

| Week | post_type | Title (TH) | CTA | Notes |
|------|-----------|-----------|-----|-------|
| W1 | standard | "ยินดีต้อนรับสู่ SmileScape — Implant Mastery สำหรับครอบครัวคุณ" | book | Brand launch |
| W3 | standard | "ทำไม Dr. แฮม เลือกเทคนิค Sausage Technique" | learn_more | Authority |
| W6 | event | "ปรึกษาฟรี — Open House วันเสาร์" | book | Lead gen |
| W9 | standard | "SMILE DNA — 5 ค่านิยมของ SmileScape" | learn_more | Brand values |
| W11 | standard | "Family Standard — เราดูแลคนไข้เหมือนพ่อแม่ของเรา" | learn_more | Differentiator |

### Q2 — Service Highlights

| Week | post_type | Title (TH) | CTA | Service |
|------|-----------|-----------|-----|---------|
| W14 | standard | "All-on-4 vs All-on-6 — เลือกแบบไหนดี" | learn_more | all-on-x |
| W17 | standard | "Sausage Technique — เคสกระดูกไม่พอ ทำได้" | book | sausage-technique |
| W19 | offer | "โปรโมชั่นรากฟันเทียม — Founder's Quarter" | book | dental-implant |
| W22 | standard | "Lifetime Warranty — รับประกันรากฟันเทียมตลอดชีพ" | learn_more | lifetime-implant-warranty |
| W25 | standard | "Clear Aligner TrioClear — จัดฟันใสแบบ Progressive" | book | trioclear-aligner |

### Q3 — Patient Education / Authority

| Week | post_type | Title (TH) | CTA | Notes |
|------|-----------|-----------|-----|-------|
| W27 | standard | "ฟันหายไม่ทำ — ผลกระทบที่คุณอาจไม่รู้" | learn_more | tooth-loss awareness |
| W30 | standard | "CBCT 3D — ทำไมต้องสแกนก่อนฝังราก" | learn_more | cbct-3d-scan |
| W33 | event | "Workshop ฟรี — ดูแลรากฟันเทียมระยะยาว" | sign_up | Existing patient retention |
| W36 | standard | "Peri-Implantitis — สัญญาณเตือนที่ต้องระวัง" | learn_more | peri-implantitis |
| W39 | standard | "All-on-X เคสจริง — Before & After" | learn_more | Case study link |

### Q4 — Year-end / Holiday

| Week | post_type | Title (TH) | CTA | Notes |
|------|-----------|-----------|-----|-------|
| W41 | offer | "Year-end Health Promotion — ใช้สิทธิ์ก่อนสิ้นปี" | book | Tax incentive angle |
| W44 | standard | "ของขวัญสุขภาพ — Gift Voucher ปรึกษาทันตกรรม" | book | Gift card |
| W47 | standard | "เคสปีนี้ — รวมผลงาน SmileScape" | learn_more | Year recap |
| W50 | event | "Holiday Hours — ตารางวันหยุดปลายปี" | none | Special hours notice |
| W52 | standard | "ขอบคุณคนไข้ทุกท่าน — สวัสดีปีใหม่" | none | Year-end thank you |

**Annual total:** ~20 posts × 2 branches = ~40 GBP post rows (matches `seo_gbp_posts` volume estimate of 10-100 per branch/year).

---

## Content Guidelines

**Voice & tone** (per `patient-journey.md` SMILE DNA):
- ไม่ใช้คำเทคนิคจัด — explain ความหมาย
- น้ำเสียง warm, knowledgeable, never pushy
- Lead with patient benefit, not features
- Mention Dr. แฮม / หมอแพรว naturally where authority signal helps
- Always include local context ("ที่ SmileScape นนทบุรี/ศรีนครินทร์")

**Medical claims compliance:**
- Statistics must cite source (Pillar 1-5 from `citation-pool-seed.md`)
- Avoid superlatives ("ดีที่สุด", "อันดับ 1") — use specific evidence
- Treatment outcomes must include realistic disclaimers
- PDPA: no patient identifying details in photos/text

**Hashtag strategy (per branch):**
- #SmileScape #รากฟันเทียม #DentalImplant
- รัตนาธิเบศร์: #คลินิกทันตกรรมนนทบุรี #รากฟันเทียมนนทบุรี
- ศรีนครินทร์: #คลินิกทันตกรรมกรุงเทพ #รากฟันเทียมศรีนครินทร์

---

## Performance Metrics (Flow E4 daily sync)

| Field | Source | Notes |
|-------|--------|-------|
| `views_count` | GBP API | Impression count |
| `clicks_count` | GBP API | CTA tap count |
| `conversions_count` | GA4 / conversion API | If tracked (book consultation completion) |
| `engagement_rate` | GENERATED ALWAYS AS (clicks/views) STORED | CTR proxy |

**KPI targets (Year 1 baseline):**

| Metric | Target | Notes |
|--------|--------|-------|
| Views per post | ≥ 500 | GBP norm for active business |
| Clicks per post | ≥ 25 | 5% CTR |
| Engagement rate | ≥ 0.05 | |
| Posts published / month | 2-4 | Optimal cadence |

---

## EUG Pre-flight Notes (Stage 1.5)

- [ ] `post_type` ∈ {'standard','event','offer','product','covid_update'}
- [ ] `cta_type` ∈ allowed CHECK list or NULL
- [ ] `status` ∈ {'draft','scheduled','publishing','published','expired','failed','archived'}
- [ ] `approval_status` ∈ {'pending','approved','rejected'}
- [ ] If `post_type='event'` → `event_start_at` and `event_end_at` NOT NULL, end >= start
- [ ] `title` ≤ 58 chars (validated in form)
- [ ] `body` ≤ 1500 chars
- [ ] `branch_id` FK valid (cascade delete)
- [ ] `batch_id` consistent across batched siblings
- [ ] `engagement_rate` GENERATED column — read-only

---

## Operator Action Items

**Pre-launch (Stage 1.5):**

- [ ] GBP account claim per branch (prerequisite — see `directory-listings.md`)
- [ ] Define annual campaign calendar (build from seed above)
- [ ] Build approval workflow in Notion (linked to `approval_status` column)
- [ ] Define `rejection_reason` taxonomy
- [ ] Train content team on GBP content limits + voice guidelines
- [ ] Photo library prep (1-2 photos per post × ~40 posts = ~50-80 photo assets needed for Y1)

**Ongoing (Phase F onward):**

- [ ] Monthly approval cycle (operator + medical director review)
- [ ] Quarterly campaign review (rotate seasonal angles)
- [ ] Performance review per `engagement_rate` — kill underperformers, scale winners

---

## n8n Flow E2 + E4 Integration

```
Flow E2: GBP Posts Publish
Trigger: Cron every 15min
Steps:
1. SELECT seo_gbp_posts WHERE status='scheduled' AND approval_status='approved'
                         AND scheduled_for <= NOW()
2. For each post:
3.   Call GBP API: localPosts.create per branch
4.   UPDATE row: status='published', gbp_post_id, gbp_post_url, gbp_published_at
5.   On error: status='failed', gbp_api_response

Flow E4: GBP Posts Metrics Sync
Trigger: Cron daily at 06:00
Steps:
1. SELECT seo_gbp_posts WHERE status='published'
                         AND gbp_last_synced_at < NOW() - INTERVAL '1 day'
2. For each post:
3.   Call GBP API: localPosts.reports
4.   UPDATE: views_count, clicks_count, gbp_last_synced_at
       (engagement_rate auto-recomputed GENERATED column)
```

---

## Cross-References

- Parent branch: `branches.md` — gbp_account_id + gbp_place_id required for Flow E2
- Approval team: pending `seo_authors_reviewers` (medical director, commercial director)
- Entity references: `entities.md` — for service mentions in post body
- Citation references: `citation-pool-seed.md` — Pillar 1-5 for evidence-backed claims
- Schema migration: `012_create_seo_gbp_posts.sql` (DR-025)

---

*Phase C local SEO skeleton — content calendar seed + schema reference. Actual post drafting at Phase F. Per Schema v1.11 §3.7 + DR-025.*
