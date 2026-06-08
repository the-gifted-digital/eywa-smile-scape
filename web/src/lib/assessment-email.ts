// Standalone (no '~' alias, no astro:content) so the Cloudflare Worker can bundle it.
export type Locale = 'th' | 'en' | 'zh-cn';

export interface EmailReport {
  tierTitle: string; tierSummary: string;
  whyBullets: string[]; nextSteps: string[];
  relatedLinks: { label: string; url: string }[];
  ctaUrl: string; ctaLabel: string;
}

interface Chrome {
  subject: string;
  greeting: (name: string) => string;
  whyTitle: string; nextTitle: string; relatedTitle: string;
  disclaimer: string; footer: string;
}

const CHROME: Record<Locale, Chrome> = {
  th: {
    subject: 'ผลประเมินความพร้อมรากฟันเทียมของคุณ + คำแนะนำเฉพาะคุณ',
    greeting: (n) => `สวัสดีคุณ ${n || ''} 👋 นี่คือผลประเมินฉบับเต็มของคุณ`,
    whyTitle: 'ทำไมคุณอยู่กลุ่มนี้', nextTitle: 'ขั้นตอนที่แนะนำ', relatedTitle: 'อ่านต่อเรื่องที่เกี่ยวกับเคสของคุณ',
    disclaimer: 'เพื่อการศึกษาเบื้องต้น ไม่ใช่การวินิจฉัยทางการแพทย์ — ผลขึ้นกับการตรวจโดยทันตแพทย์',
    footer: 'SmileScape Dental Clinic · โทร 092 293 6226',
  },
  en: {
    subject: 'Your dental implant readiness result + personalized guidance',
    greeting: (n) => `Hi ${n || ''} 👋 here is your full readiness report`,
    whyTitle: "Why you're in this group", nextTitle: 'Recommended next steps', relatedTitle: 'Further reading for your case',
    disclaimer: 'Educational self-check only — not a medical diagnosis. Results depend on a dentist exam.',
    footer: 'SmileScape Dental Clinic · Tel 092 293 6226',
  },
  'zh-cn': {
    subject: '您的种植牙适合度结果 + 个性化建议',
    greeting: (n) => `您好 ${n || ''} 👋 这是您的完整评估报告`,
    whyTitle: '为什么您在此组', nextTitle: '推荐步骤', relatedTitle: '针对您情况的延伸阅读',
    disclaimer: '仅供科普参考，非医疗诊断 —— 结果取决于牙医的检查。',
    footer: 'SmileScape Dental Clinic · 电话 092 293 6226',
  },
};

function esc(s: string): string {
  return String(s).replace(/[&<>"]/g, (m) => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[m] as string));
}
const li = (s: string) => `<li>${esc(s)}</li>`;

export function buildAssessmentEmail(o: { name: string; locale: Locale; report: EmailReport; relatedOn: boolean }): { subject: string; html: string } {
  const c = CHROME[o.locale] ?? CHROME.th;
  const r = o.report;
  const related = o.relatedOn && r.relatedLinks.length
    ? `<h3>${esc(c.relatedTitle)}</h3><ul>${r.relatedLinks.map((l) => `<li><a href="${esc(l.url)}">${esc(l.label)}</a></li>`).join('')}</ul>`
    : '';
  const html = `<!doctype html><html><body style="font-family:system-ui,-apple-system,'Segoe UI',sans-serif;color:#2C3E50;max-width:560px;margin:0 auto;padding:16px;line-height:1.6">
<p>${esc(c.greeting(o.name))}</p>
<h2 style="color:#0B2A4A">${esc(r.tierTitle)}</h2>
<p>${esc(r.tierSummary)}</p>
<h3 style="color:#0B2A4A">${esc(c.whyTitle)}</h3>
<ul>${r.whyBullets.map(li).join('')}</ul>
<h3 style="color:#0B2A4A">${esc(c.nextTitle)}</h3>
<ol>${r.nextSteps.map(li).join('')}</ol>
${related}
<p style="margin-top:20px"><a href="${esc(r.ctaUrl)}" style="display:inline-block;background:#1E915A;color:#fff;text-decoration:none;border-radius:99px;padding:10px 22px;font-weight:700">${esc(r.ctaLabel)}</a></p>
<p style="font-size:12px;color:#9DB4C9;margin-top:20px">${esc(c.disclaimer)}</p>
<p style="font-size:12px;color:#9DB4C9">${esc(c.footer)}</p>
</body></html>`;
  return { subject: c.subject, html };
}
