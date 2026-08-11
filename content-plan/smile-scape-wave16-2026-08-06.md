# Smile Scape — Wave 16: dedupe + backbone calibration

> **วันที่:** 2026-08-06 · **ต่อจาก:** `smile-scape-baseline-audit-2026-08-06.md`
> **กติกา:** DR-042 · DR-046 · DR-047 · DR-048 · `keyword-assignment-sop.md` v1.3 · EYWA Bible §4.2
> **backup:** `seo_topic_cluster_master_ssbak_20260806` · `seo_entity_graph_ssbak_20260806` · `seo_website_page_master_ssbak_20260806` · `seo_entity_relationships_ssbak_20260806` · `seo_x_ads_keywords_contextual_master_ssbak_20260806` · `seo_page_internal_links_ssbak_20260806`
> **SQL:** `deployment/supabase-load/27_ss_entity_dedupe.sql` · `28_ss_cluster_dedupe.sql`

---

# Phase 1 · dedupe `brand_scope = '*'`

## 1.1 entity — ยุบ 6 แถว

| ยุบ | canonical | เหตุผล | ของที่ยกตามไป |
|---|---|---|---|
| `single-tooth-implant` (ss 3 · kw 8) | `single-implant` **deezy** | ชื่อเหมือน 100% | aliases |
| `cbct-3d-scan` (ss 7 · kw 5 · device) | `cbct-scan` **deezy** (procedure) | token สลับ · operator เลือกชนิด procedure | aliases + `ai_entity_summary` ที่ยาวกว่า + **แถว `seo_entity_devices` ทั้งแถว** (repoint ไม่ลบ) + `contraindications` เข้าแถว procedures ที่ว่างอยู่ |
| `root-canal-retreatment` (ss 1) | `rct-retreatment` **deezy** | ต่างแค่ขีดกลาง | aliases + summary |
| `guided-surgery` (ss 1) | `guided-implant` **deezy** | ชื่อเหมือน 100% | aliases |
| `tooth-loss` (ss 6 · **114 ref ใน related_entities_fps**) | `missing-tooth` **deezy** | K08.409 เดียวกัน + aliases อ้างชื่อกันไปมา = defect ตาม DR-042 | aliases + summary ที่ยาวกว่า |
| `trioclear-aligner` (ss 4 · kw 11) | `trioclear` | ⚠️ **กลับทิศจากร่างแรก** | aliases |

### 🔴 กลับคำ 1 จุด — `trioclear`

ร่างแรกในเอกสาร audit เขียนว่าให้ `trioclear-aligner` (ฝั่ง smile-scape) ชนะเพราะมีหน้า/คีย์มากกว่า **ผิด** — ตรวจของจริงแล้ว

- `trioclear-aligner` = `brand_scope={smile-scape-clinic}` (private) · `ai_entity_summary` ว่าง · แถว `seo_entity_devices` ว่างทุกช่อง
- `trioclear` = `brand_scope={*}` (ใช้ร่วม) · summary 634 ตัวอักษร · devices row เต็ม (ผู้ผลิต Modern Dental Group · CE mark · indications/contraindications ครบ)

แถวที่รอดต้องเป็นแถวที่ใช้ร่วมได้ ไม่งั้นการยุบจะดันแนวคิดเดียวเข้าไปอยู่ในกล่องส่วนตัวของแบรนด์เดียว — นี่คือรูปแบบเดียวกับที่ DR-046 🔴 เตือนว่า *"ตรวจข้อมูลบนแถวที่กำลังจะแพ้เสมอ"*

### สิ่งที่จงใจ **ไม่** ยก

`root-canal-retreatment` ถือ `icd_10_code = K04.0` (acute pulpitis) ทั้งที่เป็นแถว procedure — เป็นการใส่โค้ดโรคผิดที่ ไม่ใช่ข้อมูลที่ควรยกไปให้ canonical · เขียนกฎไว้ใน SQL: ห้ามยก ICD ขึ้นแถวที่ `entity_type ∈ (procedure, treatment)`

### QA เฉพาะจุด

| เช็ค | ผล |
|---|--:|
| `page_master.primary_entity_fp` ค้างที่ loser | **0** |
| `page_master.related_entities_fps[]` ค้าง | **0** (จาก 169 ช่อง) |
| `keywords.primary_entity_fp` ค้าง | **0** (จาก 24) |
| `entity_graph.parent_entity_fp` / `related_entities_fps` ค้าง | **0** |
| `seo_entity_relationships` ค้าง | **0** (ลบเส้นที่จะกลายเป็น self-edge/ซ้ำก่อน repoint ตามบทเรียน deezy) |
| ext table ค้าง | **0** |

## 1.2 cluster — ยุบ 8 แถว + เก็บ 1 เป็น child (operator)

ทุกแถวที่ยุบ `load_from = NULL` · ทุก canonical `load_from='deezy-dental'` → ไม่มีคู่ไหนกำกวมตาม DR-046 ข้อ 2

| ยุบ | หน้า SS | พ่วง | canonical |
|---|--:|--:|---|
| `dental-implant-core` | 126 | — | `implant-dentistry` |
| `clear-aligner-orthodontics` | 66 | vth 1 | `orthodontics` |
| `general-restorative` | 55 | vth 3 | `restorative-dentistry` |
| `smile-design-cosmetic` | 43 | — | `cosmetic-dentistry` |
| `periodontics-perio-disease` | 39 | vth 1 | `periodontics-gum` |
| `digital-technology-diagnostics` | 28 | vth 1 | `dental-technology` |
| `insurance-coverage-th` | 28 | — | `insurance-access` |
| `endodontics-specialist` | 11 | — | `endodontics` |

**operator ตัดสิน 2026-08-06 — โครงสองชั้นเหงือก:** เก็บ `gum-soft-tissue` (26 หน้า) ไว้เป็น **child ของ `periodontics-gum`** · ยุบเฉพาะ `periodontics-perio-disease` → ชื่อโรคเหลือชื่อเดียวทั้งตาราง ขณะที่แง่มุมศัลยกรรมเนื้อเยื่ออ่อนยังมีที่อยู่ ตรงกับ pattern `teeth-whitening ⊂ cosmetic-dentistry` ที่ deezy ใช้อยู่แล้ว

### สิ่งที่ต้องทำ **ก่อน** ยุบ (ไม่งั้นลูกลอย)

smile-scape ไม่ได้สร้างแค่แถวคู่ขนาน แต่สร้าง **ต้นไม้คู่ขนาน** — `all-on-x-full-arch` และ `implant-systems-brands` แขวนอยู่ใต้ `dental-implant-core` ที่กำลังจะถูกยุบ · ย้าย parent ก่อนเสมอ

facet ที่ตอนนี้แขวนใต้ deezy root แล้ว: `all-on-x-full-arch` · `implant-systems-brands` · `bone-regeneration-gbr` · `implant-materials` · `patient-conditions-tooth-loss` · `patient-conditions-bone` → `implant-dentistry` · `gum-soft-tissue` → `periodontics-gum` · `dental-anatomy` → `cross-cutting`

## 1.3 ปิดหนี้ที่ค้างจากรอบก่อน (แถว `{*}` กระทบทุกแบรนด์)

`periodontal-gum` ถูก merge ไปตั้งแต่ 2026-08-03 แต่ยังมี **10 entity ค้างชี้อยู่** (VTH audit ข้อ A3 รายงานไว้แล้วแต่ไม่ได้ทำ) → ย้ายเข้า `periodontics-gum` ครบ

## 1.4 entity ที่วางผิดหมวด (แก้ที่ entity = ทุกแบรนด์ได้ประโยชน์)

- `cbct-scan` : `preventive-general` → `dental-technology`
- `trioclear` : `cross-cutting` → `orthodontics`

## 1.5 cluster mismatch — 370 → 0 (ที่อธิบายไม่ได้)

| ขั้น | mismatch | มีคำอธิบาย |
|---|--:|--:|
| ตั้งต้น | 370 | 0 |
| หลังยุบ cluster | 177 | 0 |
| หลัง retag entity 2 ตัว | 166 | 0 |
| **retag หน้า 86 หน้า** ที่ cluster ของหน้าไม่ใช่ทั้ง parent และไม่ใช่บริบทที่ตั้งใจ → ยึด cluster ของ entity (DR-047 precedence) | 80 | 0 |
| **เขียน `reconciliation_notes` ให้ 80 หน้าที่ต่างโดยเจตนา** | 80 | **80** |
| **ผลสุดท้าย: mismatch ที่ไม่มีคำอธิบาย** | — | **0** ✅ |

**สิ่งที่เจอระหว่างทาง:** `patient-conditions-bone` ("Patient Conditions — Bone Deficiency") ถูกใช้เป็น **ถังรวมของ §5 ทั้งหมด** — 34 หน้าในนั้นเป็นเรื่องกลิ่นปาก · ปากแห้ง · ฟันผุ · นอนกัดฟัน ซึ่งไม่เกี่ยวกับกระดูกเลย · เป็นรูปแบบเดียวกับที่ deezy-clean-plan §2 เตือนไว้ (สร้าง/ใช้ facet ผิดชนิด) → retag ตาม entity

---

# Phase 2 · Backbone calibration (Bible §4.2)

## 2.1 ผลก่อน/หลัง

| # | ทดสอบ | ก่อน | หลัง |
|---|---|--:|--:|
| T1 | §3 ถือ entity ชนิด condition | 19 | **8** (ทั้งหมดติดคำอธิบายแล้ว · 2 หน้าติดธงให้ operator ตัดสินย้ายหมวด) |
| T3 | หน้า §5 ที่ไม่มีลิงก์ออกไป §3 | 174 / 193 | **0** |
| T4 | schema shield | 0 | **0** (สะอาดตั้งแต่ต้น) |
| T5 | §3 **hub** ที่ไม่เคยรับคนจาก §5 | 13 / 39 | **0** |
| T6 | หน้านอก §3 ที่ไม่มีเส้นทางกลับ §3 | 456 / 480 | **0** |

ลิงก์ของ smile-scape: 2,306 → **2,775** (contextual 66 → 535)

> ก่อนรอบนี้ ลิงก์ 2,306 เส้นเป็น breadcrumb 1,580 + navigational 660 + **contextual แค่ 66** — โครง 8 section วางถูกแต่ **ไม่มีเส้นเนื้อหาที่พาคนกลับเข้า §3 เลย** ซึ่งเป็นเหตุผลเดียวที่ §4–§9 มีอยู่ตามหลักที่ operator ล็อกไว้ในรอบ deezy

**ที่มาของเส้นที่สร้าง (derive ไม่เดา):**
1. หน้า §3 ที่ถือ entity เดียวกับหน้าต้นทาง (เลือกหน้าที่ตื้นที่สุด) — `route-to-service (entity-match)`
2. §3 hub ของคลัสเตอร์เดียวกัน — `route-to-service (cluster-hub)`
3. hub ทันตกรรมทั่วไป `3.4` สำหรับหน้าที่ไม่เข้าเงื่อนไขบน — `route-to-service (general-hub)`
4. ย้อนกลับ: §3 hub ที่ยังไม่มีคนส่งมา ได้เส้นจากหน้า §5 ที่ entity/cluster ตรงที่สุด — `concern-to-service bridge`

## 2.2 entity ฝั่งบริการที่กราฟยังไม่มี — สร้าง `periodontal-treatment`

หน้า §3 หมวดปริทันต์ 4 หน้า (`3.7` hub · `3.7.1` · `3.7.2` · `3.7.6` ราคา) ถือ `periodontitis` ซึ่งเป็น **ชื่อโรค** เพราะกราฟไม่มี entity ฝั่งบริการระดับ "การรักษาโรคปริทันต์" — เป็นหนี้เดียวกับที่ deezy ทิ้งไว้ที่ **B3** (*"ต้องสร้าง entity บริการฝั่งปริทันต์ที่กราฟยังไม่มี"*)

ผ่าน reuse-first check (DR-042) แล้ว: กราฟมี condition (`periodontitis`/`gingivitis`), procedure ย่อย (`deep-scaling`/`periodontal-surgery`/`gum-graft`/`laser-perio`) และ specialty (`periodontics`/`periodontist`) แต่ **ไม่มี treatment ระดับหมวด**

→ สร้าง `periodontal-treatment` (treatment · MedicalTherapy · `periodontics-gum` · `brand_scope={*}`) + ผูก edge `treats`→periodontitis/gingivitis และ `part_of`→deep-scaling/periodontal-surgery ทันที (ห้ามปล่อยลอย)

**deezy ใช้ต่อได้ทันที** — หน้า `deezy-3.4` (hub ปริทันต์) มีอาการเดียวกัน

## 2.3 หน้า §3 ที่ผูก entity ใหม่ 11 หน้า

`3.7` · `3.7.1` · `3.7.2` · `3.7.6` → `periodontal-treatment` · `3.7.3` → `periodontal-surgery` · `3.7.4` + `3.2.9.7.3` → `gum-graft` · `3.4.1.3` → `deep-scaling` · `3.2.10.9` → `peri-implantitis-treatment` · `3.2.9.5.1` → `bone-grafting` · `3.12.4` → `ga-dentistry`

entity เดิมทุกตัว **ย้ายไปอยู่ `related_entities_fps`** ไม่ทิ้ง · ทุกหน้าติดธง `entity-retagged` + เหตุผลใน `reconciliation_notes`

## 2.4 8 หน้าที่ §3 ยังถือ condition โดยรู้ตัว

ยอมรับเป็น non-defect 6 หน้า (implant candidacy 3 · การป้องกัน/วินิจฉัย peri-implantitis 2 · pregnancy gingivitis ที่ประกาศให้ยืนเดี่ยวไว้แล้ว 1)

🔴 **ติดธง `section-move-candidate` 2 หน้า ให้ operator ตัดสิน:** `3.6.7` ฟันร้าว/รากฟันแตก · `3.13.1.4` ปากแห้ง — ชื่อหน้าเป็นอาการล้วน ควรพิจารณาย้ายไป §5

---

# 🔴 ค้างการตัดสินของ operator — หมวดราคา/สิทธิ์

ตรวจแล้ว smile-scape มีหน้าราคา **26 หน้า** และหน้าสิทธิ์/เบิกจ่าย **29 หน้า** กระจายอยู่ 4 หมวด

| หมวด | ราคา | สิทธิ์ |
|---|--:|--:|
| §3 Services | 9 | 6 |
| §4 Technology | 1 | 0 |
| **§5 Concern** | **8** | **15** |
| §6 Knowledge | 8 | 6 |
| §8 Contact | 0 | 2 |

**23 หน้าใน §5 เป็นราคา/สิทธิ์** ซึ่งผิดสัญญา §5 (มุมความกังวลของคนไข้) แบบเดียวกับ `deezy-5.4.x` ที่เพิ่งย้ายออกไปเมื่อ 2026-08-06

แต่ **Wave 15 (2026-07-31) operator อนุมัติไว้แล้ว** ว่า smile-scape ใช้โมเดลของตัวเอง: cost hub อยู่ที่ `5.13` + หน้าราคารายบริการอยู่ใน §3 (*"ไม่เปิด §8.10 hub ใหม่ เพราะ 5.13 cost-hub + 13 หน้าราคารายบริการมีอยู่แล้วตั้งแต่ R26"*)

## ✅ operator ตัดสิน 2026-08-06 + 🔴 ผมนับผิดเอง

operator เลือก: *เก็บ 5.13 cost-hub ตาม Wave 15 · ย้ายหน้าที่กระจายเข้ามารวมใต้ hub*

**ตรวจของจริงแล้วพบว่าคำถามของผมตั้งอยู่บนตัวเลขที่ผิด** — เลข "23 หน้าใน §5" มาจาก regex กว้างที่นับ subtree ของ `5.13` เองเป็น "หน้ากระจาย" ของจริงคือ

- **18 หน้าอยู่ใต้ `5.13` เรียบร้อยแล้ว** (5.13 hub · 5.13.1 · 5.13.2 sub-hub + 5.13.2.1–2.9 · 5.13.3–5.13.7)
- เหลือนอก hub เพียง **2 หน้า** คือ `5.7.1` "รากฟันเทียมราคาแพง — คุ้มค่าไหม" และ `5.21.7` "ราคาคุ้มค่า vs ราคาถูกที่สุด" — ทั้งคู่เป็น **ความกังวลเรื่องความคุ้มค่า (มุมคนไข้)** ไม่ใช่ตารางราคา จึงอยู่ §5 ถูกแล้ว

**⇒ ไม่มีหน้าไหนต้องย้าย** เขียน `reconciliation_notes` แทน 20 หน้า: 18 หน้าประกาศว่าเป็นข้อยกเว้น §5 ที่ operator อนุมัติ (พร้อมวิธีเลื่อนขึ้น §8 ในอนาคตแบบทั้ง subtree ตาม §13.3) · 2 หน้าประกาศว่าเป็น concern-side โดยเจตนา

---

# Phase 3 · ตารางแวดล้อม + เช็กลิสต์ 6 จุด

| เช็ค | ผล |
|---|--:|
| orphan `seo_page_citations` (ทุกแบรนด์) | **0** |
| orphan `seo_editorial_reviews` (ทุกแบรนด์) | **0** |
| orphan `seo_page_internal_links` ทั้งสองทิศ | **0** |
| `page_fingerprint` ค้าง `zzz-` | **0** |
| `page_fingerprint` ≠ `smilescape-`‖`sitemap_node_id` | **0** |
| `page_fingerprint` ซ้ำ | **0** |
| หน้า orphan (ไม่มี inbound) | **0** |

> รอบนี้ **ไม่ได้ renumber หน้าใดเลย** จึงไม่ได้แตะ 6 จุดของ §13.3 · แต่เขียนไว้ใน `reconciliation_notes` ของ subtree `5.13` แล้วว่าถ้าย้ายในอนาคตต้องย้ายทั้ง subtree และอัปเดตครบ 6 จุด (รวม `seo_page_citations.page_fp` และ `seo_editorial_reviews.page_fp` ที่รอบ deezy ทำหลุด)

---

# Phase 4 · Citation — 0 → ครบ

| | ก่อน | หลัง |
|---|--:|--:|
| `seo_page_citations` ที่ผูกกับหน้า smile-scape | **0** | **2,159** |
| หน้าเชิงเนื้อหาที่ไม่มี citation | 677 | **0** |
| หน้าเชิงเนื้อหาที่ไม่มี Tier 1–3 | 677 | **0** |
| citation ที่ถูกผูกแล้วไม่มี `key_findings` | — | **0** |
| citation ที่ถูกใช้จริงจากพูล | 0 | **257 / 321** |
| หน้าโครงสร้าง (home/about/สาขา/หมอ/contact/local) ที่ถูกผูก citation | — | **0** (ไม่ต้องมีโดยธรรมชาติ) |

**วิธีผูก (ตาม DR-044 ข้อ 6 — anchor + round-robin ไม่ใช่ top-N ต่อ cluster):**
สร้าง topic regex ต่อคลัสเตอร์ (24 คลัสเตอร์) จับกับ `title + abstract + key_findings` ของพูล → เรียงผู้สมัครตาม tier → แจกแบบ round-robin ด้วย offset ของหน้าในคลัสเตอร์ (3 ตัว/หน้า) แล้วเติมรอบสองเฉพาะหน้าที่ยังไม่ได้ Tier 1–3
คลัสเตอร์ facet ที่พูลบาง (`all-on-x-full-arch` · `bone-regeneration-gbr` · `patient-conditions-*` · `dental-anatomy` ฯลฯ) ขยาย regex ให้กินคำของคลัสเตอร์แม่ด้วย ไม่งั้นจะได้ผู้สมัคร 3–5 ตัวแล้วซ้ำกันทั้งหมวด · citation ที่ถูกใช้มากที่สุดถูกใช้ 26 หน้า (ไม่ใช่ทั้ง cluster ได้ชุดเดียวกัน)

**🔴 ข้อจำกัดที่เขียนไว้ในทุกแถว:** นี่คือการผูก **ระดับหัวข้อ ไม่ใช่ระดับข้ออ้าง** — `supports_claim` ของทุกแถวระบุไว้ตรง ๆ ว่าคนเขียนต้อง map ข้ออ้างจริงตอนเขียนหน้า (PAMREL) และถอดตัวที่ไม่ตรงออก · **จงใจไม่ใช้ข้อความ placeholder แบบเดิม** (*"Backbone evidence assigned from the verified shared citation pool by topic cluster"*) เพราะข้อความนั้นคือสิ่งที่รอบ deezy ต้องตามไปปลดระวางทีหลัง

**แถวที่กันไว้ไม่ให้ผูก:** 13 แถว `verification_status='unverified'` (first-party ของ smile-scape) และ 2 แถว `broken_link` — ตาม DR-044 ข้อ 1 ห้ามรับเข้าใช้ก่อนผ่าน locator round-trip

## 4.1 `key_findings` ที่ต้องเขียนใหม่ 13 ตัว

ทั้ง 13 ตัวมี PMID · **ดึงบทคัดย่อจริงจาก PubMed ทุกตัว ไม่เขียนจากความจำ** · ฟอร์แมตเดียวกับ VTH/deezy: บรรทัดข้อค้นพบ แล้วปิดท้ายด้วย ⚠️ (ขอบเขต/ข้อจำกัด) และ 🔴 (สิ่งที่ห้ามเคลม) พร้อมบรรทัดอ้าง PubMed PMID + DOI

ตัวอย่างข้อ 🔴 ที่เขียนกันการเคลมเกินจริงไว้:

| งาน | 🔴 ที่บันทึกไว้ |
|---|---|
| Papageorgiou 2014 SR+MA แบร็กเก็ต (PMID 24062378) | ห้ามเคลมว่า self-ligating/Damon "เร็วกว่า" — meta-analysis ชี้ว่าใช้เวลานานกว่าเฉลี่ย 2.01 เดือน |
| Cochrane 2022 single vs multiple visit (36512807) | ห้ามโฆษณาว่ารักษารากครั้งเดียว "ดีกว่า/ปลอดภัยกว่า" — ผลเท่ากันแต่ปวดใน 1 สัปดาห์แรกมากกว่า |
| Cochrane 2018 home bleaching (30562408) | ห้ามเคลมความคงทนระยะยาว/ยี่ห้อไหนดีกว่า และต้องแจ้งอาการเสียวฟันเสมอ |
| Naujokat 2016 implant + diabetes (27747697) | ห้ามใช้เป็นการรับประกันว่าผู้ป่วยเบาหวานทำรากเทียมได้ทุกราย — เงื่อนไขคือระดับการควบคุมโรค |
| Burke 2012 veneer survival (22863131) | ห้ามเคลม "วีเนียร์อยู่ได้ตลอดชีวิต" |
| Tonetti 2018 staging/grading (29926952) | ห้ามทำเป็นแบบประเมินตัวเองบนเว็บที่ให้ผลเป็นการวินิจฉัย |

> ข้อมูลงานวิจัยทั้งหมดในส่วนนี้มาจาก **PubMed** และบันทึก DOI ไว้ในตัว `key_findings` ทุกแถว

---

# Phase 5 · Keyword (ทำได้บางส่วน — ระบุตามจริง)

## 5.1 ✅ ที่ปิดได้

| งาน | ผล |
|---|---|
| แยก "หน้าที่ไม่ต้องมีคีย์" ออกจาก "งานค้าง" | **43 หน้า** เปลี่ยนจากธง `kw-none` → `structural-exempt` (32 hub ที่มีหน้าลูก + 11 หน้าโครงสร้าง) พร้อมเหตุผลรายหน้า |
| Q1 คู่ซ้ำ 2 คู่ (จับได้ด้วย strip-เว้นวรรคเท่านั้น) | ปิดตามที่ operator ตัดสิน — `2.1` ถือ `smilescape` เป็น primary + รับ `smile scape` เป็น semantic · `3.2.12.6` ถือ `รากเทียม เหงือกอักเสบ` ไว้ · อีกสองหน้าปล่อยคำแล้วรอคำใหม่ |
| `keyword_use_as` ไม่ตรงการใช้งาน | 19 → **0** |
| คำใหม่ที่วัด DFS แล้วโหลดเข้าคลัง + assign | **10 คำ / 10 หน้า** |
| หน้าที่ไม่มีคีย์และไม่ติดธง | **0** |

**คำที่โหลดรอบนี้** — ยิง DFS Google Ads (th-TH · Thailand) จริงทุกคำเมื่อ 2026-08-06 ก่อนโหลด · ค่า `0` ที่บันทึกคือค่าที่วัดได้จริง ไม่ใช่ค่าว่าง (DR-048)

| หน้า | คำ | vol |
|---|---|--:|
| 5.17.1 | `กลิ่นปาก` | **590** |
| 5.17.2 | `กลิ่นปากตอนเช้า` | 20 |
| 3.11.7 | `ครอบฟันเด็ก` | 0 |
| 3.2.10.1 | `กระดูกไม่พอ` | 0 |
| 5.19.9 | `กินอะไรหลังทำฟัน` | 0 |
| 5.2.2 | `กระดูกขากรรไกรล่างบาง` | 0 |
| 6.1.10 | `คู่มือฟอกสีฟัน` | 0 |
| 6.1.11 | `คู่มือผ่าฟันคุด` | 0 |
| 6.2.4.3 | `การดูแลสุขภาพช่องปาก` | 0 |
| 6.2.4.7 | `ครอบฟันคืออะไร` | 0 |

> `กลิ่นปาก` (590) มีหน้าสมัคร 2 หน้า — ให้ `5.17.1` (deep-dive) ตามกฎ 1 คีย์ : 1 หน้า · `5.6.6` ซึ่งเป็นหน้าสรุปของ §5.6 (ชื่อหน้าเขียนเองว่า "→ 5.17 deep-dive") ยังรอคำของตัวเอง

## 5.2 🔴 ที่ยังไม่จบ — 321 หน้ายังรอคีย์

**สาเหตุที่ไม่จบในรอบเดียว ไม่ใช่เรื่องเวลา แต่เป็นเรื่องคุณภาพของ seed**

คลังคีย์ของแบรนด์มีคำที่ว่างจริง (ไม่ได้เป็น primary และไม่ได้เป็น semantic ของใครเลย) **แค่ 13 คำ** จึงต้องเติมของเข้าคลังไม่ใช่ยัดของที่มี (SOP บรรทัด 42) · ผมสร้าง seed จากชื่อหน้าแบบอัตโนมัติแล้ววัดผล พบว่า **seed ที่ได้ใช้ไม่ได้เกินครึ่ง**

ตาราง `ss_kw_seed_wave16_20260806` (สร้างไว้ใน Supabase พร้อม `COMMENT` อธิบายวิธีใช้) เก็บ seed ของทั้ง 329 หน้า แยกชั้นไว้แล้ว

| `seed_class` | หน้า | ความหมาย |
|---|--:|---|
| `thai-candidate` | **189** | เป็นวลีไทยที่คนไข้พิมพ์ได้จริง → ยิง DFS ต่อได้ทันที (วัดแล้ว 11) |
| `english-term` | **104** | ชื่อหน้าเป็นศัพท์อังกฤษล้วน (`Densah Bur System` · `Le Fort I` · `Hybrid Prosthesis`) — ต้องมีคนตั้งคำไทยให้ก่อน |
| `internal-label` | **22** | เป็นป้ายภายใน (`Case: …` · `Decision Tree: …` · `Evidence Tier Framework`) ไม่ใช่คำค้น |
| `too-long-needs-shortening` | **14** | ชื่อหน้ายาวเกินกว่าจะเป็นคีย์ ต้องย่อ |

**สิ่งที่พิสูจน์แล้วในรอบนี้ (ยืนยันบทเรียน L6/L8 ของ SOP ซ้ำอีกครั้ง):** จาก 11 คำแรกที่วัด มีเพียง 2 คำที่มีดีมานด์วัดได้ — ดีมานด์ภาษาไทยของหัวข้อคลินิกเชิงลึกบางจริง

**สิ่งที่ห้ามทำในรอบถัดไป:**
- ห้าม hand-insert คำที่ยังไม่ยิง DFS เข้า `seo_x_ads_keywords_contextual_master`
- ห้ามเอา seed ชั้น `internal-label` / `english-term` ไป assign ตรง ๆ — จะกลายเป็น "assign มั่ว" คนละแบบกับที่ SOP เตือน
- ทุกคำต้องเช็คชนสองแบบ (`kw_norm()` + `replace(lower(kw),' ','')`) ก่อน assign

---

# 🏁 QA gate ปิดงาน — 2026-08-06

| # | เกต | ผล |
|---|---|--:|
| G01 | entity ชื่อซ้ำ (active ทั้งตาราง) | **0** |
| G02 | entity ไม่มี cluster (ไม่นับ person/organization) | **0** |
| G03 | หน้าไม่มี cluster | **0** |
| G04 | `page.cluster_id ≠ entity.topic_cluster_id` โดยไม่มี `reconciliation_notes` | **0** (จาก 370) |
| G05 | ตัวชี้ไปยัง entity ที่ `lifecycle='merged'` — page (ทุกแบรนด์) | **0** |
| G05b | ตัวชี้ไปยัง entity ที่ merged — keywords (ทุกแบรนด์) | **0** |
| G05c | ตัวชี้ไปยัง cluster ที่ merged (ทุกแบรนด์) | **0** |
| G06 | Q1 คีย์ซ้ำ token-sort | **0** |
| G07 | Q1 คีย์ซ้ำแบบ strip เว้นวรรค (trap L13) | **0** |
| G08 | หน้าเนื้อหาที่มี entity แต่ไม่มีคีย์ **และไม่ติดธง** | **0** |
| G09 | หน้าเนื้อหาที่ไม่มี citation | **0** |
| G09b | หน้าเนื้อหาที่ไม่มี citation Tier 1–3 | **0** |
| G09c | citation ที่ผูกแล้วไม่มี `key_findings` | **0** |
| G10 | `keyword_use_as` ไม่ตรงการใช้งานจริง | **0** |
| G11 | orphan `seo_page_citations` | **0** |
| G12 | orphan `seo_editorial_reviews` | **0** |
| G13 | orphan `seo_page_internal_links` | **0** |
| G14 | หน้านอก §3 ที่ไม่มีเส้นทางกลับ §3 | **0** |
| G15 | §5 ถือ `Article` schema (Bible ห้าม) | **0** |
| G16 | `page_fingerprint` ไม่ตรง node / ค้าง `zzz-` | **0** |
| G17 | `topic_cluster_name` เพี้ยนจาก master (ทั้งตาราง) | **0** |

**สถานะปิดรอบ:** หน้า active 722 · มี target keyword **358** · `structural-exempt` 43 · รอคีย์ (ติดธง `kw-none`) **321** · citation bindings **2,159** · internal links **2,775**

---

# เหลือส่งต่อ

| # | งาน | ใคร |
|---|---|---|
| 1 | **คีย์ 321 หน้า** — ยิง DFS ต่อจากตาราง `ss_kw_seed_wave16_20260806` ชั้น `thai-candidate` (เหลือ 178) แล้วตั้งคำไทยให้ชั้น `english-term`/`internal-label`/`too-long` | รอบถัดไป |
| 2 | 2 หน้าติดธง `section-move-candidate` — `3.6.7` ฟันร้าว/รากฟันแตก · `3.13.1.4` ปากแห้ง ควรย้ายไป §5 หรือไม่ | **operator** |
| 3 | `brand-doctor-authority` เป็น `brand_scope={smile-scape-clinic}` แต่ **VTH ใช้อยู่ 9 หน้า** = ผิดกฎ DR-046 ข้อ 1 (ของ VTH ไม่ใช่ของเรา) | คิว VTH |
| 4 | คู่ขนานที่เหลือในหมวดปริทันต์ซึ่งเป็น VTH ↔ deezy ล้วน (`scaling`↔`scaling-polishing` · `deep-cleaning`↔`deep-scaling` · `laser-periodontal`↔`laser-perio` · `gum-surgery`↔`periodontal-surgery` · `periodontal-disease`↔`periodontitis`) — เว้นไว้ให้คิว VTH ตามลำดับ DR-046 ไม่ตัดสินเป็นผลพลอยได้ | คิว VTH |
| 5 | คิว VTH ตาม DR-046 (137 หน้า) **ยังไม่ได้รัน** — `orthodontics-alignment` 29 · `aesthetic-restorative` 24 · `dentures-prosthetics` 10 ยัง active อยู่ | คิว VTH |
| 6 | `periodontal-treatment` เป็น entity ใหม่ที่สร้างในรอบนี้ — deezy `3.4` (hub ปริทันต์) ใช้ต่อได้ทันที ควรเก็บตอนรอบ deezy ถัดไป | deezy |

---

# 🔴 Wave 16b — รอบแก้หลังอ่าน `similarity-layer-2026-08-06.md`

**ข้อผิดพลาดของผม:** Wave 16 ทำ dedupe ด้วย**การเทียบสตริงอย่างเดียว** (ชื่อ · token-sort · ICD) ทั้งที่มีชั้นตรวจความคล้ายที่สร้างเสร็จแล้วรออยู่ — `pg_trgm` views + embedding 694 ตัว (openai-text-embedding-3-small) ที่รันเมื่อ 2026-08-06 · เอกสารนั้นเขียนไว้ตรง ๆ ว่า **"28 คู่ที่ cluster ไม่ตรงกัน คือคิวงานตรงของรอบ smile-scape"** และผมไม่ได้เปิดดู

## ผลการรันชั้นที่ขาดไป

| ชั้น | คู่ที่แตะ smile-scape | สรุป |
|---|--:|---|
| `v_page_title_near_duplicates` | **0** | S4 สะอาดอยู่แล้ว |
| `v_entity_near_duplicates` (trigram) | **0** | Wave 16 กวาดหมดแล้วจริง — ยืนยันว่าชั้นสตริงไม่พลาด |
| `v_entity_semantic_duplicates` (cosine) | **13** | **4 คู่เป็นของที่ Wave 16 มองไม่เห็น** |
| `v_keyword_near_duplicates` (trigram, ทั้งสองฝั่งเป็น primary) | **13 คู่ / 26 หน้า** | Q1 ของ SOP จับไม่ได้เลยสักคู่ |

## แก้อะไรไป

| # | เจอเพราะ | ทำอะไร |
|---|---|---|
| A | cosine 0.167 · **name_sim 0.906** | ยุบ `social-security-dental-benefit` "(TH)" (**17 หน้า SS · 9 คีย์**) → `social-security-dental` (deezy) — รูปแบบ `(TH)` ที่ worklist Tier A เขียนไว้ แต่ token-sort/strip-เว้นวรรคจับไม่ได้เพราะคำว่า `Benefit` กับวงเล็บ |
| B | cluster_conflict + cosine 0.180 | `tmj-disorder` (VTH 9 หน้า · SS 5 หน้า) ถูก loader รอบหลังเขียนทับให้ไปนั่งใน `patient-conditions-bone` = facet รากเทียมของ smile-scape → ย้ายกลับ `tmj-orofacial-pain` + ผูก edge `tmj-pain --symptom_of--> tmj-disorder` · **worklist 2026-08-04 §3 รายงานเคสนี้ไว้แล้วชื่อตรงตัว** |
| C | cosine 0.173 · name_sim 0.370 | ยุบ `bone-graft-implant` (deezy · 1 หน้า · 0 คีย์ · implant-dentistry) → `bone-grafting` (deezy · 12 หน้า · 19 คีย์ · oral-surgery) — **deezy ซ้ำกับตัวเอง** สรุปภาษาไทยแทบเหมือนกันคำต่อคำ · ทั้งคู่ `load_from='deezy-dental'` จึงตัดสินด้วย DR-046 กฎข้อ 4 (หน้า/คีย์มากกว่าชนะ) |
| D | cluster_conflict + cosine 0.175 | `early-orthodontic-intervention` ⟷ `pediatric-orthodontics` (deezy) — **ไม่ยุบ** เพราะเป็น subtype จริง (interceptive/phase-1) → ผูก `is_a` + ย้าย cluster ไป `orthodontics` ให้ตรงพ่อ + **ถอด ICD M26.4 ที่ติดผิดบนแถว treatment** |

**ที่ระบบชูขึ้นมาแต่ยืนยันว่าห้ามยุบ** (ตรงกับที่เอกสาร similarity เตือนไว้เอง): `Single Tooth Implant` ⟷ `Multiple Teeth Implant` · `Guided Bone Regeneration` ⟷ `Osseodensification` · `Regenerative` ⟷ `Resective Peri-Implantitis Surgery` · `SmileScape สาขารัตนาธิเบศร์` ⟷ `สาขาศรีนครินทร์` · `Ridge` ⟷ `Vertical Bone Augmentation`

## 🔴 บทเรียนใหม่ — Q1 ของ SOP มีรูที่ภาษาไทย (เสนอเป็น L20)

trap L13 บอกให้เช็ค 2 แบบ (`kw_norm()` token-sort + strip เว้นวรรค) — **ทั้งสองแบบจับ "การสลับลำดับคำไทยที่ไม่เว้นวรรค" ไม่ได้** เพราะ token-sort ต้องมีช่องว่างให้ตัดคำ ส่วน strip-เว้นวรรคเทียบสตริงตรงตัวจึงแพ้เมื่อลำดับต่าง

คู่ที่หลุด Q1 มาได้ทั้งที่เป็นคำเดียวกัน:

| หน้า A | หน้า B | sim |
|---|---|--:|
| `รักษาโรคเหงือก` (5.11.3) | `โรคเหงือก รักษา` (5.6.3.8) | 0.722 |
| `ผ่าตัดรากฟันเทียม` (3.2.3) | `รากฟันเทียม ผ่าตัด` (3.2.11.1) | 0.762 |
| `คลินิกสไมล์สเคป` (8.1) | `สไมล์สเคป คลินิก` (2.2.10) | 0.778 |
| `ผ่อนรากฟันเทียม` (3.2.8) | `รากฟันเทียม ผ่อน` (3.2.10.3) | 0.737 |
| `smilescape รากฟันเทียม` (2.5) | `รากฟันเทียม by smilescape` (2.1.2) | 0.885 |
| `รากฟันเทียม ผ่อน` (3.2.10.3) | `รากฟันเทียม ผ่อน 0` (6.2.1.5) | 0.895 |
| `สิทธิ์ทันตกรรม ประกันสังคม` (3.14.3) | `สิทธิประกันสังคม ทันตกรรม` (5.13.2.3) | 0.828 |

**เกตใหม่ที่เพิ่ม (G07b):** `v_keyword_near_duplicates` sim ≥ 0.70 โดยตัดคู่ที่ฝั่งหนึ่งเป็น substring ของอีกฝั่งออก (เพราะนั่นคือ "หัวคำ vs คำมุม" ที่ถูกต้องตาม DR-048 เช่น `รากฟันเทียม` vs `รากฟันเทียม ราคา`)

**13 คู่ / 26 หน้า ติดธง `kw-dup-semantic` ไว้ ไม่แก้เอง** — การเลือกเจ้าของคีย์เป็นการตัดสินใจเรื่องเนื้อหา ต้องให้ operator
⚠️ ในนั้นมี false positive ของ trigram อย่างน้อย 1 คู่: `ค่ารากฟันเทียม` ⟷ `ผ่ารากฟันเทียม` (0.765) ต่างกันแค่อักษรเดียวแต่คนละความหมายสิ้นเชิง — ยืนยันว่า view เป็น **รายการผู้ต้องสงสัย ไม่ใช่คำตัดสิน**

## 🏁 QA หลัง Wave 16b

| เกต | ผล |
|---|--:|
| G01 entity ชื่อซ้ำ (token-sort) | **0** |
| **G01b** trigram near-dup ที่แตะ smile-scape | **0** |
| **G01c** semantic near-dup ที่ยัง cluster ขัดกัน | **0** (จาก 3) |
| G04 mismatch cluster ไม่มี notes | **0** |
| G05 / G05b ตัวชี้ไป entity merged | **0 / 0** |
| **G05d** embedding ที่ยังชี้ entity ที่ปิดไปแล้ว | **0** |
| G06 / G07 Q1 token-sort / strip-เว้นวรรค | **0 / 0** |
| **G07b** คีย์สลับลำดับคำไทยที่ยังไม่ติดธง | **0** |
| G08 หน้าเนื้อหาไม่มีคีย์และไม่ติดธง | **0** |
| G09 / G09b citation / Tier 1-3 | **0 / 0** |
| G10 keyword_use_as ไม่ตรง | **0** |
| G14 หน้านอก §3 ไม่มีเส้นทางกลับ §3 | **0** |
| **G18** หัวข้อหน้าใกล้ซ้ำ (S4) | **0** |

> เพิ่มขั้นตอนบำรุงรักษา: ทุกครั้งที่ยุบ entity ต้อง **ลบแถวใน `seo_entity_embeddings` ของตัวที่ปิด** ไม่งั้น `v_entity_semantic_duplicates` จะชูซากขึ้นมาซ้ำทุกรอบ (ทำแล้วในรอบนี้)

## เพิ่มในรายการส่งต่อ

| # | งาน | ใคร |
|---|---|---|
| 7 | **13 คู่คีย์ที่ติดธง `kw-dup-semantic`** — เลือกเจ้าของรายคู่ | **operator** |
| 8 | เสนอ **L20** เข้า `Keyword_Assignment_SOP` — Q1 ต้องเพิ่มชั้นที่ 3 (`pg_trgm` ≥0.70 ตัด substring pair ออก) เพราะ L13 สองชั้นเดิมจับการสลับลำดับคำไทยไม่ได้ · และเพิ่มขั้นตอน "ลบ embedding ของ entity ที่ยุบ" เข้าเช็กลิสต์ merge | spec |
| 9 | **รัน `v_entity_semantic_duplicates` เป็นเกตมาตรฐานของทุกรอบ dedupe** — รอบนี้พิสูจน์แล้วว่าชั้นสตริงสะอาด (trigram 0 คู่) ขณะที่ชั้น semantic ยังเจอของจริง 4 คู่ | spec |

---

# 🔴 Wave 16c — รอบแก้หลังสเปกอัปเดต (2026-08-09)

**เอกสารเปลี่ยนระหว่างทาง** — `eywa-protocol-spec` commit `f129bb2` (2026-08-07) เพิ่ม **DR-049/050/051** + `Entity_Identity_SOP` + บทเรียน **L20–L23** + แก้เช็กลิสต์ §13.3 จาก 6 เป็น **7 จุด** · สองข้อระบุชื่อ smile-scape ตรง ๆ ว่ายังไม่ได้ตรวจ

## 1 · หนี้ที่เกิดจาก Wave 16 เอง — L20 (absence ≠ zero)

Wave 16 บันทึก `volume_recent_12m = 0` ให้ 8 คำที่ DFS ไม่คืนค่า · **L20 (2026-08-07) บอกว่าผิด** — DFS ไม่คืนค่าให้หัวคำไทยตัวใหญ่เป็นปกติ (`ครอบฟัน` `จัดฟัน` `รากฟันเทียม` ว่างหมด ขณะที่ `ขูดหินปูน` คืน 12,100) ตัวเลขว่างคือช่องว่างของ**ข้อมูล** ไม่ใช่ของ**ดีมานด์**

→ แก้เป็น `NULL` + `data_signal_quality = 0` ทั้ง 8 แถว · แก้ `viability_assessment.volume_12m` และ note ของคีย์ตามไปด้วย

## 2 · DR-049 + §13.3 จุดที่ 7 — ตรวจแล้ว ผ่าน

| เกต | ผล |
|---|--:|
| ลิงก์ที่ **ชี้เข้า** หน้า Merged ที่ยังไม่ deprecate | **0** |
| ลิงก์ที่ **วิ่งออกจาก** หน้า Merged ที่ยังไม่ deprecate | **0** |
| `planned_outbound_fps` ชี้หน้าที่ไม่มีจริง (จุดที่ 7 ที่เพิ่งเพิ่ม) | **0** |

smile-scape ไม่มีหน้า `status='Merged'` เลย จึงไม่มีลิงก์ตายจากเหตุนี้ — แต่รันเกตไว้เป็นหลักฐานตามที่ DR-049 สั่ง

## 3 · DR-050 — operator รันไปแล้ว ตรวจยืนยัน

`seo_entity_graph.icd_10_code` = **0 แถวทั้งตาราง** (ปลดระวางแล้ว) · `seo_entity_condition` ถือ `icd10_code` 97 + `icd10_cm_code` 109 · `wikidata_id` 148 → ไม่มีอะไรต้องแก้ฝั่ง smile-scape

## 4 · DR-051 role-mismatch — 🔴 เจอของจริงเยอะที่สุดของรอบนี้

### ชั้นที่ 1 · หัวบริการหายจากคลัง **8 คำ**

`ครอบฟัน` · `ฟอกสีฟัน` · `ฟันปลอม` · `สะพานฟัน` · `รักษาคลองรากฟัน` · `เกลารากฟัน` · `ดมยาสลบทำฟัน` · `รากเทียมทั้งปาก` — มีหน้าบริการครบทุกตัวแต่ไม่มีหัวคำในคลังเลย

### ชั้นที่ 1 · หัวบริการ **อยู่ผิดหน้า 12 คำ** — รูปแบบที่เจอซ้ำ

| รูปแบบ | ตัวอย่าง |
|---|---|
| **§5 ถือหัวบริการของ §3** | `ถอนฟัน` อยู่ `5.19` (hub หลังทำหัตถการ) · `ผ่าฟันคุด` อยู่ `5.14.8` (pericoronitis) · `รักษาโรคเหงือก` อยู่ `5.11.3` |
| **§6 ถือหัวบริการของ §3** | `ทันตกรรมเด็ก` อยู่ `6.5.1.5` FAQ |
| **หัวคำกว้างอยู่หน้าลูก** (ผิด Q5 ด้วย) | `จัดฟัน` อยู่ `3.10.4` จัดฟันเหล็ก · `อุดฟัน` อยู่ `3.11.3` อุดฟันน้ำนมเด็ก |
| **hub ถือคำของหน้าลูก** | `ขูดหินปูน` อยู่ `3.4` hub ทันตกรรมทั่วไป · `ครอบฟัน เซรามิก` อยู่ `3.5.1` hub ครอบฟัน (= เคสเดียวกับ VTH clear-aligner เป๊ะ) |
| **คำอยู่คนละหน้ากับชื่อหน้าที่ตรงเป๊ะ** | `ขูดหินปูน เจ็บไหม` (4,900/mo) อยู่ `3.4.1.8` ขณะที่ `3.4.1.5` ชื่อ "ขูดหินปูน เจ็บไหม" |

### ชั้นที่ 2 · 21 hit → เป็นการละเมิดจริง **12**

false positive ที่ยอมรับตาม DR-051 ข้อ 3: `gbr คืออะไร` · `sausage technique คืออะไร` · `trioclear ดีไหม` (รูปประโยค `X คือ/ดีไหม` ของชื่อเฉพาะ = หัวคำไทยจริง)
ละเมิดจริงคือกลุ่มที่**หัวข้อของคีย์ต่างจากบทบาทของหน้า**: `รากฟันเทียม ผ่อน` บนหน้าผู้ป่วยเบาหวาน · `รากฟันเทียม เจ็บไหม` บนหน้า Maintenance Program · `รากฟันเทียม คืออะไร` บนหน้าอายุการใช้งาน · `all on 4 ผ่อน` บนหน้าเปรียบเทียบขากรรไกร ฯลฯ

### สิ่งที่ทำ

- **สลับหัวบริการเข้าหน้าที่ตรงบทบาท 20 คำ** (2 รอบ) — ทุกคำที่ปลดออกลงเป็น `semantic_keyword` ไม่ทิ้ง (DR-051 ข้อ 4)
- **มินต์หัวบริการใหม่ 10 คำ** ที่ไม่เคยมีในคลัง — ยิง DFS วัดก่อนโหลดทุกคำ · ได้ค่าจริง 1 คำ (`ฟอกสีฟัน` 3,600/mo) ที่เหลือ DFS ไม่คืนค่า → เก็บ `NULL` + `data_signal_quality=0` ตาม L20 แล้ว **assign ต่อตาม DR-048 relevancy-first**
- **รวมงานคีย์เวิร์ดรอบนี้:** มี target keyword **339 หน้า** (จาก 350 ตอนเริ่ม Wave 16 แต่คนละชุด — 20 คำถูกย้ายไปหน้าที่ถูก และ 20 คำใหม่เข้ามา) · หน้าว่างที่ไม่ติดธง = **0**

## 5 · ปิด 13 คู่คีย์ `kw-dup-semantic` (operator สั่งให้จัดการเลย)

ตัดสินตาม DR-051 (§3 ถือหัวบริการ · ราคา/ผ่อน → cost hub `5.13` · สิทธิ์ → `5.13.2`) — เหลือ **1 คู่ที่ยอมรับเป็น non-defect** พร้อมเหตุผลในตาราง: `จัดฟัน self ligating ดีไหม` (3.10.3.2 หน้าเปรียบเทียบ) ⟷ `จัดฟัน self-ligating` (3.10.3.1 หน้าชนิด PSL) — trigram 0.78 แต่คนละเจตนาจริง

**เจอระหว่างทาง (ติดธง `structure-overlap` รอ operator):** §3.14 "ทำฟันด้วยสิทธิ์ประกันสังคม" กับ §5.13.2 "สิทธิ์ประกันสังคมทำฟัน — hub" เป็น**หมวดสิทธิ์ประกันสังคมสองชุดในไซต์เดียว** (~28 หน้า) — ไม่ยุบเองเพราะเป็นการตัดสินเชิงโครง

## 6 · 3.6.7 / 3.13.1.4 — operator ตัดสิน: ไม่ย้าย ให้เขียนเป็นมุมบริการ

ติดธง `content-rewrite-needed` พร้อมบรีฟรายหน้า (ไม่แก้เนื้อหาเองตามกติกา):
- **3.6.7** ฟันร้าว/รากฟันแตก → เขียนเป็นบริการวินิจฉัย+รักษาฟันร้าว (ตรวจด้วยอะไร · รักษาได้ไหม · ต้องถอนเมื่อไหร่) · entity ควรเป็นหัตถการ ไม่ใช่ `cracked-tooth`
- **3.13.1.4** ปากแห้ง+อาหารแข็งไม่ได้ → เขียนเป็นบริการดูแลผู้ป่วยปากแห้ง (ประเมิน · ฟลูออไรด์/น้ำลายเทียม · แผนป้องกันฟันผุ) แล้วลิงก์ไป 5.18 สำหรับมุมอาการ

## 7 · L22 — `seo_editorial_reviews` 0 → 677

smile-scape มี reviewer 2 ท่านในตารางแต่**ไม่มี review record เลยสักแถว** (VTH 688 · Deezy 683) → ผูกครบทุกหน้าเนื้อหา 677 หน้า
routing: คลัสเตอร์ตระกูลรากเทียม → **ทพ. วรภัทร จรางกุล** (Implantology & Oral Surgery) · ที่เหลือ → **ทพญ. พิชชาภา ผุดผ่อง** (OMFS)
**ทุกแถว `review_status='pending'` · `approved = NULL`** — ตาม L22 ห้ามบันทึก approved ให้หน้าที่ยังไม่มีเนื้อหา

## 8 · เขียนกลับเข้าสเปก (operator อนุมัติ)

- `Keyword_Assignment_SOP_v1_0.md` v1.4 — **Q9** ใน §10 (Q1 ชั้นที่ 3 ด้วย `pg_trgm` + SQL) · บทเรียน **L24** (สองชั้นเดิมจับการสลับลำดับคำไทยไม่ได้) และ **L25** (dedupe ที่ใช้แต่สตริงประกาศสะอาดทั้งที่ยังซ้ำ + ต้องลบ embedding ของ entity ที่ยุบ)
- `DECISION_RECORDS.md` DR-051 — อัปเดต Consequences ว่า smile-scape รันตัวตรวจแล้ว พร้อมรูปแบบที่พบ (เหลือ Deezy ที่ยังไม่รัน)

## 🏁 QA ปิด Wave 16c

| เกต | ผล |
|---|--:|
| G04 mismatch cluster ไม่มี notes | **0** |
| G05 ชี้ entity ที่ merged (ทุกแบรนด์) | **0** |
| G06 / G07 Q1 token-sort / strip-เว้นวรรค | **0 / 0** |
| **G07b** คีย์ใกล้ซ้ำ trigram ≥0.70 ที่ยังไม่อธิบาย | **0** |
| G08 หน้าเนื้อหาว่างและไม่ติดธง | **0** |
| G09 หน้าเนื้อหาไม่มี citation | **0** |
| G10 `keyword_use_as` ไม่ตรง | **0** |
| G14 หน้านอก §3 ไม่มีเส้นทางกลับ §3 | **0** |
| **G19** DR-049 ลิงก์แตะหน้า Merged (สองทิศ) | **0** |
| **G20** `planned_outbound_fps` ชี้หน้าที่ไม่มี (จุดที่ 7) | **0** |
| **G21** DR-050 `icd_10_code` ค้างบน `entity_graph` | **0** |
| **G22** L20 snapshot ที่ยังเก็บ `0` แทน `NULL` | **0** |
| **G23** DR-051 ชั้น 1 หัวบริการที่ยังหายจากคลัง | **0** |

## เหลือ

- **คีย์ ~300 หน้า** — seed แยกชั้นไว้ใน `ss_kw_seed_wave16_20260806` · `thai-candidate` ยิงต่อได้เลย · `english-term` 104 + `internal-label` 22 + `too-long` 14 ต้องมีคนตั้งคำไทยก่อน · **DFS คืนได้สูงสุด 10 คำต่อครั้ง** (วัดแล้วในรอบนี้) วางแผนรอบยิงตามนั้น
- **§3.14 ⟷ §5.13.2 หมวดสิทธิ์ประกันสังคมซ้อนกัน** (~28 หน้า) รอ operator
- Deezy ยังไม่เคยรัน DR-051 detector

---

# Wave 16d — Q3 intent gate (2026-08-09)

**เอกสารเปลี่ยนอีกรอบ** — `eywa-vth-biodent/content-plan/keyword-assignment-sop.md` อัปเดต 2026-08-09 15:45 (+18KB) เพิ่ม **operator ruling 4 ข้อ** และบทเรียนใหม่ ⚠️ **เลข L20/L21 ของ SOP ฉบับ VTH ชนกับ L20–L25 ของสเปกกลาง คนละเรื่องกันทั้งคู่** — ต้องรีเบสเลขก่อนมีคนอ้างผิด

## 1 · 🔴 Q3 ไม่เคยรันกับ smile-scape เลย

Wave 15/16/16b/16c ตรวจ Q1 · Q5 · Q7 · role-mismatch ครบ แต่ **ไม่เคยตรวจ Q3 (intent × page-type)** — เพราะไม่มีข้อมูล intent ให้ตรวจ นี่คืออาการเดียวกับที่ §5.1 อธิบายไว้: *"กฎที่ไม่มีข้อมูลให้ตรวจ ต้องรายงานว่าตรวจไม่ได้ ไม่ใช่ผ่าน"*

| ชั้น (§5.1) | ก่อน | หลัง |
|---|--:|--:|
| 1 · DFS snapshot (hard) | 120 | **177** |
| 2 · contextual_master LLM (soft) | 100 | 66 |
| 3 · ไม่มีข้อมูล (ตรวจไม่ได้) | **119** | 74 |

ยิง `dataforseo_labs_search_intent` **219 คำ** (tool รับ 1,000/ครั้ง — คนละตัวกับ volume ที่คืนได้ครั้งละ 10) เก็บ `search_intent` + `search_intent_probability` + `search_intent_secondary` + `fetched_at` ลง snapshot ตามคอลัมน์ที่ ruling เพิ่มไว้

**ผลการตรวจครั้งแรก: 34 หน้าละเมิด** (hard p≥0.8 = 17 · ย่านให้คนดู p 0.5–0.8 = 17)

## 2 · แยกเป็นสองกอง แล้วจัดการคนละแบบ

### กอง A · คำอยู่ผิดหน้าจริง — 22 หน้า (ปลดคำ ลงเป็น semantic)

Q3 เผยโรคเดียวกับ DR-051 จากอีกมุม — ตัวอย่างที่ชัดที่สุด:

| หน้า | คำที่ถืออยู่ | intent | ไปเป็น semantic ที่ |
|---|---|---|---|
| `2.3.2` International Training & Affiliation | `ผ่อนทำฟัน ไม่ใช้บัตร` | transactional **1.000** | 5.13.3 |
| `2.2.6` Orthodontics Team | `ผ่อน 0 ทำฟัน` | transactional 0.996 | 5.13.3 |
| `6.3` พจนานุกรมศัพท์ทันตกรรม (hub) | `รากฟันเทียม ผ่อน 0 ไม่ใช้บัตร` | transactional 0.703 | 5.13.3 |
| `6.5.2.3` FAQ การดูแลหลังรักษา | `รากฟันเทียม โปร 29900` | transactional 0.810 | 5.13.1 |
| `6.5.4` FAQ Cost & Insurance | `รากฟันเทียม ใช้งานไม่ได้` | transactional 0.857 | 6.2.1.22 |
| `6.5.4.2` FAQ ผ่อน 0% | `รากฟันเทียม กับ สะพานฟัน อันไหนดี` | commercial 0.797 | 3.2.11.1 |
| `6.2.1.28` กินอาหารหลังรากเทียม | `รากฟันเทียม vs ครอบฟัน` | commercial 0.800 | 3.2.11.1 |
| `6.3.1` ศัพท์รากฟันเทียม A-Z | `รากเทียม titanium vs ceramic` | commercial 0.878 | 3.2.8.10 |

รูปแบบซ้ำ: **หน้าเงื่อนไข/ทีมงาน/พจนานุกรม ถือคำผ่อนชำระและคำเปรียบเทียบ** — ทุกคำปลดออกแล้วลงเป็น semantic ของหน้าที่เป็นเจ้าของจริง (DR-051 ข้อ 4) · หน้าที่ว่างลงติดธงตามสภาพ (hub → `structural-exempt` · หน้าลูก → `kw-none`)

### กอง B · ข้อยกเว้นระดับหมวด (§5.2) — 12 หน้า เขียน `INTENT EXEMPTION` พร้อมเหตุผล

| หมวด | ยกเว้น | เหตุผล |
|---|---|---|
| §6 หน้าเปรียบเทียบ / หน้าแบรนด์ | `commercial` · `transactional` | "เลือกอันไหนดี" เป็นคำถามเชิงซื้อโดยธรรมชาติ แต่หน้าเป็นหน้าความรู้ — รูปแบบเดียวกับ VTH §6.8 |
| **§7 case study** | `commercial` | **ข้อยกเว้นใหม่ของ smile-scape** — หน้าเคสมีไว้พิสูจน์ผล คำเชิงประเมิน (`all on 4 ดีไหม`) คือสิ่งที่เคสจริงตอบได้ตรงที่สุด |
| ย่าน p 0.5–0.8 ที่คนตัดสินให้ผ่าน | รายหน้า | `trioclear รีวิว` 0.511 · `รากฟันเทียม ฟันกรามบน` 0.597 · `รากฟันเทียม ห้ามทำอะไร` 0.549 · `รากฟันเทียมขาว` 0.691 — เขียนเหตุผลรายหน้าไว้ทุกอัน ตามที่ §5.1 บังคับ (*"exemption ที่ไม่บอกว่าทำไม คือการเปลี่ยนกฎแบบเงียบ ๆ"*) |

## 3 · §5.0 time-series — เปลี่ยนวิธีอ่านแล้ว

`v_keyword_market_latest` มีอยู่แล้ว · ก่อนรอบนี้ smile-scape ยังไม่มี fingerprint ไหนที่มี snapshot หลายแถว (0) จึงยังไม่พัง — แต่ทั้งตารางตอนนี้มี **378 fingerprint ที่มีหลายแถวแล้ว** ทุกคิวรีที่อ่าน volume/intent ในรอบนี้ใช้ `distinct on (fingerprint) … order by snapshot_date desc nulls last` ทั้งหมด

## 4 · ⚠️ กับดัก temp table — โดนจริง

ruling ใหม่เตือนว่า SQL editor ของ Supabase ต่อผ่าน pool แบบ transaction mode temp table จึงหายระหว่าง statement — **รอบนี้เจอจริง** (`ERROR 42P01 relation "_dup" does not exist`) ตั้งแต่ก่อนอ่าน ruling · งานหลังจากนั้นเปลี่ยนมาใช้ data-modifying CTE ทั้งหมด

⚠️ กับดักย่อยของ CTE ที่เจอเพิ่ม: **CTE ทุกตัวเห็น snapshot เดียวกัน** — เขียน `strip` แล้วต่อด้วย `flag ... where target_keyword_fp is null` ในนิพจน์เดียวจะได้ 0 เพราะ flag ยังเห็นค่าก่อนถูก strip · ต้องแยกเป็นสอง statement

## 5 · 🔴 ช่องว่าง web ↔ DB (บันทึกไว้ตามที่ operator สั่ง)

`web/` ของ smile-scape **ไม่มี `web/scripts/` · ไม่มี npm `gen:*` · ไม่มี `page-context.json` / `internal-links.json` / `entity-schema` · ไม่มีโค้ดไหนอ้าง supabase เลย** (มีแค่ `src/data/doctors.json` ที่ดูแลด้วยมือ)

⇒ **งาน planning 722 หน้าอยู่ใน Supabase อย่างเดียว หน้าเว็บ `go.` อ่านไม่ถึงสักฟิลด์** — คนละสถาปัตยกรรมกับ VTH/deezy ที่ build อ่านไฟล์ derived ซึ่ง generate จาก DB
ผลข้างเคียง: **บทเรียน L21 ของ SOP ฉบับ VTH (แตะ DB แล้วต้อง regen ไฟล์ derived) ยังใช้กับ smile-scape ไม่ได้** เพราะไม่มีไฟล์ให้ regen · แต่นั่นแปลว่าทุกอย่างที่ทำใน Wave 15–16d ยังไม่มีทางไหลออกหน้าเว็บ

**เสนอเป็นงานรอบหน้า:** พอร์ต gen pipeline จาก VTH — ⚠️ L45 ของ DR-045 เตือนไว้แล้วว่า *"พอร์ตมั่ว = ได้สคริปต์ที่โกหก"* ต้องไล่ตรวจทีละ field เทียบ schema ของแบรนด์ก่อน

## 🏁 QA ปิด Wave 16d

| เกต | ผล |
|---|--:|
| **Q3 ละเมิดชั้น 1 ที่ยังไม่มี `INTENT EXEMPTION`** | **0** (จาก 34) |
| ชั้น 3 "ตรวจไม่ได้" | 119 → **74** |
| หน้าว่างและไม่ติดธง | **0** |
| มี target keyword | **317** |

## เหลือ

- **ชั้น 2 (66) + ชั้น 3 (74)** ยังไม่มี DFS intent — คีย์ที่เป็น semantic ล้วน ยังไม่ยิง (operator เลือกยิงเฉพาะ target รอบนี้)
- **คีย์ ~330 หน้า** ยังรอ volume — operator เลือก "ยังไม่ต้อง" รอบนี้ · seed แยกชั้นไว้ใน `ss_kw_seed_wave16_20260806` · ⚠️ `google_ads_search_volume` คืนได้ **10 คำ/ครั้ง** ต้องวางแผนรอบยิงตามนั้น
- **รีเบสเลขบทเรียนที่ชนกัน** — spec L20–L25 ⟷ VTH-SOP L20/L21
