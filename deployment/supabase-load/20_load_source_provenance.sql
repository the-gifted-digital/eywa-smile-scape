-- 20_load_source_provenance.sql — Wave 10: tag SmileScape-created rows in the SHARED tables (2026-07-16).
--
-- WHY: `load_source` is the provenance column on exactly the cross-brand SHARED tables
-- (entity_graph / entity_relationships / citations / topic_cluster_master / authors_reviewers
-- + the 6 entity-extension tables). Brand-OWNED tables (page_master, branches) use brand_id/brand_name instead.
-- It answers "which brand's file load CREATED this row" — distinct from `brand_scope` ("who may USE it").
--
-- PROBLEM: Deezy wrote a bare file path (`content-plan/entities.md`) — ambiguous, since every brand has
-- that same path. SmileScape's generators never set it at all (all NULL) → provenance untraceable.
--
-- CONVENTION ADOPTED (operator-approved 2026-07-16): `<brand-slug>:<repo-relative source path>`.
-- Prefixing keeps Deezy's existing rows untouched and yields a tri-state audit:
--    load_source LIKE 'smile-scape-clinic:%'  → SmileScape-created
--    load_source NOT LIKE '%:%' (bare path)   → Deezy-created
--    load_source IS NULL                      → VTH BioDent  ⚠️ see caveat
--
-- ⚠️ CAVEAT — "NULL = VTH" is ~99% true, NOT 100%. Deezy left 9 rows un-tagged, which would be
-- misread as VTH. Discriminate by era instead: VTH's load = created_at >= 2026-07-07; anything
-- NULL created BEFORE that is a Deezy straggler. Remaining NULL rows by date:
--    entity_graph          339 → all 2026-07-07            = VTH ✔ clean
--    topic_cluster_master   23 → all 2026-07-07            = VTH ✔ clean
--    authors_reviewers       1 → 2026-07-08                = VTH ✔ clean
--    citations              54 → 48 @2026-07-08 (VTH) + 6 @2026-06-06 (DEEZY straggler)
--    entity_relationships  694 → 691 @2026-07-08 (VTH) + 1 @2026-07-06 (DEEZY) + 2 @2026-06-07 23:06
--                                 (Deezy-era, payer/corporate-welfare topic — NOT SmileScape;
--                                  SS's batches that day ran 15:xx)
-- Left untouched this round per operator: only SmileScape gets tagged now.
--
-- ROW IDENTIFICATION: by insert-batch timestamp, cross-checked against LOAD-LOG counts.
--   SmileScape load = 2026-06-07 15:xx UTC · this session's additions = 2026-07-08 18:4x/18:54 + 2026-07-09 09:50.
--   NB relationships: SS batch (18:54, 255 rows) shares the date 2026-07-08 with VTH's batches (07:31–07:43,
--   692 rows) — MUST separate by minute, not by date, or VTH rows get mis-tagged.
--
-- Idempotent: every statement guards on `load_source is null`.

update public.seo_entity_graph set load_source='smile-scape-clinic:content-plan/entities.md'
 where load_source is null and (date(created_at)='2026-06-07'
   or entity_fingerprint in ('dental-scaling','frenectomy','oral-pathology','dr-pitchapa-phudphong'));  -- 117

update public.seo_entity_relationships set load_source='smile-scape-clinic:content-plan/relationships.md'
 where load_source is null and date_trunc('minute',created_at)='2026-07-08 18:54+00';                    -- 255

update public.seo_citations set load_source='smile-scape-clinic:content-plan/citation-pool-seed.md'
 where load_source is null and date(created_at)='2026-06-07';                                            -- 90

update public.seo_topic_cluster_master set load_source='smile-scape-clinic:content-plan/clusters.md'
 where load_source is null and date(created_at)='2026-06-07';                                            -- 19

update public.seo_authors_reviewers set load_source='smile-scape-clinic:web/src/data/doctors.json'
 where load_source is null and brand_scope=array['smile-scape-clinic'];                                  -- 2

-- entity extensions (created by 02_entity_extensions.sql, which derives from entities.md).
-- NOTE: that script had no brand filter, so SS's load also created extension rows for entities other
-- brands had authored — tagging by batch is still correct ("this row came into existence via SS's load").
update public.seo_entity_procedures set load_source='smile-scape-clinic:content-plan/entities.md'
 where load_source is null and (date(created_at)='2026-06-07'
   or entity_fp in ('dental-scaling','frenectomy','oral-pathology'));                                    -- 41
update public.seo_entity_condition set load_source='smile-scape-clinic:content-plan/entities.md'
 where load_source is null and date(created_at)='2026-06-07';                                            -- 13
update public.seo_entity_anatomy set load_source='smile-scape-clinic:content-plan/entities.md'
 where load_source is null and date(created_at)='2026-06-07';                                            -- 3
-- ext_devices / ext_symptom / ext_drug: SmileScape's load created none (0) — nothing to tag.

-- validation: tri-state per shared table
select 'entity_graph' t,
  count(*) filter (where load_source like 'smile-scape-clinic:%') smilescape,
  count(*) filter (where load_source is not null and load_source not like '%:%') deezy_bare_path,
  count(*) filter (where load_source is null) still_null
from public.seo_entity_graph;
