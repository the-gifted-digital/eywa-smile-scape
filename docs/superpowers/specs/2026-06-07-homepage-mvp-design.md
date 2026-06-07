# SmileScape — Homepage MVP (go. root) — Design Spec

> **Date:** 2026-06-07 · **Author:** operator + Claude (brainstorming session) · **Status:** approved design, pre-implementation
> **Session C** of the 2026-06-07 handover (`docs/HANDOVER-2026-06-07.md` §SESSION C).
> **Branch:** `web-skeleton` · **App:** `web/` (Astro 4 + Tailwind, Cloudflare Workers Static Assets).
> **Companion deliverable (next spec):** Content-template system (T1–T22) — the section/card components built here become its building blocks.

---

## 1. Context — verified live state (not assumed)

- **Target page:** the `go.` subdomain ROOT — `web/src/pages/index.astro` → `https://go.smilescapeclinic.com/`. Currently a throwaway **skeleton placeholder** (Hero + Blue Diamond card + RelatedContent + FaqBlock).
- **Parallel-safe:** WordPress still serves the apex `smilescapeclinic.com`. The `go.` subdomain is the Astro site. Editing `index.astro` does **not** touch the live LP (`lp/dental-implant.astro`) or WP. No downtime risk.
- **Reusable assets already in repo:**
  - `web/src/layouts/Base.astro` — standard full-site shell: i18n `<html lang>` + hreflang (th default `/`, en `/en/`), SEO/OG, Dentist JSON-LD (NAP = PLACEHOLDER), header **nav** (links to not-yet-existing hubs), footer, `AnalyticsHead`/`AnalyticsBody` **gated as no-op** until `PUBLIC_GTM_ID` is set.
  - `web/src/layouts/Landing.astro` — LP shell (no nav) with **live GTM** `GTM-NFBVZT43` + dataLayer events (`lead_submit`, `line_click`, `call_click`). Pattern source for tracking.
  - `web/src/pages/lp/dental-implant.astro` — rich component source: hero w/ cover, before/after lightbox, doctor cross-fade, animated callouts, square video, n8n appointment form, sticky mobile CTA.
  - `web/src/components/` — `FaqBlock.astro` (emits FAQPage JSON-LD), `RelatedContent.astro`, `AnalyticsHead/Body.astro`.
  - `web/src/content/config.ts` — `pages` + `articles` collections (`type:'content'`) aligned to the sitemap 7-column model (for deliverable 2's ~726 pages — **not** for the homepage).
- **Live WP homepage structure** (scraped 2026-06-07, reference for IA): Hero → 3 feature cards → mission → before/after+rating → branches → Blue Diamond ("Your Final Dental Implant Selection") → services grid → 17 partner logos → 6-step process → portfolio → testimonials → **28-doctor wall** → FAQ → booking form → benefits → contact+map → footer.
- **Brand:** "The Lifetime Foundation"; hero service Blue Diamond 29,900฿; 2 branches (รัตนาธิเบศร์ MRT ม่วง / ศรีนครินทร์ MRT เหลือง); founders หมอแฮม (Lead Implantologist) + หมอแพรว (Co-Founder); SMILE DNA + 4 mission pillars; Global Mastery credentials.

## 2. Goal / non-goals

**Goal.** Replace the `go.` root skeleton with a real, shippable **bilingual homepage** built as a **full component library** (every section a component), composed in `index.astro` (TH) + `en/index.astro` (EN), tracking-wired, `noindex,follow`, all images as swap-ready placeholders. Ship via the existing build/deploy.

**Non-goals (this session).**
- No real image binaries (→ Session A / Cloudflare; placeholders only now).
- No service hubs or other site pages (`/services/`, `/implants/`, `/about/`, `/contact/` etc. → deliverable 2 / Phase F).
- No Supabase hydration of homepage data (→ Session B; the content collection is the seam).
- No apex cutover, no removing `noindex`.
- Do **not** touch `lp/dental-implant.astro`, `Landing.astro`, `privacy-policy.astro`.

## 3. Protocol alignment (verified against EYWA spec this session)

| DR | Constraint | How this spec complies |
|----|-----------|------------------------|
| **DR-EYWA-MKT-005** | Astro 4 + Tailwind + Node 22, `src/{components,content,layouts,pages,styles}`, deploy `npm run build && npx wrangler deploy`, PascalCase components / kebab-case routes | Followed exactly; mirrors polyvex (`eywa-polyvex/web/src/`) and SmileScape LP |
| **DR-004** | URL structure: subdirectory + Thai default → TH `/`, EN `/en/`, hreflang in `<head>` | TH at `/`, EN at `/en/`; hreflang already in `Base.astro` |
| **DR-029** | Components consume design tokens only — **no hardcoded colors**; Bridge palette LOCKED; Tailwind auto-maps tokens → `brand-*` classes | All components use `brand-*` Tailwind classes (e.g. `bg-brand-anchor`, `text-brand-primary-deep`); no raw hex |
| **DR-035** | Image binaries on Cloudflare; Supabase stores URL only. Brand chrome → `web/src/assets/` + `astro:assets`; content images → Cloudflare URL. Build an `Image.astro` wrapper so URL swap needs no code change | `Image.astro` wrapper (see §6); MVP renders placeholders, later swap to Cloudflare URL with no markup change |
| **Content_Templates (DR-020, T1–T22)** | Pages = composition of block components | Homepage ≈ **T11 (Institutional)** but a *custom composition*; its sections/cards seed the deliverable-2 block library |

**Content layer correction (made this session):** homepage content lives in **Astro content collections** (`src/content/`), **not** `src/data/*.ts`. Only runtime config (analytics id, feature flags) may live in `src/data/`/env.

## 4. Architecture — `Base.astro` becomes the full-site shell

Decision: **extend `Base.astro`** (not a new `Site.astro`) so the homepage and all future site pages share one shell — DRY and forward-compatible with deliverable 2.

Changes to `Base.astro`:
1. **Activate GTM** — set `PUBLIC_GTM_ID = GTM-NFBVZT43` (env, via `wrangler.jsonc` vars / `.env`) so the existing `AnalyticsHead`/`AnalyticsBody` stop being no-ops. (Keep the env-gate so local dev without the id stays clean.)
2. **`robots` meta** — new prop `robots?: string` defaulting to **`noindex,follow`** (go. policy). Emits `<meta name="robots" content={robots}>`. Apex cutover later flips the default.
3. **Trim nav to real destinations only:** Home `/` · รากฟันเทียม → `/lp/dental-implant/` (live LP) · จองคิว → `#booking` (on-page anchor). Drop `/services/ /about/ /contact/` until those pages exist. EN nav mirrors.
4. **Global tracking listeners** — delegated click listeners (in `AnalyticsBody` or a small inline script): `line_click` on `a[href*="maac.io"]`/`a[href*="line"]`, `call_click` on `a[href^="tel:"]`. (`lead_submit` is fired by `BookingForm` on success.)
5. **Sticky mobile CTA** — render `<StickyCta>` controlled by a prop `stickyCta?: boolean` (default off; homepage sets it true). LINE green + pulse + call.
6. **Footer** — white logo (placeholder), NAP (placeholder), 2 branches, copyright. Keep existing structure.

## 5. Component library (option B — full componentization)

```
web/src/components/
  ui/
    Button.astro            # variants: primary | outline | pill; renders <a>; tracks via href
    SectionHeading.astro    # eyebrow (font-display uppercase) + title + optional subtitle
    Section.astro           # consistent vertical-rhythm wrapper (max-w, padding)
    Image.astro             # DR-035 wrapper — placeholder now, Cloudflare/astro:assets later
  cards/
    Pillar.astro            # one of the 4 "Why" pillars (icon + title + line)
    ServiceCard.astro       # icon/image + title + 1-liner + href
    DoctorCard.astro        # photo + name + role/credential line
    ReviewCard.astro        # quote + name + stars
    BranchCard.astro        # name + MRT line + address + map link
  sections/
    Hero.astro              # §1
    TrustBar.astro          # §2
    WhyPillars.astro        # §3 (4× Pillar)
    BlueDiamond.astro       # §4  ⚠ compliance copy
    ServicesGrid.astro      # §5 (6× ServiceCard)
    PartnerLogos.astro      # §6 (placeholder logos)
    FoundersMastery.astro   # §7 (2 founders, cross-fade)
    TeamRoster.astro        # §8 (client-side shuffle → 4–6× DoctorCard)
    ProcessSteps.astro      # §9 (5 steps)
    BeforeAfter.astro       # §10 lightbox  ⚠ compliance, placeholder
    Reviews.astro           # §11 (ReviewCard + square video)
    Branches.astro          # §12 (2× BranchCard + map embed)
    FinalCta.astro          # §15
    StickyCta.astro         # rendered by Base when stickyCta
  forms/
    BookingForm.astro       # n8n webhook + PDPA consent + lead_submit
  (reuse) FaqBlock.astro · RelatedContent.astro · AnalyticsHead/Body.astro
```
Conventions: PascalCase filenames; props typed via TS `interface Props`; **zero hardcoded colors** (Bridge `brand-*` Tailwind classes only); each component self-contained and independently understandable.

## 6. `Image.astro` (DR-035 swap-ready wrapper)

Props: `src?: string` · `alt: string` (required) · `width: number` · `height: number` · `ratio?: string` · `label?: string` · `class?: string`.
Behaviour:
- **No `src` / `src` starts with `placeholder:`** → render a styled placeholder box at the correct `width`/`height` (prevents CLS), showing `label` (e.g. "หมอ", "B/A", "LOGO") + `alt` as title. **MVP uses this for every image.**
- **Local path** (`/src/assets/...` or `~/assets/...`) → `astro:assets` `<Image>` (Sharp optimize at build) — for brand chrome later.
- **Cloudflare URL** (`https://...`) → `<img>` with `?format=auto`, explicit `width`/`height`, `loading="lazy"`/`decoding="async"`.
Swapping a placeholder → real image = change the `src` value in the content collection only; **no markup change** (DR-035).

## 7. Content / data layer — `home` content collection

A new **`type:'data'`** collection `home` (cleaner than markdown frontmatter for heterogeneous section data), schema added to `web/src/content/config.ts`, one YAML entry per locale:

```
web/src/content/home/
  th.yaml
  en.yaml
```

Schema (zod) — top-level keys, each a typed object/array:
- `meta` { title, description }
- `hero` { eyebrow, title, body, primaryCta {label,href}, secondaryCta {label,href}, image {src,alt} }
- `trustBar` [ { label } … ]
- `pillars` [ { icon, title, body } × 4 ]
- `blueDiamond` { title, priceLabel, bullets[], image {src,alt}, cta }   # ⚠ guarantee text here
- `services` [ { title, summary, href, image {src,alt} } × 6 ]
- `partners` [ { name, logo {src,alt} } … ]   # placeholder logos
- `founders` [ { name, role, credentials[], image {src,alt} } × 2 ]
- `doctors` [ { name, role, image {src,alt} } … ]   # full roster; TeamRoster shuffles 4–6
- `process` [ { step, title, body, image {src,alt} } × 5 ]
- `beforeAfter` [ { before {src,alt}, after {src,alt}, caption } … ]   # ⚠ placeholder
- `reviews` [ { quote, name, stars } … ] + `video` { poster {src,alt}, src }
- `branches` [ { name, mrt, address, mapUrl } × 2 ]
- `faq` [ { q, a } … ]
- `finalCta` { title, cta }

`index.astro` (TH) and `en/index.astro` (EN) do `getEntry('home','th'|'en')`, then pass typed slices to each section component. This is the **Supabase hydration seam** (Session B can later generate these YAML files, or a build step can replace `getEntry` with a DB fetch) and the **EN translation slot**.

Runtime-only config (not content): `PUBLIC_GTM_ID`, feature flags such as `showBeforeAfter` → env / `src/data/site.ts`.

## 8. Section composition (top → bottom) — the 15 sections

| # | Section component | Data key | Source | Notes / flags |
|---|---|---|---|---|
| N | (Base header/nav) | — | new shell | trimmed nav; GTM; robots noindex |
| 1 | `Hero` | `hero` | ⬆ LP | "The Lifetime Foundation" + 2 CTAs |
| 2 | `TrustBar` | `trustBar` | ⬆ LP | 5.0★ · 2 สาขา MRT · รับประกัน · ผ่อน 0% · Digital 100% |
| 3 | `WhyPillars` | `pillars` | ▣ WP cards → EYWA 4 pillars | Implant Mastery / Family-Standard Integrity / Efficiency / Lifelong Confidence |
| 4 | `BlueDiamond` | `blueDiamond` | ⬆ LP | 29,900฿ · ผ่อน 0% · Korea value-premium · Tissue/Operator/Patient Friendly · MegaGen · **⚠ guarantee copy** |
| 5 | `ServicesGrid` | `services` | ▣ WP | 6 หมวด; implant card → `/lp/dental-implant/`, others → `#booking` anchor |
| 6 | `PartnerLogos` | `partners` | ▣ WP | placeholder logos (MegaGen/Neodent/Straumann/3Shape/Acteon…) |
| 7 | `FoundersMastery` | `founders` | ⬆ LP cross-fade | หมอแฮม (full credentials) + หมอแพรว |
| 8 | `TeamRoster` | `doctors` | ✚ new | client-side shuffle → show 4–6 of roster; reinforces team depth |
| 9 | `ProcessSteps` | `process` | ⬆ LP | ปรึกษาฟรี → X-ray → วางแผน → รักษา → ติดตาม |
| 10 | `BeforeAfter` | `beforeAfter` | ⬆ LP lightbox | **⚠ placeholder**; gate via `showBeforeAfter` flag |
| 11 | `Reviews` | `reviews`+`video` | ⬆ LP | text reviews + 5.0★ + square video (`preload=none`, poster) |
| 12 | `Branches` | `branches` | ▣ WP | 2 branches + Google Maps embed |
| 13 | `FaqBlock` (reuse) | `faq` | ⬆ existing | emits FAQPage JSON-LD |
| 14 | `BookingForm` | — | ⬆ LP | n8n webhook + PDPA + `lead_submit` |
| 15 | `FinalCta` | `finalCta` | ⬆ LP/Base | closing CTA band |
| + | `StickyCta` | — | ⬆ LP | mobile; LINE pulse + call; `line_click`/`call_click` |

**TeamRoster shuffle:** server renders the full roster markup; a small inline script on mount selects 4–6 at random and shows them (hides the rest). Acceptable for SEO because go. is `noindex`; revisit at apex cutover if needed.

## 9. Tracking

- GTM container `GTM-NFBVZT43` via `PUBLIC_GTM_ID`.
- dataLayer events (mirrors `Landing.astro`): `line_click`, `call_click` (global delegated listeners in shell), `lead_submit` (`BookingForm` on successful POST to n8n).
- n8n webhook: `https://nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form` (reuse LP's).
- Contacts: phone `tel:+66922936226`, LINE `https://maac.io/6yp2p`.

## 10. Compliance guardrails

- Blue Diamond guarantee language ("รับประกันตลอดชีพ" / "ตัว Top") + before/after imagery carry the same open compliance question as the LP (Thai dental-advertising law + Google healthcare policy). **Non-blocking** for build, but: keep `noindex` (prevents indexing during review), use **placeholder** before/after (no real patient photos yet), and recommend a **healthcare-marketing-compliance** review before ad spend / apex cutover. Clinic license (Q-Clinic #) not yet shown.
- `showBeforeAfter` feature flag lets us hide §10 instantly if compliance requires, without removing the component.

## 11. Files

**Modify**
- `web/src/layouts/Base.astro` — shell upgrade (GTM activate, robots prop, nav trim, global listeners, StickyCta slot).
- `web/src/pages/index.astro` — compose TH homepage from `home/th`.
- `web/src/pages/en/index.astro` — compose EN homepage from `home/en`.
- `web/src/content/config.ts` — add `home` data collection + schema.
- `web/src/components/AnalyticsBody.astro` (or new small script) — add delegated `line_click`/`call_click` listeners.
- `web/wrangler.jsonc` / env — set `PUBLIC_GTM_ID`.

**Create**
- Components in §5 (`ui/`, `cards/`, `sections/`, `forms/`).
- `web/src/content/home/th.yaml`, `web/src/content/home/en.yaml`.
- (optional) `web/src/data/site.ts` for runtime flags.

**Do NOT touch**
- `web/src/pages/lp/dental-implant.astro`, `web/src/layouts/Landing.astro`, `web/src/pages/privacy-policy.astro`.

## 12. Verification plan

1. `cd web && npm run build` — clean (no TS/Astro/zod errors).
2. `npm run preview` → check at `http://localhost:4321/` and `/en/` (NEVER `file://` on `dist/`).
3. Assert: `<meta name="robots" content="noindex,follow">` present on `/` and `/en/`; GTM script loads; hreflang th/en/x-default correct; FAQPage JSON-LD validates; Dentist JSON-LD present; sticky CTA appears after hero on mobile; TeamRoster shows 4–6 and reshuffles on reload; `BookingForm` POSTs to n8n (test submission) and pushes `lead_submit`; `line_click`/`call_click` fire (dataLayer/GTM preview).
4. Layout: all `Image.astro` placeholders reserve correct dimensions → **no CLS**; responsive at 360 / 768 / 1280.
5. Lighthouse (mobile) sanity pass.
6. `npx wrangler deploy` → smoke test `https://go.smilescapeclinic.com/` + `/en/`.

## 13. Out of scope / follow-ups

- Real images + Cloudflare Images/Stream/R2 wiring → **Session A** (swap placeholder `src` values in `home/*.yaml`).
- Service hubs + other site pages + the T1–T22 component templates → **deliverable 2 / Phase F** (reuses this component library).
- Supabase-driven homepage content → **Session B** (replace `getEntry` seam).
- Apex cutover: flip `robots` default to index, point apex → same worker.

## 14. Open questions / data gaps (placeholders until operator provides)

- **Doctor roster** for `TeamRoster`: real names/photos beyond the 2 founders (README confirms Periodontist + Endodontist + Pediatric on staff; names TBD). MVP uses placeholder doctor cards.
- **NAP**: branch full addresses, GPS, phone per branch, GBP Place IDs, hours (Base JSON-LD currently placeholder).
- **หมอแพรว** full credentials (README open item).
- **Partner brand** real logos + the confirmed partner list.
- **EN copy**: drafted as translation of TH; operator review recommended.
- **Q-Clinic license #** for trust/footer badge.

## 15. Cross-brand reuse & incremental memory capture (operator directive 2026-06-07)

SmileScape is the **first EYWA brand to build the full Astro component library** — treat it as the reference implementation, build pragmatically, and refine across brands rather than perfecting up front.

- **Brand-agnostic by construction.** Components carry no brand-specific logic or copy: visuals via `brand-*` Tailwind tokens (DR-029), content via the `home` collection. A component lifted to another brand should work by swapping tokens + content only — never hardcode "SmileScape", phone numbers, or fixed copy inside a component.
- **Promotion path.** Proven components/conventions get promoted upward: brand → EYWA `Content_Templates` (T1–T22 blocks) + the polyvex/reference Astro profile, so other brands inherit them.
- **Memory logging (ongoing habit).** As components/conventions stabilise, record them to memory — `MEMORY.md` for SmileScape-local notes; flag protocol-level conventions for the EYWA spec — so the next brand reuses rather than reinvents. Loop: **build → learn → record → refine.**
