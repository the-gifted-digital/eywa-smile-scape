-- 05_branches.sql — seo_branches (SmileScape, 2, PARTIAL). brand_id=uuid. branch_fingerprint=slug.
-- street/full/lat/lng/postal/phone/email/line/license = NULL -> operator batch UPDATE later (DR-025).
-- organization_entity_id resolved from the Organization entities loaded in 01 (slug == branch_fingerprint).
insert into public.seo_branches
  (branch_fingerprint, brand_id, brand_slug, branch_name, branch_slug, business_name_brand,
   is_primary, city, region, country_code, website_url, status, local_business_schema_type)
values
  ('smilescape-rattanathibet','c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid,'smile-scape-clinic',
   'SmileScape สาขารัตนาธิเบศร์','smilescape-rattanathibet','SmileScape สาขารัตนาธิเบศร์',
   true,'นนทบุรี','นนทบุรี','TH','https://smilescapeclinic.com/รัตนาธิเบศร์','active','DentalClinic'),
  ('smilescape-srinakarin','c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid,'smile-scape-clinic',
   'SmileScape สาขาศรีนครินทร์','smilescape-srinakarin','SmileScape สาขาศรีนครินทร์',
   false,'กรุงเทพมหานคร','กรุงเทพมหานคร','TH','https://smilescapeclinic.com/ศรีนครินทร์','active','DentalClinic')
on conflict (branch_fingerprint) do nothing;

-- link organization entity (if present in graph)
update public.seo_branches b set organization_entity_id = g.id
from public.seo_entity_graph g
where b.brand_slug='smile-scape-clinic' and g.entity_fingerprint = b.branch_fingerprint;

-- validation
select branch_slug, fingerprint, is_primary, city, organization_entity_id is not null as org_linked
from seo_branches where brand_id='c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid order by is_primary desc;
