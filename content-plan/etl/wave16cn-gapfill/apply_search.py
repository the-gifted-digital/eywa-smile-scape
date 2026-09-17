# Insert verified PubMed picks: new seo_citations rows (by PMID) + seo_page_citations bindings. Idempotent.
import json, sys, hashlib, urllib.request
sys.path.insert(0, "/Volumes/SSD NN/CLAUDE AI/repos/eywa-protocol-spec/scripts/citation-gates")
import eywa_supabase as sb
K = sb.key()
TIER = {"systematic_review": 1, "meta_analysis": 1, "rct": 2, "clinical_guideline": 3, "regulatory_document": 4, "cohort_study": 5, "case_control": 5, "cross_sectional": 5, "case_series": 5, "textbook": 6, "expert_opinion": 6, "case_report": 6, "editorial": 6, "industry_publication": 6, "patient_resource": 6, "other": 6}
rows = json.load(open(sys.argv[1]))
by_pmid = {c["pubmed_pmid"]: c for c in sb.fetch("seo_citations", "fingerprint,pubmed_pmid,citation_tier,doi", "&pubmed_pmid=not.is.null", k=K, order="fingerprint")}
dois = {c["doi"] for c in by_pmid.values() if c.get("doi")}
bound = {(l["page_fp"], l["citation_fp"]) for l in sb.fetch("seo_page_citations", "page_fp,citation_fp", "&page_fp=like.smilescape-*", k=K, order="page_fp,citation_fp")}
new_cits, links, skipped = {}, [], []
for r in rows:
    pmid = str(r["pmid"]).strip()
    if not pmid.isdigit(): skipped.append((r["node"], pmid, "bad pmid")); continue
    tier = TIER.get(r["citation_type"], 6)
    if tier > 3: skipped.append((r["node"], pmid, "tier %d" % tier)); continue
    if pmid in by_pmid:
        fp = by_pmid[pmid]["fingerprint"]
    else:
        fp = "cite_" + hashlib.sha256(("pubmed:" + pmid).encode()).hexdigest().upper()[:16]
        if fp not in new_cits:
            doi = (r.get("doi") or "").strip() or None
            if doi and doi in dois: doi = None
            new_cits[fp] = {"fingerprint": fp, "fingerprint_display_name": fp[-6:] + "::pm" + pmid, "citation_slug": "pm" + pmid, "title": r["title"], "journal_name": r.get("journal"),
                "publication_year": r.get("year"), "pubmed_pmid": pmid, "doi": doi, "url": "https://pubmed.ncbi.nlm.nih.gov/%s/" % pmid,
                "citation_type": r["citation_type"], "study_type": r.get("study_type"), "citation_tier": tier, "abstract": r.get("abstract"), "key_findings": r.get("key_findings") or [],
                "language_code": "en", "is_retracted": False, "verification_status": "verified", "brand_scope": ["*"], "sync_state": "flat_loaded",
                "load_from": "smile-scape-clinic", "load_source": "smile-scape-clinic:wave16cn PubMed round (Sonnet search · Opus verify vs abstract)"}
            if doi: dois.add(doi)
    if (r["page_fp"], fp) in bound: skipped.append((r["node"], pmid, "already bound")); continue
    bound.add((r["page_fp"], fp))
    links.append({"page_fp": r["page_fp"], "citation_fp": fp, "citation_purpose": r["citation_purpose"], "section_context": "references", "status": "active",
                  "supports_claim": r["supports_claim"] + " · wave16cn 2026-09-17 PubMed round (Opus %s)" % r["verdict"]})
print("new citations", len(new_cits), "links", len(links), "skipped", len(skipped))
for s in skipped[:10]: print("  skip", s)
if "--apply" not in sys.argv: sys.exit(0)
def post(table, payload):
    for i in range(0, len(payload), 100):
        req = urllib.request.Request(sb.SB + table, data=json.dumps(payload[i:i+100]).encode(), method="POST", headers={"apikey": K, "Authorization": "Bearer " + K, "Content-Type": "application/json", "Prefer": "return=minimal"})
        urllib.request.urlopen(req)
post("seo_citations", list(new_cits.values())); print("citations inserted")
post("seo_page_citations", links); print("links inserted")
