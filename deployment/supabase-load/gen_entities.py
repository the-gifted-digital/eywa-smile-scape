# deployment/supabase-load/gen_entities.py
import re, collections
from _lib import *

cur_cluster = None; cur_scope = "['*']"
rows = []
hdr = re.compile(r"^##\s+([a-z0-9\-]+):")
for ln in open(SRC + "/entities.md", encoding="utf-8"):
    m = hdr.match(ln)
    if m: cur_cluster = m.group(1); continue
    s = ln.strip()
    if s.startswith("**Brand Scope:**"):
        cur_scope = s.split("**Brand Scope:**", 1)[1].strip(); continue
    if not s.startswith("|"): continue
    c = cells(ln)
    if is_sep(c) or len(c) < 11: continue
    if c[1] in ("Entity Name",): continue          # table header
    name, slug, etype = c[1], c[2], c[3].lower()
    schema_org, parent, icd, life = c[4], c[5], c[6], c[7]
    aliases, scope = c[9], c[10]
    if not slug or slug in DASH: continue
    rows.append(dict(slug=slug, name=name, etype=etype, schema=schema_org,
                     parent=parent, icd=icd, life=life, aliases=aliases,
                     scope=scope if scope and scope not in DASH else cur_scope,
                     cluster=cur_cluster))

# de-dupe within file (slug is the unique key)
seen = {}; uniq = []
for r in rows:
    if r["slug"] in seen: continue
    seen[r["slug"]] = 1; uniq.append(r)
print("entities parsed:", len(rows), "unique:", len(uniq))
print("by type:", dict(collections.Counter(r["etype"] for r in uniq)))
dups = [s for s, k in collections.Counter(r["slug"] for r in rows).items() if k > 1]
print("dupe slugs:", dups[:20])

vals = []
for r in uniq:
    vals.append("(" + ",".join([
        q(r["slug"]),                       # entity_fingerprint (= slug, unique)
        q(r["name"]),                       # entity_name
        q(r["slug"]),                       # entity_slug
        q(r["etype"]),                      # entity_type (lowercase)
        q(r["schema"]),                     # schema_org_type
        q(r["parent"]),                     # parent_entity_fp (slug ref / NULL)
        q(r["cluster"]),                    # topic_cluster_id (cluster slug)
        q(r["life"]),                       # entity_lifecycle
        q(r["icd"]),                        # icd_10_code
        text_array(split_aliases(r["aliases"])),  # aliases text[]
        norm_scope(r["scope"]),             # brand_scope
    ]) + ")")

allslugs = ",".join(q(r["slug"]) for r in uniq)
sql = ("-- 01_entities.sql — seo_entity_graph (SmileScape, " + str(len(uniq)) + " authored).\n"
       "-- MERGE: ON CONFLICT(entity_fingerprint) DO NOTHING — shared ['*'] entities (e.g. dental-implant)\n"
       "--   already exist from Deezy and are reused; only net-new SmileScape entities insert.\n"
       "-- entity_fingerprint=entity_slug=slug; entity_type lowercase; fingerprint/display auto.\n"
       "insert into public.seo_entity_graph\n"
       "  (entity_fingerprint, entity_name, entity_slug, entity_type, schema_org_type,\n"
       "   parent_entity_fp, topic_cluster_id, entity_lifecycle, icd_10_code, aliases, brand_scope)\n"
       "values\n" + ",\n".join(vals) + "\non conflict (entity_fingerprint) do nothing;\n\n"
       "-- validation: how many of our slugs are now present (existing + newly inserted)\n"
       "select count(*) present_of_ours\n"
       "from seo_entity_graph where entity_fingerprint in (" + allslugs + ");\n")
open(OUT + "/01_entities.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 01_entities.sql")

# emit the slug list for the pre-load diff query
open(OUT + "/_entity_slugs.txt", "w", encoding="utf-8").write("\n".join(r["slug"] for r in uniq))
