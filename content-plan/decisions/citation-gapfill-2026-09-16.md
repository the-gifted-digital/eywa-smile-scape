# ช่วง A — หาหลักฐานให้ 82 หน้าที่ไม่เคยมี citation ตรงเรื่อง (2026-09-16)

82 หน้านี้ผ่านเกต G มาได้เพราะ placeholder T1 ที่คนละเรื่อง ปลดออกเมื่อไหร่พังทันที จึงหาของจริงมาแทนก่อนปลด

## ผล

| | ค่า |
|---|---|
| หน้าที่หาได้ | **78/82** |
| หาไม่เจอ (PubMed ว่าง) | 4: `5.13.2.8` `5.13.3` `5.13.7` `6.5.4.5` |
| citation ใหม่ | 288 (56+225+7) |
| เส้นผูกใหม่ | 383 |
| placeholder ปลดออก | 184 |
| placeholder ที่ยังถือ | 16 บน 6 หน้า (4 หาไม่เจอ + 2 หาได้แต่ไม่มี Tier 1–3: `5.12.2` `5.13.2.10`) |

## วิธี — Sonnet ค้น+คัด · Opus ตรวจ

ตายที่ session/weekly limit 4 รอบ resume จาก cache ทุกครั้ง · agent รวม ~400 (Sonnet 246 ค้น + 82 คัด · Opus 82 ตรวจ)

ด่าน Opus ติง **63/82 หน้า · 116 จุด · 111 เป็น `claim_unsupported`** — Sonnet เลือกบทความถูก tier ถูก (ผิดแค่ 2)
แต่เขียนประโยคเกินบทคัดย่อ 37% ของ picks — เติมคำแนะนำเอง · ผูกตัวเลขผิดคู่เปรียบเทียบ · แปลงผลเป็นข้อสั่งการ
รอบแก้ (Sonnet แก้ · Opus ตรวจซ้ำ) ผ่าน 60/63 · เหลือ 3 จุดคำเดียวแก้เอง:
- `39889231` "สูญเสียความกว้างที่**วัดได้** 46-49%" → "ที่**เพิ่มได้ไป** 46-49%" (ตัวหารคือ gain ไม่ใช่ทั้งหมด)
- `31002614` Sonnet ลด tier 2→5 อ้าง TIER_BY_TYPE แต่ controlled clinical trial พับเป็น rct = 2 · คืนค่า
- `28512551` "ภาวะแทรกซ้อน**ที่พบบ่อยที่สุด**คือฟันปลอมชั่วคราวแตก" — บทคัดย่อไม่ได้จัดอันดับ ตัดออก

## สิ่งที่ต้องรู้

### `narrative_review` ไม่อยู่ใน CHECK ของ `citation_type`
CHECK รับ 17 ค่า ไม่มี narrative_review/controlled_clinical_trial · map เป็น `expert_opinion` (T6) 23 picks / `rct` 1 pick ตามที่ฐานใช้อยู่
ควรเติมค่าลง CHECK หรือใส่ synonym map ในสคริปต์ ETL — งานของเจ้าของ Bible

### G9 จับงานวิจัยอิสระที่ศึกษาสินค้าที่คลินิกใช้
PMID 42033855 (Int Orthod 2026, Tagore Dental College) ศึกษา UDMA รั่วจากถาด Graphy Tera Harz TC-85 — งานอิสระ ไม่ใช่ industry publication
แต่ `COMMERCIAL_RE` จับ "tera harz" ในชื่อเรื่อง และเกตตรวจทั้งพูล ปลดจากหน้าก็ยังติด
ตั้ง type เป็น industry_publication จะผิดข้อเท็จจริง จึง**ลบแถว** (ไม่มีอะไรอ้าง) และบันทึกไว้ที่นี่
หน้า `6.2.5.8` ถาดพิมพ์ตรงจาก TC-85 ที่คลินิกใช้จริง — งานอิสระเรื่องความปลอดภัยคือหลักฐานที่**ควร**ใช้
เกตต้องการกลไก disclosure ระดับหน้า ไม่ใช่บล็อกที่ระดับพูล — งานของเจ้าของเกต

### 35 หน้าเนื้อหาไม่มี citation เลยตั้งแต่แรก
ไม่อยู่ในขอบเขต 664 หน้าที่มี citation — pricing 8 · local/branch 12 · evidence_case 3 · service 4 · knowledge 4 · technology 2 · insurance 1 · `3.3.8` All-on-5 ที่สร้างในเวฟ 16ca
ส่วนใหญ่เป็นหน้าเชิงพาณิชย์/พื้นที่ ไม่ต้องการหลักฐานทางคลินิก · ที่ควรมี: `3.3.8` `3.4.1.7` `5.19.9` `3.10.1.1` `3.2.9.7.1.3` `4.6.0.4` `4.6.0.5`

## ยังถือ placeholder 16 เส้น

```
[["smilescape-5.12.2", "cite_257739E731894B5A"], ["smilescape-5.12.2", "cite_46345FF64F5E986B"], ["smilescape-5.13.2.10", "cite_549902FEE4A29769"], ["smilescape-5.13.2.8", "cite_67EFC86184F242FB"], ["smilescape-5.13.3", "cite_2E7411159C79E74E"], ["smilescape-5.13.3", "cite_99E88FFEE45F4FCE"], ["smilescape-5.13.3", "cite_B935F35CB638EDDF"], ["smilescape-5.13.3", "cite_UVPF05E6F7081920"], ["smilescape-5.13.7", "cite_13F3D1FCB6334EF4"], ["smilescape-5.13.7", "cite_2F91F9BFE6744596"], ["smilescape-5.13.7", "cite_45A1DF9AD6E34C45"], ["smilescape-5.13.7", "cite_45AEFE6CBE404DB3"], ["smilescape-6.5.4.5", "cite_820B0F94CE5647B2"], ["smilescape-6.5.4.5", "cite_99E88FFEE45F4FCE"], ["smilescape-6.5.4.5", "cite_B935F35CB638EDDF"], ["smilescape-6.5.4.5", "cite_UVPF05E6F7081920"]]
```