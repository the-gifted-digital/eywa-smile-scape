-- 16_page_strategy_schema.sql — Wave 6: derive node_tier_strategy + schema_markup_type. 2026-07-09.
-- Both deterministic (no DFS, no content). Idempotent overwrite by page_fingerprint.
--   node_tier_strategy (CHECK hub/spoke/pillar/supporting/leaf) <- hub/leaf role
--   schema_markup_type (text; NOTE live col is single text, NOT text[] as v1_8 spec said) <- page_type -> primary schema.org type
with role as (
  select p.page_fingerprint fp,
    (p.parent_page_fp is not null) has_parent,
    exists(select 1 from seo_website_page_master c where c.parent_page_fp=p.page_fingerprint) has_children,
    p.page_type pt
  from seo_website_page_master p
  where p.page_fingerprint like 'smilescape-%'
)
update public.seo_website_page_master p set
  node_tier_strategy = case
    when p.page_fingerprint='smilescape-1' then 'pillar'          -- home
    when r.has_children and not r.has_parent then 'pillar'        -- top-of-tree cluster pillar
    when r.has_children then 'hub'                                -- intermediate hub
    when r.has_parent then 'spoke'                                -- leaf under a hub
    else 'supporting' end,                                        -- standalone leaf
  schema_markup_type = case r.pt
    when 'condition_pillar' then 'MedicalCondition'
    when 'procedure_pillar' then 'MedicalProcedure'
    when 'service_page'     then 'MedicalProcedure'
    when 'technology_page'  then 'MedicalDevice'
    when 'knowledge_article' then 'Article'
    when 'evidence_case'    then 'Article'
    when 'doctor_profile'   then 'Physician'
    when 'branch_landing'   then 'Dentist'
    when 'local_landing'    then 'Dentist'
    when 'about'            then 'AboutPage'
    when 'contact'          then 'ContactPage'
    when 'home'             then 'WebPage'
    when 'pillar'           then 'MedicalWebPage'
    else 'WebPage' end
from role r where p.page_fingerprint = r.fp;

-- validation
select
 (select jsonb_object_agg(node_tier_strategy,c) from (select node_tier_strategy,count(*) c from public.seo_website_page_master where page_fingerprint like 'smilescape-%' group by 1) a) node_tier_strategy_dist,
 (select jsonb_object_agg(schema_markup_type,c order by c desc) from (select schema_markup_type,count(*) c from public.seo_website_page_master where page_fingerprint like 'smilescape-%' group by 1) b) schema_markup_type_dist;
