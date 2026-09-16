# Entity summary audit — ช่วง D2 (wave 16ci, 2026-09-17)

## ขอบเขต/วิธี

- seo_entity_graph live 710 · แตะได้ (brand_scope `*` หรือ smile-scape-clinic) 668 · มี ai_entity_summary 612 → **อ่านเทียบเกณฑ์ครบ 612** (inline 16 batch ไม่ใช้ agent) · other-brand-only 42 ไม่แตะ · ไม่มี summary 56 (หน้าเราใช้ 28 → D4)
- เกณฑ์ (จาก COMMENT: "neutral brief used as schema.org description … Must be sourced, not invented" + บรรทัดฐาน All-on-5 2026-09-10): ผ่าน = นิยามกลาง ขอบเขตถูก ไม่มีตัวเลข/ผลลัพธ์/ความเหนือกว่า/ความปลอดภัย/ราคา ที่ไม่มีแหล่ง · ข้ออ้างที่ **ขัดกับ key_findings ของ citation ใน pool** (ตรวจ PubMed แล้วในช่วง C) = แก้ · คำบอกความถี่ระดับตำรา ("มักเกิดจากคราบจุลินทรีย์") ยอมรับ ถ้าไม่ใช่ผลลัพธ์การรักษา
- heuristic เชิงกล flag 360 แต่ตัดสินจริงต้องอ่านทั้งหมด: false positive สูง (เช่น OPG "ทั้งปาก" ถูก) และ false negative มี (device ที่ flag ว่าง แต่มี vendor claim)

## ผล

- ผ่าน **472** · ต้องแก้ **140** (ผูกกับหน้า smile-scape 39 · ไม่ผูก 101)
- ประเภท defect (นับซ้ำได้): benefit 57 · contradicts_source 12 · superior 10 · meta_leak 10 · length 8 · safety 8 · factual 7 · marketing 7 · price 7 · number 7 · dup 7 · hedge 5 · freq 5 · overclaim 4 · tone 3 · vendor_benefit 3 · scope 2 · subjective 2 · vendor_superior 2 · vendor 2 · contradicts 2 · language 2 · absolute 2 · offtopic 1 · cost 1 · compliance 1 · ad_claim 1 · price_marketing 1
- ตาม entity_type: treatment 35 · procedure 33 · concept 28 · device 20 · condition 13 · specialty 3 · symptom 3 · technology 2 · anatomy 1 · drug 1 · organization 1

### รูปแบบที่พบซ้ำ (สำหรับ Bible/ETL)

1. **editorial/verification note หลุดใน public text** 9 ตัว (Clarius, Exion, GBT, Botox, healthy-aging, student-stress, physiotherapist, poor-recovery, regenerative-facial) — ข้อความแบบ "ควรตรวจสอบเพิ่มเติมก่อนเผยแพร่" อยู่ใน schema description → ต้องมี gate ตรวจ pattern "หมายเหตุ:|ควรตรวจสอบ|ไม่มีแหล่งอ้างอิงที่ให้มา|อ้างอิงจาก" ก่อน emit
2. **ข้อความภาษาอังกฤษ** 2 ตัว (jaw-cyst-surgery, gingivitis-treatment) ในตารางที่เหลือเป็นไทยทั้งหมด
3. **device/vendor entity** เคลม "แม่นยำกว่า/ปลอดภัย/เจ็บน้อย/หายเร็ว/คุ้มค่า" โดยไม่มีแหล่ง — เกือบทุกตัวใน device + laser procedure
4. **ราคา** ("ราคาย่อมเยา/คุ้มค่า/ราคาถูก") 7 ตัว — ขัดนโยบายไม่พูดราคา
5. **ขัด key_findings ใน pool** (ตัวอย่าง): All-on-4/6 "ทั้งปาก" · self-ligating "ลดจำนวนครั้งปรับ" (23299650) · flossing (25639826) · pregnancy↔preterm (39396142) · night guard/occlusal "ลดปวด TMJ" (39282765) · tinnitus (39290041) · mini-implant (33571327) · in-office whitening (40485133) · light-activated whitening (29893625) · immediate implant "รักษากระดูก" · CBCT "รังสีต่ำ" (41500761)
6. **ประโยคเด็ดขาดไม่ hedge** ("ฟันจะโยกและหลุดในที่สุด") — แก้เป็น "อาจ"
7. **ยาวเกิน** >400 ตัวอักษร 45 ตัว (สูงสุด 783) — schema description ควรสั้น; แก้เฉพาะที่ยาวเพราะยัดวิจัย/note

### entity ซ้ำที่พบระหว่างอ่าน (dedupe ทีหลัง — ต้องรัน similarity layer ก่อนตาม SOP)

- `cbct-scan` — DUP: cbct-scan ซ้ำกับ cbct (#27) — ข้อความขัดกันเรื่อง dose; dedupe ภายหลัง
- `aligner-vs-braces` — DUP: aligner-vs-braces ↔ braces-vs-aligner (#239)
- `pregnancy-dental` — DUP: pregnancy-dental ↔ pregnancy-dental-care (#141) · ยาว 432
- `deep-cleaning` — DUP: deep-cleaning ↔ deep-scaling (#77)
- `scaling` — DUP: scaling ↔ dental-scaling (#58) ↔ scaling-polishing (#459)
- `nightlase-snoring` — DUP: nightlase-snoring ↔ nightlase (#486)
- `sleep-study` — DUP: sleep-study ↔ polysomnography (#493)
- `oral-appliance-therapy` — DUP: oral-appliance-therapy ↔ mad (#576)
- `zygomatic-system` — ตัด "ได้เร็วขึ้น" · DUP กับ zygomatic-implant (#45)
- `prf-technology` — "ช่วยลดอาการปวดบวมและเสริมการหาย" → ตาม 28551729: หลักฐานด้านเนื้อเยื่ออ่อน/เบ้าฟันแห้ง ด้านกระดูกจำกัด · DUP กับ prf-platelet-rich-fibrin (#132)
- `gbt-airflow-prophylaxis` — ตัด "นุ่มนวลและเจ็บน้อยกว่า" → "ประสิทธิผลไม่ต่างจากวิธีเดิม ใช้เวลาน้อยกว่า (41531192)" · DUP gbt-airflow (#421)
- `tmj-injection` — "ช่วยให้อ้าปากกว้างขึ้นและเคี้ยวดีขึ้น" → "มุ่ง…" · DUP กับ corticosteroid-injection-tmj/ha-injection-tmj
- `uv-implant` — "ยึดติดเร็วและแน่นขึ้น ลดการละลาย" → "หลักฐานส่วนใหญ่จากห้องปฏิบัติการ/สัตว์" · DUP uv-device (#433)
- `viscosupplementation-tmj` — "ช่วยบรรเทาปวด ข้อฝืด เสียงคลิก" → "มุ่ง…" · DUP ha-injection-tmj (#157)
- `myofunctional-therapy` — "ช่วยแก้…ลดการนอนกรนและ OSA" → "มีหลักฐานระดับปานกลางว่าช่วยลด…ในผู้ใหญ่" · DUP omt-airway/certified-myologist
- `omt-airway` — "ช่วยลดการนอนกรน OSA ง่วง" → hedge · DUP myofunctional-therapy (#583)

## รายการแก้ (D3 จะเขียนใหม่ตาม note นี้)

- `dental-implant` Dental Implant [treatment] pages=269 · **factual** — "รากโลหะ" ตกรากเซอร์โคเนีย → "รากเทียมไทเทเนียมหรือเซอร์โคเนีย"
- `all-on-4` All-on-4 [treatment] pages=142 · **scope+benefit** — "ทั้งปาก" ผิด (ต่อขากรรไกร) · "ช่วยฟื้นการเคี้ยว" ไม่มีแหล่ง · ใส่ layout 2 ตรง+2 เอียง (33571327)
- `all-on-6` All-on-6 [treatment] pages=130 · **superior+scope** — "มั่นคงขึ้น" ไม่มีแหล่ง · "ทั้งปาก" → ต่อขากรรไกร (33571327: 6–8 axial)
- `multiple-missing-teeth` Multiple Missing Teeth [condition] pages=123 · **benefit+hedge** — ตัดประโยคท้าย "ช่วยลดความเสี่ยง" · hedge "ทำให้"→"อาจทำให้" · ยาว 378
- `periodontitis` Periodontitis [condition] pages=45 · **hedge** — "ฟันจะโยกและหลุดในที่สุด" → "อาจโยกและหลุดได้"
- `cbct` Cone Beam Computed Tomography (CBCT) [procedure] pages=29 · **factual+benefit** — ตัด "ปริมาณรังสีค่อนข้างต่ำ" (ขัด 41500761 CBCT ต้องใช้อย่างระวังเรื่อง dose) · ตัด "แม่นยำขึ้น" (36329417 CBCT ไม่ลด nerve injury)
- `porcelain-veneer` Porcelain Veneer [treatment] pages=28 · **marketing** — ตัด "สวยงามเป็นธรรมชาติ" · คง "ทนคราบ" (40532149)
- `removable-denture` Removable Denture [treatment] pages=27 · **price+subjective** — ตัด "ราคาย่อมเยา" (ห้ามพูดราคา) และ "ทำความสะอาดง่าย"
- `trioclear` TrioClear Aligner System [device] pages=23 · **length+offtopic+marketing** — 634 ตัวอักษร · ตัดย่อหน้าวิจัย MA aligner ทั่วไป (ไม่ใช่ TrioClear) · ตัด "แบบก้าวหน้า" · คงนิยาม + ถาดสองความแข็ง + ไม่ใช่รีเทนเนอร์
- `periodontal-disease` Periodontal Disease [condition] pages=20 · **hedge** — "ฟันโยกและหลุดในที่สุด" → "อาจ…"
- `intraoral-scanner` Intraoral Scanner [technology] pages=19 · **superior** — ตัด "สะดวกและแม่นยำกว่า"
- `halitosis` Halitosis (Bad Breath) [condition] pages=18 · **overclaim** — "การทำความสะอาดช่วยแก้ที่ต้นเหตุได้" → "การรักษาเริ่มจากหาสาเหตุ" (23633830)
- `gummy-smile` Gummy Smile [condition] pages=15 · **tone+freq** — "ไม่ใช่โรคอันตรายแต่หลายคนกังวล" → ระบุสาเหตุที่เป็นไปได้ (ริมฝีปาก/ฟันขึ้นไม่เต็ม/ขากรรไกรบนยาว) การแก้ขึ้นกับสาเหตุ
- `preventive-dentistry` Preventive Dentistry [concept] pages=14 · **cost** — ตัด "และค่าใช้จ่าย"
- `laser-perio` Laser Periodontal Treatment [treatment] pages=14 · **superior** — ตัด "แผลเล็กและเจ็บน้อยกว่า" → เลเซอร์ใช้ร่วม SRP หลักฐานชี้ประโยชน์เพิ่มจำกัด (30133748, 34327566)
- `diastema` Diastema (Tooth Gap) [condition] pages=12 · **tone** — "ส่วนใหญ่ไม่เป็นอันตรายแต่บางคนกังวล" → ระบุสาเหตุที่พบ (ฟันเล็ก/พังผืดริมฝีปาก/ฟันหาย/นิสัย)
- `emax-crown` All-Ceramic Crown (E.max) [device] pages=12 · **marketing** — "สวยงามใสเป็นธรรมชาติสูง" → "มีความโปร่งแสงใกล้เคียงฟันธรรมชาติ"
- `early-orthodontic-intervention` Early Orthodontic Intervention [treatment] pages=12 · **benefit** — ตัด "ช่วยลดความซับซ้อนของการรักษาในอนาคต" (ไม่มีแหล่ง)
- `pulp-necrosis` Pulp Necrosis [condition] pages=11 · **freq+tone** — "หลายคนไม่ปวดจึงไม่รู้ตัว" → "อาจไม่มีอาการปวด"
- `bruxism` Bruxism (Teeth Grinding) [condition] pages=9 · **factual+freq** — เขียนใหม่ตาม 23121262/29926505: กิจกรรมกล้ามเนื้อบดเคี้ยวซ้ำ ๆ (ขบ/ถู/เกร็ง) มี 2 แบบ sleep/awake · ในคนสุขภาพดีเป็นพฤติกรรม ไม่ใช่โรค · อาจเป็นปัจจัยเสี่ยงของฟันสึก/ปวด
- `composite-veneer` Composite Veneer [treatment] pages=9 · **price** — ตัด "ราคาย่อมเยากว่าวีเนียร์เซรามิก"
- `ceramic-implant` Ceramic Implant [device] pages=8 · **length+number** — 608 ตัวอักษร · ตัด "~97.5% ที่ 3 ปี" และ "แพ้โลหะ" (21251079 ยังรู้น้อย) · คงนิยาม + ข้อมูลระยะยาวจำกัดกว่าไทเทเนียม (30328196 ITI: one-piece แนะนำได้เมื่อเงื่อนไขเหมาะ two-piece ระวัง)
- `arthrocentesis` Arthrocentesis & Joint Lavage [procedure] pages=5 · **benefit** — "ช่วยลดอาการปวด อ้าปากติด เสียงคลิก" → "มุ่งลด…" ไม่มีแหล่งผลลัพธ์
- `corticosteroid-injection-tmj` Corticosteroid Injection (TMJ) [procedure] pages=5 · **number+benefit** — ตัด "ราว 3 สัปดาห์" · "ช่วยให้อ้าปากกว้างขึ้น" → "มุ่งลดการอักเสบ"
- `ha-injection-tmj` Hyaluronic Acid Injection (TMJ) [procedure] pages=5 · **benefit** — "เพื่อลดการเสียดสี บรรเทาปวด ช่วยให้อ้าปากได้ดีขึ้น" → hedge "มุ่ง"
- `arthroscopy-tmj` TMJ Arthroscopy [procedure] pages=5 · **benefit** — "ช่วยลดอาการปวดและอ้าปากกว้างขึ้น" → hedge "มุ่ง"
- `dry-needling` Dry Needling & Trigger Point Therapy [treatment] pages=5 · **benefit** — "ช่วยลดอาการปวด…เพิ่มการเคลื่อนไหว" → "มุ่ง" ไม่มีแหล่ง
- `immediate-implant` Immediate Implant [treatment] pages=5 · **factual** — ตัด "รักษากระดูกเบ้าฟันไว้" (immediate implant ไม่ป้องกัน socket resorption)
- `prf-tmj` Regenerative TMJ Joint Therapy [treatment] pages=5 · **safety+benefit** — ตัด "จึงมีความปลอดภัยและรุกล้ำน้อย" · outcome → "มุ่ง" · หลักฐานจำกัด
- `awake-bruxism` Awake Bruxism (Clenching) [condition] pages=4 · **freq+benefit** — "ทำให้ปวดกราม…" → "อาจ" · ตัด "หากรู้ตัวและลดความเครียดมักดีขึ้น" · อิง 29926505 behaviour continuum
- `nemostudio` NemoStudio Digital Planning Suite [device] pages=4 · **vendor_benefit** — ตัด "ช่วยให้…แม่นยำและปลอดภัยขึ้น"
- `night-guard` Night Guard [device] pages=4 · **benefit** — "ช่วยลดอาการปวด TMJ" → ระบุหลักฐานความเชื่อมั่นต่ำมาก (39282765 Cochrane)
- `x-guide-dynamic-navigation` X-Guide Dynamic Navigation System [device] pages=4 · **vendor_superior** — ตัด "แม่นยำกว่าการฝังด้วยมือเปล่า ลดความเสี่ยง…" → "เป้าหมายให้ตำแหน่งใกล้แผน"
- `periodontal-treatment` Periodontal Treatment [treatment] pages=4 · **meta_leak** — ตัดประโยค "เป็นหน่วยฝั่ง บริการ ที่คู่กับ entity ฝั่งโรค" (meta-comment หลุดใน public text)
- `brava-ai` Brava AI Lingual Orthodontics [device] pages=3 · **length+vendor** — 756 ตัวอักษร · เหลือนิยาม lingual appliance + แขน NiTi แยกซี่ ไม่ใช้ archwire · ตัดภาษาการตลาด AI · คง caveat pilot RCT สั้น ๆ
- `endodontic-treatment` Endodontic Treatment (Laser-Assisted) [procedure] pages=3 · **benefit** — "เลเซอร์ช่วยฆ่าเชื้อและลดอาการปวดหลังทำ" → "มีการใช้เลเซอร์ร่วม หลักฐานผลลัพธ์ยังจำกัด"
- `zygomatic-system` Zygomatic Implant System [device] pages=2 · **benefit+dup** — ตัด "ได้เร็วขึ้น" · DUP กับ zygomatic-implant (#45)
- `pregnancy` Pregnancy [condition] pages=1 · **contradicts_source** — "อาจสัมพันธ์กับการคลอดก่อนกำหนด" → "ความเชื่อมโยงกับผลการตั้งครรภ์ยังไม่ได้ข้อสรุป" (39396142 ไม่พบ association)
- `self-ligating-braces` Self-Ligating Braces [treatment] pages=1 · **contradicts_source** — ตัด "จำนวนครั้งการปรับเครื่องมือ" (23299650: ไม่ต่าง) · คง "ลดแรงเสียดทานเชิงกลไก"
- `jaw-structure` Jaw Structure [anatomy] pages=0 · **hedge** — "จำเป็นต้องได้รับการจัดฟันหรือผ่าตัด" → "อาจต้อง"
- `adhd-airway` ADHD and Airway Obstruction [concept] pages=0 · **benefit** — "มักช่วยให้พฤติกรรมและสมาธิดีขึ้น" → "มีงานวิจัยศึกษาความสัมพันธ์นี้ ต้องประเมินแยกโรคโดยแพทย์"
- `before-after-smile` Before & After Smile [concept] pages=0 · **compliance** — เติม "ผลลัพธ์แตกต่างกันในแต่ละบุคคล" (กฎโฆษณาสถานพยาบาล)
- `biocompatible-materials` Biocompatible Materials Philosophy [concept] pages=0 · **safety+marketing** — ตัด "ปลอดภัย และให้ความสวยงามเป็นธรรมชาติ"
- `braces-vs-aligner` Braces vs Clear Aligners [concept] pages=0 · **subjective** — "สวยงามกว่า" → "มองเห็นได้ยากกว่า"
- `cervical-tmj` Cervical-TMJ Connection [concept] pages=0 · **benefit** — hedge "การดูแลรักษาที่ได้ผลจึงมักต้อง…" → "การประเมินมักครอบคลุมทั้งสองส่วน"
- `collagen-bone-preservation` Collagen and Bone Density Preservation [concept] pages=0 · **benefit** — "รักษาความหนาแน่น/ลดการยุบตัว" → "ใช้เป็นวัสดุร่วมใน socket preservation หลักฐานเมื่อใช้เดี่ยวมีจำกัด"
- `dental-flossing` Dental Flossing [concept] pages=0 · **contradicts_source** — "ลดความเสี่ยงฟันผุและเหงือกอักเสบ" → ตาม 25639826: แปรงซอกฟันเป็นตัวเลือกหลักเมื่อใส่ได้ ไหมขัดฟันใช้เมื่อใส่แปรงไม่ได้
- `implant-faq` Dental Implant Pain and Safety [concept] pages=0 · **ad_claim+number** — ตัด "แทบไม่เจ็บ" "ปลอดภัยและได้ผลดี" "96% ที่ 10 ปี" → นิยามกลาง: ทำใต้ยาชา อาจปวดบวมช่วงแรก พบทันตแพทย์ถ้าผิดปกติ
- `dental-installment` Dental Installment Payment [concept] pages=0 · **price_marketing** — "ช่วยให้เข้าถึง…ได้ง่ายขึ้น" → "เงื่อนไขขึ้นกับสถานพยาบาล"
- `facially-driven-ortho` Facially Driven Orthodontics [concept] pages=0 · **marketing** — ตัด "ช่วยให้ผลลัพธ์สวยงามเป็นธรรมชาติ ใช้งานได้ดี"
- `genetic-risk` Genetic Risk & Predisposition [concept] pages=0 · **number** — "ราว 40-60%" → "ประมาณการจากงานวิจัยฝาแฝดแตกต่างกันตามการศึกษา"
- `healthy-aging` Healthy Aging [concept] pages=0 · **meta_leak** — ตัดวงเล็บ editorial note ทั้งก้อน
- `nutrigenomics` Nutrigenomics [concept] pages=0 · **contradicts_source** — "ใช้ออกแบบโภชนาการเฉพาะบุคคลเพื่อช่วยป้องกัน…" → "มีการนำไปใช้ แต่หลักฐานว่าดีกว่าคำแนะนำทั่วไปยังจำกัด" (32234083 Food4Me)
- `nutrition-oral` Nutrition and Lifestyle Alignment [concept] pages=0 · **benefit** — คง <10% น้ำตาลอิสระ (26773022) · ตัด/hedge วิตามินซี-ดี-แคลเซียม "ช่วยเสริมความแข็งแรงของเหงือก"
- `oral-hygiene` Oral Hygiene [concept] pages=0 · **contradicts_source** — "ใช้ไหมขัดฟัน" → "ทำความสะอาดซอกฟัน (แปรงซอกฟัน/ไหมขัดฟัน)" (25639826)
- `oral-inflammation-systemic` Oral Inflammation (Systemic Driver) [concept] pages=0 · **benefit** — "การรักษาสุขภาพเหงือกจึงช่วยลดการอักเสบเหล่านี้ได้" → "อาจลดตัวชี้วัดการอักเสบ ผลต่อโรคระบบยังศึกษาอยู่" (22057194: HbA1c ~0.4%)
- `oral-brain-connection` Oral-Brain Connection [concept] pages=0 · **benefit** — "อาจช่วยชะลอความเสื่อมของสมอง" → "ความสัมพันธ์เชิงสาเหตุยังไม่ได้ข้อสรุป" (42093338)
- `ortho-alignment-health` Orthodontic Alignment for Health [concept] pages=0 · **benefit+contradicts** — ตัด "ปัญหาข้อต่อขากรรไกร" (39282765 very low) · hedge ฟันผุ/เหงือก (29114647: ระหว่างจัดฟันอักเสบเพิ่ม)
- `peak-performance` Peak Performance [concept] pages=0 · **hedge** — "หากไม่รักษาจะบั่นทอน…" → "อาจ"
- `pediatric-orthodontics` Pediatric Orthodontics [concept] pages=0 · **benefit** — ตัด "ช่วยลดปัญหาการสบฟันที่ซับซ้อนในอนาคต" (เหมือน #107)
- `root-cause-pediatric` Pediatric Root-Cause Philosophy [concept] pages=0 · **benefit** — "ช่วยให้ขากรรไกรพัฒนาปกติและลดโอกาสต้องจัดฟัน" → "หลักฐานเรื่องผลระยะยาวยังจำกัด" (30152171)
- `precision-medicine-dental` Precision Dental Medicine [concept] pages=0 · **benefit** — "ช่วยให้ตรวจพบโรคได้เร็วขึ้น" → "มุ่ง"
- `precision-diagnostics` Precision Diagnostic Assessments [concept] pages=0 · **marketing+superior** — ตัด "แม่นยำกว่าการตรวจทั่วไป ช่วยวางแผนตรงจุด ลดความผิดพลาด เพิ่มโอกาส…"
- `rct-vs-implant` Root Canal Treatment vs Dental Implant [concept] pages=0 · **number+superior** — "97% ที่ 10 ปี / 68% ที่ 37 ปี" → "86–93% ในช่วง 2–10 ปี (20158529)" · ตัด "รากเทียมอาจให้ผลระยะยาวดีกว่า" (32984102: รายเคส)
- `student-stress` Student Stress & Bruxism [concept] pages=0 · **length+meta_leak** — 715 ตัวอักษร · ตัดวงเล็บหมายเหตุ editorial · เหลือนิยาม + ความสัมพันธ์กับความวิตกกังวล (hedged)
- `tmj-sleep-integration` TMJ-Sleep Integration [concept] pages=0 · **freq** — "มักตรวจพบ OSA ร่วมด้วยมากกว่าคนทั่วไป" → "มีงานวิจัยรายงานความสัมพันธ์"
- `facial-change-tooth-loss` Tooth-Loss Facial Changes [concept] pages=0 · **contradicts_source** — "ชะลอได้ด้วยรากฟันเทียม" → "หลักฐานว่ารากฟันเทียมชะลอการละลายสันเหงือกยังผสม (33281173)"
- `tongue-tie` Ankyloglossia [condition] pages=0 · **contradicts_source** — "รักษาได้ด้วยการขริบ" → "การผ่าตัดพิจารณาตามอาการจริง ไม่ใช่จากลักษณะที่เห็น (35689515, 33501864)"
- `pediatric-dental-anxiety` Dental Anxiety in Children [condition] pages=0 · **number** — ตัด "ราวหนึ่งในสามของเด็กเล็ก"
- `titanium-allergy` Titanium Allergy [condition] pages=0 · **overclaim** — "วินิจฉัยได้ด้วยการทดสอบภูมิแพ้โลหะ" → "การทดสอบยังมีข้อจำกัด ความรู้เรื่องนี้ยังน้อย (21251079)"
- `acrylic-denture` Acrylic Denture [device] pages=0 · **price** — ตัด "ราคาย่อมเยา" · คง "ปรับแก้ได้ง่าย"
- `aoralscan` Aoralscan Elite Wireless [device] pages=0 · **vendor_benefit** — ตัด "ให้ความสบายและรวดเร็ว" · AI ตรวจฟันผุ → "ผู้ผลิตระบุว่ามีระบบช่วย…"
- `clarius-hd3` Clarius HD3 [device] pages=0 · **meta_leak+length** — 718 ตัวอักษร มี verification note หลุด 3 จุด → นิยามสะอาด: อัลตราซาวด์พกพา ใช้ตรวจเนื้อเยื่ออ่อนช่องปาก-ใบหน้า ไม่มีรังสี เสริมเอกซเรย์ · ข้อบ่งชี้ทางทันตกรรมยังไม่มีการรับรองเฉพาะ
- `dental-monitoring-ai` Dental Monitoring AI [device] pages=0 · **vendor_benefit** — "ช่วยลดการเดินทาง…" → "ผู้ผลิตระบุว่า"
- `emface` Emface (HIFES + RF) [device] pages=0 · **benefit** — "ช่วยกระชับ ยก กระตุ้นคอลลาเจน ลดริ้วรอย ไม่ต้องพักฟื้น" → "ผู้ผลิตระบุว่ามุ่ง…"
- `exion` Exion (Fractional RF + Ultrasound) [device] pages=0 · **meta_leak+number** — ตัด "~224% ในสุกร" และวงเล็บ FDA ที่ยืนยันไม่ได้ → นิยาม + "ผู้ผลิตระบุว่า"
- `fotona-lightwalker` Fotona LightWalker MAX [device] pages=0 · **benefit** — ตัด "โดยเจ็บน้อยและแผลหายเร็ว"
- `gbt-airflow` GBT Airflow System (EMS) [device] pages=0 · **meta_leak+length** — 581 ตัวอักษร · ตัดวงเล็บ editorial · สรุปเป็น "ประสิทธิผลไม่ต่างจาก SRP ใช้เวลาน้อยกว่า (41531192 SR)" ไม่ใส่ตัวเลข Vouros ถ้าไม่มีใน pool
- `myobrace-system` Myobrace System [device] pages=0 · **length+benefit** — 621 ตัวอักษร · ตัด "ลดความจำเป็นต้องจัดฟันซับซ้อนในอนาคต" · คงนิยาม + "ผลด้าน airway ด้อยกว่า Twin block ในบางการศึกษา"
- `osstem-implant` Osstem / Dentium Implant (Korean) [device] pages=0 · **price** — ตัด "เป็นทางเลือกที่คุ้มค่า"
- `prf-technology` Platelet-Rich Fibrin Technology [device] pages=0 · **benefit+dup** — "ช่วยลดอาการปวดบวมและเสริมการหาย" → ตาม 28551729: หลักฐานด้านเนื้อเยื่ออ่อน/เบ้าฟันแห้ง ด้านกระดูกจำกัด · DUP กับ prf-platelet-rich-fibrin (#132)
- `uv-device` UV Photofunctionalization Device [device] pages=0 · **benefit** — "ส่งผลให้ osseointegration เร็วและมั่นคงขึ้น" → "หลักฐานส่วนใหญ่จากห้องปฏิบัติการ/สัตว์ทดลอง"
- `botulinum-toxin` Botulinum Toxin [drug] pages=0 · **meta_leak** — ตัดประโยค "ไม่มีแหล่งอ้างอิงที่ให้มารองรับในชุดนี้ จึงตัดออกจากสรุป…" และ "(มีหลักฐานสนับสนุนโดยตรงจากงานวิจัย)" · คง 3–6 เดือน hedged
- `microbiome-lab` Microbiome & Genetic Lab [organization] pages=0 · **benefit** — "วางแผน…ได้แม่นยำขึ้น" → hedge "ใช้ประกอบ"
- `tmj-assessment-3d` 3D TMJ Analysis [procedure] pages=0 · **factual** — ตัด "รังสีปริมาณต่ำ" (CBCT dose สูงกว่า intraoral; 41500761)
- `airway-assessment-3d` Airway Assessment (3D Volumetric) [procedure] pages=0 · **factual+overclaim** — ตัด "รังสีปริมาณต่ำ" · "ช่วยประเมินความเสี่ยง OSA" → "ใช้เสริม ไม่แทนการตรวจการนอนหลับ" (38978295)
- `functional-metabolic-panel` Functional Metabolic Panel [procedure] pages=0 · **benefit** — ตัด "และสุขภาพช่องปาก" (ไม่มีแหล่งเชื่อม panel ฮอร์โมนกับช่องปาก)
- `gbt-airflow-prophylaxis` GBT Airflow Prophylaxis [procedure] pages=0 · **superior+dup** — ตัด "นุ่มนวลและเจ็บน้อยกว่า" → "ประสิทธิผลไม่ต่างจากวิธีเดิม ใช้เวลาน้อยกว่า (41531192)" · DUP gbt-airflow (#421)
- `jaw-cyst-surgery` Jaw Cyst Surgery [procedure] pages=0 · **language+meta_leak** — ข้อความอังกฤษ + note "The lesion itself is the separate condition entity" → เขียนไทย: การผ่าตัดถุงน้ำขากรรไกร (enucleation/marsupialisation) วางแผนจากภาพรังสี ส่งชิ้นเนื้อตรวจ อาจปลูกกระดูก
- `jaw-motion-tracking` Jaw Motion Tracking [procedure] pages=0 · **superior** — ตัด "แม่นยำกว่าการดูด้วยตา"
- `laser-conservative` Laser Conservative Dentistry [procedure] pages=0 · **benefit** — "ส่วนใหญ่ไม่ต้องฉีดยาชาและเจ็บน้อยกว่า เหมาะกับเด็ก" → hedge "บางกรณีอาจลดความจำเป็นในการฉีดยาชา หลักฐานจำกัด"
- `laser-gingivectomy` Laser Gingivectomy [procedure] pages=0 · **superior** — ตัด "แผลเล็ก เลือดออกน้อย หายเร็วกว่า"
- `laser-intraoral-rejuvenation` Laser Intraoral Rejuvenation [procedure] pages=0 · **benefit** — "ช่วยลดริ้วรอย…กระชับ" → "ผู้ให้บริการระบุว่ามุ่ง…" หลักฐานจำกัด
- `laser-lip` Laser Lip Enhancement [procedure] pages=0 · **benefit** — "ทำให้ริมฝีปากอิ่มฟู กระชับ สีสว่าง" → "ผู้ให้บริการระบุว่ามุ่ง…" หลักฐานจำกัด
- `laser-pbm` Laser Photobiomodulation (PBM) [procedure] pages=0 · **benefit** — "ช่วยลดปวด ลดอักเสบ เร่งสมานแผล" → "มุ่ง…; หลักฐานชัดที่สุดในเยื่อบุช่องปากอักเสบจากรังสี/เคมีบำบัด"
- `laser-wisdom-tooth` Laser-Assisted Wisdom Tooth Surgery (Fotona) [procedure] pages=0 · **benefit+vendor** — "งานวิจัยพบว่าช่วยลดบวมปวดมากกว่าหัวกรอ" → "บางการศึกษารายงาน… หลักฐานจำกัด"
- `maxillary-expansion` Maxillary Expansion (MSE/MARPE/EASE) [procedure] pages=0 · **benefit** — "ช่วยเพิ่มพื้นที่ทางเดินหายใจ" → "ผลต่อทางเดินหายใจยังไม่ชัด (38978295)"
- `nasal-hygiene` Nasal Hygiene [procedure] pages=0 · **price+safety** — ตัด "เป็นวิธีที่ปลอดภัยและราคาถูก"
- `occlusal-mapping` Occlusal Mapping (Digital Bite Force) [procedure] pages=0 · **vendor_superior** — "แม่นยำและวัดซ้ำได้ดีกว่ากระดาษกดสบฟัน" → "ให้ข้อมูลเชิงตัวเลขเพิ่มจากกระดาษกดสบฟัน"
- `pediatric-laser` Pediatric Laser Dentistry [procedure] pages=0 · **benefit** — ตัด "ลดความเจ็บ/วิตกกังวล ลดหรือไม่ต้องใช้ยาชา … นุ่มนวลกว่า" → "หลักฐานเรื่องความเจ็บ/ยาชายังจำกัด"
- `pediatric-sedation` Pediatric Sedation Dentistry [procedure] pages=0 · **safety** — ตัด "ปลอดภัยและราบรื่นขึ้น" · คงข้อกำหนดประเมินก่อน (28206886)
- `sweeps` SWEEPS Endodontic Protocol [procedure] pages=0 · **benefit** — "ลึกกว่า…ลดเชื้อได้ดีขึ้น" → "การศึกษาในห้องปฏิบัติการชี้ว่า…" (36643274)
- `skeletal-aging-eval` Skeletal Aging Evaluation [procedure] pages=0 · **marketing** — ตัด "ฟื้นฟูความอ่อนเยาว์…ได้แม่นยำขึ้น"
- `tmj-injection` TMJ Injection Therapy [procedure] pages=0 · **benefit+dup** — "ช่วยให้อ้าปากกว้างขึ้นและเคี้ยวดีขึ้น" → "มุ่ง…" · DUP กับ corticosteroid-injection-tmj/ha-injection-tmj
- `tmj-reconstruction` TMJ Reconstruction [procedure] pages=0 · **benefit** — "ช่วยลดอาการปวดและอ้าปากกว้างขึ้น" → "มุ่ง…"
- `frenectomy-adult` Tongue Tie Release (Frenectomy) [procedure] pages=0 · **contradicts_source** — "ลดปัญหาการพูด" → "ผลต่อการพูดยังสรุปไม่ได้ (33501864)"
- `tooth-reshaping` Tooth Reshaping [procedure] pages=0 · **absolute** — "ไม่เจ็บ" → "มักไม่ต้องฉีดยาชา"
- `touchwhite` TouchWhite Whitening [procedure] pages=0 · **safety+contradicts** — ตัด "ขาวขึ้นอย่างปลอดภัย" · เติม "หลักฐานชี้ว่าแสงกระตุ้นไม่จำเป็นต่อผลการฟอก (29893625)"
- `uv-implant` UV Photofunctionalized Implant [procedure] pages=0 · **benefit+dup** — "ยึดติดเร็วและแน่นขึ้น ลดการละลาย" → "หลักฐานส่วนใหญ่จากห้องปฏิบัติการ/สัตว์" · DUP uv-device (#433)
- `diagnostic-ultrasound` Ultrasound Diagnostic Imaging [procedure] pages=0 · **price+safety** — ตัด "ปลอดภัย ราคาไม่แพง ไม่เจ็บ" → คง "ไม่ใช้รังสี"
- `viscosupplementation-tmj` Viscosupplementation (TMJ) [procedure] pages=0 · **benefit+dup** — "ช่วยบรรเทาปวด ข้อฝืด เสียงคลิก" → "มุ่ง…" · DUP ha-injection-tmj (#157)
- `certified-myologist` Certified Myologist [specialty] pages=0 · **benefit** — "นิยมใช้…ช่วยลดนอนกรน/OSA" → "มีการใช้เป็นการรักษาเสริม หลักฐานระดับปานกลาง"
- `physiotherapist` Physiotherapist [specialty] pages=0 · **meta_leak** — ตัด "(อ้างอิงจาก Cleveland Clinic) ทั้งนี้…ควรตรวจสอบเพิ่มเติมก่อนเผยแพร่…" ทั้งท่อน
- `physiotherapy` Physiotherapy [specialty] pages=0 · **benefit** — "ช่วยฟื้นฟู…ให้กลับมาใช้งานได้ปกติ" → "มุ่ง…"
- `poor-recovery` Poor Recovery and Sleep Quality [symptom] pages=0 · **meta_leak** — ตัดวงเล็บ "หมายเหตุ: ข้อมูลการฟื้นตัว…"
- `tmj-headache` TMJ-Related Headache [symptom] pages=0 · **overclaim** — "อาการมักดีขึ้นเมื่อรักษา TMD จึงช่วยแยกจากไมเกรน" → "การวินิจฉัยแยกจากไมเกรนต้องอาศัยการตรวจ"
- `tinnitus-tmj` Tinnitus (TMJ Connection) [symptom] pages=0 · **contradicts_source** — ตัด "หลายรายดีขึ้นเมื่อรักษา TMD" (39290041: ความหมายทางคลินิกยังไม่ทราบ)
- `dental-laser` Dental Laser [technology] pages=0 · **superior** — ตัด "ให้แผลเล็ก เลือดออกน้อย และหายเร็ว"
- `biomimetic-restoration` Biomimetic Restorative Dentistry [treatment] pages=0 · **benefit** — "ซึ่งช่วยลดโอกาสต้องครอบฟันโดยไม่จำเป็น" → hedge (เป็นการอนุมาน)
- `bite-rehab` Bite Rehabilitation and Occlusal Stabilization [treatment] pages=0 · **benefit** — "บรรเทาอาการปวดข้อต่อขากรรไกร" → "มุ่ง…; หลักฐานด้าน TMD ความเชื่อมั่นต่ำมาก (39282765)"
- `regenerative-protocol-facial` Facial Regenerative Protocol [treatment] pages=0 · **length+safety** — 490 · ตัดวงเล็บ "(มีหลักฐานชัดเจน…)" และ "จึงเข้ากับร่างกายได้ดี" · ผลต่อผิวหน้า → "หลักฐานจำกัด"
- `facial-rejuvenation-program` Facial Rejuvenation Program [treatment] pages=0 · **benefit** — "ช่วยลดริ้วรอย…" → "ผู้ให้บริการระบุว่ามุ่ง…"
- `facial-volume-restoration` Facial Volume Restoration [treatment] pages=0 · **factual** — "รากฟันเทียมเพื่อคงสภาพกระดูกเบ้าฟัน" → hedge (33281173) · ฟิลเลอร์ → "โดยแพทย์ผิวหนัง"
- `forward-head-posture` Forward Head Posture Correction [treatment] pages=0 · **benefit** — "ช่วยเพิ่มมุมกระดูกคอ ลดปวด…บรรเทา TMD" → "มุ่ง…"
- `gingivitis-treatment` Gingivitis Treatment [treatment] pages=0 · **language** — ข้อความอังกฤษ → ไทย: การจัดการเหงือกอักเสบจากคราบจุลินทรีย์ — วินิจฉัยแยกจากปริทันต์อักเสบ ควบคุมคราบ ขจัดหินปูนและปัจจัยกักคราบ ประเมินซ้ำ · ต่างจากการขูดหินปูนทั่วไปและการรักษาปริทันต์
- `guided-growth` Guided Growth Orthodontics [treatment] pages=0 · **benefit** — ตัด "ช่วยลดความรุนแรงและความยุ่งยากของการจัดฟันเต็มรูปแบบในอนาคต"
- `in-office-whitening` In-Office Whitening [treatment] pages=0 · **contradicts_source** — "ควบคุมความปลอดภัยได้ดีกว่าการทำเอง / เห็นผลเร็ว" → "ภายใต้การควบคุมของทันตแพทย์ มักเห็นผลในนัดเดียว; ประสิทธิผลรวมไม่ต่างจากชุดที่บ้านภายใต้การดูแล (40485133)"
- `laser-dentistry` Laser Dentistry [treatment] pages=0 · **superior** — ตัด "จุดเด่นคือช่วยลดเลือดออก ลดความเจ็บ แผลหายเร็วกว่า"
- `local-anesthesia` Local Anesthesia (Dental) [treatment] pages=0 · **absolute** — "รักษาได้โดยไม่เจ็บ" → "ลดความเจ็บระหว่างหัตถการ"
- `metal-braces` Metal Braces [treatment] pages=0 · **price** — ตัด "คุ้มค่า"
- `microbiome-reset` Microbiome Reset Protocol [treatment] pages=0 · **benefit** — "ช่วยลดการเกิดโรคซ้ำ" → "หลักฐานประสิทธิผลของโปรโตคอลยังจำกัด"
- `mini-implant` Mini Implant [treatment] pages=0 · **contradicts_source** — ตัด "ผ่าตัดน้อยและฟื้นตัวเร็ว" · เติม "ในขากรรไกรบน overview SR รายงานอัตราล้มเหลวระยะสั้นสูง ไม่แนะนำ (33571327)"
- `muscle-posture-recovery` Muscle & Posture-Based Recovery [treatment] pages=0 · **benefit** — "ช่วยลดอาการปวด อ้าปากได้กว้างขึ้น" → "มุ่ง…"
- `myofunctional-therapy` Myofunctional Therapy [treatment] pages=0 · **benefit** — "ช่วยแก้…ลดการนอนกรนและ OSA" → "มีหลักฐานระดับปานกลางว่าช่วยลด…ในผู้ใหญ่" · DUP omt-airway/certified-myologist
- `nitrous-oxide` Nitrous Oxide Sedation [treatment] pages=0 · **safety** — ตัด "จัดเป็นวิธี…ที่ปลอดภัยและใช้กันแพร่หลายที่สุด" → "ใช้กันแพร่หลาย ต้องมีการประเมินก่อน"
- `non-surgical-facial` Non-Surgical Facial Rejuvenation [treatment] pages=0 · **benefit** — "ทำให้ผิวเรียบตึงและดูอ่อนวัยขึ้น" → "ผู้ให้บริการระบุว่ามุ่ง…" คงข้อจำกัด
- `omt-airway` OMT for Airway & Sleep [treatment] pages=0 · **benefit+dup** — "ช่วยลดการนอนกรน OSA ง่วง" → hedge · DUP myofunctional-therapy (#583)
- `postural-rehab` Postural Rehabilitation [treatment] pages=0 · **benefit** — "ช่วยลดอาการปวด เพิ่มการเคลื่อนไหว" → "มุ่ง…"
- `tmj-posture-recovery` TMJ Muscle and Posture Recovery [treatment] pages=0 · **benefit** — "ช่วยลดอาการปวด เพิ่มระยะอ้าปาก" → "มุ่ง…"
- `zoom-whitening` Zoom Whitening [treatment] pages=0 · **contradicts_source** — เติม "หลักฐานชี้ว่าแสงกระตุ้นไม่จำเป็นต่อผลการฟอก (29893625)"

---

## D4 — เขียน summary ใหม่ 26 จาก 28 ตัวที่ว่างและหน้า smile-scape ใช้ (wave 16ck, 2026-09-17)

ทั้ง 28 เป็น first-party (load_source `content-plan/entities.md`) ไม่ใช่เรื่องที่หาจาก PubMed แบบ All-on-5 → แหล่งต่อกลุ่ม:

| กลุ่ม | จำนวน | แหล่ง | ใครร่าง |
|---|---|---|---|
| แบรนด์/สาขา/หมอ/แนวคิดคลินิก | 10 | `docs/brand-concept.md` · `docs/team/*.md` · `doctors.json` · `branches.md` · `site-nav.ts` | Sonnet → Opus แก้ 3 |
| อุปกรณ์ที่คลินิกใช้ | 13 | entities.md (ตัวตน/ผู้ผลิต) + key_findings ของ citation ที่ผูกกับหน้าที่ใช้ (ตรวจ PubMed แล้วในช่วง C) | Sonnet → Opus แก้ 7 (ตัด survival % generic ที่ไปเกาะกับยี่ห้อ) |
| สิทธิรักษา | 2 | gcc.go.th relay ประกาศ สปส. 2026-04-18 (มีผล 1 พ.ค. 2569) · hfocus | Opus |
| KOL ภายนอก | 1 | PubMed (Linkevicius T, Vilnius University) + Open Library ISBN 9780867157994 | Opus |

**ตัดสินใจโดย operator (2026-09-17):**
- Lifetime warranty → นิยามกลาง ไม่มี "ตลอดชีพ" เป็นคำสัญญา จนกว่า compliance ผ่าน
- **บัตรทอง (`universal-coverage-th`) และ ข้าราชการ (`civil-servant-dental-benefit`) — คลินิกไม่รับ ห้ามพูดถึง → ไม่เขียน summary** · brand-config.json `accepted: false`
- Blue Diamond ใส่ราคาโปร 29,900 ได้ (ตามเงื่อนไขและช่วงเวลาที่คลินิกประกาศ) — ⚠️ entity description ไม่มีวันหมดอายุ ต้องอัปเดตเมื่อโปรเปลี่ยน
- **"Q-Clinic" ไม่มีจริง สร้างความสับสน — เลิกใช้ทั้งหมด** → entity_name `Q-Clinic Direct Billing (SSO)` → `SSO Direct Billing (ไม่ต้องสำรองจ่าย)` · alias ตัด Q-Clinic · primary_entity_name 6 หน้า · slug 6.2.7.2 `what-is-a-q-clinic` → `what-is-an-sso-partner-clinic` · ถอด target keyword `q clinic ประกันสังคม` (คงแถว keyword ไว้เป็นหลักฐานว่าวัดแล้ว = 0) · เอกสารแผน/loader ล้างแล้ว (เว้น changelog/handover/reports = ประวัติ) · `entity_slug`/`entity_fingerprint` `sso-direct-billing-q-clinic` **คงไว้** เพราะเป็น join key ตาม COMMENT

**ค้างให้ operator:** หน้าที่ใช้ entity บัตรทอง/ข้าราชการเป็น primary — `6.5.4.4`, `5.13.2.5` (ประกันสังคม vs บัตรทอง), `5.13.5` (ข้าราชการ) — ถ้า "ห้ามพูดถึง" หน้าเหล่านี้ควรยุบ/redirect หรือเก็บเป็นหน้าเปรียบเทียบ? ยังไม่แตะ (กฎ: ยุบ/ย้ายหน้าต้องถาม)

รายละเอียด old(NULL)→new + sources ทุกตัว: `entity-summary-new-2026-09-17.json`
