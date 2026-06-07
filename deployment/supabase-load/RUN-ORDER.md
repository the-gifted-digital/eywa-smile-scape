# SmileScape — Supabase Load: RUN ORDER (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav` · brand `smile-scape-clinic`. Path A: parser-generated SQL → run in Supabase SQL Editor → Claude validates via MCP. Conventions: `LOAD-LOG.md`.

## HOW TO RUN A FILE
1. Supabase Dashboard → project GTGT → SQL Editor → New query.
2. Open the `.sql` from this folder, copy ALL, paste, Run (▶). The closing `select`/`returning` shows the result.
3. Tell Claude "ran NN done" → Claude validates (count + FK + orphan + brand-isolation) via MCP and confirms ✅.
4. Run files strictly in numbered order. Do NOT skip (FK/reference deps).

> Re-run safety: every file is idempotent (ON CONFLICT / NOT EXISTS). Inserts are atomic — a failed file inserts nothing. On error, tell Claude; don't blind re-run.

## RUN ORDER
| # | File | Table | Rows (plan) | Status |
|---|------|-------|------|--------|
| 00 | `00_clusters.sql` | `seo_topic_cluster_master` | 20 | ⏳ pending |
| 01 | `01_entities.sql` | `seo_entity_graph` | 163 → MERGE (net-new) | ⏳ pending |
| 02 | `02_entity_extensions.sql` | condition/symptom/anatomy/procedures/drug | ~82 | ⏳ pending |
| 03 | `03_citations.sql` | `seo_citations` | net-new (dedup doi/pmid) | ⏳ pending |
| 04 | `04_authors.sql` | `seo_authors_reviewers` + `seo_doctor_assignments` | 2 (+assign) | ⏳ pending |
| 05 | `05_branches.sql` | `seo_branches` | 2 (partial) | ⏳ pending |
| 06 | `06_pages.sql` | `seo_website_page_master` | ~726 (stub) | ⏳ pending |
| 10 | `10_keywords.sql` | `seo_x_ads_keywords_contextual_master` | ~680 (seed→DFS) | ⏳ pending |

## DEFERRED (not this session)
relationships (edge-vocab+evidence) · page_citations (Phase F) · page_internal_links (Phase F) · product/device entity-ext (enum) · programmatic templates (Wave 1B) · keyword metrics (DFS) · Notion sync (n8n) · image URLs (Cloudflare).
