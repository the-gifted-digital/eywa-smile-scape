# SmileScape — Interactive Implant Readiness Check (`/implant-check/`) — Design Spec

> **Date:** 2026-06-08 · **Author:** operator + Claude (brainstorming session) · **Status:** approved design, pre-implementation (touch-up pass pending)
> **Workstream B** of the 2026-06-07 handover (`docs/HANDOVER-2026-06-07.md`) — the interactive dental self-assessment lead-gen page, deferred from the homepage polish chat.
> **Branch:** `web-skeleton` · **App:** `web/` (Astro 4 + Tailwind, Cloudflare Workers Static Assets).
> **Reuses:** the homepage component library + motion layer + `Base.astro` shell + n8n lead pattern (see `memory/homepage-component-library.md`).

---

## 1. Context — verified live state (not assumed)

- **Stack (verified this session):** `web/astro.config.mjs` → **static** output (no adapter), `site: smilescapeclinic.com`, `trailingSlash: 'always'`, i18n `defaultLocale: th` (no prefix), `en` → `/en/`, `zh-cn` → `/zh-cn/`, `fallback: { en: th, 'zh-cn': th }`. Build format `directory`.
- **Deploy (verified):** `web/wrangler.jsonc` — **Cloudflare Workers + Static Assets**, `assets.directory: ./dist`, custom domain `go.smilescapeclinic.com`. Deploy = `npm run build && npx wrangler deploy` (run from `web/`). No `main` Worker entry today → assets-only.
- **Reusable assets already in repo:**
  - `layouts/Base.astro` — full-site shell: i18n `<html lang>` + auto hreflang (derives th/en/zh-cn alternates from pathname), SEO/OG, Dentist JSON-LD, `robots` prop (default `noindex,follow`), `jsonLd` prop (merge extra nodes), `stickyCta` prop, global `line_click`/`call_click` delegated listeners, **motion layer** (`data-reveal` / `data-reveal-stagger` / `data-parallax`, `prefers-reduced-motion`-safe), GTM `GTM-NFBVZT43` via Partytown.
  - `components/forms/BookingForm.astro` — the **gate pattern source**: trilingual via internal `LABELS[lang]` map + `Astro.currentLocale`, PDPA consent checkbox, client `fetch` → n8n webhook, fires `dataLayer.push({event:'lead_submit'})` on `res.ok`, `data-*` attrs carry localized status messages.
  - `components/ui/` (`Section`, `SectionHeading`, `Button`, `Image` [DR-035 seam]), `components/FaqBlock.astro` (emits FAQPage JSON-LD), `components/RelatedContent.astro` (DR-021 internal-linking render point).
  - `content/config.ts` — `pages` + `articles` (`type:'content'`) and `home` (`type:'data'`) collections; `lib/home.ts` `getHome(locale)` pattern.
- **Existing lead pipeline:** homepage `BookingForm` POSTs to n8n `https://nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form`. LINE `https://maac.io/6yp2p`, phone `+66922936226` / `092 293 6226`.
- **Content reality:** the site currently has only `index` (3 locales), `lp/dental-implant`, `privacy-policy`. The service/knowledge pages this assessment would link to (bone grafting, All-on-X, gum care, …) **mostly do not exist yet** (sitemap WIP). The design must degrade gracefully.

## 2. Goal / non-goals

**Goal.** Ship a dedicated, trilingual, interactive **Implant Readiness Check** at `/implant-check/` (+ `/en/`, `/zh-cn/`): a step-by-step wizard (~9 questions) grounded in recognized clinical implant-eligibility factors, framed as an **educational self-check (not a diagnosis)**. After completion it shows a **free teaser result**, then a **soft, non-hardsell gate** (name/phone/email + PDPA) that unlocks the **full personalized report on-screen** and emails a detailed copy. Lead → n8n (existing pipeline); email → Resend (via a thin Cloudflare Worker endpoint). The page is a shareable, ad-landing-friendly, SEO/AEO lead magnet, built from the existing component library + motion layer.

**Non-goals (this workstream).**
- No change to the homepage, LP, or other live pages **except** small additive entry CTAs (§12), done last and low-risk.
- No real article/service destination pages — related links are data-driven with graceful fallback (§5); building those pages is deliverable 2.
- No LINE-OA gate yet — design the gate so it can **switch** to "add LINE first" in phase 2 (§13), but ship the email gate now.
- No apex cutover, no removing `noindex` (stays `noindex,follow` on `go.`).
- No numeric "score" shown to users (compliance — §11); rules-engine tiers only.
- Do **not** touch `lp/dental-implant.astro`, `Landing.astro`, `privacy-policy.astro`.

## 3. Decisions locked in brainstorm (do not re-litigate)

| # | Decision | Choice |
|---|----------|--------|
| D1 | Instrument | **Implant Readiness Check** ("Am I a candidate?"), ~9 Q, recognized clinical risk factors, educational self-check (not diagnosis) |
| D2 | Results flow | **Teaser (free, on-screen) → soft gate → full report on-screen + emailed copy** (refines handover's email-only) |
| D3 | Teaser tone | **No lock/blur metaphor.** Give real partial value, then a soft "want the full personalized report?" invite — an offer, not a wall |
| D4 | Backend split | **Lead → n8n** (existing pipeline, consistency) · **Email → Resend** (REST API) — both orchestrated by one thin **Cloudflare Worker** endpoint |
| D5 | URL | `/implant-check/` (+ `/en/implant-check/`, `/zh-cn/implant-check/`) |
| D6 | Locales | **All 3** (TH / EN / zh-CN) at parity |
| D7 | Index policy | `noindex,follow` (go. policy; flip at apex cutover) |
| D8 | Quiz UX | **Step-by-step wizard** (one card per question + progress + motion reveal) |
| D9 | Related-content in email | **Designed but switched OFF by default** (`relatedContent.email = false`); on-screen related links ON but render only available targets, else fallback |

## 4. Instrument — the questions

**Framework honesty.** No single validated patient-facing "implant readiness" questionnaire exists. This is a **branded self-check grounded in recognized clinical risk/success factors** documented in implant dentistry literature. Cited sources (shown in a "how this works / references" disclosure): **ITI (International Team for Implantology)** treatment guidance, **AAP (American Academy of Periodontology)** (periodontal / peri-implant disease), **ADA** (patient oral-health info), and peer-reviewed systematic reviews on **smoking** and **diabetes** vs. implant outcomes. Framing throughout: "factors a dentist considers" — never a diagnosis.

| # | id | Question (TH gist) | Options (value) | Sets |
|---|-----|--------------------|-----------------|------|
| 1 | `situation` | สถานการณ์ฟันตอนนี้ | many/all-missing · 1-2 missing · about-to-extract · denture-bridge-unhappy · teeth-intact-researching | need + intent; `intact` → Informational result |
| 2 | `duration` | ฟัน/ช่องว่างหายมานานแค่ไหน | <6mo · 6mo-2y · >2y · none | `flag:bone` if `>2y` |
| 3 | `bone` | เคยถูกบอกว่ากระดูกไม่พอ / ต้องปลูกกระดูก-ยกไซนัส | yes · no · unsure | `flag:bone` if yes/unsure |
| 4 | `gums` | เหงือก: เลือดออก/บวม-ร่น/เคยเป็นโรคเหงือก | often · sometimes · never | `flag:perio` if often |
| 5 | `smoking` | สูบบุหรี่ | regular · occasional-quitting · none | `flag:smoking` if regular |
| 6 | `diabetes` | เบาหวาน + การคุมน้ำตาล | yes-poor/unsure · yes-controlled · no | `flag:medical` if poor/unsure |
| 7 | `medical` | bisphosphonate/ยากระดูกพรุน · ฉายแสงขากรรไกร · ภูมิคุ้มกันบกพร่อง | has-any · none · unsure | `flag:complex` if has-any |
| 8 | `bruxism` | นอนกัดฟัน/กัดแน่นบ่อย | yes · unsure · no | `flag:bruxism` if yes (minor) |
| 9 | `intent` | ความพร้อม/เป้าหมาย | soon · 3-6mo · researching | lead temperature (n8n routing); **not** scored to tier |

**Deliberately omitted:** an age question (kept to 9, avoids feeling intrusive). Covered by a universal disclaimer: "implants are for adults with completed jaw growth; an in-person exam confirms suitability." Easy to add later if desired (touch-up candidate).

## 5. Scoring — rules engine (flags → tier), not a numeric score

Pure function `scoreAssessment(answers): { tier, flags, recommendations }` in `lib/assessment.ts`. Tier resolved by priority (first match wins):

1. **`info` — Informational** — if `situation = teeth-intact-researching`. Copy: "implants aren't needed right now — here's what to know for the future." Soft CTA. (Honors brand value: **no over-treatment**.)
2. **🟠 `C` — "ควรให้ทันตแพทย์ประเมินก่อน" (needs professional evaluation)** — if `flag:complex` (Q7) **or** `flag:medical` (Q6 poorly-controlled diabetes). Honest, non-promissory: "your situation needs an individual evaluation."
3. **🟡 `B` — "เหมาะ — ควรเตรียมพร้อมก่อน" (candidate with preparation)** — if any of `flag:bone | perio | smoking | bruxism`. Personalized prep recommendations.
4. **🟢 `A` — "เหมาะกับรากฟันเทียม" (good candidate)** — none of the above; mostly favorable answers.

**All tiers end on a "book a free consultation" CTA**, with copy tuned per tier. Tier badge + tier copy come from the content collection (localized).

**Representative verification cases** (for testing the pure function):
- All favorable (no flags) → `A`.
- `bone=yes` only → `B` + bone recommendation.
- `medical=has-any` + `bone=yes` → `C` (complex overrides B).
- `diabetes=yes-poor` → `C`. `smoking=regular` only → `B`.
- `situation=teeth-intact-researching` (+ any flags) → `info` (situation overrides).

## 6. Personalized recommendations (flag → recommendation → optional link)

Each fired flag maps to a localized recommendation entry `{ text, topic, href, published }`:

| flag | recommendation gist | links to (topic) |
|------|--------------------|------------------|
| `bone` | อาจต้องปลูกกระดูก — เทคนิค Sausage (Dr. Urban) | bone-grafting page |
| `perio` | รักษาเหงือกให้พร้อมก่อน | gum-care / perio page |
| `smoking` | ลด/เลิกบุหรี่เพิ่มโอกาสสำเร็จ | knowledge page |
| `diabetes`/`medical` | คุมน้ำตาลให้ดีก่อนทำ | knowledge page |
| `bruxism` | อาจต้องใส่เฝือกสบฟัน | knowledge page |
| `situation=many/all-missing` | All-on-X immediate loading อาจเหมาะ | all-on-x page |
| `complex` | ปรึกษาทันตแพทย์เฉพาะทางเพื่อประเมินรายบุคคล | (no link; consult CTA) |

**Related-content engine (graceful):** the map lives in the content collection. A link renders only if `published: true`; otherwise it is **omitted** (on-screen) or the block falls back to a single "ปรึกษา/ดูบริการรากฟันเทียม" link pointing at the live LP (`/lp/dental-implant/`). Two switches (per D9): `relatedContent.onScreen` (default **true**) and `relatedContent.email` (default **false**). As real pages ship, flip `published` per entry — no code change. Reuses the spirit of `RelatedContent.astro`.

## 7. Page flow & UX

```
INTRO ─▶ WIZARD (Q1..Q9, one card, progress, back/next, motion reveal)
        └─ on finish: scoreAssessment(answers) [client] ─▶ TEASER (free, on-screen)
              └─ "ขอรายงานฉบับเต็ม (ฟรี)" ─▶ GATE (name/phone/email + PDPA)
                    └─ submit ─▶ POST /api/assessment-lead (Worker)
                          ├─ Worker → n8n (lead) + Resend (email)
                          └─ on response ─▶ FULL REPORT on-screen (already computed) + success
```

- **Intro:** short hero — headline ("คุณเหมาะกับรากฟันเทียมไหม?"), ~1-min / free / "not a diagnosis", **Start** button. Server-rendered (SSG) so content is crawlable.
- **Wizard:** all question cards present in the DOM (crawlable), JS shows one at a time; progress bar (`ข้อ n/9`); auto-advance on select with a small delay, plus Back/Next; uses the existing motion layer for card reveal. State held in a plain JS object.
- **Teaser (D3):** tier badge + a genuine partial insight given freely; a soft invite card describing what the full report adds; one button → gate. No lock/blur.
- **Gate:** mirrors `BookingForm` (fields, PDPA checkbox, localized messages, validation) but submits to the Worker endpoint, not directly to n8n. Privacy-policy link.
- **Full report:** tier + "why you're in this group" + recommended next steps + (switchable) related links + book / LINE / call CTAs + disclaimer. Revealed client-side after the gate response (the result was already computed at teaser time).
- **Trust + FAQ:** a "how this works / references" disclosure (sources, disclaimer) + `FaqBlock` (FAQPage JSON-LD) at the foot.

## 8. Architecture — components, content, lib, worker

**New files (proposed):**
```
web/src/
  pages/
    implant-check/index.astro          # TH
    en/implant-check/index.astro       # EN
    zh-cn/implant-check/index.astro    # zh-CN   (thin: getAssessment(locale) → <AssessmentApp/>)
  components/assessment/
    AssessmentApp.astro                # orchestrator: renders intro+wizard+teaser+gate+report scaffold; ships client script
    QuestionCard.astro                 # one question (label/options) — rendered in a loop, hidden until active
    ResultPanel.astro                  # tier + recs + related links template (populated by client)
    AssessmentGate.astro               # gate form (BookingForm-derived), posts to Worker
  lib/
    assessment.ts                      # PURE scoreAssessment(answers) → {tier, flags, recommendations}; shared client+worker
    assessment-content.ts              # getAssessment(locale) (mirrors lib/home.ts)
    assessment-email.ts                # buildEmailHtml({tier, recs, contact, locale, relatedOn}) → localized HTML string (shared)
  content/assessment/{th,en,zh-cn}.yaml
  worker/index.ts                      # thin Worker: POST /api/assessment-lead → n8n + Resend; else ASSETS.fetch
```

**Content collection `assessment` (`type:'data'`, schema in `content/config.ts`):** `meta{title,description}`, `intro{eyebrow,title,body,startLabel,timeNote,disclaimer}`, `questions[]{id,eyebrow,text,options[]{label,value,flags[]}}`, `tiers{A,B,C,info}{badge,title,summary,nextStepsLabel,ctaLabel,ctaHref}`, `recommendations{<flag>:{text,topic,href,published}}`, `relatedContent{onScreen:boolean,email:boolean}`, `teaser{inviteTitle,inviteBody,buttonLabel}`, `gate{title,body,...}`, `references[]`, `faq[]`. Component-level microcopy (button/error/status strings) stays in internal `LABELS[lang]` maps (BookingForm pattern), **not** the collection.

**Client script (vanilla TS, no framework — consistent with the codebase):** manages step index + answers, calls `scoreAssessment` (imported from `lib/assessment.ts`, bundled by Astro into the client script), drives teaser→gate→report DOM, fires GTM events, POSTs the gate. Localized copy (questions/tiers/recs) is emitted by `AssessmentApp` as a JSON `<script type="application/json">` block and read by the client — so no locale strings are hardcoded in the script.

**Tokens/i18n/images:** `brand-*` Tailwind + `font-sans`/`font-display` only (DR-029); per-locale content via collection + `Astro.currentLocale`; any imagery via `Image.astro` (DR-035). Page uses `Base.astro` with `robots="noindex,follow"`, `jsonLd` = `MedicalWebPage` + FAQ.

## 9. Backend — Worker endpoint, n8n, Resend

**Worker (`web/worker/index.ts`), wired via `wrangler.jsonc`:** add `main: "worker/index.ts"` and `assets.binding: "ASSETS"`. Logic:
```
if (POST /api/assessment-lead):
    parse {contact{name,phone,email}, consent, answers, tier, flags, locale, ts}
    validate + basic anti-abuse (require consent; simple rate/heuristic)
    1) forward lead → fetch(N8N_ASSESSMENT_WEBHOOK_URL, JSON)   // lead capture (must-succeed)
    2) build localized email via assessment-email.ts (relatedOn = relatedContent.email)
       send → fetch('https://api.resend.com/emails', Bearer RESEND_API_KEY, from RESEND_FROM)  // best-effort
    return 200 if (1) ok (email failure is non-fatal, logged); 5xx if (1) failed
else:
    return env.ASSETS.fetch(request)   // serve static site unchanged
```
- **n8n payload** extends the homepage shape: `{ form:'implant_check', name, phone, email, consent, locale, tier, flags, answers, intent, ts }`. **Recommend a new webhook** `smilescape-implant-check-lead` so automations/routing differ from homepage; reuse the existing webhook only if the operator prefers (config value).
- **Resend:** REST call from the Worker (no SDK needed). Requires a **verified sending domain** (e.g., `smilescapeclinic.com` or `mail.smilescapeclinic.com`) + `RESEND_FROM` (e.g., `SmileScape <results@smilescapeclinic.com>`). DNS (SPF/DKIM) added via Cloudflare. The Resend MCP can create the domain + key and preview/test the template during build.
- **Client failure handling:** the **full report still renders on-screen** once the gate is submitted (it was computed client-side) — a network failure never blocks the user's result. On Worker 5xx, show a subtle "couldn't send email — call/LINE us" note (call/LINE still convert). Optional defensive fallback: client may also POST the lead directly to n8n (homepage path) if the Worker errors.

**Why one Worker doing both:** keeps the Resend key server-side, one round-trip, one error path, CORS-free (same origin), and n8n stays the lead store (D4). The site remains 100% static except this one route.

## 10. Tracking (GTM `GTM-NFBVZT43`)

`dataLayer.push` events: `assessment_start`, `assessment_complete` (`{tier}`), `assessment_gate_view`, `lead_submit` (`{form:'implant_check'}`), `assessment_report_view`. Optional/noisy (off by default): `assessment_question_answered` (`{step}`). Global `line_click` / `call_click` already handled by `Base.astro`.

## 11. Compliance & legal (healthcare)

- **Educational, not diagnosis** — disclaimer on intro, each question foot, teaser, full report, and email: "เพื่อการศึกษาเบื้องต้น ไม่ใช่การวินิจฉัยทางการแพทย์ — ผลขึ้นกับการตรวจโดยทันตแพทย์."
- **No numeric score**, no guarantees/superlatives in result copy (Thai dental-advertising law + medical-claims guardrails, same as LP/homepage). Tiers describe **readiness / what to prepare**, not "you can / cannot."
- **Tier C** uses honest, non-promissory language.
- **PDPA** consent checkbox required at the gate (reuse pattern) + privacy-policy link; n8n/email only after consent.
- **Cited sources** disclosed (ITI/AAP/ADA + reviews) to back "internationally recognized."
- **Pre-launch gate:** a healthcare-marketing compliance review of all copy. (Note: the available compliance specialist agent is China-focused; for Thai law rely on the LP/homepage guardrails + the operator's compliance contact.) This is a launch checklist item, not a code blocker.

## 12. Homepage & site entry CTAs (done last, low-risk, additive)

After the page exists and is verified: add entry points — (a) `Base.astro` nav link to `/implant-check/` (localized), (b) homepage hero **secondary CTA** href → `/implant-check/` (edit `home/*.yaml` only), optionally (c) a small dedicated band on the homepage. Each is additive + reversible; the live homepage layout/components are otherwise untouched. Later: link from service/concern pages as they ship.

## 13. LINE-first phase-2 seam

The gate is a swappable component with a `mode` concept: `mode:'email'` (now) vs `mode:'line'` (phase 2 — "add our LINE OA to receive your full report", deep-link `https://maac.io/6yp2p`, then deliver via LINE). Keep the gate's contract (`onUnlock(contact)`) stable so switching modes is a config/content change, not a rewrite. No LINE Messaging API work now.

## 14. Config & secrets

- `web/wrangler.jsonc`: add `main`, `assets.binding="ASSETS"`; vars `N8N_ASSESSMENT_WEBHOOK_URL`, `RESEND_FROM`, `RELATED_EMAIL_ENABLED` (mirror of D9 for the worker). Secret: `RESEND_API_KEY` (`npx wrangler secret put`).
- GTM already active (`GTM-NFBVZT43`). Local UI dev = `astro dev` (Worker route absent → report still shows, email skipped); endpoint testing = `npx wrangler dev` against `./dist` + worker.

## 15. Testing, verification & deploy

- `scoreAssessment` is pure → verify the §5 representative cases (lightweight `node:test` spec optional; no test runner exists today — don't add heavy infra).
- `npm run check` (ignore the ~19 pre-existing errors in `Landing.astro` / `lp/dental-implant.astro`), `npm run build`, `npm run preview` (UI), `npx wrangler dev` (endpoint).
- Manual: complete each tier path (A/B/C/info), gate submit, confirm n8n receipt + Resend email (test address) + on-screen report + graceful failure + `prefers-reduced-motion`.
- Trilingual parity check (TH/EN/zh-CN copy, hreflang, no leaked locale strings — the BookingForm-style bug).
- Deploy: `npm run build && npx wrangler deploy` (operator-gated).

## 16. Out of scope / future / touch-up candidates

- Article/service destination pages (deliverable 2) — until then, fallback links.
- LINE-OA gate (phase 2, §13). Email related-links block (ships OFF, §6/D9).
- Optional age question (§4). Optional per-question tracking (§10).
- Result-share / PDF download of the report. A/B testing teaser copy.

## 17. Proposed Decision Records (to log on approval)

- **SS-DR-ASSESS-001** — `/implant-check/` is an educational self-check (not diagnosis); rules-engine tiers, no numeric score; cited sources (ITI/AAP/ADA).
- **SS-DR-ASSESS-002** — Results model: free on-screen teaser → soft gate → full on-screen report + emailed copy.
- **SS-DR-ASSESS-003** — Backend: lead → n8n; email → Resend; orchestrated by one thin Cloudflare Worker (`main` + `ASSETS` binding) keeping the rest of the site static.
- **SS-DR-ASSESS-004** — Related-content engine is data-driven with `published` gating + `onScreen`/`email` switches (email OFF at launch).
