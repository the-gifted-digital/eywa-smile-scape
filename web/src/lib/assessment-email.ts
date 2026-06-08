// Standalone (no '~' alias, no astro:content) so the Cloudflare Worker can bundle it.
// Branded, table-based HTML email — inline styles only, ~600px, email-client safe.
export type Locale = 'th' | 'en' | 'zh-cn';

export interface EmailReport {
  tier: string; // 'A' | 'B' | 'C' | 'info' | 'minor' — drives accent color
  tierBadge: string; // e.g. "🟡 เหมาะ — ควรเตรียมพร้อมก่อน"
  tierTitle: string;
  tierSummary: string;
  whyItems: { topic: string; text: string }[];
  nextSteps: string[];
  relatedLinks: { label: string; url: string }[];
  ctaUrl: string;
  ctaLabel: string;
}

interface Chrome {
  subject: string;
  tagline: string;
  greeting: (name: string) => string;
  intro: string;
  whyTitle: string;
  nextTitle: string;
  relatedTitle: string;
  reassurance: string;
  lineLabel: string;
  callLabel: string;
  branches: string;
  disclaimer: string;
  unsubscribe: string;
}

const CLINIC = {
  name: 'SmileScape Dental Clinic',
  phoneDisplay: '092 293 6226',
  phoneTel: '+66922936226',
  line: 'https://maac.io/6yp2p',
  website: 'https://smilescapeclinic.com',
};

const TIER_ACCENT: Record<string, string> = {
  A: '#1E915A', B: '#B8862A', C: '#C2410C', info: '#1E6BB8', minor: '#5A6B7C',
};
const TIER_TINT: Record<string, string> = {
  A: '#E9F7EF', B: '#FFF6E9', C: '#FDEDE3', info: '#EAF3FB', minor: '#F2F5F8',
};

const CHROME: Record<Locale, Chrome> = {
  th: {
    subject: 'ผลประเมินความพร้อมรากฟันเทียมของคุณ + คำแนะนำเฉพาะคุณ',
    tagline: 'รากฐานฟันที่มั่นคง เพื่อความสุขที่ยั่งยืนตลอดชีวิต',
    greeting: (n) => `สวัสดีค่ะ/ครับ คุณ${n ? ' ' + n : ''} 👋`,
    intro: 'นี่คือผลประเมินความพร้อมก่อนทำรากฟันเทียมเบื้องต้นของคุณ พร้อมคำแนะนำเฉพาะบุคคล (เพื่อการศึกษา ไม่ใช่การวินิจฉัยทางการแพทย์)',
    whyTitle: 'สิ่งที่เราพบจากคำตอบของคุณ',
    nextTitle: 'ขั้นตอนที่แนะนำสำหรับคุณ',
    relatedTitle: 'อ่านต่อเรื่องที่เกี่ยวกับเคสของคุณ',
    reassurance: 'ที่ SmileScape เรายึด “มาตรฐานครอบครัว” — เคสที่เราไม่กล้าทำให้พ่อแม่ตัวเอง เราจะไม่แนะนำให้คุณ และจะให้ข้อมูลตรงไปตรงมาเสมอ',
    lineLabel: 'ทักไลน์',
    callLabel: 'โทรเลย',
    branches: 'สาขารัตนาธิเบศร์ (MRT สีม่วง) · สาขาศรีนครินทร์ (MRT สีเหลือง)',
    disclaimer: 'แบบประเมินนี้เพื่อการศึกษาเบื้องต้น ไม่ใช่การวินิจฉัยทางการแพทย์ — ผลลัพธ์ขึ้นกับการตรวจและเอกซเรย์โดยทันตแพทย์',
    unsubscribe: 'คุณได้รับอีเมลนี้เพราะทำแบบประเมินความพร้อมรากฟันเทียมบนเว็บไซต์ของเรา',
  },
  en: {
    subject: 'Your dental implant readiness result + personalized guidance',
    tagline: 'The Lifetime Foundation',
    greeting: (n) => `Hi${n ? ' ' + n : ''} 👋`,
    intro: 'Here is your initial dental implant readiness result with personalized guidance (educational self-check — not a medical diagnosis).',
    whyTitle: 'What we noticed from your answers',
    nextTitle: 'Recommended next steps for you',
    relatedTitle: 'Further reading for your case',
    reassurance: 'At SmileScape we follow the “Family Standard” — if we wouldn’t do a case for our own parents, we won’t recommend it to you, and we always give you honest information.',
    lineLabel: 'Message on LINE',
    callLabel: 'Call us',
    branches: 'Rattanathibet branch (MRT Purple) · Srinagarindra branch (MRT Yellow)',
    disclaimer: 'This is an educational self-check, not a medical diagnosis — results depend on an in-person dental exam and X-rays.',
    unsubscribe: 'You received this email because you took the implant readiness check on our website.',
  },
  'zh-cn': {
    subject: '您的种植牙适合度结果 + 个性化建议',
    tagline: '稳固的牙齿根基，成就一生自信笑容',
    greeting: (n) => `您好${n ? ' ' + n : ''} 👋`,
    intro: '这是您的种植牙初步适合度评估结果及个性化建议（科普式自测，非医疗诊断）。',
    whyTitle: '我们从您的回答中注意到',
    nextTitle: '为您推荐的步骤',
    relatedTitle: '针对您情况的延伸阅读',
    reassurance: 'SmileScape 坚持“家人标准”——不敢为自己父母做的方案，绝不会推荐给您，并始终如实告知。',
    lineLabel: '通过 LINE 联系',
    callLabel: '致电我们',
    branches: 'Rattanathibet 分院（MRT 紫线）· Srinagarindra 分院（MRT 黄线）',
    disclaimer: '本评估仅供科普参考，非医疗诊断 —— 结果取决于牙医的面诊与 X 光检查。',
    unsubscribe: '您收到此邮件是因为在我们网站完成了种植牙适合度自测。',
  },
};

function esc(s: string): string {
  return String(s).replace(/[&<>"]/g, (m) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[m] as string));
}

const FONT = "'Helvetica Neue', Arial, 'Leelawadee UI', 'Sukhumvit Set', Tahoma, sans-serif";

export function buildAssessmentEmail(o: { name: string; locale: Locale; report: EmailReport; relatedOn: boolean }): { subject: string; html: string } {
  const c = CHROME[o.locale] ?? CHROME.th;
  const r = o.report;
  const accent = TIER_ACCENT[r.tier] ?? '#1E6BB8';
  const tint = TIER_TINT[r.tier] ?? '#EAF3FB';

  const whyRows = r.whyItems
    .map(
      (w) => `<tr><td style="padding:8px 0;border-bottom:1px solid #EDF1F5;">
        <div style="font-weight:700;color:#0B2A4A;font-size:14px;">${esc(w.topic)}</div>
        <div style="color:#42566B;font-size:14px;line-height:1.6;margin-top:2px;">${esc(w.text)}</div>
      </td></tr>`
    )
    .join('');

  const stepRows = r.nextSteps
    .map(
      (s, i) => `<tr>
        <td valign="top" style="width:26px;color:${accent};font-weight:800;font-size:14px;padding:4px 8px 4px 0;">${i + 1}.</td>
        <td style="color:#42566B;font-size:14px;line-height:1.6;padding:4px 0;">${esc(s)}</td>
      </tr>`
    )
    .join('');

  const related =
    o.relatedOn && r.relatedLinks.length
      ? `<tr><td style="padding:8px 24px 0;">
          <div style="font-weight:800;color:#0B2A4A;font-size:15px;margin-bottom:6px;">${esc(c.relatedTitle)}</div>
          ${r.relatedLinks.map((l) => `<div style="margin:4px 0;"><a href="${esc(l.url)}" style="color:#1E6BB8;text-decoration:none;font-weight:600;font-size:14px;">› ${esc(l.label)}</a></div>`).join('')}
        </td></tr>`
      : '';

  const html = `<!doctype html><html lang="${o.locale}"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><meta name="color-scheme" content="light only"></head>
<body style="margin:0;padding:0;background:#F2F5F8;">
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:#F2F5F8;padding:20px 12px;">
  <tr><td align="center">
    <table role="presentation" width="600" cellpadding="0" cellspacing="0" style="width:600px;max-width:100%;background:#ffffff;border-radius:16px;overflow:hidden;font-family:${FONT};">

      <!-- Header -->
      <tr><td style="background:#1E6BB8;padding:20px 24px;">
        <div style="font-size:20px;font-weight:800;color:#ffffff;letter-spacing:-.2px;">Smile<span style="color:#BFE0FF;">Scape</span></div>
        <div style="font-size:12px;color:#D6E8FA;margin-top:2px;">${esc(c.tagline)}</div>
      </td></tr>

      <!-- Greeting + intro -->
      <tr><td style="padding:22px 24px 4px;">
        <div style="font-size:16px;color:#0B2A4A;font-weight:700;">${esc(c.greeting(o.name))}</div>
        <div style="font-size:14px;color:#5A6B7C;line-height:1.6;margin-top:6px;">${esc(c.intro)}</div>
      </td></tr>

      <!-- Tier result card -->
      <tr><td style="padding:14px 24px 4px;">
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background:${tint};border-left:4px solid ${accent};border-radius:10px;">
          <tr><td style="padding:14px 16px;">
            <span style="display:inline-block;background:#ffffff;color:${accent};border:1px solid ${accent};border-radius:99px;padding:4px 12px;font-size:13px;font-weight:800;">${esc(r.tierBadge)}</span>
            <div style="font-size:16px;font-weight:800;color:#0B2A4A;margin-top:10px;">${esc(r.tierTitle)}</div>
            <div style="font-size:14px;color:#42566B;line-height:1.6;margin-top:4px;">${esc(r.tierSummary)}</div>
          </td></tr>
        </table>
      </td></tr>

      <!-- Why -->
      <tr><td style="padding:18px 24px 0;">
        <div style="font-weight:800;color:#0B2A4A;font-size:15px;">${esc(c.whyTitle)}</div>
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="margin-top:4px;">${whyRows}</table>
      </td></tr>

      <!-- Next steps -->
      <tr><td style="padding:18px 24px 0;">
        <div style="font-weight:800;color:#0B2A4A;font-size:15px;margin-bottom:6px;">${esc(c.nextTitle)}</div>
        <table role="presentation" width="100%" cellpadding="0" cellspacing="0">${stepRows}</table>
      </td></tr>

      ${related}

      <!-- Reassurance -->
      <tr><td style="padding:16px 24px 0;">
        <div style="background:#F7FAFC;border-radius:10px;padding:12px 14px;font-size:13px;color:#42566B;line-height:1.6;">${esc(c.reassurance)}</div>
      </td></tr>

      <!-- CTAs -->
      <tr><td style="padding:18px 24px 4px;" align="center">
        <a href="${esc(r.ctaUrl)}" style="display:inline-block;background:${accent};color:#ffffff;text-decoration:none;border-radius:99px;padding:13px 30px;font-weight:800;font-size:15px;">${esc(r.ctaLabel)}</a>
      </td></tr>
      <tr><td style="padding:8px 24px 4px;" align="center">
        <a href="${esc(CLINIC.line)}" style="display:inline-block;background:#06C755;color:#ffffff;text-decoration:none;border-radius:99px;padding:9px 18px;font-weight:700;font-size:13px;margin:3px;">${esc(c.lineLabel)}</a>
        <a href="tel:${esc(CLINIC.phoneTel)}" style="display:inline-block;background:#ffffff;color:#1E6BB8;border:1.5px solid #1E6BB8;text-decoration:none;border-radius:99px;padding:8px 18px;font-weight:700;font-size:13px;margin:3px;">${esc(c.callLabel)} ${esc(CLINIC.phoneDisplay)}</a>
      </td></tr>

      <!-- Footer -->
      <tr><td style="padding:18px 24px 22px;margin-top:8px;">
        <div style="border-top:1px solid #EDF1F5;padding-top:14px;">
          <div style="font-weight:700;color:#0B2A4A;font-size:14px;">${esc(CLINIC.name)}</div>
          <div style="font-size:12px;color:#5A6B7C;margin-top:4px;">${esc(c.branches)}</div>
          <div style="font-size:12px;color:#5A6B7C;margin-top:2px;">${esc(CLINIC.phoneDisplay)} · <a href="${esc(CLINIC.website)}" style="color:#1E6BB8;text-decoration:none;">smilescapeclinic.com</a></div>
          <div style="font-size:11px;color:#9DB4C9;margin-top:10px;line-height:1.5;">${esc(c.disclaimer)}</div>
          <div style="font-size:11px;color:#B8C4CF;margin-top:6px;">${esc(c.unsubscribe)}</div>
        </div>
      </td></tr>

    </table>
  </td></tr>
</table>
</body></html>`;

  return { subject: c.subject, html };
}
