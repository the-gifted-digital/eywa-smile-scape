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

export const collections = { pages, articles };
