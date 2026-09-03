# ร่าง DR — content_topic_tier สำหรับคลินิกบริการทางการแพทย์
> 🔴 **ร่าง ยังไม่ได้เสนอเข้า DECISION_RECORDS.md และยังไม่ได้เขียนค่าลงฐานข้อมูล**
> เป็น DR ระดับ UNIVERSAL กระทบ 3 แบรนด์ ต้องให้ operator อนุมัติและแจ้ง deezy/vth ตรวจรับก่อน
>
> วิธีร่าง: 4 มุมมองอิสระ (ตัวบท · Google QRG · กฎหมายไทย · ย้อนจากผล) → ผู้ตรวจปฏิปักษ์ 3 คน → สังเคราะห์
> 8 agents · 0 error · 1.29M tokens

## หลักการเดียวที่กฎนี้ยืนอยู่

content_topic_tier ให้เกรดสิ่งเดียว: **"ผู้อ่านจะเอาหน้านี้ไปทำอะไรกับร่างกายตัวเอง ตอนที่ไม่มีทันตแพทย์อยู่ตรงนั้น"** — ไม่ใช่ความเสี่ยงเชิงพาณิชย์/โฆษณา (คอลัมน์นั้นคือ legal_review_required ซึ่งตั้งไว้แล้ว 86 หน้า) และไม่ใช่ page_category. ชั้นขึ้นเป็น T3 เมื่อหน้านั้น "สั่งการดูแลที่ผู้อ่านลงมือเอง / ตัดสินความเร่งด่วนแทนผู้อ่าน / พูดกับกลุ่มเปราะบางหรือผู้มีโรคประจำตัว / เป็นหน้าโรคและอาการ" และขึ้นเป็น T4 เฉพาะเมื่อแตะยาที่ต้องมีผู้สั่งจ่ายหรือผู้ให้ยาที่มีใบอนุญาต. บาร์ของทุกชั้นต้องเขียนด้วยคำศัพท์ของ seo_citations จริง (tier1=meta/SR · tier2=RCT · tier3=clinical_guideline · tier4=regulatory_document) ไม่ใช่ตัวเลขใน §32.4 ที่เขียนจากสเกลคนละอัน — ไม่งั้นกฎจะสั่งห้ามแหล่งที่ถูกต้องที่สุดของหน้านั้นเอง

## ผลถ้าใช้กับ smile-scape 727 หน้า

```
T1   49   T2  433   T3  231   T4   15
```

## ตารางตัดสิน (เรียงตามลำดับตรวจ — หยุดที่ข้อแรกที่ตรง)

### ข้อ 1 → tier 1 · flag `medium`

**เงื่อนไข:** page_category ∈ {home, about, contact, branch_landing, doctor_profile, pricing_page} AND legal_review_required = true — หน้าองค์กร/ราคา/รับประกัน ที่ถือข้อผูกพันเชิงกฎหมาย (วัดได้ด้วย 2 คอลัมน์ ไม่ต้องอ่าน body)

**เหตุผล:** หน้าพวกนี้ไม่มีคำสั่งทางคลินิกให้ผู้อ่านทำตาม → topic sensitivity = ต่ำสุด; แต่ข้อความเป็นข้อผูกพัน (ราคา/คำรับประกัน) จึงไม่ใช่ 'none'. ความเสี่ยงจริงของหน้าถูกแบกโดย legal_review_required=true ที่ตั้งไว้แล้ว — ดัน tier ขึ้นคือจองคอลัมน์ซ้อนและส่งหน้าราคาไปหาบาร์ PubMed ที่ใช้กับตารางราคาไม่ได้. ยิงจริง 17 หน้า (pricing 16 + Treatment Warranty ใน about 1)

### ข้อ 2 → tier 1 · flag `none`

**เงื่อนไข:** page_category ∈ {home, about, contact, branch_landing, doctor_profile, pricing_page} (ที่เหลือ)

**เหตุผล:** DR-030 §1 T1 = 'decorative product showcase' คือหน้าที่ประธานของเรื่องเป็นตัวแบรนด์ ไม่ใช่ผลลัพธ์สุขภาพ. โล่นี้อยู่ก่อนกฎเนื้อหาโดยตั้งใจ เพื่อไม่ให้หน้า 'ทีมทันตแพทย์เด็ก' หรือ 'ราคาดมยาสลบ' ถูกดึงขึ้นด้วยคำในชื่อ — หน้าที่จัด category ผิด (เช่น 'เลือกหมอฟันยังไง' อยู่ใน doctor_profile) ต้องแก้ที่ page_category ไม่ใช่แก้ที่กฎนี้. ยิงจริง 32 หน้า

### ข้อ 3 → tier 2 · flag `medium`

**เงื่อนไข:** page_category = insurance_page — สิทธิ์/ความคุ้มครองของผู้จ่ายรายที่สาม (ประกันสังคม/บัตรทอง/ประกันเอกชน)

**เหตุผล:** เป็นการให้ความรู้ที่มีผลลัพธ์เฉพาะ (T2 คำต่อคำ) — ผิดแล้วเสียเงินและเสียเวลา ไม่ใช่เสียสุขภาพ. ไม่ยกขึ้น T4 เพราะบาร์ T4 ที่ §32.4 เขียนว่า 'gov + clinical' ในสเกลจริงของ seo_citations คือ regulatory_document (tier 4) ซึ่งกฎข้อนี้อนุญาตอยู่แล้วที่ T2 — และเพราะ review_type='legal_compliance' มี 0 แถวใน 2,099 แถวทั้งเฟเดอเรชัน ธง T4 บน 27 หน้านี้จะเป็นธงที่ไม่มีปลายทาง. legal_review_required=true ทั้ง 27 หน้าคงไว้เหมือนเดิม. ยิงจริง 27 หน้า

### ข้อ 4 → tier 4 · flag `critical`

**เงื่อนไข:** ชื่อ/seo_title/slug ชนกลุ่ม 'ยาที่ต้องมีผู้สั่งจ่ายหรือผู้ให้ยาที่มีใบอนุญาต' — regex: sedation|anesthe|anaesth|ดมยา|ยาสลบ|วิสัญญ|nitrous|แก๊สหัวเราะ|ไนตรัส|ยาแก้ปวด|ยาที่ใช้|antibiotic|ยาปฏิชีวนะ|drug dosing|opioid|ยานอนหลับ|ยาคลายกังวล

**เหตุผล:** DR-030 §1 T4 คำต่อคำ = 'content touching controlled substances' และ T4 เป็นชุดผู้ตรวจชุดเดียวที่มี regulator — ซึ่งตรงกับสิ่งที่หน้ากลุ่มนี้ต้องการจริง (ยาสลบ/ยาระงับความรู้สึก/ยาปฏิชีวนะ/การปรับขนาดยาในผู้ป่วยไต-ตับ). ตรวจรายชื่อครบทั้ง 15 หน้าแล้ว ไม่มี false positive (ตัดออก 1 หน้าที่ชน 'prophylaxis' แบบขัดฟัน = EMS Airflow Prophylaxis). ยิงจริง 15 หน้า — นี่คือชุดเดียวในเว็บที่กฎนี้ยอมให้เป็น T4

### ข้อ 5 → tier 3 · flag `high`

**เงื่อนไข:** หน้าตัดสินความเร่งด่วน/ภาวะฉุกเฉิน/สัญญาณอันตราย — regex: ฉุกเฉิน|emergency|เลือดไม่หยุด|เลือดออกไม่หยุด|hemostat|ปวดมาก|ปวดรุนแรง|กลางคืน|คืนนี้|หนอง|abscess|บวม|swelling|ฟันหลุด|ฟันหัก|ฟันแตก|อุบัติเหตุ|trauma|เมื่อไหร่ต้อง|เมื่อไรต้อง|เมื่อไหร่ควรมาพบ|เมื่อไหร่ผิดปกติ|when to come back|สัญญาณเตือน|red flag|ติดเชื้อ|infection|pericoronitis|pulpitis|แพ้ยา|แพ้โลหะ|แพ้ไหม|allerg

**เหตุผล:** ผลของการเขียนผิดคือ 'ผู้อ่านอยู่บ้านต่อ' ซึ่งแก้กลับไม่ได้ — เข้า YMYL-high ตรงกว่าหน้าอธิบายหัตถการ. เป็นชั้นที่การอ่าน T3 แบบ 'หมวดประชากรอย่างเดียว' ทำหล่นทั้งชั้น (เลือดไม่หยุดหลังถอนฟัน · ฝีหนองเหงือก · ปวดรุนแรงกลางคืน · Acute Pulpitis). หมายเหตุ false positive ที่ตัดทิ้งแล้ว: ห้ามใช้ token 'ฝี' (ชน 'ริมฝีปาก') และ 'แพ้' เดี่ยว (ชนสำนวน 'ไม่แพ้'). ยิงจริง 40 หน้า

### ข้อ 6 → tier 3 · flag `high`

**เงื่อนไข:** ประธานของหน้าเป็นกลุ่มเปราะบาง/ผู้มีโรคประจำตัว/โรคร้ายแรง — regex: เด็ก|ทารก|ฟันน้ำนม|pediatric|kids|ขวบ|ของลูก|ดูดนิ้ว|อมจุก|ตั้งครรภ์|pregnan|ให้นมบุตร|breastfeed|หลังคลอด|ผู้สูงอายุ|สูงวัย|geriatric|senior|เบาหวาน|diabet|hba1c|โรคหัวใจ|cardiac|endocarditis|ความดัน|ยาละลายลิ่มเลือด|anticoagul|bisphosphonate|denosumab|mronj|กระดูกพรุน|osteopor|ภูมิคุ้มกัน|immunocompromis|hiv|มะเร็ง|cancer|เคมีบำบัด|chemo|รังสีรักษา|ฉายรังสี|radiation|orn risk|ฟอกไต|renal|hepatic|โรคไต|ตับ|โรคประจำตัว|โรคเรื้อรัง|comorbid|medical clearance|special needs|autoimmune|lupus|sjogren|sjögren|ภูมิแพ้|เนื้องอก|ซีสต์|cyst|tumor|oral pathology|รอยโรค|กลัวหมอฟัน|กลัวทำฟัน|กลัวผ่าตัด|กลัวฝังราก|phobia|anxiety|วิตกกังวล|บุหรี่|สูบ|smoking

**เหตุผล:** แปลหกหมวดของ T3 คำต่อคำเข้าโดเมนทันตกรรม: pediatric advice · pregnancy advice · mental health (กลัวหมอฟัน/วิตกกังวล) · cancer-adjacent (มะเร็ง/ฉายรังสี/เนื้องอก/รอยโรค) · post-illness recovery (เบาหวาน/หัวใจ/bisphosphonate-MRONJ/ไต-ตับ/ภูมิคุ้มกันต่ำ) · addiction (บุหรี่). ห้ามใช้ token 'aging' (ชน '3D imaging'). ยิงจริง 86 หน้า — ก้อนใหญ่สุดของ T3 และเป็นก้อนที่ clinical guideline รองรับได้จริงที่สุด

### ข้อ 7 → tier 3 · flag `high`

**เงื่อนไข:** หน้าให้ชุดคำสั่งที่ผู้อ่านลงมือทำเองที่บ้านหลังหัตถการ — regex: หลังถอน|หลังผ่า|หลังฝัง|หลังรักษา|หลังทำ|หลังจัดฟัน|หลังใส่|aftercare|post-op|postop|post-treatment|การฟื้นตัว|พักฟื้น|recovery|ระยะเวลาหาย|กินอะไรหลัง|อาหารหลัง|ดูแลหลัง|maintenance protocol (จงใจไม่จับ 'ดูแล' เดี่ยว ๆ — สุขอนามัยประจำวันไม่ใช่ T3)

**เหตุผล:** T3 คำต่อคำมี 'post-illness recovery'. เส้นแบ่งคือ 'ใครเป็นคนลงมือ': หน้าอธิบายหัตถการ คนลงมือคือหมอ; หน้า aftercare คนลงมือคือคนไข้เอง ตอนตีสาม โดยไม่มีใครแก้ให้ทัน. ยิงจริง 32 หน้า

### ข้อ 8 → tier 3 · flag `high`

**เงื่อนไข:** page_category = condition_pillar (หน้าโรค/อาการ ที่ยังไม่ถูกจับด้วยกฎ 4-7)

**เหตุผล:** หน้าที่ประธานคือโรคหรืออาการคือหน้าที่ผู้อ่านใช้ self-triage ('อันตรายไหม ต้องไปหาหมอหรือยัง') — Google QRG ยกหน้า dental condition เป็นตัวอย่าง YMYL โดยตรง. เลือกใช้ทั้ง category เพราะตรวจได้ด้วยคอลัมน์เดียวและทำซ้ำได้ 100%; ยอมรับ over-classification บนหน้าเชิงความงามราว 8 หน้า (เหงือกดำ · Black Triangle · ฟันเหยิน) — ผิดฝั่งสูงถูกกว่าผิดฝั่งต่ำ. ยิงจริง 73 หน้า (อีก 35 หน้าของ condition_pillar ถูกกฎ 4-7 จับไปก่อนแล้ว)

### ข้อ 9 → tier 2 · flag `medium`

**เงื่อนไข:** ที่เหลือทั้งหมด — service_page/procedure_pillar/technology_page/knowledge_article/evidence_case/local_* ที่ไม่ชนกฎใดข้างบน (หัตถการ เทคนิค วัสดุ เครื่องมือ เคสก่อน-หลัง คู่มือ การเปรียบเทียบ ราคาเชิงตลาด) รวมถึงหน้าใหม่ที่ยังจำแนกไม่ได้

**เหตุผล:** T2 = 'Specific outcome education' คำต่อคำ. หน้า 'ผ่าฟันคุดคืออะไร' คนลงมือคือหมอ ผู้อ่านตัดสินแค่ 'จะไปปรึกษาไหม' — บาร์ที่ถูกคือ clinical_guideline (seo_citations tier 3) ซึ่งเป็น standard of care จริงของทันตกรรม ไม่ใช่การไล่คนเขียนไปหยิบ RCT เดี่ยว ๆ มาปิดตัวนับ. หมายเหตุ hub 68 หน้าใช้กฎเดียวกันทุกข้อ ไม่มีข้อยกเว้น (hub ดมยาสลบ = T4 ตามกฎ 4) แต่หนี้รีวิวของ hub ปลดได้ด้วยรีวิวของหน้าลูกในคลัสเตอร์ ไม่ต้องเปิดคิวใหม่. ยิงจริง 406 หน้า

---

## ต่างจาก deezy อย่างไร

"ต่างกัน 3 จุด และทั้ง 3 จุดเป็นเรื่องที่วัดได้ ไม่ใช่รสนิยม.\n\n**1) แกนของ T4 คนละแกน** — deezy วาง T4 ไว้ที่หน้าเงิน (insurance 20/21 · pricing 17/24 = 37 หน้า) ส่วน DR นี้วาง T4 ไว้ที่หน้ายาเท่านั้น (15 หน้า: GA/IV/nitrous/pediatric GA/ยาหลังทำฟัน/antibiotic prophylaxis/drug dosing). เหตุผลไม่ใช่ 'deezy ผิด' แต่เป็น: ปลายทางของ T4 คือผู้ตรวจ regulator + แหล่งอ้างอิงเชิงกำกับ ซึ่งใช้กับตารางราคาไม่ได้เลย และ deezy พิสูจน์ผลลัพธ์นั้นให้ดูแล้ว — T4 37 หน้า มี 6 หน้าไม่มี citation เลย. ความเสี่ยงของหน้าเงินถูกแบกด้วย legal_review_required ซึ่ง smile-scape ตั้งไว้แล้ว 86 หน้า (evidence 38 · insurance 27 · pricing 16 · อื่น 5 — ยอดนี้ตรวจกับฐานแล้วตรง)\n\n**2) หน่วยของการตัดสินคนละหน่วย** — deezy map ทั้ง page_category (service 145/145 = T3, condition 85/85 = T3, procedure 37/37 = T3, local 99/99 = T3) และปล่อย knowledge_article ปนสามชั้นโดยไม่มีเกณฑ์ให้ตัดสิน. DR นี้ใช้ category เป็นโล่เฉพาะฝั่งที่ category *คือ* คำตอบ (หน้าองค์กร · ประกัน · หน้าโรค) และใช้ trigger เนื้อหา 4 ชุดกับที่เหลือ. ผลที่ต่างชัด: หน้า aftercare / ฉุกเฉิน / กลุ่มเปราะบางที่ฝังอยู่ใน service_page และ knowledge_article ถูกดึงขึ้น T3 (72 + 36 หน้า) ขณะที่หน้าเทคนิคผ่าตัดล้วน ๆ (CAF, VISTA, Sausage, Le Fort I) อยู่ T2 — deezy ทำกลับกันทั้งสองฝั่ง\n\n**3) วัดก่อนตั้งบาร์ ไม่ใช่ตั้งบาร์แล้วค่อยรู้** — จุดที่ deezy ล้มคือ T3 371 หน้าโดยที่ 108 หน้าไม่มี citation tier 1-2 สักใบ และ 99 หน้าไม่มี citation เลย. DR นี้รันบาร์ของตัวเองกับฐานก่อนเขียน: T3 231 หน้า มี **212 หน้าที่ผ่านบาร์อยู่แล้ว** (มี citation_tier ≤3 อย่างน้อย 1 ใบ) เหลือหนี้ 19 หน้า · T4 15 หน้าผ่าน 12 เหลือ 3 · T2 433 หน้าผ่าน 370 เหลือ 63. หนี้รวม 85 หน้า ระบุตัวได้ทุกหน้า — ไม่ใช่เพราะบาร์ต่ำกว่า แต่เพราะบาร์ถูกแปลเป็นคำศัพท์ที่ฐานใช้จริง (clinical_guideline นับ) แทนตัวเลขที่ §32.4 เขียนไว้จากสเกลอื่น.\n\n**สิ่งที่เหมือน deezy โดยตั้งใจ**: หน้าองค์กร (about/doctor/contact/home/branch) = T1 และ technology_page ส่วนใหญ่ = T2 — สองอันนี้ deezy อ่านถูก และ DR นี้ได้คำตอบเดียวกันโดยเดินคนละทาง (deezy ใช้ category, DR นี้ใช้ 'ไม่มีคำสั่งให้ผู้อ่านลงมือทำ')."

---

## 🔴 คำถามที่กฎตัดสินเองไม่ได้ ต้องให้ operator ชี้

**1.** **§32.4 คอลัมน์ citation เขียนจากสเกลคนละอัน — ใครเป็นคนรับรองการอ่านใหม่?** ตัวบทเขียน T3='tier 1-2 (PubMed, clinical guidelines)' และ T4='tier 1 only (gov + clinical)' แต่สเกลจริงใน seo_citations คือ tier1=meta_analysis/systematic_review · tier2=rct · tier3=clinical_guideline · tier4=regulatory_document. อ่านตามตัวเลขตรง ๆ = T3 ห้ามใช้ clinical guideline และ T4 ห้ามใช้เอกสารราชการ ซึ่งกลับหัวกับเจตนาในวงเล็บของตัวบทเอง. DR นี้อ่านว่า 'วงเล็บคือของจริง ตัวเลขคือสเกลเก่า' → T2/T3 รับ citation_tier ≤3, T4 รับ tier 3-4. ถ้าเจ้าของ Bible ตัดสินว่าตัวเลขคือของจริง กฎนี้ต้องเขียนบาร์ใหม่ทั้งฉบับ

**2.** **มีทันตแพทย์ตัวจริงที่จะเซ็น 246 หน้า (T3 231 + T4 15) ไหม และคนไหน?** วัดวันนี้: smile-scape มี seo_editorial_reviews 728 แถว review_type='medical' ทั้งหมด **pending 100% · approved 0** และทั้งเฟเดอเรชัน 2,099 แถวมี review_type แค่ 'medical' กับ 'editorial' — **legal_compliance = 0 แถว** ทั้งที่ DR-030 เพิ่มค่านี้เข้า enum ตั้งแต่ 2026-05-20. ถ้าไม่มีผู้ตรวจกฎหมาย/ระเบียบตัวจริง 15 หน้า T4 คือธงที่ไม่มีปลายทาง — จะยอมให้ค้างเป็นหนี้ที่มองเห็นได้ หรือให้ถอย T4 ไปใช้ legal_review_required อย่างเดียวก่อน

**3.** **การขออนุมัติโฆษณาสถานพยาบาลไม่ได้อยู่ในคอลัมน์นี้และ DR นี้ไม่แก้ให้** — ภาพก่อน-หลัง 38 หน้า (evidence_case) + คำรับประกันตลอดชีพ + ตารางราคา 16 หน้า ถูกจัดเป็น T2/T1 เพราะไม่มีคำสั่งทางคลินิก. ถ้าจะจัดการความเสี่ยงโฆษณาจริงต้องมีฟิลด์ของตัวเอง (สถานะ/เลขที่อนุมัติโฆษณา) — CLAUDE.md ระบุ 'compliance review of before-after photos + guarantee wording' ค้างอยู่แล้ว. operator ต้องตัดสินว่าจะเปิดฟิลด์นั้นหรือปล่อยให้ legal_review_required=true 86 หน้าแบกไปก่อน

**4.** **has_medical_review = true ทั้ง 728 หน้า ทั้งที่ 727 หน้ายัง status='Planned' และรีวิวทุกแถวยัง pending** — ฟิลด์นี้โกหกอยู่แล้วในฐาน. DR นี้จงใจไม่พึ่งมันเลย แต่ operator ต้องตัดสินว่าจะรีเซ็ตให้ derive จาก approved review หรือปล่อยไว้ (ถ้าปล่อย ห้ามมี rule/dashboard ไหนอ่านมันอีก)

**5.** **หน้าราคาอยู่สองที่คนละชั้น โดยตั้งใจ** — pricing_page 16 หน้า = T1 (กฎ 1) แต่ knowledge_article ที่พูดราคาตลาด ('ราคาปลูกกระดูกฟันในไทย', 'ค่าใช้จ่าย All-on-4 ในไทย') = T2 (กฎ 9). ถ้า operator ไม่ยอมรับ ทางแก้คือแก้ page_category ของหน้าเหล่านั้น ไม่ใช่แก้กฎ — บอกมาว่าจะแก้ฝั่งไหน

**6.** **หน้าเครื่องมือที่มีคำกล่าวอ้างเรื่องรังสีและความปลอดภัย ถูกวางไว้ T2** — CBCT / Panoramic X-ray / Intraoral X-ray ('Low-dose') · Piezoelectric Surgery · PRF Centrifuge (ผลิตภัณฑ์จากเลือดคนไข้) · มาตรฐานการฆ่าเชื้อ. เหตุผล: ผู้อ่านไม่ได้ลงมือทำอะไร คลินิกเป็นคนใช้เครื่อง. หัวหน้าคลินิกรับเส้นนี้ไหม (หน้า 'เอกซเรย์ตอนตั้งครรภ์' ยังเป็น T3 ด้วยกฎ 6 อยู่แล้ว)

**7.** **ทั้ง 728 แถวเป็น page_language='th' — ไม่มีแถว en/zh-cn เลย** DR นี้จึงจงใจ **ไม่มี** ข้อ 'jurisdictional medical claims / dental tourism' เพราะกฎที่แมตช์ 0 แถวคือกฎที่ทดสอบไม่ได้และจะทำงานเงียบ ๆ ทีหลัง. operator ต้องตัดสินตอนสร้างแถว en/zh: tier สืบทอดจากแถวไทย หรือคำนวณใหม่ (หน้า /en/ ของ 'ราคา All-on-X' คือเคส dental-tourism ตัวจริง)

**8.** **เลข DR** — เสนอเป็น DR-065 (DR-064 landed 2026-08-26) แต่ต้องยืนยันกับ registry ก่อนวางลง DECISION_RECORDS.md และแจ้ง deezy/vth ให้ตรวจรับตามธรรมเนียม

---

## เนื้อ DR ที่ร่างไว้ (พร้อมวางถ้าอนุมัติ)

### [DR-065] — Clinic Reading of DR-030 §1: ชั้นความอ่อนไหวของหัวข้อ สำหรับแบรนด์สถานพยาบาลที่ให้บริการรักษาจริง (2026-09-04) ⚖️🦷

**Status:** **Proposed** — เสนอโดย smile-scape-clinic · รอ operator รับรอง · รอ deezy/vth ตรวจรับ (เลข DR รอยืนยันกับ registry)
**Bible Reference:** Part 32.2 (นิยาม 4 ชั้น) · Part 32.4 (workflow mapping) · Part 32.9 / DR-030 §8 (retrofit policy) · Part 23.1 (citation 6 tiers)
**Schema Reference:** ไม่มีการเปลี่ยนสคีมา — ใช้คอลัมน์ที่ DR-030 v1.17 สร้างไว้แล้วทั้งหมด
**Companion to:** DR-030 (ตัวแม่ — DR นี้เป็น *การอ่าน* ไม่ใช่การแก้) · DR-057 §6 (ยกเลิก block-publish เหลือ routing) · DR-019 (schema taxonomy) · DR-064 (หน้าราคาแยกจากหน้าหลัก)
**Scope:** **UNIVERSAL สำหรับ cohort เดียว** — แบรนด์ที่เป็นสถานพยาบาลและลงมือรักษาจริง (คลินิกทันตกรรม/เวชกรรม). ไม่แตะแบรนด์สินค้า. ชั้นแรกที่ใช้จริงคือ smile-scape-clinic 728 หน้า

---

**Context — ทำไมเอกสารเดิมตอบไม่ได้**

DR-030 §1 ให้ตัวอย่างของทั้ง 4 ชั้นเป็นโดเมนอาหารเสริม/เครื่องสำอางทั้งหมด (DR เกิดจาก HP100 แบรนด์อาหารเสริมหลังบำบัดยาเสพติด) — ไม่มีบรรทัดไหนพูดถึง "หน้าที่อธิบายหัตถการที่คลินิกลงมือทำกับคนไข้จริง" ซึ่งคือ 537/728 หน้าของ smile-scape. ผลคือคนสองคนอ่านตัวบทเดียวกันแล้วได้คำตอบห่างกันสองชั้นบนหน้าเดียวกัน และตัวบทเองก็ไม่มีถ้อยคำให้ตัด.

ช่องว่างที่ตามมาอีก 4 ข้อ ซึ่งวัดได้ทั้งหมดเมื่อ 2026-09-04:

1. **§32.4 เขียนบาร์ citation จากสเกลคนละอันกับฐาน** — ตัวบทเขียน T3 = "1-2 (PubMed, clinical guidelines)" และ T4 = "1 only (gov + clinical)" แต่สเกลจริงใน `seo_citations` คือ `tier1=meta_analysis(200)/systematic_review(128) · tier2=rct(38) · tier3=clinical_guideline(55) · tier4=regulatory_document(20) · tier5=cohort · tier6=expert_opinion`. อ่านตามตัวเลขตรง ๆ จะได้ผลลัพธ์ที่กลับหัวกับวงเล็บของตัวบทเอง: **T3 ห้ามใช้ clinical guideline** (ซึ่งเป็น standard of care ตัวจริงของทันตกรรม) และ **T4 ห้ามใช้เอกสารราชการ** (ซึ่งเป็นแหล่งเดียวที่หน้าประกันสังคมมี). กฎจำแนกใด ๆ ที่เขียนก่อนแก้ข้อนี้ จะผลักคุณภาพหลักฐานลง ไม่ใช่ขึ้น
2. **ค่าตั้งต้นระดับแบรนด์ที่ §8 อ้างถึง ไม่เคยถูกตั้ง** — `brands.compliance_profile` = NULL ทั้ง 20 แบรนด์ · `positioning_mode` = NULL ทั้ง 3 แบรนด์ทันตกรรม
3. **มิติ product ไม่แยกอะไรได้เลย** — `product_regulatory_tier` = 1 ครบ 1,432 หน้าทั้งฐาน (smile-scape 728/728) → `compliance_max_tier` = `content_topic_tier` เสมอสำหรับ cohort นี้
4. **บาร์ที่ประกาศแล้วไม่มีใครทำถึง เป็นหลักฐานเอาผิดตัวเอง** — มีบรรทัดฐานในเฟเดอเรชันแล้วว่า การ map ทั้ง page_category ขึ้น T3 โดยไม่วัดก่อน จบลงที่ 108 หน้าติดธง T3 ที่ไม่มี citation tier 1-2 สักใบ (ใช้เป็น **ข้อมูลเปรียบเทียบ** ไม่ใช่บรรทัดฐาน — แบรนด์นั้นไม่มี compliance_profile รองรับด้วย)

---

**Decision**

#### 0. หลักการเดียวที่ DR นี้ยืนอยู่

> `content_topic_tier` ให้เกรดสิ่งเดียว: **"ผู้อ่านจะเอาหน้านี้ไปทำอะไรกับร่างกายตัวเอง ตอนที่ไม่มีทันตแพทย์อยู่ตรงนั้น"**
> — ไม่ใช่ความเสี่ยงเชิงพาณิชย์/โฆษณา (คอลัมน์นั้นคือ `legal_review_required` ที่ DR-030 §2 สร้างไว้แล้ว และตั้งไว้แล้ว 86 หน้า)
> — ไม่ใช่ `page_category`

#### 1. ตารางตัดสิน — ตรวจตามลำดับ ข้อแรกที่เข้าเงื่อนไขชนะ

| # | เงื่อนไข (ตรวจได้จากคอลัมน์ + ชื่อ/seo_title/slug) | tier | flag | ยิงจริง |
|---|---|---|---|---|
| 1 | `page_category ∈ {home,about,contact,branch_landing,doctor_profile,pricing_page}` **และ** `legal_review_required = true` | 1 | medium | 17 |
| 2 | `page_category ∈` ชุดเดียวกัน (ที่เหลือ) | 1 | none | 32 |
| 3 | `page_category = insurance_page` | 2 | medium | 27 |
| 4 | ชนกลุ่ม **ยาที่ต้องมีผู้สั่งจ่าย/ผู้ให้ยาที่มีใบอนุญาต** | **4** | critical | 15 |
| 5 | ชนกลุ่ม **ฉุกเฉิน / ตัดสินความเร่งด่วน / สัญญาณอันตราย** | 3 | high | 40 |
| 6 | ชนกลุ่ม **กลุ่มเปราะบาง / โรคประจำตัว / โรคร้ายแรง** | 3 | high | 86 |
| 7 | ชนกลุ่ม **คำสั่งดูแลตัวเองหลังหัตถการ** | 3 | high | 32 |
| 8 | `page_category = condition_pillar` (ที่เหลือ) | 3 | high | 73 |
| 9 | ที่เหลือทั้งหมด + หน้าใหม่ที่ยังจำแนกไม่ได้ | 2 | medium | 406 |

`sensitive_topic_flag` ผูกกับ tier แบบ 1→none · 2→medium · 3→high · 4→critical **ยกเว้นข้อเดียว** คือแถว 1 (T1 ที่ถือข้อผูกพันเชิงกฎหมาย → medium ไม่ใช่ none). ค่า `'low'` ไม่ถูกใช้ในแบรนด์นี้โดยตั้งใจ — ไม่มีอะไร route บนมัน

#### 2. Classifier ที่ทำซ้ำได้ (รันได้วันนี้ ไม่ต้องรอ body)

```sql
-- WHERE brand_id='smile-scape-clinic'; t = lower(page_name||' '||seo_title||' '||slug)
CASE
 WHEN page_category IN ('home','about','contact','branch_landing','doctor_profile','pricing_page') THEN 1
 WHEN page_category = 'insurance_page' THEN 2
 WHEN t ~ 'sedation|anesthe|anaesth|ดมยา|ยาสลบ|วิสัญญ|nitrous|แก๊สหัวเราะ|ไนตรัส|ยาแก้ปวด|ยาที่ใช้|antibiotic|ยาปฏิชีวนะ|drug dosing|opioid|ยานอนหลับ|ยาคลายกังวล' THEN 4
 WHEN t ~ 'ฉุกเฉิน|emergency|เลือดไม่หยุด|เลือดออกไม่หยุด|hemostat|ปวดมาก|ปวดรุนแรง|กลางคืน|คืนนี้|หนอง|abscess|บวม|swelling|ฟันหลุด|ฟันหัก|ฟันแตก|อุบัติเหตุ|trauma|เมื่อไหร่ต้อง|เมื่อไรต้อง|เมื่อไหร่ควรมาพบ|เมื่อไหร่ผิดปกติ|when to come back|สัญญาณเตือน|red flag|ติดเชื้อ|infection|pericoronitis|pulpitis|แพ้ยา|แพ้โลหะ|แพ้ไหม|allerg' THEN 3
 WHEN t ~ 'เด็ก|ทารก|ฟันน้ำนม|pediatric|kids|ขวบ|ของลูก|ดูดนิ้ว|อมจุก|ตั้งครรภ์|pregnan|ให้นมบุตร|breastfeed|หลังคลอด|ผู้สูงอายุ|สูงวัย|geriatric|senior|เบาหวาน|diabet|hba1c|โรคหัวใจ|cardiac|endocarditis|ความดัน|ยาละลายลิ่มเลือด|anticoagul|bisphosphonate|denosumab|mronj|กระดูกพรุน|osteopor|ภูมิคุ้มกัน|immunocompromis|hiv|มะเร็ง|cancer|เคมีบำบัด|chemo|รังสีรักษา|ฉายรังสี|radiation|orn risk|ฟอกไต|renal|hepatic|โรคไต|ตับ|โรคประจำตัว|โรคเรื้อรัง|comorbid|medical clearance|special needs|autoimmune|lupus|sjogren|sjögren|ภูมิแพ้|เนื้องอก|ซีสต์|cyst|tumor|oral pathology|รอยโรค|กลัวหมอฟัน|กลัวทำฟัน|กลัวผ่าตัด|กลัวฝังราก|phobia|anxiety|วิตกกังวล|บุหรี่|สูบ|smoking' THEN 3
 WHEN t ~ 'หลังถอน|หลังผ่า|หลังฝัง|หลังรักษา|หลังทำ|หลังจัดฟัน|หลังใส่|aftercare|post-op|postop|post-treatment|การฟื้นตัว|พักฟื้น|recovery|ระยะเวลาหาย|กินอะไรหลัง|อาหารหลัง|ดูแลหลัง|maintenance protocol' THEN 3
 WHEN page_category = 'condition_pillar' THEN 3
 ELSE 2 END
-- sensitive_topic_flag = CASE tier WHEN 1 THEN (CASE WHEN legal_review_required THEN 'medium' ELSE 'none' END)
--                                  WHEN 2 THEN 'medium' WHEN 3 THEN 'high' ELSE 'critical' END
```

**Token ที่ห้ามใส่ (false positive ที่จับได้จริงตอนทดสอบ):** `ฝี` (ชน "ริม**ฝี**ปาก" → Frenectomy) · `aging` (ชน "3D im**aging**" → Acteon CBCT) · `แพ้` เดี่ยว (ชนสำนวน "สำคัญไม่**แพ้**กระดูก") · `prophylaxis` เดี่ยว (ชน "EMS Airflow **Prophylaxis** System" = ขัดฟัน ไม่ใช่ยา)

#### 3. §32.4 แปลกลับเป็นคำศัพท์ที่ฐานใช้จริง (การ *อ่าน* ไม่ใช่การแก้)

วงเล็บของตัวบทคือเจตนา ตัวเลขคือสเกลเก่า — "PubMed, clinical guidelines" และ "gov + clinical" ระบุ *ชนิดแหล่ง* ไว้ชัด:

| tier | ผู้ตรวจ | หลักฐานที่ยอมรับ (คำศัพท์ `seo_citations` จริง) | schema.org |
|---|---|---|---|
| 1 | ไม่บังคับ | ไม่บังคับ citation | ใดก็ได้ (ห้ามอ้าง Medical* claim) |
| 2 | ทันตแพทย์ในคลินิก — *แนะนำ* | ≥1 ใบ `citation_tier ≤ 3` (meta/SR, RCT, **clinical_guideline**) ที่ `supports_claim` ตรงกับข้อกล่าวอ้างหลัก | Article / MedicalWebPage / MedicalProcedure / MedicalCondition |
| 3 | **ทันตแพทย์ระบุชื่อเซ็น** (แถว `approved=true`, `review_type='medical'`) + editorial | ≥1 ใบ `citation_tier ≤ 3` ที่รองรับ *คำสั่งที่ผู้อ่านทำเอง* หรือ *ข้อบ่งชี้/ข้อห้ามของกลุ่มเปราะบาง* | เดิม + Medical* — อาศัยข้อยกเว้นที่ §32.4 เขียนไว้เองว่า *"no MedicalCondition schema **unless explicit educational angle**"* (หน้าโรคของคลินิกคือ educational angle ตรงตัว) |
| 4 | เดิม + ผู้ตรวจกฎหมาย/ระเบียบ (`review_type='legal_compliance'`) | ≥1 ใบ `citation_tier ∈ {3,4}` (clinical_guideline หรือ **regulatory_document**) ที่พูดถึงตัวยา/การให้ยาโดยตรง | เดิม + ห้าม `Drug` |

#### 4. สิ่งที่ DR นี้ **ไม่** แตะ (โดยตั้งใจ)

- **ไม่แก้ §8 retrofit** — `content_topic_tier_default = 1` ของ cohort baseline อยู่ได้เหมือนเดิม เพราะไม่มีหน้าไหนอาศัยค่า default: ตารางนี้ให้ค่าครบทั้ง 728 แถว. (ยังต้องตั้ง `compliance_profile` + `positioning_mode='baseline'` ตามตัวบท — ดู Consequences)
- **ไม่แตะ `product_regulatory_tier`** — คลินิกไม่ได้ขายสินค้า คงเป็น 1 ทั้ง 728 หน้า
- **ไม่มีข้อ jurisdictional / dental tourism** — ทั้ง 728 แถวเป็น `page_language='th'` กฎที่แมตช์ 0 แถวคือกฎที่ทดสอบไม่ได้
- **ไม่ฟื้น block-publish** — DR-057 §6 ยกเลิกไปแล้ว DR นี้ให้แต่ routing
- **ไม่พึ่ง `has_medical_review`** — ฟิลด์นี้เป็น `true` ทั้ง 728 หน้า ทั้งที่ 727 หน้ายัง `Planned` และรีวิวทุกแถวยัง pending

---

**สภาพจริงที่วัดได้ (รันกับ `lffcbeszjqzioobqfdav` เมื่อ 2026-09-04)**

| สิ่งที่วัด | ค่า |
|---|---|
| หน้าทั้งหมด `brand_id='smile-scape-clinic'` | **728** (ไม่ใช่ 727) · `status='Planned'` 727 · `Merged` 1 |
| `content_topic_tier` / `sensitive_topic_flag` | NULL ครบ 728 ทั้งคู่ |
| `product_regulatory_tier` / `compliance_max_tier` | = 1 ครบ 728 ทั้งคู่ |
| `legal_review_required = true` | 86 — evidence_case 38 · insurance 27 · pricing 16 · service 2 · knowledge 1 · about 1 · procedure 1 |
| `has_medical_review = true` | **728/728** ขณะที่ยังไม่มีหน้าไหนถูกเขียน |
| page_category (15 หมวด รวม 728) | service 213 · knowledge 184 · condition 108 · technology 66 · evidence 38 · procedure 33 · insurance 27 · about 22 · pricing 16 · doctor 7 · local_service 6 · local_landing 4 · branch 2 · home 1 · contact 1 |
| หน้า hub (`page_name ILIKE '%(hub)%'`) | 68 |
| รีวิวของ smile-scape ใน `seo_editorial_reviews` | 728 แถว · `review_type='medical'` ทั้งหมด · **pending 100% · approved 0** |
| `review_type` ที่มีจริงทั้งเฟเดอเรชัน (2,099 แถว) | `'medical'`, `'editorial'` เท่านั้น — **`legal_compliance` = 0 แถว** · อนุมัติสะสมตลอดกาล medical 418 · editorial 41 |
| citation ที่ผูกกับ smile-scape | 1,833 แถว · 361 แหล่งไม่ซ้ำ · `supports_claim` เต็ม 1,833/1,833 · แหล่งที่ถูกแปะบน ≥15 หน้า = 19 แหล่ง · สูงสุด 22 หน้า/แหล่ง |

**ผลของการรัน classifier (728 = 49 + 433 + 231 + 15):**

| tier | หน้า | flag | `legal_review_required` ในชั้นนี้ | ผ่านบาร์หลักฐานแล้ว (มี `citation_tier ≤3` ≥1 ใบ) | **หนี้** |
|---|---|---|---|---|---|
| 1 | 49 | none 32 / medium 17 | 17 | — (ไม่บังคับ) | 0 |
| 2 | 433 | medium | 63 | 370 | **63** (20 หน้าไม่มี citation เลย) |
| 3 | 231 | high | 6 | 212 | **19** (3 หน้าไม่มี citation เลย) |
| 4 | 15 | critical | 0 | 12 | **3** |

> ✅ **`compliance_max_tier` ไม่ต้องมีใครเขียน** — ตรวจ `information_schema` แล้ว: `is_generated = ALWAYS`, `generation_expression = GREATEST(product_regulatory_tier, content_topic_tier)` (ตรงกับที่ DR-030 §2 ประกาศไว้). วันนี้มันเป็น 1 ทั้ง 728 แถวเพราะ `content_topic_tier` เป็น NULL เท่านั้น — วินาทีที่เขียน tier ลงไป มันขยับเอง ไม่มี write path ให้ลืม

---

**Rationale**

1. **คอลัมน์ต้องบรรทุกข้อมูลที่คอลัมน์อื่นไม่มี** — ถ้า T4 ถูกนิยามให้เท่ากับชุด `legal_review_required` มันคือคอลัมน์ซ้ำ และจะตายแบบเดียวกับ `product_regulatory_tier` ที่เป็น 1 ครบ 1,432 แถวจนแยกอะไรไม่ได้. DR นี้จึงแยกสองแกนออกจากกันชัด ๆ: **แกนร่างกาย → tier · แกนกฎหมาย/พาณิชย์ → `legal_review_required`** (86 หน้าคงไว้ทุกหน้า ไม่แตะ)
2. **ตัวบทให้เส้นมาแล้วสองเส้น ไม่ใช่เส้นเดียว** — T3 ระบุทั้งหมวดประชากร (*pediatric/pregnancy advice*) และหมวดคำแนะนำ (*post-illness recovery*). อ่านเอาแต่หมวดประชากรจะทำ aftercare/ฉุกเฉินหล่นทั้งชั้น; อ่านเอาแต่ "อันตรายไหม" จะดันหน้าผ่าตัดทั้งเว็บขึ้น T3. กฎ 5-8 คือการหยิบทั้งสองเส้นมาใช้พร้อมกัน
3. **บาร์ต้องเขียนด้วยคำที่ฐานใช้** — ดู §3 ข้างบน. นี่คือความต่างที่ทำให้หนี้ T3 เหลือ 19 หน้าแทนที่จะเป็นหลักร้อย ไม่ใช่เพราะบาร์ต่ำลง แต่เพราะ `clinical_guideline` (EFP S3 / AAE / AAPD) ถูกนับตามที่วงเล็บของตัวบทตั้งใจตั้งแต่แรก
4. **จำแนกด้วยสิ่งที่มีอยู่วันนี้** — 727/728 หน้ายัง `Planned` และ `content_brief` สั้นกว่า 80 ตัวอักษรทั้งฐาน. กฎที่สั่งให้ "อ่านบล็อกที่ชิปจริง" รันไม่ได้เลยวันนี้; กฎนี้อ่านชื่อ/สลัก/หมวด ซึ่งมีจริงทั้ง 728 แถว แล้วประกาศให้ค่าที่ได้เป็น **provisional** และคำนวณซ้ำตอนหน้าเปลี่ยนเป็น `Live`
5. **ธงกับกำลังตรวจต้องอยู่ในสายตาเดียวกัน** — จึงต้องรายงานตรง ๆ ว่า T3+T4 = 246 หน้า ยืนอยู่บนแบรนด์ที่มี approved review = 0 (ดู Consequences)

---

**Consequences**

**หนี้ที่กฎนี้สร้าง — พูดตรง ๆ ไม่กลบ**

- ⚠️ **หนี้ผู้ตรวจ 246 หน้า** = T3 231 + T4 15 ต้องมีทันตแพทย์ระบุชื่อเซ็น. วันนี้ smile-scape มีรีวิว 728 แถว **pending 100% · approved 0** และทั้งเฟเดอเรชันอนุมัติ medical ได้ 418 แถวตลอดกาล. ธงนี้จะไม่บล็อกการพับลิช (DR-057 §6) แปลว่ามันจะค้างเงียบ ๆ ได้ถ้าไม่มีใครไล่เก็บ — ถ้าผ่านไปหนึ่งไตรมาสแล้ว approved ยังเป็น 0 ให้ถือว่ากฎนี้ล้มเหลวเชิงปฏิบัติและต้องหด T3 ลงเหลือเฉพาะกฎ 5+7 (72 หน้า)
- ⚠️ **หนี้ผู้ตรวจกฎหมาย 15 หน้าไม่มีเจ้าหนี้** — `review_type='legal_compliance'` มี **0 แถวใน 2,099** ทั้งที่ DR-030 เพิ่มค่านี้เข้า enum ตั้งแต่ 2026-05-20. ถ้า operator ไม่ตั้งคนจริง ให้ถอย T4 ทั้ง 15 หน้าลงเป็น T3 + `legal_review_required=true` แทนการปล่อยธงลอย
- ⚠️ **หนี้หลักฐาน 85 หน้า ระบุตัวได้ทุกหน้า** — T2 63 · T3 19 · T4 3 (ในนั้น 23 หน้าไม่มี citation เลย). เล็กกว่าที่กลัวเพราะบาร์นับ clinical_guideline — ไม่ใช่เพราะกฎผ่อน
- ⚠️ **หนี้ที่ตัวเลขข้างบนยัง *มองไม่เห็น*** — "มี citation tier ≤3 อย่างน้อย 1 ใบ" เป็นการนับระดับ *หน้า*. วัดแล้วพบว่า 19 แหล่งถูกแปะบน ≥15 หน้า และแหล่งเดียวสูงสุดกินไป 22 หน้า → หน้าที่ "ผ่าน" อาจแบก SR ที่ไม่ได้ค้ำข้อความบนหน้านั้นเลย. หน่วยที่ถูกคือ `supports_claim` (เต็ม 1,833/1,833 แถว รอใครใช้) — **การตรวจจริงต้องทำระดับ claim ก่อนประกาศว่าผ่านบาร์**

**ผลดีที่วัดได้**

- ✅ **คิว medical review 728 คิวที่ไม่แยกอะไรเลย กลายเป็น 246 คิวบังคับ + 482 คิวที่ปิดด้วยการตรวจแบบเบา** — นี่คือประโยชน์ตรงตัวของ DR-030 §3 ที่ยังไม่เคยได้ใช้กับแบรนด์นี้
- ✅ **ไม่ต้องแก้สคีมา ไม่ต้องแก้ Bible** — §32.4 คอลัมน์ schema ใช้ข้อยกเว้น *"unless explicit educational angle"* ที่ตัวบทเขียนไว้เอง (สำคัญเพราะ smile-scape มี `schema_markup_type` ที่ไม่ใช่ `Article` อยู่ 446 หน้า และเทมเพลตที่ deploy แล้วยิง MedicalProcedure/MedicalWebPage/HowTo ออกไปจริง); คอลัมน์ citation ใช้การแปลสเกล ไม่ใช่การแก้ตัวเลข
- ✅ **`compliance_max_tier` ตามให้เอง** — generated column, ไม่มี write path ให้ลืม
- ✅ **ต้นทุนจริงเป็นระดับบล็อก ไม่ใช่รายหน้า** — SmileScape เรนเดอร์ B-blocks ร่วมกันข้ามหลายร้อยหน้า (B89 CareTimeline · B91 MedicationSchedule · B90 CrisisDisclosure · B87 CoverageTable). ให้ตรวจ **บล็อก** ครั้งเดียวแล้วให้หน้าที่ใช้บล็อกนั้นอ้างผลการตรวจ — หนี้ 246 หน้าจึงไม่ใช่ 246 การอ่านเอกสารแยกกัน. เช่นเดียวกับ hub 68 หน้า: จัดชั้นด้วยกฎเดียวกันทุกข้อ แต่หนี้รีวิวปลดด้วยรีวิวของหน้าลูกในคลัสเตอร์

**Follow-ups บังคับ**

1. ตั้ง `brands.compliance_profile` + `positioning_mode='baseline'` ให้ smile-scape ตาม DR-030 §8 คำต่อคำ (วันนี้ NULL ทั้ง 20 แบรนด์) — ไม่ใช่การเบี่ยงจากตัวบท เป็นการทำตามตัวบทที่ยังไม่เคยทำ
2. เขียนค่า tier + flag ด้วย UPDATE เดียวจาก classifier §2 แล้ว **บันทึกวันที่รันไว้** ค่าเป็น provisional
3. คำนวณซ้ำตอนหน้าเปลี่ยนเป็น `status='Live'` — ไม่ใช่ backfill ครั้งเดียวจบ. เพิ่มบล็อกจากกฎ 4-7 ลงหน้า T2 = หน้านั้นเลื่อนชั้นทันที
4. ตรวจระดับ `supports_claim` บน 246 หน้า T3+T4 ก่อนประกาศว่าผ่านบาร์
5. แจ้ง deezy/vth: cohort เดียวกัน อ่านตารางนี้แล้วบอกว่าไม่เห็นด้วยตรงไหน

---

**References**

- DR-030 §1 (นิยาม 4 ชั้น — ตัวบทที่ DR นี้อ่าน) · §2 (คอลัมน์ + `compliance_max_tier` generated) · §3 (workflow mapping ที่ DR นี้แปลสเกล) · §8 (retrofit — cohort dental = baseline)
- DR-057 §6 (ยกเลิก block-publish; เหลือ routing) · DR-019 (schema taxonomy) · DR-064 (หน้าราคาแยกจากหน้าหลัก — เหตุผลที่ `pricing_page` เป็น category ของตัวเอง)
- Bible Part 23.1 (citation 6 tiers) · Part 32.2 / 32.4 / 32.9
- External: [Google YMYL Quality Rater Guidelines](https://static.googleusercontent.com/media/guidelines.raterhub.com/en//searchqualityevaluatorguidelines.pdf) — ทั้งตัวอย่างหน้าโรคทางทันตกรรมที่ Google จัดเป็น YMYL และภาษา spectrum ("many or most topics are not YMYL") ซึ่งเป็นขาที่ชั้น T2 ยืนอยู่
- Live DB `lffcbeszjqzioobqfdav` — ทุกตัวเลขในหัวข้อ "สภาพจริงที่วัดได้" รันเมื่อ 2026-09-04 · classifier §2 ทำซ้ำได้ตรงตัว
- `brands/eywa-smile-scape/CLAUDE.md` — ข้อค้าง "compliance review of before-after photos + guarantee wording" ที่ DR นี้ **ไม่** แก้ให้
