// web/src/lib/site-nav.ts
// Single source for header + footer content, per locale.
// TH + EN authored. zh-cn omitted for now → falls back to EN (spec §7: zh-cn copy pending).
// The slogan/tagline is an English brand line for ALL locales (design decision D5).

export type Locale = 'th' | 'en' | 'zh-cn';

// Desktop mega-menu panels. Content is being (re)built — panels currently render
// as empty placeholders (MegaPanel.placeholder). Add columns/promo per key later.
export type PanelKey = 'about' | 'services' | 'technology' | 'concerns';

export interface LinkItem { label: string; href?: string; soon?: boolean; live?: boolean; }
export interface NavItem { label: string; href?: string; panel?: PanelKey; flag?: boolean; soon?: boolean; }
export interface MegaColumn { label: string; links: LinkItem[]; }
export interface Promo { kw: string; title: string; priceEyebrow: string; price: string; bullets: string[]; ctaLabel: string; ctaHref: string; }
export interface MegaPanel { heading: string; sub?: string; ctaLabel?: string; ctaHref?: string; columns?: MegaColumn[]; promo?: Promo; imageLabel?: string; placeholder?: string; }
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
  megaPanels: Record<PanelKey, MegaPanel>;
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
const YEAR = new Date().getFullYear();
const SOCIAL: SocialLink[] = [
  { name: 'facebook', href: '#' },
  { name: 'instagram', href: '#' },
  { name: 'tiktok', href: '#' },
  { name: 'line', href: LINE_URL },
];

// Placeholder mega panels — content TBD ("we'll build the mega menu next").
const PLACEHOLDER_TH = 'อยู่ระหว่างจัดเตรียมเนื้อหา — เดี๋ยวเรามาทำ mega menu กันต่อ';
const PLACEHOLDER_EN = 'Content coming soon.';

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
      { label: 'หน้าหลัก', href: '/' },
      { label: 'เกี่ยวกับเรา', panel: 'about' },
      { label: 'บริการ', panel: 'services' },
      { label: 'เทคโนโลยี', panel: 'technology' },
      { label: 'บริการตามปัญหา', panel: 'concerns' },
      { label: 'คลังความรู้', soon: true },
      { label: 'กรณีศึกษา', soon: true },
      { label: 'ติดต่อเรา', href: '#booking' },
    ],
    cta: { label: 'จองคิว', href: '#booking' },
    mobileCta: { label: 'นัดปรึกษาทันตแพทย์เฉพาะทาง', href: '#booking' },
    megaPanels: {
      about: { heading: 'เกี่ยวกับเรา', placeholder: PLACEHOLDER_TH },
      services: { heading: 'บริการ', placeholder: PLACEHOLDER_TH },
      technology: { heading: 'เทคโนโลยี', placeholder: PLACEHOLDER_TH },
      concerns: { heading: 'บริการตามปัญหา', placeholder: PLACEHOLDER_TH },
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
      legal: ['© ' + YEAR + ' SmileScape Dental Clinic', 'นโยบายความเป็นส่วนตัว', 'ข้อมูลใช้เพื่อการนัดหมายตามนโยบาย PDPA'],
      verify: { label: 'คลินิกได้รับอนุญาตถูกต้อง · ตรวจสอบได้', href: VERIFY_URL },
    },
  },
  en: {
    slogan: SLOGAN, social: SOCIAL, langLabel: 'EN',
    nav: [
      { label: 'Home', href: '/en/' },
      { label: 'About', panel: 'about' },
      { label: 'Services', panel: 'services' },
      { label: 'Technology', panel: 'technology' },
      { label: 'By Concern', panel: 'concerns' },
      { label: 'Knowledge', soon: true },
      { label: 'Case Studies', soon: true },
      { label: 'Contact', href: '#booking' },
    ],
    cta: { label: 'Book Now', href: '#booking' },
    mobileCta: { label: 'Consult a Specialist Dentist', href: '#booking' },
    megaPanels: {
      about: { heading: 'About', placeholder: PLACEHOLDER_EN },
      services: { heading: 'Services', placeholder: PLACEHOLDER_EN },
      technology: { heading: 'Technology', placeholder: PLACEHOLDER_EN },
      concerns: { heading: 'By Concern', placeholder: PLACEHOLDER_EN },
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
      legal: ['© ' + YEAR + ' SmileScape Dental Clinic', 'Privacy Policy', 'Data used for appointments per PDPA'],
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
