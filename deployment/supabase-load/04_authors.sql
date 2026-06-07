-- 04_authors.sql — seo_authors_reviewers (2) + seo_doctor_assignments. brand_id = SmileScape brands.id.
-- Source: docs/team/dr-worapat-jarangkul.md + docs/team/dr-pitchapa-phudphong.md.
-- Exclude dr-tomas-linkevicius (external authority -> graph entity only). fingerprint/display auto by trigger.
-- License numbers not on either CV -> NULL (operator UPDATE later). author_fp links to person entity where one exists.
with a1 as (
  insert into public.seo_authors_reviewers
    (full_name, canonical_names, credential_types, board_certifications, medical_license_number,
     medical_license_country, brand_scope, primary_specialty, specialties, languages_spoken,
     is_active, short_bio, bio)
  values
    ('ทพ. วรภัทร จรางกุล',
     '{"th":"ทพ. วรภัทร จรางกุล","en":"Dr. Worapat Jarangkul","nickname_th":"หมอแฮม","nickname_en":"Dr. Ham"}'::jsonb,
     array['DDS','MSc']::text[], NULL, NULL,
     'TH', array['smile-scape-clinic']::text[], 'Implantology & Oral Surgery',
     array['Implantology','Oral Surgery','Guided Bone Regeneration','Full-Arch Rehabilitation','Digital Dentistry']::text[],
     array['th','en']::text[], true,
     'Co-CEO, Medical Director & Lead Implantologist, SmileScape',
     'ทพ. วรภัทร จรางกุล (หมอแฮม) Co-CEO ผู้อำนวยการด้านการแพทย์และทันตแพทย์รากเทียมหลักของ SmileScape — ทันตแพทยศาสตรบัณฑิตเกียรตินิยมอันดับหนึ่งเหรียญทอง มหาวิทยาลัยมหิดล, วุฒิบัตรศัลยศาสตร์ช่องปาก จุฬาลงกรณ์มหาวิทยาลัย, M.Sc. Oral Surgery & Implantology (มหิดล + University of Duisburg-Essen) เชี่ยวชาญทันตกรรมรากเทียม การบูรณะทั้งขากรรไกร การปลูกกระดูก (GBR) และทันตกรรมดิจิทัล')
  returning id
)
insert into public.seo_doctor_assignments
  (author_id, author_fp, brand_id, branch_id, role_at_brand, is_primary_role, sync_state)
select id, 'dr-woraphat-jarangkul', 'c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid, NULL, 'medical_director', true, 'flat_loaded'
from a1;

with a2 as (
  insert into public.seo_authors_reviewers
    (full_name, canonical_names, credential_types, board_certifications, medical_license_number,
     medical_license_country, brand_scope, primary_specialty, specialties, languages_spoken,
     is_active, short_bio, bio)
  values
    ('ทพญ. พิชชาภา ผุดผ่อง',
     '{"th":"ทพญ. พิชชาภา ผุดผ่อง","en":"Dr. Pitchapa Phudphong","nickname_th":"หมอแพรว","nickname_en":"Dr. Praew"}'::jsonb,
     array['DDS']::text[], array['Diploma, Thai Board of Oral and Maxillofacial Surgery (2023)']::text[], NULL,
     'TH', array['smile-scape-clinic']::text[], 'Oral & Maxillofacial Surgery',
     array['Oral & Maxillofacial Surgery','Implantology','Zygomatic Implants','Guided Bone Regeneration','Full-Arch Rehabilitation']::text[],
     array['th','en']::text[], true,
     'Co-CEO & Specialist Oral & Maxillofacial Surgeon, SmileScape',
     'ทพญ. พิชชาภา ผุดผ่อง (หมอแพรว) Co-CEO และศัลยแพทย์เฉพาะทางช่องปากและแม็กซิลโลเฟเชียลของ SmileScape — ทันตแพทยศาสตรบัณฑิต ม.เชียงใหม่, อนุมัติบัตร Thai Board of Oral and Maxillofacial Surgery (2566), เชี่ยวชาญทันตกรรมรากเทียม การบูรณะทั้งขากรรไกร การปลูกกระดูก (GBR) และรากฟันเทียมไซโกมาติก อาจารย์ผู้สอนหลักสูตร Thai-German Basic Implantology Course (TG-BIC)')
  returning id
)
insert into public.seo_doctor_assignments
  (author_id, author_fp, brand_id, branch_id, role_at_brand, is_primary_role, sync_state)
select id, NULL, 'c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid, NULL, 'medical_director', false, 'flat_loaded'
from a2;

-- validation
select r.full_name, r.fingerprint, r.primary_specialty, d.role_at_brand, d.is_primary_role
from seo_authors_reviewers r join seo_doctor_assignments d on d.author_id=r.id
where 'smile-scape-clinic' = any(r.brand_scope) order by d.is_primary_role desc;
