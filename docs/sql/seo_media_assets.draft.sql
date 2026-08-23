-- ============================================================================
-- DRAFT — seo_media_assets  (Media / DAM table for the EYWA SEO schema)
-- ----------------------------------------------------------------------------
-- STATUS: DRAFT FOR SESSION B REVIEW — DO NOT APPLY AS-IS.
-- Drafted by Session A (media pipeline). Conventions reverse-engineered from the
-- live GTGT schema (Spec v1.22): DR-008 two-column identity, N↔S sync columns,
-- RLS policy `eywa_authenticated_full_access`, and the seo_schema_changes audit log.
--
-- Implements: DR-035 (binaries on Cloudflare, DB stores URL) + the Notion
-- "Media Library" DB already created in marketing-vt (collection://20e248f7-4b65-44eb-bfd4-90dac48a79d7).
-- Pairs with SmileScape SS-DR-015 (pipeline) + SS-DR-016 (patient-consent lifecycle).
--
-- PROPOSED registry values (Session B to confirm real numbers):
--   related_dr_id   = DR-037 (proposed)          migration_version = eywa_w12_01_dr037_media_assets
--   spec_version    = v1.23 (proposed)           migration_name    = Wave 12.0 Media/DAM — seo_media_assets
--
-- OPEN ITEMS FOR SESSION B (see "ASSUMPTIONS" inline):
--   1. brands FK — brands PK is legacy `brand_name`; we FK brand_id → brands(id).
--      Requires a UNIQUE constraint on brands.id (seo_branches already references it,
--      so it should exist). Confirm before apply.
--   2. Group/Tier classification + Spec §section number for the schema overview doc.
--   3. Whether media should also relate to seo_topic_cluster_master / seo_brand_centers.
--   4. updated_at: reuse the schema's shared trigger fn if one exists (we ship a
--      self-named one to avoid clobbering).
-- ============================================================================

begin;

-- ── updated_at helper (self-named to avoid clobbering any shared fn) ──────────
create or replace function public.seo_media_assets_set_updated_at()
returns trigger language plpgsql as $$
begin new.updated_at = now(); return new; end $$;

-- ── table ────────────────────────────────────────────────────────────────────
create table if not exists public.seo_media_assets (
  -- identity / DR-008 two-column + N↔S sync (mirrors seo_entity_graph, brands)
  id                       uuid primary key default gen_random_uuid(),
  fingerprint              text not null,                 -- DR-008 dedup identity (normalized)
  fingerprint_display_name text not null,                 -- DR-008 human label
  media_slug               text not null,                 -- kebab business key (DR-010 style)
  notion_id                text,                          -- Notion page id (Media Library row)
  notion_database_id       text,                          -- which Notion DB (marketing-vt vs gifted)
  notion_workspace         text,                          -- 'marketing-vt' | 'gifted' (multi-workspace, mirrors brands)
  notion_synced_at         timestamptz,

  -- storage / delivery (DR-035)
  r2_key                   text not null,                 -- e.g. cases/dental-implant/case-0007-before.webp
  cdn_url                  text not null,                 -- https://cdn.smilescapeclinic.com/<r2_key>

  -- descriptive / SEO (bilingual mandatory)
  title                    text,
  alt_th                   text not null,
  alt_en                   text not null,
  caption_th               text,
  caption_en               text,

  -- classification
  media_type               text not null
                             check (media_type in
                               ('doctor','branch','brand','treatment','procedure',
                                'condition','tech','case','clinic','brand_asset','other')),
  mime_type                text,                          -- image/webp, image/jpeg, video/mp4
  width                    integer,
  height                   integer,
  file_size_bytes          bigint,

  -- relations (FK to live masters)
  entity_id                uuid references public.seo_entity_graph(id),
  brand_id                 uuid,                          -- ASSUMPTION: FK → brands(id) added below (needs unique brands.id)
  brand_slug               text,                          -- denormalised business key (mirrors seo_branches/seo_website_page_master)
  branch_id                uuid references public.seo_branches(id),
  author_id                uuid references public.seo_authors_reviewers(id),   -- doctor portraits
  page_id                  uuid references public.seo_website_page_master(id),

  -- publish lifecycle
  status                   text not null default 'pending'
                             check (status in ('pending','active','expired','revoked','archived')),

  -- ── patient / consent block (SS-DR-016) ───────────────────────────────────
  is_patient_image         boolean not null default false,
  consent_status           text check (consent_status in ('obtained','pending','revoked')),
  consent_doc_url          text,                          -- signed consent form (private, NOT on CDN)
  consent_obtained_at      date,
  usage_perpetual          boolean,                       -- true = ใช้ได้ตลอดไป ; false = มีวันหมดอายุ
  usage_expires_at         date,                          -- required when usage_perpetual = false
  patient_ref              text,                          -- pseudonymised ref ONLY — never patient name (PDPA)

  -- provenance / audit
  source                   text,                          -- 'notion' | 'batch-upload' | 'wp-migration'
  credit                   text,
  created_at               timestamptz not null default now(),
  updated_at               timestamptz not null default now(),
  expired_at               timestamptz,                   -- set by the n8n sweep on removal

  -- integrity guards: a patient image can't go live without consent + a usage rule
  constraint seo_media_patient_consent_required check (
    not is_patient_image
    or (consent_status is not null and usage_perpetual is not null)
  ),
  constraint seo_media_patient_expiry_required check (
    not is_patient_image
    or usage_perpetual is true
    or usage_expires_at is not null
  )
);

-- ── brands FK (guarded: only if brands.id is unique) ──────────────────────────
-- ASSUMPTION: brands.id has a UNIQUE constraint (seo_branches.brand_id already references it).
-- Session B: uncomment after confirming, or swap to reference brands(brand_slug).
-- alter table public.seo_media_assets
--   add constraint seo_media_assets_brand_id_fkey
--   foreign key (brand_id) references public.brands(id);

-- ── indexes ───────────────────────────────────────────────────────────────────
create unique index if not exists seo_media_assets_r2_key_uidx       on public.seo_media_assets (r2_key);
create unique index if not exists seo_media_assets_notion_id_uidx     on public.seo_media_assets (notion_id) where notion_id is not null;
create index        if not exists seo_media_assets_entity_idx         on public.seo_media_assets (entity_id);
create index        if not exists seo_media_assets_brand_idx          on public.seo_media_assets (brand_id);
create index        if not exists seo_media_assets_branch_idx         on public.seo_media_assets (branch_id);
create index        if not exists seo_media_assets_author_idx         on public.seo_media_assets (author_id);
create index        if not exists seo_media_assets_page_idx           on public.seo_media_assets (page_id);
create index        if not exists seo_media_assets_type_idx           on public.seo_media_assets (media_type);
create index        if not exists seo_media_assets_status_idx         on public.seo_media_assets (status);
create index        if not exists seo_media_assets_expiry_idx         on public.seo_media_assets (usage_expires_at)
                                                                      where is_patient_image and not usage_perpetual;

-- ── updated_at trigger ────────────────────────────────────────────────────────
drop trigger if exists seo_media_assets_set_updated_at on public.seo_media_assets;
create trigger seo_media_assets_set_updated_at
  before update on public.seo_media_assets
  for each row execute function public.seo_media_assets_set_updated_at();

-- ── RLS (mirrors schema convention) ───────────────────────────────────────────
alter table public.seo_media_assets enable row level security;
create policy eywa_authenticated_full_access on public.seo_media_assets
  for all to authenticated using (true) with check (true);

-- ── serving gate: build-time belt (Astro/consumers query THIS, not the table) ──
-- Excludes expired/unconsented patient images even between n8n sweeps.
create or replace view public.seo_servable_media as
select *
from public.seo_media_assets
where status = 'active'
  and (
    not is_patient_image
    or (
      consent_status = 'obtained'
      and (usage_perpetual is true or usage_expires_at >= current_date)
    )
  );

-- ── comments (match the schema's documented-table style) ──────────────────────
comment on table public.seo_media_assets is
  'Group ? | Tier 1 | N↔S | Media/DAM master. Cloudflare R2 binaries (DR-035), bilingual alt, FK to entity/brand/branch/author/page, patient-consent lifecycle (SS-DR-016). Notion source: Media Library. Spec v1.23 §? / DR-037 (proposed).';
comment on column public.seo_media_assets.is_patient_image is 'Toggle. If true, consent block is required (CHECK) before status can be active.';
comment on column public.seo_media_assets.usage_expires_at is 'Last date a patient image may appear. n8n daily sweep quarantines the R2 object + purges cache after this date (SS-DR-016 L2).';
comment on column public.seo_media_assets.patient_ref is 'Pseudonymised reference only — never store the patient name (PDPA data-minimisation).';

-- ── audit log entry (schema convention) ───────────────────────────────────────
insert into public.seo_schema_changes
  (change_type, table_name, migration_version, migration_name, related_dr_id, spec_version, description, performed_by, performed_at)
values
  ('create_table', 'seo_media_assets',
   'eywa_w12_01_dr037_media_assets', 'Wave 12.0 Media/DAM — seo_media_assets',
   'DR-037', 'v1.23',
   'NEW media/DAM master — R2 binaries + bilingual alt + FK to entity/brand/branch/author/page + patient-consent lifecycle (SS-DR-016). Notion source: Media Library. + view seo_servable_media (build-time consent gate).',
   'claude-code (draft)', now());

commit;

-- ============================================================================
-- ROLLBACK (if needed)
-- ----------------------------------------------------------------------------
-- drop view if exists public.seo_servable_media;
-- drop table if exists public.seo_media_assets cascade;
-- drop function if exists public.seo_media_assets_set_updated_at();
-- ============================================================================
