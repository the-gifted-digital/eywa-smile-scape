-- 06b_pages_delta.sql — Wave 2b: insert 55 NEW R26 nodes missing from DB (post 55-stale delete).
-- Regenerated from R26 sitemap. Idempotent ON CONFLICT. Cluster set from entity after.
insert into public.seo_website_page_master
  (page_fingerprint, page_name, sitemap_node_id, primary_entity_fp, status, brand_id, brand_name)
values
('smilescape-3.4.1.1','ขูดหินปูนแบบ Ultrasonic — มาตรฐาน','3.4.1.1','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.2','ขูดหินปูนแบบ Air Polishing — ขจัดคราบลึก ไม่เจ็บ','3.4.1.2','airflow-air-polishing','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.3','Deep Cleaning / Scaling & Root Planing — รักษาโรคเหงือกระยะแรก (→ link 3.7 Periodontics)','3.4.1.3','periodontitis','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.4','ขูดหินปูน ราคา — เปรียบเทียบราคาแต่ละแบบ','3.4.1.4','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.5','ขูดหินปูน เจ็บไหม — ความรู้สึกจริง + วิธีลดเจ็บ','3.4.1.5','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.6','ขูดหินปูนบ่อยแค่ไหน — Schedule ที่แนะนำ','3.4.1.6','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.7','ขูดหินปูนใช้สิทธิประกันสังคม / สปสช','3.4.1.7','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.4.1.8','ขูดหินปูนหลังจัดฟัน / หลังฝังรากเทียม','3.4.1.8','dental-scaling','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.5.2','สะพานฟัน — Dental Bridge','3.5.2','dental-crown','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.6.7','ฟันร้าว / รากฟันแตก — Cracked Tooth / Vertical Root Fracture','3.6.7','cracked-tooth','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.6.8','Pulp Regeneration / Apexogenesis (เด็ก) (→ link 3.11.6)','3.6.8','pulp-regeneration','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.6.9','รักษารากฟัน vs ถอน + รากเทียม — เปรียบเทียบทางเลือก','3.6.9','root-canal-treatment','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.2.1','Porcelain Veneer — วีเนียร์พอร์ซเลน','3.9.2.1','porcelain-veneer','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.2.2','Composite Veneer — วีเนียร์คอมโพสิท (DFS 590/mo)','3.9.2.2','dental-veneer','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.2.3','วีเนียร์ ราคา — เปรียบเทียบราคาแต่ละแบบ (R21 — commercial intent)','3.9.2.3','dental-veneer','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.2.4','วีเนียร์ vs ครอบฟัน — เลือกแบบไหน (R21 → link 3.5.1 Crown)','3.9.2.4','dental-veneer','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.3.1','Cool Light Whitening — ฟอกฟันในคลินิกที่ SmileScape (→ tech 4.9.1 device)','3.9.3.1','teeth-whitening','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.3.2','Home Bleaching — ฟอกที่บ้านด้วยถาดฟอก','3.9.3.2','teeth-whitening','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.9.3.3','Walking Bleach — ฟอกฟันตายภายในเฉพาะซี่ (→ link 3.6.6 Internal Bleaching)','3.9.3.3','internal-bleaching','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.1','SmileScape In-House Clear Aligner (Signature #6 — commercial face)','3.10.1.1','direct-print-clear-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.2','จัดฟันใสแบบ Progressive Force — Multi-Layer Material (Soft→Hard) — 2nd option','3.10.1.2','trioclear-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.3','จัดฟันใส Thermoformed — Conventional Clear Aligner — 3rd option (R16)','3.10.1.3','thermoformed-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.4','ใครเหมาะ / ไม่เหมาะกับจัดฟันใส + ข้อจำกัด (R16: รวม candidacy + limitations)','3.10.1.4','clear-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.5','ราคาจัดฟันใส SmileScape — In-House Direct Print vs Outsourced Lab Tier','3.10.1.5','clear-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.1.6','การดูแล Aligner — Cleaning + Storage + Replacement Schedule','3.10.1.6','clear-aligner','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.3.1','Passive Self-Ligating (PSL) — Metal vs Ceramic Options (R17: metal/ceramic detail = in-page sections)','3.10.3.1','passive-self-ligating','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.3.2','Active vs Passive Self-Ligating — เปรียบเทียบ (2 ตัวเลือกจริงที่คลินิกมี)','3.10.3.2','passive-self-ligating','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8','จัดฟันร่วมผ่าตัดเลื่อนขากรรไกร — Orthognathic Surgery Program (hub)','3.10.8','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.1','ใครเหมาะ — Class III / Class II Severe / Skeletal Asymmetry','3.10.8.1','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.2','ขั้นตอน — Pre-surgical Ortho → Surgery → Post-surgical Ortho','3.10.8.2','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.3','BSSO / IVRO — ผ่าตัดเลื่อนขากรรไกรล่าง','3.10.8.3','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.4','Le Fort I — ผ่าตัดขากรรไกรบน','3.10.8.4','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.5','Bimaxillary (Two-jaw) Surgery','3.10.8.5','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.6','Genioplasty — เสริม/ลดคาง','3.10.8.6','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.7','Surgery-First Approach','3.10.8.7','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.10.8.8','ระยะเวลา & ค่าใช้จ่าย','3.10.8.8','orthognathic-surgery','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.11.10','Habit Appliance — แก้ดูดนิ้ว / อมจุก / กัดริมฝีปาก','3.11.10','habit-appliance','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.11.11','จัดการพฤติกรรมเด็กกลัวหมอ — Behavior Management','3.11.11','behavior-management','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.11.12','Early Orthodontic Intervention — จัดฟันเด็กระยะแรก','3.11.12','early-orthodontic-intervention','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.11.13','ดมยาสลบทำฟันเด็ก (→ link 3.12.6)','3.11.13','ga-dentistry','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.12.1','Conscious Sedation — Nitrous Oxide (แก๊สหัวเราะ) / Oral Sedation','3.12.1','conscious-sedation','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.12.4','ใครเหมาะกับการดมยาสลบทำฟัน — Special Needs / Severe Anxiety / Complex Case','3.12.4','dental-anxiety','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.12.6','ดมยาสลบทำฟันเด็ก — Pediatric GA','3.12.6','ga-dentistry','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.12.7','ดมยาสลบสำหรับฝังรากฟันเทียม / All-on-X','3.12.7','ga-dentistry','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.13.1.1','ทำฟันร่วมกับโรคประจำตัวผู้สูงอายุ — Comorbidity Management','3.13.1.1','medical-compromised-dentistry','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.13.1.2','ฟันปลอม / Overdenture สำหรับผู้สูงอายุ (→ link 3.2.8.7 + 3.5.4 Denture)','3.13.1.2','overdenture','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.13.2.1','Pregnancy Gingivitis Treatment (kept standalone — clinical condition + entity match + EFP evidence base) (→ link 5.20.4)','3.13.2.1','pregnancy-gingivitis','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14','ทำฟันด้วยสิทธิ์ประกันสังคม ที่ SmileScape (hub)','3.14','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.1','ขั้นตอน "ไม่ต้องสำรองจ่าย" ที่ SmileScape Q-Clinic','3.14.1','sso-direct-billing-q-clinic','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.2','ตรวจสิทธิ์ + เอกสารใช้สิทธิประกันสังคม (sub-hub)','3.14.2','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.2.1','วิธีตรวจสิทธิประกันสังคม Online — sso.go.th + แอป SSO Connect (R9 DFS 2,400/mo)','3.14.2.1','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.2.2','เอกสารที่ต้องเตรียม — Checklist + ID card / payslip / claim form (R9 DFS 720/mo)','3.14.2.2','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.2.3','ใช้สิทธิ์ครั้งแรก ที่ SmileScape — Step-by-step','3.14.2.3','sso-direct-billing-q-clinic','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.2.4','ตรวจสิทธิ์ ม.39 / ม.40 — Article-specific guidance','3.14.2.4','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic'),
('smilescape-3.14.3','Upsell Pathway — ทำพื้นฐานด้วยประกัน + ต่อยอด Implant / Aesthetic','3.14.3','social-security-dental-benefit','Planned','smile-scape-clinic','Smile Scape Clinic')
on conflict (page_fingerprint) do nothing;

update public.seo_website_page_master p set cluster_id = g.topic_cluster_id
  from public.seo_entity_graph g
  where p.brand_id='smile-scape-clinic' and p.primary_entity_fp is not null and p.cluster_id is null
    and g.entity_fingerprint = p.primary_entity_fp;

select count(*) total, count(primary_entity_fp) with_entity, count(cluster_id) with_cluster
from public.seo_website_page_master where brand_id='smile-scape-clinic';
