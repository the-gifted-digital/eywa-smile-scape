import { test, expect, vi, beforeEach } from 'vitest';
import worker from './index';

const env = {
  ASSETS: { fetch: vi.fn(async () => new Response('asset', { status: 200 })) },
  RESEND_API_KEY: 'rk', RESEND_FROM: 'SmileScape <r@x.com>',
  N8N_ASSESSMENT_WEBHOOK_URL: 'https://n8n.test/webhook', RELATED_EMAIL_ENABLED: 'false',
} as any;

const validBody = {
  form: 'implant_check', locale: 'en', consent: true,
  contact: { name: 'A', phone: '1', email: 'a@b.com', sex: '' },
  age: '40-59', tier: 'A', flags: [], intent: 'soon', answers: {},
  report: { tier: 'A', tierBadge: '🟢 Good', tierTitle: 'T', tierSummary: 'S', whyItems: [], nextSteps: [], relatedLinks: [], ctaUrl: 'https://x/#b', ctaLabel: 'Book' },
  ts: '2026-06-08T00:00:00Z',
};

beforeEach(() => { vi.restoreAllMocks(); env.ASSETS.fetch.mockClear(); });

test('non-API request is served by ASSETS', async () => {
  const res = await worker.fetch(new Request('https://go.x/implant-check/'), env);
  expect(env.ASSETS.fetch).toHaveBeenCalled();
  expect(await res.text()).toBe('asset');
});

test('go. parallel-launch host is forced noindex via X-Robots-Tag', async () => {
  const res = await worker.fetch(new Request('https://go.smilescapeclinic.com/'), env);
  expect(res.headers.get('X-Robots-Tag')).toBe('noindex');
  expect(await res.text()).toBe('asset'); // body preserved through the wrapper
});

test('apex (cutover) host is indexable — no X-Robots-Tag header', async () => {
  const res = await worker.fetch(new Request('https://smilescapeclinic.com/'), env);
  expect(res.headers.get('X-Robots-Tag')).toBeNull();
});

test('valid POST forwards to n8n + sends email, returns ok', async () => {
  const fetchMock = vi.fn(async (..._args: any[]) => new Response('{}', { status: 200 }));
  vi.stubGlobal('fetch', fetchMock);
  const res = await worker.fetch(new Request('https://go.x/api/assessment-lead', {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(validBody),
  }), env);
  expect(res.status).toBe(200);
  expect(await res.json()).toEqual({ ok: true });
  const urls = fetchMock.mock.calls.map((c) => String(c[0]));
  expect(urls).toContain('https://n8n.test/webhook');
  expect(urls).toContain('https://api.resend.com/emails');
});

test('missing consent → 400', async () => {
  const res = await worker.fetch(new Request('https://go.x/api/assessment-lead', {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ ...validBody, consent: false }),
  }), env);
  expect(res.status).toBe(400);
});

test('n8n failure → 502 ok:false (email still attempted)', async () => {
  const fetchMock = vi.fn(async (url: any) =>
    String(url).includes('n8n') ? new Response('', { status: 500 }) : new Response('{}', { status: 200 }));
  vi.stubGlobal('fetch', fetchMock);
  const res = await worker.fetch(new Request('https://go.x/api/assessment-lead', {
    method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(validBody),
  }), env);
  expect(res.status).toBe(502);
  expect(await res.json()).toEqual({ ok: false });
});
