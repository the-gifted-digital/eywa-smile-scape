# Handover — Interactive Dental Assessment page (workstream B)

> **Created:** 2026-06-08. **For:** a fresh chat that will design + build the interactive dental self-assessment lead-gen page. Read THIS file first — it's self-contained.
> **Repo:** `/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape` · **Branch:** `web-skeleton` · **Astro app:** `web/`.
> **Status of the rest:** Homepage MVP + 3 locales (TH `/`, EN `/en/`, zh-CN `/zh-cn/`) + motion polish are DONE & LIVE on `go.smilescapeclinic.com`. This was "workstream B", deferred so the current chat could keep polishing the homepage.

---

## 0) The idea (operator's words, paraphrased)

Build an **interactive dental assessment** — something genuinely useful and based on an internationally-recognized standard — that attracts visitors to complete it. **Before showing results, gate behind a form** (name/phone/email) so results are delivered **by email**. **Future evolution:** ask the user to **add the clinic LINE OA first**, then deliver results via LINE.

Make it a **dedicated full page** (its own URL), **linked from the homepage and from various points across the site**. (This was reviewed and agreed: a separate page = shareable, ad-landing-friendly, an SEO/AEO asset, a clean self-contained funnel, and a strong lead magnet.)

## 1) Decisions already made (don't re-litigate)

- ✅ **Separate full page** at its own URL (not embedded in the homepage). Home links INTO it.
- ✅ **Gated results:** take assessment → capture lead (form / LINE) → deliver results (email now; LINE later).
- ✅ Entry CTAs from the homepage + (later) service/concern pages.

## 2) Open decisions for the new chat to brainstorm

1. **Which assessment instrument** ("internationally standard, genuinely usable"). Candidates to evaluate — pick + adapt a recognized framework and **cite the source**; must be honest (educational self-check, NOT a diagnosis):
   - **Implant suitability / "Am I a candidate?"** check — best fit for this implant-first clinic + lead-gen intent.
   - **Oral-health risk:** caries risk (ADA/CAMBRA), periodontal self-assessment (AAP "Are you at risk?" tool), or a general oral-health questionnaire (WHO).
   - **OHIP-14** (validated oral-health quality-of-life instrument) — credible, but more academic.
   - Likely best: a short, branded **"Smile / Implant Readiness Check"** built on a recognized risk framework, ~6–12 questions, with a scored result + tiered recommendation + book-a-consult CTA.
2. **Scoring + results UX:** client-side scoring (static Astro site → JS), personalized result tiers + recommendations, then the book CTA. Results shown after the gate.
3. **Lead delivery mechanism:** (a) reuse the existing **n8n webhook** (`https://nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form`) which already handles the homepage form; or (b) **Resend** (the Resend MCP is connected this project — can send templated result emails directly); or (c) both. Decide + design the result-email template.
4. **LINE-first future path:** how to gate on "add LINE OA" (LINE URL `https://maac.io/6yp2p`) then deliver via LINE — likely a phase 2; design the page so it can switch the gate from email-form to LINE-add later.
5. **URL + i18n:** path (e.g. `/assessment/` or `/implant-check/`), trilingual (TH `/`, EN `/en/...`, zh-CN `/zh-cn/...`) like the rest of the site. Index vs noindex on go. (currently everything is `noindex,follow`).
6. **Compliance (important):** healthcare — must not "diagnose"; frame as educational self-check + "results are not a medical diagnosis; consult a dentist." Thai dental-advertising law + medical-claims guardrails apply (same caveats as the LP/homepage; consider the healthcare-marketing-compliance specialist before launch).

## 3) What to reuse (the homepage gave us all of this)

- **Component library** (`web/src/components/`): `ui/` (Image, Button, SectionHeading, Section), `cards/`, `sections/`, `forms/BookingForm` (n8n + PDPA + `lead_submit` pattern — the gate form can mirror this). `FaqBlock` (FAQPage schema).
- **Shell** `layouts/Base.astro` — full-site shell (nav, footer, GTM `GTM-NFBVZT43`, `robots` prop default `noindex,follow`, global `line_click`/`call_click`, optional `<StickyCta>`, hreflang th/en/zh-CN).
- **Motion layer** (live): `data-reveal` / `data-reveal-stagger` (scroll-reveal, spring), `.u-hover`, `data-parallax`, `prefers-reduced-motion` safe. Use these for the assessment UI too (e.g. reveal each question, animate the result).
- **i18n pattern:** section content via per-locale content collections; component micro-copy via `Astro.currentLocale` + internal `{th,en,'zh-cn'}` label maps. **Never hardcode locale copy in a component.**
- **Image seam:** `Image.astro` (DR-035; placeholder→Cloudflare URL with no markup change).
- **Tokens (DR-029):** `brand-*` Tailwind classes + `font-sans`/`font-display` only, no raw hex.
- **Tracking:** GTM events `lead_submit` (gate form), `line_click`/`call_click` (global). Add assessment-specific events (e.g. `assessment_start`, `assessment_complete`).
- **Email:** Resend MCP connected (templated result emails) OR n8n.

## 4) Recommended workflow (mirror the homepage)

`/brainstorm` (pick instrument + flow + email mechanism + URL) → spec (`docs/superpowers/specs/YYYY-MM-DD-dental-assessment-design.md`) → `writing-plans` → `subagent-driven-development` (fresh agent per task + spec & quality review). Verify with `npm run check` (ignore the ~19 pre-existing errors in `Landing.astro`/`lp/dental-implant.astro`) + `npm run build` + `npm run preview`. Deploy `npx wrangler deploy` (operator-gated).

## 5) Reference paths

- Homepage spec/plan: `docs/superpowers/specs/2026-06-07-homepage-mvp-design.md`, `docs/superpowers/plans/2026-06-07-homepage-mvp.md`.
- Motion spec/plan: `docs/superpowers/specs/2026-06-08-homepage-motion-polish-design.md`, `docs/superpowers/plans/2026-06-08-homepage-motion-polish.md`.
- Component-library memory: `~/.claude/projects/-Volumes-SSD-NN-CLAUDE-AI-repos-brands-eywa-smile-scape/memory/homepage-component-library.md`.
- Content-template-system handover (separate deliverable): `docs/HANDOVER-content-templates.md`.
- Brand: `docs/brand-concept.md`; doctors (CV source-of-truth): `web/src/data/doctors.json`; contacts: phone `+66922936226`, LINE `https://maac.io/6yp2p`.

## 6) Quick-start for the new chat

```
1. Read this file + memory/homepage-component-library.md.
2. /brainstorm: choose the assessment instrument (lead with "implant readiness / oral-health risk"),
   the gate flow (email now via Resend or n8n; LINE later), the URL + trilingual plan, compliance framing.
3. spec → plan → subagent-driven build, reusing the component library + motion layer.
4. Add entry CTAs on the homepage (hero secondary CTA / a dedicated band) once the page exists.
```

*The chat that created this handover stays focused on homepage polish. Assessment work continues from here in a separate chat.*
