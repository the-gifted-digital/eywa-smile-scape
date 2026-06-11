# Site Header & Footer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the placeholder header/footer in `web/src/layouts/Base.astro` with production `SiteHeader.astro` + `SiteFooter.astro` (two-tier desktop header with two mega panels, mobile drawer header, light desktop+mobile footers), driven by a per-locale data module.

**Architecture:** A typed data module (`lib/site-nav.ts`) holds all header/footer content per locale (TH + EN authored; zh-cn falls back to EN until translated) plus helpers. A tiny `ui/Icon.astro` DRYs all inline SVGs. Two data-driven components (`SiteHeader.astro`, `SiteFooter.astro`) render the regions with Tailwind token classes + a small scoped `<style>` for animations; `Base.astro` imports them. Behavior (mega-panel open, scroll-collapse, drawer, accordions, language dropdown) lives in component-scoped `<script>`, gated by `prefers-reduced-motion`.

**Tech Stack:** Astro 4, Tailwind 3 (token classes only — DR-029), self-hosted fonts (Cabinet Grotesk / Google Sans), vitest. Source of design truth: `docs/superpowers/specs/2026-06-12-header-footer-design.md`.

**Pre-flight:** `cd web` for all `npm` commands. The repo has ~19 pre-existing `astro check` errors in `Landing.astro` / `dental-implant.astro` / `AssessmentApp.astro` — these are the baseline; "no NEW errors" is the bar. Branch is `web-skeleton` (not default) — commit directly. Keep `robots: noindex`.

---

## File Structure

| File | Responsibility | Action |
|---|---|---|
| `web/src/components/ui/Icon.astro` | Single inline-SVG icon set (`name` prop) | Create |
| `web/src/lib/site-nav.ts` | Types + per-locale header/footer content + `getHeader`/`getFooter`/`getAltLocales`/`pick` | Create |
| `web/src/lib/site-nav.test.ts` | Unit tests for the pure helpers | Create |
| `web/src/components/SiteFooter.astro` | Light footer (responsive: desktop 5-col / mobile stack) | Create |
| `web/src/components/SiteHeader.astro` | Two-tier desktop header + 2 mega panels + mobile bar/drawer + behavior | Create |
| `web/src/layouts/Base.astro` | Import + render the two components; drop inline header/footer + dead maps | Modify |

Logos reuse the existing public assets (`/images/lp/logo-smilescape.png` header, `/images/lp/logo-stacked.png` footer — shown in natural colour on the light footer). Moving them to `src/assets` + `astro:assets` is a documented follow-up (spec §1), out of scope here.

---

## Task 1: Icon component

**Files:**
- Create: `web/src/components/ui/Icon.astro`

- [ ] **Step 1: Create the icon component**

```astro
---
// Icon.astro — single source for inline SVGs used by header/footer (DRY).
// Usage: <Icon name="line" class="w-5 h-5" />  — colour via currentColor.
interface Props { name: keyof typeof paths; class?: string; }
const { name, class: className = '' } = Astro.props;

const paths = {
  facebook: '<path fill="currentColor" d="M14 9h3V5h-3c-2.2 0-4 1.8-4 4v2H7v4h3v6h4v-6h3l1-4h-4V9c0-.6.4-1 1-1z"/>',
  instagram: '<rect x="3" y="3" width="18" height="18" rx="5" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="12" cy="12" r="4" fill="none" stroke="currentColor" stroke-width="2"/><circle cx="17.5" cy="6.5" r="1" fill="currentColor"/>',
  tiktok: '<path fill="currentColor" d="M16 3c.3 2 1.6 3.6 3.6 3.9V10c-1.4 0-2.7-.4-3.7-1.1v6.3c0 3.2-2.6 5.8-5.8 5.8S4.3 18.4 4.3 15.2c0-2.9 2.1-5.3 4.9-5.7v3.2a2.6 2.6 0 1 0 1.8 2.5V3H16z"/>',
  line: '<path fill="currentColor" d="M19.365 9.863c.349 0 .63.285.63.63 0 .345-.281.63-.63.63h-1.755v1.125h1.755c.349 0 .63.283.63.63 0 .344-.281.629-.63.629h-2.386c-.345 0-.627-.285-.627-.629V8.108c0-.345.282-.63.63-.63h2.386c.346 0 .627.285.627.63 0 .349-.281.63-.63.63h-1.755v1.125h1.755zm-3.855 3.016c0 .27-.174.51-.432.596-.064.021-.133.031-.199.031-.211 0-.391-.09-.51-.25l-2.443-3.317v2.94c0 .344-.279.629-.631.629-.346 0-.626-.285-.626-.629V8.108c0-.27.173-.51.43-.595.06-.023.136-.033.194-.033.195 0 .375.105.495.254l2.462 3.33V8.108c0-.345.282-.63.63-.63.345 0 .63.285.63.63v4.771zm-5.741 0c0 .344-.282.629-.631.629-.345 0-.627-.285-.627-.629V8.108c0-.345.282-.63.63-.63.346 0 .628.285.628.63v4.771zm-2.466.629H4.917c-.345 0-.63-.285-.63-.629V8.108c0-.345.285-.63.63-.63.348 0 .63.285.63.63v4.141h1.756c.348 0 .629.283.629.63 0 .344-.282.629-.629.629M24 10.314C24 4.943 18.615.572 12 .572S0 4.943 0 10.314c0 4.811 4.27 8.842 10.035 9.608.391.082.923.258 1.058.59.12.301.079.766.038 1.08l-.164 1.02c-.045.301-.24 1.186 1.049.645 1.291-.539 6.916-4.078 9.436-6.975 1.305-1.43 1.928-2.882 1.928-4.485z"/>',
  chevron: '<path d="M6 9l6 6 6-6" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"/>',
  globe: '<circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="2"/><path d="M3 12h18M12 3c2.5 2.7 2.5 15.3 0 18M12 3c-2.5 2.7-2.5 15.3 0 18" fill="none" stroke="currentColor" stroke-width="2"/>',
  phone: '<path fill="currentColor" d="M6.6 10.8a15.5 15.5 0 0 0 6.6 6.6l2.2-2.2a1 1 0 0 1 1-.24c1.1.37 2.3.57 3.6.57a1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A17 17 0 0 1 3 4a1 1 0 0 1 1-1h3.5a1 1 0 0 1 1 1c0 1.2.2 2.4.57 3.6a1 1 0 0 1-.24 1l-2.2 2.2z"/>',
  clock: '<circle cx="12" cy="12" r="9" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 7v5l3 2" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"/>',
  check: '<path d="M20 6L9 17l-5-5" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"/>',
  external: '<path d="M7 17L17 7M17 7H9M17 7v8" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>',
  close: '<path d="M6 6l12 12M18 6L6 18" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"/>',
  menu: '<path d="M4 7h16M4 12h16M4 17h16" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round"/>',
  dot: '<circle cx="12" cy="12" r="4" fill="currentColor"/>',
} as const;
---
<svg viewBox="0 0 24 24" class={className} aria-hidden="true" set:html={paths[name]} />
```

- [ ] **Step 2: Verify it type-checks**

Run: `cd web && npm run check 2>&1 | tail -5`
Expected: no NEW errors referencing `Icon.astro`.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/ui/Icon.astro
git commit -m "feat(ui): Icon component — single inline-SVG set for header/footer"
```

---

## Task 2: Site-nav data module (+ tests)

**Files:**
- Create: `web/src/lib/site-nav.ts`
- Test: `web/src/lib/site-nav.test.ts`

- [ ] **Step 1: Write the failing test**

```ts
// web/src/lib/site-nav.test.ts
import { describe, it, expect } from 'vitest';
import { pick, getHeader, getFooter, getAltLocales } from './site-nav';

describe('pick', () => {
  it('returns the requested locale when present', () => {
    expect(pick({ th: 'ก', en: 'a' }, 'en')).toBe('a');
  });
  it('falls back to en when locale missing', () => {
    expect(pick({ th: 'ก', en: 'a' }, 'zh-cn')).toBe('a');
  });
  it('falls back to th when en also missing', () => {
    expect(pick({ th: 'ก' }, 'zh-cn')).toBe('ก');
  });
});

describe('getHeader', () => {
  it('has both mega panels with the flagship first', () => {
    const h = getHeader('th');
    const panels = h.nav.filter((n) => n.panel).map((n) => n.panel);
    expect(panels).toEqual(['implant', 'services']);
    expect(h.megaPanels.implant.promo).toBeTruthy();
  });
  it('marks unbuilt service links as soon', () => {
    const h = getHeader('th');
    const services = h.megaPanels.services.columns.flatMap((c) => c.links);
    expect(services.some((l) => l.soon)).toBe(true);
  });
});

describe('getFooter', () => {
  it('has two branches with phone + map', () => {
    const f = getFooter('th');
    expect(f.branches).toHaveLength(2);
    expect(f.branches[0].phoneTel).toBe('+66984624949');
    expect(f.branches[0].mapUrl).toMatch(/^https?:\/\//);
  });
});

describe('getAltLocales', () => {
  it('builds per-locale URLs from a non-default path', () => {
    const alt = getAltLocales('/en/implant-check/', 'https://go.example.com');
    expect(alt.th).toBe('https://go.example.com/implant-check/');
    expect(alt.en).toBe('https://go.example.com/en/implant-check/');
    expect(alt['zh-cn']).toBe('https://go.example.com/zh-cn/implant-check/');
  });
});
```

- [ ] **Step 2: Run it to confirm it fails**

Run: `cd web && npx vitest run src/lib/site-nav.test.ts`
Expected: FAIL — "Cannot find module './site-nav'".

- [ ] **Step 3: Write the data module**

```ts
// web/src/lib/site-nav.ts
// Single source for header + footer content, per locale.
// TH + EN authored. zh-cn omitted for now → falls back to EN (spec §7: zh-cn copy pending).
// The slogan/tagline is an English brand line for ALL locales (design decision D5).

export type Locale = 'th' | 'en' | 'zh-cn';

export interface LinkItem { label: string; href?: string; soon?: boolean; live?: boolean; }
export interface NavItem { label: string; href?: string; panel?: 'implant' | 'services'; flag?: boolean; }
export interface MegaColumn { label: string; links: LinkItem[]; }
export interface Promo { kw: string; title: string; priceEyebrow: string; price: string; bullets: string[]; ctaLabel: string; ctaHref: string; }
export interface MegaPanel { heading: string; sub: string; ctaLabel: string; ctaHref: string; columns: MegaColumn[]; promo?: Promo; imageLabel?: string; }
export interface SocialLink { name: 'facebook' | 'instagram' | 'tiktok' | 'line'; href: string; }
export interface Branch { name: string; mrt: string; province: string; phoneDisplay: string; phoneTel: string; hours: string[]; mapUrl: string; }
export interface FooterGroup { label: string; links: LinkItem[]; }

export interface HeaderData {
  slogan: string;
  social: SocialLink[];
  langLabel: string;
  nav: NavItem[];
  cta: { label: string; href: string };
  mobileCta: { label: string; href: string };
  megaPanels: { implant: MegaPanel; services: MegaPanel };
}
export interface FooterData {
  tagline: string;
  social: SocialLink[];
  groups: FooterGroup[];
  branches: Branch[];
  legal: string[];
  verify: { label: string; href: string };
}

// ---- shared constants (locale-independent) ----
const SLOGAN = 'A stable foundation for a lifetime of confident smiles';
const LINE_URL = 'https://maac.io/6yp2p';
const PHONE_DISPLAY = '098 462 4949'; // PLACEHOLDER — per-branch real numbers pending (spec §7)
const PHONE_TEL = '+66984624949';
const VERIFY_URL = 'https://hosp.hss.moph.go.th/';
const SOCIAL: SocialLink[] = [
  { name: 'facebook', href: '#' },
  { name: 'instagram', href: '#' },
  { name: 'tiktok', href: '#' },
  { name: 'line', href: LINE_URL },
];

/** Return m[locale], else m.en, else m.th. */
export function pick<T>(m: Partial<Record<Locale, T>>, locale: Locale): T {
  return (m[locale] ?? m.en ?? m.th) as T;
}

// Per-locale string bundle. Add a 'zh-cn' key here when translations land.
type Bundle = HeaderData & { footer: FooterData };
const BUNDLES: Partial<Record<Locale, Bundle>> = {
  th: {
    slogan: SLOGAN,
    social: SOCIAL,
    langLabel: 'TH',
    nav: [
      { label: 'หน้าแรก', href: '/' },
      { label: 'รากฟันเทียม', panel: 'implant', flag: true },
      { label: 'บริการ', panel: 'services' },
      { label: 'เกี่ยวกับเรา', href: '#', },
      { label: 'สาขา', href: '#branches' },
      { label: 'บทความ', soon: true } as unknown as NavItem,
      { label: 'เช็กความพร้อม', href: '/implant-check/' },
      { label: 'ติดต่อ', href: '#booking' },
    ],
    cta: { label: 'จองคิว', href: '#booking' },
    mobileCta: { label: 'นัดปรึกษาทันตแพทย์เฉพาะทาง', href: '#booking' },
    megaPanels: {
      implant: {
        heading: 'รากฟันเทียม — รากฐานฟันที่มั่นคงตลอดชีวิต',
        sub: 'ดูแลโดยทันตแพทย์เฉพาะทางศัลยศาสตร์ช่องปากฯ · CBCT 3D · Guided Surgery',
        ctaLabel: 'ดูหน้ารากฟันเทียม', ctaHref: '/lp/dental-implant/',
        columns: [
          { label: 'ประเภทการรักษา', links: [
            { label: 'รากเทียมซี่เดียว', soon: true },
            { label: 'รากเทียมหลายซี่ / สะพานฟัน', soon: true },
            { label: 'All-on-X (ฟันทั้งปาก)', soon: true },
            { label: 'รากเทียม + ปลูกกระดูก', soon: true },
          ]},
          { label: 'ตามเคส & ความพร้อม', links: [
            { label: 'เช็กความพร้อมรากเทียม', href: '/implant-check/', live: true },
            { label: 'ปลูกกระดูก / ยกไซนัส', soon: true },
            { label: 'รากเทียมทันที (Immediate)', soon: true },
            { label: 'เคสยาก / All-on-4', soon: true },
          ]},
        ],
        promo: {
          kw: 'Signature Offer', title: 'Blue Diamond Implant', priceEyebrow: 'เริ่มต้น', price: '29,900.-',
          bullets: ['นำเข้าเกาหลี · รับประกันตลอดชีพ', 'ผ่อน 0% นาน 10 เดือน', 'รวมครอบฟัน'],
          ctaLabel: 'ปรึกษาฟรี', ctaHref: '#booking',
        },
      },
      services: {
        heading: 'บริการทันตกรรมครบวงจร',
        sub: 'ตั้งแต่ดูแลทั่วไป จัดฟัน ความงาม ไปจนถึงงานเฉพาะทาง — ครบในที่เดียว',
        ctaLabel: 'ดูบริการทั้งหมด', ctaHref: '#',
        columns: [
          { label: 'ความงาม', links: [
            { label: 'วีเนียร์', soon: true }, { label: 'ฟอกสีฟัน', soon: true }, { label: 'Digital Smile Design', soon: true },
          ]},
          { label: 'จัดฟัน', links: [
            { label: 'จัดฟันใส', soon: true }, { label: 'Damon System', soon: true },
          ]},
          { label: 'ทั่วไป & รักษา', links: [
            { label: 'รักษารากฟัน', soon: true }, { label: 'ถอนฟัน / ฟันคุด', soon: true }, { label: 'อุดฟัน · ฟันปลอม', soon: true },
          ]},
          { label: 'เหงือก', links: [
            { label: 'รักษาปริทันต์', soon: true }, { label: 'รักษาเหงือกร่น', soon: true },
          ]},
        ],
        imageLabel: 'ภาพคลินิก & ทีมแพทย์',
      },
    },
    footer: {
      tagline: SLOGAN, social: SOCIAL,
      groups: [
        { label: 'บริการ', links: [
          { label: 'รากฟันเทียม', href: '/lp/dental-implant/' },
          { label: 'เช็กความพร้อมรากเทียม', href: '/implant-check/' },
          { label: 'ความงาม', soon: true }, { label: 'จัดฟัน', soon: true }, { label: 'ทันตกรรมทั่วไป', soon: true },
        ]},
        { label: 'ลิงก์ด่วน', links: [
          { label: 'เกี่ยวกับเรา', href: '#' }, { label: 'ทีมแพทย์', href: '#' }, { label: 'สาขา', href: '#branches' },
          { label: 'บทความ', soon: true }, { label: 'จองคิว', href: '#booking' }, { label: 'นโยบายความเป็นส่วนตัว', href: '/privacy-policy/' },
        ]},
      ],
      branches: [
        { name: 'สาขารัตนาธิเบศร์', mrt: 'MRT สีม่วง · แยกนนทบุรี 1', province: 'นนทบุรี',
          phoneDisplay: PHONE_DISPLAY, phoneTel: PHONE_TEL, hours: ['เปิดทุกวัน', 'เวลา 10.00–20.00'],
          mapUrl: 'https://maps.google.com/?q=SmileScape+รัตนาธิเบศร์' },
        { name: 'สาขาศรีนครินทร์', mrt: 'MRT สีเหลือง · สวนหลวง ร.9', province: 'กรุงเทพมหานคร',
          phoneDisplay: PHONE_DISPLAY, phoneTel: PHONE_TEL, hours: ['เปิดทุกวัน', 'เวลา 10.00–20.00'],
          mapUrl: 'https://maps.google.com/?q=SmileScape+ศรีนครินทร์' },
      ],
      legal: ['© ' + 2026 + ' SmileScape Dental Clinic', 'นโยบายความเป็นส่วนตัว', 'ข้อมูลใช้เพื่อการนัดหมายตามนโยบาย PDPA'],
      verify: { label: 'คลินิกได้รับอนุญาตถูกต้อง · ตรวจสอบได้', href: VERIFY_URL },
    },
  },
  en: {
    slogan: SLOGAN, social: SOCIAL, langLabel: 'EN',
    nav: [
      { label: 'Home', href: '/en/' },
      { label: 'Dental Implants', panel: 'implant', flag: true },
      { label: 'Services', panel: 'services' },
      { label: 'About', href: '#' },
      { label: 'Branches', href: '#branches' },
      { label: 'Articles', soon: true } as unknown as NavItem,
      { label: 'Readiness Check', href: '/en/implant-check/' },
      { label: 'Contact', href: '#booking' },
    ],
    cta: { label: 'Book Now', href: '#booking' },
    mobileCta: { label: 'Consult a Specialist Dentist', href: '#booking' },
    megaPanels: {
      implant: {
        heading: 'Dental Implants — a lifetime foundation',
        sub: 'By oral & maxillofacial surgery specialists · CBCT 3D · Guided Surgery',
        ctaLabel: 'View implants page', ctaHref: '/en/lp/dental-implant/',
        columns: [
          { label: 'Treatments', links: [
            { label: 'Single implant', soon: true }, { label: 'Multiple / bridge', soon: true },
            { label: 'All-on-X (full arch)', soon: true }, { label: 'Implant + bone graft', soon: true },
          ]},
          { label: 'By case & readiness', links: [
            { label: 'Implant readiness check', href: '/en/implant-check/', live: true },
            { label: 'Bone graft / sinus lift', soon: true }, { label: 'Immediate implant', soon: true }, { label: 'Complex / All-on-4', soon: true },
          ]},
        ],
        promo: { kw: 'Signature Offer', title: 'Blue Diamond Implant', priceEyebrow: 'from', price: '29,900.-',
          bullets: ['Korean-made · lifetime warranty', '0% installment for 10 months', 'Crown included'],
          ctaLabel: 'Free consult', ctaHref: '#booking' },
      },
      services: {
        heading: 'Full-service dentistry', sub: 'General, ortho, cosmetic and specialist care — all in one place.',
        ctaLabel: 'View all services', ctaHref: '#',
        columns: [
          { label: 'Cosmetic', links: [{ label: 'Veneers', soon: true }, { label: 'Whitening', soon: true }, { label: 'Digital Smile Design', soon: true }] },
          { label: 'Orthodontics', links: [{ label: 'Clear aligners', soon: true }, { label: 'Damon System', soon: true }] },
          { label: 'General & restorative', links: [{ label: 'Root canal', soon: true }, { label: 'Extraction / wisdom tooth', soon: true }, { label: 'Filling · dentures', soon: true }] },
          { label: 'Gums', links: [{ label: 'Periodontal care', soon: true }, { label: 'Gum recession', soon: true }] },
        ],
        imageLabel: 'Clinic & dental team',
      },
    },
    footer: {
      tagline: SLOGAN, social: SOCIAL,
      groups: [
        { label: 'Services', links: [
          { label: 'Dental Implants', href: '/en/lp/dental-implant/' }, { label: 'Readiness Check', href: '/en/implant-check/' },
          { label: 'Cosmetic', soon: true }, { label: 'Orthodontics', soon: true }, { label: 'General Dentistry', soon: true },
        ]},
        { label: 'Quick links', links: [
          { label: 'About', href: '#' }, { label: 'Our dentists', href: '#' }, { label: 'Branches', href: '#branches' },
          { label: 'Articles', soon: true }, { label: 'Book Now', href: '#booking' }, { label: 'Privacy Policy', href: '/privacy-policy/' },
        ]},
      ],
      branches: [
        { name: 'Rattanathibet branch', mrt: 'MRT Purple · Yaek Nonthaburi 1', province: 'Nonthaburi',
          phoneDisplay: PHONE_DISPLAY, phoneTel: PHONE_TEL, hours: ['Open daily', '10.00–20.00'],
          mapUrl: 'https://maps.google.com/?q=SmileScape+รัตนาธิเบศร์' },
        { name: 'Srinagarindra branch', mrt: 'MRT Yellow · Suan Luang Rama 9', province: 'Bangkok',
          phoneDisplay: PHONE_DISPLAY, phoneTel: PHONE_TEL, hours: ['Open daily', '10.00–20.00'],
          mapUrl: 'https://maps.google.com/?q=SmileScape+ศรีนครินทร์' },
      ],
      legal: ['© ' + 2026 + ' SmileScape Dental Clinic', 'Privacy Policy', 'Data used for appointments per PDPA'],
      verify: { label: 'Licensed clinic · verify', href: VERIFY_URL },
    },
  },
};

export function getHeader(locale: Locale): HeaderData {
  const b = pick(BUNDLES, locale);
  const { footer, ...header } = b;
  return header;
}
export function getFooter(locale: Locale): FooterData {
  return pick(BUNDLES, locale).footer;
}

/**
 * Per-locale absolute URLs for the CURRENT page (language switcher).
 * Mirrors Base.astro: th at root, en under /en/, zh-cn under /zh-cn/.
 */
export function getAltLocales(pathname: string, site: string) {
  const seg = pathname.split('/')[1];
  const known = ['en', 'zh-cn'];
  const basePath = known.includes(seg) ? (pathname.slice(seg.length + 1) || '/') : pathname;
  const withLocale = (loc: string) => (loc === 'th' ? basePath : ('/' + loc + basePath).replace(/\/{2,}/g, '/'));
  return {
    th: new URL(withLocale('th'), site).toString(),
    en: new URL(withLocale('en'), site).toString(),
    'zh-cn': new URL(withLocale('zh-cn'), site).toString(),
  };
}
```

- [ ] **Step 4: Run tests to confirm they pass**

Run: `cd web && npx vitest run src/lib/site-nav.test.ts`
Expected: PASS (8 tests).

- [ ] **Step 5: Type-check**

Run: `cd web && npm run check 2>&1 | tail -5`
Expected: no NEW errors in `site-nav.ts`.

- [ ] **Step 6: Commit**

```bash
git add web/src/lib/site-nav.ts web/src/lib/site-nav.test.ts
git commit -m "feat(site-nav): per-locale header/footer data module + helpers + tests"
```

---

## Task 3: SiteFooter component (light)

**Files:**
- Create: `web/src/components/SiteFooter.astro`

- [ ] **Step 1: Create the footer**

```astro
---
import Icon from '~/components/ui/Icon.astro';
import { getFooter, type Locale } from '~/lib/site-nav';
const locale = (Astro.currentLocale ?? 'th') as Locale;
const f = getFooter(locale);
const soonLabel = locale === 'en' ? 'soon' : 'เร็วๆ นี้';
const mapLabel = locale === 'en' ? 'Open in map →' : 'เปิดในแผนที่ →';
---
<footer class="bg-brand-ice text-brand-neutral-500 border-t border-brand-neutral-200">
  <div class="max-w-wide mx-auto px-6 py-12 grid gap-9 md:grid-cols-5">
    <!-- brand -->
    <div class="md:col-span-2 lg:col-span-1 md:row-span-1" style="--c:1.6">
      <img src="/images/lp/logo-stacked.png" alt="SmileScape Dental Clinic" width="400" height="248" class="h-14 w-auto mb-4" />
      <p class="font-display font-medium text-sm text-brand-anchor/90 max-w-[30ch] leading-snug">{f.tagline}</p>
      <div class="flex gap-5 mt-5">
        {f.social.map((s) => (
          <a href={s.href} aria-label={s.name} class="text-brand-neutral-500 hover:text-brand-primary transition-colors"><Icon name={s.name} class="w-5 h-5" /></a>
        ))}
      </div>
    </div>

    <!-- link groups (mobile: 2-col block; desktop: own columns) -->
    <div class="grid grid-cols-2 gap-x-4 gap-y-6 md:contents">
      {f.groups.map((g) => (
        <div>
          <h4 class="text-brand-anchor text-sm font-bold tracking-wide mb-3">{g.label}</h4>
          {g.links.map((l) => l.soon ? (
            <span class="block text-sm py-1.5 text-brand-neutral-300">{l.label} <span class="text-[10px] bg-brand-neutral-200 text-brand-neutral-500 px-1.5 py-0.5 rounded-full align-middle">{soonLabel}</span></span>
          ) : (
            <a href={l.href} class="block text-sm py-1.5 text-brand-neutral-900 hover:text-brand-primary-deep transition-colors">{l.label}</a>
          ))}
        </div>
      ))}
    </div>

    <!-- branches -->
    {f.branches.map((b) => (
      <div>
        <h4 class="text-brand-anchor text-[15px] font-bold mb-2">{b.name}</h4>
        <span class="inline-block text-[11px] font-semibold text-brand-primary-deep bg-brand-primary-soft px-2.5 py-0.5 rounded-full mb-2">{b.mrt}</span>
        <p class="text-[13.5px] text-brand-neutral-500 mb-2">{b.province}</p>
        <a href={`tel:${b.phoneTel}`} class="flex items-center gap-2 text-[13.5px] text-brand-neutral-900 py-0.5"><Icon name="phone" class="w-[15px] h-[15px] text-brand-anchor/60" />{b.phoneDisplay}</a>
        <p class="flex items-start gap-2 text-[13.5px] text-brand-neutral-500 py-0.5"><Icon name="clock" class="w-[15px] h-[15px] text-brand-anchor/60 mt-[3px] shrink-0" /><span class="leading-snug" set:html={b.hours.join('<br class="md:inline hidden" /> ')} /></p>
        <a href={b.mapUrl} class="inline-flex items-center gap-1.5 text-[13.5px] font-semibold text-brand-primary hover:text-brand-primary-deep mt-2">{mapLabel}</a>
      </div>
    ))}
  </div>

  <!-- bottom bar -->
  <div class="bg-brand-primary-soft">
    <div class="max-w-wide mx-auto px-6 py-[18px] text-[12.5px] text-brand-neutral-500 flex flex-col items-center gap-3 text-center md:flex-row md:justify-between md:text-left">
      <div class="ssf-legal leading-relaxed">
        {f.legal.map((line, i) => (
          <span class="ssf-legal-item">{i === 1 ? <a href="/privacy-policy/" class="text-brand-anchor hover:text-brand-primary-deep">{line}</a> : line}</span>
        ))}
      </div>
      <a href={f.verify.href} target="_blank" rel="noopener noreferrer"
         class="inline-flex items-center gap-1.5 text-xs font-semibold px-3 py-1.5 rounded-full ssf-verify transition-colors">
        <Icon name="check" class="w-3.5 h-3.5" />{f.verify.label}<Icon name="external" class="w-3 h-3 opacity-70" />
      </a>
    </div>
  </div>
</footer>

<style>
  /* one-off success-green for the verify badge (not a brand token) */
  .ssf-verify{ color:#0a8f4d; background:#e3f7ec; border:1px solid #b6e6c8; }
  .ssf-verify:hover{ background:#d4f1de; border-color:#8fd9a8; }
  /* desktop bottom bar = inline with separators; mobile = stacked one-per-line */
  .ssf-legal-item{ display:block; }
  @media (min-width:768px){
    .ssf-legal-item{ display:inline; }
    .ssf-legal-item + .ssf-legal-item::before{ content:"·"; opacity:.4; margin:0 .5rem; }
  }
</style>
```

> Hours `<br>` is hidden on desktop (forces one wrapper) — wait: desktop wants TWO lines, mobile ONE. The `set:html` joins with a `<br class="md:inline hidden">`: hidden on mobile (one line), shown ≥md (two lines). Confirm in Step 2's visual check.

- [ ] **Step 2: Verify type-check + build**

Run: `cd web && npm run check 2>&1 | tail -5 && npm run build 2>&1 | tail -5`
Expected: no NEW errors; build succeeds.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/SiteFooter.astro
git commit -m "feat(footer): SiteFooter — light responsive footer (5-col / mobile stack)"
```

---

## Task 4: SiteHeader — desktop (utility + main + mega panels)

**Files:**
- Create: `web/src/components/SiteHeader.astro`

- [ ] **Step 1: Create the header with desktop tiers, nav, language dropdown, and both mega panels**

```astro
---
import Icon from '~/components/ui/Icon.astro';
import { getHeader, getAltLocales, type Locale, type MegaPanel } from '~/lib/site-nav';
const locale = (Astro.currentLocale ?? 'th') as Locale;
const h = getHeader(locale);
const alt = getAltLocales(Astro.url.pathname, Astro.site!.toString());
const soonLabel = locale === 'en' ? 'soon' : 'เร็วๆ นี้';
const liveLabel = locale === 'en' ? 'ready' : 'พร้อมใช้';
const panels: { key: 'implant' | 'services'; data: MegaPanel }[] = [
  { key: 'implant', data: h.megaPanels.implant },
  { key: 'services', data: h.megaPanels.services },
];
---
<header id="ssf-header" class="sticky top-0 z-[60]">
  <!-- TIER 1 — utility (navy) -->
  <div class="ssf-util bg-brand-anchor text-white/80 overflow-hidden">
    <div class="max-w-wide mx-auto px-6 h-10 flex items-center justify-between gap-4">
      <span class="hidden sm:block font-display font-medium text-[13.5px] tracking-tight">{h.slogan}</span>
      <div class="flex items-center gap-3 ml-auto">
        <div class="flex items-center gap-4">
          {h.social.map((s) => (
            <a href={s.href} aria-label={s.name} class="text-white/70 hover:text-white transition-colors"><Icon name={s.name} class="w-[17px] h-[17px]" /></a>
          ))}
        </div>
        <span class="w-px h-5 bg-white/20"></span>
        <!-- language switcher -->
        <div class="relative">
          <button type="button" id="ssf-lang" aria-haspopup="true" aria-expanded="false"
            class="flex items-center gap-1.5 px-2.5 py-1.5 rounded-lg text-[13px] font-semibold text-white border border-white/25 hover:border-white">
            <Icon name="globe" class="w-3.5 h-3.5 opacity-85" />{h.langLabel}<Icon name="chevron" class="w-2.5 h-2.5" />
          </button>
          <div id="ssf-lang-menu" class="hidden absolute top-[calc(100%+8px)] right-0 bg-white border border-brand-neutral-200 rounded-xl shadow-lg p-1.5 min-w-[140px] z-[70]">
            <a href={alt.th} class="block px-3 py-2 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">ไทย (TH)</a>
            <a href={alt.en} class="block px-3 py-2 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">English (EN)</a>
            <a href={alt['zh-cn']} class="block px-3 py-2 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">中文 (ZH)</a>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- TIER 2 — main (white) -->
  <div class="ssf-main bg-white/95 backdrop-blur border-b border-brand-neutral-200">
    <div class="max-w-wide mx-auto px-6 h-[72px] flex items-center gap-5">
      <a href={locale === 'en' ? '/en/' : locale === 'zh-cn' ? '/zh-cn/' : '/'} class="shrink-0">
        <img src="/images/lp/logo-smilescape.png" alt="SmileScape Dental Clinic" width="600" height="106" class="h-[31px] w-auto" />
      </a>
      <!-- desktop nav -->
      <nav class="hidden lg:flex items-center gap-0.5 mx-auto" aria-label="Primary">
        {h.nav.map((item) => item.panel ? (
          <button type="button" class={`ssf-trigger nav-item ${item.flag ? 'flag' : ''}`} data-panel={item.panel} aria-expanded="false">
            {item.flag && <span class="w-1.5 h-1.5 rounded-full bg-brand-accent"></span>}
            {item.label}<Icon name="chevron" class="chev w-[11px] h-[11px]" />
          </button>
        ) : item.soon ? (
          <span class="nav-item text-brand-neutral-300 cursor-default">{item.label}</span>
        ) : (
          <a href={item.href} class="nav-item">{item.label}</a>
        ))}
      </nav>
      <a href={h.cta.href} class="hidden lg:inline-flex items-center gap-1.5 ml-auto shrink-0 px-5 py-2.5 rounded-full bg-brand-primary text-white font-bold text-[14.5px] shadow-md hover:bg-brand-primary-deep transition">{h.cta.label} →</a>
      <!-- mobile bar controls (built in Task 5) -->
      <div id="ssf-mobile-controls" class="lg:hidden ml-auto flex items-center gap-2"></div>
    </div>
  </div>

  <!-- MEGA PANELS -->
  {panels.map(({ key, data }) => (
    <div class="ssf-panel hidden lg:block absolute left-0 right-0 top-full px-6 pt-3.5" id={`ssf-panel-${key}`}>
      <div class="max-w-wide mx-auto bg-white rounded-[22px] shadow-lg border border-brand-neutral-200 overflow-hidden">
        <div class="flex items-center justify-between gap-6 px-8 pt-6 pb-5">
          <div>
            <h3 class="font-display text-[23px] font-extrabold text-brand-anchor leading-tight">{data.heading}</h3>
            <p class="text-sm text-brand-neutral-500 mt-1.5">{data.sub}</p>
          </div>
          <a href={data.ctaHref} class="shrink-0 inline-flex items-center gap-1.5 px-5 py-2.5 rounded-full bg-brand-primary text-white font-bold text-[14.5px] shadow-md hover:bg-brand-primary-deep transition">{data.ctaLabel} →</a>
        </div>
        <div class="h-px bg-brand-neutral-200 mx-8"></div>
        <div class={`grid gap-6 px-8 py-8 ${key === 'implant' ? 'lg:grid-cols-[1fr_1fr_1.05fr]' : 'lg:grid-cols-[repeat(4,1fr)_1.1fr]'}`}>
          {data.columns.map((col) => (
            <div>
              <div class="text-[11px] font-bold tracking-[.16em] text-brand-primary uppercase mb-3.5">{col.label}</div>
              {col.links.map((l) => l.soon ? (
                <span class="flex items-center gap-2 py-1.5 text-[15px] text-brand-neutral-300 cursor-default">{l.label}<span class="text-[10px] font-semibold bg-brand-neutral-200 text-brand-neutral-500 px-1.5 py-0.5 rounded-full ml-auto">{soonLabel}</span></span>
              ) : (
                <a href={l.href} class="ssf-link flex items-center gap-2 py-1.5 text-[15px] font-medium text-brand-neutral-900">{l.label}{l.live && <span class="text-[10px] font-bold text-[#0a8f4d] bg-[#e3f7ec] px-1.5 py-0.5 rounded-full">{liveLabel}</span>}</a>
              ))}
            </div>
          ))}
          {data.promo && (
            <div class="ssf-promo rounded-2xl p-6 text-white relative overflow-hidden">
              <div class="text-[11px] font-bold tracking-[.2em] opacity-80 uppercase">{data.promo.kw}</div>
              <div class="text-[30px] mt-1.5 mb-0.5">💎</div>
              <h4 class="font-display text-[21px] font-extrabold leading-tight">{data.promo.title}</h4>
              <div class="font-display text-[34px] font-extrabold mt-3"><span class="text-sm font-medium opacity-85">{data.promo.priceEyebrow}</span> {data.promo.price}</div>
              <ul class="list-none my-3 text-[13px] opacity-90 grid gap-1.5">
                {data.promo.bullets.map((b) => <li class="flex items-center gap-2 before:content-['✓'] before:text-[#7BD0A6] before:font-extrabold">{b}</li>)}
              </ul>
              <a href={data.promo.ctaHref} class="inline-flex items-center gap-1.5 bg-white text-brand-anchor font-bold text-sm px-5 py-2.5 rounded-full">{data.promo.ctaLabel} →</a>
            </div>
          )}
          {data.imageLabel && (
            <div class="rounded-2xl border-2 border-dashed border-brand-neutral-300 bg-gradient-to-br from-brand-ice to-brand-primary-soft flex flex-col items-center justify-center text-center text-brand-anchor p-6 min-h-full">
              <Icon name="check" class="w-10 h-10 opacity-40 mb-2.5" />
              <b class="text-sm">{data.imageLabel}</b>
              <span class="text-xs text-brand-neutral-500 mt-1">DR-035 swap seam</span>
            </div>
          )}
        </div>
      </div>
    </div>
  ))}

  <div id="ssf-backdrop" class="hidden lg:block fixed inset-0 z-40"></div>
  <!-- mobile drawer mounts here (Task 5) -->
</header>

<style>
  .nav-item{ display:inline-flex; align-items:center; gap:.3rem; padding:.5rem .7rem; border-radius:.625rem;
    font-size:15px; font-weight:500; color:theme('colors.brand.anchor'); white-space:nowrap; transition:.16s; background:none; border:none; cursor:pointer; }
  a.nav-item:hover, button.nav-item:hover{ background:theme('colors.brand.ice'); color:theme('colors.brand.primary-deep'); }
  .nav-item.flag{ color:theme('colors.brand.primary-deep'); font-weight:600; }
  .nav-item.active{ background:theme('colors.brand.ice'); color:theme('colors.brand.primary-deep'); }
  .nav-item .chev{ transition:transform .2s; }
  .nav-item.active .chev{ transform:rotate(180deg); }
  .ssf-link:hover{ color:theme('colors.brand.primary-deep'); transform:translateX(3px); transition:.14s; }

  .ssf-util{ height:40px; transition:height .26s cubic-bezier(.16,1,.3,1), opacity .2s ease; }
  body.ssf-scrolled .ssf-util{ height:0; opacity:0; }
  body.ssf-scrolled .ssf-main{ box-shadow:0 6px 20px rgba(20,56,107,.08); }

  .ssf-panel{ opacity:0; visibility:hidden; transform:translateY(-10px); transition:.22s cubic-bezier(.16,1,.3,1); }
  .ssf-panel.open{ opacity:1; visibility:visible; transform:translateY(0); }
  .ssf-promo{ background:radial-gradient(120% 120% at 100% 0%, theme('colors.brand.primary-deep') 0%, theme('colors.brand.anchor') 60%); }

  #ssf-backdrop{ background:rgba(20,56,107,.32); backdrop-filter:blur(2px); opacity:0; visibility:hidden; transition:.22s; }
  #ssf-backdrop.open{ opacity:1; visibility:visible; }

  @media (prefers-reduced-motion: reduce){
    .ssf-util, .ssf-panel, #ssf-backdrop, .nav-item .chev, .ssf-link{ transition:none; }
  }
</style>

<script>
  const header = document.getElementById('ssf-header')!;
  const backdrop = document.getElementById('ssf-backdrop')!;
  const triggers = Array.from(document.querySelectorAll<HTMLElement>('.ssf-trigger'));
  let hoverTimer: number | undefined;

  function closeAll() {
    document.querySelectorAll('.ssf-panel.open').forEach((p) => p.classList.remove('open'));
    triggers.forEach((t) => { t.classList.remove('active'); t.setAttribute('aria-expanded', 'false'); });
    backdrop.classList.remove('open');
  }
  function openPanel(key: string) {
    closeAll();
    document.getElementById('ssf-panel-' + key)?.classList.add('open');
    const t = document.querySelector<HTMLElement>(`.ssf-trigger[data-panel="${key}"]`);
    t?.classList.add('active'); t?.setAttribute('aria-expanded', 'true');
    backdrop.classList.add('open');
  }
  triggers.forEach((t) => {
    const key = t.dataset.panel!;
    t.addEventListener('click', (e) => { e.stopPropagation(); t.classList.contains('active') ? closeAll() : openPanel(key); });
    t.addEventListener('mouseenter', () => { window.clearTimeout(hoverTimer); openPanel(key); });
  });
  header.addEventListener('mouseleave', () => { hoverTimer = window.setTimeout(closeAll, 200); });
  header.addEventListener('mouseenter', () => window.clearTimeout(hoverTimer));
  backdrop.addEventListener('click', closeAll);
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeAll(); });

  // language dropdown
  const langBtn = document.getElementById('ssf-lang')!;
  const langMenu = document.getElementById('ssf-lang-menu')!;
  langBtn.addEventListener('click', (e) => {
    e.stopPropagation();
    const open = langMenu.classList.toggle('hidden');
    langBtn.setAttribute('aria-expanded', String(!open));
  });
  document.addEventListener('click', () => { langMenu.classList.add('hidden'); langBtn.setAttribute('aria-expanded', 'false'); });

  // scroll-collapse utility row
  const onScroll = () => document.body.classList.toggle('ssf-scrolled', window.scrollY > 8);
  window.addEventListener('scroll', onScroll, { passive: true });
  onScroll();
</script>
```

- [ ] **Step 2: Verify type-check + build**

Run: `cd web && npm run check 2>&1 | tail -8 && npm run build 2>&1 | tail -5`
Expected: no NEW errors; build succeeds.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/SiteHeader.astro
git commit -m "feat(header): SiteHeader desktop — two-tier bar, mega panels, language switcher"
```

---

## Task 5: SiteHeader — mobile bar + drawer

**Files:**
- Modify: `web/src/components/SiteHeader.astro`

- [ ] **Step 1: Fill the mobile controls placeholder**

Replace the line `<div id="ssf-mobile-controls" class="lg:hidden ml-auto flex items-center gap-2"></div>` with:

```astro
      <div class="lg:hidden ml-auto flex items-center gap-2">
        <div class="relative">
          <button type="button" id="ssf-mlang" class="flex items-center gap-1.5 h-[42px] px-3 rounded-xl bg-brand-ice text-brand-anchor text-sm font-bold">
            <Icon name="globe" class="w-[17px] h-[17px] opacity-80" />{h.langLabel}<Icon name="chevron" class="w-[11px] h-[11px] opacity-70" />
          </button>
          <div id="ssf-mlang-menu" class="hidden absolute top-[calc(100%+8px)] right-0 bg-white border border-brand-neutral-200 rounded-xl shadow-lg p-1.5 min-w-[140px] z-[70]">
            <a href={alt.th} class="block px-3 py-2.5 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">ไทย (TH)</a>
            <a href={alt.en} class="block px-3 py-2.5 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">English (EN)</a>
            <a href={alt['zh-cn']} class="block px-3 py-2.5 rounded-lg text-sm text-brand-anchor hover:bg-brand-ice">中文 (ZH)</a>
          </div>
        </div>
        <button type="button" id="ssf-burger" aria-label="Menu" aria-expanded="false" class="w-[42px] h-[42px] grid place-items-center rounded-xl bg-brand-ice text-brand-anchor"><Icon name="menu" class="w-[23px] h-[23px]" /></button>
      </div>
```

- [ ] **Step 2: Add the drawer markup before the closing `</header>`**

Insert immediately before `<!-- mobile drawer mounts here (Task 5) -->`:

```astro
  <!-- mobile scrim + drawer -->
  <div id="ssf-scrim" class="lg:hidden fixed inset-0 z-[55]"></div>
  <aside id="ssf-drawer" class="lg:hidden fixed top-0 right-0 bottom-0 w-[88%] max-w-sm bg-white z-[56] flex flex-col" aria-hidden="true">
    <div class="h-[58px] shrink-0 flex items-center justify-between px-4 border-b border-brand-neutral-200">
      <img src="/images/lp/logo-smilescape.png" alt="SmileScape" width="600" height="106" class="h-[26px] w-auto" />
      <button type="button" id="ssf-close" aria-label="Close" class="w-10 h-10 grid place-items-center rounded-xl bg-brand-ice text-brand-anchor"><Icon name="close" class="w-5 h-5" /></button>
    </div>
    <div class="flex-1 overflow-y-auto py-2">
      {h.nav.map((item) => item.panel ? (
        <>
          <button type="button" class="ssf-acc w-full flex items-center gap-2.5 px-5 py-3.5 text-base font-semibold text-brand-anchor text-left" data-acc={item.panel} aria-expanded={item.panel === 'implant' ? 'true' : 'false'}>
            {item.flag && <span class="w-1.5 h-1.5 rounded-full bg-brand-accent"></span>}{item.label}
            <Icon name="chevron" class="chev w-[18px] h-[18px] ml-auto text-brand-neutral-300" />
          </button>
          <div class="ssf-acc-panel overflow-hidden bg-brand-ice" data-acc-panel={item.panel}>
            <div class="px-5 pt-1.5 pb-4">
              {h.megaPanels[item.panel].columns.map((col) => (
                <>
                  <div class="text-[10.5px] font-bold tracking-[.14em] text-brand-primary uppercase mt-3 mb-1">{col.label}</div>
                  {col.links.map((l) => l.soon ? (
                    <span class="flex items-center gap-2 py-2.5 text-sm text-brand-neutral-300"><span class="w-[7px] h-[7px] rounded-full bg-brand-neutral-200"></span>{l.label}<span class="text-[9.5px] font-semibold bg-brand-neutral-200 text-brand-neutral-500 px-1.5 py-0.5 rounded-full ml-auto">{soonLabel}</span></span>
                  ) : (
                    <a href={l.href} class="flex items-center gap-2 py-2.5 text-sm font-medium text-brand-neutral-900"><span class="w-[7px] h-[7px] rounded-full bg-brand-highlight"></span>{l.label}{l.live && <span class="text-[9.5px] font-bold text-[#0a8f4d] bg-[#d9f3e3] px-1.5 py-0.5 rounded-full">{liveLabel}</span>}</a>
                  ))}
                </>
              ))}
              {h.megaPanels[item.panel].promo && (
                <div class="ssf-promo rounded-xl p-4 mt-3.5 text-white">
                  <div class="text-[9.5px] font-bold tracking-[.16em] uppercase opacity-80">{h.megaPanels[item.panel].promo!.kw}</div>
                  <h5 class="font-display text-[17px] font-extrabold mt-0.5">💎 {h.megaPanels[item.panel].promo!.title}</h5>
                  <div class="font-display text-2xl font-extrabold mt-1"><span class="text-xs font-medium opacity-85">{h.megaPanels[item.panel].promo!.priceEyebrow}</span> {h.megaPanels[item.panel].promo!.price}</div>
                  <a href={h.megaPanels[item.panel].promo!.ctaHref} class="inline-flex items-center gap-1.5 bg-white text-brand-anchor font-bold text-[13px] px-4 py-2.5 rounded-full mt-3">{h.megaPanels[item.panel].promo!.ctaLabel} →</a>
                </div>
              )}
              <a href={h.megaPanels[item.panel].ctaHref} class="block text-brand-primary-deep font-bold mt-2">{h.megaPanels[item.panel].ctaLabel} →</a>
            </div>
          </div>
        </>
      ) : item.soon ? (
        <span class="block px-5 py-3.5 text-base font-semibold text-brand-neutral-300">{item.label}</span>
      ) : (
        <a href={item.href} class="block px-5 py-3.5 text-base font-semibold text-brand-anchor">{item.label}</a>
      ))}
    </div>
    <div class="shrink-0 border-t border-brand-neutral-200 p-[18px]">
      <a href={h.mobileCta.href} class="ssf-bookcta relative overflow-hidden w-full inline-flex items-center justify-center gap-2 px-4 py-3.5 rounded-full text-white font-bold text-[14.5px]">{h.mobileCta.label} <span class="ssf-arrow">→</span></a>
      <div class="flex items-center justify-between mt-3.5">
        <a href={`tel:${h.megaPanels.implant.promo ? '+66984624949' : '+66984624949'}`} class="inline-flex items-center gap-1.5 text-sm font-semibold text-brand-anchor"><Icon name="phone" class="w-4 h-4" />098 462 4949</a>
        <div class="flex gap-3.5">
          {h.social.map((s) => (<a href={s.href} aria-label={s.name} class="text-brand-neutral-500"><Icon name={s.name} class="w-[19px] h-[19px]" /></a>))}
        </div>
      </div>
    </div>
  </aside>
```

- [ ] **Step 3: Add drawer styles** — append inside the existing `<style>` block (before `@media (prefers-reduced-motion`):

```css
  #ssf-scrim{ background:rgba(13,34,64,.55); backdrop-filter:blur(16px) saturate(.9); opacity:0; visibility:hidden; transition:.28s; }
  #ssf-scrim.open{ opacity:1; visibility:visible; }
  #ssf-drawer{ transform:translateX(100%); transition:transform .3s cubic-bezier(.16,1,.3,1); box-shadow:-20px 0 50px rgba(15,42,80,.25); }
  #ssf-drawer.open{ transform:translateX(0); }
  .ssf-acc.open{ background:theme('colors.brand.ice'); }
  .ssf-acc.open .chev{ transform:rotate(180deg); }
  .ssf-acc .chev{ transition:transform .25s; }
  .ssf-acc-panel{ max-height:0; transition:max-height .3s ease; }
  .ssf-acc-panel.open{ max-height:680px; }
  .ssf-bookcta{ background:linear-gradient(120deg, theme('colors.brand.primary'), theme('colors.brand.primary-deep')); box-shadow:0 10px 22px rgba(33,125,234,.4); transition:transform .2s, box-shadow .2s; }
  .ssf-bookcta:hover{ transform:translateY(-2px); box-shadow:0 16px 32px rgba(33,125,234,.52); }
  .ssf-bookcta .ssf-arrow{ transition:transform .2s; }
  .ssf-bookcta:hover .ssf-arrow{ transform:translateX(4px); }
  .ssf-bookcta::before{ content:""; position:absolute; top:0; left:-120%; width:55%; height:100%;
    background:linear-gradient(120deg, transparent, rgba(255,255,255,.38), transparent); transform:skewX(-20deg); transition:left .55s ease; pointer-events:none; }
  .ssf-bookcta:hover::before{ left:150%; }
```

And extend the reduced-motion guard to include the drawer:
```css
  @media (prefers-reduced-motion: reduce){
    .ssf-util, .ssf-panel, #ssf-backdrop, .nav-item .chev, .ssf-link,
    #ssf-scrim, #ssf-drawer, .ssf-acc .chev, .ssf-acc-panel, .ssf-bookcta, .ssf-bookcta::before{ transition:none; }
  }
```

- [ ] **Step 4: Add drawer + mobile-language behavior** — append inside the existing `<script>`:

```ts
  // mobile drawer
  const drawer = document.getElementById('ssf-drawer')!;
  const scrim = document.getElementById('ssf-scrim')!;
  const burger = document.getElementById('ssf-burger')!;
  const openDrawer = () => { drawer.classList.add('open'); scrim.classList.add('open'); drawer.setAttribute('aria-hidden', 'false'); burger.setAttribute('aria-expanded', 'true'); };
  const closeDrawer = () => { drawer.classList.remove('open'); scrim.classList.remove('open'); drawer.setAttribute('aria-hidden', 'true'); burger.setAttribute('aria-expanded', 'false'); };
  burger.addEventListener('click', openDrawer);
  document.getElementById('ssf-close')!.addEventListener('click', closeDrawer);
  scrim.addEventListener('click', closeDrawer);
  document.addEventListener('keydown', (e) => { if (e.key === 'Escape') closeDrawer(); });

  // accordions (รากฟันเทียม open by default per markup)
  document.querySelectorAll<HTMLElement>('.ssf-acc').forEach((t) => {
    const panel = document.querySelector<HTMLElement>(`.ssf-acc-panel[data-acc-panel="${t.dataset.acc}"]`)!;
    if (t.getAttribute('aria-expanded') === 'true') { t.classList.add('open'); panel.classList.add('open'); }
    t.addEventListener('click', () => {
      const open = t.classList.toggle('open'); panel.classList.toggle('open');
      t.setAttribute('aria-expanded', String(open));
    });
  });

  // mobile language dropdown
  const mlang = document.getElementById('ssf-mlang')!;
  const mlangMenu = document.getElementById('ssf-mlang-menu')!;
  mlang.addEventListener('click', (e) => { e.stopPropagation(); mlangMenu.classList.toggle('hidden'); });
  document.addEventListener('click', () => mlangMenu.classList.add('hidden'));
```

- [ ] **Step 5: Verify type-check + build**

Run: `cd web && npm run check 2>&1 | tail -8 && npm run build 2>&1 | tail -5`
Expected: no NEW errors; build succeeds.

- [ ] **Step 6: Commit**

```bash
git add web/src/components/SiteHeader.astro
git commit -m "feat(header): SiteHeader mobile — bar (lang+hamburger) + drawer with accordions"
```

---

## Task 6: Wire into Base.astro + remove dead code

**Files:**
- Modify: `web/src/layouts/Base.astro`

- [ ] **Step 1: Import the components** — add to the frontmatter imports (after the `StickyCta` import, ~line 16):

```astro
import SiteHeader from '~/components/SiteHeader.astro';
import SiteFooter from '~/components/SiteFooter.astro';
```

- [ ] **Step 2: Replace the inline `<header>…</header>` block (lines ~134-158) with:**

```astro
    <SiteHeader />
```

- [ ] **Step 3: Replace the inline `<footer>…</footer>` block (lines ~164-171) with:**

```astro
    <SiteFooter />
```

- [ ] **Step 4: Remove now-dead frontmatter** — delete the `navByLocale`, `nav`, `homeHref`, `footerByLocale`, and `footer` const declarations (lines ~83-95). Keep `alt`, `orgLd`, `ldNodes`, `PHONE_*`, `LINE_URL` (still used by JSON-LD / StickyCta / global listeners).

> Note: `alt` is still computed in Base for hreflang `<link>` tags — leave it. `SiteHeader` computes its own copy via `getAltLocales`; that duplication is acceptable (or, optional cleanup: import `getAltLocales` in Base too and reuse — not required).

- [ ] **Step 5: Verify type-check + build**

Run: `cd web && npm run check 2>&1 | tail -8 && npm run build 2>&1 | tail -5`
Expected: no NEW errors (the ~19 baseline remain); build succeeds. If `check` reports unused-var errors for any leftover const, delete it.

- [ ] **Step 6: Commit**

```bash
git add web/src/layouts/Base.astro
git commit -m "refactor(base): use SiteHeader/SiteFooter; drop inline header/footer + dead locale maps"
```

---

## Task 7: Behavioral verification + a11y/motion pass

**Files:** none (verification) — fix forward in the relevant component if a check fails.

- [ ] **Step 1: Start the preview server**

Run: `cd web && npm run build && npm run preview` (serves `http://localhost:4321`). Use the `preview_*` tooling or a browser.

- [ ] **Step 2: Desktop checks (viewport ≥1024)** — on `/`, `/en/`, `/zh-cn/`:
  - Header renders: navy utility row (slogan + social + 🌐 lang), white main row (logo + 8 nav + จองคิว).
  - Hover **รากฟันเทียม** → mega panel opens with promo card; hover **บริการ** → 4-col panel + image card; backdrop dims; `Esc` closes.
  - Click 🌐 → dropdown lists ไทย/English/中文 pointing at the SAME page in each locale (verify the `/en/` ↔ `/` ↔ `/zh-cn/` URLs).
  - Scroll down >8px → utility row collapses, main row stays sticky with shadow.
  - `/en/` shows English labels; `/zh-cn/` falls back to English labels (expected — spec §7).

- [ ] **Step 3: Mobile checks (viewport 390)** — resize / DevTools device mode:
  - Bar shows logo + (🌐 TH + ☰); desktop nav hidden.
  - Tap ☰ → drawer slides from right, background heavily blurred + dark; รากฟันเทียม accordion open showing sub-links + Blue Diamond card; tap บริการ → expands.
  - Bottom CTA "นัดปรึกษาทันตแพทย์เฉพาะทาง" full-width; hover/long-press shows lift; phone + 4 social (incl LINE) below.
  - Tap scrim / ✕ / `Esc` closes.

- [ ] **Step 4: Footer checks** — both viewports:
  - Light background, colour logo, tagline, 4 social.
  - Desktop: 5 columns; branch hours show **two lines**; bottom bar one horizontal row (legal · separators · Q-Clinic badge right).
  - Mobile: stacked; บริการ|ลิงก์ด่วน 2-col; branches stacked; hours **one line**; bottom legal **3 stacked lines** + badge below.
  - Q-Clinic badge links to `https://hosp.hss.moph.go.th/` (new tab).

- [ ] **Step 5: Motion + a11y smoke**
  - With OS "reduce motion" on, panels/drawer appear without slide/transition.
  - Keyboard: Tab to a mega-panel trigger, Enter opens, `Esc` closes; `aria-expanded` toggles. Tab into drawer controls; `Esc` closes drawer.
  - Run `cd web && npm run check 2>&1 | tail -8` — confirm no NEW errors.

- [ ] **Step 6: Confirm noindex intact** — view source of `/`: `<meta name="robots" content="noindex,follow">` still present (Base default unchanged).

- [ ] **Step 7: Final commit (if any fixes were made)**

```bash
git add -A web/src
git commit -m "fix(header-footer): a11y/motion polish from verification pass"
```

> Deploy is operator-gated (`npm run deploy` / `npx wrangler deploy`) — do NOT deploy without explicit approval.

---

## Self-Review (author checklist — completed)

- **Spec coverage:** §2 desktop header → Tasks 4–5; §3 mobile → Task 5; §4 footer → Task 3; §5 decisions are encoded in the data (D8 `soon`, D9 single mobile CTA, D10 LINE in social, D6 lang dropdown, D12 light footer); §6 component architecture → Tasks 1–6; §7 operator gaps → placeholders + zh-cn→EN fallback (Task 2) + noted; §8 guardrails → reduced-motion blocks, tokens-only classes, Image via public assets, noindex check (Task 7).
- **Placeholder scan:** content placeholders (phone, social `#`, map URLs) are deliberate operator-pending values documented in spec §7, not plan-failures. No "TODO/implement later" steps; every code step is complete.
- **Type consistency:** `getHeader`/`getFooter`/`pick`/`getAltLocales` signatures match across Task 2 (definition) and Tasks 3–5 (use); `MegaPanel`/`Branch`/`NavItem` fields referenced in components exist on the interfaces; icon `name`s used in components all exist in `Icon.astro` (`facebook/instagram/tiktok/line/chevron/globe/phone/clock/check/external/close/menu/dot`).
- **Known divergence:** the mockups used raw hex CSS; this plan uses Tailwind token classes + `theme()` in scoped styles, with three documented one-off colours (LINE green `#06C755` is not used directly — LINE link styling inherits; success-green `#0a8f4d`/`#e3f7ec`; promo `#7BD0A6` check) kept in scoped `<style>`, matching the `Landing.astro` precedent.
