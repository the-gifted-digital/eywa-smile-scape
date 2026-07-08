# deployment/supabase-load/gen_pages_enrich.py — Wave 2 backfill (2026-07-09)
# Enriches the 722 SmileScape page stubs with structural fields already present in
# content-plan/sitemap.md R26. NO fabrication: only columns with real per-row values.
#   node_tier       <- Tier column (A/B/C/D)          [baseline; Wave 3 DFS recomputes]
#   funnel_stage    <- Funnel column (top/mid/bottom)  [populated per-row, NOT the stale TBD note]
#   sitemap_section <- node's first segment (1-8)
#   crawl_depth     <- node depth-1 (3.2.8.3 -> 3)
#   parent_page_fp  <- 'smilescape-'+node minus last segment, ONLY if that page exists (else NULL)
# DELIBERATELY SKIPPED (Phase F): page_type (col is placeholder 'A' for 651/722), slug, seo_title, target_keyword_fp.
# Idempotent: plain UPDATE by page_fingerprint; re-run overwrites with same values.
import os, re
SRC = os.environ.get("SS_SRC", "/Volumes/SSD NN/CLAUDE AI/tmp/ss-main-wt/content-plan")
OUT = os.path.dirname(os.path.abspath(__file__))
NODE = re.compile(r"^\d+(\.\d+)*$")

def cells(line):
    return [c.strip() for c in line.strip().strip("|").split("|")]

rows, seen = [], set()
for ln in open(SRC + "/sitemap.md", encoding="utf-8"):
    if not ln.lstrip().startswith("|"):
        continue
    c = cells(ln)
    if len(c) < 5 or not NODE.match(c[0]):
        continue
    node = c[0]
    if node in seen:               # de-dupe: keep first (7-col) occurrence, matches gen_pages
        continue
    seen.add(node)
    tier = c[3].replace("*", "").strip() or None
    funnel = c[4].replace("*", "").strip() or None
    if tier not in ("A", "B", "C", "D"):
        tier = None                # ignore stray/non-tier values
    if funnel not in ("top", "mid", "bottom"):
        funnel = None
    section = node.split(".")[0]
    depth = node.count(".")        # 0 for "1"/"3", 3 for "3.2.8.3"
    parent = ("smilescape-" + node.rsplit(".", 1)[0]) if "." in node else None
    rows.append(dict(node=node, tier=tier, funnel=funnel, section=section, depth=depth, parent=parent))

def q(s):
    return "NULL" if s is None else "'" + str(s).replace("'", "''") + "'"

# Compact form: only tier+funnel carry NEW data; section/crawl_depth/parent are derived
# in-SQL from sitemap_node_id (already present on all 722 rows). Keeps payload small.
vals = ",\n".join(
    "(" + ",".join([q("smilescape-" + r["node"]), q(r["tier"]), q(r["funnel"])]) + ")"
    for r in rows
)
sql = (
    "-- 12_pages_enrich.sql — seo_website_page_master structural backfill (SmileScape, Wave 2 2026-07-09).\n"
    "-- " + str(len(rows)) + " pages. node_tier + funnel_stage from sitemap.md (NEW data);\n"
    "-- sitemap_section / crawl_depth / parent_page_fp DERIVED in-SQL from sitemap_node_id.\n"
    "-- parent_page_fp -> NULL when the parent node has no page row (self-join guard). Idempotent.\n"
    "with src(fp, tier, funnel) as (values\n" + vals + ")\n"
    "update public.seo_website_page_master p set\n"
    "  node_tier       = src.tier,\n"
    "  funnel_stage    = src.funnel,\n"
    "  sitemap_section = split_part(p.sitemap_node_id, '.', 1),\n"
    "  crawl_depth     = char_length(p.sitemap_node_id) - char_length(replace(p.sitemap_node_id, '.', '')),\n"
    "  parent_page_fp  = (\n"
    "     select 'smilescape-' || parent_node\n"
    "     from (select substring(p.sitemap_node_id from '^(.*)\\.[^.]+$') parent_node) pn\n"
    "     where parent_node is not null\n"
    "       and exists (select 1 from public.seo_website_page_master pp\n"
    "                   where pp.page_fingerprint = 'smilescape-' || parent_node))\n"
    "from src where p.page_fingerprint = src.fp;\n\n"
    "-- validation\n"
    "select count(*) total,\n"
    "       count(node_tier) with_tier,\n"
    "       count(funnel_stage) with_funnel,\n"
    "       count(sitemap_section) with_section,\n"
    "       count(parent_page_fp) with_parent,\n"
    "       count(*) filter (where node_tier='A') tier_a\n"
    "from public.seo_website_page_master where page_fingerprint like 'smilescape-%';\n"
)
open(OUT + "/12_pages_enrich.sql", "w", encoding="utf-8").write(sql)
print("pages:", len(rows), "| with tier:", sum(1 for r in rows if r["tier"]),
      "| with funnel:", sum(1 for r in rows if r["funnel"]),
      "| with parent-node:", sum(1 for r in rows if r["parent"]))
print("bytes:", len(sql), "-> 12_pages_enrich.sql")
