# Content-readiness sweep — 2026-09-17 (wave 16cm)

วัดจาก DB: 725 หน้า active · 2,827 planned internal links · คีย์ smile 1,789 (target 662 · semantic 953 · ว่าง 174)

## สะอาดแล้ว (0)
primary entity · seo_title/meta ครบไม่ซ้ำ · page_type/role/category/format/schema/topic_tier/sensitive_flag ครบ · slug ไม่ซ้ำ · entity summary ทุกตัวผ่าน audit · citation gates 0 · keyword collision blocking 0 · template registry 0 · anchor-text blocking 0 · ทุกหน้ามี inbound/outbound (breadcrumb+nav) · entity dedupe ปิด (D5)

## ข้อ 7 hygiene — ทำแล้ว
- seo_title >60: 3.12.5 (65→50) · 4.2.3 (62→59) · meta >160: 6.2.4.1 (189→150)
- target kw ไม่มี intent: `all on 5` → informational (ตามหน้า 3.3.8 brand-tier) · `ขูดหินปูน ประกันสังคม ไม่ต้องสํารองจ่าย` → transactional (เทียบ 3.14.1) + 3.4.1.7 `intent_source_tier=brand`
- primary_entity_fp ซ้ำใน related_entities_fps 17 หน้า → ถอด
- planned internal links แตะ 3 หน้าที่ยุบ 14 เส้น → ลบ (backup `_ss_d5links_bak_20260917`)

## ข้อ 4 — leaf 21 หน้าไม่มี target keyword (ขอตัดสิน)

| กลุ่ม | หน้า | เสนอ |
|---|---|---|
| A. brand/about | 2.1.2 Vision · 2.1.3 SMILE DNA · 2.1.4 Family Standard · 3.2.2 ทำไมต้อง SmileScape | **ไม่มี target ตั้งใจ** — ใส่ marker `[no-target: brand-page]` ใน reconciliation_notes ให้ audit ข้าม |
| B. evidence summary 6.4.x | 6.4.2 · 6.4.3 · 6.4.4 · 6.4.5 · 6.4.7 · 6.4.8 · 6.4.9 · 6.4.11 · 6.4.12 · 6.4.14 · 6.4.15 (11 หน้า สรุป paper) | **ไม่มี target ตั้งใจ** — หน้าหลักฐาน E-E-A-T ไม่มีคำค้นไทย · marker `[no-target: evidence-page]` |
| C. มีคำวัดแล้วว่างในคลัง | 3.2.12.7 อายุการใช้งานรากฟันเทียม → **"รากฟันเทียม อยู่ได้กี่ปี"** · 3.3.9 ดูแลหลัง All-on-X → **"all on 4 ดูแล"** · 3.2.12.6 Peri-Implantitis Prevention → **"รากฟันเทียม ติดเชื้อ"** | ตั้ง target (ทั้ง 3 คำ use_as ว่าง ยังไม่มีใครใช้ · intent informational) |
| D. pointer page | 3.11.13 ดมยาสลบทำฟันเด็ก "(→ link 3.12.6)" — คำ "ดมยาสลบทำฟันเด็ก" เป็น target ของ 3.12.6 อยู่แล้ว | **ยุบเข้า 3.12.6** (pattern เดียวกับ 3.2.10.9) |
| E. รอวัด | 4.6.2 Invisalign/SmartTrack (ไม่มีคำ smarttrack ในคลัง · "invisalign" เป็นของ 3.10.1.3) · 6.2.7.2 คลินิกคู่สัญญา (operator: วัดภายหลัง) | marker `[no-target: pending-measure]` |

## ข้อ 5 — keyword collisions K3w 12 คู่ (gate ตัดสินไม่ได้เพราะ volume ว่าง)

| คู่ | หน้า | เสนอ |
|---|---|---|
| **รากฟันเทียม ศรีนครินทร์ ⟷ คลินิกรากฟันเทียม ศรีนครินทร์** | 8.3 branch_landing ⟷ 8.3.2 local implant | **ชนจริง** (intent เดียวกัน) · โครงเดียวกันที่ 8.2 ⟷ 8.2.2 ก็ซ้ำ (รัตนาธิเบศร์/นนทบุรี แค่คนละคำ geo) → เสนอ branch landing ถือคำสาขา: **8.3 → "ทำฟัน ศรีนครินทร์"** · **8.2 → "ทำฟัน รัตนาธิเบศร์"** (ทั้งคู่วัดแล้ว ว่าง) · หน้า local implant ถือคำรากฟันเทียม+geo ต่อไป |
| **เหงือกร่น ⟷ เหงือกร่น แก้** | 5.11.1 condition ⟷ 3.7.4 treatment | gate เสนอย้าย "แก้" เป็น semantic (vol 0) — ไม่เอา (meaning-first) → **3.7.4 → "เหงือกร่น รักษา"** (วัดแล้ว ว่าง treatment intent ชัดกว่า) · "เหงือกร่น แก้" ลง semantic ของ 3.7.4 |
| อีก 10 คู่ | peri-implantitis/วินิจฉัย · ครอบฟัน/emax · ดมยาสลบทำฟัน/เด็ก · ดูแลฟันปลอม/ฟันปลอม · รากฟันเทียม/แพงไหม · รากฟันเทียม/รีวิว · หลายซี่/รีวิวหลายซี่ · รีวิว/รีวิวผู้สูงอายุ · เหงือกอักเสบ/กลิ่นปาก · โรคเหงือก/อาการ | **หัวคำ vs คำมุม (DR-048) — เก็บ** · gate จะ WARN ต่อ (ไม่ blocking) เพราะไม่มี allowlist — บันทึกคำตัดสินไว้ที่นี่ |

## คิวถัดไป (หลังตัดสิน 4/5)
6 citation gapfill รอบ 2 (knowledge 14 · condition_pillar 10 · service 12 · technology 9 · insurance 14 ที่ไม่มี T1–3) → 2 semantic kw 379 หน้า → 1 contextual link plan (613 หน้าไม่มี in-body inbound) → 3 writer packet (content_brief 725)

## ✅ ข้อ 4 + 5 ทำแล้ว (operator "โอเค" 2026-09-17)
- 4C: 3.2.12.7 → "รากฟันเทียม อยู่ได้กี่ปี" · 3.3.9 → "all on 4 ดูแล" · 3.2.12.6 → "รากฟันเทียม ติดเชื้อ" (use_as → target)
- 4A/B/E: marker `[no-target: brand-page]` ×4 · `[no-target: evidence-page]` ×11 · `[no-target: pending-measure]` ×2 ใน reconciliation_notes
- 4D: **3.11.13 ยุบเข้า 3.12.6** — Merged · noindex · redirect `/pediatric-general-anesthesia/` · citation 4 ใบย้าย (3 ซ้ำ) · links 4 เส้นลบ (backup `_ss_3_11_13_links_bak_20260917`) → active 724 หน้า
- 5: 8.3 → "ทำฟัน ศรีนครินทร์" · 8.2 → "ทำฟัน รัตนาธิเบศร์" (คำ "รากฟันเทียม <สาขา>" ลงเป็น semantic ของ 8.3.2/8.2.2) · 3.7.4 → "เหงือกร่น รักษา" ("เหงือกร่น แก้" ลง semantic)
- gate หลังทำ: K1/K2 0 · K3w WARN 10 (หัวคำ vs คำมุม ตั้งใจเก็บ) · citation blocking 0

## ข้อ 6 — citation: วัดตามกฎ gate จริง (MIN_PER_LAYER: §5/§6 = 3 · §3/§4 = 2 · §7 = 1 · Live block / Planned warn)
- ก่อน: G6w ต่ำกว่าขั้นต่ำ 274 หน้า · G7w ไม่มี T1–3 76
- **CITATION EXEMPTION** ใส่แล้ว 70 หน้า: pricing_page 16 · insurance_page 24 (precedent BROADCAST 2026-08-24 SSO FAQ) · about 25 · เรื่องราวคนไข้ 7.6.x 5 — ถอน marker ทันทีถ้าเนื้อหาใส่สถิติ
- หลัง: **264 หน้า ขาด 338 เส้น · 49 หน้าไม่มี T1–3** (knowledge 92 · service 71 · condition 50 · technology 26 · procedure 12 · evidence_case 3)
- **257/264 เติมได้จาก pool เดิม** (citation T1–3 ที่ผูกอยู่กับหน้า entity เดียวกัน ยังไม่ผูกหน้านี้) · pool ว่างแค่ 6 หน้า → รอบนี้เป็น reuse pass ไม่ใช่ค้น PubMed ใหม่

## ข้อ 1 — contextual link plan (wave 16co) ✅
วัดตาม protocol (`required_min_outbound` นับ contextual · `required_min_inbound` นับทุก type): ขาด outbound 284 หน้า · ต่ำกว่า inbound 51 หน้า — ไม่ใช่ 613 ตามที่ประเมินรอบแรก (contextual-inbound ทุกหน้าไม่ใช่ข้อกำหนด)
- planner `content-plan/etl/wave16co-links/gen.py` (deterministic ไม่ใช้ agent): เป้าหมาย = หน้าที่ primary entity อยู่ใน related_entities ของหน้าต้นทาง (+3) · entity เดียวกันคนละ category (+2) · edge ใน seo_entity_relationships (+2) · sibling (+1) · pillar/hub (+1) · ปลายทางต่ำกว่า inbound ที่ประกาศ (+2) · ปลายทางรับ contextual ≥15 แล้ว (−1) · ไม่ซ้ำลิงก์เดิม ไม่ชี้ parent (breadcrumb มีแล้ว)
- anchor = คำเป้าหมายของหน้าปลายทาง (exact) หรือ alias ไทย/ชื่อ entity (topical) · หมุนกันซ้ำต่อปลายทาง · ห้ามเท่าชื่อหน้า (A3) · ≤60
- ผล: **+328 เส้น** (entity-bridge 326) + 2 เส้นมือ (2.2.2→2.2.3 หมอแพรว · 3.10.1.3→4.6.0.6) → ต่ำกว่า outbound **0** · ต่ำกว่า inbound **0** · contextual 554→884 · ปลายทาง 125 หน้า (max 15/หน้า) · anchor gate blocking 0 (A6 monotony WARN 50→35) · backup `_ss_links_bak_20260917`
- surrounding_text_snippet ยังว่างทั้ง 3,139 เส้น (A7 WARN) — เป็นงานของ writer ตอนเขียน ไม่ใช่ของแผน

## ข้อ 6 — run 1 (wave 16cn)
- workflow `citation-reuse-gapfill` 329 agents: haiku ที่โหลด index คืน JSON ตัดท้าย (182/264) → **บทเรียน: ส่ง list ผ่าน `args` ตรง ๆ ห้ามให้ agent อ่านไฟล์แล้วคืน JSON ยาว**
- 182 หน้า: เขียน **168 เส้น** (Opus fix 157 · accept 11 · reject 3) · 46 หน้า shortfall 60 (pool ไม่มี citation ตรงประเด็น เช่น torus removal · loupes · piezo · habit appliance — รายการ `citation-gapfill2-shortfall-run1-2026-09-17.json` → คิวค้น PubMed รอบถัดไป)
- run 2 (90 หน้าที่เหลือ) กำลังรัน `wf_e927a3c2-87c`
- สคริปต์ `content-plan/etl/wave16cn-gapfill/{prep,apply}.py` · backup `_ss_gapfill2_bak_20260917_pc`

## entity ผิดหน้า — พบจาก PubMed round (wave 16cn)
รอบค้น PubMed ให้ agent ตั้งธง `entity_mismatch` → 15/59 หน้า primary_entity ไม่ตรงเนื้อหา (นี่คือเหตุผลที่ pool ไม่มีของตรง) · ขยายดูทั้งแบรนด์: **`dental-implant` ถูกใช้เป็น entity ตั้งต้นแบบเหมา** บนหน้า FAQ/hub/glossary/ค่าใช้จ่าย/กลัวหมอฟัน ที่ไม่เกี่ยวกับรากเทียม

### retag แล้ว 34 หน้า (backup `_ss_retag_bak_20260917`) — keyword เป้าหมายของหน้าย้าย entity ตาม
| หน้า | เดิม → ใหม่ |
|---|---|
| 4.4.3 กล้องขยาย | surgical-guide → endodontic-microscope |
| 5.11.2 เหงือกดำ | periodontitis → dark-gums |
| 5.12 hub เด็ก | family-standard → pediatric-dentistry |
| 5.13 hub ค่าใช้จ่าย · 5.13.1 · 6.5.4 | dental-implant → fee-transparency (5.13 เก็บ dental-implant เป็น related) |
| 5.14.3 pulpitis | dental-caries → pulpitis |
| 5.16.5 ฟันสึกจากกรด | tooth-fracture → tooth-erosion |
| 5.19.7 รีเทนเนอร์ | clear-aligner → orthodontic-retainer |
| 5.5.2 ฟันห่าง | digital-smile-design → diastema |
| 6.2.4 hub ความรู้ · 6.2.4.3 · 6.1 | dental-implant → oral-hygiene |
| 6.2.4.4 อาหาร | dental-implant → nutrition-oral |
| 6.5.4.1 · 6.5.4.2 · 5.13.3 ผ่อน/ชำระ | dental-implant → dental-installment |
| 6.5 · 6.5.1 · 6.5.2 · 6.5.3 · 6.5.5 · 6.5.5.1 · 6.5.5.2 FAQ hubs | dental-implant → smilescape-dental-clinic |
| 6.5.3.1 FAQ ผู้สูงอายุ | dental-implant → geriatric-dentistry |
| 6.5.3.4 FAQ โรคประจำตัว | dental-implant → medical-compromised-dentistry |
| 5.4 · 5.4.3 กลัวทำฟัน | dental-implant → dental-phobia |
| 6.6 case hub · 7.1 ผลงานจริง | dental-implant → before-after-smile |
| 6.4 · 6.4.13 evidence hub | dental-implant → evidence-based-dentistry |
| 6.2.4.11 ตรวจฟันประจำปี | dental-implant → dental-checkup |
| 6.2.1.26 เส้นประสาทเสียหลังฝังราก | dental-implant → orofacial-paresthesia (เก็บ dental-implant เป็น related) |

### ENTITY GAP 11 หน้า — กราฟไม่มี entity ที่ถูก (ติดธง `⚠️ ENTITY GAP` ใน notes) → **เสนอสร้าง 8 entity** (ขอ operator)
| entity ใหม่ (fp) | type | ใช้กับหน้า |
|---|---|---|
| `piezosurgery` | device | 4.4.1 |
| `lactation-dental-care` | concept | 5.20.5 · 5.20.6 |
| `osteoradionecrosis` | condition | 5.8.10 |
| `dental-glossary` | concept | 6.3 · 6.3.2 |
| `dental-tax-deduction-th` | concept | 5.13.7 · 6.5.4.5 |
| `post-treatment-care` | concept | 5.22 · 6.5.2.3 |
| `common-dental-problems` | concept | 5.6 (hub) |
- ยังเหลือ `dental-implant` เป็น primary 81 หน้า — ทั้งหมดอยู่ section รากเทียม (3.2 · 3.3 · 5.7 · 6.2.1 · 7.2) ถูกต้อง
- บทเรียน: การ audit "entity ตรงหน้าไหม" ไม่เคยทำเป็นระบบ — ทำได้ถูกสุดตอน agent อ่านหน้าอยู่แล้ว (ให้ทุก workflow ต่อหน้าคืนธง entity_mismatch)

## ข้อ 6 — ปิด (wave 16cn รอบ 3: PubMed)
- 59 หน้าที่ pool ไม่มีของตรง → workflow `citation-pubmed-gapfill` (Sonnet ค้น PubMed MCP + ร่าง key_findings/claim จากบทคัดย่อ → Opus ดึงบทคัดย่อเองซ้ำ ตรวจชนิด/tier/claim) · ชน session limit กลางทาง 33 verify → resume จาก cache สำเร็จ
- ผล: **citation ใหม่ 48 ใบ** (SR 42 · MA 11 · RCT 7 · guideline 1 — นับรวม 61 เส้น) · Opus แก้ 53 / รับ 8 / ทิ้ง 1 · shortfall 15 เส้นบน 9 หน้า (หา T1–3 ไม่ได้จริง: torus 3.8.6/3.8.6.2 · 4.8 · 5.19.9 · 5.21.6 · 6.2.1.28–30 · 6.5.2.3 — `citation-gapfill2-shortfall-pubmed-2026-09-17.json`)
- study_type ที่ agent เขียนเป็นคำบรรยาย → normalise เป็นคำศัพท์ (G14u 112→64) · authority weight คำนวณแล้ว 1,027 ใบ
- **รวม 3 รอบ: +334 เส้น (reuse 273 · PubMed 61) · citation ใหม่ 48** · gate: ต่ำกว่าขั้นต่ำ 274 → **7** · ไม่มี T1–3 76 → **5** · blocking 0
- `flag_review` citation-gap/evidence-tier-gap คำนวณใหม่จากสภาพจริง: 154/84 ธง → **7/5** (185 หน้าแก้ · backup `_ss_flagreview_bak_20260917`)

## สรุปสภาพปิดวัน 2026-09-17 (724 หน้า active)
| gate | ผล |
|---|---|
| keyword collisions | blocking 0 · K3w WARN 10 (หัวคำ vs คำมุม ตั้งใจเก็บ) |
| citation QA | blocking 0 · below-min 7 · no-T1–3 5 · stale(G8) 213 (คิวแยก) |
| anchor text | blocking 0 · monotony WARN 35 |
| template registry | 0 |
| internal links | ต่ำกว่า required in/out **0** · contextual 884 |
| entity | dedupe ปิด · retag 34 · ENTITY GAP 11 หน้า รอ entity ใหม่ 8 ตัว |

## ยังค้าง (ตัดสินใจ/คิวแยก)
1. **entity ใหม่ 8 ตัว** (ตารางบน) — รอ operator
2. **SERP snapshot = 0 แถว** สำหรับ smile-scape → §3.3 competitor/PAA เดินไม่ได้ · ต้องดึง DFS (มีค่าใช้จ่าย)
3. writer packet (E) — พักไว้ตามคำสั่ง
4. G8 stale 213 ใบ (T1 >5 ปี / T2,T5 >7 ปี) — refresh รอบถัดไป
5. 9 หน้า shortfall T1–3 — ถ้าหาไม่ได้จริง ใส่ CITATION EXEMPTION เฉพาะที่ไม่มีข้ออ้าง หรือลด claim

## ✅ entity ใหม่ 7 ตัวสร้างแล้ว (wave 16cp · operator "1 ต่อเลย")
`piezosurgery` (device · dental-technology · ICD –) · `lactation-dental-care` (concept · demographic) · `osteoradionecrosis` (condition · demographic · ICD-10 M27.2) · `dental-glossary` (concept · cross-cutting · DefinedTermSet) · `dental-tax-deduction-th` (concept · insurance-access — summary ระบุชัดว่าค่ารักษาที่จ่ายเองโดยทั่วไป**ไม่**อยู่ในรายการลดหย่อน ต่างจากเบี้ยประกัน) · `post-treatment-care` (concept · cross-cutting) · `common-dental-problems` (concept · preventive)
- lifecycle `emerging` · load_source `wave16cp` · related_entities ตั้งต้น · 11 หน้า repoint แล้ว (ENTITY GAP ปิดครบ) · keyword เป้าหมายย้าย entity ตาม · embedding 7 ตัวสด · similarity view: 0 คู่ชนกับ entity ใหม่
- ⚠️ `embed-entities.mjs` (spec) ข้าม `merged` แต่**ไม่ข้าม `dropped`** → re-embed entity ต้องห้าม 2 ตัวกลับมา ลบทิ้งแล้ว — เจ้าของสคริปต์ควรเพิ่ม `dropped` ใน skip list
- gates หลังสร้าง: keyword collisions blocking 0 · citation blocking 0

## operator 2026-09-17 (หลัง entity ใหม่): เรื่องลดหย่อนภาษีไม่ใช่มุมของแบรนด์ — มุมเดียวคือ "ประกันสังคมไม่ต้องสำรองจ่าย"
- **ยุบ 5.13.7** (ค่าทำฟันลดหย่อนภาษีได้ไหม → `/dental-costs-and-coverage/`) และ **6.5.4.5** (FAQ ลดหย่อนภาษี → `/faq-cost-insurance/`) — convention เดิม · citation 4+4 ตัด · links 9 ลบ · keyword 2 คำ topic ปิด · backup `_ss_taxpages_bak_20260917_*`
- entity `dental-tax-deduction-th` → `dropped` (สร้างแล้วยกเลิกในวันเดียว · row เก็บไว้ตาม DR-046) · embedding ลบ
- active 722 หน้า · required inbound/outbound ยัง 0 ค้าง · gates 0 blocking
