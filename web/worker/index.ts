import { buildAssessmentEmail } from '../src/lib/assessment-email';

export interface Env {
  ASSETS: { fetch: (req: Request) => Promise<Response> };
  RESEND_API_KEY: string;
  RESEND_FROM: string;
  N8N_ASSESSMENT_WEBHOOK_URL: string;
  RELATED_EMAIL_ENABLED?: string;
}

function json(obj: unknown, status = 200): Response {
  return new Response(JSON.stringify(obj), { status, headers: { 'Content-Type': 'application/json' } });
}

async function handleLead(request: Request, env: Env): Promise<Response> {
  let body: any;
  try { body = await request.json(); } catch { return json({ ok: false, error: 'bad_json' }, 400); }
  if (!body?.consent || !body?.contact?.email) return json({ ok: false, error: 'missing' }, 400);

  // 1) Lead → n8n (must-succeed)
  let n8nOk = false;
  try {
    const res = await fetch(env.N8N_ASSESSMENT_WEBHOOK_URL, {
      method: 'POST', headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        form: 'implant_check',
        name: body.contact.name, phone: body.contact.phone, email: body.contact.email, sex: body.contact.sex || '',
        consent: true, locale: body.locale, age: body.age, tier: body.tier, flags: body.flags,
        intent: body.intent, answers: body.answers, ts: body.ts,
      }),
    });
    n8nOk = res.ok;
  } catch { n8nOk = false; }

  // 2) Email → Resend (best-effort; non-fatal)
  try {
    const relatedOn = (env.RELATED_EMAIL_ENABLED ?? 'false') === 'true';
    const { subject, html } = buildAssessmentEmail({ name: body.contact.name || '', locale: body.locale, report: body.report, relatedOn });
    await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: { Authorization: `Bearer ${env.RESEND_API_KEY}`, 'Content-Type': 'application/json' },
      body: JSON.stringify({ from: env.RESEND_FROM, to: body.contact.email, subject, html }),
    });
  } catch (err) { console.error('resend error', err); /* non-fatal */ }

  return json({ ok: n8nOk }, n8nOk ? 200 : 502);
}

// Hosts allowed to be indexed by search engines. Everything else — the `go.`
// parallel-launch subdomain, *.workers.dev preview, localhost — is forced
// noindex via an X-Robots-Tag header (SS-DR-017). This is a server-level belt
// over the per-page `<meta name="robots" content="noindex">` default in the
// layouts: it also covers non-HTML responses (sitemap.xml, images) and any page
// that ever forgets the meta. Self-disables at apex cutover (apex is indexable),
// so the only cutover edits are flipping the layout meta defaults.
const INDEXABLE_HOSTS = new Set(['smilescapeclinic.com', 'www.smilescapeclinic.com']);

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    if (url.pathname === '/api/assessment-lead' && request.method === 'POST') {
      return handleLead(request, env);
    }
    const res = await env.ASSETS.fetch(request);
    if (INDEXABLE_HOSTS.has(url.hostname)) return res;
    const guarded = new Response(res.body, res);
    guarded.headers.set('X-Robots-Tag', 'noindex');
    return guarded;
  },
};
