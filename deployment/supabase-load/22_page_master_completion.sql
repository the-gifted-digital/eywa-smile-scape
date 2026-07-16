-- 22_page_master_completion.sql — Wave 12: complete every keyword-independent page_master column (2026-07-16).
-- Operator spotted these empty; all derivable NOW. Conventions reverse-engineered from Deezy (689/689 filled = reference):
--   * content_format = TEMPLATE CODE (T1..T19) — this is where the template binding lives (Deezy: T1/T2b/T4..T19)
--   * conversion events = 'line_follow' / 'call_click' (LINE-first; branch/local/contact pages call-first)
--   * required_min_inbound/outbound by tier: A=3/2 B=2/2 C=1/1 D=1/1 (DR-021)
--   * word_count_target = tier × template-family (knowledge-family 2300→1550, service-family 1800→1200)
--   * link_role from node_tier_strategy · anchor_strategy_mode by page family · review_cycle by tier (A quarterly/B semiannual/else annual)
--   * priority (XML) 1.0/0.8/0.6/0.4 · link_priority 10(home)/9/7/5/4 · robots 'index, follow'
--   * parent_page_name / primary_entity_name = pure denormalizations
--   * related_entities_fps from seo_entity_relationships edges (both directions, ranked by edge type, cap 8);
--     fallback = same-cluster entities (cap 4). Result avg 5.5/page (Deezy avg 6.8).
-- NOT filled (correctly deferred): keyword set (target_keyword_fp/semantic/intent → DFS Gate),
--   Phase-F content (slug/title/meta/brief/canonical), DR-030 compliance flags (review output — NULL federation-wide),
--   ops (notion_id/published_date/viability_assessment).
-- Idempotent overwrite.

with d as (
  select p.page_fingerprint fp, p.node_tier tier, p.page_type pt, p.sitemap_node_id node,
         p.node_tier_strategy strat, p.cluster_id cl
  from seo_website_page_master p where p.page_fingerprint like 'smilescape-%'
),
m as (
  select fp,
    case
      when cl='insurance-coverage-th' then 'T16'
      when node like '6.5%' or node like '6.3%' then 'T12'
      when pt='condition_pillar' then 'T1'
      when pt='procedure_pillar' then 'T2'
      when pt='service_page' then 'T5'
      when pt='technology_page' then 'T4'
      when pt='knowledge_article' then 'T6'
      when pt='evidence_case' then 'T8'
      when pt='doctor_profile' then 'T9'
      when pt='branch_landing' then 'T10'
      when pt='local_landing' then 'T18'
      when pt in ('home','about','contact') then 'T11'
      else 'T6' end tpl,
    case when pt in ('branch_landing','local_landing','contact') then 'call_click' else 'line_follow' end conv1,
    case when pt in ('branch_landing','local_landing','contact') then array['line_follow'] else array['call_click'] end conv2,
    case tier when 'A' then 3 when 'B' then 2 else 1 end inb,
    case tier when 'A' then 2 when 'B' then 2 else 1 end outb,
    case when strat in ('pillar','hub') then 'primary_hub' when strat='supporting' then 'supporting' else 'cluster_spoke' end lrole,
    case
      when pt in ('home','about','doctor_profile','branch_landing','contact') then 'branded_navigational'
      when pt in ('service_page','procedure_pillar','technology_page','local_landing') then 'partial_diverse'
      when pt in ('condition_pillar','knowledge_article','evidence_case','pillar') then 'topical_diverse'
      else 'generic_mixed' end amode,
    case tier when 'A' then 'quarterly' when 'B' then 'semiannual' else 'annual' end rcycle,
    case tier when 'A' then '1.0' when 'B' then '0.8' when 'C' then '0.6' else '0.4' end prio,
    case when fp='smilescape-1' then '10' when tier='A' then '9' when tier='B' then '7' when tier='C' then '5' else '4' end lprio
  from d
)
update seo_website_page_master p set
  content_format = m.tpl,
  conversion_event_primary = m.conv1,
  conversion_event_secondary = m.conv2,
  required_min_inbound = m.inb,
  required_min_outbound = m.outb,
  auto_suggested_word_count_target = case
    when m.tpl in ('T1','T6','T12','T16','T8') then
      case p.node_tier when 'A' then 2300 when 'B' then 2050 when 'C' then 1800 else 1550 end
    else
      case p.node_tier when 'A' then 1800 when 'B' then 1600 when 'C' then 1400 else 1200 end
    end,
  link_role = m.lrole,
  anchor_strategy_mode = m.amode,
  review_cycle = m.rcycle,
  robots_directive = 'index, follow',
  priority = m.prio,
  link_priority = m.lprio,
  parent_page_name = (select pp.page_name from seo_website_page_master pp where pp.page_fingerprint = p.parent_page_fp),
  primary_entity_name = (select g.entity_name from seo_entity_graph g where g.entity_fingerprint = p.primary_entity_fp)
from m where p.page_fingerprint = m.fp;

-- related_entities_fps: from entity edges (both directions), ranked by edge-type, cap 8
with edges as (select from_entity_fp a, to_entity_fp b, edge_type from seo_entity_relationships),
rel as (select a ent, b other, edge_type from edges union all select b, a, edge_type from edges),
scored as (
  select ent, other, min(case edge_type
      when 'treats' then 1 when 'broader_than' then 2 when 'is_a' then 2
      when 'part_of' then 3 when 'requires' then 4 when 'symptom_of' then 5 else 6 end) pr
  from rel group by ent, other),
ranked as (select ent, other, row_number() over (partition by ent order by pr, other) rn from scored),
agg as (select ent, array_agg(other order by rn) related from ranked where rn <= 8 group by ent)
update seo_website_page_master p
set related_entities_fps = a.related
from agg a
where p.page_fingerprint like 'smilescape-%' and p.primary_entity_fp = a.ent;

-- fallback for edge-less entities: same-cluster mates, cap 4
with need as (
  select distinct p.primary_entity_fp ent, p.cluster_id cl
  from seo_website_page_master p
  where p.page_fingerprint like 'smilescape-%' and p.related_entities_fps is null),
cluster_mates as (
  select n.ent, g.entity_fingerprint other,
    row_number() over (partition by n.ent order by g.entity_fingerprint) rn
  from need n
  join seo_entity_graph g on g.topic_cluster_id = n.cl and g.entity_fingerprint <> n.ent
    and (g.load_source like 'smile-scape-clinic:%' or '*' = any(g.brand_scope))),
agg2 as (select ent, array_agg(other order by rn) related from cluster_mates where rn <= 4 group by ent)
update seo_website_page_master p
set related_entities_fps = a.related
from agg2 a
where p.page_fingerprint like 'smilescape-%' and p.related_entities_fps is null and p.primary_entity_fp = a.ent;

-- validation
select count(*) total, count(content_format) tpl, count(related_entities_fps) related,
  count(parent_page_name) parent_nm, count(primary_entity_name) entity_nm,
  count(conversion_event_primary) conv, count(auto_suggested_word_count_target) wc,
  count(required_min_inbound) minlinks, count(review_cycle) cycle
from seo_website_page_master where page_fingerprint like 'smilescape-%';
