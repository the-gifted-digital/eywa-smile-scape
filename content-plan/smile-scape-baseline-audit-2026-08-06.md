# Smile Scape — Baseline Audit ก่อนเริ่ม calibrate (Phase 0)

> **วันที่:** 2026-08-06 · **ขอบเขต:** `brand_id='smile-scape-clinic'` · **722 หน้า active (Planned ทั้งหมด · Live 0 · Merged 0)**
> **วัดกับ:** DR-042 (reuse-first) · DR-046 (shared-table governance) · DR-047 (cluster precedence) · DR-048 (relevancy > volume) · `keyword-assignment-sop.md` v1.3 · EYWA Bible §4.2
> **ต่อจาก:** `eywa-vth-biodent/content-plan/deezy-clean-plan-2026-08-04.md` (baseline deezy ปิดแล้ว) · `cluster-entity-dedupe-worklist-2026-08-04.md`

---

## 🔴 ตัวเลขที่ไม่ตรงกับบรีฟ — ต้องแก้ความเข้าใจก่อนเริ่ม

| รายการ | บรีฟบอก | **วัดจริง 2026-08-06** | หมายเหตุ |
|---|--:|--:|---|
| หน้า active | 722 | **722** ✅ | ตรง |
| มี `target_keyword_fp` | 350 | **350** ✅ | ตรง |
| ขาด target keyword | 372 | **372** ✅ | ตรง |
| หน้าไม่มี cluster | 0 | **0** ✅ | ตรง |
| citation ที่ผูก | 0 | **0** ✅ | ตรง |
| **cluster mismatch (`page.cluster_id ≠ entity.topic_cluster_id`)** | **0** | **370** 🔴 | บรีฟผิด — ตัวเลข 370 ในบันทึก deezy คือ *คิวงานของ smile-scape* ไม่ใช่ "0 แล้ว" · และ **ไม่มีสักแถวที่มี `reconciliation_notes` อธิบาย** (0/370) |

**ลำดับงานตาม DR-046 ยังไม่ครบ:** DR-046 กำหนด deezy → VTH → smile-scape · deezy ปิดแล้ว 2026-08-04 แต่ **คิว VTH ยังไม่ได้รัน** (ตรวจแล้ว `orthodontics-alignment` 29 หน้า · `aesthetic-restorative` 24 · `dentures-prosthetics` 10 ยัง `status='active'` อยู่ครบ) การทำ smile-scape ก่อนทำได้ แต่ต้องรู้ว่าการยุบคลัสเตอร์ `{*}` บางตัวจะขยับหน้าของ VTH ไปด้วย 1–3 หน้าต่อคลัสเตอร์ (อยู่ในข้อยกเว้นที่ operator อนุญาต)

---

## 1. ชั้น Cluster

### 1.1 smile-scape สร้าง "ต้นไม้คู่ขนาน" ไม่ใช่แค่แถวคู่ขนาน

นี่คือส่วนที่ต่างจาก VTH — smile-scape ไม่ได้สร้างแค่ root ซ้ำ แต่ **เอา facet ของตัวเองไปแขวนใต้ root ซ้ำนั้น** ทำให้ยุบ root ตรง ๆ ไม่ได้ ต้อง reparent ลูกก่อน

```
dental-implant-core        (SS root · 126 หน้า)   ⟵ คู่ขนานของ deezy implant-dentistry
  ├── all-on-x-full-arch          (52)
  └── implant-systems-brands      (18)
gum-soft-tissue            (SS root · 26 หน้า)    ⟵ คู่ขนานของ deezy periodontics-gum
  └── periodontics-perio-disease  (39)
patient-conditions-tooth-loss (SS root · 10)
  └── patient-conditions-bone     (62)
```

### 1.2 คู่ขนาน `brand_scope={*}` ที่ต้องยุบเข้าหา canonical ของ deezy

ตัดสินด้วย `load_from` ตาม DR-046 ข้อ 2 — **ทุกแถวฝั่ง smile-scape มี `load_from = NULL`** ส่วน canonical ทุกตัวเป็น `load_from='deezy-dental'` จึงไม่มีคู่ไหนกำกวม

| # | แถว smile-scape (ยุบ) | หน้า SS | หน้าแบรนด์อื่นที่พ่วง | canonical (deezy) |
|---|---|--:|--:|---|
| C1 | `dental-implant-core` | 126 | 0 | `implant-dentistry` |
| C2 | `clear-aligner-orthodontics` | 66 | vth 1 | `orthodontics` |
| C3 | `general-restorative` | 55 | vth 3 | `restorative-dentistry` |
| C4 | `smile-design-cosmetic` | 43 | 0 | `cosmetic-dentistry` |
| C5 | `periodontics-perio-disease` | 39 | vth 1 | `periodontics-gum` |
| C6 | `digital-technology-diagnostics` | 28 | vth 1 | `dental-technology` |
| C7 | `insurance-coverage-th` | 28 | 0 | `insurance-access` (เปิด `{*}` แล้วรอบ deezy STEP 2) |
| C8 | `endodontics-specialist` | 11 | 0 | `endodontics` |
| **C9** | **`gum-soft-tissue`** | **26** | 0 | ⚠️ **ต้องให้ operator ตัดสิน** — ดู §1.4 |

รวม 8 คู่ตรงกับที่ worklist 2026-08-04 นับไว้ + 1 ตัวที่ค้างการตัดสิน

### 1.3 facet ที่ **เก็บ** (ความลึกของแบรนด์รากเทียม — ไม่ใช่ความซ้ำ)

`all-on-x-full-arch` (52) · `patient-conditions-bone` (62) · `bone-regeneration-gbr` (34) · `implant-systems-brands` (18) · `patient-conditions-tooth-loss` (10) · `implant-materials` (4)
→ ทั้งหมดต้อง `parent_cluster_fp` ชี้ **`implant-dentistry` (deezy)** ตามกฎที่ deezy-clean-plan §4 ประกาศไว้ ห้ามวางเป็น level-0 sibling

ช่องว่างจริงที่ deezy ไม่มี (เก็บ · ตั้ง parent ถ้ามีที่ใกล้เคียง): `demographic-dentistry` (25) · `dental-anesthesia` (12) · `dental-anatomy` (2)

### 1.4 🔴 การตัดสินที่ค้างมาจาก DR-046 — โครงสองชั้นเหงือก

`gum-soft-tissue` (Gum & Soft Tissue Management · 26 หน้า · 12 entity) เป็น**พ่อ**ของ `periodontics-perio-disease` (Periodontics & Gum Disease · 39 หน้า · 5 entity)

DR-046 บันทึกไว้ว่า *"ยุบตรง ๆ จะทิ้งการแบ่งชั้น ให้ตัดสินตอนถึงคิว"* — คิวนั้นคือรอบนี้

ความต่างที่วัดได้จากข้อมูล: `gum-soft-tissue` ถือ entity เชิง**ศัลยกรรมเนื้อเยื่ออ่อน** ส่วน `periodontics-perio-disease` ถือ entity เชิง**โรคปริทันต์** — deezy `periodontics-gum` ("Periodontics & Gum Health") ครอบทั้งสองอย่างในถังเดียว

3 ทางเลือก (เสนอทางที่ 2):

| ทาง | ทำอะไร | ได้ | เสีย |
|---|---|---|---|
| 1 | ยุบทั้งสองเข้า `periodontics-gum` | ถังเดียวเท่า deezy · dedupe จบสะอาด | ทิ้งการแบ่งชั้นศัลย์/โรค ที่ smile-scape ตั้งใจแยก (65 หน้า) |
| **2** ⭐ | ยุบ `periodontics-perio-disease` → `periodontics-gum` · เก็บ `gum-soft-tissue` เป็น **child ของ `periodontics-gum`** | ชื่อโรคเหลือชื่อเดียวทั้งตาราง · แง่มุมศัลย์เหงือกยังมีที่อยู่ ตรงกับ pattern `teeth-whitening ⊂ cosmetic-dentistry` ที่ deezy ใช้อยู่แล้ว | ต้อง retag 3 หน้าที่ `gum-soft-tissue` ถือแต่ entity อยู่ `periodontics-gum` |
| 3 | เก็บทั้งคู่เป็น child ของ `periodontics-gum` | เสียของน้อยสุด | เหลือคู่ขนานชื่อ "Periodontics & Gum Disease" อยู่ในตารางร่วม ขัดเจตนา DR-046 |

---

## 2. ชั้น Entity

### 2.1 คู่ที่ยุบได้ (smile-scape ถือฝั่งที่แพ้)

| # | ยุบ (SS ใช้อยู่) | หน้า SS | kw | canonical | เหตุ |
|---|---|--:|--:|---|---|
| E1 | `single-tooth-implant` | 3 | 8 | `single-implant` (deezy) | ชื่อเหมือน 100% |
| E2 | `cbct-3d-scan` (device) | 7 | 5 | `cbct-scan` (deezy · procedure) | token สลับ · ⚠️ Tier D `entity_type` ไม่ตรง — ต้องเลือกชนิดก่อนยุบ · ฝั่งที่แพ้ถือของมากกว่า ต้องยกตามไปทั้งหมด |
| E3 | `root-canal-retreatment` | 1 | 0 | `rct-retreatment` (deezy) | ชื่อเหมือน (ขีดกลาง) |
| E4 | `guided-surgery` | 1 | 0 | `guided-implant` (deezy) | ชื่อเหมือน 100% · ⚠️ canonical เป็นแถวว่าง (0 หน้า/0 kw) แต่ `load_from` ชนะตาม DR-046 |
| E5 | ~~`trioclear` (vth 1 หน้า)~~ | 0 | 0 | ~~`trioclear-aligner`~~ | 🔴 **ข้อเสนอนี้ผิด — กลับทิศแล้วตอนลงมือ** ดู `smile-scape-wave16-2026-08-06.md` §1.1: `trioclear-aligner` เป็น `brand_scope={smile-scape-clinic}` (private) และ ext row ว่าง ส่วน `trioclear` เป็น `{*}` + summary 634 ตัวอักษร + devices row เต็ม ⇒ **`trioclear` ต้องเป็นแถวที่รอด** |

### 2.2 คู่ ICD ซ้ำที่ **ห้ามยุบ** — เป็น subtype/คนละชนิดจริง (ผูก edge แทน ตาม DR-042 ข้อ 3)

| ICD | คู่ | ทำไมไม่ยุบ |
|---|---|---|
| M27.62 | `peri-implantitis` (deezy) ⟷ `peri-implantitis-treatment` (SS 6 หน้า) | condition vs procedure |
| K05.10 | `gingivitis` (deezy) ⟷ `pregnancy-gingivitis` (SS 6 หน้า) | เปลี่ยนประชากร = subtype |
| K02.9 | `dental-caries` (deezy) ⟷ `dental-filling` (SS 3 · kw 67) | condition vs procedure |
| K03.6 | `dental-calculus` (deezy) ⟷ `dental-scaling` (SS 8 · kw 11) | condition vs procedure |
| K04.0 | `pulpitis` ⟷ `pediatric-pulpotomy` (SS 2) | condition vs procedure |
| K01.1 | `impacted-wisdom-tooth` (deezy · kw 57) ⟷ `wisdom-tooth-removal` (SS 10 · kw 9) | condition vs procedure — **แต่ต้องตรวจว่าหน้า SS 10 หน้าเขียนเป็นหัตถการจริง** ไม่ใช่หน้าอาการ |
| K08.409 | `missing-tooth` (deezy) ⟷ `tooth-loss` (SS 6) | ⚠️ **ก้ำกึ่ง** — สองแถวนี้อาจเป็น concept เดียวกันจริง ต้องอ่าน `ai_entity_summary` ทั้งคู่ก่อนตัดสิน |

### 2.3 ICD ที่ใส่ผิด (ไม่ใช่ความซ้ำ — แก้ค่า)

- `direct-print-clear-aligner` (SS 5 หน้า) ติด **M26.4** (malocclusion) — เป็นอุปกรณ์ ไม่ใช่โรค
- `dental-caries-extraction` (SS 1) ติด **K02.9** — เป็นหัตถการ
- `pediatric-extraction` (SS 1) ติด **K08.409** — เป็นหัตถการ

---

## 3. ชั้น Backbone (Bible §4.2) — สอบตกหนักกว่า deezy ตอนเริ่ม

| # | ทดสอบ | เกณฑ์ผ่าน | **smile-scape** | (deezy ตอนเริ่ม) |
|---|---|---|--:|--:|
| T1 | §3 ห้ามถือ entity ชนิด condition | 0 | **19** 🔴 | 18 |
| T2 | §5 ห้ามถือ entity ชนิด treatment/procedure | 0 | **67** 🔴 | 13 |
| T3 | หน้า §5 ต้องมีลิงก์ออกไป §3 ≥1 | 0 ที่ไม่มี | **174 / 193 (90%)** 🔴 | 41/120 |
| T4 | schema shield (§5 ห้าม `Article` · §6 ต้องมี Article-family · ห้ามว่าง) | 0 | **0 / 0 / 0** ✅ | ผิด 7 |
| T5 | หน้า §3 ต้องมี inbound จาก §5 | 0 ที่ไม่มี | **227 / 242 (94%)** 🔴 | 160/219 |
| T6 | หน้านอก §3 ต้องมีเส้นทางกลับ §3 | 0 ที่ไม่มี | **456 / 480 (95%)** 🔴 | 182/498 |

**อ่านรวม:** โครง 8 section วางถูก · schema สะอาด · `page_type` ใช้ชุดเดียวกับสเปกครบ (ต่างจาก deezy ที่ใช้ vocabulary ของตัวเอง) — **แต่ internal-link graph แทบไม่มีทิศทางกลับเข้า §3 เลย** ลิงก์ 2,306 เส้นที่มีอยู่วิ่งอยู่ในหมวดตัวเองเป็นหลัก

### 3.1 ที่สะอาดแล้ว ✅

`page_fingerprint = 'smilescape-'||sitemap_node_id` ครบ 722/722 · parent FK ไม่พัง · ลิงก์ไม่มีปลายทางลอย 0 · orphan 0 · หน้าไม่มี cluster 0 · หน้าไม่มี entity 0 · schema ว่าง 0 · หน้า Merged 0 (ไม่มีหนี้ค้างจากรอบก่อน)

---

## 4. ชั้น Citation — ช่องว่างใหญ่สุด

| | |
|---|--:|
| `seo_page_citations` ที่ผูกกับหน้า smile-scape | **0** |
| `seo_editorial_reviews` ของ smile-scape | **0** |
| พูลที่ใช้ได้ (`brand_scope` มี `*` หรือ `smile-scape-clinic`) | **321** แถว |
| ในนั้น Tier 1–3 verified | **195** |
| ในนั้นยังไม่มี `key_findings` | **48** |
| แถว `unverified` (13 แถว first-party ของ smile-scape เอง) | **13** — ห้ามผูกจนกว่าจะผ่าน locator round-trip (DR-044) |
| หน้าที่ต้องมี citation (หน้าเชิงเนื้อหา ไม่นับโครงสร้าง/สาขา/about/home) | **~677** |

หนี้นี้ถูกบันทึกไว้ตั้งแต่ DR-044: *"smile-scape-clinic ยังไม่ผูกสระเข้าหน้าเลย (0 แถว) — 722 หน้า ต้องรัน §6 ของ SOP"*

---

## 5. ชั้น Keyword

| | |
|---|--:|
| คีย์ในคลังของแบรนด์ (`brand='Smile Scape Clinic'`) | 525 |
| assign เป็น target แล้ว | 350 |
| ยังไม่ assign | 175 |
| **ยังไม่ assign และไม่ได้เป็น semantic ของหน้าไหนเลย (ของว่างจริง)** | **13** 🔴 |
| คีย์ที่ไม่มี `primary_entity_fp` (ผิด P1) | 6 |
| `keyword_use_as` ไม่ตรงการใช้งาน (เป็น target ของหน้าแต่ค่าไม่ใช่ `target_keyword`) | **19** |

### 5.1 ขนาดของช่องว่าง

372 หน้าไม่มีคีย์ แยกได้เป็น

| กลุ่ม | จำนวน | ต้องมีคีย์ไหม |
|---|--:|---|
| hub (มีหน้าลูก) | 32 | ไม่ต้อง — P2 ยกเว้น ติด `structural-exempt` |
| หน้าโครงสร้าง (home/about/contact/สาขา/หมอ/local) | 11 | ไม่ต้อง — `structural-exempt` |
| **หน้าเชิงเนื้อหาจริง** | **329** | **ต้องมี** |

**คลังจ่ายให้ 329 หน้าไม่ได้** — ของว่างจริงมี 13 คำ ⇒ ต้องยิง DFS รอบใหญ่ (ใหญ่กว่ารอบ deezy ที่เติม 35 คำมาก) ทุกคำต้องวัด volume จริงก่อนโหลด (`0` ที่วัดได้ = ค่าจริง) + `primary_entity_fp` (P1) + snapshot ลงวันที่ (P3)

### 5.2 Q1 — คีย์ซ้ำภายใน smile-scape (จับได้ด้วย strip-เว้นวรรค เท่านั้น · trap L13)

| หน้า | คีย์ | ชนิด |
|---|---|---|
| `smilescape-2.1` / `smilescape-2.4` | `smilescape` ⟷ `smile scape` | brand-nav |
| `smilescape-3.2.12.6` / `smilescape-5.19.6` | `รากเทียม เหงือกอักเสบ` ⟷ `รากเทียมเหงือกอักเสบ` | **§3 vs §5 — ต้องเลือกเจ้าของ** |

> token-sort (`kw_norm`) จับได้ **0 คู่** · strip-เว้นวรรค จับได้ **2 คู่** — ยืนยัน L13 อีกครั้ง

### 5.3 คีย์ชนข้ามแบรนด์ = **ไม่ใช่ข้อบกพร่อง**

พบข้อความคีย์ตรงกันข้ามแบรนด์ 80+ คู่ (`ขูดหินปูน` · `วีเนียร์` · `จัดฟัน` …) — **ปกติและถูกต้อง** แต่ละแบรนด์มีแถวคีย์ของตัวเอง (คนละ `fingerprint`) และ `uq_page_master_target_keyword_fp` บังคับที่ระดับ fingerprint กติกา 1 keyword : 1 page ของ SOP เป็นกติกา**ในแบรนด์** ไม่ใช่ข้ามแบรนด์ · บันทึกไว้กัน audit รอบหน้าเข้าใจผิด

---

## 6. สิ่งที่ต้อง operator ตัดสินก่อนลงมือ

| # | เรื่อง | ทำไมตัดสินเองไม่ได้ |
|---|---|---|
| **D1** | โครงสองชั้น `gum-soft-tissue` / `periodontics-perio-disease` (§1.4) | DR-046 ระบุให้ operator ตัดสิน · กระทบ 65 หน้า |
| **D2** | คู่ Q1 `รากเทียม เหงือกอักเสบ` (3.2.12.6) ⟷ `รากเทียมเหงือกอักเสบ` (5.19.6) | เลือกเจ้าของ = การตัดสินใจเรื่องเนื้อหา ไม่ใช่ data hygiene |
| **D3** | คู่ Q1 `smilescape` (2.1) ⟷ `smile scape` (2.4) | เหมือนกัน |
| **D4** | `entity_type` ของคู่ `cbct-scan` (procedure) ⟷ `cbct-3d-scan` (device) — เลือกชนิดไหนเป็นของแถวที่รอด | กระทบ schema.org ที่ emit ออกไป |
| **D5** | `tooth-loss` (SS) ⟷ `missing-tooth` (deezy) K08.409 — ยุบหรือแยก | ก้ำกึ่งจริง |

**ไม่ต้องถาม:** ไม่มีหน้า smile-scape ไหนอยู่สถานะ `Live` ในตาราง (722 = Planned ทั้งหมด) การย้าย/ยุบหน้าจึงไม่กระทบ production ของฐานข้อมูล
⚠️ แต่ **เว็บ `go.smilescapeclinic.com` มีหน้าที่ deploy จริงอยู่แล้ว** (นอกฐานข้อมูลนี้) — หน้าที่เปลี่ยนคีย์/หมวดแล้วมีของจริงบนเว็บ ต้องติด `flag_review='content-rewrite-needed'` ส่งต่องานเขียน
