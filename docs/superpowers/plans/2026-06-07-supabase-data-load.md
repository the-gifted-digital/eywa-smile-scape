# SmileScape → Supabase Stage-1.5 Flat-Load — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Load SmileScape's Stage-1 content plan (`content-plan/*.md`) into the live EYWA Supabase (project **GTGT** `lffcbeszjqzioobqfdav`, Schema v1.21), scoped to brand `smile-scape-clinic`, mirroring the proven Deezy Path-A pattern.

**Architecture:** Standalone Python parsers read each markdown file and emit deterministic, idempotent `.sql` into `deployment/supabase-load/`. The operator runs each `.sql` in the Supabase SQL Editor in strict numbered order; Claude validates each via the Supabase MCP (`execute_sql`, project `lffcbeszjqzioobqfdav`) before the next file. Shared `['*']` entities and citations already exist (SmileScape is the 2nd dental brand) → entity and citation loads MERGE (insert net-new only). No schema DDL. No other brand's rows are touched.

**Tech Stack:** Python 3 (stdlib only), PostgreSQL 17 (Supabase), Supabase MCP server `5814a0fb-eb09-4ece-89b3-227aeced0519`.

**Spec:** `docs/superpowers/specs/2026-06-07-supabase-data-load-design.md`. **Reference impl:** `repos/brands/eywa-deezy/deployment/supabase-load/`.

---

## Shared constants & conventions

Used by every generator (defined once in `_lib.py`, Task 0):

| Constant | Value |
|---|---|
| `BRAND_ID` (uuid, `brands.id`) | `c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25` |
| `BRAND_SLUG` | `smile-scape-clinic` |
| `BRAND_NAME` | `Smile Scape Clinic` |
| `BRAND_NAME_LOWER` (keyword fp) | `smile scape clinic` |
| `PROJECT_ID` (MCP) | `lffcbeszjqzioobqfdav` |
| repo root | `/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape` |

**Conventions (locked, from spec §5):** `brand_scope` = slug array, normalize planning `smile-scape` → `smile-scape-clinic`; `['*']` = universal. Trigger-generated `fingerprint`/`fingerprint_display_name`/`brand_scope_id`/`brand_scope_name` → **leave NULL** (except keywords, whose `fingerprint` is the explicit PK). `entity_fingerprint`/`entity_slug` = kebab slug; `entity_type` lowercase. `notion_id` NULL. Every file ends with a validation `SELECT` and uses an idempotent insert (ON CONFLICT / NOT EXISTS).

**Per-file run protocol (applies to every load task):** operator opens Supabase Dashboard → SQL Editor → pastes the file → Run → tells Claude "ran NN". Claude then runs that task's MCP validation query and confirms ✅ before the next file. On any error, stop — do not blind re-run.

---

## File structure

```
deployment/supabase-load/
  _lib.py                  # shared parser helpers + constants
  gen_clusters.py   → 00_clusters.sql
  gen_entities.py   → 01_entities.sql
  02_entity_extensions.sql # static INSERT..SELECT (no parser)
  gen_citations.py  → 03_citations.sql
  04_authors.sql           # static, hand-written (2 doctors)
  05_branches.sql          # static, hand-written (2 branches)
  gen_pages.py      → 06_pages.sql
  gen_keywords.py   → 10_keywords.sql
  RUN-ORDER.md             # operator how-to + status table
  LOAD-LOG.md              # conventions + progress + flags
```

---

## Task 0: Scaffold folder, shared lib, operator docs

**Files:**
- Create: `deployment/supabase-load/_lib.py`
- Create: `deployment/supabase-load/RUN-ORDER.md`
- Create: `deployment/supabase-load/LOAD-LOG.md`

- [ ] **Step 1: Create `_lib.py`**

```python
# deployment/supabase-load/_lib.py — shared helpers + constants for SmileScape Stage-1.5 load
import re

BRAND_ID    = "c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25"   # brands.id (uuid)
BRAND_SLUG  = "smile-scape-clinic"
BRAND_NAME  = "Smile Scape Clinic"
BRAND_LOWER = "smile scape clinic"
ROOT = "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
SRC  = ROOT + "/content-plan"
OUT  = ROOT + "/deployment/supabase-load"
DASH = {"—", "-", "–", "", "N/A", "n/a", "TBD", "tbd", "?"}

def q(s):
    """SQL-quote a scalar; NULL for empty/dash placeholders."""
    if s is None or (isinstance(s, str) and s.strip() in DASH):
        return "NULL"
    return "'" + str(s).strip().replace("'", "''") + "'"

def cells(line):
    """Split a markdown table row into trimmed cells."""
    p = [c.strip() for c in line.rstrip("\n").split("|")]
    if p and p[0] == "": p = p[1:]
    if p and p[-1] == "": p = p[:-1]
    return p

def is_sep(c):
    """True for a markdown separator row like |---|:--:|."""
    return bool(c) and all(set(x) <= set("-: ") for x in c if x != "")

def norm_scope(raw):
    """\"['*'] mixed\" / \"['smile-scape']\" -> SQL text[] literal, normalized to brand slug."""
    toks = re.findall(r"[*A-Za-z0-9\-]+", raw or "")
    out = []
    for t in toks:
        if t in ("mixed",): continue
        if t == "smile-scape": t = "smile-scape-clinic"
        out.append(t)
    if not out: out = ["*"]
    return "array[" + ",".join("'" + t + "'" for t in out) + "]::text[]"

def scope_primary(scope_literal):
    return "'smile-scape-clinic'" if "smile-scape-clinic" in scope_literal else "'*'"

def text_array(items):
    """list[str] -> SQL text[] literal, or NULL."""
    vals = [i.strip().replace("'", "''") for i in (items or []) if i and i.strip() not in DASH]
    return "array[" + ",".join("'" + v + "'" for v in vals) + "]::text[]" if vals else "NULL"

def split_aliases(cell):
    """Aliases cell -> list (comma-separated, Thai+English)."""
    if not cell or cell.strip() in DASH: return []
    return [a for a in re.split(r"[,/]", cell) if a.strip()]
```

- [ ] **Step 2: Create `RUN-ORDER.md`** (operator interface — copy the table; statuses start `⏳ pending`)

````markdown
# SmileScape — Supabase Load: RUN ORDER (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav` · brand `smile-scape-clinic`. Path A: parser-generated SQL → run in Supabase SQL Editor → Claude validates via MCP. Conventions: `LOAD-LOG.md`.

## HOW TO RUN A FILE
1. Supabase Dashboard → project GTGT → SQL Editor → New query.
2. Open the `.sql` from this folder, copy ALL, paste, Run (▶). The closing `select`/`returning` shows the result.
3. Tell Claude "ran NN done" → Claude validates (count + FK + orphan + brand-isolation) via MCP and confirms ✅.
4. Run files strictly in numbered order. Do NOT skip (FK/reference deps).

> Re-run safety: every file is idempotent (ON CONFLICT / NOT EXISTS). Inserts are atomic — a failed file inserts nothing. On error, tell Claude; don't blind re-run.

## RUN ORDER
| # | File | Table | Rows (plan) | Status |
|---|------|-------|------|--------|
| 00 | `00_clusters.sql` | `seo_topic_cluster_master` | 20 | ⏳ pending |
| 01 | `01_entities.sql` | `seo_entity_graph` | 163 → MERGE (net-new) | ⏳ pending |
| 02 | `02_entity_extensions.sql` | condition/symptom/anatomy/procedures/drug | ~82 | ⏳ pending |
| 03 | `03_citations.sql` | `seo_citations` | net-new (dedup doi/pmid) | ⏳ pending |
| 04 | `04_authors.sql` | `seo_authors_reviewers` + `seo_doctor_assignments` | 2 (+assign) | ⏳ pending |
| 05 | `05_branches.sql` | `seo_branches` | 2 (partial) | ⏳ pending |
| 06 | `06_pages.sql` | `seo_website_page_master` | ~726 (stub) | ⏳ pending |
| 10 | `10_keywords.sql` | `seo_x_ads_keywords_contextual_master` | ~680 (seed→DFS) | ⏳ pending |

## DEFERRED (not this session)
relationships (edge-vocab+evidence) · page_citations (Phase F) · page_internal_links (Phase F) · product/device entity-ext (enum) · programmatic templates (Wave 1B) · keyword metrics (DFS) · Notion sync (n8n) · image URLs (Cloudflare).
````

- [ ] **Step 3: Create `LOAD-LOG.md`** (conventions recap + empty progress table — Claude appends results as files load)

```markdown
# SmileScape — Supabase Flat-Load Log (Stage 1.5)

> Target: GTGT `lffcbeszjqzioobqfdav`. Brand: Smile Scape Clinic (`brands.id=c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25`, slug `smile-scape-clinic`, fp `brnd_8314A55613F44453`). Fresh load (0 content rows). Method: parse content-plan/*.md → SQL → run via SQL Editor → Claude validates via MCP.

## Conventions
- brand_scope = slug array; planning `smile-scape` normalized → `smile-scape-clinic`; `['*']` universal.
- Triggers auto-set fingerprint/display/brand_scope_id/name → leave NULL. entity_fingerprint=slug; entity_type lowercase. notion_id NULL.
- MERGE tables (2nd dental brand): entities ON CONFLICT(entity_fingerprint); citations dedup on slug/doi/pmid. page_fingerprint=`smilescape-{node}`; keyword fp=`smile scape clinic::{loc}::{lang}::{kw}`.

## Progress
| Phase | Table | Rows | Status |
|---|---|---|---|
| (filled as we go) | | | |

## Flags
- Author slug: entities.md `dr-woraphat-jarangkul` vs team file `dr-worapat-jarangkul.md` — canonical chosen = TBD at Task 5.
- Shared-entity type mismatch (e.g. ceramic-implant product vs treatment): existing row wins.
```

- [ ] **Step 4: Commit**

```bash
cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
git add deployment/supabase-load/_lib.py deployment/supabase-load/RUN-ORDER.md deployment/supabase-load/LOAD-LOG.md
git commit -m "chore(supabase-load): scaffold folder, shared lib, operator docs"
```

---

## Task 1: Clusters → `00_clusters.sql`

**Files:**
- Create: `deployment/supabase-load/gen_clusters.py`
- Generates: `deployment/supabase-load/00_clusters.sql`
- Source: `content-plan/clusters.md` (table under `## Cluster Master Table`: `Cluster ID | Cluster Name | Domain | Parent Cluster (text) | Pillar Page | Brand Scope`)

- [ ] **Step 1: Write `gen_clusters.py`**

```python
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
```

- [ ] **Step 2: Run the generator**

Run: `cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape/deployment/supabase-load" && python3 gen_clusters.py`
Expected: `clusters parsed: 20` then `bytes: … -> 00_clusters.sql`.

- [ ] **Step 3: Eyeball the SQL**

Run: `grep -c "^(" 00_clusters.sql ; grep -c "^update" 00_clusters.sql`
Expected: 20 value rows; ~8 parent-update lines (clusters with a non-`—` parent). Confirm `smile-scape` was normalized: `grep -n "'smile-scape'" 00_clusters.sql` → **no matches** (only `smile-scape-clinic`).

- [ ] **Step 4: Commit**

```bash
git add deployment/supabase-load/gen_clusters.py deployment/supabase-load/00_clusters.sql
git commit -m "feat(supabase-load): clusters generator + 00_clusters.sql (20)"
```

- [ ] **Step 5: Operator runs `00_clusters.sql`; then Claude validates via MCP**

`execute_sql(project_id="lffcbeszjqzioobqfdav")`:
```sql
select count(*) total,
       count(*) filter (where cluster_type='topical') topical,
       count(parent_cluster_fp) with_parent,
       count(*) filter (where fingerprint like 'clst_%') fp_ok
from seo_topic_cluster_master
where cluster_slug in (select cluster_slug from seo_topic_cluster_master
                       where brand_scope_primary in ('*','smile-scape-clinic'))
  and 'smile-scape-clinic' = any(brand_scope) or brand_scope_primary='*';
```
Better-scoped check (the 20 we inserted):
```sql
select count(*) total, count(parent_cluster_fp) with_parent,
       count(*) filter (where fingerprint ~ '^clst_[0-9A-F]{16}$') fp_ok,
       count(*) filter (where sync_state='flat_loaded') flagged
from seo_topic_cluster_master
where cluster_slug in ('dental-implant-core','implant-systems-brands','all-on-x-full-arch',
 'patient-conditions-tooth-loss','bone-regeneration-gbr','patient-conditions-bone',
 'smile-design-cosmetic','gum-soft-tissue','periodontics-perio-disease','clear-aligner-orthodontics',
 'general-restorative','digital-technology-diagnostics','implant-materials','dental-anatomy',
 'brand-doctor-authority','pediatric-dentistry','endodontics-specialist','dental-anesthesia',
 'demographic-dentistry','insurance-coverage-th');
```
Expected: `total=20`, `fp_ok=20`, `flagged=20`, `with_parent≈8`. Append result to `LOAD-LOG.md` progress table. ✅ → next task.

---

## Task 2: Entities → `01_entities.sql` (MERGE)

**Files:**
- Create: `deployment/supabase-load/gen_entities.py`
- Generates: `deployment/supabase-load/01_entities.sql`
- Source: `content-plan/entities.md` (per-cluster sections `## {cluster-slug}: …`, each a 12-col table: `# | Entity Name | Slug | Type | Schema.org | Parent | ICD-10 | Lifecycle | Primary Page | Aliases | Brand Scope | Notes`)

- [ ] **Step 1: Pre-load diff (MCP) — how many already exist**

`execute_sql`:
```sql
-- run AFTER generator (Step 3) once we have the slug list; placeholder here to remember the check
select 'see Step 5 pre-check' as note;
```
(Real diff is in Step 5; it needs the generated slug list.)

- [ ] **Step 2: Write `gen_entities.py`**

```python
# deployment/supabase-load/gen_entities.py
import re
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
import collections
print("by type:", dict(collections.Counter(r["etype"] for r in uniq)))

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

# emit the slug list to a side file for the pre-load diff query
open(OUT + "/_entity_slugs.txt", "w", encoding="utf-8").write("\n".join(r["slug"] for r in uniq))
```

- [ ] **Step 3: Run the generator**

Run: `python3 gen_entities.py`
Expected: `entities parsed: … unique: 163` (or close; note actual), and a type breakdown roughly `treatment ~40, procedure ~49, condition ~27, product 9, concept 16, device 16, anatomy 6, organization 3, person 2/3`.

- [ ] **Step 4: Commit**

```bash
git add deployment/supabase-load/gen_entities.py deployment/supabase-load/01_entities.sql
git commit -m "feat(supabase-load): entities generator + 01_entities.sql (MERGE)"
```

- [ ] **Step 5: Pre-load diff via MCP (before operator runs the file)**

Build the slug `VALUES` list from `_entity_slugs.txt`, then `execute_sql`:
```sql
with ours(slug) as (values ('dental-implant'),(/* …all slugs from _entity_slugs.txt… */))
select count(*) total_ours,
       count(g.entity_fingerprint) already_exist,
       count(*) - count(g.entity_fingerprint) net_new
from ours left join seo_entity_graph g on g.entity_fingerprint = ours.slug;
```
Record `net_new` — that's the **expected insert count** for Step 6.

- [ ] **Step 6: Operator runs `01_entities.sql`; Claude validates via MCP**

Snapshot total before (from earlier: 722). After load:
```sql
select count(*) present_of_ours
from seo_entity_graph
where entity_fingerprint in (/* same VALUES list */);
-- expect = total_ours (all our slugs now present)
select count(*) filter (where 'smile-scape-clinic' = any(brand_scope)) ss_scoped,
       count(*) filter (where entity_type <> lower(entity_type)) bad_case
from seo_entity_graph
where entity_fingerprint in (/* VALUES list */);
-- bad_case must be 0
```
Also assert the global total rose by exactly `net_new` (e.g. 722 → 722+net_new) and no other brand lost rows. Append to LOAD-LOG. ✅

---

## Task 3: Entity extensions → `02_entity_extensions.sql`

**Files:**
- Create: `deployment/supabase-load/02_entity_extensions.sql` (static; no parser)

> Mirrors Deezy `05_entity_extensions.sql`. `INSERT..SELECT` by lowercase `entity_type`, idempotent. Covers condition/symptom/anatomy/procedures/drug. **Defers product + device** (consumer-enum mismatch, spec §4.2). ⚠️ This binds ALL lowercase-type entities of those types (shared `['*']` + SmileScape) — but ON CONFLICT makes it a no-op for rows already bound by the Deezy run, so it only adds ext rows for entities not yet bound.

- [ ] **Step 1: Write `02_entity_extensions.sql`**

```sql
-- 02_entity_extensions.sql — type-extension binding for lowercase-type entities.
-- entity_fp = entity_fingerprint = slug (FK -> seo_entity_graph.entity_fingerprint).
-- UNIQUE(entity_fp) per table -> idempotent. Defers product+device (enum mismatch). drug needs generic_name.
insert into public.seo_entity_condition (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='condition'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_symptom (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='symptom'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_anatomy (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='anatomy'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_procedures (entity_fp)
select entity_fingerprint from public.seo_entity_graph where entity_type='procedure'
on conflict (entity_fp) do nothing;

insert into public.seo_entity_drug (entity_fp, generic_name)
select entity_fingerprint, entity_name from public.seo_entity_graph where entity_type='drug'
on conflict (entity_fp) do nothing;

-- validation: ext rows that bind to a SmileScape-scoped entity
select 'condition' ext, count(*) n from public.seo_entity_condition c
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=c.entity_fp
               and g.entity_type='condition' and 'smile-scape-clinic'=any(g.brand_scope))
union all select 'procedures', count(*) from public.seo_entity_procedures p
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=p.entity_fp
               and g.entity_type='procedure' and 'smile-scape-clinic'=any(g.brand_scope))
union all select 'anatomy', count(*) from public.seo_entity_anatomy a
  where exists (select 1 from seo_entity_graph g where g.entity_fingerprint=a.entity_fp
               and g.entity_type='anatomy' and 'smile-scape-clinic'=any(g.brand_scope))
order by ext;
```

- [ ] **Step 2: Commit**

```bash
git add deployment/supabase-load/02_entity_extensions.sql
git commit -m "feat(supabase-load): entity extensions (cond/symptom/anatomy/proc/drug)"
```

- [ ] **Step 3: Operator runs `02_entity_extensions.sql`; Claude validates via MCP**

The closing `SELECT` returns per-table counts. Cross-check vs entities loaded: condition count should ≈ number of `condition`-type entities present that are SmileScape-scoped (many shared ['*'] conditions also bind, which is fine). Confirm no error (FK satisfied). Append to LOAD-LOG. ✅

---

## Task 4: Citations → `03_citations.sql` (MERGE / dedup)

**Files:**
- Create: `deployment/supabase-load/gen_citations.py`
- Generates: `deployment/supabase-load/03_citations.sql`
- Source: `content-plan/citation-pool-seed.md` (per `## Pillar N — …`, a `**Citations:**` table: `# | Tier | Authors | Source | Year | DOI/URL | Schema Evidence | Covers Claim(s)`)

> Citations are a shared `['*']` pool; `doi` + `pubmed_pmid` + `citation_slug` are globally UNIQUE and overlap Deezy's pool. Insert net-new only via `NOT EXISTS` on all three keys. `title` is synthesized (`{Authors}. {journal}. {year}`) since the seed has no explicit paper title; `citation_type` mapped from the "Schema Evidence" text; tier 5 → brand scope.

- [ ] **Step 1: Write `gen_citations.py`**

```python
# deployment/supabase-load/gen_citations.py
import re
from _lib import *

TYPE_MAP = [  # (regex on schema-evidence text, citation_type)
    (r"meta[- ]?analysis", "meta_analysis"), (r"systematic review", "systematic_review"),
    (r"\brct\b|randomi", "rct"), (r"cohort", "cohort_study"), (r"case[- ]control", "case_control"),
    (r"cross[- ]sectional", "cross_sectional"), (r"case series", "case_series"),
    (r"case report", "case_report"), (r"guideline", "clinical_guideline"),
    (r"textbook|book", "textbook"), (r"consensus|expert", "expert_opinion"),
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
    if c[0] in ("#",) or not re.match(r"^\d+$", c[0]): continue
    num, tier, authors, source, year, dois, ev = c[0], c[1], c[2], c[3], c[4], c[5], c[6]
    doi = DOI_RX.search(dois); doi = doi.group(1) if doi else None
    pm = PMID_RX.search(dois); pmid = (pm.group(1) or pm.group(2)) if pm else None
    journal = re.sub(r"\s*\(.*?\)\s*$", "", source).strip()      # strip "(vol:pages)"
    yr = re.search(r"\d{4}", year or ""); yr = yr.group(0) if yr else None
    tiern = re.search(r"\d", tier or ""); tiern = tiern.group(0) if tiern else "2"
    title = f"{authors}. {journal}. {yr or ''}".strip().rstrip(".") + "."
    scope = "['smile-scape-clinic']" if tiern == "5" else "['*']"
    rows.append(dict(slug=f"p{pillar}-c{num}", title=title, authors=authors, year=yr,
                     pmid=pmid, doi=doi, journal=journal, tier=tiern, ctype=ctype(ev), scope=scope))

# de-dupe within file on doi/pmid/slug
seen_doi=set(); seen_pmid=set(); seen_slug=set(); uniq=[]
for r in rows:
    if r["slug"] in seen_slug: continue
    if r["doi"] and r["doi"] in seen_doi: continue
    if r["pmid"] and r["pmid"] in seen_pmid: continue
    seen_slug.add(r["slug"]); 
    if r["doi"]: seen_doi.add(r["doi"])
    if r["pmid"]: seen_pmid.add(r["pmid"])
    uniq.append(r)
print("citations parsed:", len(rows), "unique:", len(uniq))

def row_select(r):
    return ("select " + ",".join([
        q(r["slug"]), q(r["title"]), q(r["authors"]),
        (r["year"] or "NULL"), q(r["pmid"]), q(r["doi"]),
        q(r["journal"]), r["tier"], q(r["ctype"]), norm_scope(r["scope"])
    ]) + " where not exists (select 1 from public.seo_citations x where "
        + "x.citation_slug=" + q(r["slug"])
        + (" or x.doi=" + q(r["doi"]) if r["doi"] else "")
        + (" or x.pubmed_pmid=" + q(r["pmid"]) if r["pmid"] else "")
        + ")")

body = "\nunion all\n".join(row_select(r) for r in uniq)
sql = ("-- 03_citations.sql — seo_citations (SmileScape). MERGE: insert net-new only\n"
       "-- (skip rows whose citation_slug/doi/pubmed_pmid already exist — shared ['*'] pool).\n"
       "-- title synthesized from authors+journal+year (seed has no explicit title). tier5 -> brand scope.\n"
       "insert into public.seo_citations\n"
       "  (citation_slug, title, authors, publication_year, pubmed_pmid, doi,\n"
       "   journal_name, citation_tier, citation_type, brand_scope)\n"
       + body + "\n;\n\n"
       "-- validation\n"
       "select count(*) ours_present from public.seo_citations\n"
       "where citation_slug like 'p%-c%';\n")
open(OUT + "/03_citations.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 03_citations.sql")
```

- [ ] **Step 2: Run the generator**

Run: `python3 gen_citations.py`
Expected: `citations parsed: N unique: M` (M ≤ N). Spot-check: `grep -c "^select " 03_citations.sql` ≈ M.

- [ ] **Step 3: Eyeball**

`grep -n "not exists" 03_citations.sql | head` — every row guarded. `grep -c "10\." 03_citations.sql` — DOIs extracted.

- [ ] **Step 4: Commit**

```bash
git add deployment/supabase-load/gen_citations.py deployment/supabase-load/03_citations.sql
git commit -m "feat(supabase-load): citations generator + 03_citations.sql (dedup)"
```

- [ ] **Step 5: Operator runs `03_citations.sql`; Claude validates via MCP**

```sql
select count(*) ours_present,
       count(*) filter (where fingerprint ~ '^cite_[0-9A-F]{16}$') fp_ok,
       count(*) filter (where citation_tier between 1 and 6) tier_ok
from seo_citations where citation_slug like 'p%-c%';
```
Expected: `ours_present` = the count present (net-new inserted + any pre-existing p#-c# = should equal M minus those skipped only by doi/pmid under a *different* slug — note in LOAD-LOG). `fp_ok = ours_present`, `tier_ok = ours_present`. Confirm global `seo_citations` rose by exactly the inserted count. ✅

---

## Task 5: Authors → `04_authors.sql` (both doctors)

**Files:**
- Create: `deployment/supabase-load/04_authors.sql` (static; hand-written)
- Sources: `docs/team/dr-worapat-jarangkul.md` (หมอแฮม), `docs/team/dr-pitchapa-phudphong.md` (หมอแพรว), `content-plan/entities.md` person rows.

- [ ] **Step 1: Read both team files to fill the author fields**

Run: read `docs/team/dr-worapat-jarangkul.md` and `docs/team/dr-pitchapa-phudphong.md`. Extract: full_name (TH), en name, nickname, credential_types, license no/country, primary_specialty, short_bio, bio, languages. Decide the **canonical author slug** (reconcile `dr-woraphat-jarangkul` vs `dr-worapat-jarangkul`) and record it in LOAD-LOG. Roles: หมอแฮม = `medical_director` (is_primary true); หมอแพรว = `author` (is_primary false) unless the file states a directorial role.

- [ ] **Step 2: Write `04_authors.sql`** (template — fill bracketed values from Step 1; no brackets may remain)

```sql
-- 04_authors.sql — seo_authors_reviewers (2) + seo_doctor_assignments. brand_id = SmileScape brands.id.
-- Exclude dr-tomas-linkevicius (external authority -> graph entity only). fingerprint/display auto.
with a1 as (
  insert into public.seo_authors_reviewers
    (full_name, canonical_names, credential_types, medical_license_number, medical_license_country,
     brand_scope, primary_specialty, languages_spoken, short_bio, bio)
  values
    ('<หมอแฮม full TH name>',
     '{"th":"<th>","en":"<en>","nickname_th":"หมอแฮม","nickname_en":"Dr. Ham"}'::jsonb,
     array['<DDS/…>']::text[], '<license or NULL>', 'TH',
     array['smile-scape-clinic']::text[], '<Implantology/…>', array['th','en']::text[],
     '<short bio>', '<bio>')
  returning id
)
insert into public.seo_doctor_assignments
  (author_id, brand_id, branch_id, role_at_brand, is_primary_role, sync_state)
select id, 'c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid, NULL, 'medical_director', true, 'flat_loaded' from a1;

with a2 as (
  insert into public.seo_authors_reviewers
    (full_name, canonical_names, credential_types, medical_license_number, medical_license_country,
     brand_scope, primary_specialty, languages_spoken, short_bio, bio)
  values
    ('<หมอแพรว full TH name>',
     '{"th":"<th>","en":"<en>","nickname_th":"หมอแพรว","nickname_en":"Dr. Praew"}'::jsonb,
     array['<DDS/…>']::text[], '<license or NULL>', 'TH',
     array['smile-scape-clinic']::text[], '<specialty or NULL>', array['th','en']::text[],
     '<short bio>', '<bio>')
  returning id
)
insert into public.seo_doctor_assignments
  (author_id, brand_id, branch_id, role_at_brand, is_primary_role, sync_state)
select id, 'c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid, NULL, 'author', false, 'flat_loaded' from a2;

-- validation
select r.full_name, r.fingerprint, d.role_at_brand, d.is_primary_role
from seo_authors_reviewers r join seo_doctor_assignments d on d.author_id=r.id
where 'smile-scape-clinic' = any(r.brand_scope) order by d.is_primary_role desc;
```

- [ ] **Step 3: Commit**

```bash
git add deployment/supabase-load/04_authors.sql
git commit -m "feat(supabase-load): authors + doctor assignments (Ham + Praew)"
```

- [ ] **Step 4: Operator runs `04_authors.sql`; Claude validates via MCP**

The closing `SELECT` returns 2 rows (both doctors) with `auth_`/`docasg_` fingerprints and roles. Confirm 2 author rows + 2 assignment rows for brand_id `c93a5e7b…`. Append to LOAD-LOG. ✅

---

## Task 6: Branches → `05_branches.sql` (partial)

**Files:**
- Create: `deployment/supabase-load/05_branches.sql` (static; 2 rows; geo/phone/address NULL → operator UPDATE later)

> All address/geo columns are nullable (verified). `organization_entity_id` → set from the org entities after they load (Task 2). `brand_id` is uuid here.

- [ ] **Step 1: Write `05_branches.sql`**

```sql
-- 05_branches.sql — seo_branches (SmileScape, 2, PARTIAL). brand_id=uuid. branch_fingerprint=slug.
-- street/full/lat/lng/postal/phone/email/line/license = NULL -> operator batch UPDATE later (DR-025).
-- organization_entity_id resolved from the Organization entities loaded in 01.
insert into public.seo_branches
  (branch_fingerprint, brand_id, brand_slug, branch_name, branch_slug, business_name_brand,
   is_primary, city, region, country_code, website_url, status, local_business_schema_type)
values
  ('smilescape-rattanathibet','c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid,'smile-scape-clinic',
   'SmileScape สาขารัตนาธิเบศร์','smilescape-rattanathibet','SmileScape สาขารัตนาธิเบศร์',
   true,'นนทบุรี','นนทบุรี','TH','https://smilescapeclinic.com/รัตนาธิเบศร์','active','DentalClinic'),
  ('smilescape-srinakarin','c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid,'smile-scape-clinic',
   'SmileScape สาขาศรีนครินทร์','smilescape-srinakarin','SmileScape สาขาศรีนครินทร์',
   false,'กรุงเทพมหานคร','กรุงเทพมหานคร','TH','https://smilescapeclinic.com/ศรีนครินทร์','active','DentalClinic')
on conflict (branch_fingerprint) do nothing;

-- link organization entity (if present in graph)
update public.seo_branches b set organization_entity_id = g.id
from public.seo_entity_graph g
where b.brand_slug='smile-scape-clinic' and g.entity_fingerprint = b.branch_fingerprint;

-- validation
select branch_slug, fingerprint, is_primary, city, organization_entity_id is not null org_linked
from seo_branches where brand_id='c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid order by is_primary desc;
```

- [ ] **Step 2: Commit**

```bash
git add deployment/supabase-load/05_branches.sql
git commit -m "feat(supabase-load): branches (2, partial) + org-entity link"
```

- [ ] **Step 3: Operator runs `05_branches.sql`; Claude validates via MCP**

Expected: 2 rows, `brch_` fingerprints, `is_primary` one true/one false. `org_linked` may be false if the org entity slugs differ from branch slugs — if so, note in LOAD-LOG (org-link deferred). ✅

---

## Task 7: Pages → `06_pages.sql` (stub)

**Files:**
- Create: `deployment/supabase-load/gen_pages.py`
- Generates: `deployment/supabase-load/06_pages.sql`
- Source: `content-plan/sitemap.md` (per-section 7-col tables: `# | Page Name | Layer | Tier | Funnel | Page Type | Primary Entity`)

> Ported from Deezy `gen_pages.py`. Keep only pure dotted-node rows; `page_fingerprint='smilescape-{node}'`; minimal stub; authoritative `cluster_id` from a post-insert UPDATE joining `primary_entity_fp` → entity `topic_cluster_id`.

- [ ] **Step 1: Write `gen_pages.py`**

```python
# deployment/supabase-load/gen_pages.py
import re, collections
from _lib import *

NODE = re.compile(r"^\d+(\.\d+)*$")
def clean(name):
    n = re.sub(r"^(\s*→\s*)+", "", name)
    n = n.replace("🌟", "").replace("⭐", "").replace("★", "").replace("🏆", "").replace("🔒", "")
    return re.sub(r"\s+", " ", n).strip()

rows = []; skipped = []
for ln in open(SRC + "/sitemap.md", encoding="utf-8"):
    if not ln.lstrip().startswith("|"): continue
    c = cells(ln)
    if not c: continue
    node = c[0]
    if node in ("#",) or is_sep(c): continue
    if not NODE.match(node): skipped.append(node); continue
    if len(c) < 7: skipped.append(node + "(<7)"); continue
    name = clean(c[1]); entity = c[6]
    rows.append(dict(node=node, name=name, entity=entity if entity not in DASH else None))

dupe = [n for n, k in collections.Counter(r["node"] for r in rows).items() if k > 1]
print("pages parsed:", len(rows), "| dupes:", dupe[:10], "| skipped non-node:", len(skipped))

vals = []
for r in rows:
    vals.append("(" + ",".join([
        q("smilescape-" + r["node"]),  # page_fingerprint
        q(r["name"]),                  # page_name
        q(r["node"]),                  # sitemap_node_id
        q(r["entity"]),                # primary_entity_fp (slug / NULL)
        "'Planned'",                   # status
        "'smile-scape-clinic'",        # brand_id (text)
        "'Smile Scape Clinic'",        # brand_name
    ]) + ")")

sql = ("-- 06_pages.sql — seo_website_page_master (SmileScape, MINIMAL STUB) — " + str(len(rows)) + " pages.\n"
       "-- page_fingerprint='smilescape-{node}'. URLs/CPT/T-template/parent deferred (need keyword research).\n"
       "-- fingerprint/display auto by trigger. cluster_id set authoritatively from entity below.\n"
       "insert into public.seo_website_page_master\n"
       "  (page_fingerprint, page_name, sitemap_node_id, primary_entity_fp, status, brand_id, brand_name)\n"
       "values\n" + ",\n".join(vals) + "\non conflict (page_fingerprint) do nothing;\n\n"
       "-- authoritative cluster: page inherits its primary entity's topic_cluster_id\n"
       "update public.seo_website_page_master p set cluster_id = g.topic_cluster_id\n"
       "  from public.seo_entity_graph g\n"
       "  where p.brand_id='smile-scape-clinic' and p.primary_entity_fp is not null\n"
       "    and g.entity_fingerprint = p.primary_entity_fp;\n\n"
       "-- validation\n"
       "select count(*) total, count(primary_entity_fp) with_entity, count(cluster_id) with_cluster\n"
       "from public.seo_website_page_master where brand_id='smile-scape-clinic';\n")
open(OUT + "/06_pages.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 06_pages.sql")
```

- [ ] **Step 2: Run the generator**

Run: `python3 gen_pages.py`
Expected: `pages parsed: ~726 | dupes: [] | skipped non-node: …`. If `dupes` is non-empty, investigate the sitemap (duplicate node ids) before loading — append finding to LOAD-LOG.

- [ ] **Step 3: Eyeball**

`grep -c "^(" 06_pages.sql` ≈ 726. `grep -n "'smile-scape'" 06_pages.sql` → no matches (brand_id is `smile-scape-clinic`).

- [ ] **Step 4: Commit**

```bash
git add deployment/supabase-load/gen_pages.py deployment/supabase-load/06_pages.sql
git commit -m "feat(supabase-load): pages generator + 06_pages.sql (~726 stub)"
```

- [ ] **Step 5: Operator runs `06_pages.sql`; Claude validates via MCP**

```sql
select count(*) total,
       count(primary_entity_fp) with_entity,
       count(cluster_id) with_cluster,
       count(*) filter (where fingerprint ~ '^pg_[0-9A-F]{16}$') fp_ok,
       count(*) filter (where primary_entity_fp is not null
                        and not exists (select 1 from seo_entity_graph g
                                        where g.entity_fingerprint=p.primary_entity_fp)) orphan_entity
from seo_website_page_master p where brand_id='smile-scape-clinic';
```
Expected: `total≈726`, `fp_ok=total`, `orphan_entity=0` (every referenced entity exists — they were loaded in Task 2). Note `with_cluster`. ✅

---

## Task 8: Keywords → `10_keywords.sql` (seed → DFS)

**Files:**
- Create: `deployment/supabase-load/gen_keywords.py`
- Generates: `deployment/supabase-load/10_keywords.sql`
- Source: `content-plan/keyword-seed-list.md` (keywords inside ```` ``` ```` code fences, grouped by cluster)

> Ported from Deezy `gen_keywords.py` but reads markdown code-fences (Deezy used a CSV). fingerprint = `'{brand_lower}::{loc}::{lang}::{kw}'` with loc/lang pulled byte-exact from an existing TH row (so the async DFS run UPDATEs these). `brand='Smile Scape Clinic'`. ON CONFLICT (fingerprint PK).

- [ ] **Step 1: Write `gen_keywords.py`**

```python
# deployment/supabase-load/gen_keywords.py
from _lib import *

kws = []; seen = set(); infence = False
for ln in open(SRC + "/keyword-seed-list.md", encoding="utf-8"):
    s = ln.rstrip("\n")
    if s.lstrip().startswith("```"):
        infence = not infence; continue
    if not infence: continue
    k = s.strip()
    if not k or k.startswith("#") or k.startswith("|"): continue
    k = k.split("  ")[0].strip()           # drop trailing intent tags if any
    if k in seen: continue
    seen.add(k); kws.append(k)
print("unique keywords:", len(kws))

vals = ",\n".join("  (" + q(k) + ")" for k in kws)
sql = ("-- 10_keywords.sql — seed SmileScape keyword LIST into seo_x_ads_keywords_contextual_master.\n"
       "-- Load keyword + brand only; DFS full run enriches metrics/SERP/intent afterward.\n"
       "-- fingerprint = '{brand_lower}::{loc}::{lang}::{kw}'; loc/lang pulled byte-exact from a TH row\n"
       "--   so DFS (same fingerprint) UPDATEs these seeded rows. brand='Smile Scape Clinic'.\n"
       "-- Source: content-plan/keyword-seed-list.md (" + str(len(kws)) + " unique).\n"
       "insert into public.seo_x_ads_keywords_contextual_master (fingerprint, keyword, brand)\n"
       "select 'smile scape clinic::'||loc.l||'::'||loc.g||'::'||k.kw, k.kw, 'Smile Scape Clinic'\n"
       "from (values\n" + vals + "\n) as k(kw)\n"
       "cross join (\n"
       "  select split_part(fingerprint,'::',2) l, split_part(fingerprint,'::',3) g\n"
       "  from public.seo_x_ads_keywords_contextual_master\n"
       "  where brand='TC Smile Dental' and fingerprint like '%::%::%::%'\n"
       "  limit 1\n) loc\n"
       "on conflict (fingerprint) do nothing;\n\n"
       "-- validation\n"
       "select count(*) ss_keywords,\n"
       "       count(*) filter (where fingerprint like 'smile scape clinic::%') fp_ok\n"
       "from public.seo_x_ads_keywords_contextual_master where brand='Smile Scape Clinic';\n")
open(OUT + "/10_keywords.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 10_keywords.sql")
```

- [ ] **Step 2: Run the generator**

Run: `python3 gen_keywords.py`
Expected: `unique keywords: ~680`. (The doc claims ~680; record the actual.)

- [ ] **Step 3: Pre-check the `loc` source exists (MCP)**

```sql
select split_part(fingerprint,'::',2) l, split_part(fingerprint,'::',3) g
from seo_x_ads_keywords_contextual_master
where brand='TC Smile Dental' and fingerprint like '%::%::%::%' limit 1;
```
Expected: 1 row (the TH locale/lang strings). If empty, pick another existing brand with `::` fingerprints and update the generator's `where brand=` filter; note in LOAD-LOG.

- [ ] **Step 4: Commit**

```bash
git add deployment/supabase-load/gen_keywords.py deployment/supabase-load/10_keywords.sql
git commit -m "feat(supabase-load): keywords generator + 10_keywords.sql (seed)"
```

- [ ] **Step 5: Operator runs `10_keywords.sql`; Claude validates via MCP**

The closing `SELECT` returns `ss_keywords` (= unique loaded) and `fp_ok` (= same). Confirm equal and that the global keyword count rose by that amount. Note "→ hand off to DataForSEO full run". ✅

---

## Task 9: Final validation, advisors, wrap-up

**Files:**
- Modify: `deployment/supabase-load/RUN-ORDER.md` (statuses → ✅), `deployment/supabase-load/LOAD-LOG.md` (final summary)

- [ ] **Step 1: Whole-load summary via MCP**

```sql
select 'clusters'  t, count(*) n from seo_topic_cluster_master where 'smile-scape-clinic'=any(brand_scope) or brand_scope_primary='*'
union all select 'pages', count(*) from seo_website_page_master where brand_id='smile-scape-clinic'
union all select 'branches', count(*) from seo_branches where brand_id='c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25'::uuid
union all select 'authors', count(*) from seo_authors_reviewers where 'smile-scape-clinic'=any(brand_scope)
union all select 'keywords', count(*) from seo_x_ads_keywords_contextual_master where brand='Smile Scape Clinic'
union all select 'ss-scoped entities', count(*) from seo_entity_graph where 'smile-scape-clinic'=any(brand_scope);
```

- [ ] **Step 2: Brand-isolation final check via MCP**

```sql
-- other brands' page counts unchanged vs session start (Deezy 689-ish, VitalSleep present)
select brand_name, count(*) from seo_website_page_master
where brand_name is not null and brand_id <> 'smile-scape-clinic' group by brand_name order by 1;
```
Confirm Deezy/VitalSleep counts match the pre-load snapshot (no collateral change).

- [ ] **Step 3: Run Supabase advisors (security)**

Use MCP `get_advisors(project_id="lffcbeszjqzioobqfdav", type="security")`. Report any new findings (expect none — no DDL). Include remediation links if any.

- [ ] **Step 4: Finalize docs + commit**

Update `RUN-ORDER.md` statuses to ✅ and `LOAD-LOG.md` with final counts + any flags (org-link, type-mismatch, dupes).
```bash
git add deployment/supabase-load/RUN-ORDER.md deployment/supabase-load/LOAD-LOG.md
git commit -m "docs(supabase-load): finalize RUN-ORDER + LOAD-LOG (load complete)"
```

---

## Self-Review

**Spec coverage:** clusters (T1), entities+MERGE (T2), entity-ext defer product/device (T3), citations+dedup (T4), both authors excl. Linkevicius (T5), partial branches (T6), page stub (T7), keyword seed (T8), validation+isolation+advisors (T9). Deferrals listed in RUN-ORDER. All spec §4.1 in-scope tables have a task. ✅

**Placeholder scan:** The only bracketed placeholders are in `04_authors.sql` (Task 5) — intentionally filled from the team files in Task 5 Step 1 before the file is committed; Step 1 explicitly requires no brackets remain. The entity/citation slug `VALUES` lists in the MCP diff queries are generated artifacts (`_entity_slugs.txt`), not authoring placeholders. No "TBD/handle errors/similar to" placeholders elsewhere.

**Type consistency:** `entity_fingerprint`=`entity_slug`=slug throughout; `brand_id` is **uuid** on `seo_branches`/`seo_doctor_assignments` but **text** (`smile-scape-clinic`) on `seo_website_page_master` (matches live schema, called out in spec §5). `page_fingerprint`/keyword `fingerprint` brand-prefixed (no cross-brand collision). ON CONFLICT targets all verified unique constraints (cluster_slug, citation_slug, branch_fingerprint, page_fingerprint, keyword fingerprint PK, entity_fingerprint).

**Known soft spots flagged for execution (not blockers):** citation `title` synthesis + `citation_type` mapping (Task 4 — parser run + eyeball), author slug reconciliation (Task 5), org-entity link may no-op (Task 6), sitemap dupes guard (Task 7), keyword `loc` source brand availability (Task 8 Step 3).
