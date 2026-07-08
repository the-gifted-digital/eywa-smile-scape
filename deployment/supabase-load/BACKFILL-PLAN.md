# SmileScape — Supabase Backfill Plan (post Stage 1.5 flat-load)

> Created 2026-07-09. Target: GTGT `lffcbeszjqzioobqfdav` · brand `smile-scape-clinic`.
> Continues from `LOAD-LOG.md` (✅ LOAD COMPLETE 2026-06-07). Sitemap source of truth = branch `sitemap-review-r18-21` (R26, 722p, FULL review complete).
> DB state audited live 2026-07-09 (see "Current gaps" below). Federation housekeeping 2026-07-08 (`_archive_prevth_*`) did NOT touch SmileScape rows — 722 pages verified intact.

## Current gaps (audited 2026-07-09 via MCP)

| Table | SS state | Gap |
|---|---|---|
| `seo_website_page_master` | 722 stubs; `primary_entity_fp` 721/722 | `node_tier` / `funnel_stage` / `page_type` / `slug` / `seo_title` / `target_keyword_fp` / `content_brief` / `parent_page_fp` = **0 ทั้งหมด** |
| `seo_entity_relationships` | **0 แถว SS-scoped** | 271 edges ใน `content-plan/relationships.md` ยังไม่เคยโหลด |
| `seo_page_internal_links` | 0 (4,197 แถวที่มีเป็นของ Deezy) | DR-021 link plan ยังไม่เริ่ม (Phase F) |
| `seo_page_citations` | 0 (ทั้ง federation) | page↔citation junction ยังไม่เริ่ม (Phase F) |
| `seo_x_ads_keywords_contextual_master` | 525 seed (`notion_tier` มีครบ) | `search_intent` = 0; ไม่มี snapshot metrics → **รอ DFS full batch** |
| `seo_branches` | 2 สาขา org-linked | NAP/geo/phone/license = NULL → operator batch |
| `seo_programmatic_templates` | 0 | registry T1–T22 ยังไม่ลง (โค้ด template สร้างครบแล้วบน branch `content-templates`) |
| `seo_entity_graph` | orphan อ้างจาก 3 หน้า | `orthodontic-intervention` (3.5.4/.5/.7 ชื่อหลัง R17) ไม่มีใน entities.md |

---

## Wave 0 — Repo hygiene (prereq, ไม่แตะ DB) — Claude ทำได้เลย

1. **Merge `sitemap-review-r18-21` → `main`.** DB โหลดจากไฟล์ R26 ไปแล้ว แต่ main ค้างที่ R16-17 → เอกสารต้องตามให้ทัน (8 commits, fast-forward-able)
2. **Resolve orphan entity `orthodontic-intervention`:** ทางแนะนำ = เพิ่ม entity ใหม่ใน `entities.md` (Procedure, brand_scope universal — เป็นชื่อที่ตั้งใจ rename ตอน R17) + insert 1 แถว `seo_entity_graph` + 1 แถว `seo_entity_procedures` → orphan_entity 3→0
3. อัปเดต `LOAD-LOG.md` ทุกครั้งที่ wave เสร็จ (convention เดิม)

## Wave 1 — Relationships load (`11_relationships.sql`) — Claude gen ได้เลย, บล็อกไม่มี

- Parse `content-plan/relationships.md` (271 edges, DR-012 10-edge vocab) → `seo_entity_relationships`
- Mapping: `from_entity_fp`/`to_entity_fp` = slug ตรง ๆ · `edge_type` ตรง (DR-013 12-edge เป็น superset ของ DR-012) · Notes → `edge_note` · edges `evidenced_by` ผูก `edge_evidence_citation` ถ้าโยงถึง citation ใน pool ได้
- `brand_scope`: default `['*']` สำหรับ clinical edges ทั่วไป / `['smile-scape-clinic']` สำหรับ brand edges (ZBL, SMILE DNA, signature ฯลฯ) — ตามกติกา merge เดียวกับ entities
- Idempotent `ON CONFLICT (fingerprint)` — ระวังชน 133 แถว universal ที่แบรนด์อื่นลงไว้แล้ว (edge ซ้ำ = ปล่อยผ่าน, existing row wins)
- ⚠️ Trigger medical signoff (DR-013): edges การแพทย์อาจต้อง `medical_reviewer_fp` → ใส่ หมอแฮม (`dr-woraphat-jarangkul`) ตาม byline governance
- Validate: count / FK orphan ทั้งสองข้าง / brand isolation

## Wave 2 — Page enrichment จาก sitemap (`12_pages_enrich.sql`) — ✅ DONE 2026-07-09 (667/722)

Backfill คอลัมน์ที่ sitemap R26 **มีค่าจริง**:

- ✅ `node_tier` ← Tier (A–D) · `funnel_stage` ← Funnel (top/mid/bottom — **พบว่ามีค่าจริง ไม่ใช่ TBD**) · `sitemap_section` ← section 1–8 · `crawl_depth` + `parent_page_fp` ← derive จาก `sitemap_node_id` ใน SQL
- ⏭️ **ยังข้าม** `page_type` (คอลัมน์เป็น placeholder `A` 651/722), `slug`, `seo_title`, `target_keyword_fp` → Phase F
- ⚠️ อัปเดตได้แค่ **667/722** → เจอ divergence (ดู Wave 2b)

## Wave 2b — Page-node reconciliation (55 stale rows) — 🚧 รอ operator OK (มี DELETE)

DB page load (2026-06-07) รันจาก sitemap **ก่อน** review R18–R26 (branch เพิ่ง merge วันนี้) → **55 แถวใน DB เป็น node เก่า** (เช่น Orthognathic `3.5.8.x`→ตอนนี้ `3.10.8.x`, whitening `3.4.7.x`, scaling `3.6.1.x`, `3.9.7–13`, `6.2`, `6.2.5.10`) ที่ไม่มีใน sitemap R26 แล้ว, และ **55 node ใหม่ของ R26 ยังไม่มีแถว** (symmetric).
- ทำ: DELETE 55 แถวเก่า (SS ไม่มี dependent — 0 page_citations / 0 internal_links) → re-run `06_pages.sql` (idempotent, ใส่ 55 node ใหม่) → re-run `12_pages_enrich.sql` → 722/722
- เป็น DELETE จึงรอ operator เคาะ; content ย้ายจริง (ไม่ใช่แค่ renumber) → ห้าม rename ตรง ๆ เพราะ entity จะ mis-map

## Wave 3 — DFS full keyword batch → Stage 1 Gate ⭐ (ตัวปลดล็อกทุกอย่าง)

- ยิง DataForSEO เต็ม batch 525 seed keywords (TH/th): volume, CPC, competition, intent, SERP features → `seo_x_ads_keywords_monthly_market_snapshot` (เส้นทาง n8n WF เดิม) + `search_intent`/`qualitative_kd` ใน contextual master
- **Tier recompute** ตามผล DFS: promote/demote หน้า (เป้า Tier A 5-8% จากปัจจุบัน ~2.3%) → เขียนกลับทั้ง `sitemap.md` (dual-write) และ `node_tier` ใน DB
- เก็บ keyword↔page: เติม `target_keyword_fp` ให้หน้า Tier A/B ที่ keyword ชัด
- ✅ ผ่านแล้ว = **Stage 1 Gate ปิด** → เปิดทาง Phase F
- ต้องการ: operator go (ค่า DFS credits) — เครื่องมือพร้อม (dfs-mcp ต่ออยู่แล้ว)

## Wave 4 — Phase F content briefing backfill (ก้อนใหญ่สุด — หลัง Gate เท่านั้น)

ทำเป็น batch ราย section (1→8) เริ่มจาก Tier A/B (~70 หน้า) ก่อน:

1. `page_type` — ผูก template T1–T22 ต่อหน้า + ลง registry `seo_programmatic_templates` (T1–T22 spec v1.5 LOCKED)
2. `funnel_stage` — จาก intent DFS + patient-journey.md
3. `slug` + `seo_title` + `content_brief` — ราย section
4. **Internal links (DR-021)** → `seo_page_internal_links` — ใช้ internal-link engine ที่สร้างแล้วบน branch `content-templates` (4-state resolve + backfill) เป็นตัว generate plan rows
5. **page↔citations** → `seo_page_citations` (pool 90 แถวรออยู่แล้ว; enrich `citation_type` ที่เป็น `other` ไปด้วย)

## Wave 5 — Operator data batch (คู่ขนานได้ ไม่บล็อก wave อื่น)

- `seo_branches` ×2: address/geo/phone/email/hours/license/GBP Place ID — **รอ operator** (ค้างมาตั้งแต่ standing constraints)
- Operator TBDs จาก R26: Invisalign provider tier / โรงพยาบาล partner orthognathic / รุ่น 3D printer + resin / เครดเดนเชียลหมอแพรว (+ Person entity หมอแพรว ที่ยังไม่มีใน entities.md)
- product/device extensions ที่ defer ไว้ (enum mismatch) — แก้ mapping แล้วโหลด

## Wave 6 — Sync & media (ท้ายสุด)

- Notion sync (n8n) ตาราง N↔S ของ SS
- `seo_media_assets` + Cloudflare R2 URLs (R2 live แล้ว: `cdn.smilescapeclinic.com`)
- `seo_editorial_reviews` rows — เกิดตอน Stage 2 content production จริง

---

## ลำดับ dependency

```
Wave 0 (repo) ──┐
Wave 1 (edges) ─┼─ อิสระ ทำได้ทันที ─┐
Wave 2 (tiers) ─┘                    ├─→ Wave 4 (Phase F) → Wave 6
Wave 3 (DFS → Stage 1 Gate) ─────────┘
Wave 5 (operator) ── คู่ขนาน, บล็อกเฉพาะ branch NAP + TBD pages
```

## ⚠️ Security note (จาก advisor, ไม่ auto-fix)

RLS ปิดอยู่ 7 ตาราง: `seo_brand_centers` + `_archive_legacy_*` ×2 + `_archive_prevth_*` ×4 — anon key อ่าน/เขียนได้ทุกแถว. เป็นของ federation housekeeping ไม่ใช่ของ load เรา แต่ควรแจ้ง operator ตัดสินใจ (enable RLS เฉย ๆ จะ block ทุก access ถ้าไม่มี policy):

```sql
ALTER TABLE public.seo_brand_centers ENABLE ROW LEVEL SECURITY;
-- + archive tables อีก 6 ตาราง (หรือ drop ถ้าหมดประโยชน์)
```
