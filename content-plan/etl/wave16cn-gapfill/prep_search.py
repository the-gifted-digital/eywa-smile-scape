# Work items for the PubMed-search round: pages still below the section minimum (or without T1-3) after the reuse pass.
import json, os, sys
sys.path.insert(0, "/Volumes/SSD NN/CLAUDE AI/repos/eywa-protocol-spec/scripts/citation-gates")
import eywa_supabase as sb
K = sb.key(); OUT = "/Volumes/SSD NN/CLAUDE AI/tmp/gapfill-20260917"
MIN = {"5": 3, "6": 3, "3": 2, "4": 2, "7": 1}
pages = [p for p in sb.fetch("seo_website_page_master", "page_fingerprint,sitemap_node_id,page_name,page_category,page_intent_type,primary_entity_fp,related_entities_fps,target_keyword_fp,seo_title,meta_description,content_topic_tier,reconciliation_notes,status", "&brand_id=eq.smile-scape-clinic", k=K, order="page_fingerprint") if p["status"] != "Merged" and "CITATION EXEMPTION" not in (p.get("reconciliation_notes") or "")]
fps = {p["page_fingerprint"] for p in pages}
links = [l for l in sb.fetch("seo_page_citations", "page_fp,citation_fp,supports_claim,status", "&page_fp=like.smilescape-*", k=K, order="page_fp,citation_fp") if l["status"] == "active" and l["page_fp"] in fps]
cfps = sorted({l["citation_fp"] for l in links}); cits = {}
for i in range(0, len(cfps), 150):
    for c in sb.fetch("seo_citations", "fingerprint,title,citation_tier,pubmed_pmid", "&fingerprint=in.(%s)" % ",".join(cfps[i:i+150]), k=K, order="fingerprint"): cits[c["fingerprint"]] = c
ents = {e["entity_fingerprint"]: e for e in sb.fetch("seo_entity_graph", "entity_fingerprint,entity_name,ai_entity_summary,aliases", k=K, order="entity_fingerprint")}
kws = {r["fingerprint"]: r["keyword"] for r in sb.fetch("seo_x_ads_keywords_contextual_master", "fingerprint,keyword", "&fingerprint=like.smile*", k=K, order="fingerprint")}
notes = {}
for f in ("shortfall_run1.json", "shortfall_run2.json"):
    for n in json.load(open(os.path.join(OUT, f))):
        node, sf, note = (n[0], n[1], n[2]) if isinstance(n, list) else (n["node"], n["shortfall"], n.get("note"))
        notes[node] = note
by_page = {}
for l in links: by_page.setdefault(l["page_fp"], []).append(l)
index = []
for p in pages:
    sec = p["sitemap_node_id"].split(".")[0]; need = MIN.get(sec, 0)
    if not need: continue
    have = by_page.get(p["page_fingerprint"], [])
    t13 = sum(1 for l in have if (cits.get(l["citation_fp"], {}).get("citation_tier") or 9) <= 3)
    gap = max(need - len(have), 0)
    if gap == 0 and t13 > 0: continue
    if gap == 0: gap = 1
    prim = p["primary_entity_fp"]
    item = {"page_fp": p["page_fingerprint"], "node": p["sitemap_node_id"], "page_name": p["page_name"], "category": p["page_category"], "intent": p["page_intent_type"], "topic_tier": p["content_topic_tier"],
            "seo_title": p["seo_title"], "meta_description": p["meta_description"], "target_keyword": kws.get(p["target_keyword_fp"]),
            "primary_entity": {"fp": prim, "name": ents.get(prim, {}).get("entity_name"), "summary": ents.get(prim, {}).get("ai_entity_summary"), "aliases": ents.get(prim, {}).get("aliases")},
            "related_entities": [{"fp": r, "name": ents.get(r, {}).get("entity_name")} for r in (p.get("related_entities_fps") or [])],
            "need_total": need, "have": len(have), "gap": gap, "need_tier_1_3": t13 == 0,
            "existing_citations": [{"pmid": cits.get(l["citation_fp"], {}).get("pubmed_pmid"), "title": cits.get(l["citation_fp"], {}).get("title"), "tier": cits.get(l["citation_fp"], {}).get("citation_tier")} for l in have],
            "why_pool_failed": notes.get(p["sitemap_node_id"]),
            "pool_pmids_already_in_db_note": "ถ้า PMID ที่พบมีอยู่แล้วในระบบ ผู้เขียนผลจะผูกให้เอง — ไม่ต้องกังวล"}
    path = os.path.join(OUT, "search", p["sitemap_node_id"] + ".json"); json.dump(item, open(path, "w"), ensure_ascii=False, indent=1)
    index.append({"node": p["sitemap_node_id"], "page_fp": p["page_fingerprint"], "path": path, "gap": gap, "need_tier_1_3": t13 == 0})
json.dump(index, open(os.path.join(OUT, "index_search.json"), "w"), ensure_ascii=False)
print("items", len(index), "gap", sum(i["gap"] for i in index), "need_t13", sum(1 for i in index if i["need_tier_1_3"]))
