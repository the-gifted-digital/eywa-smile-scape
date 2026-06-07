# deployment/supabase-load/gen_pages.py
import re, collections
from _lib import *

NODE = re.compile(r"^\d+(\.\d+)*$")
def clean(name):
    n = re.sub(r"^(\s*→\s*)+", "", name)
    for ch in ("🌟", "⭐", "★", "🏆", "🔒"):
        n = n.replace(ch, "")
    return re.sub(r"\s+", " ", n).strip()

rows = []; skipped = []
for ln in open(SRC + "/sitemap.md", encoding="utf-8"):
    if not ln.lstrip().startswith("|"): continue
    c = cells(ln)
    if not c: continue
    node = c[0]
    if node in ("#",) or is_sep(c): continue
    if not NODE.match(node): skipped.append(node); continue
    if len(c) < 2: skipped.append(node + "(<2)"); continue   # need at least node+name
    name = clean(c[1])
    entity = c[6] if len(c) > 6 else None                    # 4-col section-6 hub rows have no entity col
    rows.append(dict(node=node, name=name, entity=entity if entity not in DASH else None))

raw_dupe = [n for n, k in collections.Counter(r["node"] for r in rows).items() if k > 1]
# de-dupe by node, preferring the entity-bearing (richer 7-col) row over a 4-col hub-index row
order = []; best = {}
for r in rows:
    n = r["node"]
    if n not in best:
        best[n] = r; order.append(n)
    elif best[n]["entity"] is None and r["entity"] is not None:
        best[n] = r
rows = [best[n] for n in order]
dupe = [n for n, k in collections.Counter(r["node"] for r in rows).items() if k > 1]
print("pages unique:", len(rows), "| collapsed dupe nodes:", raw_dupe, "| residual dupes:", dupe,
      "| skipped non-node:", len(skipped))
print("with entity:", sum(1 for r in rows if r["entity"]))

vals = []
for r in rows:
    vals.append("(" + ",".join([
        q("smilescape-" + r["node"]),  # page_fingerprint
        q(r["name"]),                  # page_name
        q(r["node"]),                  # sitemap_node_id
        q(r["entity"]),                # primary_entity_fp (slug / NULL)
        "'Planned'",                   # status
        "'smile-scape-clinic'",        # brand_id (text)
        "'Smile Scape Clinic'",        # brand_name
    ]) + ")")

sql = ("-- 06_pages.sql — seo_website_page_master (SmileScape, MINIMAL STUB) — " + str(len(rows)) + " pages.\n"
       "-- page_fingerprint='smilescape-{node}'. URLs/CPT/T-template/parent deferred (need keyword research).\n"
       "-- fingerprint/display auto by trigger. cluster_id set authoritatively from entity below.\n"
       "insert into public.seo_website_page_master\n"
       "  (page_fingerprint, page_name, sitemap_node_id, primary_entity_fp, status, brand_id, brand_name)\n"
       "values\n" + ",\n".join(vals) + "\non conflict (page_fingerprint) do nothing;\n\n"
       "-- authoritative cluster: page inherits its primary entity's topic_cluster_id\n"
       "update public.seo_website_page_master p set cluster_id = g.topic_cluster_id\n"
       "  from public.seo_entity_graph g\n"
       "  where p.brand_id='smile-scape-clinic' and p.primary_entity_fp is not null\n"
       "    and g.entity_fingerprint = p.primary_entity_fp;\n\n"
       "-- validation\n"
       "select count(*) total, count(primary_entity_fp) with_entity, count(cluster_id) with_cluster\n"
       "from public.seo_website_page_master where brand_id='smile-scape-clinic';\n")
open(OUT + "/06_pages.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 06_pages.sql")
