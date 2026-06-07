# Content Template System — Design Spec (deliverable 2)

> **Created:** 2026-06-08 · **Branch:** `web-skeleton` · **Astro app:** `web/`
> **Status:** approved in brainstorm; pending user review before plan.
> **Prereq:** Homepage MVP shipped (first EYWA Astro component library). This spec builds the per-content-type **page-template system** on top of that library.
> **Inputs:** `docs/HANDOVER-content-templates.md`, `memory/homepage-component-library.md`, `repos/eywa-protocol-spec/Content_Templates_EYWA_v1_0.md` (T1–T22 LOCKED, B## block system), `docs/master-example-peri-implantitis.html` (T1 master), `legacy/Sitemap Deezy/SmileScape/prototype-all-on-4-v2.html` (T5 reference prototype — internal-link-first layout), `content-plan/{entities,relationships,clusters}.md` (the internal-link graph), `web/src/content/config.ts` (existing `home` pattern).

---

## 1. Goal

Build **reusable, trilingual Astro page templates — one per EYWA content type** — so the ~726-page sitemap can be produced consistently. Each template composes blocks from the existing homepage component library, emits the correct schema.org `@graph`, weaves **internal links from the entity/relationship graph** (DR-021/DR-022), and renders TH `/`, EN `/en/`, zh-CN `/zh-cn/` from per-locale structured content.

This deliverable locks the architecture by building the two hardest reference templates end-to-end **at full prototype parity**, plus a permanent preview harness, a centralized internal-link engine with graceful fallback, and a mapping artifact.

## 2. Scope (locked in brainstorm)

**In scope — five deliverables:**
1. **Template-system architecture** — collections, registry, dispatcher routing, PageShell/reading layout, schema `@graph`, loaders, i18n (Approach A).
2. **T5 — Service** reference template at **full parity** with the All-on-4 prototype (sitemap Section 3, `Service`/`MedicalProcedure`).
3. **T1 — Concern** reference template (sitemap Section 5, `MedicalCondition`/`MedicalWebPage`), same shell + link patterns.
4. **Internal-Link Engine + Preview Harness** — centralized link resolver over the entity/relationship graph with 4-state fallback + backfill (§5), and a noindex live 1:1 preview paired with every template (§6).
5. **Page-Type → T# mapping proposal** doc for operator review (§7).

**Out of scope (later specs / other sessions):**
- knowledge (T6), faq-page, glossary (T6/DefinedTerm) templates — next slice, inherit this pattern.
- Remaining templates T2/T2a–e, T3, T4, T7–T19, T-ADS-x.
- **Full** entity-registry population (all 163 entities) + real content authoring (Phase F); this slice **seeds ~15–20 entities** the two demos reference. DataForSEO keyword research, real images (Session A swaps `Image.astro` src), apex cutover, Supabase hydration wiring (Session B — schema is the seam).

## 3. Locked decisions

| # | Decision | Choice |
|---|---|---|
| D1 | First-pass scope | Architecture + T5 + T1 + link engine + preview harness + Page-Type→T# mapping |
| D2 | Content authoring model | **Fully structured data** — every B## block is a typed field; collections are `type:'data'` (extends `home`) |
| D3 | Dispatch architecture | **Approach A** — one collection per template + per-locale catch-all dispatcher reading a shared registry |
| D4 | Trilingual storage | Per-locale subfolders `content/<template>/{th,en,zh-cn}/<slug>.yaml` |
| D5 | Preview harness | Default + permanent; every template ships a kitchen-sink demo fixture (3 locales) + gallery registration |
| D6 | New prose blocks | Minimize: one generic `ProseBlock` (`variant: prose\|checklist`) covers definition/symptoms/diagnosis/whoFor; visually-distinct blocks keep dedicated components |
| D7 | `pages` collection | Remove the unused generic `pages` collection; keep `articles` reserved for T6 (next slice) |
| D8 | FAQ in `@graph` | `FaqBlock` keeps emitting its own FAQPage JSON-LD; single-`@graph` consolidation is a non-blocking follow-up |
| D9 | **Prototype parity** | Build T5 to **full parity** with the All-on-4 prototype (PageShell + sticky sidebar + ToC, tabbed RelatedCluster, expertise box, tech badges, multi-CTA, breadcrumb) |
| D10 | **Internal-link mechanism** | **Entity-token** `[label](entity:slug)` resolved at build by a single engine (chosen because it's the only option that enables centralized existence-checking → clean fallback) |
| D11 | **Link fallback** | Resolver is the single chokepoint; 4-state resolution + per-surface graceful degradation + graph backfill (§5) — never ship a dead link or a near-empty link box |

## 4. Architecture (Approach A)

```
registry (lib/templates.ts) ──reads──► catch-all dispatcher (pages/[...slug].astro ×3 locales)
        │                                       │  slug → entry → template key
        ▼                                       ▼
content collections (type:'data')        template layouts (layouts/templates/*.astro)
  service/{th,en,zh-cn}/*.yaml   ──────►   Service.astro ─┐ compose blocks + PageShell
  concern/{th,en,zh-cn}/*.yaml   ──────►   Concern.astro ─┤ + jsonLd @graph + resolved links
                                                          └─► wrap in Base.astro
link engine (lib/links.ts) ◄── entity registry (content/_entities.yaml) + relationship edges
        ▲ resolveLink(slug, locale, surface) → {state, href?, label} + backfill + DR-021 audit
preview gallery (pages/preview/) + preview routes ──reads registry + demo.yaml fixtures──► same layouts, noindex
```

**Why A:** literal generalization of the proven homepage pattern. Adding a template = one registry row + one schema + one layout + one demo fixture. Scales to 726 pages without per-page route files; each template's schema stays readable and independently testable.

### 4.1 Content collections & schema (`web/src/content/config.ts` + `_shared.ts`)

Collection-per-template, **`type:'data'`**. Extract a shared base.

**`content/_shared.ts`** — exported helpers reused across templates:
- `imageRef` `{ src?, alt, label? }` (DR-035 placeholder→Cloudflare seam) · `cta` `{ label, href? , linkTo? }` (href OR `linkTo` entity slug) · `faqItem` `{ q, a }`
- `relatedItem` `{ linkTo (entity slug) | href, title?, summary?, image? }` (DR-021; resolved via link engine)
- `referenceItem` `{ label, url? }` (B21) · `reviewItem` `{ quote, name, stars }` · `beforeAfterItem` `{ before, after, caption }`
- `proseBlock` `{ heading?, eyebrow?, lead?, paragraphs[], bullets?[], subsections?: [{ heading, body }], variant?: 'prose'|'checklist' }` — paragraphs/bullets are **rich strings** that may contain entity-token links `[label](entity:slug)` (§5.7)
- `schemaTypeEnum` (extend existing: add `MedicalCondition`, `MedicalWebPage`, `CollectionPage`, `DefinedTerm`, `DefinedTermSet`)
- `templateKey` enum: `['service','concern']` (grows per slice)
- **`baseFields`** spread into each template schema:
  ```
  meta:        { title, description }
  template:    templateKey
  breadcrumb?: [{ linkTo|href, label }]          // visible Breadcrumb UI + BreadcrumbList schema (B-nav)
  hero:        { eyebrow?, badge?, title, body, image, primaryCta: cta, secondaryCta? }   // B01 + CTA#1
  quickFacts?: { variant: 'stats'|'essentials', items:[...] }   // B02 (stat-band OR 5-essentials+toggle)
  toc?:        boolean (default true)            // render sticky sidebar ToC (scrollspy)
  sidebarRelated?: [relatedItem]                 // sidebar "บริการที่เกี่ยวข้อง" (backfilled if sparse)
  sidebarCta?: { title, body, cta }              // sidebar mini-CTA
  midCta?:     { title, body, cta }              // CTA#2 strategic, mid-content
  expertise?:  { heading, quote?, body?, trustItems:[{ title, body }] }   // B10/B19 expertise box
  reviewer?:   { name, credentials[], reviewedDate }            // B19 → schema reviewedBy/lastReviewed
  references:  [referenceItem] (default [])      // B21
  faq:         [faqItem] (default [])            // B18
  relatedCluster?: { tabs:[{ key, label, edge?, items:[relatedItem] }] }  // tabbed end cluster (§5)
  finalCta?:   { title, body, cta }              // B20 / CTA#3
  schemaType:  schemaTypeEnum
  canonical?:  string
  published:   boolean = false
  updatedAt?:  date
  ```

**`concern` collection (T1)** = `baseFields` + : `definition: proseBlock` (B04) · `causes: { heading, groups:[{ category, factors:[{ name, mechanism, citation? }] }] }` (B05) · `symptoms: proseBlock` (B06) · `diagnosis: proseBlock` (B07) · `treatment: { heading, options:[{ name, body }] }` (B08) · `clinicalInsight?: { quote, by }` (B12) · `reviews?: [reviewItem]` · `beforeAfter?: [beforeAfterItem]` (B16).

**`service` collection (T5)** = `baseFields` + : `whoFor: proseBlock | { heading, cards:[{ icon, title, body, linkTo? }] }` (B27, concern-card variant per prototype) · `process: [{ step, title, body, image? }]` (B13) · `techBadges?: [{ linkTo (entity slug), label? }]` (uses-edge cluster) · `pricing: { note?, oldPrice?, tiers:[{ name, price, period?, includes[], highlight? }] }` (B17) · `comparison?: { heading, columns[], rows:[{ label, cells[] }] }` (B09) · `beforeAfter?: [beforeAfterItem]`.

`articles` (T6) stays defined `type:'data'` reserved. The generic `pages` collection is **removed**.

### 4.2 URL slug rule

The entry's path under its locale folder **is** the URL slug. `content/concern/th/peri-implantitis.yaml` → `/peri-implantitis/`. Hierarchical URLs nest the file (`service/th/services/dental-implant.yaml` → `/services/dental-implant/`). `canonical` may override. No separate `slug` field.

### 4.3 Blocks: reuse vs build new

**Reuse as-is:** `Hero`, `ProcessSteps`, `BeforeAfter`, `Reviews`, `FaqBlock` (Tier-3 FAQPage), `Section`, `SectionHeading` (extend with `eyebrow`), `Button`, `Image`, `StickyCta` (mobile sticky bar via Base).

**Design note (collapse trade-off):** collapsing prose blocks affects *rendering only* — each block stays a distinct typed field, so schema emission and per-locale authoring are unaffected. Only genuinely-prose blocks collapse into `ProseBlock`; visually-distinct blocks keep dedicated components. Extracting a bespoke component later is cheap and local (no schema/content migration).

**Build new** (`brand-*` tokens only):
| Component | Block / role | Used by |
|---|---|---|
| `ProseBlock.astro` (`variant: prose\|checklist`; renders entity-token inline links) | B04/B06/B07/B27/B28 | both |
| `QuickFacts.astro` (`variant: stats` band \| `essentials` 5-row + `<details>` toggle, DR-033 code order) | B02 | both |
| `RiskFactors.astro` (grouped factors + mechanism + citation) | B05 | concern |
| `TreatmentOptions.astro` (named options) | B08 | concern |
| `PricingTable.astro` (tiers grid, old/new price) | B17 | service |
| `ExpertiseBox.astro` (quote + trust-item grid, on-dark) | B10/B19 | both |
| `TechBadges.astro` (linked badge row → technology/brand pages) | uses-edge | service |
| `DoctorReview.astro` (reviewer name/credentials/date) | B19 | both |
| `ReferencesBlock.astro` (numbered citations) | B21 | both |
| `Breadcrumb.astro` (resolved trail + BreadcrumbList) | B-nav | both |
| `CtaInline.astro` (strategic mid-content CTA) | CTA#2 | both |
| `RelatedCluster.astro` (tabbed end cluster; tabs by edge type; cards) | DR-021 | both |
| **`PageShell.astro`** (two-column reading layout + sticky sidebar host) | layout | both (§4.8) |
| **`Sidebar.astro`** (ToC scrollspy + compact related + mini-CTA) | layout/nav | both (§4.8) |

### 4.4 Template layouts (`web/src/layouts/templates/`)

Receive resolved `{ data, locale }`, compose blocks in EYWA order, render only blocks whose data is present, wrap body in `PageShell` (main + sidebar), wrap page in `Base`, pass `jsonLd` from `lib/schema.ts`. Inline links + all link surfaces pre-resolved through `lib/links.ts` (§5).

- **`Service.astro`** (T5, prototype parity): Breadcrumb → Hero(CTA#1) → QuickFacts(stats) → **PageShell**[ main: Definition(inline links) → Process → WhoFor(concern cards) → TechBadges → ExpertiseBox → CtaInline(CTA#2) → Pricing → Comparison? → FaqBlock ; sidebar: ToC + sidebarRelated + sidebarCta ] → RelatedCluster(tabs) → FinalCta(CTA#3). Schema: `Service` + `MedicalProcedure`.
- **`Concern.astro`** (T1): Breadcrumb → Hero → QuickFacts(essentials) → **PageShell**[ main: Definition → Causes → Symptoms → Diagnosis → Treatment → ClinicalInsight? → BeforeAfter? → Reviews? → FaqBlock → DoctorReview → ReferencesBlock ; sidebar: ToC + sidebarRelated + sidebarCta ] → RelatedCluster(tabs) → FinalCta. Schema: `MedicalCondition` + `MedicalWebPage`.

T1/T5 required blocks per the EYWA spec are honored; `B09` optional in both.

### 4.5 Registry (`web/src/lib/templates.ts`)

Single source of truth, read by dispatcher **and** preview gallery:
```
export const TEMPLATES = [
  { code:'T1', key:'concern', name:'Medical Condition', schemaType:'MedicalCondition', component: Concern, demoSlug:'demo' },
  { code:'T5', key:'service', name:'Service / Money Page', schemaType:'Service',         component: Service, demoSlug:'demo' },
] as const
```
Adding a template later = append one row.

### 4.6 Loaders (`web/src/lib/pages.ts`)

Mirror `getHome()`: `getPageEntries(locale)` (gather all template collections, **exclude** slug `demo`/empty), `getPage(template, slug, locale)` (with `th` fallback), `getDemo(templateKey, locale)`. Also build a **published-page index** (`{ entitySlug|pageSlug → { locales published, url } }`) consumed by the link engine (§5.3).

### 4.7 Routing / dispatch

Triplet catch-alls (same pattern as the three homepage `index.astro`): `pages/[...slug].astro` (TH), `pages/en/[...slug].astro`, `pages/zh-cn/[...slug].astro`. `getStaticPaths()` → `getPageEntries(locale)` → `{ params:{ slug }, props:{ entry } }`. Component reads `entry.template` → `TEMPLATES` lookup → renders matching `component`. Static routes and the more-specific `en/`,`zh-cn/` files win over the root catch-all; TH catch-all emits only TH slugs (never `en/*`); empty/`demo` slugs excluded.

### 4.8 PageShell & two-column reading layout

`PageShell.astro` = the prototype's `.layout` (`grid: minmax(0,1fr) 300px`, responsive collapse to one column, sidebar `order:2` on mobile). Hosts a `main` slot + a `Sidebar.astro`:
- **ToC** (`toc-list`) generated from the in-page `<section id>`s, with a small client scrollspy (mirrors the prototype script; only interactive JS in the template).
- **Compact related** — `sidebarRelated`, resolved + backfilled (§5).
- **Mini-CTA** — `sidebarCta`.
Sidebar is `position: sticky`. Templates pass `toc`/`sidebarRelated`/`sidebarCta`; when all sidebar content is empty the shell renders single-column.

### 4.9 Schema `@graph` (`web/src/lib/schema.ts`)

`buildPageSchema(entry, locale)` → Tier-2 page node (`MedicalCondition` for T1; `Service`+`MedicalProcedure` for T5) + `BreadcrumbList` (from `breadcrumb`, resolved) + `SpeakableSpecification` (hero summary). `reviewer` → `reviewedBy`+`lastReviewed`. `Base` gains an optional `jsonLd` prop injected server-side in `<head>` (joins Base's Tier-1 Organization/WebSite). `FaqBlock` keeps its own FAQPage (Tier-3) inline; single-`@graph` consolidation is a follow-up.

### 4.10 i18n

Section **content** from per-locale `.yaml`; generic **micro-copy** (block labels, ToC title, tab labels, "ตรวจสอบโดย") in component `{th,en,'zh-cn'}` label maps keyed by `Astro.currentLocale`; content-specific headings come from entry data. hreflang via `Base`. **Never hardcode locale copy in a component.**

## 5. Internal-Link Engine & Fallback

The prototype is **internal-link-first**: links appear in 5 surfaces (inline prose, tech badges, sidebar related, tabbed end cluster, breadcrumb) and all must come from **one resolver** over the entity/relationship graph, degrading gracefully when targets don't exist yet.

### 5.1 Entity registry (`web/src/content/_entities.yaml` + `lib/entities.ts`)

Seeded subset (~15–20 entities the two demos touch) modeled from `content-plan/{entities,relationships}.md`:
```
- slug: all-on-4
  type: Treatment
  label: { th: 'All-on-4', en: 'All-on-4', zh-cn: 'All-on-4' }
  aliases: [...]
  primaryPage: 3.3            # sitemap node → maps to a URL when that page is published
  edges: [{ type: alternative_to, to: all-on-6 }, { type: parent_of, to: ... }, ...]
```
This is the **Supabase-hydration seam** for entities (Session B replaces the seed with the full 163). The relationship edges mirror `relationships.md` (10-edge vocabulary, DR-012).

### 5.2 Link surfaces (all via the engine)

| Surface | Source | Backfill edge priority |
|---|---|---|
| inline prose | `[label](entity:slug)` tokens in proseBlock text | — (explicit only) |
| tech badges | `service.techBadges[].linkTo` | `uses` |
| sidebar related | `sidebarRelated[]` | `alternative_to` → sibling → cluster pillar |
| tabbed RelatedCluster | `relatedCluster.tabs[].items` + `edge` | per-tab edge → sibling → pillar |
| breadcrumb | `breadcrumb[]` | `parent_of` chain |

### 5.3 Resolver — `resolveLink(target, locale, surface)` → 4 states

Checks the published-page index (§4.6) + entity registry:
1. **Live** — target page published in `locale` → real link to its URL.
2. **Locale-fallback** — page exists but not in `locale` → link to TH/default version + hreflang (mirrors `getHome` th-fallback).
3. **Stub** — entity in registry, no published page anywhere → no dead link: inline → plain text; navigational → nearest published `parent_of`/cluster hub, else dropped.
4. **Unknown** — slug absent from registry → prod: plain text + log to unresolved-links report; dev: warn.

### 5.4 Per-surface degradation

| Surface | If target missing/unpublished |
|---|---|
| inline prose | render label as **plain text** (no anchor) |
| tech badges | drop the badge (or non-clickable per config) |
| sidebar related | drop item; if `< min(2)` after backfill → drop section; box hides if empty |
| tabbed cluster | tab with 0 items hidden; all tabs empty → cluster hidden |
| breadcrumb | link only published ancestors; current page is text |
| content blocks | absent data → block self-hides |

### 5.5 Backfill ("spin") — fill to target N from the graph

When a surface wants N items but explicit/edge links yield fewer, fill in priority order until N (or exhausted): **curated (page data) → direct edge of the surface's type → siblings (same parent / same cluster) → cluster pillar/hub** — filtered to published-in-`locale`. Below `min` after backfill → hide the surface. Each surface config carries `{ min, target, max }`. This directly handles "few/no related items" without empty boxes.

### 5.6 DR-021 reciprocity + audit

The resolver, as the single chokepoint, emits a build-time **reciprocal-link audit** (which pages link to X; does X link back) and an **unresolved-links report**. DR-022 two-layer (volume-immune vs volume-driven) respected: curated links are volume-immune; backfilled links are volume-driven and clearly secondary.

### 5.7 Inline-link authoring (entity-token)

Authors write `[label](entity:slug)` in proseBlock `paragraphs`/`bullets`. A small renderer (Astro component or build helper) parses tokens and calls `resolveLink(..., 'inline')`. Plain markdown links/text are passed through untouched. Slugs survive URL + locale changes (resolved at build). Auto-link (scan aliases) is a documented later enhancement, off by default.

## 6. Template Preview Harness (noindex, 1:1, permanent)

Every template is born with its own live preview — a real page rendered through the **real layout** from a kitchen-sink mockup filling **every block (incl. optional)** — so the operator reviews layout **and link-fallback behavior** on a real screen, comments precisely, and edits one fixture when block shape changes (never rebuild mockups).

| Piece | What |
|---|---|
| **Demo fixtures** | `content/<template>/{th,en,zh-cn}/demo.yaml`, one per template per locale, every block populated; validated by that template's schema. Public dispatcher excludes slug `demo`. **Deliberately includes some unpublished/stub link targets** so fallback (§5.4) is visible on screen. |
| **Preview gallery** | `pages/preview/index.astro` (+en,+zh-cn) — a card per registered template (code/name/schemaType/status) → demo links ×3 locales. `noindex,nofollow`. |
| **Preview routes** | `pages/preview/[template].astro` (+en,+zh-cn) — `getStaticPaths` from `TEMPLATES`; loads locale demo via `getDemo()`, renders real layout, forced `noindex,nofollow`. |
| **Default DoD** | every template = layout + schema + demo fixture (3 locales) + registry row → preview pairing automatic + self-extending. |

**Review:** deploy go. (`npx wrangler deploy`) → `go.smilescapeclinic.com/preview/` (+/en,/zh-cn); or local `npm run preview`. The demo doubles as `npm run preview` verification content — no second content set. This slice: gallery + demos for T5 + T1.

## 7. Page-Type → T# mapping artifact

Doc `docs/content-templates/page-type-mapping.md`: per sitemap section, propose Page Type → T# with rationale, for operator review (sitemap "Page Type" column is `—`/TBD). Informs Phase F. Proposal only — does not edit the sitemap.

## 8. Constraints & compliance

- **Tokens only** (DR-029): `brand-*` Tailwind + `font-sans`/`font-display`, no raw hex.
- **Images** via `Image.astro` placeholders → Cloudflare later (DR-035); always pass width/height (CLS).
- **DR-021** reciprocal links (engine-audited), **DR-022** two-layer, **SS-DR-001** implant strategy (Blue Diamond hero, Neodent value-premium, **no Osstem**) where service touches implants.
- **Healthcare-marketing compliance:** guarantee language + before/after gated pending review; everything stays `noindex` (Base default `noindex,follow`; preview `noindex,nofollow`) until apex cutover.

## 9. Verification

No unit-test runner. Acceptance:
1. `cd web && npm run check` — **0 new errors** beyond the ~19 pre-existing in `Landing.astro`/`lp/dental-implant.astro`.
2. `npm run build` succeeds (incl. link resolution + reciprocity/unresolved-links reports printed).
3. `npm run preview` — in all three locales: T1 concern demo, T5 service demo, `/preview/` gallery. Every block renders; PageShell sidebar + ToC scrollspy work; tabbed RelatedCluster works; **link fallback visible** (stub targets render as plain text / hidden sections / backfilled cards) with **no dead links and no empty boxes**; no locale leakage.
4. View-source: each demo emits its Tier-2 `@graph` + BreadcrumbList + FAQPage; preview pages carry `noindex,nofollow`.
5. Validate one demo's JSON-LD (Rich Results) — no errors.

## 10. Build sequencing (for the plan)

1. Schema/config: `_shared.ts`, `concern` + `service` collections, remove `pages`, extend schema enum.
2. Entity registry seed (`_entities.yaml` + `lib/entities.ts`) + `lib/links.ts` (resolver, 4 states, per-surface degrade, backfill, audit) + published-page index in `lib/pages.ts`.
3. New block components — `ProseBlock` + inline-link renderer first; then QuickFacts, RiskFactors, TreatmentOptions, PricingTable, ExpertiseBox, TechBadges, DoctorReview, ReferencesBlock, Breadcrumb, CtaInline, RelatedCluster; then `PageShell` + `Sidebar` (+ ToC scrollspy).
4. `lib/schema.ts` + `Base` `jsonLd` prop; `lib/templates.ts` registry.
5. `Concern.astro` + `Service.astro` layouts (compose via PageShell).
6. Dispatcher routes (×3) + demo fixtures (kitchen-sink incl. stub targets, ×2 ×3 locales).
7. Preview gallery + preview routes (×3).
8. Page-Type→T# mapping doc.
9. Verify (§9). Record the proven block/link pattern toward the EYWA Content_Templates spec (cross-brand directive).

## 11. Open questions / follow-ups (non-blocking)

- Single-`@graph` consolidation (fold FaqBlock + breadcrumb + page node) — follow-up.
- Entity auto-link (alias scan) enhancement — off by default; revisit after Phase F volume.
- `ClinicalInsight` as ProseBlock variant vs standalone — decide in plan.
- Demo fixtures split from first real content entries when real content lands — revisit at Phase F.
- Supabase hydration mapping for both content + entity registry (Session B) — schema here is the seam.
