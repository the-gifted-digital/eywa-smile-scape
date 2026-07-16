-- 23_shared_tables_completion.sql — Wave 13: fill the remaining keyword-independent gaps in the
-- non-page tables, measured against Deezy (the reference "complete" brand). 2026-07-16.
--
-- METHOD: a column is a real gap only if Deezy (loaded fully, first) populated it. Anything Deezy left
-- NULL is not part of the baseline → NOT fabricated here. That rules OUT (verified NULL on Deezy too):
--   entity_graph: wikidata_id / mesh_id / entity_subtype · cluster: cluster_facet / descriptions(={} empty) ·
--   relationships: edge_strength / edge_evidence_citation / medical_reviewer_fp ·
--   entity extensions: all clinical fields (cpt_code/recovery/contraindications/…) — Phase-F clinical enrichment.
--
-- Real gaps filled:
-- 1) seo_topic_cluster_master.hierarchy_level — Deezy fills it, SS was NULL. 0=root / 1=has-parent (Deezy scheme).
-- 2) seo_branches arrays — Deezy left these NULL, but SmileScape AUTHORED them in content-plan/branches.md,
--    they FK cleanly, and they carry real dossier value (what a branch offers) → a strict improvement, not fabrication.
--    (doctors + equipment carry a "confirm per-branch" note in branches.md — filled as the documented working
--     default: both founders at both branches, universal equipment list. Operator refines per-branch later.)

-- 1) cluster hierarchy
update public.seo_topic_cluster_master
  set hierarchy_level = case when parent_cluster_fp is null then 0 else 1 end
where load_source like 'smile-scape-clinic:%' and hierarchy_level is null;

-- 2) branch service/specialty/equipment/doctor arrays (both branches — universal SmileScape catalog).
--    All 41 service + 5 equipment slugs verified present in seo_entity_graph; doctor fps = the 2 founders.
update public.seo_branches set
 services_offered_fps = array[
   'dental-implant','single-tooth-implant','multiple-implants','implant-supported-bridge','overdenture',
   'all-on-x','all-on-4','all-on-6','zygomatic-implant','full-arch-immediate-loading',
   'guided-bone-regeneration','sausage-technique','bone-grafting','sinus-lift','ridge-augmentation','socket-preservation','vertical-bone-augmentation',
   'soft-tissue-management','connective-tissue-graft',
   'dental-veneer','porcelain-veneer','dental-crown','zirconia-crown','teeth-whitening','digital-smile-design','gum-contouring',
   'clear-aligner','trioclear-aligner','damon-system',
   'root-canal-treatment','tooth-extraction','wisdom-tooth-removal','dental-filling','removable-denture',
   'periodontitis','peri-implantitis','gum-recession',
   'immediate-implant','immediate-loading','flapless-surgery','guided-surgery']::text[],
 specialties_at_branch = array['general_dentistry','implantology','oral_surgery','periodontics','orthodontics','prosthodontics','cosmetic_dentistry']::text[],
 equipment_at_branch_fps = array['cbct-3d-scan','intraoral-scanner','surgical-guide','cad-cam','ptfe-membrane']::text[],
 doctors_at_branch_fps = array['auth_9D1AD1694B2A4544','auth_51B571036EB64320']::text[]  -- หมอแฮม + หมอแพรว
where brand_slug='smile-scape-clinic';

-- validation
select
 (select jsonb_object_agg(hierarchy_level::text,c) from (select hierarchy_level,count(*) c from public.seo_topic_cluster_master where load_source like 'smile-scape-clinic:%' group by 1) a) cluster_hier,
 (select jsonb_agg(jsonb_build_object('b',branch_slug,'svc',array_length(services_offered_fps,1),'spec',array_length(specialties_at_branch,1),'equip',array_length(equipment_at_branch_fps,1),'docs',array_length(doctors_at_branch_fps,1)))
    from public.seo_branches where brand_slug='smile-scape-clinic') branch_arrays;
