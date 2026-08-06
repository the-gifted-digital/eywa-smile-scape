-- 27_ss_entity_dedupe.sql — Smile Scape Wave 16 / Phase 1a
-- ยุบ entity คู่ขนานของ smile-scape เข้า canonical ตาม DR-042 (reuse-first) + DR-046 (load_from ชนะ)
-- backup: seo_entity_graph_ssbak_20260806 · seo_website_page_master_ssbak_20260806 ฯลฯ (สร้างแล้ว 2026-08-06)
--
-- แผนที่การยุบ (loser -> winner)
--   single-tooth-implant   -> single-implant     (deezy · ชื่อเหมือน 100%)
--   cbct-3d-scan           -> cbct-scan          (deezy · token สลับ · Tier D type ต่างกัน — operator เลือก procedure)
--   root-canal-retreatment -> rct-retreatment    (deezy · ต่างแค่ขีดกลาง)
--   guided-surgery         -> guided-implant     (deezy · ชื่อเหมือน 100%)
--   tooth-loss             -> missing-tooth      (deezy · K08.409 + aliases อ้างชื่อกันไปมา = defect ตาม DR-042)
--   trioclear-aligner      -> trioclear          (⚠️ กลับทิศจากร่างแรก: trioclear-aligner เป็น brand_scope={smile-scape-clinic}
--                                                 = แถว private ส่วน trioclear เป็น {*} + มี ai_entity_summary 634 ตัวอักษร
--                                                 + devices ext row เต็ม · แถวที่รอดต้องเป็นแถวที่ใช้ร่วมได้)

begin;

create temp table _m(loser text primary key, winner text) on commit drop;
insert into _m values
 ('single-tooth-implant','single-implant'),
 ('cbct-3d-scan','cbct-scan'),
 ('root-canal-retreatment','rct-retreatment'),
 ('guided-surgery','guided-implant'),
 ('tooth-loss','missing-tooth'),
 ('trioclear-aligner','trioclear');

-- ── STEP 1 · ยกของจากแถวที่กำลังจะแพ้ก่อน (DR-046 🔴) ───────────────────────────
-- 1a aliases: ต่อท้ายชื่อ + alias ของ loser (คอลัมน์เป็น text ไม่ใช่ array — รูปแบบในตารางปนกันอยู่แล้ว)
update seo_entity_graph w
set aliases = nullif(trim(both ', ' from
      coalesce(w.aliases,'') || ', ' || l.entity_name || ', ' ||
      coalesce(regexp_replace(l.aliases, '^\{|\}$', '', 'g'), '')), '')
from _m m join seo_entity_graph l on l.entity_fingerprint = m.loser
where w.entity_fingerprint = m.winner;

-- 1b ai_entity_summary: ถ้า loser เขียนไว้ยาวกว่า ให้ยกมาเป็นของ winner (ข้อมูลใช้ร่วมทุกแบรนด์ เสียไปแล้วไม่มีที่อื่น)
update seo_entity_graph w
set ai_entity_summary = l.ai_entity_summary
from _m m join seo_entity_graph l on l.entity_fingerprint = m.loser
where w.entity_fingerprint = m.winner
  and length(coalesce(l.ai_entity_summary,'')) > length(coalesce(w.ai_entity_summary,''));

-- 1c ICD: เติมเฉพาะเมื่อ winner ว่าง **และ** โค้ดของ loser ไม่ได้เป็นโค้ดโรคที่ติดผิดบนแถวหัตถการ
--     root-canal-retreatment ถือ K04.0 (acute pulpitis) ทั้งที่เป็น procedure -> ไม่ยกตาม (บันทึกไว้ใน log)
update seo_entity_graph w
set icd_10_code = l.icd_10_code
from _m m join seo_entity_graph l on l.entity_fingerprint = m.loser
where w.entity_fingerprint = m.winner
  and coalesce(w.icd_10_code,'') = '' and coalesce(l.icd_10_code,'') <> ''
  and not (w.entity_type in ('procedure','treatment'));

-- 1d wikidata/wikipedia ถ้า winner ว่าง
update seo_entity_graph w set wikidata_id = coalesce(w.wikidata_id, l.wikidata_id),
                              wikipedia_url = coalesce(w.wikipedia_url, l.wikipedia_url)
from _m m join seo_entity_graph l on l.entity_fingerprint = m.loser
where w.entity_fingerprint = m.winner;

-- ── STEP 2 · page_master.primary_entity_fp (ทุกแบรนด์) ────────────────────────
update seo_website_page_master p set primary_entity_fp = m.winner
from _m m where p.primary_entity_fp = m.loser;

-- ── STEP 3 · page_master.related_entities_fps[]  (เขียนทั้ง array ในนิพจน์เดียว
--    ตามกับดักที่รอบ deezy เจอ: UPDATE..FROM map แมตช์ได้แถวเดียวต่อ target row) ──
update seo_website_page_master p
set related_entities_fps = sub.arr
from (
  select p2.id,
         (select array_agg(distinct coalesce(m.winner, x)) from unnest(p2.related_entities_fps) x
            left join _m m on m.loser = x) as arr
  from seo_website_page_master p2
  where p2.related_entities_fps && (select array_agg(loser) from _m)
) sub
where p.id = sub.id;

-- ── STEP 4 · keywords.primary_entity_fp ───────────────────────────────────────
update seo_x_ads_keywords_contextual_master k set primary_entity_fp = m.winner
from _m m where k.primary_entity_fp = m.loser;

-- ── STEP 5 · entity_graph pointers ────────────────────────────────────────────
update seo_entity_graph e set parent_entity_fp = m.winner
from _m m where e.parent_entity_fp = m.loser and e.entity_fingerprint <> m.winner;
-- กัน self-parent ที่อาจเกิดจากการ repoint
update seo_entity_graph set parent_entity_fp = null where parent_entity_fp = entity_fingerprint;

update seo_entity_graph e
set related_entities_fps = sub.arr
from (
  select e2.entity_fingerprint fp,
         (select array_agg(distinct coalesce(m.winner, x)) from unnest(e2.related_entities_fps) x
            left join _m m on m.loser = x) as arr
  from seo_entity_graph e2
  where e2.related_entities_fps && (select array_agg(loser) from _m)
) sub
where e.entity_fingerprint = sub.fp;

-- ── STEP 6 · edges: ลบเส้นที่ resolve แล้วจะกลายเป็น self-edge หรือซ้ำ ก่อน repoint
--    (chk_no_self_edge ปฏิเสธสถานะกลางทาง — บทเรียนจากรอบ deezy) ───────────────
delete from seo_entity_relationships r
using _m m
where (r.from_entity_fp = m.loser and r.to_entity_fp = m.winner)
   or (r.to_entity_fp   = m.loser and r.from_entity_fp = m.winner);

-- ลบเส้นที่ repoint แล้วจะซ้ำกับเส้นที่มีอยู่แล้ว
delete from seo_entity_relationships r
using _m m
where r.from_entity_fp = m.loser
  and exists (select 1 from seo_entity_relationships q
              where q.from_entity_fp = m.winner and q.to_entity_fp = r.to_entity_fp and q.edge_type = r.edge_type);
delete from seo_entity_relationships r
using _m m
where r.to_entity_fp = m.loser
  and exists (select 1 from seo_entity_relationships q
              where q.to_entity_fp = m.winner and q.from_entity_fp = r.from_entity_fp and q.edge_type = r.edge_type);

update seo_entity_relationships r set from_entity_fp = m.winner from _m m where r.from_entity_fp = m.loser;
update seo_entity_relationships r set to_entity_fp   = m.winner from _m m where r.to_entity_fp   = m.loser;

-- ── STEP 7 · ext tables ───────────────────────────────────────────────────────
-- 7a condition: tooth-loss -> missing-tooth (winner มีแถวอยู่แล้ว) -> ลบแถว loser
delete from seo_entity_condition where entity_fp in (select loser from _m)
  and exists (select 1 from seo_entity_condition w join _m m on m.winner=w.entity_fp
              where m.loser = seo_entity_condition.entity_fp);
-- 7b procedures: guided-surgery / root-canal-retreatment เป็นแถวว่างล้วน (winner มีข้อมูลมากกว่า) -> ลบ
delete from seo_entity_procedures where entity_fp in ('guided-surgery','root-canal-retreatment');
-- 7c devices: trioclear-aligner เป็นแถวว่างล้วน -> ลบ
delete from seo_entity_devices where entity_fp = 'trioclear-aligner';
-- 7d devices: cbct-3d-scan ถือข้อมูลคลินิกชุดเดียวที่มี (indications/contraindications/regulatory)
--     winner cbct-scan เป็น procedure และแถว procedures ของมัน "ว่างเปล่า"
--     -> ยก contraindications เข้าแถว procedures ก่อน แล้ว repoint แถว devices ไปที่ winner (ไม่ลบ)
update seo_entity_procedures p
set contraindications = d.contraindications, updated_at = now()
from seo_entity_devices d
where p.entity_fp = 'cbct-scan' and d.entity_fp = 'cbct-3d-scan' and p.contraindications is null;
update seo_entity_devices set entity_fp = 'cbct-scan', updated_at = now() where entity_fp = 'cbct-3d-scan';

-- ── STEP 8 · ปิดแถว loser (ห้ามลบ — ต้องสืบย้อนได้ DR-042 ข้อ 5) ───────────────
update seo_entity_graph l
set entity_lifecycle = 'merged',
    ai_entity_summary = '[MERGED 2026-08-06 -> ' || m.winner || '] ' || coalesce(l.ai_entity_summary,''),
    last_graph_update = now(),
    updated_at = now()
from _m m where l.entity_fingerprint = m.loser;

commit;
