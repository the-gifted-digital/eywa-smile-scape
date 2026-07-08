# deployment/supabase-load/gen_relationships.py — Wave 1 backfill (2026-07-09)
# Parses content-plan/relationships.md (DR-012 10-edge planning vocab) ->
# 11_relationships.sql for seo_entity_relationships (DR-013 DB vocab).
#
# Vocab mapping (federation precedent, verified against prevth rows 2026-07-09):
#   parent_of            -> broader_than          (direction preserved)
#   subtype_of           -> is_a                  (direction preserved)
#   uses                 -> related_to  + [uses] note tag
#   alternative_to       -> related_to  + [alternative_to] note tag (symmetric, single row)
#   requires_assessment  -> requires    + [requires_assessment] note tag
#   evidenced_by         -> related_to  + [evidenced_by] note tag
#   treats / symptom_of / part_of / related_to -> unchanged
# brand_scope derived in SQL: both endpoints universal -> ['*'], else ['smile-scape-clinic'].
# Idempotent: NOT EXISTS on (from, to, edge_type). fingerprint/display auto by trigger.
import re, collections
from _lib import *

EDGE_MAP = {
    "parent_of": ("broader_than", False),
    "subtype_of": ("is_a", False),
    "treats": ("treats", False),
    "symptom_of": ("symptom_of", False),
    "uses": ("related_to", True),
    "alternative_to": ("related_to", True),
    "part_of": ("part_of", False),
    "requires_assessment": ("requires", True),
    "evidenced_by": ("related_to", True),
    "related_to": ("related_to", False),
}
SLUG = re.compile(r"^[a-z0-9][a-z0-9-]*$")

rows, skipped, in_vocab = [], [], False
for ln in open(SRC + "/relationships.md", encoding="utf-8"):
    if ln.startswith("## "):
        in_vocab = ln.strip() == "## Edge Vocabulary"
        continue
    if in_vocab or not ln.lstrip().startswith("|"):
        continue
    c = cells(ln)
    if not c or is_sep(c) or c[0] in ("From Entity", "Edge Type"):
        continue
    if len(c) < 5 or c[1] not in EDGE_MAP:
        if c[0] not in ("From Entity",):
            skipped.append(c[0] + "|" + (c[1] if len(c) > 1 else "?"))
        continue
    frm, edge, to, note = c[0], c[1], c[2], c[4]
    if not (SLUG.match(frm) and SLUG.match(to)):
        skipped.append(frm + "->" + to)
        continue
    db_edge, tag = EDGE_MAP[edge]
    note = None if note in DASH else note
    if tag:
        note = ("[" + edge + "]" + (" " + note if note else ""))
    rows.append((frm, db_edge, to, note))

# de-dupe (same from/edge/to may appear across sections; keep first note)
seen, uniq = set(), []
for r in rows:
    k = (r[0], r[1], r[2])
    if k in seen:
        continue
    seen.add(k)
    uniq.append(r)
rows = uniq
by_type = collections.Counter(r[1] for r in rows)
print("edges parsed:", len(rows), "| by db type:", dict(by_type), "| skipped:", len(skipped), skipped[:10])

vals = ",\n".join(
    "(" + ",".join([q(f), q(t), q(e), q(n) if n else "NULL"]) + ")"
    for f, e, t, n in rows
)
sql = (
    "-- 11_relationships.sql — seo_entity_relationships (SmileScape, Wave 1 backfill 2026-07-09).\n"
    "-- " + str(len(rows)) + " unique edges from content-plan/relationships.md (DR-012 -> DR-013 vocab map in gen_relationships.py).\n"
    "-- Idempotent: NOT EXISTS (from,to,edge_type). brand_scope: ['*'] iff both endpoints universal.\n"
    "-- Pre-check: endpoints missing from seo_entity_graph (expect 0 rows)\n"
    "with src(from_fp, to_fp, edge_type, note) as (values\n" + vals + ")\n"
    "select distinct fp from (\n"
    "  select from_fp fp from src union select to_fp from src) x\n"
    "where not exists (select 1 from public.seo_entity_graph g where g.entity_fingerprint = x.fp);\n\n"
    "-- Load\n"
    "with src(from_fp, to_fp, edge_type, note) as (values\n" + vals + "),\n"
    "ins as (\n"
    "  insert into public.seo_entity_relationships (from_entity_fp, to_entity_fp, edge_type, edge_note, brand_scope)\n"
    "  select s.from_fp, s.to_fp, s.edge_type, s.note,\n"
    "    case when '*' = any(f.brand_scope) and '*' = any(t.brand_scope)\n"
    "         then array['*']::text[] else array['smile-scape-clinic']::text[] end\n"
    "  from src s\n"
    "  join public.seo_entity_graph f on f.entity_fingerprint = s.from_fp\n"
    "  join public.seo_entity_graph t on t.entity_fingerprint = s.to_fp\n"
    "  where s.from_fp <> s.to_fp\n"
    "    and not exists (select 1 from public.seo_entity_relationships r\n"
    "                    where r.from_entity_fp = s.from_fp and r.to_entity_fp = s.to_fp\n"
    "                      and r.edge_type = s.edge_type)\n"
    "  returning edge_type, brand_scope)\n"
    "select count(*) inserted,\n"
    "       count(*) filter (where brand_scope = array['*']) universal,\n"
    "       count(*) filter (where brand_scope = array['smile-scape-clinic']) ss_scoped\n"
    "from ins;\n"
)
open(OUT + "/11_relationships.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 11_relationships.sql")
