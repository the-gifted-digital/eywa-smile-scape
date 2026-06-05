---
title: "รากฟันเทียม Blue Diamond Implant"
title_en: "Blue Diamond Dental Implant"
summary: "ตัวอย่างหน้า (skeleton) — สาธิต schema ของ content collection 'pages' ที่ผูกกับ sitemap 7 คอลัมน์ + relations + FAQ."
section: "3.1"
layer: "L2"
tier: "A"
funnel: "BOFU"
page_type: "Service Hub"
primary_entity: "dental-implant"
schema_type: "Service"
related_pages:
  - "services"
related_entities:
  - "bone-grafting"
  - "all-on-4"
faq:
  - q: "รากฟันเทียม Blue Diamond ราคาเท่าไหร่?"
    a: "เริ่มต้น 29,900 บาทต่อซี่ รับประกันตลอดชีพ ผ่อน 0%."
published: false
updated_at: 2026-06-06
---

> หน้าตัวอย่าง (ไม่ publish) สำหรับตรวจสอบว่า schema ของ content collection ใช้งานได้
> ตอน `astro build`. ลบไฟล์นี้ได้เมื่อเริ่มลงเนื้อหาจริง.

เนื้อหา body ของหน้าจะอยู่ตรงนี้ (Markdown). ใน build เต็มรูปแบบ ตัว body นี้คือ
สิ่งที่สะท้อนไป Notion เพื่อให้คนรีวิว (§18.5 Notion ↔ Supabase) และ relations
ด้านบนจะถูก render ผ่าน `<RelatedContent>` + `<FaqBlock>`.
