# SmileScape — Supabase Flat-Load Log (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav`. Brand: Smile Scape Clinic (`brands.id=c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25`, slug `smile-scape-clinic`, fp `brnd_8314A55613F44453`). Fresh load (0 content rows). Method: parse content-plan/*.md → SQL → run via SQL Editor → Claude validates via MCP.

## Conventions
- brand_scope = slug array; planning `smile-scape` normalized → `smile-scape-clinic`; `['*']` universal.
- Triggers auto-set fingerprint/display/brand_scope_id/name → leave NULL. entity_fingerprint=slug; entity_type lowercase. notion_id NULL.
- MERGE tables (2nd dental brand): entities ON CONFLICT(entity_fingerprint); citations dedup on slug/doi/pmid. page_fingerprint=`smilescape-{node}`; keyword fp=`smile scape clinic::{loc}::{lang}::{kw}`.

## Progress
| Phase | Table | Rows | Status |
|---|---|---|---|
| (filled as we go) | | | |

## Flags
- Author slug: entities.md `dr-woraphat-jarangkul` (Woraphat) vs CV `dr-worapat-jarangkul.md` (Worapat) — **RESOLVED**: keep entity/`author_fp` slug `dr-woraphat-jarangkul`; display name "Worapat" per CV.
- Shared-entity type mismatch (e.g. ceramic-implant product vs treatment): existing row wins (ON CONFLICT).
- Entities pre-load diff: 163 authored = 50 already-exist (`['*']` shared) + **113 net-new** to insert.
- หมอแพรว has NO Person entity in entities.md (only woraphat + tomas); loaded as author only (`author_fp` NULL).
- Pages: parser yields **722 unique** (721 entity-bearing + `6.2` hub). Official audit "726" double-counts 4 section-6 hub-index rows (6.1/6.3/6.4/6.6 also exist as 7-col page rows) → de-duped.
- Page orphan ref: `orthodontic-intervention` ×3 pages (3.5.4/.5/.7, R17 rename) — entity not in entities.md → expect `orphan_entity=3`. Phase F: add entity or remap.
- Citations: 93 parsed; 2 DOIs already in shared pool (`10.1016/j.jdent.2019.03.008`, `10.1111/j.1600-0501.2012.02546.x`) → **91 net-new**. `citation_type` mostly `other` (bare grade letters / `—` / retrospectives) — Phase F enrich. Only 11 of 93 carry a DOI (md DOI/URL column sparse).
- Keywords: 525 unique (after dropping 21 `[service]`/`[BRAND]`/`[condition]` template placeholders). Source doc claimed ~680 (loose).
- Source counts vs handover: entities **163** (not 166/167); pages **722 unique** (not 726).
