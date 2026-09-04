# ข้อเสนอ — ตารางราคาค่าบริการ + ที่เก็บสถานะสิทธิ์ (2026-09-05)

> ตอบคำถาม operator 2 ข้อ · **ยังไม่สร้างอะไร** — เป็นตารางใหม่ระดับ universal กระทบทุกแบรนด์
> ต้องอนุมัติ + ทำ DR + แจ้ง deezy/vth ก่อน

---

## ข้อ 2 · ตารางราคา — เห็นด้วย และควรทำ

### สภาพตอนนี้

สแกนทั้ง schema แล้ว **ไม่มีตารางราคาค่าบริการเลย** คอลัมน์ราคาที่มีอยู่ 11 ช่องอยู่ในตารางที่ไม่เกี่ยว:

```
seo_entity_product      price_min/max/typical/per_unit   สินค้าขายปลีก (น้ำยาบ้วนปาก) ไม่ใช่หัตถการ · 0 แถว
seo_entity_lab_test     typical_cost_thb                 แล็บ · 0 แถว
seo_gbp_posts           product_price_min/max            โพสต์ GBP · 0 แถว
seo_entity_procedures   — ไม่มีคอลัมน์ราคาเลย —           145 แถว = หัตถการจริงทั้งหมด
```

### สเปกออกแบบรูปทรงไว้แล้ว

`Keyword_Assignment_SOP` สองข้อกำหนดว่าตารางต้องรองรับอะไร:

> §368 — "หน้าบริการ §3 แต่ละหน้า: **ตารางราคาย่อ 3–5 บรรทัด** + ลิงก์ 'ดูราคาเต็ม' → `/pricing/#<slug>`"
> §444 — "หน้าสาขา**ไม่ทำตารางราคาซ้ำ** ให้ลิงก์เข้าหน้ารวม **ยกเว้นราคาต่างกันจริงตามสาขา**"

→ ต้องผูก **entity** (ให้หน้า §3 ดึงเองได้) และต้องรองรับ **ราคาต่างรายสาขา**

### เสนอ: ตารางเดียว `seo_service_prices`

```sql
create table seo_service_prices (
  id                  uuid primary key default gen_random_uuid(),
  fingerprint         text unique not null,          -- คอนเวนชันบ้าน
  brand_id            uuid not null references brands(id),
  branch_id           uuid references seo_branches(id),   -- null = ทุกสาขา · มีค่า = ราคาเฉพาะสาขา (§444)
  entity_fp           text references seo_entity_graph(entity_fingerprint),  -- ให้ §3 auto-derive
  department          text not null,                 -- 17 แผนกจากไฟล์ · ใช้จัดกลุ่มหน้า /pricing
  item_name_th        text not null,
  item_name_en        text,
  price_min           numeric,                       -- ราคาเดียว = ใส่ min เท่ากับ max
  price_max           numeric,
  price_unit          text,                          -- ซี่ · ขากรรไกร · ครั้ง · ชิ้น · ราย · sextant
  price_note          text,                          -- "รวมค่าถ่ายภาพรังสี" · "ขึ้นกับความยากของเคส"
  includes            text[],
  excludes            text[],
  -- 🔴 สามช่องนี้คือของที่ audit พบว่าขาดแล้วเกิดปัญหาจริง
  is_publishable      boolean not null default false, -- ยา/Botox/รหัสหลังบ้าน/ต้นทุน = false ตลอดกาล
  not_publishable_reason text,                        -- "พ.ร.บ.ยา ม.88" · "รหัสหลังบ้าน" · "ข้อมูลต้นทุน"
  price_kind          text not null default 'standalone'
                      check (price_kind in ('standalone','included_in_course','deposit','installment','addon')),
  -- "ไม่มีค่าใช้จ่าย" ส่วนใหญ่คือ included_in_course ไม่ใช่ฟรี · เขียนว่า "ฟรี" = โฆษณาเกินจริง
  effective_from      date not null,
  effective_to        date,                          -- null = ยังใช้อยู่
  source_note         text,                          -- อ้างไฟล์/ชีท/วันที่ต้นทาง
  display_order       int,
  created_at          timestamptz default now(),
  updated_at          timestamptz default now()
);
create index on seo_service_prices (brand_id, department, display_order);
create index on seo_service_prices (entity_fp) where entity_fp is not null;
create unique index on seo_service_prices (brand_id, coalesce(branch_id,'00000000-0000-0000-0000-000000000000'::uuid), item_name_th, effective_from);
```

### ทำไมออกแบบแบบนี้

| ช่อง | แก้ปัญหาอะไรที่ audit เจอจริง |
|---|---|
| `is_publishable` | ยา 28 รายการ (Augmentin · Botox 8,000) ผิด พ.ร.บ.ยา ม.88 · รหัสหลังบ้าน 27 รายการ · ต้นทุน/DF ที่หลุดในหมวดแพ็กเกจ — **ต้องอยู่ในตารางได้แต่ห้ามหลุดเว็บ** |
| `price_kind` | "ไม่มีค่าใช้จ่าย" ส่วนใหญ่คือขั้นตอนที่รวมในคอร์สแล้ว · ขึ้นว่า "ฟรี" = โฆษณาเกินจริง · และแยกตารางผ่อน/มัดจำ 5 ตารางในไฟล์ออกจากราคาหลัก |
| `price_min/max` + `price_unit` | 18 แถวเป็นช่วงราคา · หน่วยไม่เหมือนกัน (ซี่/ขากรรไกร/sextant) · เก็บเป็น text ก้อนเดียวจะ query ไม่ได้ |
| `branch_id` nullable | §444 ของสเปก — ปกติราคาเดียวทุกสาขา แต่รองรับกรณีต่างจริง |
| `entity_fp` | §368 — หน้าบริการดึงราคาย่อ 3–5 บรรทัดเองได้ · **ไม่ต้องให้ผู้เขียนฝังตัวเลขในบทความ** ซึ่งเป็นเหตุผลหลักที่ต้องมีตารางนี้ |
| `effective_from/to` | ราคาเปลี่ยน ไม่ต้องลบของเก่า และหน้าเว็บอ้าง "ราคา ณ วันที่" ได้ |

### ทางเลือกที่พิจารณาแล้วไม่เลือก

- **ใส่คอลัมน์ราคาใน `seo_entity_procedures`** — 1 หัตถการมีหลายราคา (วัสดุ/เกรด/จำนวนซี่) หนึ่งแถวต่อ entity ไม่พอ และ entity เป็นตารางกลางไม่มี brand
- **ใช้ `seo_entity_product`** — คอลัมน์ราคาครบก็จริง แต่ตารางนั้นแปลว่า "สินค้า" ไม่ใช่ "บริการ" ยืมมาใช้แล้ว schema `Product` จะผิดตอน emit
- **เก็บใน markdown ต่อไป** — query ไม่ได้ · หน้า §3 auto-derive ไม่ได้ · อัปเดตราคาทีเดียวต้องไล่แก้ 16 หน้าราคา + หน้าบริการที่อ้างถึง

### งานที่ตามมาถ้าอนุมัติ

1. DR ใหม่ + broadcast (ตารางระดับ universal)
2. นำเข้าจาก `docs/pricing/ราคาค่าบริการ.md` 750 รายการ — โดย **ตั้ง `is_publishable=false` เป็นค่าตั้งต้น** แล้วเปิดเฉพาะที่ตรวจแล้ว
3. ผูก `entity_fp` เท่าที่จับคู่ได้ (จากแผนที่ใน `docs/pricing/แผนที่ราคาสู่หน้าเว็บ.md`)
4. รายการที่ต้องให้ operator ชี้ก่อนนำเข้า: ราคาที่ขัดกันข้ามหมวด · วีเนียร์ 6/10 ซี่ที่ตีความไม่ได้ · 3 แถวที่ช่องราคาว่าง

---

## ข้อ 3 · ประกันสังคม — เห็นด้วย ไม่ควรอยู่ใน `seo_payer_partners`

operator ถูก · ตารางนั้นคือ**บริษัทคู่ค้าที่เป็นคู่สัญญา** (`partner_type CHECK IN ('insurer','employer')`)
70 แถวเป็นของ deezy ล้วน · ประกันสังคมเป็น**สิทธิของรัฐ** ไม่ใช่คู่สัญญาเอกชน คนละชนิดกัน

### แต่ต้องมีที่เก็บ เพราะตอนนี้ไม่มีเลย

`seo_branches` มี 61 คอลัมน์ **ไม่มีช่องเรื่องสิทธิ์/ผู้จ่ายสักช่อง** → สถานะที่ operator เพิ่งยืนยัน
("รับประกันสังคมไม่ต้องสำรองจ่ายทุกสาขา") ตอนนี้อยู่แค่ใน `reconciliation_notes` ของ 12 หน้า
ซึ่ง query ไม่ได้และหน้าอื่นดึงไปใช้ไม่ได้

### เสนอ: ตารางเล็ก `seo_payer_schemes`

```sql
create table seo_payer_schemes (
  id             uuid primary key default gen_random_uuid(),
  fingerprint    text unique not null,
  brand_id       uuid not null references brands(id),
  branch_id      uuid references seo_branches(id),    -- null = ทุกสาขา
  scheme_code    text not null check (scheme_code in ('sso','ucs','cgd','private_direct')),
  -- sso=ประกันสังคม · ucs=บัตรทอง/สปสช · cgd=กรมบัญชีกลาง(ข้าราชการ) · private_direct=ประกันเอกชนเบิกตรง
  accepts        boolean not null,
  cashless       boolean not null default false,       -- true = ไม่ต้องสำรองจ่าย
  provider_reg_no text,                                -- เลขสถานพยาบาลที่ขึ้นทะเบียนกับกองทุน
  verified_by    text not null,                        -- ใครยืนยัน + ยืนยันด้วยอะไร
  verified_at    date not null,
  conditions_note text,
  created_at     timestamptz default now(),
  updated_at     timestamptz default now()
);
create unique index on seo_payer_schemes
  (brand_id, coalesce(branch_id,'00000000-0000-0000-0000-000000000000'::uuid), scheme_code);
```

**ตั้งใจให้เล็ก** — เก็บแค่ "แบรนด์/สาขานี้รับสิทธิ์อะไร สำรองจ่ายไหม" เท่านั้น
ส่วน**ข้อเท็จจริงของสิทธิ์เอง** (900 บาท/ปี · ฟันปลอม 1,500–6,000 · ม.33/39/40) **ไม่เก็บในฐาน**
เพราะ (ก) เป็นข้อเท็จจริงของรัฐ ไม่ใช่ของแบรนด์ (ข) เปลี่ยนตามประกาศ ไม่ใช่ตามแบรนด์
(ค) ต้องมี citation กำกับทุกตัวเลข ซึ่ง `docs/compliance/sso-dental-2569.md` ทำหน้าที่นั้นอยู่แล้ว

`verified_by` + `verified_at` บังคับให้ทุกแถวบอกว่าใครยืนยันเมื่อไร — กันไม่ให้เกิดเคสเดิม
ที่หน้า 12 หน้าเคลมสถานะโดยไม่มีใครยืนยัน

### ถ้าอนุมัติจะใส่แถวเดียวก่อน

```
brand=smile-scape · branch=null (ทุกสาขา) · scheme_code='sso' · accepts=true · cashless=true
verified_by='operator ยืนยันในบทสนทนา 2026-09-04' · verified_at=2026-09-04
conditions_note='ยืนยันสถานะคลินิกเท่านั้น ตัวเลขสิทธิ์ดู docs/compliance/sso-dental-2569.md'
```

⚠️ `provider_reg_no` ยังว่าง — ถ้ามีเลขสถานพยาบาลที่ขึ้นทะเบียนกับ สปส. ควรใส่ (`seo_branches.medical_license_no` มีอยู่แล้วแต่คนละเลข)
