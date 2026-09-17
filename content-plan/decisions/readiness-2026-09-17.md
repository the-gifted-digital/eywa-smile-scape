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
