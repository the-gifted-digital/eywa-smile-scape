# SmileScape — Supabase Load: RUN ORDER (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav` · brand `smile-scape-clinic`. Path A: parser-generated SQL → run in Supabase SQL Editor → Claude validates via MCP. Conventions: `LOAD-LOG.md`.

## HOW TO RUN A FILE
1. Supabase Dashboard → project GTGT → SQL Editor → New query.
2. Open the `.sql` from this folder, copy ALL, paste, Run (▶). The closing `select`/`returning` shows the result.
3. Tell Claude "ran NN done" → Claude validates (count + FK + orphan + brand-isolation) via MCP and confirms ✅.
4. Run files strictly in numbered order. Do NOT skip (FK/reference deps).

> Re-run safety: every file is idempotent (ON CONFLICT / NOT EXISTS). Inserts are atomic — a failed file inserts nothing. On error, tell Claude; don't blind re-run.

## RUN ORDER (generated 2026-06-07 — counts are exact, from generator + MCP pre-diffs)
| # | File | Table | Expected effect | Status |
|---|------|-------|------|--------|
| 00 | `00_clusters.sql` | `seo_topic_cluster_master` | +20 (4 parent links) | ✅ done (20, fp_ok=20, parent=4) |
| 01 | `01_entities.sql` | `seo_entity_graph` | 163 authored → **+113 net-new** (50 shared `['*']` reused); global 722→835 | ⏳ pending |
| 02 | `02_entity_extensions.sql` | condition/symptom/anatomy/procedures/drug | SmileScape-scoped: condition 28 + procedure 46 + anatomy 6 | ⏳ pending |
| 03 | `03_citations.sql` | `seo_citations` | 93 → **+91** (2 DOI already in pool); `ours_present`=91 | ⏳ pending |
| 04 | `04_authors.sql` | `seo_authors_reviewers` + `seo_doctor_assignments` | +2 authors +2 assignments | ⏳ pending |
| 05 | `05_branches.sql` | `seo_branches` | +2 (partial; org-link both) | ⏳ pending |
| 06 | `06_pages.sql` | `seo_website_page_master` | +722 stub (721 entity-bound; expect `orphan_entity`=3 → orthodontic-intervention) | ⏳ pending |
| 10 | `10_keywords.sql` | `seo_x_ads_keywords_contextual_master` | +525 seed (brand `Smile Scape Clinic`) → DFS | ⏳ pending |

## DEFERRED (not this session)
relationships (edge-vocab+evidence) · page_citations (Phase F) · page_internal_links (Phase F) · product/device entity-ext (enum) · programmatic templates (Wave 1B) · keyword metrics (DFS) · Notion sync (n8n) · image URLs (Cloudflare).
