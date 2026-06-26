// web/src/lib/site-nav.ts
// Single source for header + footer content, per locale.
// TH + EN authored. zh-cn omitted for now → falls back to EN (spec §7: zh-cn copy pending).
// The slogan/tagline is an English brand line for ALL locales (design decision D5).

export type Locale = 'th' | 'en' | 'zh-cn';

// Desktop mega-menu panels. `services` carries real content; about/technology/concerns
// share a generic skeleton (same shape) — polish each panel's content separately later.
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

/**
 * Generic mega-panel skeleton (same shape for about/technology/concerns) — a
 * starting template to be replaced with real content panel-by-panel.
 */
const skel = (loc: 'th' | 'en', heading: string): MegaPanel => {
  const t = loc === 'th';
  const item = t ? 'รายการตัวอย่าง' : 'Sample item';
  const cat = t ? 'หมวดหมู่' : 'Category';
  return {
    heading,
    sub: t ? 'โครงเมนูตัวอย่าง — รอลงเนื้อหารายเมนู' : 'Skeleton — content per panel TBD',
    ctaLabel: t ? 'ดูทั้งหมด' : 'View all', ctaHref: '#',
    columns: [
      { label: `${cat} 1`, links: [{ label: item, soon: true }, { label: item, soon: true }, { label: item, soon: true }] },
      { label: `${cat} 2`, links: [{ label: item, soon: true }, { label: item, soon: true }, { label: item, soon: true }] },
      { label: `${cat} 3`, links: [{ label: item, soon: true }, { label: item, soon: true }] },
    ],
    imageLabel: t ? 'พื้นที่ภาพ' : 'Image area',
  };
};

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
      about: skel('th', 'เกี่ยวกับเรา'),
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
      technology: skel('th', 'เทคโนโลยี'),
      concerns: skel('th', 'บริการตามปัญหา'),
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
      about: skel('en', 'About'),
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
      technology: skel('en', 'Technology'),
      concerns: skel('en', 'By Concern'),
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
