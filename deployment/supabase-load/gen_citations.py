# deployment/supabase-load/gen_citations.py
import re
from _lib import *

TYPE_MAP = [  # (regex on schema-evidence text, citation_type) — order matters; first match wins
    (r"meta[- ]?analysis", "meta_analysis"),
    (r"systematic review|\bsrs?\b", "systematic_review"),   # SR / SRs / Cochrane SR
    (r"\brcts?\b|randomi", "rct"), (r"cohort", "cohort_study"), (r"case[- ]control", "case_control"),
    (r"cross[- ]sectional", "cross_sectional"), (r"case series", "case_series"),
    (r"case report", "case_report"), (r"guideline", "clinical_guideline"),
    (r"consensus|expert", "expert_opinion"), (r"textbook|book", "textbook"),
    (r"manufacturer|industry", "industry_publication"),
]
def ctype(ev):
    e = (ev or "").lower()
    for rx, t in TYPE_MAP:
        if re.search(rx, e): return t
    return "other"

DOI_RX  = re.compile(r"(10\.\d{4,9}/[^\s\)\]]+)")
PMID_RX = re.compile(r"pubmed.*?(\d{6,9})|pmid[:\s]*(\d{6,9})", re.I)

rows = []; pillar = None
for ln in open(SRC + "/citation-pool-seed.md", encoding="utf-8"):
    m = re.match(r"^##\s+Pillar\s+(\d+)", ln)
    if m: pillar = m.group(1); continue
    if not ln.lstrip().startswith("|") or pillar is None: continue
    c = cells(ln)
    if is_sep(c) or len(c) < 7: continue
    if not re.match(r"^\d+$", c[0]): continue          # skip header / non-numbered rows
    num, tier, authors, source, year, dois, ev = c[0], c[1], c[2], c[3], c[4], c[5], c[6]
    doim = DOI_RX.search(dois); doi = doim.group(1).rstrip(".") if doim else None
    pm = PMID_RX.search(dois); pmid = (pm.group(1) or pm.group(2)) if pm else None
    journal = re.sub(r"\s*\(.*?\)\s*$", "", source).strip()      # strip "(vol:pages)"
    yrm = re.search(r"\d{4}", year or ""); yr = yrm.group(0) if yrm else None
    tm = re.search(r"\d", tier or ""); tiern = tm.group(0) if tm else "2"
    title = (authors + ". " + journal + ". " + (yr or "")).strip().rstrip(".") + "."
    scope = "['smile-scape-clinic']" if tiern == "5" else "['*']"
    rows.append(dict(slug="p" + pillar + "-c" + num, title=title, authors=authors, year=yr,
                     pmid=pmid, doi=doi, journal=journal, tier=tiern, ctype=ctype(ev), scope=scope))

# de-dupe within file on slug/doi/pmid
seen_doi = set(); seen_pmid = set(); seen_slug = set(); uniq = []
for r in rows:
    if r["slug"] in seen_slug: continue
    if r["doi"] and r["doi"] in seen_doi: continue
    if r["pmid"] and r["pmid"] in seen_pmid: continue
    seen_slug.add(r["slug"])
    if r["doi"]: seen_doi.add(r["doi"])
    if r["pmid"]: seen_pmid.add(r["pmid"])
    uniq.append(r)
print("citations parsed:", len(rows), "unique:", len(uniq))

def row_select(r):
    guard = "x.citation_slug=" + q(r["slug"])
    if r["doi"]:  guard += " or x.doi=" + q(r["doi"])
    if r["pmid"]: guard += " or x.pubmed_pmid=" + q(r["pmid"])
    return ("select " + ",".join([
        q(r["slug"]), q(r["title"]), q(r["authors"]),
        (r["year"] or "NULL"), q(r["pmid"]), q(r["doi"]),
        q(r["journal"]), r["tier"], q(r["ctype"]), norm_scope(r["scope"])
    ]) + " where not exists (select 1 from public.seo_citations x where " + guard + ")")

body = "\nunion all\n".join(row_select(r) for r in uniq)
sql = ("-- 03_citations.sql — seo_citations (SmileScape). MERGE: insert net-new only\n"
       "-- (skip rows whose citation_slug/doi/pubmed_pmid already exist — shared ['*'] pool).\n"
       "-- title synthesized from authors+journal+year (seed has no explicit title). tier5 -> brand scope.\n"
       "insert into public.seo_citations\n"
       "  (citation_slug, title, authors, publication_year, pubmed_pmid, doi,\n"
       "   journal_name, citation_tier, citation_type, brand_scope)\n"
       + body + "\n;\n\n"
       "-- validation\n"
       "select count(*) ours_present from public.seo_citations where citation_slug like 'p%-c%';\n")
open(OUT + "/03_citations.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 03_citations.sql")
