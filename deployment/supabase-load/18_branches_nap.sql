-- 18_branches_nap.sql — Wave 9: operator-verified branch NAP/geo/GBP (2026-07-09).
-- Source: operator-supplied Google Business Profile share links (share.google/J4Z732WoNtZfWgBYG,
--   share.google/94nmxV2iZNhvLhUiH) resolved via firecrawl. Both branch rows already exist (05_branches.sql).
-- geo_point = geography(Point,4326). opening_hours = jsonb OpeningHoursSpecification. Idempotent overwrite.
update public.seo_branches set
  business_name_brand = 'SmileScape Dental Clinic สาขารัตนาธิเบศร์',
  street_address = '401, 403 ถนนรัตนาธิเบศร์',
  district = 'บางกระสอ', city = 'เมืองนนทบุรี', region = 'นนทบุรี',
  country_code = 'TH', postal_code = '11000',
  formatted_address = '401, 403 ถนนรัตนาธิเบศร์ ตำบลบางกระสอ อำเภอเมืองนนทบุรี นนทบุรี 11000',
  latitude = 13.8528902, longitude = 100.5233113,
  geo_point = ST_SetSRID(ST_MakePoint(100.5233113, 13.8528902), 4326)::geography,
  plus_code = 'G3QF+QP',
  phone = '+66 92 293 6226',
  website_url = 'https://smilescapeclinic.com',
  opening_hours = '[{"opens":"10:00","closes":"20:00","dayOfWeek":["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]}]'::jsonb,
  gbp_place_id = 'ChIJfs2aP5tPazsRhyIUDuzx2Cw',
  gbp_review_count = 773, gbp_avg_rating = 4.9,
  local_business_schema_type = 'DentalClinic'
where brand_slug='smile-scape-clinic' and branch_slug='smilescape-rattanathibet';

update public.seo_branches set
  business_name_brand = 'SmileScape Dental Clinic สาขาศรีนครินทร์',
  street_address = '1, 7 โครงการ ซอยหมู่บ้านแกรนด์ เดอ วิลล์',
  district = 'หนองบอน', city = 'ประเวศ', region = 'กรุงเทพมหานคร',
  country_code = 'TH', postal_code = '10250',
  formatted_address = '1, 7 โครงการ ซอยหมู่บ้านแกรนด์ เดอ วิลล์ แขวงหนองบอน เขตประเวศ กรุงเทพมหานคร 10250',
  latitude = 13.7031, longitude = 100.617,
  geo_point = ST_SetSRID(ST_MakePoint(100.617, 13.7031), 4326)::geography,
  plus_code = '7C5J+W5',
  phone = '+66 63 649 5396',
  website_url = 'https://smilescapeclinic.com',
  opening_hours = '[{"opens":"10:30","closes":"20:00","dayOfWeek":["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]}]'::jsonb,
  gbp_place_id = 'ChIJ67n4qsoVHTERFRL5aFg2tJ4',
  gbp_review_count = 141, gbp_avg_rating = 4.8,
  local_business_schema_type = 'DentalClinic'
where brand_slug='smile-scape-clinic' and branch_slug='smilescape-srinakarin';

-- Still NULL (operator/later): business_name_legal, email, line_id, gbp_account_id,
--   apple_maps_id, facebook_page_url, wongnai_url, medical_license_no, business_registration_no.
select branch_slug, phone, gbp_place_id, latitude, longitude, postal_code, gbp_avg_rating
from public.seo_branches where brand_slug='smile-scape-clinic' order by is_primary desc;
