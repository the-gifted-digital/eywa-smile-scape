-- 28_ss_cluster_dedupe.sql — Smile Scape Wave 16 / Phase 1b
-- ยุบคลัสเตอร์คู่ขนานของ smile-scape เข้า canonical ของ deezy ตาม DR-046 (load_from ชนะ) + DR-047 (repoint 4 จุด)
-- ทุกแถวที่ยุบมี load_from = NULL · ทุก canonical มี load_from='deezy-dental' -> ไม่มีคู่ไหนกำกวม
-- operator ตัดสิน 2026-08-06: gum-soft-tissue เก็บไว้เป็น child ของ periodontics-gum (ไม่ยุบ)

begin;

create temp table _c(loser text primary key, winner text) on commit drop;
insert into _c values
 ('dental-implant-core','implant-dentistry'),
 ('clear-aligner-orthodontics','orthodontics'),
 ('general-restorative','restorative-dentistry'),
 ('smile-design-cosmetic','cosmetic-dentistry'),
 ('periodontics-perio-disease','periodontics-gum'),
 ('digital-technology-diagnostics','dental-technology'),
 ('insurance-coverage-th','insurance-access'),
 ('endodontics-specialist','endodontics');

-- STEP 1+2 · facet ของ smile-scape -> แขวนใต้ deezy root ที่ใกล้ที่สุด
--   ต้องทำ **ก่อน** ยุบ root ไม่งั้นลูกลอย (all-on-x-full-arch / implant-systems-brands แขวนใต้ dental-implant-core อยู่)
--   กฎจาก deezy-clean-plan §4: cluster ที่ deezy ไม่มีตัวเทียบเท่า เก็บได้ แต่ห้ามวางเป็น level-0 sibling
update seo_topic_cluster_master
set parent_cluster_fp = (select fingerprint from seo_topic_cluster_master where cluster_slug='implant-dentistry'),
    hierarchy_level = 1, updated_at = now()
where cluster_slug in ('all-on-x-full-arch','implant-systems-brands','bone-regeneration-gbr',
                       'implant-materials','patient-conditions-tooth-loss','patient-conditions-bone');

update seo_topic_cluster_master
set parent_cluster_fp = (select fingerprint from seo_topic_cluster_master where cluster_slug='periodontics-gum'),
    hierarchy_level = 1, updated_at = now()
where cluster_slug = 'gum-soft-tissue';

update seo_topic_cluster_master
set parent_cluster_fp = (select fingerprint from seo_topic_cluster_master where cluster_slug='cross-cutting'),
    hierarchy_level = 1, updated_at = now()
where cluster_slug = 'dental-anatomy';

-- STEP 3 · repoint จุดที่ 1 — page_master.cluster_id (ทุกแบรนด์: SS 390 หน้า + VTH 6 หน้าที่ยืมอยู่)
update seo_website_page_master p set cluster_id = m.winner, updated_at = now()
from _c m where p.cluster_id = m.loser;

-- STEP 4 · repoint จุดที่ 2+3 — entity_graph.topic_cluster_id + topic_cluster_name
update seo_entity_graph e set topic_cluster_id = m.winner, last_graph_update = now(), updated_at = now()
from _c m where e.topic_cluster_id = m.loser;

-- ล้าง cache ชื่อคลัสเตอร์ให้ตรง master ทั้งตาราง (DR-047 ข้อ 1: topic_cluster_name เป็น cache ห้ามอ่านตัดสินใจ)
update seo_entity_graph e set topic_cluster_name = c.cluster_name, updated_at = now()
from seo_topic_cluster_master c
where c.cluster_slug = e.topic_cluster_id and e.topic_cluster_name is distinct from c.cluster_name;

-- STEP 5 · repoint จุดที่ 4 — aliases.merged_from บนแถวที่รอด + ปิดแถวที่ยุบ (ห้ามลบ)
update seo_topic_cluster_master w
set aliases = jsonb_set(coalesce(w.aliases,'{}'::jsonb), '{merged_from}',
      (coalesce(w.aliases->'merged_from','[]'::jsonb) || to_jsonb(array(select loser from _c m where m.winner = w.cluster_slug)))),
    updated_at = now()
where w.cluster_slug in (select winner from _c);

update seo_topic_cluster_master l
set status = 'merged',
    descriptions = coalesce(l.descriptions,'{}'::jsonb) ||
      jsonb_build_object('merge_note', 'MERGED 2026-08-06 -> ' || m.winner ||
        ' · DR-046 load_from=deezy-dental ชนะ · smile-scape wave16'),
    updated_at = now()
from _c m where l.cluster_slug = m.loser;

commit;
