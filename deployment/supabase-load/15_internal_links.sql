-- 15_internal_links.sql — Wave 5: planned internal-link graph for SmileScape (DR-021). 2026-07-09.
-- Deterministic structural layers only (no DFS, no content drafting). status='planned', implemented=false.
-- anchor_text = target page_name (refined to authored topical anchors at Phase F).
-- Mirrors VTH BioDent's model (breadcrumb + navigational + contextual). Auto-reciprocal trigger flags is_reciprocal.
-- Idempotent: every insert guards with NOT EXISTS on (from,to,link_type).
-- Final footprint: 2306 links — breadcrumb 1580 · navigational 660 · contextual 66 · orphans 0 · avg inbound 3.2/page.

-- L1 — BREADCRUMB: each page -> every ancestor (parent chain) + home. role=primary_hub, pri 9.
with recursive chain as (
  select p.page_fingerprint page_fp, p.parent_page_fp anc_fp
  from seo_website_page_master p
  where p.page_fingerprint like 'smilescape-%' and p.parent_page_fp is not null
  union all
  select c.page_fp, a.parent_page_fp
  from chain c join seo_website_page_master a on a.page_fingerprint=c.anc_fp
  where a.parent_page_fp is not null
),
anc as (
  select page_fp, anc_fp from chain
  union
  select page_fingerprint, 'smilescape-1'
  from seo_website_page_master
  where page_fingerprint like 'smilescape-%' and page_fingerprint <> 'smilescape-1'
)
insert into seo_page_internal_links
 (from_page_fp,to_page_fp,link_type,link_role,link_priority,anchor_text,anchor_variant_type,section_context,status,planned,implemented,is_cross_brand,brand_scope)
select a.page_fp, a.anc_fp, 'breadcrumb', 'primary_hub', 9, t.page_name,
  case when a.anc_fp='smilescape-1' then 'branded' else 'exact' end, 'breadcrumb',
  'planned', true, false, false, array['smile-scape-clinic']::text[]
from anc a join seo_website_page_master t on t.page_fingerprint=a.anc_fp
where a.page_fp <> a.anc_fp
  and not exists (select 1 from seo_page_internal_links l where l.from_page_fp=a.page_fp and l.to_page_fp=a.anc_fp and l.link_type='breadcrumb');

-- L2 — HUB->SPOKE: parent -> each direct child. role=cluster_spoke, pri 7.
insert into seo_page_internal_links
 (from_page_fp,to_page_fp,link_type,link_role,link_priority,anchor_text,anchor_variant_type,section_context,status,planned,implemented,is_cross_brand,brand_scope)
select c.parent_page_fp, c.page_fingerprint, 'navigational', 'cluster_spoke', 7, c.page_name,
  'exact', 'child-nav', 'planned', true, false, false, array['smile-scape-clinic']::text[]
from seo_website_page_master c
where c.page_fingerprint like 'smilescape-%' and c.parent_page_fp is not null
  and not exists (select 1 from seo_page_internal_links l where l.from_page_fp=c.parent_page_fp and l.to_page_fp=c.page_fingerprint and l.link_type='navigational');

-- L3 — CURATED CROSS-CLUSTER: 66 operator "→ link X.Y" annotations parsed from sitemap.md. role=cross_cluster, pri 6.
with pairs(from_fp,to_fp) as (values
('smilescape-3.1.5','smilescape-3.9.1'),('smilescape-3.2.8.3','smilescape-3.3'),('smilescape-3.2.8.4','smilescape-3.3'),('smilescape-3.2.11.1','smilescape-3.5.2'),('smilescape-3.2.11.2','smilescape-3.5.4'),('smilescape-3.3.5','smilescape-3.5.4'),('smilescape-3.3.6','smilescape-3.13.1'),('smilescape-3.4.1.3','smilescape-3.7'),('smilescape-3.5.1.3','smilescape-3.2.8'),('smilescape-3.6.8','smilescape-3.11.6'),('smilescape-3.7.4','smilescape-3.2.9.7.3'),('smilescape-3.7.7.9','smilescape-3.4.1'),('smilescape-3.8.1','smilescape-3.4.4'),('smilescape-3.9.2.4','smilescape-3.5.1'),('smilescape-3.9.3.3','smilescape-3.6.6'),('smilescape-3.11.13','smilescape-3.12.6'),('smilescape-3.13.1.2','smilescape-3.2.8.7'),('smilescape-3.13.1.3','smilescape-3.2.10.2'),('smilescape-3.13.1.4','smilescape-5.18'),('smilescape-3.13.2.1','smilescape-5.20.4'),('smilescape-3.13.3.4','smilescape-5.8.6'),('smilescape-3.13.3.5','smilescape-5.8.7'),('smilescape-3.13.3.6','smilescape-5.8.9'),('smilescape-4.2','smilescape-3.1'),('smilescape-4.3','smilescape-3.1.4'),('smilescape-4.5','smilescape-3.2.11.6'),('smilescape-4.7','smilescape-3.5'),('smilescape-4.9.1','smilescape-3.9.3.1'),('smilescape-5.6.2.2','smilescape-3.6'),('smilescape-5.6.2.4','smilescape-3.11.4'),('smilescape-5.6.3.1','smilescape-3.7'),('smilescape-5.6.3.7','smilescape-3.7.7'),('smilescape-5.6.5','smilescape-5.16'),('smilescape-5.6.6','smilescape-5.17'),('smilescape-5.6.7','smilescape-5.16'),('smilescape-5.10.7','smilescape-3.10.8'),('smilescape-5.10.9','smilescape-3.10.1.1'),('smilescape-5.11.1','smilescape-3.2.9.7.3'),('smilescape-5.11.5','smilescape-3.2.9.7'),('smilescape-5.11.6','smilescape-3.2.9.7.1'),('smilescape-5.11.7','smilescape-3.2.9.7.2'),('smilescape-5.11.8','smilescape-3.2.9.7'),('smilescape-5.11.9','smilescape-3.2.9.7'),('smilescape-5.13.2.2','smilescape-3.4.1.7'),('smilescape-5.13.2.10','smilescape-3.14.1'),('smilescape-5.14.6','smilescape-3.11'),('smilescape-5.14.7','smilescape-5.19.4'),('smilescape-5.15.5','smilescape-5.16'),('smilescape-5.16.4','smilescape-3.6.7'),('smilescape-5.16.7','smilescape-5.15'),('smilescape-5.17.5','smilescape-5.6.3'),('smilescape-5.17.6','smilescape-3.6'),('smilescape-5.18.5','smilescape-5.8.12'),('smilescape-5.18.6','smilescape-5.8.1'),('smilescape-5.19.6','smilescape-3.2.12'),('smilescape-5.19.8','smilescape-3.2.9.7'),('smilescape-5.20.4','smilescape-5.6.3'),('smilescape-5.21.5','smilescape-2.2.2'),('smilescape-6.5.2.3','smilescape-5.19'),('smilescape-6.5.2.4','smilescape-5.14'),('smilescape-6.5.2.5','smilescape-5.5'),('smilescape-6.5.2.6','smilescape-5.21'),('smilescape-6.5.3.1','smilescape-5.8.1'),('smilescape-6.5.3.2','smilescape-5.20'),('smilescape-6.5.3.3','smilescape-5.12'),('smilescape-6.5.3.4','smilescape-5.8'))
insert into seo_page_internal_links
 (from_page_fp,to_page_fp,link_type,link_role,link_priority,anchor_text,anchor_variant_type,section_context,status,planned,implemented,is_cross_brand,brand_scope)
select pr.from_fp, pr.to_fp, 'contextual', 'cross_cluster', 6, t.page_name,
  'partial', 'sitemap-cross-ref', 'planned', true, false, false, array['smile-scape-clinic']::text[]
from pairs pr
join seo_website_page_master f on f.page_fingerprint=pr.from_fp
join seo_website_page_master t on t.page_fingerprint=pr.to_fp
where not exists (select 1 from seo_page_internal_links l where l.from_page_fp=pr.from_fp and l.to_page_fp=pr.to_fp and l.link_type='contextual');

-- L4 — ORPHAN-CLOSE: any page with 0 inbound gets one from its nearest existing ancestor (else home).
with orphans as (
  select p.page_fingerprint fp, p.sitemap_node_id node, p.page_name nm
  from seo_website_page_master p
  where p.page_fingerprint like 'smilescape-%'
    and not exists(select 1 from seo_page_internal_links l where l.to_page_fp=p.page_fingerprint)
),
closed as (
  select o.fp, o.nm,
    coalesce((select a.page_fingerprint from seo_website_page_master a
              where a.page_fingerprint like 'smilescape-%' and o.node like a.sitemap_node_id || '.%'
              order by length(a.sitemap_node_id) desc limit 1), 'smilescape-1') src_fp
  from orphans o
)
insert into seo_page_internal_links
 (from_page_fp,to_page_fp,link_type,link_role,link_priority,anchor_text,anchor_variant_type,section_context,status,planned,implemented,is_cross_brand,brand_scope)
select c.src_fp, c.fp, 'navigational', 'cluster_spoke', 7, c.nm,
  'exact', 'orphan-close', 'planned', true, false, false, array['smile-scape-clinic']::text[]
from closed c
where c.src_fp <> c.fp
  and not exists (select 1 from seo_page_internal_links l where l.from_page_fp=c.src_fp and l.to_page_fp=c.fp);

-- validation
select (select count(*) from seo_page_internal_links where from_page_fp like 'smilescape-%') total,
  (select count(*) from seo_website_page_master p where p.page_fingerprint like 'smilescape-%'
     and not exists(select 1 from seo_page_internal_links l where l.to_page_fp=p.page_fingerprint)) orphans;
