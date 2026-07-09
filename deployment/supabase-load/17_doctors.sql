-- 17_doctors.sql — Wave 8: complete founder/doctor data (หมอแฮม + หมอแพรว). 2026-07-09.
-- Source: web/src/data/doctors.json + docs/team/*.md (verbatim CV extraction).
-- Pre-state: both had seo_authors_reviewers rows (Wave 04) but หมอแพรว had NO person entity
--   and her seo_doctor_assignments.author_fp was NULL; her profile page 2.2.3 pointed at the
--   org placeholder. หมอแฮม already had entity dr-woraphat-jarangkul.
-- NOTE: personal phone/email/address in doctors.json are PRIVATE (per _meta.contact_warning) —
--   deliberately NOT loaded into any public column. medical_license_number not in source → still operator-pending.
-- Idempotent.

-- 1) หมอแพรว Person entity (mirrors dr-woraphat-jarangkul)
insert into public.seo_entity_graph
 (entity_fingerprint, entity_name, entity_slug, entity_type, schema_org_type,
  parent_entity_fp, topic_cluster_id, entity_lifecycle, aliases, brand_scope)
values
('dr-pitchapa-phudphong','Dr. Pitchapa Phudphong','dr-pitchapa-phudphong','person','Physician',
 'smilescape-dental-clinic','brand-doctor-authority','Growing',
 array['หมอแพรว','ทพญ. พิชชาภา ผุดผ่อง','Dr. Praew','Specialist Oral & Maxillofacial Surgeon SmileScape','Co-CEO SmileScape']::text[],
 array['smile-scape-clinic']::text[])
on conflict (entity_fingerprint) do nothing;

-- 2) link her doctor_assignment to the new person entity
update public.seo_doctor_assignments d set author_fp='dr-pitchapa-phudphong'
where d.author_id='0efbddef-364b-4a6b-ae2f-3b201c9a5185' and d.author_fp is null;

-- 3) point her profile page (2.2.3) at her entity + re-derive derived fields to doctor_profile
update public.seo_website_page_master p set
  primary_entity_fp = 'dr-pitchapa-phudphong',
  page_type = 'doctor_profile',
  schema_markup_type = 'Physician',
  node_tier_strategy = 'spoke',
  cluster_id = (select topic_cluster_id from public.seo_entity_graph where entity_fingerprint='dr-pitchapa-phudphong')
where p.page_fingerprint='smilescape-2.2.3';

-- 4) หมอแฮม board_certifications: null -> [] (verified none — CV shows OMS Certificate + dual M.Sc.,
--    no Thai Board diploma; distinct from หมอแพรว who holds the Thai Board OMFS Diploma 2023).
update public.seo_authors_reviewers set board_certifications='[]'::jsonb
where fingerprint='auth_9D1AD1694B2A4544' and board_certifications is null;

-- validation
select
 (select count(*) from public.seo_entity_graph where entity_type='person' and 'smile-scape-clinic'=any(brand_scope)) ss_person_entities,
 (select count(*) from public.seo_authors_reviewers where brand_scope=array['smile-scape-clinic'] and board_certifications is null) ss_authors_null_board,
 (select count(*) from public.seo_doctor_assignments where brand_id='c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25' and author_fp is null) assignments_null,
 (select count(*) from public.seo_website_page_master where page_fingerprint like 'smilescape-%' and page_type='doctor_profile') doctor_profile_pages;
