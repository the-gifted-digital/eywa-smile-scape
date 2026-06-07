# deployment/supabase-load/gen_clusters.py
from _lib import *

rows = []; intbl = False
for ln in open(SRC + "/clusters.md", encoding="utf-8"):
    if ln.lstrip().startswith("| Cluster ID"): intbl = True; continue
    if intbl:
        if not ln.lstrip().startswith("|"): break
        c = cells(ln)
        if is_sep(c) or len(c) < 6: continue
        rows.append((c[0], c[1], c[3], c[5]))   # slug, name, parent, scope
print("clusters parsed:", len(rows))

vals = []
for slug, name, parent, scope in rows:
    sc = norm_scope(scope)
    vals.append("(" + ",".join([q(slug), q(name), "'topical'", sc, scope_primary(sc), "'flat_loaded'"]) + ")")

ups = []
for slug, name, parent, scope in rows:
    if parent and parent.strip() not in DASH:
        ups.append("update public.seo_topic_cluster_master c set parent_cluster_fp=p.fingerprint "
                   "from public.seo_topic_cluster_master p where c.cluster_slug=" + q(slug) +
                   " and p.cluster_slug=" + q(parent) + ";")

allslugs = ",".join(q(s) for s, _, _, _ in rows)
sql = ("-- 00_clusters.sql — seo_topic_cluster_master (SmileScape, " + str(len(rows)) + " clusters).\n"
       "-- cluster_type='topical'; sync_state='flat_loaded'; fingerprint/display auto by trigger.\n"
       "insert into public.seo_topic_cluster_master\n"
       "  (cluster_slug, cluster_name, cluster_type, brand_scope, brand_scope_primary, sync_state)\n"
       "values\n" + ",\n".join(vals) + "\non conflict (cluster_slug) do nothing;\n\n"
       "-- parent links (set parent_cluster_fp from parent's fingerprint by slug)\n"
       + "\n".join(ups) + "\n\n"
       "-- validation\n"
       "select count(*) total, count(parent_cluster_fp) with_parent\n"
       "from public.seo_topic_cluster_master where cluster_slug in (" + allslugs + ");\n")
open(OUT + "/00_clusters.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 00_clusters.sql")
