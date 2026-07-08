-- 14_page_type.sql — Wave 4 (partial): derive SEMANTIC page_type for SmileScape (2026-07-09).
-- page_type = page CATEGORY (drives template T1-T22 + schema.org). NOT the A/B/C/D tier (=node_tier).
-- Origin-of-meaning: archive/Schema_Overview_EYWA_v1_8.md L995 (page_type) vs L992/L1143 (node_tier CHECK A/B/C/D).
-- The sitemap markdown "Page Type" column (mostly 'A') is a legacy placeholder — deliberately NOT used.
-- Derived deterministically from primary_entity.entity_type + sitemap_section + hub/leaf (no keyword research).
-- Idempotent: plain overwrite by page_fingerprint.
with d as (
  select pm.page_fingerprint fp, pm.sitemap_section sec, pm.sitemap_node_id node,
         g.entity_type et,
         exists(select 1 from seo_website_page_master c where c.parent_page_fp = pm.page_fingerprint) is_hub
  from seo_website_page_master pm
  join seo_entity_graph g on g.entity_fingerprint = pm.primary_entity_fp
  where pm.page_fingerprint like 'smilescape-%'
),
m as (
  select fp,
    case
      when sec='1' then 'home'
      when sec='2' and et='person' then 'doctor_profile'
      when sec='2' then 'about'
      when sec='4' then 'technology_page'            -- whole Technology section
      when sec='6' then 'knowledge_article'          -- whole Knowledge section
      when sec='7' then 'evidence_case'              -- whole Case Studies section
      when sec='8' and node='8.1' then 'contact'
      when sec='8' and node ~ '^8\.[0-9]+$' then 'branch_landing'   -- 8.2 / 8.3 branch hubs
      when sec='8' then 'local_landing'                              -- 8.2.x / 8.3.x localized pages
      when et in ('condition','symptom') then 'condition_pillar'
      when et in ('device','product','technology') then 'technology_page'
      when et in ('procedure','treatment') and is_hub then 'procedure_pillar'
      when et in ('procedure','treatment') then 'service_page'
      when et='specialty' then 'service_page'
      when et='person' then 'doctor_profile'
      when is_hub then 'pillar'                       -- concept/organization hubs
      else 'supporting'
    end pt
  from d
)
update public.seo_website_page_master p set page_type = m.pt
from m where p.page_fingerprint = m.fp;

-- validation
select jsonb_object_agg(page_type, c order by c desc) page_type_distribution, sum(c) total
from (select page_type, count(*) c from public.seo_website_page_master
      where page_fingerprint like 'smilescape-%' group by page_type) x;
