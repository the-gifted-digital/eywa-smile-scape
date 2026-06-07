# Handover — Content Template System (deliverable 2)

> **Created:** 2026-06-07 (end of Session C). **For:** a fresh chat that will design + build the per-content-type page templates. Read THIS file first — it's self-contained.
> **Repo:** `/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape` · **Branch:** `web-skeleton` · **Astro app:** `web/`.
> **Prereq context:** the Homepage MVP is DONE + LIVE on `go.smilescapeclinic.com/` (TH) `/en/` (EN) `/zh-cn/` (zh-CN). It produced the **first full EYWA Astro component library** — that library is the foundation this deliverable builds on.

---

## 0) Goal

Design and build **reusable Astro page templates, one per content/page type**, so the ~726-page sitemap can be produced consistently. The operator named these priority types:

> **knowledge · faq · service · concern · glossary** (+ the rest of the EYWA template set)

Each template = an Astro page-template/layout that **composes blocks from the homepage component library**, emits the correct **schema.org** type, follows **DR-021 internal linking**, and is **trilingual** (TH `/`, EN `/en/`, zh-CN `/zh-cn/`) via per-locale content collections — exactly the pattern the homepage already uses.

This is **deliverable 2**. Deliverable 1 (Homepage MVP) is shipped. The two were sequenced: homepage first (to forge the component library), template system second (this).

---

## 1) What already exists to reuse (don't rebuild)

**Component library** (`web/src/components/`) — built + reviewed + live this session:
- `ui/` — `Image.astro` (DR-035 placeholder→Cloudflare swap seam), `Button`, `SectionHeading` (has `onDark`), `Section` (tones default/ice/paper/anchor).
- `cards/` — `Pillar`, `ServiceCard`, `DoctorCard`, `ReviewCard`, `BranchCard`.
- `sections/` — `Hero`, `TrustBar`, `WhyPillars`, `BlueDiamond`, `ServicesGrid`, `PartnerLogos`, `FoundersMastery`, `TeamRoster`, `ProcessSteps`, `BeforeAfter`, `Reviews`, `Branches`, `FinalCta`, `StickyCta`.
- `forms/` — `BookingForm` (n8n + PDPA + `lead_submit`).
- existing — `FaqBlock.astro` (renders accordion **+ emits FAQPage JSON-LD**), `RelatedContent.astro` (DR-021 render point).

**Shell:** `layouts/Base.astro` = full-site shell (nav + footer + GTM `GTM-NFBVZT43` + `robots` prop default `noindex,follow` + global `line_click`/`call_click` + optional `<StickyCta>` via `stickyCta` prop + hreflang for th/en/zh-CN). `layouts/Landing.astro` = LP-only shell.

**Content layer:** Astro content collections in `web/src/content/config.ts`:
- `home` (type:'data', per-locale YAML `content/home/{th,en,zh-cn}.yaml`) — the homepage pattern.
- **`pages` + `articles`** (type:'content') — already scaffolded with zod schemas aligned to the sitemap **7-column model** (title/section/layer/tier/funnel/page_type/primary_entity + related_pages/related_entities + faq + schema_type + hero_image). **These are the data shape for the ~726 content pages.** Templates will consume these.
- Accessor pattern: `lib/home.ts` `getHome(locale)`. Mirror this for page/article loaders.

**i18n:** TH `/` (default, no prefix), EN `/en/`, zh-CN `/zh-cn/`. Components self-localize via `Astro.currentLocale` + internal `{th,en,'zh-cn'}` label maps (see `BookingForm`/`StickyCta`/`Base`). Section *content* comes from per-locale collection entries; **micro-copy** lives in component label maps. Never hardcode locale copy in a component.

**Design system (DR-029):** components use only `brand-*` Tailwind tokens + `font-sans`/`font-display`. No raw hex. Tokens in `design/brand-foundation/tokens.json`.

**Reference docs from this session:**
- Memory: `~/.claude/projects/-Volumes-SSD-NN-CLAUDE-AI-repos-brands-eywa-smile-scape/memory/homepage-component-library.md` (the reusable pattern, in detail).
- Spec: `docs/superpowers/specs/2026-06-07-homepage-mvp-design.md`.
- Plan: `docs/superpowers/plans/2026-06-07-homepage-mvp.md` (shows the component code + composition pattern to imitate).

---

## 2) Canonical template definitions — EYWA Content_Templates

**Source of truth:** `repos/eywa-protocol-spec/Content_Templates_EYWA_v1_0.md` (filename says v1_0; **internal version is v1.8**, T1–T22 **LOCKED** per DR-020; T-ADS-X proposed). ADOPT as-is — do not reinvent.

Key idea: **a template is a composition of "blocks" (Layer 1, the `B##` system) — and our Astro section/card components ARE those blocks.** So building a template = composing existing components in the right order + emitting the right schema + wiring DR-021 links, mostly NOT writing new low-level UI.

**The 25 templates:**
- **Core Universal (12):** T1 Medical Condition · T2 Medical Procedure/Treatment · T3 Diagnostic · T4 Device/Technology · T5 Service/Money Page · T6 Concept/Knowledge Article · T6a Guide (long-form) · T7 Comparison · T8 Case Study · T9 Doctor · T10 Branch · T11 Institutional (Home/About/Contact/Privacy — **done** as the homepage et al.).
- **T2 Variants (5):** T2a Aesthetic · T2b Dental · T2c Wellness Program · T2d Rehab · T2e Genomic Test.
- **Specialized (7+):** T12 Hub · T13 Pricing · T14 News · T15 Quiz · T16 Insurance · T17 Care Instructions · T18 Programmatic Local · T19 Promotion.
- **Ads (proposed, T-ADS-1..5):** Hero Service LP / Booking LP / Promo LP / Comparison LP / Lead-Magnet LP — note the live `lp/dental-implant.astro` is effectively a T-ADS-1.

The spec also defines per-template **block requirements** (e.g. FAQ floor per DR-034/B18, author/E-E-A-T blocks, safety blocks, internal-link counts per template — see its tables ~lines 700–725). Honor those.

---

## 3) Operator's named types → template → sitemap section → schema → components to reuse

| Operator term | EYWA template | Sitemap section (`content-plan/sitemap.md`) | schema.org | Reuse / new blocks |
|---|---|---|---|---|
| **service** | **T5** Service/Money (+ **T12** Hub for category hubs) | Section 3 Services (~240p) | `Service` / `MedicalProcedure` | Hero, BlueDiamond-style offer band, ProcessSteps, ServicesGrid (sub-services), BookingForm, FaqBlock, RelatedContent |
| **concern** | **T1** Medical Condition | Section 5 Treatment by Concerns (~193p) | `MedicalWebPage` / `MedicalCondition` | symptom/cause/treatment prose blocks (new), ProcessSteps, FaqBlock, RelatedContent, Reviews. **Reference: `docs/master-example-peri-implantitis.html`** = the annotated Condition Page master example |
| **knowledge** | **T6** Concept + **T6a** Guide (long-form) | Section 6 Knowledge (~169p, L5) | `Article` | prose/TOC blocks (new), `featured_answer` (GEO/AEO) already in `articles` schema, FaqBlock, RelatedContent |
| **faq** | FAQ canonical pages (**SS-DR-009**, Section 6.5; B18 FAQ block, DR-034 tiered floor) | Section 6.5 (29 canonical FAQ pages) | `FAQPage` | **`FaqBlock` already emits FAQPage JSON-LD** — wrap it in a page template + intra-page answer routing (§4.5.4 PAA×FAQ) |
| **glossary** | **T6** Concept (short term page) / glossary type | Section 6 Glossary sub-hub | `DefinedTerm` / `DefinedTermSet` | compact definition block (new), RelatedContent (DR-021 links to clusters), FaqBlock optional |

Plus the remaining high-volume types to plan: **T2/T2a-e** Procedure (Section 3 detail pages), **T4** Technology (Section 4, ~44p), **T7** Comparison, **T8** Case Study (Section 7, ~38p), **T9** Doctor (derive from `web/src/data/doctors.json`), **T10** Branch (Section 8 + `content-plan/branches.md`), **T13** Pricing, **T16** Insurance (Q-Clinic/SSO — Section 5.13).

> Sitemap **"Page Type" column is currently `—` (TBD)** — it gets populated at **Phase F content briefing**. Part of this deliverable may be proposing the Page Type → T# mapping for operator review.

---

## 4) Recommended approach (mirror the homepage workflow)

1. **brainstorm** (superpowers:brainstorming) → decide scope: which templates first, the template-file architecture (e.g. `layouts/` per type, or a generic `PageTemplate.astro` switching on `page_type`, or one Astro page-template component per T#), the page/article collection loader, the routing (`pages/[...slug].astro` driven by the collection vs explicit files), trilingual strategy.
2. **spec** → `docs/superpowers/specs/YYYY-MM-DD-content-templates-design.md`.
3. **plan** (superpowers:writing-plans) → `docs/superpowers/plans/...`.
4. **build** (superpowers:subagent-driven-development) → fresh subagent per template, spec-review + quality-review each.

**Suggested first slice (de-risk the pattern):** build **T5 Service hub** + **T1 Concern page** (the two biggest sections, 240p + 193p) end-to-end first — one representative content entry each, trilingual — to lock the template architecture, THEN expand to knowledge/faq/glossary and the rest. Promote the resulting pattern to the EYWA Content_Templates spec so other brands inherit it (spec §15 cross-brand directive).

**Verification (no unit-test runner):** `cd web && npm run check` (ignore ~19 pre-existing errors in `Landing.astro`/`lp/dental-implant.astro`; require 0 NEW) + `npm run build` + `npm run preview`. Deploy = `npx wrangler deploy` (operator-gated). Keep `noindex,follow` on go.

---

## 5) Constraints & dependencies

- **Tokens only** (DR-029); **images via `Image.astro`** placeholders now → Cloudflare URLs later (DR-035, Session A swaps `src` in content only).
- **Content via collections** (`pages`/`articles` in `content/config.ts`), NOT `src/data/`. The collection is the **Supabase hydration seam** (Session B will populate from the live DB — schema already loaded for SmileScape per `docs/superpowers/specs/2026-06-07-supabase-data-load-design.md`).
- **DR-021** reciprocal internal linking (render via `RelatedContent`), **DR-022** two-layer (volume-immune vs volume-driven), **SS-DR-001** implant brand strategy (Blue Diamond hero, Neodent value-premium, **no Osstem**).
- **Compliance:** same guardrails as homepage/LP — guarantee language + before/after pending healthcare-marketing-compliance review; `noindex` until apex cutover.
- **Out of scope here:** real content authoring (Phase F), DataForSEO keyword research (Stage-1 gate), apex cutover, real images (Session A).

---

## 6) Quick-start for the new chat

```
1. Read this file + memory/homepage-component-library.md + the homepage spec/plan.
2. Skim Content_Templates_EYWA_v1_0.md (T1–T22) + master-example-peri-implantitis.html.
3. Skim content-plan/sitemap.md sections 3/5/6 (service/concern/knowledge volumes).
4. /brainstorm the template-system architecture → spec → plan → build (subagent-driven).
5. Start with T5 Service + T1 Concern as the reference templates.
```

*This chat (the one that created this handover) stays focused on the homepage. Template-system work continues from here in a separate chat.*
