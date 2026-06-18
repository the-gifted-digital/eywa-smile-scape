# Decor Layer — seasonal/festival overlay (design spec)

> Status: approved direction (2026-06-19), pending final spec review before implementation plan.
> Branch target: `web-skeleton`. Scope: `web/` (Astro static site).

## 1. Overview

A site-wide, **temporary, date-scheduled decorative overlay** ("Decor layer", code key `decor`)
that adds a light festive gimmick — gently falling snowflakes plus an occasional motif
gliding across the bottom of the screen — without disturbing reading or blocking any UI.

The operator sets a date window once (e.g. December), and the overlay turns itself on and
off on those dates with **no redeploy required**. The first shipped festival is **Christmas
(snow)**; the system is built generically so more festivals (Songkran, Loy Krathong, Chinese
New Year, …) are added later by appending one config block.

### Goals
- Set-and-forget scheduling on a fully static site (no SSR, no infra changes).
- Subtle, premium, "ไม่รบกวนการอ่าน" — never covers text legibility or interactive chrome.
- Zero new runtime dependencies; tiny payload; no external requests.
- Fully disabled under `prefers-reduced-motion` (matches existing motion layer in `Base.astro`).
- Reusable across EYWA brands (one config-driven component).

### Non-goals (YAGNI)
- No snow accumulation / physics / canvas / WebGL.
- No per-festival theming engine beyond a `theme` switch + motif list (only `snow` ships now).
- No CMS/admin UI — the schedule is a typed config file edited by a developer/operator.
- No A/B testing, analytics events, or user toggle in the UI.

## 2. Locked decisions

| Decision | Value |
|---|---|
| Name / code key | `decor` (component `DecorLayer`, lib `decor.ts`) |
| Page scope | **All pages by default** (Base.astro + Landing.astro); **per-page opt-out** via prop |
| Effect | Falling **snowflakes** (rotating) + **one crossing motif at a time** |
| Motifs (Christmas) | `snowman`, `christmas-tree`, `deer` — **random alternation**, one per crossing |
| Crossing motion | Slow glide (~50% slower than a brisk pass), travels **fully across and off the far side**, gentle vertical bob, then a gap before the next |
| Snow density default | **medium** (desktop ~34 particles; mobile auto ~half, ~16) |
| Schedule (first preset) | **Christmas: Dec 1 – Dec 31**, `repeatYearly: true`, timezone **Asia/Bangkok** |
| Scheduling mechanism | **Client-side** date gate (browser reads "today in Bangkok") |
| Art / assets | **Tabler Icons (MIT)** SVG paths **inlined** (snowflake + motifs). No webfont, no Disney IP. |
| Accessibility | `aria-hidden`, `pointer-events:none`, fully off under `prefers-reduced-motion` |
| Stacking | `z-index: 30` — above page content, **below** all interactive chrome (header `z-[60]`, sticky CTA `z-50`, drawer/scrim `z-[55/56]`, mega backdrop `z-40`) |

## 3. Why client-side scheduling

The site is built statically (`astro build` → Cloudflare static assets; no SSR). The only way to
"turn on between Dec 1–31 without redeploying on those exact dates" is to evaluate the date in the
browser. Rejected alternatives:
- **Worker/edge inject** (`worker/index.ts`): authoritative server date, but HTML rewriting couples a
  cosmetic feature to infra, is hard to preview in dev, and is overkill for a gimmick.
- **Build-time gate**: requires a redeploy both when the window opens *and* closes → defeats the goal.

Trade-off accepted: a visitor whose device clock is badly wrong may see the overlay off-window. Fine
for a decorative gimmick. Timezone is **pinned to Asia/Bangkok** (via `Intl.DateTimeFormat`), so all
visitors flip at the same wall-clock regardless of their device timezone.

## 4. Architecture

```
web/src/lib/decor.ts            ← types + festival presets + resolveActiveDecor() [pure]
web/src/lib/decor.test.ts       ← vitest unit tests (pattern: site-nav.test.ts)
web/src/components/DecorLayer.astro  ← empty container + global CSS + runtime build/gate script
```

Wiring: render `<DecorLayer enabled={decor} />` just before `</body>` in **both**
`web/src/layouts/Base.astro` and `web/src/layouts/Landing.astro`. Both layouts gain a
`decor?: boolean` prop (default `true`) that passes through to the component.

### Data flow
1. **Build time:** `DecorLayer.astro` outputs only an empty `#decor-root` (omitted entirely when
   `enabled={false}`). The bundled script imports the presets + resolver from `lib/decor.ts`.
2. **Runtime (browser):** the script computes "today in Bangkok", checks `prefers-reduced-motion`
   and any URL override, calls the resolve logic, and — if a preset is active and motion is
   allowed — **builds** the snowflake symbol + particle pool + motif slot inside `#decor-root` and
   starts the motif scheduler; otherwise it removes `#decor-root`. CSS does
   all visual work; if nothing is active the script removes `#decor-root` from the DOM.

## 5. Config model — `lib/decor.ts`

```ts
export type Locale = 'th' | 'en' | 'zh-cn';
export type DecorTheme = 'snow';
export type DecorMotif = 'snowman' | 'christmas-tree' | 'deer'; // extend per festival
export type SnowDensity = 'light' | 'medium' | 'heavy';

export interface DecorPreset {
  key: string;            // stable id, also the ?decor= override value, e.g. 'christmas'
  start: string;          // 'MM-DD' or 'YYYY-MM-DD' (inclusive)
  end: string;            // 'MM-DD' or 'YYYY-MM-DD' (inclusive)
  repeatYearly?: boolean; // true → compare MM-DD only; supports year-wrap (e.g. 12-24 → 01-02)
  theme: DecorTheme;
  motifs: DecorMotif[];   // randomly alternated, one crossing at a time
  density?: SnowDensity;  // default 'medium'
  locales?: Locale[];     // optional targeting; omit = all locales
  enabled?: boolean;      // per-preset kill switch, default true
}

export const DECOR_PRESETS: DecorPreset[] = [
  {
    key: 'christmas',
    start: '12-01',
    end: '12-31',
    repeatYearly: true,
    theme: 'snow',
    motifs: ['snowman', 'christmas-tree', 'deer'],
    density: 'medium',
  },
];
```

### `resolveActiveDecor` contract (pure, unit-tested)
```ts
resolveActiveDecor(
  presets: DecorPreset[],
  todayBangkok: string,   // 'YYYY-MM-DD'
  locale: Locale,
  override?: string | null // from ?decor= : a preset key forces on; 'off' forces null
): DecorPreset | null
```
Rules:
- `override === 'off'` → `null`. `override === <key>` → that preset (ignores dates), else continue.
- Skip presets with `enabled === false` or whose `locales` excludes `locale`.
- Date match: inclusive on both ends. `repeatYearly` compares `MM-DD`; handles wrap-around windows
  where `start > end` (window spans New Year). First match wins.
- One-off (non-`repeatYearly`) presets MUST use full `YYYY-MM-DD`. A bare `MM-DD` there can never match
  (a real `YYYY-..` is always lexicographically greater), so it **fails closed and `console.warn`s in
  dev** rather than silently never showing — guards an easy copy-paste mistake.

Helper: `todayInBangkok(): string` using
`new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Bangkok' }).format(new Date())` → `YYYY-MM-DD`.

## 6. Effect engine (`DecorLayer.astro`)

### Container
Build output is just `{enabled && <div id="decor-root" aria-hidden="true"></div>}` — an empty,
opt-out-able container. The runtime script (below) builds everything inside it **only when active**, so
off-season / reduced-motion / opted-out pages ship ~0 decor markup. `#decor-root` is
`position:fixed; inset:0; pointer-events:none; z-index:30;`.

> Styles are `<style is:global>` namespaced under `#decor-root` (unique id, no leak), **not** Astro
> scoped — so JS-injected nodes are styled identically. (An earlier draft rendered the snow pool at
> build time "so scoped styles apply"; that rationale was wrong for a global stylesheet, and building at
> runtime avoids shipping ~1.7 KB gzip of inert snow markup on every page for the ~11 months it's off.)

### Snow
- The script injects a one-off `<symbol id="decor-flake-sym">` (inlined **Tabler `snowflake`**, MIT) plus
  N `<span class="decor-flake"><svg><use/></svg></span>` particles, each with inline props: `left`,
  `width/height` (11–22px), `opacity` (0.5–0.95), `--sway` (±30px), `--spin` (±120–520deg),
  `animation-duration` (7–13s), `animation-delay` (−0…−12s). Params are `Math.random` at runtime (natural
  per-visit variety; determinism no longer needed since nothing is shipped in HTML).
- Single keyframe `decor-fall`: `translate(0,-24px) rotate(0)` → `translate(var(--sway), 110vh)
  rotate(var(--spin))`, linear infinite. The running animation self-promotes to a compositor layer, so
  **no static `will-change`** on flakes (that would pin ~34 layers all month for no benefit).
- Counts: desktop medium 34 (light 18, heavy 56); mobile (`max-width: 767px`) = `ceil(base/2)` (≈17 at
  medium). The active density's exact count is generated — no over-rendering of hidden tiers.
- Particles are small + translucent and sit **above** content (sections have opaque backgrounds, so a
  behind-content layer wouldn't show). Mixed white + navy tints so some flakes read on both light and
  dark sections. Legibility preserved by small size + opacity, not by z-order.

### Crossing motif (JS-scheduled, one at a time)
- A single motif element at the bottom strip (`bottom: ~16px`), inlined Tabler SVG
  (`snowman` / `christmas-tree` / `deer`, MIT), navy `currentColor` at ~0.82 opacity, ~46px.
- **Exactly one motif per crossing.** The character is chosen at the *start* of a crossing and never
  changes mid-pass; a new random motif (≠ previous) is chosen only for the *next* crossing. (Implement
  via a single non-looping cross animation + `animationend`, gated on `e.animationName === '<cross>'` —
  do **not** use `animationiteration` or an infinite loop, which can swap the icon mid-pass.)
- Scheduler (runs only when active + motion allowed):
  `runOnce()` → pick a random motif (≠ previous), play one cross animation, on `animationend`
  wait a random gap, then `runOnce()` again.
  - Cross: `translateX(-160px)` → `translateX(calc(100vw + 160px))`, **fully off the far side**,
    duration ~20s (the "~50% slower, glides all the way through" requirement). `will-change:transform`
    only while `.run` (scoped to the active crossing, dropped during the idle gap).
  - Gap between crossings: random ~15–35s (the "นาน ๆ ผ่านที" feel). The scheduler stops if the slot is
    detached (`isConnected` guard) so no timer leaks after teardown.
  - Gentle vertical bob on an inner wrapper (`translateY` ±7px, ~2.6s ease-in-out) for life.
  - On mobile (`max-width:767px`) the motif sits at `bottom: calc(84px + env(safe-area-inset-bottom))` so
    it clears the opaque sticky CTA bar (z-50) + iOS home indicator instead of gliding behind it.

### Accessibility & performance
- If `prefers-reduced-motion: reduce` → script removes the overlay entirely (no snow, no motif). Matches
  the existing `Base.astro` motion-layer precedent. Because this layer animates continuously (unlike
  Base's one-shot reveals), it **also** registers a `matchMedia('… reduce').addEventListener('change')`
  so a *mid-session* toggle tears the overlay down (stopping animations + the motif timer), not just the
  CSS belt that hides it.
- `aria-hidden="true"` on the root; `pointer-events:none` guarantees it never intercepts taps/clicks.
- All animation is compositor-only (`transform`/`opacity`). No `requestAnimationFrame` loop, no canvas,
  no layout thrash. No network requests (SVGs inlined). Built after load into a `position:fixed` layer →
  no LCP/CLS impact; off-season/opted-out pages do no work and ship no markup.

## 7. Per-page opt-out & preview override

- **Opt-out:** any page rendered through a layout can pass `decor={false}` to suppress the overlay
  (e.g. a focused conversion or assessment page). Default is on everywhere.
- **Preview/QA override (URL query):**
  - `?decor=christmas` (or any preset key) → force that preset on regardless of date.
  - `?decor=off` → force off.
  Lets the operator preview before the window and lets us verify in dev/screenshots.

## 8. Assets & licensing

Snowflake and all motif glyphs are **Tabler Icons**, MIT-licensed — free for commercial use. MIT's one
obligation is that the copyright + permission notice be retained, so it is kept in
`web/THIRD-PARTY-NOTICES.md` plus a short pointer comment in `DecorLayer.astro` (copy the notice along
when reusing the component in other brands). We **inline the SVG path data** into `DecorLayer.astro`
(no `@tabler` dependency, no icon webfont). This both keeps payload minimal and sidesteps any
third-party-character IP concern.
**Explicitly excluded:** Disney "Frozen" characters (Elsa, Olaf, Sven, the sleigh design) — using them
on a commercial site is a copyright/trademark risk. We reproduce the *winter aesthetic*, not the IP.

## 9. i18n

Locale-agnostic by default (snow + generic motifs look the same in th/en/zh-cn). The optional
`locales` field exists so a future festival can target one locale (e.g. a Chinese-New-Year preset for
`zh-cn` only). No copy/translation needed for the Christmas preset.

## 10. Testing

- **Unit (`decor.test.ts`, vitest — 20 tests):** `resolveActiveDecor` —
  inclusive boundaries (start/end days on/just-outside), `repeatYearly` MM-DD matching, year-wrap
  window, one-off `YYYY-MM-DD` (and the fail-closed guard for a mis-written one-off `MM-DD`), `locales`
  targeting, `enabled:false`, override (`<key>` and `off`), no-match → `null`. Plus `todayInBangkok()`
  format/timezone sanity.
- **Manual (dev + preview tools):** open `?decor=christmas`, confirm snow + motif, motif crosses fully
  and alternates one-per-pass, buttons/links remain clickable through the layer (`pointer-events:none`),
  `?decor=off` and off-window both remove `#decor-root`, density count (34 desktop / 17 mobile), and the
  motif clears the mobile sticky CTA. Reduced-motion verified via the shipped CSS rule.

## 11. Deployment & lifecycle

- **No infra change.** Ships through the existing flow: `cd web && npm run build && npx wrangler deploy`.
  Works under the current `noindex` posture (overlay is `aria-hidden`, no SEO/schema impact).
- **Turn a festival on/off:** edit/append a block in `DECOR_PRESETS`, redeploy. `enabled:false` is a
  fast kill switch.
- **Add a festival later:** append a preset (+ any new motif SVGs/`theme`); no architectural change.

## 12. Open questions (non-blocking)
- Desktop particle counts (medium 34 / light 18 / heavy 56) and crossing/gap timings are tuned values;
  adjust further in `DecorLayer.astro` if desired.
- Whether to also drop the overlay on the assessment/implant-check tool pages — left ON by default;
  operator can add `decor={false}` per page if desired.
