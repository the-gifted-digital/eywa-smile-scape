# Handover — Header & Footer redesign

> **Created:** 2026-06-08. **For:** a fresh chat that will design + build the site header and footer. Read THIS file first — it's self-contained.
> **Repo:** `/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape` · **Branch:** `web-skeleton` · **Astro app:** `web/`.
> **Live now:** homepage (TH `/`, EN `/en/`, zh-CN `/zh-cn/`) + motion polish + LP (`/lp/dental-implant/`) + assessment (`/implant-check/`) + privacy (`/privacy-policy/`), all on `go.smilescapeclinic.com` (noindex).

---

## 0. Goal

Design and build a proper **header** and **footer**. They currently live inside the shared shell `web/src/layouts/Base.astro` as minimal placeholders. This is a focused redesign of those two regions.

## 1. ⚠️ Critical: header/footer = `Base.astro` = the SHARED shell

`web/src/layouts/Base.astro` wraps **every** standard page (homepage, assessment, privacy, and all future content-template pages). The LP uses a separate `Landing.astro` shell. **Editing Base's header/footer changes the whole site.**

- **Coordinate:** Base.astro is touched by multiple workstreams (this homepage-polish chat; the content-template system on branch `content-templates`). Pull latest, and consider whether header/footer markup should be extracted into dedicated `components/SiteHeader.astro` / `SiteFooter.astro` (imported by Base) to reduce churn on the big shell file — recommended as part of this work.

## 2. Current state (what exists today, in `Base.astro`)

**Header** (lines ~134–158): a text wordmark `Smile` + `Scape` (NO real logo image), a small inline `nav` (per-locale `navByLocale`: Dental-implant LP · Readiness-check `/implant-check/` · Booking CTA `#booking`), stacks on mobile (`flex-col sm:flex-row`). **There is NO language switcher in the UI** even though 3 locales are live — this is the biggest functional gap.

**Footer** (lines ~164–171): text only — `SmileScape Dental Clinic`, localized tagline + branch line (`footerByLocale` th/en/zh-cn), copyright. NO logo, NO NAP (phone/address/hours), NO social, NO legal/privacy links, NO branch maps.

**Already wired in Base (reuse, don't rebuild):** GTM + `robots` (noindex default) + hreflang for th/en/zh-CN + Dentist JSON-LD (NAP placeholder) + global `line_click`/`call_click` listeners + `StickyCta` (mobile) + the motion layer.

**Gold for the language switcher:** Base already computes `const alt = { th, en, 'zh-cn' }` = the THREE per-locale URLs of the *current* page (via the `withLocale` helper). A language switcher just renders links to `alt.th` / `alt.en` / `alt['zh-cn']` — the hard part is done.

## 3. What to design (scope)

**Header**
- Real **logo** (assets below) replacing the text wordmark; sized for desktop + mobile.
- **Language switcher** TH / EN / 中文 (zh-CN) — uses `alt.*`. Decide style (inline pills vs dropdown).
- Nav links — decide final IA (coordinate with the content-template page system; today only the implant LP, the assessment, and the booking anchor exist — most hubs are still being built on `content-templates`).
- Booking CTA (LINE/phone/`#booking`).
- **Mobile menu** (hamburger / drawer) — current inline-wrap nav won't scale once there are more links.
- Optional: sticky-on-scroll / condense-on-scroll behavior (reuse the motion/scroll patterns; respect `prefers-reduced-motion`).

**Footer**
- Real **logo** (white/stacked variant on a dark or paper footer).
- **Full NAP per branch** (รัตนาธิเบศร์ / ศรีนครินทร์): address, phone, hours, Google Maps link/Place ID — *operator data pending (see §6)*.
- **Social** links (handles pending), **LINE** (`https://maac.io/6yp2p`), phone (`+66922936226`).
- **Legal / nav links**: `/privacy-policy/` (exists), key service links, the assessment.
- Language switcher (mirror header).
- Optional: Q-Clinic verification badge (license # pending — compliance), trust signals.
- Trilingual (all copy via `Astro.currentLocale` + per-locale maps, like the current `footerByLocale`).

## 4. Reuse / conventions

- **Tokens only** (DR-029): `brand-*` Tailwind classes + `font-sans`/`font-display`. No raw hex.
- **Logo via `Image.astro`** / `astro:assets` (DR-035 — brand chrome belongs in `web/src/assets/`, Sharp-optimized; current LP logos are in `web/public/images/lp/`).
- **i18n**: `Astro.currentLocale` (`'th'|'en'|'zh-cn'`) + per-locale label maps; never hardcode locale copy. hreflang already emitted.
- **Motion layer** available (`data-reveal`, `prefers-reduced-motion` safe) if you want subtle header/footer reveals.
- Mirror the established quality bar: brainstorm → spec → plan → subagent-driven build, `npm run check`/`build`/`preview` (ignore the ~19 pre-existing errors in `Landing.astro`/`dental-implant.astro`/`AssessmentApp.astro`), deploy `npx wrangler deploy` (operator-gated), keep `noindex`.

## 5. Logo assets

- Source artwork: `design/Smile Scape_Logo/` — `AW Final_Logo_Smile Scape_25.10.22-Primary_Transparency.png` (+ HR), `..._Transparency-WH.png` (white, for dark footer), `.ai`/`.pdf` masters, `Book Brand_Smile Scape_25.10.22.pdf` (brand book).
- Currently used on the LP: `web/public/images/lp/logo-smilescape.png` (header, 600×106) and `logo-stacked.png` (footer, shown white via `brightness-0 invert`).
- Recommend exporting a clean header logo + a white footer logo into `web/src/assets/` and serving via `astro:assets`/`Image.astro`.

## 6. Data gaps (operator — pending; needed for a real footer)

- Per-branch **NAP**: full addresses, phone numbers, **GPS / Google Business Place IDs**, opening hours (currently all placeholder; the Base Dentist JSON-LD `department` has placeholder NAP too — fill it while you're here).
- **Social** handles (FB/IG/TikTok/YouTube?), LINE OA id.
- **Q-Clinic license #** for the verification badge (compliance).
- Final logo variant choice. Brand colors are locked (Bridge): anchor `#14386B`, primary `#217DEA`, etc. (see `design/brand-foundation/tokens.json`).

## 7. Reference paths

- Shell: `web/src/layouts/Base.astro` (header lines ~134–158, footer ~164–171, `alt`/`navByLocale`/`footerByLocale`/`withLocale`). LP shell: `web/src/layouts/Landing.astro` (its slim header/footer is a styling reference).
- Brand: `docs/brand-concept.md`; tokens `design/brand-foundation/tokens.json`.
- Component-library memory: `~/.claude/projects/-Volumes-SSD-NN-CLAUDE-AI-repos-brands-eywa-smile-scape/memory/homepage-component-library.md`.
- Branches data: `content-plan/branches.md`. Contacts: phone `+66922936226`, LINE `https://maac.io/6yp2p`.
- Other handovers: `docs/HANDOVER-content-templates.md`, `docs/HANDOVER-dental-assessment.md`.

## 8. Quick-start for the new chat

```
1. Read this file + Base.astro (header/footer + the alt/navByLocale/footerByLocale block) + Landing.astro for reference.
2. /brainstorm: header (logo + lang switcher via alt.* + nav IA + mobile menu + sticky behavior) and footer
   (logo + NAP per branch + social + legal links + lang switcher). Pull operator NAP if available, else placeholder.
3. Recommend extracting SiteHeader.astro / SiteFooter.astro out of Base.astro to keep the shared shell lean.
4. spec → plan → subagent-driven build. Deploy is operator-gated; keep noindex.
```

*The chat that created this handover stays focused on homepage touch-ups; header/footer work continues from here in a separate chat.*
