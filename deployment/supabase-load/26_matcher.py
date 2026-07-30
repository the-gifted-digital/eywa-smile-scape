#!/usr/bin/env python3
# SOP keyword re-assignment matcher. Reads per-entity bundle, produces injective
# primary matching + capped semantics + flags, emits ETL SQL. Deterministic.
import json, re, io, sys

BUNDLE = sys.argv[1] if len(sys.argv) > 1 else '/Users/nn/.claude/projects/-Volumes-SSD-NN-CLAUDE-AI-repos-brands-eywa-smile-scape/41ac0d97-9c4c-47a1-9ea8-504455246a7d/tool-results/mcp-5814a0fb-eb09-4ece-89b3-227aeced0519-execute_sql-1785433387848.txt'
OUT = '/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape/deployment/supabase-load/26_keyword_reassign_sop.sql'

env = json.load(io.open(BUNDLE, encoding='utf-8'))
m = re.search(r'<untrusted-data-[0-9a-f-]+>\s*(\[.*\])\s*</untrusted-data', env['result'], re.S)
rows = json.loads(m.group(1))
print(f"entities in bundle: {len(rows)}")

# prole precedence fix: page_TYPE-driven roles (knowledge/local/brand) win over the name-based
# 'price' tag. A knowledge_article named "ราคา…" is §6 informational content, not a §3 price page (§5).
for _r in rows:
    for _p in (_r.get('pages') or []):
        pt = _p.get('ptype')
        if pt in ('knowledge_article', 'evidence_case'): _p['prole'] = 'knowledge'
        elif pt in ('branch_landing', 'local_landing'): _p['prole'] = 'local'
        elif pt in ('home', 'about', 'contact', 'doctor_profile'): _p['prole'] = 'brand'
        # else keep the bundle's prole ('price' by name, or 'service')

# ---- caps per page role (§6.3) ----
def sem_cap(prole, tier):
    if prole == 'local': return 6
    if prole == 'brand': return 5
    if tier == 'A' or prole == 'price': return 15
    if tier == 'B': return 12
    return 10

# ---- intent gate (§5): can this kw be PRIMARY of this page-role? ----
def primary_eligible(pg, kw):
    if kw['blk']: return False                                   # B3/B6/B10 never primary
    role = pg['prole']
    if role == 'price':
        if not kw['price']: return False                        # price page wants ราคา
    else:
        if kw['price']: return False                            # §8.3 กฎเหล็ก: non-price never takes ราคา primary
    if role == 'local':
        if not kw['geo']: return False                          # §9 local needs geo
    else:
        if kw['geo']: return False                              # geo reserved to local
    it = kw['intent']
    if role == 'knowledge' and it in ('commercial','transactional'): return False   # §6 info-only
    if role == 'brand' and it in ('commercial','transactional'): return False       # §2 no transactional
    # note: §3 forbids navigational, but within an entity's R1 pool "navigational" is almost always the
    # bare product-name head (DFS mislabel) which structurally BELONGS on the service hub (§5 monotonicity,
    # relevance>intent). True brand-nav lives on the brand entity. So we don't nav-block service here.
    return True

def role_fit(pg, kw):
    r, it = pg['prole'], kw['intent']
    if r == 'price' and kw['price']: return 3
    if r == 'local' and kw['geo']: return 3
    if r == 'knowledge' and it == 'informational': return 3
    if r == 'brand' and it in ('navigational','informational'): return 3
    if r == 'service' and it == 'commercial': return 3
    if r == 'service' and it == 'informational': return 2
    return 1

# assignment stores
page_primary = {}   # pfp -> kfp
kw_is_primary = set()
page_meta = {}      # pfp -> pg dict
kw_meta = {}        # kfp -> kw dict
page_entity = {}    # pfp -> entity
ent_pages = {}      # entity -> [pg]
ent_kws = {}        # entity -> [kw]
viab = {}           # pfp -> dict

for r in rows:
    ent = r['entity']
    pages = r['pages'] or []
    kws = r['keywords'] or []
    ent_pages[ent] = pages
    ent_kws[ent] = kws
    for pg in pages:
        page_meta[pg['pfp']] = pg; page_entity[pg['pfp']] = ent
    for kw in kws:
        kw_meta[kw['kfp']] = kw

    # ---- PRIMARY: page-driven greedy, injective. Pages claim in priority order
    #      (price -> service hub -> ... ) so hubs win the entity HEAD term (§5 monotonicity). ----
    tier_rank = {'A':0,'B':1,'C':2,'D':3}
    # brand/home first so it claims the brand HEAD (smilescape) before service pages of the same
    # brand entity grab it; then price -> service -> knowledge -> local.
    role_rank = {'brand':0,'price':1,'service':2,'knowledge':3,'local':4}
    ordered_pages = sorted(pages, key=lambda p:(role_rank.get(p['prole'],5), tier_rank.get(p['tier'],5),
                                                p['depth'], p['node']))
    used_kw = set()
    for pg in ordered_pages:
        cands = [kw for kw in kws if kw['kfp'] not in used_kw and primary_eligible(pg, kw)]
        if not cands: continue
        r = pg['prole']
        if r == 'price':
            cands.sort(key=lambda k:(-k['vol'], k['toks'], k['kd']))
        elif r == 'service':                       # head-first (§5 monotonicity). Thai no-space compounds fool
            # token-count (L13), so use char length as the head-ness proxy: shortest term = broadest = the hub head.
            cands.sort(key=lambda k:(k['toks'], len(k['kw']), -role_fit(pg,k), -k['vol'], k['kd'], -float(k['cpc'])))
        elif r == 'brand':                           # home/about own the brand NAME first, then shortest
            def brandsig(k): return 0 if re.search(r'smile\s*scape|สไมล์\s*สเคป', k['kw'], re.I) else 1
            cands.sort(key=lambda k:(brandsig(k), len(k['kw']), -k['vol']))
        else:                                        # knowledge / local: volume-first
            cands.sort(key=lambda k:(-role_fit(pg,k), -k['vol'], k['toks'], k['kd']))
        kw = cands[0]
        page_primary[pg['pfp']] = kw['kfp']
        kw_is_primary.add(kw['kfp']); used_kw.add(kw['kfp'])
        v = {'kw_rule_version':'1.1','relevance_tier':'R1','intent_match': role_fit(pg,kw) >= 2,
             'volume_12m':kw['vol'],'kd':kw['kd'],'role_fit':role_fit(pg,kw),
             'decided_by':'etl-sop','decided_at':'2026-07-31'}
        if kw['vol'] == 0: v['v0_note'] = 'dfs_blank_awaiting_gsc'   # §7/L8 — v0 intentional
        viab[pg['pfp']] = v

# ---- SEMANTIC: leftover kws (never primary) → pages of entity, capped, ≤3 pages/kw ----
page_semantic = {}   # pfp -> [kfp]
kw_sem_uses = {}     # kfp -> count
for ent, pages in ent_pages.items():
    leftover = [k for k in ent_kws.get(ent, []) if k['kfp'] not in kw_is_primary and not k['blk']]
    leftover.sort(key=lambda k: -k['vol'])
    # pages that got a primary first (hub-ish), then others; only give semantics to pages that exist
    ordered_pages = sorted(pages, key=lambda p: (0 if p['pfp'] in page_primary else 1,
                                                 {'A':0,'B':1,'C':2,'D':3}.get(p['tier'],5), p['node']))
    for pg in ordered_pages:
        cap = sem_cap(pg['prole'], pg['tier'])
        bucket = []
        for k in leftover:
            if len(bucket) >= cap: break
            if kw_sem_uses.get(k['kfp'], 0) >= 3: continue
            # don't put a geo/price kw as semantic on a mismatched page-role primary slot? semantics looser; allow
            bucket.append(k['kfp'])
        for kfp in bucket:
            kw_sem_uses[kfp] = kw_sem_uses.get(kfp, 0) + 1
        if bucket:
            page_semantic[pg['pfp']] = bucket

# ---- stats ----
n_pages = len(page_meta)
n_primary = len(page_primary)
n_kwnone = n_pages - n_primary
over_cap = sum(1 for pfp, s in page_semantic.items() if len(s) > sem_cap(page_meta[pfp]['prole'], page_meta[pfp]['tier']))
max_sem = max((len(s) for s in page_semantic.values()), default=0)
multi_sem = sum(1 for c in kw_sem_uses.values() if c > 3)
v0_primary = sum(1 for pfp,kfp in page_primary.items() if kw_meta[kfp]['vol'] == 0)
print(f"pages={n_pages}  primary_assigned={n_primary}  kw-none={n_kwnone}")
print(f"semantic pages={len(page_semantic)}  max_semantic/page={max_sem}  over_cap={over_cap}  kw>3pages={multi_sem}")
print(f"v0 primaries={v0_primary}  distinct primary kws={len(kw_is_primary)}")

# ---- inspect: every service hub (tier A/B) + every price page, entity-wide ----
print("\n== SERVICE HUBS (tier A/B) & PRICE PAGES ==")
hubs = []
for ent, pages in ent_pages.items():
    for pg in pages:
        if (pg['prole']=='service' and pg['tier'] in ('A','B')) or pg['prole']=='price':
            kfp = page_primary.get(pg['pfp'])
            pk = kw_meta[kfp]['kw']+f" v{kw_meta[kfp]['vol']}" if kfp else "— KW-NONE"
            hubs.append((pg['node'], pg['prole'], pg['tier'], ent[:22], pk))
for node,role,tier,ent,pk in sorted(hubs, key=lambda x:[int(t) for t in x[0].split('.')]):
    print(f"  {node:<11}{role:<8}{tier} {ent:<24} <- {pk}")

# ---- emit COMPACT set-based SQL (temp staging; fingerprints reconstructed from constant prefix) ----
PREFIX = "smile scape clinic::🇹🇭 th – thailand::🇹🇭 th – thai::"
def esc(s): return str(s).replace("'", "''")
def node_of(pfp): return pfp[len('smilescape-'):]

vals = []
for pfp, kfp in page_primary.items():
    kw = kw_meta[kfp]
    use = 'brand_nav' if (kw['vol'] == 0 and page_meta[pfp]['prole'] == 'brand' and page_entity[pfp] == 'smilescape-dental-clinic') else 'target_keyword'
    vals.append(f"('{esc(node_of(pfp))}','{esc(kw['kw'])}','primary','{use}')")
for pfp, sem in page_semantic.items():
    for kfp in sem:
        vals.append(f"('{esc(node_of(pfp))}','{esc(kw_meta[kfp]['kw'])}','semantic',NULL)")

P = PREFIX.replace("'", "''")
sql = f"""-- 26_keyword_reassign_sop.sql — SOP v1.1 re-assignment (supersedes 24). Generated 2026-07-31.
-- Injective R1 primary matching + capped semantics + flags. Backup: _ss_kw_backup_wave14. Reversible.
-- decided_by=etl-sop for all; page_purpose left untouched (v0 intent carried in viability.v0_note).
begin;
update seo_website_page_master set target_keyword_fp=null, semantic_keywords_fps=null, flag_review=null where page_fingerprint like 'smilescape-%';
update seo_x_ads_keywords_contextual_master set keyword_use_as=null where brand ilike '%smile%scape%';
create temp table _asg(node text, kw text, kind text, use_as text) on commit drop;
insert into _asg(node,kw,kind,use_as) values
{",".join(vals)};
-- primary target
update seo_website_page_master p
  set target_keyword_fp='{P}'||a.kw
  from _asg a where a.kind='primary' and p.page_fingerprint='smilescape-'||a.node;
-- viability_assessment built DB-side from live snapshot of the assigned keyword (§11)
update seo_website_page_master p set viability_assessment = jsonb_build_object(
    'kw_rule_version','1.1','relevance_tier','R1','decided_by','etl-sop','decided_at','2026-07-31',
    'volume_12m',coalesce(s.volume_recent_12m,0),'kd',coalesce(s.keyword_difficulty,0),
    'intent',coalesce(s.search_intent,'-'),
    'v0_note', case when coalesce(s.volume_recent_12m,0)=0 then 'dfs_blank_awaiting_gsc' else null end)
  from seo_x_ads_keywords_contextual_master k
  left join seo_x_ads_keywords_monthly_market_snapshot s on s.keyword=k.keyword and s.brand=k.brand
  where p.page_fingerprint like 'smilescape-%' and p.target_keyword_fp=k.fingerprint;
-- keyword_use_as for primaries
update seo_x_ads_keywords_contextual_master k set keyword_use_as=a.use_as
  from _asg a where a.kind='primary' and k.fingerprint='{P}'||a.kw;
-- semantic arrays (aggregate per page)
update seo_website_page_master p set semantic_keywords_fps=a.arr
  from (select node, array_agg('{P}'||kw) arr from _asg where kind='semantic' group by node) a
  where p.page_fingerprint='smilescape-'||a.node;
-- keyword_use_as for semantics (only those not already a primary)
update seo_x_ads_keywords_contextual_master k set keyword_use_as='semantic_keyword'
  from (select distinct kw from _asg where kind='semantic') a
  where k.keyword_use_as is null and k.fingerprint='{P}'||a.kw;
-- kw-none: any SS content page still without a primary
update seo_website_page_master set flag_review='kw-none'
  where page_fingerprint like 'smilescape-%' and target_keyword_fp is null;
commit;"""
io.open(OUT, 'w', encoding='utf-8').write(sql + "\n")
print(f"wrote {OUT}  ({len(sql)} bytes, {len(vals)} staging rows)")
