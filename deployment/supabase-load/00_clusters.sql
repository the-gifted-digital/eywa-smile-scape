-- 00_clusters.sql — seo_topic_cluster_master (SmileScape, 20 clusters).
-- cluster_type='topical'; sync_state='flat_loaded'; fingerprint/display auto by trigger.
insert into public.seo_topic_cluster_master
  (cluster_slug, cluster_name, cluster_type, brand_scope, brand_scope_primary, sync_state)
values
('dental-implant-core','Dental Implant — Core Procedure','topical',array['*']::text[],'*','flat_loaded'),
('implant-systems-brands','Implant Systems & Brands','topical',array['*']::text[],'*','flat_loaded'),
('all-on-x-full-arch','All-on-X Full-Arch Rehabilitation','topical',array['*']::text[],'*','flat_loaded'),
('patient-conditions-tooth-loss','Patient Conditions — Tooth Loss','topical',array['*']::text[],'*','flat_loaded'),
('bone-regeneration-gbr','Bone Regeneration & GBR','topical',array['*']::text[],'*','flat_loaded'),
('patient-conditions-bone','Patient Conditions — Bone Deficiency','topical',array['*']::text[],'*','flat_loaded'),
('smile-design-cosmetic','Smile Design & Cosmetic Dentistry','topical',array['*']::text[],'*','flat_loaded'),
('gum-soft-tissue','Gum & Soft Tissue Management','topical',array['*']::text[],'*','flat_loaded'),
('periodontics-perio-disease','Periodontics & Gum Disease','topical',array['*']::text[],'*','flat_loaded'),
('clear-aligner-orthodontics','Clear Aligner & Orthodontics','topical',array['*']::text[],'*','flat_loaded'),
('general-restorative','General Restorative Dentistry','topical',array['*']::text[],'*','flat_loaded'),
('digital-technology-diagnostics','Digital Technology & Diagnostics','topical',array['*']::text[],'*','flat_loaded'),
('implant-materials','Implant Materials & Biomaterials','topical',array['*']::text[],'*','flat_loaded'),
('dental-anatomy','Dental Anatomy & Physiology','topical',array['*']::text[],'*','flat_loaded'),
('brand-doctor-authority','Brand, Doctor & Authority Entities','topical',array['smile-scape-clinic']::text[],'smile-scape-clinic','flat_loaded'),
('pediatric-dentistry','Pediatric Dentistry — ทันตกรรมเด็ก','topical',array['*']::text[],'*','flat_loaded'),
('endodontics-specialist','Endodontics by Specialist — รักษารากฟันโดยทันตแพทย์เฉพาะทาง','topical',array['*']::text[],'*','flat_loaded'),
('dental-anesthesia','Sedation & GA Dentistry — ดมยาสลบทำฟัน','topical',array['*']::text[],'*','flat_loaded'),
('demographic-dentistry','Demographic-Specific Dentistry (Geriatric / Pregnancy / Medical-Compromised / Special Needs)','topical',array['*']::text[],'*','flat_loaded'),
('insurance-coverage-th','Insurance Coverage TH — ประกันสังคม/บัตรทอง/ราชการ/เอกชน','topical',array['*']::text[],'*','flat_loaded')
on conflict (cluster_slug) do nothing;

-- parent links (set parent_cluster_fp from parent's fingerprint by slug)
update public.seo_topic_cluster_master c set parent_cluster_fp=p.fingerprint from public.seo_topic_cluster_master p where c.cluster_slug='implant-systems-brands' and p.cluster_slug='dental-implant-core';
update public.seo_topic_cluster_master c set parent_cluster_fp=p.fingerprint from public.seo_topic_cluster_master p where c.cluster_slug='all-on-x-full-arch' and p.cluster_slug='dental-implant-core';
update public.seo_topic_cluster_master c set parent_cluster_fp=p.fingerprint from public.seo_topic_cluster_master p where c.cluster_slug='patient-conditions-bone' and p.cluster_slug='patient-conditions-tooth-loss';
update public.seo_topic_cluster_master c set parent_cluster_fp=p.fingerprint from public.seo_topic_cluster_master p where c.cluster_slug='periodontics-perio-disease' and p.cluster_slug='gum-soft-tissue';

-- validation
select count(*) total, count(parent_cluster_fp) with_parent
from public.seo_topic_cluster_master where cluster_slug in ('dental-implant-core','implant-systems-brands','all-on-x-full-arch','patient-conditions-tooth-loss','bone-regeneration-gbr','patient-conditions-bone','smile-design-cosmetic','gum-soft-tissue','periodontics-perio-disease','clear-aligner-orthodontics','general-restorative','digital-technology-diagnostics','implant-materials','dental-anatomy','brand-doctor-authority','pediatric-dentistry','endodontics-specialist','dental-anesthesia','demographic-dentistry','insurance-coverage-th');
