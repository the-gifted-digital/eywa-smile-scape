# SmileScape — Homepage Polish + Motion — Design Spec

> **Date:** 2026-06-08 · **Author:** operator + Claude (brainstorming session) · **Status:** approved design, pre-implementation
> **Follows:** Homepage MVP (`docs/superpowers/specs/2026-06-07-homepage-mvp-design.md`) — now LIVE 3 langs on `go.smilescapeclinic.com`.
> **Branch:** `web-skeleton` · **App:** `web/` (Astro 4 + Tailwind, Cloudflare Workers Static Assets).
> **This is workstream A.** Workstream B (interactive dental assessment page) is a separate spec, brainstormed after A.

---

## 1. Goal

Add a tasteful, modern motion layer to the live homepage and bring three media-driven sections to life with real interactions — so the page feels current and engaging while staying performant and trustworthy (healthcare brand). Motion style **B "Modern & Lively"** (spring easing) was chosen from a live demo.

## 2. Motion system (foundation)

- **No animation library.** CSS animations + **one shared scroll-reveal utility**: a `data-reveal` attribute convention + a small `IntersectionObserver` script in `Base.astro` (same pattern as the existing sticky-CTA / tracking scripts). Element reveals once, then is unobserved.
- **Style B tokens** (reusable CSS in `web/src/styles/global.css`):
  - reveal: from `opacity:0; translateY(26px) scale(.94)` → to `none`, `cubic-bezier(.34,1.56,.64,1)` (spring overshoot), ~0.7s.
  - stagger: children of a `[data-reveal-group]` animate with incremental `animation-delay` (≈0.1s steps) via `nth-child`.
  - hover: cards lift `translateY(-4px) scale(1.03)` + deepen shadow; buttons lift+scale. ~0.25s.
- **`prefers-reduced-motion: reduce`** → all reveals/parallax/ambient disabled; final state shown immediately (no opacity:0 trap). This is a hard requirement.
- **CLS = 0:** reveals animate only `transform`/`opacity`/`filter` — never layout properties.

## 3. Motion scope (works on placeholders today)

1. **Scroll-reveal** on every section: heading + card/list groups, staggered, style B. Applied via `data-reveal` / `data-reveal-group` on section wrappers and their item containers.
2. **Hero signature** (`sections/Hero.astro`, dark `bg-brand-anchor`):
   - **Ambient gradient/sheen** — a slow, looping CSS gradient/sheen overlay on the hero background (subtle, low-contrast, brand blues).
   - **Load stagger** — eyebrow → title → body → CTAs reveal in sequence on first paint.
   - **Subtle parallax** — hero image translates slightly slower than scroll. **Desktop only** (`min-width: 768px`), via a `requestAnimationFrame` scroll handler, **disabled under reduced-motion**. Small magnitude (≤24px).
3. **Hover micro-interactions (B)** on `ServiceCard`, `DoctorCard`, `Pillar`, `ReviewCard`, `BranchCard`, and `Button`.
4. **Small touches:** TrustBar numeric values **count-up** when scrolled into view (e.g. 5.0, 2, 0%); **smooth scroll** to `#booking` for in-page CTA anchors. (Trimmable — included by default.)

## 4. Heavy interactions — build + reuse real LP images (3 sections only)

The LP's real media already lives in `web/public/images/lp/`. These three homepage sections switch from placeholder to real LP media so the operator can evaluate the real thing; all other sections (incl. `TeamRoster`) stay placeholder. Session A later swaps every image to a Cloudflare URL via `Image.astro` (no markup change).

1. **`BeforeAfter.astro` → lightbox** — real before/after `review1.jpg…review7.png`; click opens a full-screen lightbox. Lift the lightbox markup + script from `web/src/pages/lp/dental-implant.astro`.
2. **`FoundersMastery.astro` → doctor cross-fade** — real `doctor1.png` (หมอแฮม) ↔ `doctor-praew.png` (หมอแพรว) soft cross-fade. Lift from the LP.
3. **`Reviews.astro` → real square video** — `<video preload="none" poster="/images/lp/video-poster.jpg">` with `/videos/review-clip.mp4` (square 1280×1280). Lift from the LP.

Image refs for these 3 sections are set in `content/home/{th,en,zh-cn}.yaml` to `/images/lp/...` paths (the founders' two photos; the before/after set; the video poster). `Image.astro`'s non-placeholder branch already renders a real `<img>` for such paths.

## 5. Files

**Modify**
- `web/src/styles/global.css` — motion CSS (keyframes B, `[data-reveal]`/`[data-reveal-group]` base + visible states, `prefers-reduced-motion` reset, hover utility classes).
- `web/src/layouts/Base.astro` — shared `IntersectionObserver` reveal script + desktop parallax script + count-up script (all small, guarded by reduced-motion / viewport).
- `web/src/components/sections/*.astro` — add `data-reveal`/`data-reveal-group` + stagger hooks; `Hero` gets the ambient gradient layer + parallax target + load-stagger; cards get hover classes.
- `web/src/components/cards/*.astro` + `ui/Button.astro` — hover lift/scale classes (style B).
- `web/src/components/sections/BeforeAfter.astro` — lightbox (lift from LP).
- `web/src/components/sections/FoundersMastery.astro` — cross-fade (lift from LP).
- `web/src/components/sections/Reviews.astro` — real `<video>` (lift from LP).
- `web/src/content/home/{th,en,zh-cn}.yaml` — set real `/images/lp/...` `src` for founders (2), before/after (set), and the review video poster.

**Do NOT touch:** `lp/dental-implant.astro` (lift FROM it, read-only), `Landing.astro`, `privacy-policy.astro`.

## 6. Performance / accessibility

- CSS-first, zero JS libraries. Reveal IO unobserves after firing. Parallax: desktop-only + `requestAnimationFrame` + reduced-motion guard + tiny magnitude. Count-up: runs once on reveal, cheap.
- `prefers-reduced-motion: reduce` disables reveal/parallax/ambient/count-up (values shown statically).
- Video `preload="none"` + poster (no autoplay). Lightbox keyboard-closable (Esc) + focus-safe; trigger has accessible label.
- Target: Lighthouse mobile stays green; CLS 0; no main-thread jank from parallax.

## 7. Verification

- `cd web && npm run check` (ignore the ~19 pre-existing errors in `Landing.astro`/`dental-implant.astro`; 0 new) + `npm run build` (success) + `npm run preview` → visually confirm at `http://localhost:4321/`, `/en/`, `/zh-cn/`: sections reveal on scroll (spring), hero ambient + parallax (desktop), card/button hovers, before/after lightbox opens, founders cross-fade, review video plays, count-up fires. Toggle OS "reduce motion" → confirm everything is static and usable. Mobile width: no parallax, no jank.
- Deploy (operator-gated): `npx wrangler deploy`.

## 8. Out of scope

- Real images for sections other than the 3 above (Session A / Cloudflare).
- The interactive dental assessment page (workstream B — next spec).
- New copy / new sections.
