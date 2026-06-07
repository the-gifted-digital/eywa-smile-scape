# Content Template System Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the per-content-type Astro page-template system (Approach A) with two full-parity reference templates (T5 Service, T1 Concern), a centralized internal-link engine with graceful fallback, and a permanent noindex preview harness.

**Architecture:** Collection-per-template (`type:'data'`, mirroring the `home` collection) dispatched by per-locale catch-all routes reading a shared registry. Template layouts compose the existing homepage component library plus ~14 new blocks inside a two-column `PageShell`. All internal links (inline prose, tech badges, sidebar, tabbed cluster, breadcrumb) resolve through one engine over the seeded entity/relationship graph, degrading to plain text / hidden sections / graph-backfilled cards when targets are unpublished.

**Tech Stack:** Astro 4 content collections (zod), TypeScript, Tailwind (`brand-*` tokens), YAML content, Node (dependency-free assertion script for link-engine logic).

**Spec:** `docs/superpowers/specs/2026-06-08-content-templates-design.md`. **Reference prototype (T5 markup/classes source):** `docs/../legacy/Sitemap Deezy/SmileScape/prototype-all-on-4-v2.html`. **Graph source:** `content-plan/{entities,relationships,clusters}.md`.

**Verification model (no test runner):** unless a task says otherwise, the gate is `cd web && npm run check` → **0 new errors** beyond the ~19 pre-existing in `Landing.astro`/`lp/dental-implant.astro`, then `npm run build`. Link-engine logic uses `node web/scripts/verify-links.mjs` (red→green). Final render checks use `npm run preview`.

**Conventions to follow (from the live homepage library — read before starting):**
- Components use only `brand-*` Tailwind classes + `font-sans`/`font-display`; no raw hex (see `web/src/components/sections/*`).
- Locale micro-copy lives in a per-component `{ th, en, 'zh-cn' }` map keyed off `Astro.currentLocale` (see `BookingForm.astro`, `StickyCta.astro`). Never hardcode locale copy.
- Images go through `components/ui/Image.astro` (always pass width/height).
- Section content comes from collection data; the loader pattern is `lib/home.ts` `getHome(locale)`.

---

## Phase 0 — Foundation: schema, registry, loaders, routing (pipeline proof)

Goal: a sample entry routes to a minimal template and renders, in all 3 locales. Locks the data shape + dispatcher before any block work.

### Task 1: Shared schema helpers (`_shared.ts`)

**Files:**
- Create: `web/src/content/_shared.ts`

- [ ] **Step 1: Create the shared helpers and `baseFields`**

```ts
// web/src/content/_shared.ts — zod helpers shared across template collections.
import { z } from 'astro:content';

export const imageRef = z.object({
  src: z.string().optional(),     // undefined/"placeholder:..." → placeholder box (DR-035)
  alt: z.string(),
  label: z.string().optional(),
});

// A link target is EITHER an explicit href OR an entity slug resolved by lib/links.ts.
export const linkTarget = z.object({ href: z.string().optional(), linkTo: z.string().optional() });
export const cta = z.object({ label: z.string(), href: z.string().optional(), linkTo: z.string().optional() });

export const faqItem = z.object({ q: z.string(), a: z.string() });
export const referenceItem = z.object({ label: z.string(), url: z.string().optional() });
export const reviewItem = z.object({ quote: z.string(), name: z.string(), stars: z.number() });
export const beforeAfterItem = z.object({ before: imageRef, after: imageRef, caption: z.string() });

export const relatedItem = z.object({
  linkTo: z.string().optional(),  // entity slug (preferred)
  href: z.string().optional(),    // or explicit href
  title: z.string().optional(),
  summary: z.string().optional(),
  image: imageRef.optional(),
});

// proseBlock paragraphs/bullets may contain entity-token links: "[label](entity:slug)" (resolved by InlineLinks).
export const proseBlock = z.object({
  heading: z.string().optional(),
  eyebrow: z.string().optional(),
  lead: z.string().optional(),
  paragraphs: z.array(z.string()).default([]),
  bullets: z.array(z.string()).optional(),
  subsections: z.array(z.object({ heading: z.string(), body: z.string() })).optional(),
  variant: z.enum(['prose', 'checklist']).default('prose'),
});

export const schemaTypeEnum = z.enum([
  'WebPage', 'MedicalWebPage', 'MedicalClinic', 'Dentist', 'Service', 'MedicalProcedure',
  'MedicalCondition', 'FAQPage', 'Article', 'AboutPage', 'ContactPage',
  'CollectionPage', 'DefinedTerm', 'DefinedTermSet',
]);

export const templateKey = z.enum(['service', 'concern']);

export const quickFacts = z.object({
  variant: z.enum(['stats', 'essentials']),
  items: z.array(z.object({ icon: z.string().optional(), label: z.string(), value: z.string() })),
  technical: z.array(z.object({ label: z.string(), value: z.string() })).optional(), // essentials toggle
});

export const relatedCluster = z.object({
  heading: z.string().optional(),
  intro: z.string().optional(),
  tabs: z.array(z.object({
    key: z.string(),
    label: z.string(),
    edge: z.string().optional(),         // relationship edge type to backfill from
    items: z.array(relatedItem).default([]),
  })),
});

// Spread into every template schema.
export const baseFields = {
  meta: z.object({ title: z.string(), description: z.string() }),
  template: templateKey,
  primaryEntity: z.string().optional(),   // entity slug — link-engine graph PIVOT (backfill on EVERY template) + getPublishedIndex key
  section: z.string().optional(),         // sitemap 7-col taxonomy (all templates)
  layer: z.string().optional(),
  tier: z.string().optional(),
  funnel: z.string().optional(),
  pageType: z.string().optional(),
  sidebarRelatedEdge: z.string().optional(), // override the registry default backfill edge for the sidebar (data-driven, not hardcoded)
  breadcrumb: z.array(z.object({ linkTo: z.string().optional(), href: z.string().optional(), label: z.string() })).optional(),
  hero: z.object({
    eyebrow: z.string().optional(),
    badge: z.string().optional(),
    title: z.string(),
    body: z.string(),
    image: imageRef,
    primaryCta: cta,
    secondaryCta: cta.optional(),
  }),
  quickFacts: quickFacts.optional(),
  toc: z.boolean().default(true),
  sidebarRelated: z.array(relatedItem).optional(),
  sidebarCta: z.object({ title: z.string(), body: z.string(), cta }).optional(),
  midCta: z.object({ title: z.string(), body: z.string(), cta }).optional(),
  expertise: z.object({
    heading: z.string(),
    quote: z.string().optional(),
    body: z.string().optional(),
    trustItems: z.array(z.object({ title: z.string(), body: z.string() })).default([]),
  }).optional(),
  reviewer: z.object({ name: z.string(), credentials: z.array(z.string()).default([]), reviewedDate: z.string() }).optional(),
  references: z.array(referenceItem).default([]),
  faq: z.array(faqItem).default([]),
  relatedCluster: relatedCluster.optional(),
  finalCta: z.object({ title: z.string(), body: z.string(), cta }).optional(),
  schemaType: schemaTypeEnum,
  canonical: z.string().optional(),
  published: z.boolean().default(false),
  updatedAt: z.coerce.date().optional(),
};
```

- [ ] **Step 2: Verify it compiles**

Run: `cd web && npm run check 2>&1 | tail -5`
Expected: no NEW errors referencing `_shared.ts` (pre-existing Landing/lp errors OK).

- [ ] **Step 3: Commit**

```bash
git add web/src/content/_shared.ts
git commit -m "feat(content): shared zod schema helpers for template collections"
```

### Task 2: `concern` + `service` collections; remove `pages` (`config.ts`)

**Files:**
- Modify: `web/src/content/config.ts`

- [ ] **Step 1: Replace `pages`/`articles` block with per-template collections**

Open `web/src/content/config.ts`. Remove the `pages` collection definition entirely. Keep `home` unchanged. Add imports and the two new collections; keep `articles` reserved as `type:'data'` (empty schema with baseFields, no extra blocks).

```ts
import { baseFields, proseBlock, reviewItem, beforeAfterItem, relatedItem } from './_shared';

const concern = defineCollection({
  type: 'data',
  schema: z.object({
    ...baseFields,
    definition: proseBlock,
    causes: z.object({
      heading: z.string(),
      groups: z.array(z.object({
        category: z.string(),
        factors: z.array(z.object({ name: z.string(), mechanism: z.string(), citation: z.string().optional() })),
      })),
    }),
    symptoms: proseBlock,
    diagnosis: proseBlock,
    treatment: z.object({ heading: z.string(), options: z.array(z.object({ name: z.string(), body: z.string() })) }),
    clinicalInsight: z.object({ quote: z.string(), by: z.string() }).optional(),
    reviews: z.array(reviewItem).optional(),
    beforeAfter: z.array(beforeAfterItem).optional(),
  }),
});

const service = defineCollection({
  type: 'data',
  schema: z.object({
    ...baseFields,
    whoFor: z.union([
      proseBlock,
      z.object({ heading: z.string(), cards: z.array(z.object({ icon: z.string().optional(), title: z.string(), body: z.string(), linkTo: z.string().optional() })) }),
    ]),
    process: z.array(z.object({ step: z.number(), title: z.string(), body: z.string(), image: z.any().optional() })),
    techBadges: z.array(z.object({ linkTo: z.string(), label: z.string().optional() })).optional(),
    pricing: z.object({
      note: z.string().optional(),
      oldPrice: z.string().optional(),
      tiers: z.array(z.object({ name: z.string(), price: z.string(), period: z.string().optional(), includes: z.array(z.string()).default([]), highlight: z.boolean().optional() })),
    }),
    comparison: z.object({ heading: z.string(), columns: z.array(z.string()), rows: z.array(z.object({ label: z.string(), cells: z.array(z.string()) })) }).optional(),
    beforeAfter: z.array(beforeAfterItem).optional(),
  }),
});

const articles = defineCollection({ type: 'data', schema: z.object({ ...baseFields }) });
```

Update the final export: `export const collections = { home, concern, service, articles };`

- [ ] **Step 2: Verify**

Run: `cd web && npm run check 2>&1 | tail -8`
Expected: no NEW errors. (No content entries yet, so collections are empty — that's fine.)

- [ ] **Step 3: Commit**

```bash
git add web/src/content/config.ts
git commit -m "feat(content): concern + service data collections; drop generic pages"
```

### Task 3: Minimal template layouts (stubs) + registry

**Files:**
- Create: `web/src/layouts/templates/Service.astro`
- Create: `web/src/layouts/templates/Concern.astro`
- Create: `web/src/lib/templates.ts`

- [ ] **Step 1: Create stub layouts that render hero + title only**

Both files identical shape (grow later). `Concern.astro`:

```astro
---
import Base from '../Base.astro';
interface Props { data: any; locale: string; }
const { data } = Astro.props;
---
<Base title={data.meta.title} description={data.meta.description}>
  <h1 class="font-display text-3xl text-brand-anchor">{data.hero.title}</h1>
  <p class="mt-4 text-brand-neutral-700">{data.hero.body}</p>
</Base>
```

Create `Service.astro` identically.

- [ ] **Step 2: Create the registry**

```ts
// web/src/lib/templates.ts — single source of truth for template dispatch + preview gallery.
import Concern from '../layouts/templates/Concern.astro';
import Service from '../layouts/templates/Service.astro';

export const TEMPLATES = [
  { code: 'T1', key: 'concern', name: 'Medical Condition', schemaType: 'MedicalCondition', component: Concern, demoSlug: 'demo', sidebarEdge: 'treats' },
  { code: 'T5', key: 'service', name: 'Service / Money Page', schemaType: 'Service', component: Service, demoSlug: 'demo', sidebarEdge: 'alternative_to' },
] as const;

export const TEMPLATE_BY_KEY = Object.fromEntries(TEMPLATES.map((t) => [t.key, t]));
export type TemplateKey = (typeof TEMPLATES)[number]['key'];
```

- [ ] **Step 3: Verify + commit**

Run: `cd web && npm run check 2>&1 | tail -5` → no new errors.
```bash
git add web/src/layouts/templates/ web/src/lib/templates.ts
git commit -m "feat(templates): stub Concern/Service layouts + template registry"
```

### Task 4: Loaders + published-page index (`lib/pages.ts`)

**Files:**
- Create: `web/src/lib/pages.ts`

- [ ] **Step 1: Implement loaders mirroring `getHome`**

```ts
// web/src/lib/pages.ts — content loaders for template collections + a published-page index for the link engine.
import { getCollection, getEntry } from 'astro:content';
import type { Locale } from './home';
import { TEMPLATES, type TemplateKey } from './templates';

const COLLECTIONS = TEMPLATES.map((t) => t.key) as TemplateKey[];

/** "th/peri-implantitis" → { locale:"th", slug:"peri-implantitis" } */
function splitId(id: string) {
  const [locale, ...rest] = id.split('/');
  return { locale, slug: rest.join('/') };
}

/** All public entries for a locale across every template collection (excludes demo/empty slugs). */
export async function getPageEntries(locale: Locale) {
  const out: { slug: string; template: TemplateKey; data: any }[] = [];
  for (const key of COLLECTIONS) {
    const entries = await getCollection(key as any, (e: any) => splitId(e.id).locale === locale);
    for (const e of entries) {
      const { slug } = splitId(e.id);
      if (!slug || slug === 'demo') continue;
      out.push({ slug, template: key, data: e.data });
    }
  }
  return out;
}

export async function getPage(template: TemplateKey, slug: string, locale: Locale) {
  const entry = (await getEntry(template as any, `${locale}/${slug}`)) ?? (await getEntry(template as any, `th/${slug}`));
  return entry?.data ?? null;
}

export async function getDemo(template: TemplateKey, locale: Locale) {
  const entry = (await getEntry(template as any, `${locale}/demo`)) ?? (await getEntry(template as any, `th/demo`));
  return entry?.data ?? null;
}

/** Map of entity-slug/page-slug → which locales have a published page + the locale→url map. Consumed by lib/links.ts. */
export async function getPublishedIndex() {
  const index: Record<string, { locales: string[]; url: Record<string, string> }> = {};
  for (const key of COLLECTIONS) {
    const entries = await getCollection(key as any);
    for (const e of entries) {
      const { locale, slug } = splitId(e.id);
      if (!slug || slug === 'demo' || !e.data.published) continue;
      const id = e.data.primaryEntity ?? slug;          // entity slug if tagged, else page slug
      const url = locale === 'th' ? `/${slug}/` : `/${locale}/${slug}/`;
      index[id] ??= { locales: [], url: {} };
      index[id].locales.push(locale);
      index[id].url[locale] = url;
    }
  }
  return index;
}
```

- [ ] **Step 2: Verify + commit**

Run: `cd web && npm run check 2>&1 | tail -5` → no new errors.
```bash
git add web/src/lib/pages.ts
git commit -m "feat(content): page loaders + published-page index"
```

### Task 5: Dispatcher routes (×3 locales)

**Files:**
- Create: `web/src/pages/[...slug].astro`
- Create: `web/src/pages/en/[...slug].astro`
- Create: `web/src/pages/zh-cn/[...slug].astro`

- [ ] **Step 1: TH dispatcher**

```astro
---
// web/src/pages/[...slug].astro — TH catch-all dispatcher.
import { getPageEntries } from '../lib/pages';
import { TEMPLATE_BY_KEY } from '../lib/templates';

export async function getStaticPaths() {
  const entries = await getPageEntries('th');
  return entries.map((e) => ({ params: { slug: e.slug }, props: { entry: e } }));
}
const { entry } = Astro.props;
const Template = TEMPLATE_BY_KEY[entry.template].component;
---
<Template data={entry.data} locale="th" />
```

- [ ] **Step 2: EN + zh-CN dispatchers**

`web/src/pages/en/[...slug].astro` — identical but `getPageEntries('en')` and `locale="en"`. `web/src/pages/zh-cn/[...slug].astro` — `getPageEntries('zh-cn')` and `locale="zh-cn"`.

- [ ] **Step 3: Pipeline proof — add a throwaway TH service entry**

Create `web/src/content/service/th/_pipeline-test.yaml`... no — leading underscore is excluded by Astro. Instead create `web/src/content/service/th/pipeline-test.yaml` with the minimum required fields:

```yaml
meta: { title: "Pipeline test", description: "temp" }
template: service
hero: { title: "ทดสอบ pipeline", body: "ok", image: { alt: "x" }, primaryCta: { label: "จอง", href: "#" } }
schemaType: Service
published: true
whoFor: { heading: "x", paragraphs: ["x"] }
process: []
pricing: { tiers: [] }
```

Run: `cd web && npm run build 2>&1 | tail -15`
Expected: build succeeds; output includes `pipeline-test/index.html`. Confirm: `ls dist/pipeline-test/index.html`.

- [ ] **Step 4: Remove the throwaway entry, commit routes**

```bash
rm web/src/content/service/th/pipeline-test.yaml
git add web/src/pages/\[...slug\].astro web/src/pages/en web/src/pages/zh-cn
git commit -m "feat(routing): per-locale catch-all template dispatchers"
```

**Phase 0 checkpoint:** `npm run check` clean (0 new), routing proven end-to-end.

---

## Phase 1 — Internal-link engine (node-verifiable pure logic)

Goal: `resolveLink` + backfill + degradation, tested with a dependency-free node script. This is the riskiest logic — build it red→green first.

### Task 6: Entity registry seed + loader

**Files:**
- Create: `web/src/content/_entities.yaml`
- Create: `web/src/lib/entities.ts`

- [ ] **Step 1: Seed ~18 entities from the two demos** (model from `content-plan/entities.md` + `relationships.md`)

```yaml
# web/src/content/_entities.yaml — seeded subset for the T5/T1 demos (Supabase-hydration seam; full 163 land later).
- slug: all-on-4
  type: Treatment
  label: { th: "All-on-4", en: "All-on-4", zh-cn: "All-on-4" }
  aliases: ["ออลออนโฟร์"]
  edges:
    - { type: alternative_to, to: all-on-6 }
    - { type: alternative_to, to: zygomatic-implant }
    - { type: uses, to: immediate-loading }
    - { type: treats, to: edentulism }
- slug: all-on-6
  type: Treatment
  label: { th: "All-on-6", en: "All-on-6", zh-cn: "All-on-6" }
  edges: [{ type: alternative_to, to: all-on-4 }]
- slug: zygomatic-implant
  type: Treatment
  label: { th: "Zygomatic Implant", en: "Zygomatic Implant", zh-cn: "颧骨种植" }
  edges: []
# ...continue for: dental-implant, single-tooth-implant, overdenture, immediate-loading,
#    bone-grafting, blue-diamond-implant, straumann-implant, guided-surgery,
#    edentulism, denture-dissatisfaction, peri-implantitis, osseointegration,
#    immediate-implant, sausage-technique  (≈18 total; edges per relationships.md)
```

Model the remaining entities the same way, copying edges verbatim from `content-plan/relationships.md` (sections A, B, D). Include `peri-implantitis` (the T1 demo subject) with its `treats`/`symptom_of`/`alternative_to` edges.

- [ ] **Step 2: Entity loader + index**

```ts
// web/src/lib/entities.ts — load + index the seeded entity registry.
import entitiesYaml from '../content/_entities.yaml';  // see Step 3 for the yaml import shim

export interface Entity {
  slug: string; type: string;
  label: Record<string, string>;
  aliases?: string[];
  edges?: { type: string; to: string }[];
}
export const ENTITIES: Entity[] = entitiesYaml as Entity[];
export const ENTITY_BY_SLUG: Record<string, Entity> = Object.fromEntries(ENTITIES.map((e) => [e.slug, e]));

/** neighbors of `slug` along a given edge type (follows symmetric edges both ways). */
export function neighbors(slug: string, edgeType: string): string[] {
  const out = new Set<string>();
  for (const e of ENTITY_BY_SLUG[slug]?.edges ?? []) if (e.type === edgeType) out.add(e.to);
  for (const ent of ENTITIES) for (const e of ent.edges ?? []) if (e.type === edgeType && e.to === slug) out.add(ent.slug);
  return [...out];
}
```

- [ ] **Step 3: Enable YAML imports**

Check `web/astro.config.mjs` for a YAML plugin. If absent, add `@rollup/plugin-yaml` to `vite.plugins`. Install: `cd web && npm i -D @rollup/plugin-yaml`. In `astro.config.mjs`: `import yaml from '@rollup/plugin-yaml'` and `vite: { plugins: [yaml()] }`. (If the project already imports `.yaml`, skip.)

- [ ] **Step 4: Verify + commit**

Run: `cd web && npm run check 2>&1 | tail -5` → no new errors.
```bash
git add web/src/content/_entities.yaml web/src/lib/entities.ts web/astro.config.mjs web/package.json web/package-lock.json
git commit -m "feat(links): seeded entity registry + graph neighbors"
```

### Task 7: Link resolver — 4 states (red→green via node script)

**Files:**
- Create: `web/scripts/verify-links.mjs`
- Create: `web/src/lib/links.ts`

- [ ] **Step 1: Write the failing assertions**

```js
// web/scripts/verify-links.mjs — dependency-free assertions for the link engine.
import assert from 'node:assert/strict';
import { resolveLink } from '../src/lib/links.ts';

// published index fixture: all-on-6 live in th only; all-on-4 unpublished everywhere.
const idx = { 'all-on-6': { locales: ['th'], url: { th: '/all-on-6/' } } };

// 1. Live
assert.equal(resolveLink({ linkTo: 'all-on-6' }, 'th', 'inline', idx).state, 'live');
assert.equal(resolveLink({ linkTo: 'all-on-6' }, 'th', 'inline', idx).href, '/all-on-6/');
// 2. Locale-fallback (en requested, only th published)
assert.equal(resolveLink({ linkTo: 'all-on-6' }, 'en', 'inline', idx).state, 'locale-fallback');
assert.equal(resolveLink({ linkTo: 'all-on-6' }, 'en', 'inline', idx).href, '/all-on-6/');
// 3. Stub (entity known, no page anywhere)
assert.equal(resolveLink({ linkTo: 'all-on-4' }, 'th', 'inline', idx).state, 'stub');
assert.equal(resolveLink({ linkTo: 'all-on-4' }, 'th', 'inline', idx).href, undefined);
// 4. Unknown
assert.equal(resolveLink({ linkTo: 'does-not-exist' }, 'th', 'inline', idx).state, 'unknown');
console.log('OK resolveLink 4-state');
```

- [ ] **Step 2: Run it — must fail**

Run: `cd web && node --experimental-strip-types scripts/verify-links.mjs`
Expected: FAIL (`resolveLink` not found / not a function).
(If `--experimental-strip-types` is unavailable on the installed Node, instead point the import at a compiled path or run via `npx tsx scripts/verify-links.mjs`; record which in the script header.)

- [ ] **Step 3: Implement `resolveLink`**

```ts
// web/src/lib/links.ts — single resolver for every internal link surface.
import { ENTITY_BY_SLUG, neighbors } from './entities';

export type LinkState = 'live' | 'locale-fallback' | 'stub' | 'unknown';
export type Surface = 'inline' | 'badge' | 'sidebar' | 'cluster' | 'breadcrumb';
export interface PublishedIndex { [id: string]: { locales: string[]; url: Record<string, string> }; }
export interface Resolved { state: LinkState; href?: string; label?: string; }

export function resolveLink(
  target: { linkTo?: string; href?: string; title?: string },
  locale: string,
  _surface: Surface,
  idx: PublishedIndex,
): Resolved {
  if (target.href) return { state: 'live', href: target.href, label: target.title };
  const slug = target.linkTo;
  if (!slug) return { state: 'unknown' };
  const ent = ENTITY_BY_SLUG[slug];
  const label = target.title ?? ent?.label?.[locale] ?? ent?.label?.th ?? slug;
  const pub = idx[slug];
  if (pub) {
    if (pub.url[locale]) return { state: 'live', href: pub.url[locale], label };
    const fb = pub.url.th ?? pub.url[pub.locales[0]];
    if (fb) return { state: 'locale-fallback', href: fb, label };
  }
  if (ent) return { state: 'stub', label };       // known entity, no page → caller degrades
  return { state: 'unknown', label };
}
```

- [ ] **Step 4: Run — must pass**

Run: `cd web && node --experimental-strip-types scripts/verify-links.mjs`
Expected: `OK resolveLink 4-state`.

- [ ] **Step 5: Commit**

```bash
git add web/scripts/verify-links.mjs web/src/lib/links.ts
git commit -m "feat(links): resolveLink 4-state (live/locale-fallback/stub/unknown)"
```

### Task 8: Backfill ("spin") + per-surface list resolution

**Files:**
- Modify: `web/src/lib/links.ts`
- Modify: `web/scripts/verify-links.mjs`

- [ ] **Step 1: Add failing assertions for backfill**

Append to `verify-links.mjs`:
```js
import { resolveList } from '../src/lib/links.ts';
// sidebar wants min 2: curated has 1 stub (dropped), backfill from all-on-4 alternative_to → all-on-6 (live)
const sb = resolveList({ surface: 'sidebar', curated: [{ linkTo: 'all-on-4' }], pivot: 'all-on-4', edge: 'alternative_to', min: 2, target: 4 }, 'th', idx);
assert.ok(sb.items.every((i) => i.href), 'sidebar items all resolvable');
assert.ok(sb.items.length >= 1, 'backfilled at least one live item');
// when nothing resolves and below min → hidden
const empty = resolveList({ surface: 'sidebar', curated: [{ linkTo: 'all-on-4' }], pivot: 'all-on-4', edge: 'part_of', min: 2, target: 4 }, 'th', idx);
assert.equal(empty.hidden, true, 'empty section hidden');
console.log('OK resolveList backfill');
```

- [ ] **Step 2: Run — must fail** (`resolveList` not found). Run: `cd web && node --experimental-strip-types scripts/verify-links.mjs`.

- [ ] **Step 3: Implement `resolveList`**

```ts
// append to web/src/lib/links.ts
export interface ListReq {
  surface: Surface; curated?: { linkTo?: string; href?: string; title?: string }[];
  pivot?: string; edge?: string; min: number; target: number;
}
export function resolveList(req: ListReq, locale: string, idx: PublishedIndex): { items: Resolved[]; hidden: boolean } {
  const seen = new Set<string>();
  const live: Resolved[] = [];
  const push = (t: { linkTo?: string; href?: string }) => {
    const k = t.linkTo ?? t.href; if (!k || seen.has(k)) return;
    const r = resolveLink(t, locale, req.surface, idx);
    if (r.href) { seen.add(k); live.push(r); }                 // only linkable items fill a list
  };
  for (const c of req.curated ?? []) push(c);                  // 1. curated
  if (live.length < req.target && req.pivot && req.edge)        // 2. direct edge backfill
    for (const n of neighbors(req.pivot, req.edge)) { if (live.length >= req.target) break; push({ linkTo: n }); }
  // (3. siblings / 4. cluster pillar can extend here later)
  const items = live.slice(0, req.target);
  return { items, hidden: items.length < req.min };
}
```

- [ ] **Step 4: Run — must pass.** Expected: `OK resolveList backfill`.

- [ ] **Step 5: Commit**

```bash
git add web/src/lib/links.ts web/scripts/verify-links.mjs
git commit -m "feat(links): resolveList with graph backfill + min-count hiding"
```

### Task 9: DR-021 reciprocity + unresolved-links report (build-time)

**Files:**
- Modify: `web/src/lib/links.ts`

- [ ] **Step 1: Add a reporter that scans all entries**

```ts
// append to web/src/lib/links.ts — call from a build step / the dispatcher's getStaticPaths once.
export function auditLinks(allLinks: { from: string; to: string }[], idx: PublishedIndex) {
  const pairs = new Set(allLinks.map((l) => `${l.from}->${l.to}`));
  const nonReciprocal = allLinks.filter((l) => !pairs.has(`${l.to}->${l.from}`));
  const unresolved = allLinks.filter((l) => !idx[l.to]);
  if (nonReciprocal.length) console.warn(`[DR-021] ${nonReciprocal.length} non-reciprocal links`);
  if (unresolved.length) console.warn(`[links] ${unresolved.length} unresolved targets`);
  return { nonReciprocal, unresolved };
}
```

- [ ] **Step 2: Verify + commit**

Run: `cd web && npm run check 2>&1 | tail -5` → no new errors.
```bash
git add web/src/lib/links.ts
git commit -m "feat(links): DR-021 reciprocity + unresolved-links audit"
```

**Phase 1 checkpoint:** `node scripts/verify-links.mjs` green; engine ready for components.

---

## Phase 2 — Block components

Each component: `brand-*` tokens only, locale micro-copy via `Astro.currentLocale` map, wrapped in `Section`/`SectionHeading` where appropriate. Markup/classes adapt the prototype (`prototype-all-on-4-v2.html`) — read the matching CSS block there for spacing/structure, translate to Tailwind `brand-*`. Gate each: `npm run check` (0 new).

### Task 10: `InlineLinks` renderer + `SectionHeading` eyebrow

**Files:**
- Create: `web/src/components/blocks/InlineLinks.astro`
- Modify: `web/src/components/ui/SectionHeading.astro`

- [ ] **Step 1: `InlineLinks` — parse `[label](entity:slug)` and resolve**

```astro
---
// Renders a rich string: "[All-on-6](entity:all-on-6)" → resolved <a> or plain text (stub/unknown).
import { resolveLink } from '../../lib/links';
interface Props { text: string; idx: any; locale: string; }
const { text, idx, locale } = Astro.props;
const TOKEN = /\[([^\]]+)\]\(entity:([a-z0-9-]+)\)/g;
type Part = { t: 'text'; v: string } | { t: 'link'; label: string; href?: string };
const parts: Part[] = [];
let last = 0, m: RegExpExecArray | null;
while ((m = TOKEN.exec(text))) {
  if (m.index > last) parts.push({ t: 'text', v: text.slice(last, m.index) });
  const r = resolveLink({ linkTo: m[2], title: m[1] }, locale, 'inline', idx);
  parts.push({ t: 'link', label: m[1], href: r.href });   // href undefined for stub/unknown → plain text
  last = m.index + m[0].length;
}
if (last < text.length) parts.push({ t: 'text', v: text.slice(last) });
---
{parts.map((p) => p.t === 'text'
  ? p.v
  : p.href
    ? <a href={p.href} class="font-semibold text-brand-primary border-b border-dotted border-brand-secondary hover:text-brand-secondary">{p.label}</a>
    : <span>{p.label}</span>)}
```

- [ ] **Step 2: Add `eyebrow` to `SectionHeading`**

Read `web/src/components/ui/SectionHeading.astro`. Add an optional `eyebrow?: string` prop; when present render it above the heading as a `text-brand-secondary text-xs font-bold tracking-[2px] uppercase` line (the prototype's `.section-tag`). Keep existing `onDark` behavior.

- [ ] **Step 3: Verify + commit**

Run: `cd web && npm run check 2>&1 | tail -5` → no new errors.
```bash
git add web/src/components/blocks/InlineLinks.astro web/src/components/ui/SectionHeading.astro
git commit -m "feat(blocks): InlineLinks entity-token renderer + SectionHeading eyebrow"
```

### Task 11: `ProseBlock` (`prose` | `checklist`)

**Files:**
- Create: `web/src/components/blocks/ProseBlock.astro`

- [ ] **Step 1: Implement** — props = the `proseBlock` shape from `_shared.ts` + `{ idx, locale }`. Render `eyebrow`/`heading` via `SectionHeading`; each paragraph through `InlineLinks`; `bullets` as a styled list — `variant='checklist'` uses the prototype's `.feature-list` ✓ marker (`before:content-['✓'] text-brand-secondary`), `variant='prose'` a plain `<ul>`. `subsections` render as `<h3>` + paragraphs.

```astro
---
import SectionHeading from '../ui/SectionHeading.astro';
import InlineLinks from './InlineLinks.astro';
interface Props { block: any; idx: any; locale: string; }
const { block, idx, locale } = Astro.props;
const checklist = block.variant === 'checklist';
---
{block.heading && <SectionHeading eyebrow={block.eyebrow} title={block.heading} />}
{block.lead && <p class="text-lg text-brand-anchor font-medium mt-3"><InlineLinks text={block.lead} idx={idx} locale={locale} /></p>}
{block.paragraphs.map((p: string) => <p class="mt-4 text-brand-neutral-700 leading-relaxed"><InlineLinks text={p} idx={idx} locale={locale} /></p>)}
{block.bullets && (
  <ul class:list={["mt-4 space-y-2", checklist && "[&>li]:pl-8 [&>li]:relative"]}>
    {block.bullets.map((b: string) => (
      <li class:list={[checklist && "before:content-['✓'] before:absolute before:left-0 before:text-brand-secondary before:font-bold"]}>
        <InlineLinks text={b} idx={idx} locale={locale} />
      </li>
    ))}
  </ul>
)}
{block.subsections?.map((s: any) => (<div class="mt-6"><h3 class="font-display text-xl text-brand-anchor">{s.heading}</h3><p class="mt-2 text-brand-neutral-700"><InlineLinks text={s.body} idx={idx} locale={locale} /></p></div>))}
```

- [ ] **Step 2: Verify + commit** — `npm run check` (0 new).
```bash
git add web/src/components/blocks/ProseBlock.astro
git commit -m "feat(blocks): ProseBlock (prose/checklist) with inline links"
```

### Task 12: Remaining content blocks (batch)

Create each in `web/src/components/blocks/`. Props named in parens. All `brand-*` tokens; read the cited prototype CSS block for structure. Gate once at the end: `npm run check` (0 new) + commit.

- [ ] **`QuickFacts.astro`** (`{ facts }`) — `variant:'stats'` = the prototype `.facts-grid` (4-col stat band, `.fact-value`/`.fact-label`); `variant:'essentials'` = 5 rows always-visible + a `<details>` toggle ("ข้อมูลทางเทคนิค") listing `technical[]` (DR-033 order). Toggle label via locale map.
- [ ] **`RiskFactors.astro`** (`{ causes, idx, locale }`) — `groups[]` as subheaded blocks; each factor `name` (bold) + `mechanism` (InlineLinks) + optional `citation` superscript.
- [ ] **`TreatmentOptions.astro`** (`{ treatment, idx, locale }`) — `options[]` as named cards (`.concern-card`-style), `body` via InlineLinks.
- [ ] **`PricingTable.astro`** (`{ pricing }`) — prototype `.price-card`; `oldPrice` struck-through, tier `price` large, `includes[]` as ✓ perks; multiple tiers as a grid; `highlight` tier bordered `brand-secondary`.
- [ ] **`ExpertiseBox.astro`** (`{ expertise }`) — prototype `.expertise-box` (on-dark gradient via `brand-anchor`); `quote` styled `.quote`; `trustItems[]` 3-col grid.
- [ ] **`TechBadges.astro`** (`{ badges, idx, locale }`) — prototype `.tech-badges`; each badge `resolveLink(..., 'badge')`; **drop** badges whose state is stub/unknown (no href).
- [ ] **`DoctorReview.astro`** (`{ reviewer, locale }`) — name + credentials list + "ตรวจสอบโดย / Reviewed by" label (locale map) + reviewedDate.
- [ ] **`ReferencesBlock.astro`** (`{ references, locale }`) — numbered `<ol>`; items with `url` link out (`rel="nofollow"`), without url plain.
- [ ] **`Breadcrumb.astro`** (`{ trail, idx, locale }`) — resolve each crumb (`'breadcrumb'` surface); link only resolvable ancestors; last crumb is bold text. Emits nothing if `trail` empty.
- [ ] **`CtaInline.astro`** (`{ cta }`) — prototype `.cta-inline` (bordered band, text left + button right); button href via `resolveLink` or explicit href.

```bash
git add web/src/components/blocks/
git commit -m "feat(blocks): content + conversion blocks (QuickFacts, RiskFactors, TreatmentOptions, PricingTable, ExpertiseBox, TechBadges, DoctorReview, ReferencesBlock, Breadcrumb, CtaInline)"
```

### Task 13: `RelatedCluster` (tabbed)

**Files:**
- Create: `web/src/components/blocks/RelatedCluster.astro`

- [ ] **Step 1: Implement** (`{ cluster, pivot, idx, locale }`) — prototype `.related-cluster` + `.tabs` + `.card-grid`. For each tab call `resolveList({ surface:'cluster', curated: tab.items, pivot, edge: tab.edge, min:1, target:4 })`; **skip tabs whose result is `hidden`**; if all tabs hidden render nothing. Tab switching = the prototype's simple JS (toggle `.active` + show/hide grids), scoped `<script>`. Tab labels come from data (`tab.label`), already per-locale.

- [ ] **Step 2: Verify + commit** — `npm run check` (0 new).
```bash
git add web/src/components/blocks/RelatedCluster.astro
git commit -m "feat(blocks): tabbed RelatedCluster with per-tab backfill + empty-tab hiding"
```

**Phase 2 checkpoint:** all blocks compile; none rendered yet.

---

## Phase 3 — PageShell + Sidebar (two-column reading layout)

### Task 14: `PageShell` + `Sidebar` + ToC scrollspy

**Files:**
- Create: `web/src/components/layout/PageShell.astro`
- Create: `web/src/components/layout/Sidebar.astro`

- [ ] **Step 1: `PageShell`** — prototype `.layout` (`grid lg:grid-cols-[minmax(0,1fr)_300px] gap-12`, collapses to one column under `lg`, sidebar `order-2` on mobile). A `main` default `<slot/>` + a named `sidebar` slot. If the `sidebar` slot is empty, render single-column (`max-w-3xl`).

```astro
---
interface Props { hasSidebar?: boolean }
const { hasSidebar = true } = Astro.props;
---
<div class="container mx-auto px-5 py-14">
  <div class:list={["grid gap-12 items-start", hasSidebar ? "lg:grid-cols-[minmax(0,1fr)_300px]" : "max-w-3xl mx-auto"]}>
    <main class="min-w-0"><slot /></main>
    {hasSidebar && <aside class="lg:sticky lg:top-24 order-2 lg:order-none"><slot name="sidebar" /></aside>}
  </div>
</div>
```

- [ ] **Step 2: `Sidebar`** (`{ toc, sidebarRelated, sidebarCta, pivot, edge, idx, locale }`) — three boxes (prototype `.sidebar-box`): ToC (`toc[]` of `{ id, label }` → anchor links, scrollspy), compact related (`resolveList({surface:'sidebar', curated: sidebarRelated, pivot, edge, min:2, target:4})` → hide box if `hidden`), mini-CTA (`sidebarCta`). **`edge` is passed in by the template layout — `data.sidebarRelatedEdge ?? TEMPLATE_BY_KEY[data.template].sidebarEdge` — never hardcoded** (so concern backfills on `treats`, service on `alternative_to`, etc.). ToC title / labels via locale map.

- [ ] **Step 3: ToC scrollspy script** — adapt the prototype's scroll listener (`web/src/components/layout/Sidebar.astro` scoped `<script>`): on scroll, mark the `.toc-list a` whose section is in view `active` (`bg-brand-paper text-brand-anchor font-bold border-l-brand-secondary`).

- [ ] **Step 4: Verify + commit** — `npm run check` (0 new).
```bash
git add web/src/components/layout/
git commit -m "feat(layout): PageShell two-column reading layout + sticky Sidebar w/ ToC scrollspy"
```

---

## Phase 4 — Schema @graph + Base jsonLd

### Task 15: `lib/schema.ts` + `Base` `jsonLd` prop

**Files:**
- Create: `web/src/lib/schema.ts`
- Modify: `web/src/layouts/Base.astro`

- [ ] **Step 1: `buildPageSchema(data, locale, url)` — MAP-DRIVEN (universal, not per-template branched)** — a `SCHEMA_NODE_BUILDERS` map keyed by `schemaType` produces the Tier-2 entity node. The page node, `BreadcrumbList`, `SpeakableSpecification`, and `reviewer`→`reviewedBy`/`lastReviewed` are emitted **identically for every template**. Adding a template = add one map entry (keyed by its registry `schemaType`), never edit an if-chain.

```ts
// web/src/lib/schema.ts
type NodeBuilder = (data: any, url: string) => any;

// Tier-2 entity node per schemaType. Extend this map to add a template — nothing else changes.
const SCHEMA_NODE_BUILDERS: Record<string, NodeBuilder> = {
  MedicalCondition: (d, url) => ({ '@type': 'MedicalCondition', '@id': `${url}#entity`, name: d.meta.title }),
  Service:          (d, url) => ({ '@type': ['Service', 'MedicalProcedure'], '@id': `${url}#entity`, name: d.meta.title }),
  // future: Article, MedicalDevice, Person, LocalBusiness, CollectionPage, DefinedTerm ...
};
// Page-node @type per schemaType (defaults to WebPage).
const PAGE_TYPE: Record<string, string> = { MedicalCondition: 'MedicalWebPage' };

export function buildPageSchema(data: any, locale: string, url: string) {
  const graph: any[] = [];
  const entity = SCHEMA_NODE_BUILDERS[data.schemaType]?.(data, url);
  if (entity) graph.push(entity);
  graph.push({ '@type': PAGE_TYPE[data.schemaType] ?? 'WebPage', '@id': `${url}#page`, url, name: data.meta.title,
    ...(entity && { mainEntity: { '@id': `${url}#entity` } }),
    ...(data.reviewer && { reviewedBy: { '@type': 'Person', name: data.reviewer.name }, lastReviewed: data.reviewer.reviewedDate }),
    speakable: { '@type': 'SpeakableSpecification', cssSelector: ['.speakable-hero'] } });
  if (data.breadcrumb?.length) graph.push({ '@type': 'BreadcrumbList', '@id': `${url}#breadcrumbs`,
    itemListElement: data.breadcrumb.map((b: any, i: number) => ({ '@type': 'ListItem', position: i + 1, name: b.label })) });
  return { '@context': 'https://schema.org', '@graph': graph };
}
```

- [ ] **Step 2: `Base` `jsonLd` prop** — add optional `jsonLd?: object`; when present inject `<script type="application/ld+json" is:inline set:html={JSON.stringify(jsonLd)} />` in `<head>` alongside existing Tier-1 schema. Don't disturb existing props (`robots`, `stickyCta`, hreflang).

- [ ] **Step 3: Verify + commit** — `npm run check` (0 new).
```bash
git add web/src/lib/schema.ts web/src/layouts/Base.astro
git commit -m "feat(schema): buildPageSchema @graph (Tier-2 + Breadcrumb + Speakable) + Base jsonLd prop"
```

---

## Phase 5 — Universal shell + full template layouts

### Task 15B: `TemplateShell.astro` (universal frame — used by EVERY template)

**Files:**
- Create: `web/src/layouts/templates/TemplateShell.astro`

This is the spec's D12 "universal-by-construction" frame: the ONE place Base + schema + breadcrumb + hero + quickFacts + PageShell + Sidebar + RelatedCluster + FinalCta + link wiring live. Per-template layouts only supply body blocks.

- [ ] **Step 1: Implement the shell**

```astro
---
// web/src/layouts/templates/TemplateShell.astro — universal frame for all templates.
import Base from '../Base.astro';
import Breadcrumb from '../../components/blocks/Breadcrumb.astro';
import Hero from '../../components/sections/Hero.astro';
import QuickFacts from '../../components/blocks/QuickFacts.astro';
import PageShell from '../../components/layout/PageShell.astro';
import Sidebar from '../../components/layout/Sidebar.astro';
import RelatedCluster from '../../components/blocks/RelatedCluster.astro';
import FinalCta from '../../components/sections/FinalCta.astro';
import { buildPageSchema } from '../../lib/schema';
import { TEMPLATE_BY_KEY } from '../../lib/templates';

interface Props { data: any; locale: string; idx: any; toc?: { id: string; label: string }[]; robots?: string; }
const { data, locale, idx, toc = [], robots } = Astro.props;
const url = Astro.url.pathname;
const jsonLd = buildPageSchema(data, locale, url);
const pivot = data.primaryEntity;
const sidebarEdge = data.sidebarRelatedEdge ?? TEMPLATE_BY_KEY[data.template]?.sidebarEdge;
const hasSidebar = !!(toc.length || data.sidebarRelated || data.sidebarCta);
---
<Base title={data.meta.title} description={data.meta.description} jsonLd={jsonLd} robots={robots} stickyCta>
  {data.breadcrumb && <Breadcrumb trail={data.breadcrumb} idx={idx} locale={locale} />}
  <Hero {...data.hero} class="speakable-hero" />
  {data.quickFacts && <QuickFacts facts={data.quickFacts} locale={locale} />}
  <PageShell hasSidebar={hasSidebar}>
    <slot />
    {hasSidebar && (
      <Sidebar slot="sidebar" toc={toc} sidebarRelated={data.sidebarRelated} sidebarCta={data.sidebarCta}
               pivot={pivot} edge={sidebarEdge} idx={idx} locale={locale} />
    )}
  </PageShell>
  {data.relatedCluster && <RelatedCluster cluster={data.relatedCluster} pivot={pivot} idx={idx} locale={locale} />}
  {data.finalCta && <FinalCta {...data.finalCta} />}
</Base>
```

- [ ] **Step 2: Verify + commit** — `npm run check` (0 new). (Hero `class` pass-through: if `Hero` doesn't accept a class prop, add a `speakable` boolean prop instead that sets the `.speakable-hero` class on its summary.)
```bash
git add web/src/layouts/templates/TemplateShell.astro
git commit -m "feat(templates): universal TemplateShell frame (D12 universal-by-construction)"
```

### Task 16: `Concern.astro` (T1, full — body only)

**Files:**
- Modify: `web/src/layouts/templates/Concern.astro`

- [ ] **Step 1: Compose body inside the shell** — replace the stub. Compute `idx = await getPublishedIndex()` and `toc` (the in-page section ids/labels). Render `<TemplateShell data={data} locale={locale} idx={idx} toc={toc}>` with the **body blocks only** as default-slot children (the shell handles breadcrumb/hero/quickFacts/sidebar/related/finalCta/schema): `ProseBlock(definition)`, `RiskFactors(causes)`, `ProseBlock(symptoms, variant:checklist)`, `ProseBlock(diagnosis)`, `TreatmentOptions(treatment)`, `clinicalInsight?`, `BeforeAfter?`, `Reviews?`, `FaqBlock`, `DoctorReview`, `ReferencesBlock` — each guarded by presence, each passed `idx`/`locale`.

```astro
---
import TemplateShell from './TemplateShell.astro';
import { getPublishedIndex } from '../../lib/pages';
import ProseBlock from '../../components/blocks/ProseBlock.astro';
import RiskFactors from '../../components/blocks/RiskFactors.astro';
import TreatmentOptions from '../../components/blocks/TreatmentOptions.astro';
import DoctorReview from '../../components/blocks/DoctorReview.astro';
import ReferencesBlock from '../../components/blocks/ReferencesBlock.astro';
import FaqBlock from '../../components/FaqBlock.astro';
interface Props { data: any; locale: string; robots?: string; }   // robots passed through for preview noindex
const { data, locale, robots } = Astro.props;
const idx = await getPublishedIndex();
const toc = [
  { id: 'definition', label: data.definition?.heading }, { id: 'causes', label: data.causes?.heading },
  { id: 'symptoms', label: data.symptoms?.heading }, { id: 'diagnosis', label: data.diagnosis?.heading },
  { id: 'treatment', label: data.treatment?.heading }, { id: 'faq', label: 'FAQ' },
].filter((t) => t.label);
---
<TemplateShell data={data} locale={locale} idx={idx} toc={toc} robots={robots}>
  <section id="definition"><ProseBlock block={data.definition} idx={idx} locale={locale} /></section>
  <section id="causes"><RiskFactors causes={data.causes} idx={idx} locale={locale} /></section>
  <section id="symptoms"><ProseBlock block={{ ...data.symptoms, variant: 'checklist' }} idx={idx} locale={locale} /></section>
  <section id="diagnosis"><ProseBlock block={data.diagnosis} idx={idx} locale={locale} /></section>
  <section id="treatment"><TreatmentOptions treatment={data.treatment} idx={idx} locale={locale} /></section>
  {data.faq?.length > 0 && <section id="faq"><FaqBlock items={data.faq} /></section>}
  {data.reviewer && <DoctorReview reviewer={data.reviewer} locale={locale} />}
  {data.references?.length > 0 && <ReferencesBlock references={data.references} locale={locale} />}
</TemplateShell>
```

- [ ] **Step 2: Verify + commit** — `npm run check` (0 new). (Renders verified in Phase 6.)
```bash
git add web/src/layouts/templates/Concern.astro
git commit -m "feat(templates): full Concern (T1) body composed via TemplateShell"
```

### Task 17: `Service.astro` (T5, full prototype parity — body only)

**Files:**
- Modify: `web/src/layouts/templates/Service.astro`

- [ ] **Step 1: Compose body inside the shell** — same pattern as Task 16 (incl. `interface Props { data; locale; robots? }` and passing `robots` through to `TemplateShell`): `idx`/`toc`, `<TemplateShell …>` with the **body blocks only**: `ProseBlock(definition)`, `ProcessSteps(process)`, `whoFor` (ProseBlock OR concern-cards per its shape), `TechBadges`, `ExpertiseBox`, `CtaInline(midCta)`, `PricingTable`, `comparison?`, `FaqBlock`. Reuse existing `ProcessSteps`. Wrap each in a `<section id>` matching its `toc` entry. The shell supplies breadcrumb/hero/quickFacts(stats)/sidebar/relatedCluster/finalCta/schema.

- [ ] **Step 2: Verify + commit** — `npm run check` (0 new).
```bash
git add web/src/layouts/templates/Service.astro
git commit -m "feat(templates): full Service (T5) body composed via TemplateShell — prototype parity"
```

---

## Phase 6 — Demo fixtures + render verification

### Task 18: Kitchen-sink demo fixtures (T5 + T1, ×3 locales)

**Files:**
- Create: `web/src/content/service/{th,en,zh-cn}/demo.yaml`
- Create: `web/src/content/concern/{th,en,zh-cn}/demo.yaml`

- [ ] **Step 1: Author the T5 demo (th)** — model on the All-on-4 prototype: every block populated, including `breadcrumb`, `hero.badge`, `quickFacts.variant:stats`, `definition.paragraphs` with **entity-token inline links** (`[All-on-6](entity:all-on-6)`, `[Zygomatic Implant](entity:zygomatic-implant)`, `[ปลูกกระดูก](entity:bone-grafting)`), `process` (7 steps), `whoFor.cards` (3), `techBadges` (mix of seeded entities), `expertise`, `midCta`, `pricing` (tiers), `sidebarRelated`, `sidebarCta`, `relatedCluster.tabs` (alternatives/cases/concerns/articles), `faq`, `reviewer`, `finalCta`. **Deliberately reference 2–3 unpublished entities** (e.g. `all-on-4` itself + `overdenture`) so stub/backfill fallback shows on screen. `published: true`.

- [ ] **Step 2: Translate to en + zh-cn** — same structure, localized strings; keep `linkTo` slugs identical (they're locale-independent). Generic UI labels are NOT in the fixture (they come from component locale maps).

- [ ] **Step 3: Author the T1 concern demo (×3)** — subject = peri-implantitis (model on `docs/master-example-peri-implantitis.html`): `quickFacts.variant:essentials` (+technical toggle), `definition`, `causes.groups`, `symptoms` (checklist), `diagnosis`, `treatment.options`, `clinicalInsight`, `faq`, `reviewer`, `references`, `relatedCluster`, sidebar. Inline links to seeded entities. `published: true`.

- [ ] **Step 4: Render verification**

Run: `cd web && npm run build && npm run preview` (note the local URL). In a browser, load all six:
`/` is the homepage — demos are at the preview routes (Phase 7) OR temporarily at `/<slug>/` if you give them a non-`demo` slug for this check. For now verify via build output:
Run: `npm run build 2>&1 | tail -20` → succeeds; the link audit warnings (`[links] N unresolved`, `[DR-021] ...`) print for the deliberate stubs.

- [ ] **Step 5: Commit**
```bash
git add web/src/content/service web/src/content/concern
git commit -m "feat(content): kitchen-sink demo fixtures for T5 + T1 (×3 locales, incl. stub targets)"
```

---

## Phase 7 — Preview harness

### Task 19: Preview routes + gallery (×3 locales)

**Files:**
- Create: `web/src/pages/preview/index.astro` + `web/src/pages/en/preview/index.astro` + `web/src/pages/zh-cn/preview/index.astro`
- Create: `web/src/pages/preview/[template].astro` + `web/src/pages/en/preview/[template].astro` + `web/src/pages/zh-cn/preview/[template].astro`

- [ ] **Step 1: Preview render route (TH)**

```astro
---
// web/src/pages/preview/[template].astro
import { TEMPLATES, TEMPLATE_BY_KEY } from '../../lib/templates';
import { getDemo } from '../../lib/pages';
export async function getStaticPaths() {
  return TEMPLATES.map((t) => ({ params: { template: t.key } }));
}
const { template } = Astro.params;
const data = await getDemo(template as any, 'th');
const Template = TEMPLATE_BY_KEY[template!].component;
---
<Template data={data} locale="th" robots="noindex,nofollow" />
```
EN/zh-cn variants: `getDemo(template,'en'|'zh-cn')` and matching `locale`. The `robots` prop flows layout → `TemplateShell` → `Base` (the pass-through added in Tasks 16/17), forcing `noindex,nofollow` on every preview page regardless of Base's default.

- [ ] **Step 2: Preview gallery (TH)** — `pages/preview/index.astro`: iterate `TEMPLATES`, render a card per template (code, name, schemaType) linking to `/preview/<key>/`, `/en/preview/<key>/`, `/zh-cn/preview/<key>/`. Wrap in `Base` with `robots="noindex,nofollow"`. EN/zh-cn galleries mirror.

- [ ] **Step 3: Full render verification**

Run: `cd web && npm run build && npm run preview`. Load `/preview/`, `/en/preview/`, `/zh-cn/preview/` and each demo. Confirm, in all 3 locales: every block renders; PageShell sidebar + ToC scrollspy work; tabbed RelatedCluster switches; **stub inline links render as plain text, stub badges dropped, sparse sidebar backfills or hides — no dead links, no empty boxes**; no TH copy leaking onto EN/zh-cn. View-source: demo emits Tier-2 `@graph` + BreadcrumbList + FAQPage; preview pages carry `noindex,nofollow`.

- [ ] **Step 4: Commit**
```bash
git add web/src/pages/preview web/src/pages/en/preview web/src/pages/zh-cn/preview
git commit -m "feat(preview): noindex template gallery + per-template preview routes (×3 locales)"
```

---

## Phase 8 — Page-Type → T# mapping artifact

### Task 20: Mapping proposal doc

**Files:**
- Create: `docs/content-templates/page-type-mapping.md`

- [ ] **Step 1: Write the proposal** — table per sitemap section (skim `content-plan/sitemap.md` sections 3/4/5/6/7/8): columns `Sitemap Section | Example pages | Proposed Page Type | → T# | schema.org | Rationale`. Cover at least: Section 3 Services → T5/T2x, Section 4 Tech → T4, Section 5 Concerns → T1, Section 6 Knowledge → T6/T6a, Section 6.5 FAQ → FAQ page, Section 7 Cases → T8, Section 8 Branches → T10. Mark items needing operator decision. State explicitly: proposal only, does not edit the sitemap.

- [ ] **Step 2: Commit**
```bash
git add docs/content-templates/page-type-mapping.md
git commit -m "docs(templates): proposed Page-Type → T# mapping for operator review"
```

---

## Phase 9 — Final verification + handback

### Task 21: Full acceptance pass (spec §9)

- [ ] **Step 1:** `cd web && npm run check 2>&1 | tail -20` → **0 new errors** beyond the documented ~19 pre-existing.
- [ ] **Step 2:** `npm run build` → succeeds; link audit prints expected unresolved/non-reciprocal warnings for the deliberate demo stubs (no unexpected ones).
- [ ] **Step 3:** `node scripts/verify-links.mjs` → all green.
- [ ] **Step 4:** `npm run preview` → manual pass of the §9.3 checklist across all 3 locales (blocks, sidebar/ToC, tabs, link fallback, no leakage).
- [ ] **Step 5:** Validate one demo's JSON-LD via Rich Results test (paste view-source `@graph`) → no errors.
- [ ] **Step 6:** Update `docs/HANDOVER-content-templates.md` "what exists" section + the memory file `homepage-component-library.md` → note the template system + link engine now exist. Record proven pattern toward the EYWA Content_Templates spec (cross-brand directive). Commit.

```bash
git add docs/ ; git commit -m "docs: record content-template system + link engine in handover/memory"
```

---

## Self-review notes (author)

- **Spec coverage:** §4.1 schema (incl. `primaryEntity` pivot + taxonomy) → Tasks 1–2; §4.5 registry (w/ `sidebarEdge`) → Task 3; §4.6 loaders+index → Task 4; §4.7 routing → Task 5; §5 link engine (registry/resolver/backfill/audit/inline) → Tasks 6–9, 10; §4.3 blocks → Tasks 10–13; §4.8 PageShell → Task 14; §4.9 map-driven schema → Task 15; §4.4 `TemplateShell` (D12 universal frame) → Task 15B; §4.4 layouts (body-only) → Tasks 16–17; §6 harness → Tasks 18–19; §7 mapping → Task 20; §9 verification → Task 21. All sections mapped.
- **Universal-by-construction (D12) — audited:** link engine (`resolveLink`/`resolveList`) takes a `surface`, never a template; `TemplateShell` (Task 15B) is the single frame every template inherits; `buildPageSchema` (Task 15) is a `schemaType→builder` map; sidebar backfill edge is registry/data-driven (Task 14/15B); loaders + dispatcher + preview iterate the registry. **A new template = collection extending `baseFields` + one registry row + a thin body layout + a demo. No universal logic is re-implemented per template.**
- **No test runner:** link logic verified via `node scripts/verify-links.mjs`; everything else via `npm run check`/`build`/`preview` (matches spec §9 — no framework introduced).
- **Type consistency:** `resolveLink`/`resolveList`/`PublishedIndex`/`Resolved` names match across Tasks 7–8 and consumers (10–17). `getPublishedIndex` (Task 4) ↔ `idx` consumers. `TEMPLATE_BY_KEY` (Task 3) ↔ dispatchers (Task 5) + preview (Task 19).
- **Known soft spots for the executor:** (a) confirm the Node TS-import method in Task 7 Step 2 on the installed Node version; (b) confirm whether a YAML vite plugin already exists before Task 6 Step 3; (c) leaf-block markup is specified by prop-contract + prototype reference rather than full inline CSS (DRY against the existing prototype) — read the cited `.class` in the prototype per block.
