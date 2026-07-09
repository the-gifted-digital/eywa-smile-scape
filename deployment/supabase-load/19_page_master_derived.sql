-- 19_page_master_derived.sql — Wave 6: derive node_tier_strategy + schema_markup_type (2026-07-09).
-- Both structural (no DFS). node_tier_strategy = hub/leaf role; schema_markup_type[] = schema.org types from page_type.
-- Idempotent overwrite. Result: node_tier_strategy pillar 62 / hub 34 / spoke 613 / supporting 13; schema 722/722.
with d as (
  select pm.page_fingerprint fp, pm.page_type pt, pm.parent_page_fp par,
    exists(select 1 from seo_website_page_master c where c.parent_page_fp=pm.page_fingerprint) is_hub
  from seo_website_page_master pm where pm.page_fingerprint like 'smilescape-%'
)
update public.seo_website_page_master p set
  node_tier_strategy = case
    when d.fp='smilescape-1' then 'pillar'
    when d.is_hub and d.par is null then 'pillar'
    when d.is_hub then 'hub'
    when d.par is not null then 'spoke'
    else 'supporting' end,
  schema_markup_type = case d.pt
    when 'condition_pillar' then array['MedicalCondition','MedicalWebPage']
    when 'procedure_pillar' then array['MedicalProcedure','MedicalWebPage']
    when 'service_page' then array['MedicalProcedure','WebPage']
    when 'technology_page' then array['MedicalDevice','WebPage']
    when 'knowledge_article' then array['Article','MedicalWebPage']
    when 'evidence_case' then array['Article','MedicalWebPage']
    when 'doctor_profile' then array['Physician','ProfilePage']
    when 'branch_landing' then array['Dentist','WebPage']
    when 'local_landing' then array['Dentist','WebPage']
    when 'about' then array['AboutPage']
    when 'contact' then array['ContactPage']
    when 'home' then array['WebPage']
    when 'pillar' then array['MedicalWebPage']
    else array['WebPage'] end::text[]
from d where p.page_fingerprint=d.fp;

select jsonb_object_agg(node_tier_strategy,c) node_tier_strategy_dist
from (select node_tier_strategy,count(*) c from public.seo_website_page_master where page_fingerprint like 'smilescape-%' group by 1) a;
