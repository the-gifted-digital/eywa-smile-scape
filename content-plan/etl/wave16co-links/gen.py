# Plan contextual internal links so every active smile-scape page meets required_min_outbound
# (contextual) and pages below required_min_inbound get inbound. Dry-run writes proposal.json; --apply inserts.
import json, sys, hashlib, collections, urllib.request
sys.path.insert(0, "/Volumes/SSD NN/CLAUDE AI/repos/eywa-protocol-spec/scripts/citation-gates")
import eywa_supabase as sb
K = sb.key(); OUT = "/Volumes/SSD NN/CLAUDE AI/tmp/links-20260917"
pages = [p for p in sb.fetch("seo_website_page_master",
    "page_fingerprint,sitemap_node_id,page_name,page_category,page_role,node_tier_strategy,primary_entity_fp,related_entities_fps,parent_page_fp,target_keyword_fp,required_min_inbound,required_min_outbound,anchor_strategy_mode,status",
    "&brand_id=eq.smile-scape-clinic", k=K, order="page_fingerprint") if p["status"] != "Merged"]
P = {p["page_fingerprint"]: p for p in pages}
links = [l for l in sb.fetch("seo_page_internal_links", "from_page_fp,to_page_fp,link_type,anchor_text", "&from_page_fp=like.smilescape-*", k=K, order="from_page_fp,to_page_fp") if l["to_page_fp"] in P and l["from_page_fp"] in P]
ents = {e["entity_fingerprint"]: e for e in sb.fetch("seo_entity_graph", "entity_fingerprint,entity_name,aliases", k=K, order="entity_fingerprint")}
rels = collections.defaultdict(set)
for r in sb.fetch("seo_entity_relationships", "from_entity_fp,to_entity_fp,status", k=K, order="id"):
    if (r.get("status") or "active") in ("active", "planned"):
        rels[r["from_entity_fp"]].add(r["to_entity_fp"]); rels[r["to_entity_fp"]].add(r["from_entity_fp"])
kw = {r["fingerprint"]: r["keyword"] for r in sb.fetch("seo_x_ads_keywords_contextual_master", "fingerprint,keyword", "&fingerprint=like.smile*", k=K, order="fingerprint")}

out_any = collections.defaultdict(set); out_ctx = collections.defaultdict(int); in_any = collections.defaultdict(int); in_ctx = collections.defaultdict(int); in_anchors = collections.defaultdict(collections.Counter)
for l in links:
    out_any[l["from_page_fp"]].add(l["to_page_fp"]); in_any[l["to_page_fp"]] += 1
    if l["link_type"] == "contextual":
        out_ctx[l["from_page_fp"]] += 1; in_ctx[l["to_page_fp"]] += 1; in_anchors[l["to_page_fp"]][l["anchor_text"]] += 1
by_primary = collections.defaultdict(list)
for p in pages: by_primary[p["primary_entity_fp"]].append(p["page_fingerprint"])
children = collections.defaultdict(list)
for p in pages:
    if p["parent_page_fp"]: children[p["parent_page_fp"]].append(p["page_fingerprint"])

def thai_alias(efp):
    a = (ents.get(efp, {}).get("aliases") or "")
    for tok in [t.strip(" {}\"") for t in a.replace("{", ",").replace("}", ",").split(",")]:
        if tok and any("฀" <= ch <= "๿" for ch in tok) and len(tok) <= 60:
            return tok
    return None

def anchor_for(t):
    """Anchor choices for target page t: keyword (exact), Thai entity alias (topical). Rotate to avoid A6 monotony; never the page title (A3)."""
    cands = []
    k = kw.get(t["target_keyword_fp"]) if t["target_keyword_fp"] else None
    if k and k.strip() != t["page_name"].strip() and len(k) <= 60: cands.append((k.strip(), "exact"))
    al = thai_alias(t["primary_entity_fp"])
    if al and al != t["page_name"].strip(): cands.append((al, "topical"))
    en = (ents.get(t["primary_entity_fp"], {}).get("entity_name") or "").strip()
    if en and en != t["page_name"].strip() and len(en) <= 60: cands.append((en, "topical"))
    if not cands: return None
    used = in_anchors[t["page_fingerprint"]]
    cands.sort(key=lambda c: used[c[0]])
    return cands[0]

def score(p, t):
    if t["page_fingerprint"] == p["page_fingerprint"] or t["page_fingerprint"] in out_any[p["page_fingerprint"]] or t["page_fingerprint"] == p["parent_page_fp"]: return -1
    s = 0
    prel = set(p.get("related_entities_fps") or [])
    if t["primary_entity_fp"] in prel: s += 3
    if t["primary_entity_fp"] == p["primary_entity_fp"] and t["page_category"] != p["page_category"]: s += 2
    if t["primary_entity_fp"] in rels.get(p["primary_entity_fp"], ()): s += 2
    if p["parent_page_fp"] and t["parent_page_fp"] == p["parent_page_fp"]: s += 1
    if t["node_tier_strategy"] in ("pillar", "hub"): s += 1
    if in_any[t["page_fingerprint"]] < (t["required_min_inbound"] or 0): s += 2
    if in_ctx[t["page_fingerprint"]] >= 15: s -= 1
    return s

proposal = []
short = [p for p in pages if out_ctx[p["page_fingerprint"]] < (p["required_min_outbound"] or 0)]
for p in sorted(short, key=lambda x: x["sitemap_node_id"]):
    need = int(p["required_min_outbound"] or 0) - out_ctx[p["page_fingerprint"]]
    ranked = sorted(((score(p, t), t) for t in pages), key=lambda st: (-st[0], st[1]["sitemap_node_id"]))
    for s, t in ranked:
        if need <= 0 or s <= 0: break
        a = anchor_for(t)
        if not a: continue
        role = "primary_hub" if t["node_tier_strategy"] in ("pillar", "hub") else ("cross_cluster" if t["primary_entity_fp"] != p["primary_entity_fp"] and t["primary_entity_fp"] not in set(p.get("related_entities_fps") or []) else "cluster_spoke")
        ctx = "entity-bridge (related-entity)" if t["primary_entity_fp"] in set(p.get("related_entities_fps") or []) else "entity-bridge (relationship)" if t["primary_entity_fp"] in rels.get(p["primary_entity_fp"], ()) else "sibling / same-entity bridge"
        proposal.append({"from": p["page_fingerprint"], "to": t["page_fingerprint"], "from_node": p["sitemap_node_id"], "to_node": t["sitemap_node_id"], "score": s, "anchor": a[0], "variant": a[1], "role": role, "ctx": ctx})
        out_any[p["page_fingerprint"]].add(t["page_fingerprint"]); out_ctx[p["page_fingerprint"]] += 1; in_any[t["page_fingerprint"]] += 1; in_ctx[t["page_fingerprint"]] += 1; in_anchors[t["page_fingerprint"]][a[0]] += 1
        need -= 1
    if need > 0: proposal.append({"from": p["page_fingerprint"], "from_node": p["sitemap_node_id"], "unfilled": need})

json.dump(proposal, open(OUT + "/proposal.json", "w"), ensure_ascii=False, indent=1)
links_new = [x for x in proposal if "to" in x]
print("short pages", len(short), "new links", len(links_new), "unfilled", sum(x.get("unfilled", 0) for x in proposal))
print("by ctx", collections.Counter(x["ctx"] for x in links_new))
print("by variant", collections.Counter(x["variant"] for x in links_new))
print("still below required inbound (all types)", sum(1 for p in pages if in_any[p["page_fingerprint"]] < (p["required_min_inbound"] or 0)))
print("targets receiving", len({x["to"] for x in links_new}), "max per target", max(collections.Counter(x["to"] for x in links_new).values()))
print("sample", [(x["from_node"], x["to_node"], x["anchor"], x["variant"], x["score"]) for x in links_new[:8]])
if "--apply" not in sys.argv: sys.exit(0)
payload = []
for x in links_new:
    h = hashlib.sha256(("%s|%s|contextual|wave16co" % (x["from"], x["to"])).encode()).hexdigest().upper()[:16]
    payload.append({"fingerprint": "pil_" + h, "fingerprint_display_name": h[-6:] + "::contextual", "from_page_fp": x["from"], "to_page_fp": x["to"], "link_type": "contextual",
        "link_role": x["role"], "link_priority": 8 if x["role"] != "cross_cluster" else 6, "anchor_text": x["anchor"], "anchor_variant_type": x["variant"],
        "section_context": "wave16co " + x["ctx"], "status": "planned", "planned": True, "implemented": False, "is_reciprocal": False, "is_cross_brand": False,
        "brand_scope": ["smile-scape-clinic"], "sync_state": "flat_loaded", "first_planned_at": "2026-09-17T00:00:00+00:00"})
for i in range(0, len(payload), 200):
    req = urllib.request.Request(sb.SB + "seo_page_internal_links", data=json.dumps(payload[i:i+200]).encode(), method="POST",
        headers={"apikey": K, "Authorization": "Bearer " + K, "Content-Type": "application/json", "Prefer": "return=minimal"})
    urllib.request.urlopen(req); print("inserted", min(i+200, len(payload)))
