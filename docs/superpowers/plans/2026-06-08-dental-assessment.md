# Implant Readiness Check (`/implant-check/`) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship a trilingual interactive "Implant Readiness Check" lead-magnet page: a 10-question wizard → free on-screen teaser → soft gate (name/phone/email + optional sex + PDPA) → full personalized report on-screen + a detailed Resend email; lead → n8n; all on the existing static Astro + Cloudflare Workers stack.

**Architecture:** Pure, dependency-free scoring (`lib/assessment.ts`) runs client-side. Content lives in a new `assessment` `type:'data'` collection (3 locales). The page is server-rendered (intro + question cards + gate + FAQ are crawlable); teaser + report are built client-side from a JSON island. The gate POSTs to one thin Cloudflare **Worker** (`worker/index.ts`, added via `main` + `ASSETS` binding) that forwards the lead to n8n and sends the result email via the Resend REST API — the rest of the site stays pure static assets. The email's localized/personalized copy is sent **in the POST payload** (the Worker can't read `astro:content`); the Worker only wraps it in small built-in email chrome.

**Tech Stack:** Astro 4 (static), Tailwind (`brand-*` tokens), TypeScript, Cloudflare Workers Static Assets (wrangler), Resend REST API, n8n webhook, GTM (`GTM-NFBVZT43`), Vitest (new — for the pure logic only).

**Testing approach:** TDD with **Vitest** for the pure modules (`assessment.ts` scoring, `assessment-email.ts` builder, `worker/index.ts` handler with mocked `fetch`/`ASSETS`). Astro components/pages have no component-test infra in this repo, so they are verified by `astro check` + `astro build` + manual browser checks + `wrangler dev` (documented exact steps). Do **not** add Playwright/E2E infra.

**Canonical identifiers (use exactly, everywhere):**
- Locale: `'th' | 'en' | 'zh-cn'`.
- Tier: `'A' | 'B' | 'C' | 'info' | 'minor'`. Flag: `'minor' | 'senior' | 'bone' | 'perio' | 'smoking' | 'medical' | 'complex' | 'bruxism' | 'allarch'`.
- Question ids: `age, situation, duration, bone, gums, smoking, diabetes, medical, bruxism, intent`.
- Option values: age `under-18|18-39|40-59|60+`; situation `many-all-missing|1-2-missing|about-to-extract|denture-unhappy|teeth-intact`; duration `lt-6mo|6mo-2y|gt-2y|none`; bone `yes|no|unsure`; gums `often|sometimes|never`; smoking `regular|occasional|none`; diabetes `yes-poor|yes-controlled|no`; medical `has-any|none|unsure`; bruxism `yes|unsure|no`; intent `soon|3-6mo|researching`.
- Endpoint: `POST /api/assessment-lead`. JSON island id: `ss-assess-data`. Root id: `ss-assess`.
- Files: `web/src/lib/assessment.ts`, `web/src/lib/assessment-content.ts`, `web/src/lib/assessment-email.ts`, `web/src/components/assessment/{AssessmentApp,QuestionCard,AssessmentGate}.astro`, `web/src/content/assessment/{th,en,zh-cn}.yaml`, `web/worker/index.ts`, pages `web/src/pages/implant-check/index.astro` + `web/src/pages/en/implant-check/index.astro` + `web/src/pages/zh-cn/implant-check/index.astro`.

---

## File Structure

| File | Responsibility |
|------|----------------|
| `web/src/lib/assessment.ts` | Pure types + `scoreAssessment(answers)` → `{tier, flags}`. No imports. Client + tests only. |
| `web/src/lib/assessment-email.ts` | Pure `buildAssessmentEmail()` + `EMAIL_CHROME`. Standalone (own `Locale` type, **no `~` alias, no astro:content**) so the Worker can bundle it. |
| `web/src/lib/assessment-content.ts` | `getAssessment(locale)` reads the `assessment` collection (Astro only). |
| `web/src/content/config.ts` | Add `assessment` collection schema (modify). |
| `web/src/content/assessment/{th,en,zh-cn}.yaml` | All localized copy: questions, tiers, recommendations, gate, teaser, report labels, references, faq, switches. |
| `web/src/components/assessment/QuestionCard.astro` | One server-rendered question card (presentational). |
| `web/src/components/assessment/AssessmentGate.astro` | Server-rendered gate form (BookingForm-derived; + optional sex). |
| `web/src/components/assessment/AssessmentApp.astro` | Orchestrator: intro + wizard(cards) + teaser/report containers + gate + FAQ; emits JSON island + client script. |
| `web/src/pages/**/implant-check/index.astro` | 3 thin pages: `getAssessment(locale)` → `<Base><AssessmentApp/></Base>`. |
| `web/worker/index.ts` | Routes `POST /api/assessment-lead` → n8n + Resend; else `env.ASSETS.fetch`. |
| `web/wrangler.jsonc` | Add `main`, `assets.binding`, vars (modify). |
| `web/package.json` | Add vitest + scripts (modify). |
| `web/src/layouts/Base.astro` | Add nav link to `/implant-check/` (modify). |
| `web/src/components/sections/AssessmentBand.astro` + 3 `index.astro` | Homepage entry band (new + additive inserts). |

---

## Task 1: Add Vitest

**Files:**
- Modify: `web/package.json`

- [ ] **Step 1: Add dev dependency + scripts**

In `web/package.json`, add to `"scripts"`: `"test": "vitest run"`, `"test:watch": "vitest"`. Add to `"devDependencies"`: `"vitest": "^2.1.0"`.

- [ ] **Step 2: Install**

Run: `cd web && npm install`
Expected: vitest added to `node_modules`, lockfile updated.

- [ ] **Step 3: Smoke test the runner**

Create `web/src/lib/_smoke.test.ts`:

```ts
import { test, expect } from 'vitest';
test('vitest runs', () => { expect(1 + 1).toBe(2); });
```

Run: `cd web && npm test`
Expected: 1 passed.

- [ ] **Step 4: Remove smoke + commit**

```bash
cd web && rm src/lib/_smoke.test.ts
git add web/package.json web/package-lock.json
git commit -m "build: add vitest for assessment unit tests"
```

---

## Task 2: Scoring logic (`lib/assessment.ts`) — TDD

**Files:**
- Create: `web/src/lib/assessment.ts`
- Test: `web/src/lib/assessment.test.ts`

- [ ] **Step 1: Write the failing test**

Create `web/src/lib/assessment.test.ts`:

```ts
import { test, expect } from 'vitest';
import { scoreAssessment, type Answers } from './assessment';

const base: Answers = {
  age: '40-59', situation: '1-2-missing', duration: '6mo-2y', bone: 'no',
  gums: 'never', smoking: 'none', diabetes: 'no', medical: 'none', bruxism: 'no', intent: 'soon',
};

test('all favorable → tier A, no flags', () => {
  const r = scoreAssessment(base);
  expect(r.tier).toBe('A');
  expect(r.flags).toEqual([]);
});

test('under-18 overrides everything → minor', () => {
  const r = scoreAssessment({ ...base, age: 'under-18', bone: 'yes', medical: 'has-any' });
  expect(r.tier).toBe('minor');
  expect(r.flags).toContain('minor');
});

test('teeth-intact (adult) → info', () => {
  expect(scoreAssessment({ ...base, situation: 'teeth-intact', smoking: 'regular' }).tier).toBe('info');
});

test('antiresorptive meds → tier C', () => {
  expect(scoreAssessment({ ...base, medical: 'has-any' }).tier).toBe('C');
});

test('poorly-controlled diabetes → tier C', () => {
  expect(scoreAssessment({ ...base, diabetes: 'yes-poor' }).tier).toBe('C');
});

test('bone history → tier B with bone flag', () => {
  const r = scoreAssessment({ ...base, bone: 'yes' });
  expect(r.tier).toBe('B');
  expect(r.flags).toContain('bone');
});

test('long edentulous duration sets bone flag → B', () => {
  expect(scoreAssessment({ ...base, duration: 'gt-2y' }).tier).toBe('B');
});

test('regular smoking → B', () => {
  expect(scoreAssessment({ ...base, smoking: 'regular' }).flags).toContain('smoking');
});

test('many/all missing sets allarch (context, still A if no other flags)', () => {
  const r = scoreAssessment({ ...base, situation: 'many-all-missing' });
  expect(r.flags).toContain('allarch');
  expect(r.tier).toBe('A');
});

test('60+ sets senior flag', () => {
  expect(scoreAssessment({ ...base, age: '60+' }).flags).toContain('senior');
});

test('flags are de-duplicated (bone from duration + bone question)', () => {
  const r = scoreAssessment({ ...base, duration: 'gt-2y', bone: 'yes' });
  expect(r.flags.filter((f) => f === 'bone')).toHaveLength(1);
});
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd web && npx vitest run src/lib/assessment.test.ts`
Expected: FAIL — cannot find module `./assessment`.

- [ ] **Step 3: Implement**

Create `web/src/lib/assessment.ts`:

```ts
// Pure, dependency-free scoring for the Implant Readiness Check.
// No imports (must be bundlable by both Astro client and tests).

export type Tier = 'A' | 'B' | 'C' | 'info' | 'minor';
export type Flag =
  | 'minor' | 'senior' | 'bone' | 'perio' | 'smoking'
  | 'medical' | 'complex' | 'bruxism' | 'allarch';
export type Answers = Record<string, string>;
export interface ScoreResult { tier: Tier; flags: Flag[]; }

export function scoreAssessment(a: Answers): ScoreResult {
  const flags: Flag[] = [];
  if (a.age === 'under-18') flags.push('minor');
  if (a.age === '60+') flags.push('senior');
  if (a.duration === 'gt-2y') flags.push('bone');
  if (a.bone === 'yes' || a.bone === 'unsure') flags.push('bone');
  if (a.gums === 'often') flags.push('perio');
  if (a.smoking === 'regular') flags.push('smoking');
  if (a.diabetes === 'yes-poor') flags.push('medical');
  if (a.medical === 'has-any') flags.push('complex');
  if (a.bruxism === 'yes') flags.push('bruxism');
  if (a.situation === 'many-all-missing') flags.push('allarch');

  const uniq = [...new Set(flags)];
  const has = (f: Flag) => uniq.includes(f);

  let tier: Tier;
  if (has('minor')) tier = 'minor';
  else if (a.situation === 'teeth-intact') tier = 'info';
  else if (has('complex') || has('medical')) tier = 'C';
  else if (has('bone') || has('perio') || has('smoking') || has('bruxism')) tier = 'B';
  else tier = 'A';

  return { tier, flags: uniq };
}
```

- [ ] **Step 4: Run to verify it passes**

Run: `cd web && npx vitest run src/lib/assessment.test.ts`
Expected: PASS (11 tests).

- [ ] **Step 5: Commit**

```bash
git add web/src/lib/assessment.ts web/src/lib/assessment.test.ts
git commit -m "feat(assessment): pure scoreAssessment rules engine + tests"
```

---

## Task 3: Content schema + `getAssessment` helper

**Files:**
- Modify: `web/src/content/config.ts`
- Create: `web/src/lib/assessment-content.ts`

- [ ] **Step 1: Add the `assessment` collection schema**

In `web/src/content/config.ts`, before the final `export const collections = {...}` line, add:

```ts
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
```

Then change the export line to include it:

```ts
export const collections = { pages, articles, home, assessment };
```

- [ ] **Step 2: Create the loader**

Create `web/src/lib/assessment-content.ts`:

```ts
import { getEntry } from 'astro:content';
import type { Locale } from './home';

/** Load assessment content for a locale (falls back to th). */
export async function getAssessment(locale: Locale) {
  const entry = (await getEntry('assessment', locale)) ?? (await getEntry('assessment', 'th'));
  return entry!.data;
}
```

- [ ] **Step 3: Commit (schema compiles once content exists — committed with Task 4)**

No commit yet; `astro check` will fail until at least the `th` entry exists. Proceed to Task 4.

---

## Task 4: TH content (`content/assessment/th.yaml`)

**Files:**
- Create: `web/src/content/assessment/th.yaml`

- [ ] **Step 1: Write the file**

Create `web/src/content/assessment/th.yaml`:

```yaml
meta:
  title: เช็กความพร้อมก่อนทำรากฟันเทียม
  description: >-
    แบบประเมินความพร้อมรากฟันเทียมเบื้องต้น ~1 นาที อิงปัจจัยที่ทันตแพทย์ใช้พิจารณา
    (เพื่อการศึกษา ไม่ใช่การวินิจฉัย) รับคำแนะนำเฉพาะคุณ + สำเนาทางอีเมล
ui:
  progressLabel: 'ข้อ {n}/{total}'
  backLabel: ← ย้อนกลับ
  faqHeading: คำถามที่พบบ่อย
intro:
  eyebrow: Implant Readiness Check
  title: คุณเหมาะกับรากฟันเทียมไหม?
  body: ตอบ 10 ข้อสั้น ๆ (~1 นาที) แล้วรับผลประเมินเบื้องต้น + คำแนะนำเฉพาะคุณ
  timeNote: ใช้เวลา ~1 นาที · ฟรี
  startLabel: เริ่มเช็กเลย
  disclaimer: เพื่อการศึกษาเบื้องต้น ไม่ใช่การวินิจฉัยทางการแพทย์ — ผลขึ้นกับการตรวจโดยทันตแพทย์
questions:
  - id: age
    eyebrow: เกี่ยวกับคุณ
    text: ช่วงอายุของคุณ
    options:
      - { label: ต่ำกว่า 18 ปี, value: under-18 }
      - { label: 18–39 ปี, value: 18-39 }
      - { label: 40–59 ปี, value: 40-59 }
      - { label: 60 ปีขึ้นไป, value: 60+ }
  - id: situation
    eyebrow: สภาพฟัน
    text: สถานการณ์ฟันของคุณตอนนี้
    options:
      - { label: ฟันหายหลายซี่ / เกือบทั้งปาก, value: many-all-missing }
      - { label: ฟันหาย 1–2 ซี่, value: 1-2-missing }
      - { label: กำลังจะถอน / หมอแนะนำให้ถอน, value: about-to-extract }
      - { label: ใส่ฟันปลอม–สะพานฟันอยู่ แต่ไม่พอใจ, value: denture-unhappy }
      - { label: ฟันยังครบ แค่หาข้อมูล, value: teeth-intact }
  - id: duration
    eyebrow: สภาพฟัน
    text: ฟัน/ช่องว่างหายมานานแค่ไหน
    options:
      - { label: เพิ่งหาย (น้อยกว่า 6 เดือน), value: lt-6mo }
      - { label: 6 เดือน – 2 ปี, value: 6mo-2y }
      - { label: มากกว่า 2 ปี, value: gt-2y }
      - { label: ยังไม่หาย / ไม่มีช่องว่าง, value: none }
  - id: bone
    eyebrow: กระดูก
    text: เคยมีทันตแพทย์บอกว่า "กระดูกไม่พอ" หรือต้องปลูกกระดูก/ยกไซนัสไหม
    options:
      - { label: เคย, value: yes }
      - { label: ไม่เคย, value: no }
      - { label: ไม่แน่ใจ, value: unsure }
  - id: gums
    eyebrow: เหงือก
    text: เลือดออกตอนแปรงฟัน เหงือกบวม/ร่น หรือเคยเป็นโรคเหงือกไหม
    options:
      - { label: บ่อย / เป็นประจำ, value: often }
      - { label: บางครั้ง, value: sometimes }
      - { label: ไม่เลย, value: never }
  - id: smoking
    eyebrow: พฤติกรรม
    text: คุณสูบบุหรี่ไหม
    options:
      - { label: สูบประจำ, value: regular }
      - { label: สูบบ้าง / กำลังเลิก, value: occasional }
      - { label: ไม่สูบ / เลิกแล้วเกิน 1 ปี, value: none }
  - id: diabetes
    eyebrow: สุขภาพ
    text: คุณเป็นเบาหวานไหม และคุมระดับน้ำตาลได้ดีแค่ไหน
    options:
      - { label: เป็น และคุมได้ไม่ค่อยดี / ไม่แน่ใจ, value: yes-poor }
      - { label: เป็น แต่คุมได้ดี, value: yes-controlled }
      - { label: ไม่เป็น, value: no }
  - id: medical
    eyebrow: สุขภาพ
    text: มียา/ภาวะเหล่านี้ไหม — ยากระดูกพรุนกลุ่ม bisphosphonate, เคยฉายแสงบริเวณขากรรไกร, หรือภูมิคุ้มกันบกพร่อง
    options:
      - { label: มีอย่างใดอย่างหนึ่ง, value: has-any }
      - { label: ไม่มี, value: none }
      - { label: ไม่แน่ใจ, value: unsure }
  - id: bruxism
    eyebrow: พฤติกรรม
    text: คุณนอนกัดฟัน / กัดเน้นแน่นบ่อยไหม
    options:
      - { label: ใช่ / มีคนทักว่ากัดฟันตอนนอน, value: yes }
      - { label: ไม่แน่ใจ, value: unsure }
      - { label: ไม่, value: no }
  - id: intent
    eyebrow: เป้าหมาย
    text: คุณอยากเริ่มเมื่อไหร่
    options:
      - { label: เร็ว ๆ นี้, value: soon }
      - { label: ภายใน 3–6 เดือน, value: 3-6mo }
      - { label: กำลังหาข้อมูล, value: researching }
teaser:
  resultLabel: ผลประเมินเบื้องต้นของคุณ
  inviteTitle: อยากได้รายงานฉบับเต็มสำหรับเคสคุณไหม?
  inviteBody: รายงานเต็มมีคำแนะนำเฉพาะคุณ + ขั้นตอนที่ควรทำ + สิ่งที่ควรเตรียม พร้อมส่งสำเนาเก็บไว้ทางอีเมล
  buttonLabel: ขอรายงานฉบับเต็ม (ฟรี)
  microcopy: เพื่อการศึกษาเบื้องต้น ไม่ใช่การวินิจฉัย
gate:
  title: อีกขั้นเดียวเพื่อดูรายงานฉบับเต็ม
  body: กรอกข้อมูลเพื่อรับรายงานบนหน้าจอ + สำเนาทางอีเมล เราจะติดต่อกลับเฉพาะเมื่อคุณต้องการ
  nameLabel: ชื่อ-นามสกุล
  phoneLabel: เบอร์โทร
  emailLabel: อีเมล
  sexLabel: เพศ (ไม่บังคับ)
  sexOptions: [ชาย, หญิง, ไม่ระบุ]
  pdpa: ยินยอมให้คลินิกติดต่อกลับและเก็บข้อมูลตามนโยบาย PDPA
  submitLabel: ดูรายงานฉบับเต็ม
  sending: กำลังประมวลผล…
  success: เรียบร้อย ✓ ส่งสำเนาไปที่อีเมลของคุณแล้ว
  error: ส่งอีเมลไม่สำเร็จ แต่ดูผลด้านล่างได้เลย — หรือโทร 092 293 6226 / ทักไลน์
tiers:
  A:
    badge: 🟢 เหมาะกับรากฟันเทียม
    title: คุณมีความพร้อมที่ดีสำหรับรากฟันเทียม
    summary: จากคำตอบของคุณ ปัจจัยส่วนใหญ่เอื้อต่อการทำรากฟันเทียม ขั้นตอนต่อไปคือการตรวจวางแผนเพื่อยืนยัน
    steps: [ปรึกษา + เอกซเรย์ 3D, วางแผน Digital, นัดทำรากฟันเทียม]
    ctaLabel: จองปรึกษาวางแผน (ฟรี)
    ctaHref: /#booking
  B:
    badge: 🟡 เหมาะ — ควรเตรียมพร้อมก่อน
    title: คุณเหมาะกับรากฟันเทียม แต่มีบางจุดที่ควรจัดการก่อน
    summary: มีปัจจัยที่ควรเตรียมก่อนเพื่อเพิ่มโอกาสสำเร็จระยะยาว — เรื่องเหล่านี้ดูแลได้ก่อนเริ่ม
    steps: [ปรึกษา + เอกซเรย์ 3D ประเมินกระดูก/เหงือก, เตรียมความพร้อมตามคำแนะนำ, วางแผน Digital แล้วเริ่ม]
    ctaLabel: จองปรึกษาวางแผนเตรียมตัว (ฟรี)
    ctaHref: /#booking
  C:
    badge: 🟠 ควรให้ทันตแพทย์ประเมินก่อน
    title: เคสของคุณควรได้รับการประเมินเป็นรายบุคคล
    summary: มีปัจจัยทางสุขภาพที่ต้องให้ทันตแพทย์ประเมินตัวต่อตัวก่อน เพื่อวางแผนที่ปลอดภัยและเหมาะกับคุณที่สุด
    steps: [ปรึกษาทันตแพทย์เฉพาะทาง, แจ้งประวัติสุขภาพ/ยาให้ครบ, รับแผนเฉพาะบุคคล]
    ctaLabel: ปรึกษาทันตแพทย์เฉพาะทาง
    ctaHref: /#booking
  info:
    badge: ℹ️ ยังไม่จำเป็นตอนนี้
    title: ตอนนี้คุณยังไม่จำเป็นต้องทำรากฟันเทียม
    summary: ฟันของคุณยังครบดี — ถ้าสนใจไว้เป็นข้อมูลอนาคต เรามีเรื่องน่ารู้ให้ และยินดีให้คำปรึกษาเมื่อถึงเวลา
    steps: [ดูแลสุขภาพช่องปากสม่ำเสมอ, ตรวจฟันประจำปี, ปรึกษาเมื่อมีปัญหาฟัน]
    ctaLabel: สอบถามข้อมูลเพิ่มเติม
    ctaHref: /#booking
  minor:
    badge: ℹ️ ยังไม่ถึงวัยที่เหมาะ
    title: รากฟันเทียมเหมาะกับผู้ใหญ่ที่กระดูกขากรรไกรเจริญเต็มที่
    summary: โดยทั่วไปแนะนำในผู้ที่อายุ 18 ปีขึ้นไป — แนะนำให้พบทันตแพทย์เพื่อดูทางเลือกที่เหมาะกับวัยของคุณ
    steps: [พบทันตแพทย์เพื่อตรวจประเมิน, ดูแลสุขภาพช่องปาก]
    ctaLabel: ปรึกษาทันตแพทย์
    ctaHref: /#booking
recommendations:
  bone:
    text: คุณอาจต้องปลูกกระดูกก่อน — ที่ SmileScape มีเทคนิค Sausage (Dr. Istvan Urban) สำหรับเคสกระดูกไม่พอ
    topic: การปลูกกระดูก (Sausage Technique)
    href: ''
    published: false
  perio:
    text: ควรรักษาเหงือกให้พร้อมก่อนฝังรากเทียม เพื่อลดความเสี่ยงในระยะยาว
    topic: ดูแลเหงือกก่อนทำรากเทียม
    href: ''
    published: false
  smoking:
    text: การลด/เลิกบุหรี่ช่วยเพิ่มโอกาสสำเร็จของรากฟันเทียมอย่างมีนัยสำคัญ
    topic: บุหรี่กับรากฟันเทียม
    href: ''
    published: false
  medical:
    text: ควรคุมระดับน้ำตาลให้ดีก่อนทำ เพื่อให้แผลหายและรากยึดกระดูกได้ดี
    topic: เบาหวานกับรากฟันเทียม
    href: ''
    published: false
  complex:
    text: เนื่องจากมียา/ภาวะที่ต้องระวัง แนะนำให้ทันตแพทย์เฉพาะทางประเมินเป็นรายบุคคล
    topic: ปรึกษาเฉพาะทาง
    href: ''
    published: false
  bruxism:
    text: หากนอนกัดฟัน อาจต้องใส่เฝือกสบฟันเพื่อปกป้องรากเทียมจากแรงกัด
    topic: นอนกัดฟันกับรากเทียม
    href: ''
    published: false
  allarch:
    text: กรณีฟันหายเยอะ All-on-X (ใช้งานได้ทันที) อาจเหมาะกับคุณ — รากเทียม 4–6 ตัวรองรับทั้งขากรรไกร
    topic: All-on-X รากฟันเทียมทั้งปาก
    href: ''
    published: false
relatedContent:
  onScreen: true
  email: false
reportLabels:
  whyTitle: ทำไมคุณอยู่กลุ่มนี้
  nextTitle: ขั้นตอนที่แนะนำ
  relatedTitle: เกี่ยวกับเคสของคุณ
  fallbackLabel: ดูบริการรากฟันเทียม Blue Diamond
  fallbackHref: /lp/dental-implant/
  errorNote: ส่งอีเมลไม่สำเร็จ แต่นี่คือผลของคุณ — บันทึกหน้านี้ไว้ หรือทักไลน์/โทรหาเราได้
references:
  - { label: 'ITI (International Team for Implantology) — Treatment Guides' }
  - { label: 'AAP (American Academy of Periodontology) — peri-implant health' }
  - { label: 'ADA — patient oral-health information' }
faq:
  - q: แบบประเมินนี้แทนการตรวจกับทันตแพทย์ได้ไหม?
    a: ไม่ได้ครับ เป็นการเช็กเบื้องต้นเพื่อการศึกษา ผลจริงต้องอาศัยการตรวจและเอกซเรย์โดยทันตแพทย์
  - q: ข้อมูลของฉันปลอดภัยไหม?
    a: เราเก็บข้อมูลตามนโยบาย PDPA และใช้เพื่อส่งผล/ติดต่อกลับตามที่คุณยินยอมเท่านั้น
  - q: ใช้เวลานานไหม?
    a: ประมาณ 1 นาที มี 10 คำถามสั้น ๆ
```

- [ ] **Step 2: Verify schema compiles**

Run: `cd web && npm run check 2>&1 | grep -iE "assessment|error" | head`
Expected: no NEW errors referencing `assessment`/`content/config` (the ~19 pre-existing `Landing.astro`/`lp/dental-implant.astro` errors are unrelated and expected).

- [ ] **Step 3: Commit**

```bash
git add web/src/content/config.ts web/src/lib/assessment-content.ts web/src/content/assessment/th.yaml
git commit -m "feat(assessment): content schema + loader + TH content"
```

---

## Task 5: EN content (`content/assessment/en.yaml`)

**Files:**
- Create: `web/src/content/assessment/en.yaml`

- [ ] **Step 1: Write the file** (same keys/values as TH; English copy)

Create `web/src/content/assessment/en.yaml`:

```yaml
meta:
  title: Dental Implant Readiness Check
  description: >-
    A ~1-minute educational self-check based on factors dentists consider
    (not a diagnosis). Get personalized guidance plus an emailed copy.
ui:
  progressLabel: 'Question {n}/{total}'
  backLabel: ← Back
  faqHeading: Frequently asked questions
intro:
  eyebrow: Implant Readiness Check
  title: Are you a candidate for dental implants?
  body: Answer 10 quick questions (~1 min) for an initial readiness result and personalized guidance.
  timeNote: ~1 minute · free
  startLabel: Start the check
  disclaimer: Educational self-check only — not a medical diagnosis. Results depend on a dentist's examination.
questions:
  - id: age
    eyebrow: About you
    text: Your age range
    options:
      - { label: Under 18, value: under-18 }
      - { label: 18–39, value: 18-39 }
      - { label: 40–59, value: 40-59 }
      - { label: 60+, value: 60+ }
  - id: situation
    eyebrow: Your teeth
    text: Your current tooth situation
    options:
      - { label: Many / most teeth missing, value: many-all-missing }
      - { label: 1–2 teeth missing, value: 1-2-missing }
      - { label: About to extract / advised to, value: about-to-extract }
      - { label: Have a denture/bridge but unhappy, value: denture-unhappy }
      - { label: Teeth intact, just researching, value: teeth-intact }
  - id: duration
    eyebrow: Your teeth
    text: How long has the tooth/gap been missing?
    options:
      - { label: Recently (under 6 months), value: lt-6mo }
      - { label: 6 months – 2 years, value: 6mo-2y }
      - { label: More than 2 years, value: gt-2y }
      - { label: Not missing / no gap, value: none }
  - id: bone
    eyebrow: Bone
    text: Has a dentist ever said you have "not enough bone" or need a bone graft/sinus lift?
    options:
      - { label: Yes, value: yes }
      - { label: No, value: no }
      - { label: Not sure, value: unsure }
  - id: gums
    eyebrow: Gums
    text: Bleeding when brushing, swollen/receding gums, or a history of gum disease?
    options:
      - { label: Often, value: often }
      - { label: Sometimes, value: sometimes }
      - { label: Never, value: never }
  - id: smoking
    eyebrow: Lifestyle
    text: Do you smoke?
    options:
      - { label: Regularly, value: regular }
      - { label: Occasionally / quitting, value: occasional }
      - { label: No / quit over a year ago, value: none }
  - id: diabetes
    eyebrow: Health
    text: Do you have diabetes, and how well is it controlled?
    options:
      - { label: Yes, poorly controlled / unsure, value: yes-poor }
      - { label: Yes, well controlled, value: yes-controlled }
      - { label: No, value: no }
  - id: medical
    eyebrow: Health
    text: Any of these — bisphosphonate/antiresorptive bone meds, jaw radiation, or a weakened immune system?
    options:
      - { label: Yes, one or more, value: has-any }
      - { label: None, value: none }
      - { label: Not sure, value: unsure }
  - id: bruxism
    eyebrow: Lifestyle
    text: Do you grind or clench your teeth often?
    options:
      - { label: Yes / told I grind at night, value: yes }
      - { label: Not sure, value: unsure }
      - { label: No, value: no }
  - id: intent
    eyebrow: Goal
    text: When would you like to start?
    options:
      - { label: Soon, value: soon }
      - { label: Within 3–6 months, value: 3-6mo }
      - { label: Just researching, value: researching }
teaser:
  resultLabel: Your initial result
  inviteTitle: Want the full report for your case?
  inviteBody: The full report includes personalized guidance, recommended next steps and what to prepare — with a copy emailed to you.
  buttonLabel: Get my full report (free)
  microcopy: Educational self-check, not a diagnosis
gate:
  title: One step to see your full report
  body: Enter your details to see the report on-screen and get a copy by email. We only follow up if you want us to.
  nameLabel: Full name
  phoneLabel: Phone number
  emailLabel: Email
  sexLabel: Sex (optional)
  sexOptions: [Male, Female, Prefer not to say]
  pdpa: I consent to be contacted and to data processing per the PDPA policy.
  submitLabel: See my full report
  sending: Processing…
  success: Done ✓ A copy has been sent to your email
  error: Couldn't send the email, but your result is below — or call 092 293 6226 / message us on LINE
tiers:
  A:
    badge: 🟢 Good implant candidate
    title: You look well-prepared for dental implants
    summary: Based on your answers, most factors favor implants. The next step is a planning exam to confirm.
    steps: [Consult + 3D scan, Digital planning, Schedule the implant]
    ctaLabel: Book a free planning consult
    ctaHref: /en/#booking
  B:
    badge: 🟡 Candidate — some prep first
    title: You're a candidate, with a few things to handle first
    summary: A few factors are worth preparing first to improve long-term success — all manageable before you start.
    steps: [Consult + 3D scan of bone/gums, Prepare per guidance, Digital plan then begin]
    ctaLabel: Book a free preparation consult
    ctaHref: /en/#booking
  C:
    badge: 🟠 Best evaluated by a dentist first
    title: Your case should be evaluated individually
    summary: Some health factors need an in-person dental evaluation first, for the safest plan tailored to you.
    steps: [See a specialist dentist, Share full medical/medication history, Get an individual plan]
    ctaLabel: Consult a specialist dentist
    ctaHref: /en/#booking
  info:
    badge: ℹ️ Not needed right now
    title: You don't need implants right now
    summary: Your teeth are intact — keep this for future reference, and we're happy to advise when the time comes.
    steps: [Keep up oral hygiene, Annual dental check-ups, Consult if issues arise]
    ctaLabel: Ask us a question
    ctaHref: /en/#booking
  minor:
    badge: ℹ️ Not the right age yet
    title: Implants suit adults with fully developed jaw bone
    summary: Generally recommended from age 18+ — please see a dentist for options suited to your age.
    steps: [See a dentist for assessment, Maintain oral health]
    ctaLabel: Consult a dentist
    ctaHref: /en/#booking
recommendations:
  bone:
    text: You may need a bone graft first — SmileScape uses the Sausage Technique (Dr. Istvan Urban) for low-bone cases.
    topic: Bone grafting (Sausage Technique)
    href: ''
    published: false
  perio:
    text: Treating your gums to a healthy state first lowers long-term implant risk.
    topic: Gum care before implants
    href: ''
    published: false
  smoking:
    text: Reducing or quitting smoking significantly improves implant success rates.
    topic: Smoking and dental implants
    href: ''
    published: false
  medical:
    text: Getting your blood sugar well-controlled first helps healing and osseointegration.
    topic: Diabetes and dental implants
    href: ''
    published: false
  complex:
    text: Because of medications/conditions to watch, an individual specialist evaluation is recommended.
    topic: Specialist consultation
    href: ''
    published: false
  bruxism:
    text: If you grind your teeth, a night guard may be needed to protect the implant from overload.
    topic: Grinding and implants
    href: ''
    published: false
  allarch:
    text: With many teeth missing, All-on-X (immediate-load) may suit you — 4–6 implants supporting a full arch.
    topic: All-on-X full-arch implants
    href: ''
    published: false
relatedContent:
  onScreen: true
  email: false
reportLabels:
  whyTitle: Why you're in this group
  nextTitle: Recommended next steps
  relatedTitle: For your case
  fallbackLabel: See Blue Diamond implant service
  fallbackHref: /en/lp/dental-implant/
  errorNote: We couldn't email it, but here is your result — save this page, or message/call us
references:
  - { label: 'ITI (International Team for Implantology) — Treatment Guides' }
  - { label: 'AAP (American Academy of Periodontology) — peri-implant health' }
  - { label: 'ADA — patient oral-health information' }
faq:
  - q: Can this replace a dental exam?
    a: No — it's an educational pre-check. A real result requires an exam and X-rays by a dentist.
  - q: Is my information safe?
    a: We store data under the PDPA policy and use it only to send your result / follow up as you consent.
  - q: How long does it take?
    a: About 1 minute — 10 short questions.
```

- [ ] **Step 2: Verify + commit**

Run: `cd web && npm run check 2>&1 | grep -i assessment | head` (expect none)

```bash
git add web/src/content/assessment/en.yaml
git commit -m "feat(assessment): EN content"
```

---

## Task 6: zh-CN content (`content/assessment/zh-cn.yaml`)

**Files:**
- Create: `web/src/content/assessment/zh-cn.yaml`

- [ ] **Step 1: Write the file** (same keys; Simplified Chinese)

Create `web/src/content/assessment/zh-cn.yaml`:

```yaml
meta:
  title: 种植牙适合度自测
  description: >-
    约 1 分钟的科普式自测，依据牙医评估时考量的因素（非诊断）。
    获取个性化建议，并发送副本到您的邮箱。
ui:
  progressLabel: '第 {n}/{total} 题'
  backLabel: ← 返回
  faqHeading: 常见问题
intro:
  eyebrow: Implant Readiness Check
  title: 您适合种植牙吗？
  body: 回答 10 道简短问题（约 1 分钟），获取初步适合度结果与个性化建议。
  timeNote: 约 1 分钟 · 免费
  startLabel: 开始自测
  disclaimer: 仅供科普参考，非医疗诊断 —— 结果取决于牙医的检查。
questions:
  - id: age
    eyebrow: 关于您
    text: 您的年龄段
    options:
      - { label: 18 岁以下, value: under-18 }
      - { label: 18–39 岁, value: 18-39 }
      - { label: 40–59 岁, value: 40-59 }
      - { label: 60 岁以上, value: 60+ }
  - id: situation
    eyebrow: 牙齿情况
    text: 您目前的牙齿情况
    options:
      - { label: 缺失多颗 / 几乎全口, value: many-all-missing }
      - { label: 缺失 1–2 颗, value: 1-2-missing }
      - { label: 即将拔牙 / 医生建议拔, value: about-to-extract }
      - { label: 戴义齿–牙桥但不满意, value: denture-unhappy }
      - { label: 牙齿完好，只是了解信息, value: teeth-intact }
  - id: duration
    eyebrow: 牙齿情况
    text: 牙齿/缺口缺失多久了
    options:
      - { label: 刚缺失（不到 6 个月）, value: lt-6mo }
      - { label: 6 个月 – 2 年, value: 6mo-2y }
      - { label: 超过 2 年, value: gt-2y }
      - { label: 未缺失 / 无缺口, value: none }
  - id: bone
    eyebrow: 骨量
    text: 是否有牙医说过您"骨量不足"或需要植骨/上颌窦提升？
    options:
      - { label: 是, value: yes }
      - { label: 否, value: no }
      - { label: 不确定, value: unsure }
  - id: gums
    eyebrow: 牙龈
    text: 刷牙出血、牙龈肿胀/萎缩，或有牙周病史吗？
    options:
      - { label: 经常, value: often }
      - { label: 偶尔, value: sometimes }
      - { label: 没有, value: never }
  - id: smoking
    eyebrow: 生活习惯
    text: 您吸烟吗？
    options:
      - { label: 经常吸, value: regular }
      - { label: 偶尔 / 正在戒, value: occasional }
      - { label: 不吸 / 戒烟超过一年, value: none }
  - id: diabetes
    eyebrow: 健康
    text: 您有糖尿病吗？血糖控制如何？
    options:
      - { label: 有，控制不佳 / 不确定, value: yes-poor }
      - { label: 有，但控制良好, value: yes-controlled }
      - { label: 没有, value: no }
  - id: medical
    eyebrow: 健康
    text: 是否有以下情况 —— 双膦酸盐类骨质疏松药、颌骨放疗史、或免疫力低下？
    options:
      - { label: 有其中一项, value: has-any }
      - { label: 没有, value: none }
      - { label: 不确定, value: unsure }
  - id: bruxism
    eyebrow: 生活习惯
    text: 您常磨牙 / 紧咬牙吗？
    options:
      - { label: 是 / 被说夜间磨牙, value: yes }
      - { label: 不确定, value: unsure }
      - { label: 否, value: no }
  - id: intent
    eyebrow: 目标
    text: 您希望何时开始？
    options:
      - { label: 尽快, value: soon }
      - { label: 3–6 个月内, value: 3-6mo }
      - { label: 仅了解信息, value: researching }
teaser:
  resultLabel: 您的初步结果
  inviteTitle: 想要针对您情况的完整报告吗？
  inviteBody: 完整报告包含个性化建议、推荐步骤与需要准备的事项，并发送副本到您的邮箱。
  buttonLabel: 获取完整报告（免费）
  microcopy: 仅供科普，非诊断
gate:
  title: 再一步即可查看完整报告
  body: 填写信息即可在页面查看报告并获取邮件副本。仅在您需要时我们才会联系您。
  nameLabel: 姓名
  phoneLabel: 电话号码
  emailLabel: 邮箱
  sexLabel: 性别（选填）
  sexOptions: [男, 女, 不愿透露]
  pdpa: 我同意接受联系并依据 PDPA 政策处理我的资料。
  submitLabel: 查看完整报告
  sending: 处理中…
  success: 完成 ✓ 副本已发送到您的邮箱
  error: 邮件发送失败，但结果就在下方 —— 或致电 092 293 6226 / 通过 LINE 联系
tiers:
  A:
    badge: 🟢 适合种植牙
    title: 您具备良好的种植牙条件
    summary: 根据您的回答，多数因素都有利于种植牙。下一步是检查与方案规划以确认。
    steps: [面诊 + 3D 扫描, 数字化方案, 预约种植]
    ctaLabel: 预约免费方案面诊
    ctaHref: /zh-cn/#booking
  B:
    badge: 🟡 适合 —— 但需先做准备
    title: 您适合种植牙，但有几点需先处理
    summary: 有几项因素值得先准备以提升长期成功率 —— 都可在开始前处理好。
    steps: [面诊 + 骨/牙龈 3D 扫描, 按建议做准备, 数字化方案后开始]
    ctaLabel: 预约免费准备面诊
    ctaHref: /zh-cn/#booking
  C:
    badge: 🟠 建议先由牙医评估
    title: 您的情况应进行个别评估
    summary: 部分健康因素需先经过面对面的牙科评估，以制定最安全、最适合您的方案。
    steps: [咨询专科牙医, 完整告知病史/用药, 获取个别方案]
    ctaLabel: 咨询专科牙医
    ctaHref: /zh-cn/#booking
  info:
    badge: ℹ️ 目前尚不需要
    title: 您目前还不需要种植牙
    summary: 您的牙齿完好 —— 可留作日后参考，需要时我们乐意为您提供建议。
    steps: [保持口腔卫生, 每年口腔检查, 有问题时咨询]
    ctaLabel: 向我们咨询
    ctaHref: /zh-cn/#booking
  minor:
    badge: ℹ️ 年龄尚不适合
    title: 种植牙适合颌骨发育完全的成年人
    summary: 通常建议 18 岁以上 —— 请咨询牙医了解适合您年龄的方案。
    steps: [咨询牙医评估, 保持口腔健康]
    ctaLabel: 咨询牙医
    ctaHref: /zh-cn/#booking
recommendations:
  bone:
    text: 您可能需要先植骨 —— SmileScape 采用 Sausage 技术（Dr. Istvan Urban）处理骨量不足的病例。
    topic: 植骨（Sausage 技术）
    href: ''
    published: false
  perio:
    text: 先把牙龈治疗到健康状态可降低种植体的长期风险。
    topic: 种植前的牙龈护理
    href: ''
    published: false
  smoking:
    text: 减少或戒烟能显著提升种植牙的成功率。
    topic: 吸烟与种植牙
    href: ''
    published: false
  medical:
    text: 先把血糖控制好有助于伤口愈合与骨结合。
    topic: 糖尿病与种植牙
    href: ''
    published: false
  complex:
    text: 由于存在需注意的药物/状况，建议由专科牙医进行个别评估。
    topic: 专科咨询
    href: ''
    published: false
  bruxism:
    text: 若有磨牙，可能需要佩戴咬合垫以保护种植体免受过大咬合力。
    topic: 磨牙与种植牙
    href: ''
    published: false
  allarch:
    text: 缺失较多时，All-on-X（即刻负重）可能适合您 —— 4–6 颗种植体支撑整个牙弓。
    topic: All-on-X 全口种植
    href: ''
    published: false
relatedContent:
  onScreen: true
  email: false
reportLabels:
  whyTitle: 为什么您在此组
  nextTitle: 推荐步骤
  relatedTitle: 针对您的情况
  fallbackLabel: 查看 Blue Diamond 种植服务
  fallbackHref: /en/lp/dental-implant/
  errorNote: 邮件未能发送，但这是您的结果 —— 请保存此页，或通过 LINE/电话联系我们
references:
  - { label: 'ITI（国际口腔种植学会）— 治疗指南' }
  - { label: 'AAP（美国牙周病学会）— 种植体周围健康' }
  - { label: 'ADA — 患者口腔健康资讯' }
faq:
  - q: 这个自测能代替牙科检查吗？
    a: 不能 —— 这是科普式的初步自测。真实结果需要牙医的检查与 X 光片。
  - q: 我的信息安全吗？
    a: 我们依据 PDPA 政策存储数据，仅在您同意的范围内用于发送结果/回访。
  - q: 需要多长时间？
    a: 约 1 分钟，共 10 道简短问题。
```

> Note: zh-CN `fallbackHref` and minor CTAs point at existing pages (the implant LP only exists at `/lp/` and `/en/lp/`, so zh-CN reuses `/en/lp/dental-implant/`; `#booking` resolves on the zh-CN homepage).

- [ ] **Step 2: Verify + commit**

Run: `cd web && npm run check 2>&1 | grep -i assessment | head` (expect none)

```bash
git add web/src/content/assessment/zh-cn.yaml
git commit -m "feat(assessment): zh-CN content"
```

---

## Task 7: `QuestionCard.astro`

**Files:**
- Create: `web/src/components/assessment/QuestionCard.astro`

- [ ] **Step 1: Create the component**

```astro
---
interface Option { label: string; value: string; }
interface Props { id: string; index: number; eyebrow: string; text: string; options: Option[]; }
const { id, index, eyebrow, text, options } = Astro.props;
---
<div class="ss-card" data-question={id} data-index={index} hidden>
  <p class="font-display text-xs uppercase tracking-wide text-brand-primary">{eyebrow}</p>
  <h3 class="mt-3 text-lg sm:text-xl font-semibold text-brand-anchor leading-snug">{text}</h3>
  <div class="mt-5 grid gap-2.5">
    {options.map((o) => (
      <button
        type="button"
        data-value={o.value}
        class="ss-opt text-left rounded-xl border border-brand-neutral-300 px-4 py-3 font-medium text-brand-neutral-900 hover:border-brand-primary hover:bg-brand-ice transition u-hover"
      >{o.label}</button>
    ))}
  </div>
</div>
<style>
  .ss-opt.is-selected { border-color: var(--tw-brand-primary, #1E6BB8); background: #EAF3FB; color: #154E86; font-weight: 700; }
</style>
```

> The `.is-selected` style uses literal fallbacks because scoped `<style>` cannot read Tailwind tokens; this is the one allowed literal (same exception class as `StickyCta`). Adjust the hex if the locked brand palette differs — check `tailwind.config` `brand.primary`.

- [ ] **Step 2: Commit**

```bash
git add web/src/components/assessment/QuestionCard.astro
git commit -m "feat(assessment): QuestionCard component"
```

---

## Task 8: `AssessmentGate.astro`

**Files:**
- Create: `web/src/components/assessment/AssessmentGate.astro`

- [ ] **Step 1: Create the component** (server-rendered form; client wires submit)

```astro
---
interface Props {
  title: string; body: string;
  nameLabel: string; phoneLabel: string; emailLabel: string;
  sexLabel: string; sexOptions: string[];
  pdpa: string; submitLabel: string;
}
const { title, body, nameLabel, phoneLabel, emailLabel, sexLabel, sexOptions, pdpa, submitLabel } = Astro.props;
---
<div>
  <h3 class="text-xl font-semibold text-brand-anchor">{title}</h3>
  <p class="mt-2 text-sm text-brand-neutral-700">{body}</p>
  <form id="ss-gate-form" class="mt-5 grid gap-3 max-w-lg" novalidate>
    <div class="grid sm:grid-cols-2 gap-3">
      <input name="name" required placeholder={nameLabel} class="rounded-lg border border-brand-neutral-300 px-4 py-3" />
      <input name="phone" required inputmode="tel" placeholder={phoneLabel} class="rounded-lg border border-brand-neutral-300 px-4 py-3" />
    </div>
    <input name="email" required type="email" placeholder={emailLabel} class="rounded-lg border border-brand-neutral-300 px-4 py-3" />
    <select name="sex" aria-label={sexLabel} class="rounded-lg border border-brand-neutral-300 px-4 py-3 text-brand-neutral-700">
      <option value="">{sexLabel}</option>
      {sexOptions.map((s) => <option value={s}>{s}</option>)}
    </select>
    <label class="flex items-start gap-2 text-sm text-brand-neutral-700">
      <input type="checkbox" name="pdpa" required class="mt-1" />
      {pdpa}
    </label>
    <button type="submit" class="rounded-full bg-brand-primary px-6 py-3 font-semibold text-brand-neutral-0 hover:bg-brand-primary-deep">{submitLabel}</button>
    <p data-msg role="status" class="text-center text-sm"></p>
  </form>
</div>
```

- [ ] **Step 2: Commit**

```bash
git add web/src/components/assessment/AssessmentGate.astro
git commit -m "feat(assessment): gate form component"
```

---

## Task 9: `AssessmentApp.astro` (orchestrator + client script)

**Files:**
- Create: `web/src/components/assessment/AssessmentApp.astro`

- [ ] **Step 1: Create the component**

```astro
---
import Section from '~/components/ui/Section.astro';
import QuestionCard from './QuestionCard.astro';
import AssessmentGate from './AssessmentGate.astro';
import FaqBlock from '~/components/FaqBlock.astro';
import type { Locale } from '~/lib/home';

interface Props { data: any; lang: Locale; }
const { data, lang } = Astro.props;

const clientData = {
  locale: lang,
  endpoint: '/api/assessment-lead',
  progressLabel: data.ui.progressLabel,
  perQuestionTracking: false,
  teaser: data.teaser,
  tiers: data.tiers,
  recommendations: data.recommendations,
  relatedContent: data.relatedContent,
  reportLabels: data.reportLabels,
  gate: { sending: data.gate.sending, success: data.gate.success, error: data.gate.error },
};
---
<Section tone="ice">
  <div id="ss-assess" data-reveal class="max-w-2xl mx-auto">

    <!-- INTRO -->
    <div id="ss-intro" class="text-center">
      <p class="font-display text-xs uppercase tracking-wide text-brand-primary">{data.intro.eyebrow}</p>
      <h1 class="mt-3 font-display text-2xl sm:text-3xl font-bold text-brand-anchor">{data.intro.title}</h1>
      <p class="mt-3 text-brand-neutral-700">{data.intro.body}</p>
      <p class="mt-2 text-xs text-brand-neutral-500">{data.intro.timeNote}</p>
      <button id="ss-start" type="button" class="mt-6 rounded-full bg-brand-primary px-8 py-3 font-semibold text-brand-neutral-0 hover:bg-brand-primary-deep">{data.intro.startLabel}</button>
      <p class="mt-4 text-[11px] text-brand-neutral-400">{data.intro.disclaimer}</p>
    </div>

    <!-- WIZARD -->
    <div id="ss-wizard" hidden>
      <div class="flex items-center justify-between text-xs text-brand-neutral-500 font-semibold">
        <span id="ss-progress-text"></span>
      </div>
      <div class="h-1.5 bg-brand-neutral-200 rounded-full mt-2 overflow-hidden">
        <div id="ss-progress-bar" class="h-full bg-brand-primary rounded-full transition-all" style="width:0%"></div>
      </div>
      <div class="mt-6">
        {data.questions.map((q: any, i: number) => (
          <QuestionCard id={q.id} index={i} eyebrow={q.eyebrow} text={q.text} options={q.options} />
        ))}
      </div>
      <button id="ss-back" type="button" hidden class="mt-4 text-sm font-semibold text-brand-neutral-500">{data.ui.backLabel}</button>
    </div>

    <!-- TEASER -->
    <div id="ss-teaser" hidden class="text-center">
      <p class="text-xs text-brand-neutral-500 font-semibold">{data.teaser.resultLabel}</p>
      <p data-badge class="mt-3 inline-block rounded-full border border-brand-neutral-300 px-4 py-1.5 font-bold"></p>
      <p data-summary class="mt-4 text-brand-neutral-800"></p>
      <ul data-hints class="mt-3 text-sm text-brand-neutral-600 list-disc list-inside text-left max-w-md mx-auto"></ul>
      <div class="mt-6 rounded-2xl bg-brand-paper border border-brand-neutral-200 p-5 text-left">
        <p class="font-semibold text-brand-anchor">{data.teaser.inviteTitle}</p>
        <p class="mt-1 text-sm text-brand-neutral-700">{data.teaser.inviteBody}</p>
      </div>
      <button id="ss-unlock" type="button" class="mt-5 w-full rounded-full bg-brand-primary px-8 py-3 font-bold text-brand-neutral-0 hover:bg-brand-primary-deep">{data.teaser.buttonLabel}</button>
      <p class="mt-2 text-[11px] text-brand-neutral-400">{data.teaser.microcopy}</p>
    </div>

    <!-- GATE -->
    <div id="ss-gate" hidden>
      <AssessmentGate
        title={data.gate.title} body={data.gate.body}
        nameLabel={data.gate.nameLabel} phoneLabel={data.gate.phoneLabel} emailLabel={data.gate.emailLabel}
        sexLabel={data.gate.sexLabel} sexOptions={data.gate.sexOptions}
        pdpa={data.gate.pdpa} submitLabel={data.gate.submitLabel}
      />
    </div>

    <!-- REPORT -->
    <div id="ss-report" hidden>
      <p data-badge class="inline-block rounded-full border border-brand-neutral-300 px-4 py-1.5 font-bold"></p>
      <h2 data-title class="mt-3 text-xl font-bold text-brand-anchor"></h2>
      <p data-summary class="mt-2 text-brand-neutral-800"></p>
      <h3 class="mt-5 font-semibold text-brand-anchor">{data.reportLabels.whyTitle}</h3>
      <ul data-why class="mt-2 text-sm text-brand-neutral-700 list-disc list-inside"></ul>
      <h3 class="mt-5 font-semibold text-brand-anchor">{data.reportLabels.nextTitle}</h3>
      <ol data-steps class="mt-2 text-sm text-brand-neutral-700 list-decimal list-inside"></ol>
      <h3 class="mt-5 font-semibold text-brand-anchor">{data.reportLabels.relatedTitle}</h3>
      <div data-related-list class="mt-2 grid gap-1 text-sm"></div>
      <a data-cta href="#" class="mt-6 block text-center rounded-full bg-brand-primary px-8 py-3 font-bold text-brand-neutral-0 hover:bg-brand-primary-deep"></a>
      <p data-error hidden class="mt-3 text-center text-sm text-brand-primary-deep">{data.reportLabels.errorNote}</p>
    </div>

    <!-- REFERENCES -->
    <details class="mt-10 text-xs text-brand-neutral-500">
      <summary class="cursor-pointer font-semibold">{data.intro.disclaimer}</summary>
      <ul class="mt-2 list-disc list-inside">
        {data.references.map((r: any) => <li>{r.href ? <a href={r.href} class="underline">{r.label}</a> : r.label}</li>)}
      </ul>
    </details>
  </div>
</Section>

<FaqBlock items={data.faq} heading={data.ui.faqHeading} />

<script type="application/json" id="ss-assess-data" set:html={JSON.stringify(clientData)}></script>

<script>
  import { scoreAssessment, type Answers } from '~/lib/assessment';

  const root = document.getElementById('ss-assess');
  const dataEl = document.getElementById('ss-assess-data');
  if (root && dataEl) {
    const data = JSON.parse(dataEl.textContent || '{}');
    const dl = () => ((window as any).dataLayer = (window as any).dataLayer || []);
    const q = <T extends HTMLElement = HTMLElement>(sel: string) => root.querySelector<T>(sel)!;

    const cards = Array.from(root.querySelectorAll<HTMLElement>('[data-question]'));
    const total = cards.length;
    const answers: Answers = {};
    let step = 0;
    let result: ReturnType<typeof scoreAssessment> | null = null;

    const intro = q('#ss-intro'), wizard = q('#ss-wizard'), teaser = q('#ss-teaser'),
          gate = q('#ss-gate'), report = q('#ss-report');
    const bar = q<HTMLElement>('#ss-progress-bar'), ptext = q('#ss-progress-text'), back = q('#ss-back');

    const tierOf = (t: string) => data.tiers[t];
    const recsFor = (flags: string[]) => {
      const ordered = flags.includes('allarch') ? ['allarch', ...flags.filter((f) => f !== 'allarch')] : flags;
      return ordered.map((f) => data.recommendations[f]).filter(Boolean);
    };

    function renderStep() {
      cards.forEach((c, i) => (c.hidden = i !== step));
      ptext.textContent = data.progressLabel.replace('{n}', String(step + 1)).replace('{total}', String(total));
      bar.style.width = ((step + 1) / total) * 100 + '%';
      back.hidden = step === 0;
    }

    q('#ss-start').addEventListener('click', () => {
      intro.hidden = true; wizard.hidden = false; renderStep();
      dl().push({ event: 'assessment_start' });
    });

    wizard.addEventListener('click', (e) => {
      const btn = (e.target as HTMLElement).closest<HTMLElement>('[data-value]');
      if (!btn) return;
      const card = btn.closest<HTMLElement>('[data-question]')!;
      answers[card.dataset.question!] = btn.dataset.value!;
      card.querySelectorAll('[data-value]').forEach((b) => b.classList.remove('is-selected'));
      btn.classList.add('is-selected');
      if (data.perQuestionTracking) dl().push({ event: 'assessment_question_answered', step: step + 1 });
      if (step < total - 1) { step++; setTimeout(renderStep, 180); } else finish();
    });

    back.addEventListener('click', () => { if (step > 0) { step--; renderStep(); } });

    function finish() {
      result = scoreAssessment(answers);
      wizard.hidden = true;
      const t = tierOf(result.tier);
      const recs = recsFor(result.flags);
      teaser.querySelector('[data-badge]')!.textContent = t.badge;
      teaser.querySelector('[data-summary]')!.textContent = t.summary;
      const hints = teaser.querySelector('[data-hints]')!;
      hints.innerHTML = '';
      recs.slice(0, 2).forEach((rec: any) => { const li = document.createElement('li'); li.textContent = rec.text; hints.appendChild(li); });
      teaser.hidden = false;
      dl().push({ event: 'assessment_complete', tier: result.tier });
    }

    q('#ss-unlock').addEventListener('click', () => {
      teaser.hidden = true; gate.hidden = false;
      dl().push({ event: 'assessment_gate_view' });
    });

    const form = gate.querySelector('form') as HTMLFormElement;
    const msg = form.querySelector('[data-msg]') as HTMLElement;
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      if (!form.checkValidity()) { form.reportValidity(); return; }
      const fd = new FormData(form);
      const contact = {
        name: String(fd.get('name') || ''), phone: String(fd.get('phone') || ''),
        email: String(fd.get('email') || ''), sex: String(fd.get('sex') || ''),
      };
      msg.textContent = data.gate.sending;
      const r = result!;
      const t = tierOf(r.tier);
      const recs = recsFor(r.flags);
      const origin = location.origin;
      const relatedLinks = data.relatedContent.onScreen
        ? recs.filter((x: any) => x.published && x.href).map((x: any) => ({ label: x.topic, url: origin + x.href }))
        : [];
      const payload = {
        form: 'implant_check', locale: data.locale, consent: true,
        contact,
        age: answers.age || '', tier: r.tier, flags: r.flags, intent: answers.intent || '', answers,
        report: {
          tierTitle: t.title, tierSummary: t.summary,
          whyBullets: recs.map((x: any) => x.text), nextSteps: t.steps || [],
          relatedLinks, ctaUrl: origin + t.ctaHref, ctaLabel: t.ctaLabel,
        },
        ts: new Date().toISOString(),
      };
      let ok = true;
      try {
        const res = await fetch(data.endpoint, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(payload) });
        ok = res.ok;
      } catch { ok = false; }

      // Build + reveal report regardless of network result.
      report.querySelector('[data-badge]')!.textContent = t.badge;
      report.querySelector('[data-title]')!.textContent = t.title;
      report.querySelector('[data-summary]')!.textContent = t.summary;
      const why = report.querySelector('[data-why]')!; why.innerHTML = '';
      recs.forEach((rec: any) => { const li = document.createElement('li'); li.textContent = rec.text; why.appendChild(li); });
      const steps = report.querySelector('[data-steps]')!; steps.innerHTML = '';
      (t.steps || []).forEach((s: string) => { const li = document.createElement('li'); li.textContent = s; steps.appendChild(li); });
      const list = report.querySelector('[data-related-list]')!; list.innerHTML = '';
      let links = data.relatedContent.onScreen
        ? recs.filter((x: any) => x.published && x.href).map((x: any) => ({ label: x.topic, href: x.href }))
        : [];
      if (links.length === 0) links = [{ label: data.reportLabels.fallbackLabel, href: data.reportLabels.fallbackHref }];
      links.forEach((l: any) => { const a = document.createElement('a'); a.href = l.href; a.textContent = '→ ' + l.label; a.className = 'text-brand-primary font-medium'; list.appendChild(a); });
      const cta = report.querySelector('[data-cta]') as HTMLAnchorElement;
      cta.href = t.ctaHref; cta.textContent = t.ctaLabel;
      (report.querySelector('[data-error]') as HTMLElement).hidden = ok;

      gate.hidden = true; report.hidden = false;
      msg.textContent = ok ? data.gate.success : data.gate.error;
      dl().push({ event: 'lead_submit', form: 'implant_check', tier: r.tier });
      dl().push({ event: 'assessment_report_view' });
      report.scrollIntoView({ behavior: 'smooth', block: 'start' });
    });
  }
</script>
```

- [ ] **Step 2: Commit**

```bash
git add web/src/components/assessment/AssessmentApp.astro
git commit -m "feat(assessment): orchestrator app + client wizard/teaser/gate/report logic"
```

---

## Task 10: The three pages

**Files:**
- Create: `web/src/pages/implant-check/index.astro`
- Create: `web/src/pages/en/implant-check/index.astro`
- Create: `web/src/pages/zh-cn/implant-check/index.astro`

- [ ] **Step 1: TH page**

Create `web/src/pages/implant-check/index.astro`:

```astro
---
import Base from '~/layouts/Base.astro';
import AssessmentApp from '~/components/assessment/AssessmentApp.astro';
import { getAssessment } from '~/lib/assessment-content';
const lang = 'th' as const;
const data = await getAssessment(lang);
const faqLd = {
  '@context': 'https://schema.org', '@type': 'FAQPage',
  mainEntity: data.faq.map((f: any) => ({ '@type': 'Question', name: f.q, acceptedAnswer: { '@type': 'Answer', text: f.a } })),
};
const pageLd = { '@context': 'https://schema.org', '@type': 'MedicalWebPage', name: data.meta.title, description: data.meta.description };
---
<Base title={data.meta.title} description={data.meta.description} robots="noindex,follow" stickyCta={true} jsonLd={[pageLd, faqLd]}>
  <AssessmentApp data={data} lang={lang} />
</Base>
```

- [ ] **Step 2: EN page**

Create `web/src/pages/en/implant-check/index.astro` — identical except `const lang = 'en' as const;`.

```astro
---
import Base from '~/layouts/Base.astro';
import AssessmentApp from '~/components/assessment/AssessmentApp.astro';
import { getAssessment } from '~/lib/assessment-content';
const lang = 'en' as const;
const data = await getAssessment(lang);
const faqLd = {
  '@context': 'https://schema.org', '@type': 'FAQPage',
  mainEntity: data.faq.map((f: any) => ({ '@type': 'Question', name: f.q, acceptedAnswer: { '@type': 'Answer', text: f.a } })),
};
const pageLd = { '@context': 'https://schema.org', '@type': 'MedicalWebPage', name: data.meta.title, description: data.meta.description };
---
<Base title={data.meta.title} description={data.meta.description} robots="noindex,follow" stickyCta={true} jsonLd={[pageLd, faqLd]}>
  <AssessmentApp data={data} lang={lang} />
</Base>
```

- [ ] **Step 3: zh-CN page**

Create `web/src/pages/zh-cn/implant-check/index.astro` — identical except `const lang = 'zh-cn' as const;`.

```astro
---
import Base from '~/layouts/Base.astro';
import AssessmentApp from '~/components/assessment/AssessmentApp.astro';
import { getAssessment } from '~/lib/assessment-content';
const lang = 'zh-cn' as const;
const data = await getAssessment(lang);
const faqLd = {
  '@context': 'https://schema.org', '@type': 'FAQPage',
  mainEntity: data.faq.map((f: any) => ({ '@type': 'Question', name: f.q, acceptedAnswer: { '@type': 'Answer', text: f.a } })),
};
const pageLd = { '@context': 'https://schema.org', '@type': 'MedicalWebPage', name: data.meta.title, description: data.meta.description };
---
<Base title={data.meta.title} description={data.meta.description} robots="noindex,follow" stickyCta={true} jsonLd={[pageLd, faqLd]}>
  <AssessmentApp data={data} lang={lang} />
</Base>
```

- [ ] **Step 4: Build verification**

Run: `cd web && npm run build 2>&1 | tail -20`
Expected: build succeeds; output includes `implant-check/index.html`, `en/implant-check/index.html`, `zh-cn/implant-check/index.html`. (Pre-existing unrelated warnings ok.)

- [ ] **Step 5: Manual UI check**

Run: `cd web && npm run preview` then open `http://localhost:4321/implant-check/`.
Verify: intro → Start → answer all 10 → teaser shows tier + 2 hints → "full report" → gate → submit (email send will fail in preview — expected) → full report renders with why/steps/related-fallback/CTA + error note shown. Repeat on `/en/implant-check/` and `/zh-cn/implant-check/`. Confirm no leaked locale strings, hreflang present in `<head>`, `prefers-reduced-motion` (DevTools) still usable.

- [ ] **Step 6: Commit**

```bash
git add web/src/pages/implant-check/index.astro web/src/pages/en/implant-check/index.astro web/src/pages/zh-cn/implant-check/index.astro
git commit -m "feat(assessment): trilingual /implant-check/ pages"
```

---

## Task 11: Email builder (`lib/assessment-email.ts`) — TDD

**Files:**
- Create: `web/src/lib/assessment-email.ts`
- Test: `web/src/lib/assessment-email.test.ts`

- [ ] **Step 1: Write the failing test**

Create `web/src/lib/assessment-email.test.ts`:

```ts
import { test, expect } from 'vitest';
import { buildAssessmentEmail, type EmailReport } from './assessment-email';

const report: EmailReport = {
  tierTitle: 'You look well-prepared',
  tierSummary: 'Most factors favor implants.',
  whyBullets: ['No smoking', 'Healthy gums'],
  nextSteps: ['Consult', 'Plan'],
  relatedLinks: [{ label: 'Bone grafting', url: 'https://go.example.com/x' }],
  ctaUrl: 'https://go.example.com/#booking',
  ctaLabel: 'Book a consult',
};

test('includes greeting, tier title, why, steps, cta', () => {
  const { subject, html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: false });
  expect(subject.length).toBeGreaterThan(0);
  expect(html).toContain('Nin');
  expect(html).toContain('You look well-prepared');
  expect(html).toContain('No smoking');
  expect(html).toContain('Book a consult');
});

test('related block hidden when relatedOn=false', () => {
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: false });
  expect(html).not.toContain('Bone grafting');
});

test('related block shown when relatedOn=true', () => {
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: true });
  expect(html).toContain('Bone grafting');
});

test('escapes HTML in dynamic content', () => {
  const r = { ...report, tierTitle: '<script>x</script>' };
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report: r, relatedOn: false });
  expect(html).not.toContain('<script>x</script>');
  expect(html).toContain('&lt;script&gt;');
});

test('falls back to th chrome for unknown locale', () => {
  // @ts-expect-error testing fallback
  const { subject } = buildAssessmentEmail({ name: 'A', locale: 'xx', report, relatedOn: false });
  expect(subject.length).toBeGreaterThan(0);
});
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd web && npx vitest run src/lib/assessment-email.test.ts`
Expected: FAIL — cannot find module `./assessment-email`.

- [ ] **Step 3: Implement**

Create `web/src/lib/assessment-email.ts`:

```ts
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
```

- [ ] **Step 4: Run to verify it passes**

Run: `cd web && npx vitest run src/lib/assessment-email.test.ts`
Expected: PASS (5 tests).

- [ ] **Step 5: Commit**

```bash
git add web/src/lib/assessment-email.ts web/src/lib/assessment-email.test.ts
git commit -m "feat(assessment): localized email builder + tests"
```

---

## Task 12: Worker endpoint (`worker/index.ts`) — TDD

**Files:**
- Create: `web/worker/index.ts`
- Test: `web/worker/index.test.ts`
- Modify: `web/wrangler.jsonc`

- [ ] **Step 1: Write the failing test**

Create `web/worker/index.test.ts`:

```ts
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
  report: { tierTitle: 'T', tierSummary: 'S', whyBullets: [], nextSteps: [], relatedLinks: [], ctaUrl: 'https://x/#b', ctaLabel: 'Book' },
  ts: '2026-06-08T00:00:00Z',
};

beforeEach(() => { vi.restoreAllMocks(); env.ASSETS.fetch.mockClear(); });

test('non-API request is served by ASSETS', async () => {
  const res = await worker.fetch(new Request('https://go.x/implant-check/'), env);
  expect(env.ASSETS.fetch).toHaveBeenCalled();
  expect(await res.text()).toBe('asset');
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
```

- [ ] **Step 2: Run to verify it fails**

Run: `cd web && npx vitest run worker/index.test.ts`
Expected: FAIL — cannot find module `./index`.

- [ ] **Step 3: Implement**

Create `web/worker/index.ts`:

```ts
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
  } catch { /* non-fatal */ }

  return json({ ok: n8nOk }, n8nOk ? 200 : 502);
}

export default {
  async fetch(request: Request, env: Env): Promise<Response> {
    const url = new URL(request.url);
    if (url.pathname === '/api/assessment-lead' && request.method === 'POST') {
      return handleLead(request, env);
    }
    return env.ASSETS.fetch(request);
  },
};
```

- [ ] **Step 4: Run to verify it passes**

Run: `cd web && npx vitest run worker/index.test.ts`
Expected: PASS (4 tests).

- [ ] **Step 5: Wire the Worker into wrangler**

In `web/wrangler.jsonc`: add a top-level `"main": "worker/index.ts",` (e.g. right after `"compatibility_date"`), add `"binding": "ASSETS"` inside the `"assets"` object, and add a `"vars"` block. Result `assets` + new keys:

```jsonc
  "main": "worker/index.ts",
  "assets": {
    "directory": "./dist",
    "binding": "ASSETS",
    "not_found_handling": "404-page",
    "html_handling": "auto-trailing-slash"
  },
  "vars": {
    "N8N_ASSESSMENT_WEBHOOK_URL": "https://nexorcus.app.n8n.cloud/webhook/smilescape-implant-check-lead",
    "RESEND_FROM": "SmileScape <results@smilescapeclinic.com>",
    "RELATED_EMAIL_ENABLED": "false"
  },
```

(`RESEND_API_KEY` is a secret, set in Task 14 — never put it in `vars`.)

- [ ] **Step 6: Commit**

```bash
git add web/worker/index.ts web/worker/index.test.ts web/wrangler.jsonc
git commit -m "feat(assessment): CF Worker endpoint (n8n + Resend) + ASSETS fallback + tests"
```

---

## Task 13: Local end-to-end verify with `wrangler dev`

**Files:** none (verification only)

- [ ] **Step 1: Build then run the Worker locally**

Run: `cd web && npm run build && npx wrangler dev`
Open the printed local URL + `/implant-check/`.

- [ ] **Step 2: Exercise the flow**

Complete the wizard → gate → submit. In the `wrangler dev` console, observe the outbound POSTs. Without a real `RESEND_API_KEY`/n8n the calls may 401/404 — that's fine; confirm: (a) `/api/assessment-lead` is hit (not served as a static asset), (b) the report still renders on-screen, (c) ASSETS still serves `/implant-check/` and the homepage.

- [ ] **Step 3: Confirm static fallback**

Visit `/` and `/en/implant-check/` under `wrangler dev` — both served (ASSETS binding working). No commit (verification task).

---

## Task 14: Resend + secrets setup (operator-gated)

**Files:** none (infra config)

- [ ] **Step 1: Verify a Resend sending domain**

Using the Resend MCP (or dashboard): create/verify a sending domain for `smilescapeclinic.com` (or subdomain `mail.smilescapeclinic.com`); add the SPF/DKIM DNS records via Cloudflare DNS. Confirm `RESEND_FROM` (`results@…`) matches the verified domain. **Operator action** if DNS access is needed.

- [ ] **Step 2: Create the API key + set the Worker secret**

```bash
cd web && npx wrangler secret put RESEND_API_KEY
# paste the Resend API key when prompted
```

- [ ] **Step 3: Confirm/adjust the n8n webhook**

Create the n8n workflow at `…/webhook/smilescape-implant-check-lead` (or change `N8N_ASSESSMENT_WEBHOOK_URL` in `wrangler.jsonc` to reuse the homepage webhook). Map the payload fields to the lead pipeline. **Operator action.** No code commit.

---

## Task 15: Homepage & nav entry CTAs (additive, low-risk)

**Files:**
- Modify: `web/src/layouts/Base.astro`
- Create: `web/src/components/sections/AssessmentBand.astro`
- Modify: `web/src/pages/index.astro`, `web/src/pages/en/index.astro`, `web/src/pages/zh-cn/index.astro`

- [ ] **Step 1: Add a localized nav link**

In `web/src/layouts/Base.astro`, in `navByLocale`, add a non-CTA link before the booking CTA in each locale:
- th: `{ href: '/implant-check/', label: 'เช็กความพร้อมรากเทียม' }`
- en: `{ href: '/en/implant-check/', label: 'Implant Readiness Check' }`
- 'zh-cn': `{ href: '/zh-cn/implant-check/', label: '种植牙自测' }`

Example (th array becomes):

```js
  th: [{ href: '/lp/dental-implant/', label: 'รากฟันเทียม' }, { href: '/implant-check/', label: 'เช็กความพร้อมรากเทียม' }, { href: '/#booking', label: 'จองคิว', cta: true }],
```

(Do the same for `en` and `zh-cn`.)

- [ ] **Step 2: Create the entry band**

Create `web/src/components/sections/AssessmentBand.astro`:

```astro
---
import Section from '~/components/ui/Section.astro';
import type { Locale } from '~/lib/home';
const lang = (Astro.currentLocale ?? 'th') as Locale;
const COPY = {
  th: { eyebrow: 'เช็กฟรี ~1 นาที', title: 'คุณเหมาะกับรากฟันเทียมไหม?', body: 'ทำแบบประเมินความพร้อมเบื้องต้น รับคำแนะนำเฉพาะคุณ', cta: 'เริ่มเช็กเลย', href: '/implant-check/' },
  en: { eyebrow: 'Free ~1-min check', title: 'Are you a candidate for dental implants?', body: 'Take the readiness check and get personalized guidance', cta: 'Start the check', href: '/en/implant-check/' },
  'zh-cn': { eyebrow: '免费约 1 分钟', title: '您适合种植牙吗？', body: '做个适合度自测，获取个性化建议', cta: '开始自测', href: '/zh-cn/implant-check/' },
};
const c = COPY[lang] ?? COPY.th;
---
<Section tone="ice">
  <div data-reveal class="max-w-4xl mx-auto text-center rounded-3xl bg-brand-paper border border-brand-neutral-200 px-6 py-10">
    <p class="font-display text-xs uppercase tracking-wide text-brand-primary">{c.eyebrow}</p>
    <h2 class="mt-3 font-display text-2xl sm:text-3xl font-bold text-brand-anchor">{c.title}</h2>
    <p class="mt-3 text-brand-neutral-700">{c.body}</p>
    <a href={c.href} class="mt-6 inline-block rounded-full bg-brand-primary px-8 py-3 font-semibold text-brand-neutral-0 hover:bg-brand-primary-deep u-hover">{c.cta}</a>
  </div>
</Section>
```

- [ ] **Step 2b: Insert the band into each homepage**

In each of `web/src/pages/index.astro`, `web/src/pages/en/index.astro`, `web/src/pages/zh-cn/index.astro`: add the import `import AssessmentBand from '~/components/sections/AssessmentBand.astro';` and place `<AssessmentBand />` in the composition immediately **before** the booking/`BookingForm` section (search the file for `BookingForm` or `id="booking"` and insert the line above it). This is purely additive.

- [ ] **Step 3: Build + verify**

Run: `cd web && npm run build 2>&1 | tail -5` (expect success)
Run: `cd web && npm run preview` → check homepage (all 3 locales) shows the band + nav link, and links land on `/implant-check/`.

- [ ] **Step 4: Commit**

```bash
git add web/src/layouts/Base.astro web/src/components/sections/AssessmentBand.astro web/src/pages/index.astro web/src/pages/en/index.astro web/src/pages/zh-cn/index.astro
git commit -m "feat(assessment): homepage entry band + nav link to /implant-check/"
```

---

## Task 16: Final verification & deploy

**Files:** none

- [ ] **Step 1: Full test suite**

Run: `cd web && npm test`
Expected: all assessment + email + worker tests pass.

- [ ] **Step 2: Type check**

Run: `cd web && npm run check 2>&1 | grep -iE "implant-check|assessment" | head`
Expected: no NEW errors in assessment files (the ~19 pre-existing `Landing.astro`/`lp/dental-implant.astro` errors remain and are out of scope).

- [ ] **Step 3: Build**

Run: `cd web && npm run build 2>&1 | tail -5`
Expected: success.

- [ ] **Step 4: Deploy (operator-gated)**

Run: `cd web && npx wrangler deploy`
Then smoke-test `https://go.smilescapeclinic.com/implant-check/` end-to-end with a real email address; confirm the Resend email arrives and the n8n lead is recorded.

- [ ] **Step 5: Pre-launch compliance pass**

Have all result/teaser/email copy reviewed against Thai dental-advertising + medical-claims guardrails (no guarantees/superlatives; educational framing intact). Update copy in the YAML files only if flagged.

---

## Self-Review notes (author)

- **Spec coverage:** D1 instrument→Tasks 4–6; D2 teaser→gate→full→Task 9; D3 soft teaser→Task 9 (no lock); D4 n8n+Resend via Worker→Tasks 11–12; D5 URL→Task 10; D6 locales→Tasks 4–6,10; D7 noindex→Task 10 (`robots`); D8 wizard→Tasks 7,9; D9 related switches→content `relatedContent` + Worker `RELATED_EMAIL_ENABLED`; D10 demographics→`age` Q1 (Task 4–6/2) + optional `sex` in gate (Task 8) + payload (Task 9/12). Compliance→Task 16 Step 5 + disclaimers throughout. Entry CTAs→Task 15. LINE phase-2 seam: gate is an isolated component (mode swap is future work, not built now — per spec §13/§16).
- **Type consistency:** `scoreAssessment(answers)→{tier,flags}` used identically in Task 2 + Task 9; `buildAssessmentEmail({name,locale,report,relatedOn})` + `EmailReport` identical in Task 11 + Task 12; option values match between content YAML (Tasks 4–6) and scoring (Task 2); JSON-island keys (`tiers/recommendations/relatedContent/reportLabels/progressLabel`) match between `AssessmentApp` `clientData` (Task 9) and the client script (Task 9).
- **No placeholders:** all code + content provided in full; `href: ''`/`published: false` in recommendations are intentional data states (the graceful related-content switch), not plan placeholders.
```
