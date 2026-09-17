# Build one JSON work item per citation-short smile-scape page, from the live tables.
import json, os, sys, re
sys.path.insert(0, "/Volumes/SSD NN/CLAUDE AI/repos/eywa-protocol-spec/scripts/citation-gates")
import eywa_supabase as sb
K = sb.key()
OUT = "/Volumes/SSD NN/CLAUDE AI/tmp/gapfill-20260917"
MIN = {"5": 3, "6": 3, "3": 2, "4": 2, "7": 1}

pages = sb.fetch("seo_website_page_master",
    "page_fingerprint,sitemap_node_id,page_name,page_category,page_intent_type,primary_entity_fp,related_entities_fps,target_keyword_fp,seo_title,meta_description,content_topic_tier,reconciliation_notes,status",
    "&brand_id=eq.smile-scape-clinic", k=K, order="page_fingerprint")
pages = [p for p in pages if p["status"] != "Merged"]
fps = {p["page_fingerprint"] for p in pages}
links = [l for l in sb.fetch("seo_page_citations", "page_fp,citation_fp,supports_claim,status,citation_purpose", "&page_fp=like.smilescape-*", k=K, order="page_fp,citation_fp") if l["status"] == "active" and l["page_fp"] in fps]
cit_fps = sorted({l["citation_fp"] for l in links})
cits = {}
for i in range(0, len(cit_fps), 150):
    chunk = cit_fps[i:i+150]
    for c in sb.fetch("seo_citations", "fingerprint,title,publication_year,citation_tier,citation_type,study_type,key_findings,journal_name,pubmed_pmid,is_retracted,verification_status", "&fingerprint=in.(%s)" % ",".join(chunk), k=K, order="fingerprint"):
        cits[c["fingerprint"]] = c
ents = {e["entity_fingerprint"]: e for e in sb.fetch("seo_entity_graph", "entity_fingerprint,entity_name,ai_entity_summary", k=K, order="entity_fingerprint")}
kws = {r["fingerprint"]: r["keyword"] for r in sb.fetch("seo_x_ads_keywords_contextual_master", "fingerprint,keyword", "&fingerprint=like.smile*", k=K, order="fingerprint")}

by_page = {}
for l in links:
    by_page.setdefault(l["page_fp"], []).append(l)
# best existing claim per citation (longest non-placeholder), as a worked example of an in-bounds claim
best_claim = {}
for l in links:
    sc = l.get("supports_claim") or ""
    if sc.startswith("wave16e") or len(sc) < 40:
        continue
    if len(sc) > len(best_claim.get(l["citation_fp"], "")):
        best_claim[l["citation_fp"]] = sc

def tier_ok(c):
    return c and c.get("citation_tier") is not None and c["citation_tier"] <= 3 and not c.get("is_retracted")

index = []
for p in pages:
    if "CITATION EXEMPTION" in (p.get("reconciliation_notes") or ""):
        continue
    sec = p["sitemap_node_id"].split(".")[0]
    need = MIN.get(sec, 0)
    if need == 0:
        continue
    have = by_page.get(p["page_fingerprint"], [])
    have_fps = {l["citation_fp"] for l in have}
    t13 = sum(1 for l in have if tier_ok(cits.get(l["citation_fp"])))
    gap = max(need - len(have), 0)
    need_t13 = t13 == 0
    if gap == 0 and not need_t13:
        continue
    if gap == 0 and need_t13:
        gap = 1
    prim, rel = p["primary_entity_fp"], set(p.get("related_entities_fps") or [])
    cand = {}
    for o in pages:
        if o["page_fingerprint"] == p["page_fingerprint"]:
            continue
        op, orel = o["primary_entity_fp"], set(o.get("related_entities_fps") or [])
        w = 3 if op == prim else 2 if prim in orel else 1 if op in rel else 0
        if not w:
            continue
        for l in by_page.get(o["page_fingerprint"], []):
            cf = l["citation_fp"]
            if cf in have_fps or not tier_ok(cits.get(cf)):
                continue
            e = cand.setdefault(cf, {"w": 0, "n": 0})
            e["w"] = max(e["w"], w); e["n"] += 1
    ranked = sorted(cand.items(), key=lambda kv: (-kv[1]["w"], cits[kv[0]]["citation_tier"], -(cits[kv[0]].get("publication_year") or 0), -kv[1]["n"]))[:12]
    item = {
        "page_fp": p["page_fingerprint"], "node": p["sitemap_node_id"], "page_name": p["page_name"],
        "category": p["page_category"], "intent": p["page_intent_type"], "topic_tier": p["content_topic_tier"],
        "seo_title": p["seo_title"], "meta_description": p["meta_description"],
        "target_keyword": kws.get(p["target_keyword_fp"]),
        "primary_entity": {"fp": prim, "name": ents.get(prim, {}).get("entity_name"), "summary": ents.get(prim, {}).get("ai_entity_summary")},
        "related_entities": [{"fp": r, "name": ents.get(r, {}).get("entity_name")} for r in sorted(rel)],
        "need_total": need, "have": len(have), "gap": gap, "need_tier_1_3": need_t13,
        "existing_citations": [{"fp": l["citation_fp"], "title": cits.get(l["citation_fp"], {}).get("title"), "tier": cits.get(l["citation_fp"], {}).get("citation_tier"), "claim": l.get("supports_claim")} for l in have],
        "candidates": [{"fp": cf, "relevance_weight": e["w"], "pages_using": e["n"], "title": cits[cf]["title"], "year": cits[cf].get("publication_year"), "tier": cits[cf]["citation_tier"],
                        "citation_type": cits[cf].get("citation_type"), "study_type": cits[cf].get("study_type"), "journal": cits[cf].get("journal_name"), "pmid": cits[cf].get("pubmed_pmid"),
                        "key_findings": cits[cf].get("key_findings") or [], "example_claim_elsewhere": best_claim.get(cf)} for cf, e in ranked],
    }
    path = os.path.join(OUT, "items", p["sitemap_node_id"] + ".json")
    json.dump(item, open(path, "w"), ensure_ascii=False, indent=1)
    index.append({"node": p["sitemap_node_id"], "page_fp": p["page_fingerprint"], "path": path, "gap": gap, "need_tier_1_3": need_t13, "n_candidates": len(ranked)})
json.dump(index, open(os.path.join(OUT, "index.json"), "w"), ensure_ascii=False, indent=1)
print("items", len(index), "gap_links", sum(i["gap"] for i in index), "no_candidates", sum(1 for i in index if i["n_candidates"] == 0), "thin(<gap)", sum(1 for i in index if 0 < i["n_candidates"] < i["gap"]))
