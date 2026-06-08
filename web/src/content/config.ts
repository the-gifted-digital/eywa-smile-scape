// SmileScape — Content Collections schema (Astro 4).
//
// SKELETON shape. The fields mirror the content-plan sitemap 7-column model
// (#/Page Name/Layer/Tier/Funnel/Page Type/Primary Entity) plus body content,
// relations (DR-021 internal linking) and FAQ (FaqBlock / FAQPage schema).
//
// This is the Astro-side reflection of the Supabase "Page System" group
// (Schema_Overview_EYWA). When the real DB lands, a build step can hydrate
// these collections from Supabase; until then, Markdown files are the source.

import { defineCollection, z } from 'astro:content';

// Sitemap taxonomy enums (kept loose as strings where the vocabulary is still wide).
const tier = z.enum(['A', 'B', 'C', 'D']);
const funnel = z.enum(['TOFU', 'MOFU', 'BOFU', 'NAV', 'TRUST']);
const schemaType = z.enum([
  'WebPage',
  'MedicalWebPage',
  'MedicalClinic',
  'Dentist',
  'Service',
  'MedicalProcedure',
  'FAQPage',
  'Article',
  'AboutPage',
  'ContactPage',
]);

const faqItem = z.object({
  q: z.string(),
  a: z.string(),
});

// ---------- Pages (service hubs, procedures, trust, nav) ----------
const pages = defineCollection({
  type: 'content',
  schema: z.object({
    // Identity
    title: z.string(), // TH-first headline
    title_en: z.string().optional(),
    summary: z.string(),

    // Sitemap taxonomy (content-plan/sitemap.md)
    section: z.string().optional(), // e.g. "3.5.1" — the sitemap page id
    layer: z.string().optional(), // L1..L7
    tier: tier.optional(),
    funnel: funnel.optional(),
    page_type: z.string().optional(), // e.g. "Service Hub", "Procedure", "Pillar"
    primary_entity: z.string().optional(), // entity slug from content-plan/entities.md

    // Relations (DR-021 internal linking — render point: <RelatedContent>)
    related_pages: z.array(z.string()).default([]), // slugs of other `pages`
    related_entities: z.array(z.string()).default([]), // entity slugs

    // FAQ (render point: <FaqBlock>; emits FAQPage JSON-LD)
    faq: z.array(faqItem).default([]),

    // SEO / schema
    schema_type: schemaType.default('WebPage'),
    canonical: z.string().optional(),
    hero_image: z.string().optional(), // R2/CF URL (DR-035) — binary lives in R2, this is the URL only

    // Workflow
    published: z.boolean().default(false),
    updated_at: z.coerce.date().optional(),
  }),
});

// ---------- Articles (knowledge / blog / citation content) ----------
const articles = defineCollection({
  type: 'content',
  schema: z.object({
    title: z.string(),
    title_en: z.string().optional(),
    summary: z.string(),
    featured_answer: z.string().optional(), // answer-engine snippet (GEO/AEO)
    primary_entity: z.string().optional(),
    related_pages: z.array(z.string()).default([]),
    related_articles: z.array(z.string()).default([]),
    faq: z.array(faqItem).default([]),
    schema_type: schemaType.default('Article'),
    hero_image: z.string().optional(),
    published: z.boolean().default(false),
    published_at: z.coerce.date().optional(),
    updated_at: z.coerce.date().optional(),
  }),
});

// ---------- Home (single composed landing page per locale) ----------
const imageRef = z.object({
  src: z.string().optional(),   // undefined or "placeholder:..." → placeholder box (DR-035 swap point)
  alt: z.string(),
  label: z.string().optional(), // placeholder badge text
});
const cta = z.object({ label: z.string(), href: z.string() });

const home = defineCollection({
  type: 'data',
  schema: z.object({
    meta: z.object({ title: z.string(), description: z.string() }),
    hero: z.object({
      eyebrow: z.string(),
      title: z.string(),
      body: z.string(),
      primaryCta: cta,
      secondaryCta: cta,
      image: imageRef,
    }),
    trustBar: z.array(z.object({ label: z.string() })),
    pillars: z.array(z.object({ icon: z.string(), title: z.string(), body: z.string() })),
    blueDiamond: z.object({
      eyebrow: z.string(),
      title: z.string(),
      priceLabel: z.string(),
      bullets: z.array(z.string()),
      image: imageRef,
      cta,
    }),
    services: z.array(z.object({ title: z.string(), summary: z.string(), href: z.string(), image: imageRef })),
    partners: z.array(z.object({ name: z.string(), logo: imageRef })),
    founders: z.array(z.object({ name: z.string(), role: z.string(), nickname: z.string().optional(), credentials: z.array(z.string()), image: imageRef })),
    doctors: z.array(z.object({ name: z.string(), role: z.string(), image: imageRef })),
    process: z.array(z.object({ step: z.number(), title: z.string(), body: z.string(), image: imageRef })),
    beforeAfter: z.array(z.object({ image: imageRef, caption: z.string() })),
    reviews: z.array(z.object({ quote: z.string(), name: z.string(), stars: z.number() })),
    video: z.object({ poster: imageRef, src: z.string().optional(), label: z.string() }),
    branches: z.array(z.object({ name: z.string(), mrt: z.string(), address: z.string(), mapUrl: z.string() })),
    faq: z.array(faqItem),
    finalCta: z.object({ title: z.string(), body: z.string(), cta }),
  }),
});

// ---------- Assessment (Implant Readiness Check, per locale) ----------
const assessmentOption = z.object({ label: z.string(), value: z.string() });
const assessmentQuestion = z.object({
  id: z.string(), eyebrow: z.string(), text: z.string(),
  options: z.array(assessmentOption).min(2),
});
const assessmentTier = z.object({
  badge: z.string(), title: z.string(), summary: z.string(),
  steps: z.array(z.string()).default([]),
  ctaLabel: z.string(), ctaHref: z.string(),
});
const assessmentRec = z.object({
  text: z.string(), topic: z.string(),
  href: z.string().optional(), published: z.boolean().default(false),
});
const assessment = defineCollection({
  type: 'data',
  schema: z.object({
    meta: z.object({ title: z.string(), description: z.string() }),
    ui: z.object({ progressLabel: z.string(), backLabel: z.string(), faqHeading: z.string() }),
    intro: z.object({
      eyebrow: z.string(), title: z.string(), body: z.string(),
      timeNote: z.string(), startLabel: z.string(), disclaimer: z.string(),
    }),
    questions: z.array(assessmentQuestion),
    teaser: z.object({
      resultLabel: z.string(), inviteTitle: z.string(),
      inviteBody: z.string(), buttonLabel: z.string(), microcopy: z.string(),
    }),
    gate: z.object({
      title: z.string(), body: z.string(),
      nameLabel: z.string(), phoneLabel: z.string(), emailLabel: z.string(),
      sexLabel: z.string(), sexOptions: z.array(z.string()),
      pdpa: z.string(), submitLabel: z.string(),
      sending: z.string(), success: z.string(), error: z.string(),
    }),
    tiers: z.object({
      A: assessmentTier, B: assessmentTier, C: assessmentTier,
      info: assessmentTier, minor: assessmentTier,
    }),
    recommendations: z.record(assessmentRec),
    relatedContent: z.object({ onScreen: z.boolean().default(true), email: z.boolean().default(false) }),
    reportLabels: z.object({
      whyTitle: z.string(), nextTitle: z.string(), relatedTitle: z.string(),
      fallbackLabel: z.string(), fallbackHref: z.string(), errorNote: z.string(),
    }),
    references: z.array(z.object({ label: z.string(), href: z.string().optional() })),
    faq: z.array(faqItem),
  }),
});

export const collections = { pages, articles, home, assessment };
