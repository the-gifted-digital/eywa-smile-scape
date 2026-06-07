-- 02_entity_extensions.sql — type-extension binding for lowercase-type entities.
-- entity_fp = entity_fingerprint = slug (FK -> seo_entity_graph.entity_fingerprint).
-- UNIQUE(entity_fp) per table -> idempotent. Defers product+device (enum mismatch). drug needs generic_name.
insert into public.seo_entity_condition (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='condition'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_symptom (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='symptom'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_anatomy (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='anatomy'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_procedures (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='procedure'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_drug (entity_fp, generic_name)
select entity_fingerprint, entity_name from public.seo_entity_graph where entity_type='drug'
on conflict (entity_fp) do nothing;

-- validation: ext rows that bind to a SmileScape-scoped entity
select 'condition' ext, count(*) n from public.seo_entity_condition c
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=c.entity_fp
               and g.entity_type='condition' and 'smile-scape-clinic'=any(g.brand_scope))
union all select 'procedures', count(*) from public.seo_entity_procedures p
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=p.entity_fp
               and g.entity_type='procedure' and 'smile-scape-clinic'=any(g.brand_scope))
union all select 'anatomy', count(*) from public.seo_entity_anatomy a
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=a.entity_fp
               and g.entity_type='anatomy' and 'smile-scape-clinic'=any(g.brand_scope))
order by ext;
