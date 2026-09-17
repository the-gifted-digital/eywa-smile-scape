# Insert verified picks (rows.json) into seo_page_citations via PostgREST. Idempotent on (page_fp, citation_fp).
import json, os, sys, urllib.request
sys.path.insert(0, "/Volumes/SSD NN/CLAUDE AI/repos/eywa-protocol-spec/scripts/citation-gates")
import eywa_supabase as sb
K = sb.key()
rows = json.load(open(sys.argv[1]))
PURPOSES = {'supporting_evidence','definition','statistic','guideline_reference','counterargument','methodology','further_reading','historical_context'}
existing = {(l["page_fp"], l["citation_fp"]) for l in sb.fetch("seo_page_citations", "page_fp,citation_fp", "&page_fp=like.smilescape-*", k=K, order="page_fp,citation_fp")}
valid_cits = {c["fingerprint"] for c in sb.fetch("seo_citations", "fingerprint", "&citation_tier=lte.3", k=K, order="fingerprint")}
payload, skipped = [], []
for r in rows:
    key = (r["page_fp"], r["citation_fp"])
    if key in existing: skipped.append((key, "already bound")); continue
    if r["citation_fp"] not in valid_cits: skipped.append((key, "citation not T1-3 / unknown")); continue
    if r["citation_purpose"] not in PURPOSES: r["citation_purpose"] = "supporting_evidence"
    if not r["supports_claim"] or len(r["supports_claim"]) < 30: skipped.append((key, "claim too short")); continue
    payload.append({"page_fp": r["page_fp"], "citation_fp": r["citation_fp"], "citation_purpose": r["citation_purpose"],
                    "supports_claim": r["supports_claim"] + " · wave16cn 2026-09-17 reuse-gapfill (Sonnet pick · Opus %s)" % r["verdict"],
                    "section_context": "references", "status": "active"})
    existing.add(key)
print("to insert", len(payload), "skipped", len(skipped))
for s in skipped[:10]: print("  skip", s)
if "--apply" not in sys.argv: sys.exit(0)
for i in range(0, len(payload), 200):
    req = urllib.request.Request(sb.SB + "seo_page_citations", data=json.dumps(payload[i:i+200]).encode(), method="POST",
        headers={"apikey": K, "Authorization": "Bearer " + K, "Content-Type": "application/json", "Prefer": "return=minimal"})
    urllib.request.urlopen(req)
    print("inserted", min(i+200, len(payload)))
