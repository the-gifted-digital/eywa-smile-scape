# ความพร้อมของตารางก่อนเขียนเนื้อหา — audit 2026-09-04
> วิธีตรวจ: 8 คลัสเตอร์ตารางขนาน + ตรวจข้ามตาราง 3 มุม + สังเคราะห์ · 12 agents · 0 error · 1.89M tokens
> agent อ่านอย่างเดียว ไม่เขียนอะไรลงฐาน · ทุกข้อมีตัวเลขจาก query กำกับ
> ผู้สังเคราะห์ตรวจซ้ำแล้ว**แก้ข้อสรุปของ sub-report เอง 3 จุด** (บันทึกไว้ในคำตัดสิน)

## คำตัดสิน

ยังไม่พร้อม — แต่ไม่ได้พังทั้งกอง. โครงหน้าและ referential integrity สะอาดจริง (fingerprint ทุกตัว resolve 100%, ไม่มี orphan, ไม่มี keyword cannibalization, editorial review ครบ 727/727) เขียนได้ทันทีประมาณ 630 หน้า. ที่เขียนไม่ได้จริงคือ ~91 หน้า ใน 4 กอง ซึ่งทั้งหมดมีรากเดียวกัน: **ฐานข้อมูลไม่มีข้อเท็จจริงของคลินิกเอง** — ราคา (0 แถวในทุกตารางที่มีคอลัมน์ราคา), เคสคนไข้+รูป (seo_reviews 0, seo_media_assets 0), สถานะคู่สัญญาประกันสังคม (seo_payer_partners 0 แถวสำหรับแบรนด์นี้ ทั้งที่ deezy-dental มี 70), และบริการดมยาสลบ (0/2 สาขาระบุใน services_offered_fps, 0 วิสัญญีแพทย์ใน doctor_assignments — แต่มี 11 หน้าขายบริการนี้ รวมหน้าชื่อ 'Anesthesiologist on-site'). ทั้ง 4 กองเป็นชนิดเดียวกับ fabrication ที่ commit 410c469 เคยจับได้ ถ้าปล่อยให้เขียนคือทำซ้ำรอบสอง.

⚠️ แก้คำตัดสินจากรายงานย่อย 3 จุด (ตรวจซ้ำเองแล้ว):
1) **T8 บล็อก 38 หน้า ไม่ใช่ 7** — ops-empty บอกว่าบล็อกแค่ 7 หน้า testimonial ที่เหลือ 31 หน้าเขียนเชิงคลินิกได้; แต่หลักฐานอีกฝั่งแข็งกว่า: ทั้ง 38 หน้าติดธง awaiting-real-cases ครบ (นับเอง = 38) และ content_format=T8 คือ 'Case Study / Patient Outcome' — เขียน case study โดยไม่มีเคสจริงคือแต่งเคส ไม่ใช่ 'เขียนเชิงคลินิก'. แยกได้ story/testimonial 6 + gallery 3 + clinical case 29.
2) **ปัญหา citation ของหน้า T3/T4 ไม่ใช่ blocker** — คลัสเตอร์ citation บอกว่า 3 หน้า GA + 18 หน้า T3 ต้องหาหลักฐานใหม่; ตรวจแล้วพบว่า **18/18 และ 3/3 หน้ามีหน้าพี่น้อง entity เดียวกันที่มี citation tier 1-3 อยู่แล้วในฐาน** และ pool มี Thai regulatory citation 9 ใบที่ยังไม่ถูกผูกกับหน้า T4 เลยสักใบ → เป็นงาน mapping ไม่กี่ชั่วโมง ไม่ใช่งานวิจัย ย้ายไป before_writing.
3) **จำนวนหน้าที่ผูกกับ SSO** — รายงานมา 4 ตัวเลข (24/32/20/2) เพราะนับคนละเกณฑ์; ตัวเลขจริง: primary_entity 6 หน้า · primary+related 32 หน้า · slug/ชื่อพูดถึงตรง ๆ 21 หน้า. ใช้ 6 เป็นหน้าที่เขียนไม่ได้เลย และ 32 เป็นวงที่ต้องระวังคำเคลม.

---

## 🔴 เขียนไม่ได้จริงจนกว่าจะแก้

### 1. T8 Case Study 38 หน้า — ไม่มีเคสจริง ไม่มีรูป ไม่มีคำให้การ

**หลักฐาน:** content_format='T8' = 38 หน้าพอดี และทั้ง 38 ติดธง flag_review 'awaiting-real-cases' (นับเอง n=38 ตรงกัน). แหล่งข้อมูลที่ต้องใช้ว่างทั้งคู่: seo_reviews = 0 แถวทั้งระบบ, seo_media_assets = 0 แถวทั้งระบบ (ซึ่งเป็นทะเบียน consent รูปคนไข้ที่เดียวในสคีมา). seo_branches.primary_photo_url/exterior_photos/interior_photos = NULL ทั้ง 2 สาขา. แยกชนิด: story/testimonial 6 หน้า (7.6.1-7.6.5 + 2.3.5) · gallery/before-after 3 หน้า · clinical case 29 หน้า. ทั้ง 38 หน้า legal_review_required=true แต่ seo_editorial_reviews review_type='legal' = 0 แถว

**ทางแก้:** กัน 38 หน้าออกจากคิวรอบแรกทั้งหมด (ไม่ใช่แค่ 6 หน้า testimonial). ปลดล็อกเมื่อ operator ส่ง: เคสจริง + ภาพ before/after เข้า seo_media_assets พร้อม consent_status/consent_doc_url, และคำให้การเข้า seo_reviews พร้อม consent_record_id. ระหว่างนี้ใช้ตัวเลขรวมจาก seo_branches ได้ (773 รีวิว/4.90 รัตนาธิเบศร์, 141/4.80 ศรีนครินทร์ ผูกกับ gbp_place_id จริง) ห้ามแต่งคำพูดคนไข้หรือเคสสมมติเด็ดขาด

### 2. T13 หน้าราคา 16 หน้า — ไม่มีราคาอยู่ในฐานข้อมูลเลยแม้แต่ช่องเดียว

**หลักฐาน:** สแกน information_schema ทั้ง schema public หาคอลัมน์ ~* 'price|cost_thb|fee_thb' เจอ 11 คอลัมน์ และทุกคอลัมน์อยู่ในตารางที่ว่าง 0 แถว: seo_entity_product (price_min/max/typical/per_unit) = 0 แถว, seo_entity_lab_test.typical_cost_thb = 0 แถว, seo_gbp_posts.product_price_min/max = 0 แถว (อีก 4 ตัวเป็น is_price_kw/is_price_intent ในตาราง keyword และ backup _ss_cand/_vth_* ไม่ใช่ข้อมูลราคา). seo_entity_procedures ไม่มีคอลัมน์ราคาเลย. แต่ 16 หน้า T13 เป็น funnel_stage='decision' และชื่อหน้าสัญญาตัวเลขตรง ๆ (ราคา All-on-X แผนผ่อนชำระ, ราคารากฟันเทียม, ครอบฟัน ราคา — เปรียบเทียบวัสดุ) และ legal_review_required=true ทั้ง 16

**ทางแก้:** ขอ price list จริงจาก operator (ช่วงราคา + สิ่งที่รวม/ไม่รวม + เงื่อนไขผ่อน + วันที่ยืนราคา) แล้วเก็บที่ที่ query ได้ — ทางเร็วสุดคือใช้ seo_entity_product ที่มีคอลัมน์ราคาครบอยู่แล้ว ผูก entity_fp กับ entity ของบริการ. อย่าให้ writer ฝังราคาในตัวบทความ ไม่งั้นอัปเดตราคาทีเดียวต้องไล่แก้ 16 หน้าราคา + หน้า service ที่อ้างถึง

### 3. ประกันสังคม/คู่สัญญา — 6 หน้าเขียนไม่ได้เลย อีก 26 หน้าเสี่ยงเคลมเกิน

**หลักฐาน:** seo_payer_partners = 0 แถวสำหรับ brand_id ของ smile-scape (ทั้งตารางมี 70 แถวเป็นของ deezy-dental ล้วน → ตารางใช้งานจริง ไม่ใช่ตารางร้าง). สแกนสคีมาแล้วเป็นที่เดียวที่เก็บเรื่องผู้จ่าย/สิทธิ์ (เจอแค่ seo_payer_partners.cashless กับ seo_entity_lab_test.insurance_typical_coverage ซึ่งตารางว่าง+ไม่เกี่ยว) และ CHECK constraint partner_type รับแค่ ANY(ARRAY['insurer','employer']) → ใส่ 'ประกันสังคม' ไม่ได้โดยไม่แก้ constraint. ฝั่งหน้า: primary_entity_fp='sso-direct-billing-q-clinic' = 6 หน้า, นับรวม related_entities = 32 หน้า, slug/ชื่อพูดถึงตรง ๆ 21 หน้า. entity ตัวนี้เป็น entity_type='concept' ที่ไม่มีตาราง subtype รองรับ และ ai_entity_summary ว่าง — รวม 20 หน้าที่ primary เป็น concept ที่ไม่มี ai_entity_summary. ชื่อหน้าที่บล็อกชัด: 9.2.1/9.2.2 'ทำฟันประกันสังคม <สาขา> — ไม่ต้องสำรองจ่าย', 6.2.7.2 'คลินิกคู่สัญญาประกันสังคม คืออะไร'. commit 410c469 เคยจับ fabrication เรื่องนี้มาแล้ว 12 หน้า

**ทางแก้:** ขอจาก operator เป็นชุดเดียว: สถานะคู่สัญญาแยกรายสาขา + เลขสถานพยาบาล + ปีที่มีผล + สิทธิที่เบิกได้จริง + ต้องสำรองจ่ายหรือไม่. บันทึกลง seo_payer_partners (ต้อง ALTER CHECK ให้ partner_type รับ 'government' ก่อน — ตารางไม่มี branch_id ให้ระบุ 'ทุกสาขา' ใน conditions_note ไปก่อน) แล้วเติม ai_entity_summary ให้ entity concept 9 ตัว. ถ้าไม่ได้ในรอบนี้ ให้ 6 หน้าพักไว้ และเขียน 26 หน้าที่เหลือแบบ 'สิทธิประกันสังคมทำฟันทำอะไรได้บ้าง' โดยห้ามเคลมสถานะของคลินิกเอง

### 4. หน้าดมยาสลบ/Sedation 11 หน้า — ขายบริการที่ไม่มีบันทึกว่าคลินิกมี

**หลักฐาน:** sensitive_topic_flag='critical' = 16 หน้า ในนั้น 11 หน้าเป็นกอง sedation/GA (3.12, 3.12.1-3.12.7, 3.11.13, 6.5.1.7) และเป็นหน้าขายบริการ ไม่ใช่บทความความรู้ — รวมหน้า 3.12.5 ชื่อ 'ขั้นตอนและความปลอดภัย — Anesthesiologist on-site'. หลักฐานฝั่งคลินิกว่างหมด: seo_branches.services_offered_fps ไม่มีรายการ anesthes/sedation เลยทั้ง 2 สาขา (0/2), specialties_at_branch = cosmetic_dentistry, general_dentistry, implantology, oral_surgery, orthodontics, periodontics, prosthodontics (ไม่มีวิสัญญี), seo_doctor_assignments ที่ role ~ 'anesth' = 0 แถว (มี 2 แถว ทั้งคู่ medical_director). ซ้ำ: ทั้ง 16 หน้า critical มี legal_review_required=false (critical|legal=true = 0) และ 3 ใน 11 หน้ามีหลักฐานแค่ tier 6 (T4 ทั้งกองมี Thai citation 0 ลิงก์, regulatory 0 ลิงก์)

**ทางแก้:** ให้ operator ยืนยันก่อนเขียน: คลินิกให้บริการดมยาสลบจริงไหม / สาขาไหน / มีวิสัญญีแพทย์ประจำหรือเป็น visiting / ทำในคลินิกหรือส่งโรงพยาบาล. ถ้ายืนยันแล้วให้เติม services_offered_fps + เพิ่มแถววิสัญญีแพทย์ใน doctor_assignments แล้วค่อยเขียน. ถ้ายังไม่ยืนยันให้พัก 11 หน้า — เขียนหน้าให้ความรู้เรื่องดมยาสลบทั่วไปได้ แต่ห้ามใช้หัวเรื่องเชิงบริการ/on-site

---

## ควรทำก่อนเขียน (ไม่บล็อก)

1. เซ็ต legal_review_required=true ให้ 16 หน้า critical — ตอนนี้ critical|legal=true = 0/16 ขณะที่ธง legal 86 หน้าไปกองที่หน้าราคา/การรับประกัน (T1 17, T2 63, T3 6, T4 0) คือธงผูกกับ 'เงิน' ไม่ได้ผูกกับ 'ความเสี่ยงทางคลินิก'; ทบทวน 217 หน้า high ด้วย และสร้างแถว seo_editorial_reviews review_type='legal' ให้ 86 หน้า (ตอนนี้ 0 แถว มีแต่ 'medical' 727 แถว)

2. แก้ has_medical_review — เป็น true ครบ 727/727 ขณะที่ seo_editorial_reviews ทั้ง 727 แถวเป็น review_status='pending', approved=null และยังไม่มีหน้าไหนเขียนเลย; ถ้าคอลัมน์นี้ป้อน schema reviewedBy จะกลายเป็นเคลมว่าหมอตรวจแล้วทั้งเว็บ (เคสเดียวกับ reviewedBy gate ที่เคยแก้ใน T16/T13) — รีเซ็ตเป็น false แล้วให้ derive จาก approved=true เท่านั้น

3. copy-across citation ก่อนเขียน (งาน mapping ไม่ใช่งานวิจัย): 18 หน้า T3 และ 3 หน้า T4 ที่ไม่มี citation tier 1-3 — ตรวจแล้ว 18/18 และ 3/3 มีหน้าพี่น้อง primary_entity เดียวกันที่มี tier 1-3 อยู่แล้ว; และผูก Thai regulatory citation (มีในพูล 9 ใบ) เข้าหน้า T4 ซึ่งตอนนี้ได้ 0 ลิงก์จาก 42 ลิงก์ทั้งกอง

4. ชี้ขาดการสะกดชื่อหมอแฮมภาษาอังกฤษ — canonical_url ของหน้า 2.2.2 = /dr-woraphat-jarangkul/ แต่ seo_authors_reviewers.canonical_names->>'en' = 'Dr. Worapat Jarangkul'; ท่านนี้เป็น reviewer ของ 562/727 หน้า จึงกระทบ byline อังกฤษทั้งเว็บ ไม่ใช่หน้าเดียว

5. ขอเลขใบประกอบวิชาชีพ + รูป ของทั้ง 2 ท่าน — medical_license_number = NULL 2/2, photo_url = NULL 2/2, board_certifications ของหมอแฮม = 0 รายการ (หมอแพรวมี 1); เขียนเนื้อหาไปก่อนได้แต่ต้องเว้นสล็อตไว้ ห้ามเดาเลขและห้ามใส่รูป stock แทนตัวแพทย์

6. แก้ 10 หน้า condition_pillar ที่ primary_entity_fp ชี้ไป entity หัตถการ (gingivitis-treatment→Periodontal Treatment, gum-recession-treatment→Gum Graft ฯลฯ) — ทั้ง 10 หน้า schema_markup_type='MedicalCondition' แต่ entity.schema_org_type=MedicalProcedure/MedicalTherapy; entity โรคจริงมีอยู่ใน graph แล้ว คือเลือก fp ผิด ไม่ใช่ entity ขาด. ⚠️ อย่า re-sync primary_entity_name ก่อนแก้ข้อนี้ ไม่งั้นชื่อโรคที่ถูกจะถูกทับด้วยชื่อหัตถการ

7. ย้าย cluster_id ของ 15 หน้าราคา/FAQ ที่ถูกโยนไว้ใน implant-dentistry ทั้งที่ entity+keyword เป็นสาขาอื่น (braces-cost/clear-aligner-cost→orthodontics, root-canal-cost→endodontics, teeth-whitening-cost→teeth-whitening, veneer-cost→cosmetic-dentistry ฯลฯ) — cluster_id เป็นตัวกำหนด hub/spoke ของ link engine ที่วาง cluster_spoke ไว้แล้ว 1,019 เส้น

8. ตัดสิน canonical ที่ชนกัน: 3.1.5 (digital-smile-design-diagnostics) กับ 3.9.1 (digital-smile-design) ใช้ canonical_url เดียวกัน (distinct 726 จาก 727 แถว) ทั้งคู่ status='Planned' และ redirect_target ว่างทั้งตาราง — ถ้า 3.1.5 เป็นหน้ายุบให้เซ็ต Merged + redirect_target แล้วเอาออกจากคิว 727

9. จัดประเภทใหม่ 5 หน้าที่ติด schema Physician ทั้งที่ไม่ใช่โปรไฟล์หมอ (our-dental-team, our-founders, why-choose-smilescape-implant, finding-a-good-implant-dentist, general-vs-specialist-dentist) — ทั้ง 5 ยืม primary_entity_fp='dr-woraphat-jarangkul' มาทั้งดุ้น เท่ากับประกาศว่าหน้า 'ทันตแพทย์ทั่วไป vs เฉพาะทาง' คือตัวหมอแฮม

10. ยืนยัน services_offered_fps ของ 2 สาขา — ตอนนี้ 41 fp เหมือนกันเป๊ะทั้งสองสาขา (ก๊อปกันมา) และทับกับ entity ที่หน้า service/pricing ใช้จริงแค่ 31 จาก 80 → หน้า branch/localService 12 หน้าจะ auto-derive รายการบริการที่ขัดกับเมนูเว็บ; และมี 1 fp ('multiple-implants') ที่ไม่มีตัวตนใน entity_graph

---

## รอได้ — เติมหลังเขียน/หลัง live

- semantic_keywords_fps ว่าง 385/727 หน้า (272 หน้าเป็น tier 1-2) — เขียนด้วย target_keyword อย่างเดียวได้ และมี semantic keyword ลอยรอจับคู่อยู่ 381 ใบ เป็นงาน mapping ทำหลังได้

- แผนลิงก์ภายใน — 283 หน้าวาง outbound ไม่ถึง required_min (structural-exempt คุ้ม 30 → ขาดจริง 253), 122 หน้าไม่มี contextual inbound ทั้ง format (caseStudy 38, faq 31, bespoke 24, pricing 16, localService 10, glossary 3), และไม่มีเส้น service→pricing เลยสักเส้น; ลิงก์เชิงบรรณาธิการเกิดตอนเขียน (implemented=false ทั้ง 2,822 แถว) — บันทึกกลับตอนเขียนได้

- seo_x_ads_keyword_serp_competitors = 0 แถวสำหรับแบรนด์นี้ (ทั้งตาราง 13,666 แถว/7 แบรนด์) → ไม่มี PAA/related_searches เป็น input ของ FAQ block; ตั้ง SERP fetch job ทีหลังได้ ใช้ pipeline เดียวกับ Deezy Dental

- contextual layer ของคีย์ว่าง 605/670 target (painpoint/core_insight/funnel_stage/anxiety_level/qualitative_kd) — ผู้เขียนคิดมุมเองได้ แต่จะไม่สม่ำเสมอข้าม 727 หน้า; รัน enrichment ตามลำดับ tier ทีหลัง

- supports_claim 1,428/1,833 แถวเป็นข้อความ log ของ wave16 ไม่ใช่เคลมจริง (474 หน้าไม่มีเคลมกำกับเลย) และ 404 แถวไม่มี section_context/evidence_strength_score — ReferencesBlock ท้ายหน้ายังใช้ได้ ผู้เขียนอ่าน key_findings เองไปก่อน

- volume/KD ว่างเกือบหมด (110/665 คีย์มี volume >0, keyword_difficulty ว่าง 608/669) — ตรงกับมติ 'ความหมายมาก่อน volume' ที่ตัดสินไปแล้ว ห้ามใช้เป็นเกณฑ์จัดลำดับการเขียน กลับมา optimize เมื่อมี GSC

- seo_entity_procedures บาง: 48 treatment (283 หน้า) ไม่มีแถวเลย และแถวที่มี 64 แถวก็กลวง (duration 15/64, uses_devices_fps 0/64); seo_entity_devices ไม่มี model_number/thai_fda_reg_no เลยสักแถว — เติมตามลำดับจำนวนหน้าที่กระทบ ห้ามเขียนประโยคเชิงทะเบียนถ้าไม่มีเลข อย.

- directory_listings / gbp_posts / local_rankings / llm_citations / brand_mentions / llm_query_simulations — ว่าง 0 แถวทั้งระบบ เป็นตารางวัดผลหลังเผยแพร่ ไม่ใช่ input; llm_* วัดไม่ได้เลยจนกว่าจะปลด noindex ที่ apex cutover (SS-DR-017)

- 517/727 หน้าเดินจาก HOME ไม่ถึงตามตารางลิงก์ — เป็นสภาพของชุดข้อมูล ไม่ใช่ของเว็บจริง เพราะ global nav อยู่ใน lib/site-nav.ts ไม่ได้ถูกโมเดลในตาราง; ตัดสินใจทีหลังว่าจะบันทึก nav ลงตารางหรือใส่หมายเหตุใน DR

- งานเก็บกวาดเล็ก: enum 18 คอลัมน์ไม่มี CHECK (robots_directive เพี้ยนแล้ว 2 รูปแบบ 719/8), คีย์ซ้ำเชิงความหมาย 5 คู่ (ยุบแล้วต้องลบ embedding ด้วยตามบทเรียน Wave 16), parent_page_name ว่าง 8 แถว, page_role ขัด node_tier_strategy 2 แถวรวมหน้า HOME, meta_description ยาวเกิน 160 หนึ่งหน้า, entity_lifecycle เก็บสองแบบตัวพิมพ์ (Mature 158/mature 19)

---

## ว่างเพราะไม่ต้องใช้กับแบรนด์นี้

- seo_entity_product / seo_entity_ingredients / seo_entity_lab_test — ว่าง 0 แถว และไม่เกี่ยวกับคลินิกทันตกรรม: entity_graph มี entity_type='product' 4 ตัว (mouthwash, biomap-report, face-up-longevity-membership, biomap-update) ซึ่งหน้า smile-scape อ้าง 0 หน้าทั้ง primary และ related, และไม่มี entity_type lab_test/ingredient อยู่เลยสักตัวจาก 13 ประเภท — ตัดออกจาก checklist ได้ถาวร (ข้อยกเว้น: ถ้าจะใช้ seo_entity_product เก็บราคาตามที่เสนอใน blocker ข้อ 2 ก็เป็นการยืมตารางมาใช้ ไม่ใช่เพราะแบรนด์มี product)

- seo_brand_centers — ว่าง 0 แถว และไม่มี reference ค้าง: page_master ของแบรนด์นี้ center_slug = NULL ครบ 728/728 แถว → SmileScape ไม่ได้ใช้โมเดล multi-center แบบ vitality

- seo_x_voice_search — ว่าง 0 แถวทั้งระบบ เป็น optimization overlay ที่ต้องมี keyword_fp + page_fp อยู่ก่อน ไม่ใช่แหล่งเนื้อหา และไม่มีหน้าไหนใน 727 ที่เนื้อหาหลักคือ voice query

- กอง i18n 5 คอลัมน์ใน page_master (translation_status, translation_due_date, translations_versions_fps, source_translation_fp, wpml_page_id) — page_language='th' ครบ 727/727 ยังไม่มีแถว en/zh-cn ใน master เลย จึงว่างเพราะไม่มีปลายทาง ไม่ใช่ตกหล่น

- กอง cross-brand 4 คอลัมน์ (cross_brand_justification/role/link_type/links_fps) — cross_brand_approved=false ทั้ง 727 หน้า; และกอง ads 2 คอลัมน์ (ads_template_id, campaign_id) — page_purpose='seo_organic' ทั้ง 727 หน้า

- notion_id (ไม่ได้ sync Notion — ใช้ reconciliation_notes 703 ค่าแทน), marketplace_proposal_status, redirect_target (ยกเว้นถ้าตัดสินให้ 3.1.5 เป็นหน้ายุบตามข้อ before_writing), seo_entity_organization สำหรับ 3 entity ของแบรนด์เอง (NAP/เวลาทำการอยู่ที่ seo_branches + lib/site.ts ตามการออกแบบ T10/T11 แล้ว)

---

## ตรวจแล้วสะอาด

- Referential integrity สะอาด 100% ทุกเส้น ไม่ต้องไล่ซ้ำ: primary_entity_fp 727/727 resolve · related_entities_fps 4,000 การอ้าง (226 ตัวไม่ซ้ำ) dangling 0 · target_keyword_fp 670/670 · semantic_keywords_fps 1,160 การอ้าง dangling 0 · planned_outbound_fps 565 คู่ dangling 0 · seo_page_citations 6,683 แถว orphan 0 ทั้งฝั่งหน้าและฝั่ง citation · seo_page_internal_links 16,532 แถว to/from ที่ไม่มีในหน้า = 0 · seo_entity_relationships 1,093 แถว ปลายลอย 0 · subtype 10 ตาราง 406 แถว แถวกำพร้า 0 และ entity_fp ซ้ำ 0

- ไม่มี keyword cannibalization ระดับ target — 670 หน้าใช้ 670 คีย์ต่างกันหมด (กลุ่มซ้ำ = 0) และไม่มีคีย์ของแบรนด์อื่นหลุดเข้ามาแม้แต่ตัวเดียว (จาก pool 22,716 คีย์ทุกแบรนด์)

- Identity/uniqueness ครบ: page_fingerprint, fingerprint, sitemap_node_id, slug, page_name, seo_title, meta_description distinct 727/727 ทุกตัว และไม่มี empty string ('' หรือช่องว่างล้วน) แม้แต่แถวเดียวใน 93 คอลัมน์

- content_topic_tier + sensitive_topic_flag เขียนครบ 727/727 (T1 49 · T2 439 · T3 223 · T4 16) และ compliance_max_tier >= content_topic_tier ทุกแถว (ละเมิด 0), ไม่มีแถวที่ legal_review_required=true ขณะ flag='none' → ทิศทางของเกตถูก ปัญหาคือ 'ไม่ได้ยก' ไม่ใช่ 'ยกผิด'

- NAP ครบทั้ง 2 สาขา ไม่มี placeholder: formatted_address, phone (+66 92 293 6226 / +66 63 649 5396), lat-lng, plus_code, postal_code, opening_hours 7 วัน, gbp_place_id ครบทั้งคู่ (แบรนด์เดียวใน 37 แถวของตารางที่มี place_id) → 12-13 หน้า local/branch ไม่ถูกบล็อกด้วยเรื่อง NAP และ AggregateRating ใช้ตัวเลขจริงได้ (773/4.90, 141/4.80)

- คุณภาพ citation 361 ใบที่ถูกใช้จริง: verified ครบ 361/361, is_retracted 0, broken_link 0, key_findings ว่าง 0, ไม่มีใบไหนไร้ locator (19 ใบที่ไม่มี url มี DOI 17/PMID 2), last_verified_at อยู่ในช่วง 2026-07-29 ถึง 2026-08-17 · inline_position เรียง 1..n ครบทั้ง 664 หน้า ไม่มีซ้ำ/ไม่มีช่องว่าง · ไม่มี citation ผูกซ้ำในหน้าเดียวกัน 0 คู่

- editorial review ครอบคลุมครบ 727/727 หน้า หน้าละ 1 แถวพอดี (ซ้ำ 0), reviewer_fp resolve 100% และ routing ตรงมติ 2026-06-12 ไม่มีข้ามกลุ่ม (knowledge_article 165/165→หมอแพรว, ที่เหลือ 562/562→หมอแฮม); หน้าเดียวที่ไม่มีแถวคือ 3.2.10.9 ที่ status='Merged' ซึ่งถูกต้องแล้ว

- โครงสร้าง breadcrumb/nav สมบูรณ์: 652 หน้าที่มี parent — มีลิงก์ breadcrumb ไป parent ครบ (ขาด 0) และมีลิงก์ navigational จาก parent มาครบ (ขาด 0); ไม่มีหน้า orphan เลย (min inbound 1, min outbound 2), ไม่มีลิงก์ซ้ำ, ไม่มีลิงก์ชี้ตัวเอง, ไม่มี cross-brand contamination (2,822 แถวอยู่ในแบรนด์เดียวทั้งหมด), anchor variant ไม่มี exact_match ในกลุ่ม contextual เลย

- สเปกโครงหน้าครบทุกหน้าไม่ต้องเดา: auto_suggested_word_count_target, authority_weight, crawl_depth, required_min_inbound/outbound, node_tier, funnel_stage, page_intent_type, priority, anchor_strategy_mode, schema_markup_type, sitemap_section, page_category, conversion_event_primary เต็ม 727/727 ทุกคอลัมน์; related_entities_fps เต็ม 727/727 ไม่มี array ว่างเลย และ embeddings ครอบคลุม 240/240 entity ที่ใช้

- topic_cluster ที่หน้าอ้าง 24 ตัว match cluster_slug 100% และ status='active' ทั้งหมด — ไม่มีหน้าไหนชี้ไป cluster ที่ merged/deprecated; 34 cluster ที่ไม่มีใครใช้เป็นของแบรนด์อื่นใน master ร่วม ไม่ต้องสร้างหน้ามารองรับ

- ข้ามตาราง backup เรียบร้อย — _ss_cand, _vth_pool_snap, _vth_sem_pool, v_seo_keyword_pool ที่โผล่มาตอนสแกนคอลัมน์ราคา ไม่ถูกนับเป็นข้อมูลจริงในรายงานนี้

---

## สถานะรายตาราง

| ตาราง | สถานะ | หมายเหตุ |
|---|---|---|
| `seo_website_page_master` | ขาดบางส่วน | 728 แถว (Planned 727 + Merged 1). 59/93 คอลัมน์เต็ม 727/727, null บางส่วน 8 คอลัมน์, ว่าง 100% 26 คอลัมน์ (ในนั้นไม่ต้องใช้ 15). ที่ขาดจริงก่อนเขียน:  |
| `seo_x_ads_keywords_contextual_master` | ขาดบางส่วน | 1,788 คีย์. target 670/670 มี search_intent + primary_entity ครบ และ resolve 100% — เขียนได้; แต่ชั้นบริบทว่าง 605/670 (painpoint/core_insight/funnel_ |
| `seo_x_ads_keywords_monthly_market_snapshot` | ขาดบางส่วน | มี snapshot 1,786/1,788 คีย์ (target 669/670) ไม่มีตัวไหนเก่าเกิน 180 วัน (2026-07-17 ถึง 2026-08-16); แต่ volume ว่าง/เป็น 0 ใน 558/669 และ keyword_d |
| `seo_x_ads_keyword_serp_competitors` | ว่าง-ต้องเติม | 0 แถวสำหรับ Smile Scape Clinic จากทั้งตาราง 13,666 แถว/7 แบรนด์ → ครอบคลุม target keyword 0/670. ไม่มี PAA/featured_snippet/related_searches เป็น inpu |
| `seo_entity_graph` | ขาดบางส่วน | 733 แถว ใช้จริง 240 entity, resolve 100%, aliases ครบ, embeddings ครบ 240/240. ขาด: ai_entity_summary ว่าง 32 ตัว → 101 หน้า (รวม 20 หน้าบน concept ที |
| `seo_entity_relationships` | ขาดบางส่วน | 1,093 แถว ปลายลอย 0 · แตะ smile-scape 684 เส้น. ปัญหา: medical_reviewer_signoff_at = NULL ทั้ง 1,093 แถว, flagged_review 12 แถว (แตะเรา 11 รวม peri-im |
| `seo_topic_cluster_master` | พร้อม | 58 แถว. cluster ที่หน้าอ้าง 24 ตัว match cluster_slug 100% และ active ทั้งหมด; 34 ตัวที่เหลือเป็นของแบรนด์อื่น/merged — ตัวตารางพร้อม ปัญหาอยู่ที่ pag |
| `seo_entity_condition` | ขาดบางส่วน | 125 แถว ครอบคลุม entity โรคที่ใช้ 48/48 และเติมเนื้อจริง ~36/48 (symptoms/risk_factors/diagnostic_methods/prevention/patient_explanation th+en); แต่ c |
| `seo_entity_procedures` | ขาดบางส่วน | 145 แถว. 48 treatment (283 หน้าเชิงพาณิชย์) ไม่มีแถวเลย และ 64 แถวที่ใช้จริงก็กลวง: duration 15/64, recovery 14/64, anesthesia 23/64, success_rate 4/6 |
| `seo_entity_devices` | ขาดบางส่วน | 64 แถว ใช้จริง 26. manufacturer 8/26, model_number 0/26, thai_fda_reg_no 0/26, fda_clearance 3/26; 9 device ที่หน้าอ้างไม่มีแถวเลย (12 หน้า) → 66 หน้า |
| `seo_entity_anatomy` | พร้อม | 21 แถว ครอบคลุม entity anatomy ที่หน้าใช้ 6/6 ครบ ไม่มีแถวกำพร้า |
| `seo_entity_symptom` | พร้อม | 21 แถว ครอบคลุมที่ใช้จริง 3/3 ครบ |
| `seo_entity_drug` | พร้อม | 9 แถว ครอบคลุมที่ใช้จริง 1/1 — พอสำหรับที่หน้าอ้าง (หน้าเรื่องยา 5.19.10 ติดบล็อกด้วยเหตุผลอื่น: tier 4 + legal flag ไม่ได้ยก + citation ใบเดียว) |
| `seo_entity_organization` | ว่าง-ไม่ต้องใช้ | 21 แถวเป็นองค์กรภายนอกล้วน (ADA/WHO/SSO/Straumann) is_own_brand_org=false ทุกแถว; 3 entity องค์กรของแบรนด์เอง (44 หน้าอ้าง) join ไม่ติด — แต่ NAP/ชื่อ |
| `seo_entity_product` | ว่าง-ไม่ต้องใช้ | 0 แถว. entity_type='product' มี 4 ตัวในกราฟและหน้า smile-scape อ้าง 0 หน้า — ว่างเพราะไม่ต้องใช้. หมายเหตุ: เป็นตารางเดียวในสคีมาที่มีคอลัมน์ราคาใช้กา |
| `seo_entity_ingredients` | ว่าง-ไม่ต้องใช้ | 0 แถว. กราฟไม่มี entity_type 'ingredient' เลยสักตัวจาก 13 ประเภท — เป็นตารางของแบรนด์สกินแคร์ ตัดออกถาวร |
| `seo_entity_lab_test` | ว่าง-ไม่ต้องใช้ | 0 แถว. กราฟไม่มี entity_type 'lab_test' เลย — ตัดออกถาวร |
| `seo_entity_embeddings` | พร้อม | ครอบคลุม 240/240 entity ที่ใช้ — similarity layer ก่อน dedupe รันได้ทันที ไม่ต้องรอ backfill |
| `seo_citations` | ขาดบางส่วน | 618 ใบ. 361 ใบที่ใช้จริงคุณภาพดี (verified 100%, retracted 0, มี locator ทุกใบ, ไม่มี duplicate DOI/PMID). ที่ต้องแก้: 23 ใบ scope smile-scape เป็น se |
| `seo_page_citations` | ขาดบางส่วน | 1,833 แถว active ของแบรนด์ (removed 0), orphan 0, inline_position เรียบร้อยทุกหน้า. ปัญหาคุณภาพ: supports_claim 1,428/1,833 เป็นข้อความ log ของ wave16 |
| `seo_page_internal_links` | ขาดบางส่วน | 2,822 แถว ไม่มีลิงก์เสีย/ซ้ำ/ชี้ตัวเอง/ข้ามแบรนด์ และ breadcrumb+nav ครบ 652/652. แต่เป็นโครงสร้างล้วน: contextual แค่ 556 เส้น (19.7%), 616 หน้าไม่มี |
| `seo_authors_reviewers` | ขาดบางส่วน | 184 แถว, brand_scope ครอบ smile-scape 2 ท่าน. bio/short_bio/specialties/credential_types/canonical_names/is_active ครบทั้งคู่; ขาด medical_license_num |
| `seo_editorial_reviews` | ขาดบางส่วน | 727 แถวของแบรนด์ ครอบคลุม 727/727 หน้า หน้าละ 1 แถว reviewer resolve 100% — โครงพร้อม. แต่ review_type='medical' ล้วน, review_type='legal' = 0 แถวทั้ง |
| `seo_doctor_assignments` | ขาดบางส่วน | 2 แถวของแบรนด์ ผูก author_id/author_fp ถูกต้องไม่มี orphan; แต่ branch_id = NULL ทั้ง 2 แถว (ทั้งที่มี 2 สาขา) → 12 หน้า local/branch auto-derive 'หมอ |
| `seo_branches` | ขาดบางส่วน | 2 แถว กรอกครบที่สุดใน 37 แถวของตาราง: NAP/geo/plus_code/opening_hours/gbp_place_id/local_business_schema_type ครบทั้งคู่ → เขียนหน้า local ได้. ที่ขาด |
| `seo_payer_partners` | ว่าง-ต้องเติม | 🔴 BLOCKER. 0 แถวสำหรับแบรนด์นี้ ขณะที่ทั้งตารางมี 70 แถวเป็นของ deezy-dental (insurer 35 cashless=true + employer 35) → ตารางใช้งานจริง ไม่ใช่ตารางร้า |
| `seo_media_assets` | ว่าง-ต้องเติม | 🔴 BLOCKER (ร่วม). 0 แถวทั้งระบบ. เป็นทะเบียน consent รูปคนไข้ที่เดียวในสคีมา (is_patient_image/consent_status/consent_date/consent_doc_url/use_until)  |
| `seo_reviews` | ว่าง-ต้องเติม | 🔴 BLOCKER (ร่วม). 0 แถวทั้งระบบ. 45 คอลัมน์รวมชุด PDPA เต็ม (consent_record_id, anonymization_status, is_sensitive_recovery_testimonial). บล็อก 6 หน้า |
| `seo_directory_listings` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ (ทุกแบรนด์). เป็น NAP-citation audit หลังเผยแพร่ ไม่ใช่ input ของการเขียน — NAP ที่หน้า local ต้องใช้มาจาก seo_branches ซึ่งครบแล้ว |
| `seo_gbp_posts` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. เป็นคิวโพสต์ GBP + ผลตอบรับ = ช่องทางเผยแพร่ ไม่ใช่แหล่งเนื้อหา |
| `seo_local_rankings` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. snapshot อันดับ local pack — งานวัดผลหลัง launch |
| `seo_llm_citations` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. อ้าง page_fp ที่ต้อง index ได้แล้ว แต่ go. ยัง noindex ทั้งโดเมน → วัดไม่ได้จนกว่าจะ cutover (SS-DR-017). ห้าม seed ข้อมูลสมมติเพื่อให้ |
| `seo_brand_mentions` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. การถูกพูดถึงจากภายนอก — เก็บได้หลังหน้าเว็บมีอยู่จริงและ index ได้ |
| `seo_llm_query_simulations` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. baseline หลัง cutover เท่านั้น |
| `seo_brand_centers` | ว่าง-ไม่ต้องใช้ | 0 แถว และไม่มี FK ค้าง: page_master ของแบรนด์ center_slug = NULL ครบ 728/728 → ไม่ได้ใช้โมเดล multi-center |
| `seo_x_voice_search` | ว่าง-ไม่ต้องใช้ | 0 แถวทั้งระบบ. overlay ที่ต้องมี keyword_fp + page_fp ก่อน; สอดคล้องกับที่ 3.2.12.6 จงใจว่างรอ GSC อยู่แล้ว |
| `seo_programmatic_templates` | ขาดบางส่วน | 23 แถว ใช้กับแบรนด์นี้ได้ทั้งหมด (applicable_brands=['*'] ยกเว้น T8g=deezy ซึ่งไม่มีหน้าเราอ้าง). ปัญหา: มีแค่ 3 เทมเพลตที่ประกาศ entity_type_required |
| `brands` | พร้อม | ใช้เป็นสะพาน brand_slug → uuid (c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25) สำหรับ 11 ตารางที่ใช้ brand_id เป็น uuid; resolve ถูกต้อง ไม่มีปัญหา (cloudflare |
