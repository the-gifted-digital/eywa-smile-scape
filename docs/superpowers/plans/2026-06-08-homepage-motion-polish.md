# Homepage Polish + Motion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a tasteful "Modern & Lively" (spring) motion layer to the live homepage and bring 3 media sections to life with real LP interactions (before/after lightbox, founder cross-fade, review video).

**Architecture:** CSS-only motion + one shared `IntersectionObserver` reveal script in `Base.astro` (no library). A `data-reveal` / `data-reveal-stagger` convention drives scroll reveals; `data-parallax` drives a desktop-only rAF parallax; `.u-hover` is the hover utility. All gated by `prefers-reduced-motion`. The 3 heavy interactions are lifted from `web/src/pages/lp/dental-implant.astro` and use the real images already in `web/public/images/lp/`.

**Tech Stack:** Astro 4.16, Tailwind 3.4 (`brand-*` tokens), CSS animations + IntersectionObserver. No JS library.

**Spec:** `docs/superpowers/specs/2026-06-08-homepage-motion-polish-design.md`

---

## Testing approach (read first)

No unit-test runner. Verify each task with:
- `cd web && npm run check` — ignore the ~19 PRE-EXISTING errors in `Landing.astro` + `lp/dental-implant.astro`; require **0 NEW** errors.
- `cd web && npm run build` — must succeed (emits `/`, `/en/`, `/zh-cn/`).
- `cd web && npm run preview` → `http://localhost:4321/` — visually confirm motion/interactions. Toggle OS "Reduce Motion" and reload → confirm everything is static + usable.

**Conventions:** `~/` = `web/src/`. Tokens only (`brand-*`, `font-sans`/`font-display`) — exception: the LP-lifted lightbox/cross-fade CSS keeps its literal rgba/hex (exact brand-CTA lift, scoped to the component). Reduced-motion is a hard requirement on every animation. Never animate layout properties (keep CLS 0). Do NOT touch `lp/dental-implant.astro` (read-only lift source), `Landing.astro`, `privacy-policy.astro`.

---

## File Structure

**Modify**
- `web/src/styles/global.css` — motion CSS (reveal/hover/hero-sheen/smooth-scroll, reduced-motion via `no-preference` wrapper).
- `web/src/layouts/Base.astro` — shared reveal IO + desktop parallax `<script>`.
- `web/src/components/sections/Hero.astro` — ambient sheen layer + parallax on image + load stagger.
- `web/src/components/sections/{TrustBar,WhyPillars,BlueDiamond,ServicesGrid,PartnerLogos,ProcessSteps,Branches,FinalCta}.astro` — add `data-reveal`/`data-reveal-stagger`.
- `web/src/components/cards/{Pillar,ServiceCard,DoctorCard,ReviewCard,BranchCard}.astro` — add `.u-hover`.
- `web/src/components/ui/Button.astro` — spring hover.
- `web/src/components/sections/BeforeAfter.astro` — composite gallery + lightbox (lift).
- `web/src/components/sections/FoundersMastery.astro` — cross-fade portrait + both credentials (lift).
- `web/src/components/sections/Reviews.astro` — real `<video>` (lift).
- `web/src/content/config.ts` — `beforeAfter` schema → `{ image, caption }`.
- `web/src/content/home/{th,en,zh-cn}.yaml` — real `/images/lp/...` for founders (2), beforeAfter (8), video poster; rewrite beforeAfter entries to the new shape.

---

## Task 1: Motion foundation (global.css + Base script)

**Files:** Modify `web/src/styles/global.css`, `web/src/layouts/Base.astro`

- [ ] **Step 1: Append motion CSS to `web/src/styles/global.css`**

```css

/* ===== Motion layer (style B — spring). Reduced-motion safe. ===== */
/* Reveal + smooth-scroll only when motion is allowed; reduced-motion → elements
   stay at their natural (visible) state, never trapped at opacity:0. */
@media (prefers-reduced-motion: no-preference) {
  html { scroll-behavior: smooth; }
  [data-reveal] {
    opacity: 0;
    transform: translateY(26px) scale(0.96);
    transition: opacity 0.7s cubic-bezier(0.34, 1.56, 0.64, 1) var(--reveal-delay, 0s),
                transform 0.7s cubic-bezier(0.34, 1.56, 0.64, 1) var(--reveal-delay, 0s);
    will-change: opacity, transform;
  }
  [data-reveal].is-in { opacity: 1; transform: none; }
}

/* Hover lift (cards / interactive). Spring easing, motion-safe. */
.u-hover { transition: transform 0.25s cubic-bezier(0.34, 1.56, 0.64, 1), box-shadow 0.25s ease, border-color 0.2s ease; }
@media (prefers-reduced-motion: no-preference) {
  .u-hover:hover { transform: translateY(-4px) scale(1.02); box-shadow: 0 14px 30px rgba(20, 56, 107, 0.14); }
}

/* Hero ambient sheen (slow drifting brand-blue radials over the dark hero). */
.hero-sheen {
  position: absolute; inset: 0; pointer-events: none; z-index: 0;
  background: radial-gradient(55% 75% at 18% 0%, rgba(33, 125, 234, 0.38), transparent 60%),
              radial-gradient(45% 65% at 92% 18%, rgba(123, 164, 221, 0.26), transparent 60%);
}
@media (prefers-reduced-motion: no-preference) {
  .hero-sheen { animation: heroSheen 14s ease-in-out infinite alternate; will-change: transform, opacity; }
}
@keyframes heroSheen {
  from { transform: translate3d(0, 0, 0) scale(1); opacity: 0.8; }
  to   { transform: translate3d(0, -3%, 0) scale(1.08); opacity: 1; }
}
```

- [ ] **Step 2: Add the shared motion script to `Base.astro`**, immediately AFTER the existing global tracking `<script>` (the one with `line_click`/`call_click`), before `</body>`:

```astro
<script>
  // Motion layer — reveal on scroll (spring), staggered groups, desktop parallax.
  // Fully disabled under prefers-reduced-motion.
  const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  if (!reduceMotion) {
    // staggered groups: each child gets an incremental reveal delay
    document.querySelectorAll('[data-reveal-stagger]').forEach((group) => {
      group.querySelectorAll(':scope > [data-reveal]').forEach((el, i) => {
        (el as HTMLElement).style.setProperty('--reveal-delay', (i * 0.09) + 's');
      });
    });
    // reveal on scroll
    const io = new IntersectionObserver((entries) => {
      entries.forEach((e) => {
        if (e.isIntersecting) { e.target.classList.add('is-in'); io.unobserve(e.target); }
      });
    }, { threshold: 0.18, rootMargin: '0px 0px -8% 0px' });
    document.querySelectorAll('[data-reveal]').forEach((el) => io.observe(el));

    // desktop-only parallax (bounded, rAF-throttled)
    if (window.matchMedia('(min-width: 768px)').matches) {
      const items = Array.from(document.querySelectorAll('[data-parallax]')) as HTMLElement[];
      if (items.length) {
        let ticking = false;
        const update = () => {
          const y = window.scrollY;
          items.forEach((el) => {
            const f = parseFloat(el.dataset.parallax || '0.08');
            const offset = Math.min(y * f, 48);
            el.style.transform = 'translate3d(0,' + offset.toFixed(1) + 'px,0)';
          });
          ticking = false;
        };
        window.addEventListener('scroll', () => {
          if (!ticking) { ticking = true; requestAnimationFrame(update); }
        }, { passive: true });
        update();
      }
    }
  }
</script>
```

- [ ] **Step 3: Verify** — `cd web && npm run check` (0 new) + `npm run build` (success).

- [ ] **Step 4: Commit**

```bash
cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
git add web/src/styles/global.css web/src/layouts/Base.astro
git commit -m "feat(motion): reveal/parallax foundation (CSS + IO, reduced-motion safe)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 2: Apply reveal / hover / hero motion across components

**Files:** Modify `Hero.astro`, the 8 other section components, the 5 cards, `Button.astro`. Read each file, then add the attributes/classes below. Add NO new logic — only attributes + the hero sheen element.

- [ ] **Step 1: `sections/Hero.astro`** — add the ambient sheen + parallax + load-stagger:
  - On the hero `<section data-hero ...>`: add `class="... relative overflow-hidden"` if not already relative/overflow-hidden, and add a sheen layer as the FIRST child of the section: `<div class="hero-sheen" aria-hidden="true"></div>`. Wrap the existing inner content container so it sits above the sheen: ensure the content `<div class="max-w-6xl ...">` has `class="relative z-10 ..."`.
  - Add `data-reveal-stagger` to the text column `<div>` (the one holding eyebrow/title/body/buttons), and `data-reveal` to its children (the eyebrow `<p>`, the `<h1>`, the body `<p>`, and the buttons `<div>`).
  - On the hero `<Image .../>` (right column), add `data-parallax="0.06"` (Astro passes unknown attributes through to the component root; if `Image.astro` does not forward arbitrary attrs, wrap the `<Image>` in `<div data-parallax="0.06">`). Prefer the wrapper `<div data-parallax="0.06">…</div>` to be safe.

- [ ] **Step 2: Section reveals.** In each of these, add `data-reveal` to the `<SectionHeading .../>` (wrap it: `<div data-reveal><SectionHeading .../></div>`) and `data-reveal-stagger` to the immediate grid/list container, with `data-reveal` on each repeated child:
  - `WhyPillars.astro` — grid of `<Pillar>`: container `data-reveal-stagger`, each `<Pillar>` wrapped or given `data-reveal`. (Add `data-reveal` to the `<Pillar>` usage via a wrapping `<div data-reveal>` OR add the attribute to the grid children — wrap each: `{pillars.map((p) => <div data-reveal><Pillar .../></div>)}`.)
  - `ServicesGrid.astro` — same pattern around `<ServiceCard>`.
  - `ProcessSteps.astro` — `<ol data-reveal-stagger>`, each `<li data-reveal>` (the `<li>` already exists — add `data-reveal` to it).
  - `Branches.astro` — grid `data-reveal-stagger`, each `<BranchCard>` wrapped in `<div data-reveal>`.
  - `PartnerLogos.astro` — logo grid `data-reveal-stagger`, each `<Image>` wrapped in `<div data-reveal>`.
  - `TrustBar.astro` — the `<ul>` gets `data-reveal` (single reveal of the bar).
  - `BlueDiamond.astro` — wrap the two-column grid in `data-reveal` (image + text reveal together); no stagger needed.
  - `FinalCta.astro` — wrap inner content `<div>` in `data-reveal`.

- [ ] **Step 3: Card hover.** Add the `u-hover` class to the root element of each card so they lift on hover:
  - `cards/ServiceCard.astro` — add `u-hover` to the root `<a>` class list.
  - `cards/DoctorCard.astro` — add `u-hover` to root `<div>`.
  - `cards/Pillar.astro` — add `u-hover` to root `<div>`.
  - `cards/ReviewCard.astro` — add `u-hover` to root `<figure>`.
  - `cards/BranchCard.astro` — add `u-hover` to root `<div>`.

- [ ] **Step 4: `ui/Button.astro` spring hover.** The primary/outline variants already have color hover. Add a lift: append `hover:-translate-y-0.5 active:translate-y-0 transition-transform` to the `base` class string (keep existing classes). (Tailwind `transition-colors` is already there; change to include transform — use `transition` or add `transition-transform`.)

- [ ] **Step 5: Verify** — `npm run check` (0 new) + `npm run build`. Then `npm run preview` and confirm sections reveal on scroll with a spring stagger, hero has a drifting sheen + slight image parallax on desktop, cards/buttons lift on hover. Toggle Reduce Motion → all static.

- [ ] **Step 6: Commit**

```bash
git add web/src/components/sections/ web/src/components/cards/ web/src/components/ui/Button.astro
git commit -m "feat(motion): apply scroll-reveal, hover lift, hero sheen+parallax across homepage

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 3: BeforeAfter → composite gallery + lightbox (lift LP)

**Files:** Modify `web/src/content/config.ts`, `web/src/components/sections/BeforeAfter.astro`

- [ ] **Step 1: Change the `beforeAfter` schema** in `content/config.ts`. Replace:

```ts
    beforeAfter: z.array(z.object({ before: imageRef, after: imageRef, caption: z.string() })),
```

with:

```ts
    beforeAfter: z.array(z.object({ image: imageRef, caption: z.string() })),
```

- [ ] **Step 2: Rewrite `web/src/components/sections/BeforeAfter.astro`** — composite-image gallery + a singleton lightbox (markup/CSS/JS lifted from `lp/dental-implant.astro:188-205, 878-882, 959-979, 1009-1031`):

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  heading: string;
  enabled?: boolean; // compliance gate (spec §10 of the MVP)
  note?: string;
  items: { image: { src?: string; alt: string; label?: string }; caption: string }[];
}
const { heading, enabled = true, note, items } = Astro.props;
---
{enabled && (
  <Section>
    <div data-reveal><SectionHeading title={heading} align="center" /></div>
    <div class="mt-8 grid grid-cols-2 md:grid-cols-4 gap-3" data-reveal-stagger>
      {items.map((it, i) => (
        <figure data-reveal class={`relative rounded-xl overflow-hidden border border-brand-neutral-200 bg-brand-neutral-0 u-hover ${i === 0 ? 'col-span-2 md:col-span-1' : ''}`}>
          <Image src={it.image.src} alt={it.image.alt} label={it.image.label} width={500} height={500} rounded={false} class="ba-img cursor-zoom-in aspect-square" />
          <figcaption class="pointer-events-none absolute top-2 left-2 rounded-full bg-brand-anchor/85 text-brand-neutral-0 text-[11px] font-medium px-2.5 py-0.5">{it.caption}</figcaption>
        </figure>
      ))}
    </div>
    {note && <p class="mt-4 text-center text-xs text-brand-neutral-400">{note}</p>}

    <div id="ba-lightbox" class="ba-lightbox" aria-hidden="true" role="dialog" aria-modal="true" aria-label="ภาพผลลัพธ์ขนาดเต็ม">
      <button type="button" class="ba-close" aria-label="close">✕</button>
      <img class="ba-lightbox-img" src="" alt="" />
    </div>
  </Section>
)}
<style>
  .ba-lightbox { position: fixed; inset: 0; z-index: 100; display: none; align-items: center; justify-content: center; background: rgba(11,26,46,0.93); padding: 20px; }
  .ba-lightbox.open { display: flex; }
  .ba-lightbox-img { max-width: 100%; max-height: 88vh; width: auto; height: auto; border-radius: 12px; box-shadow: 0 16px 50px rgba(0,0,0,0.55); animation: ba-zoom 0.22s ease; }
  @keyframes ba-zoom { from { transform: scale(0.94); opacity: 0; } to { transform: scale(1); opacity: 1; } }
  .ba-close { position: absolute; top: 14px; right: 14px; width: 44px; height: 44px; border-radius: 9999px; background: rgba(255,255,255,0.16); color: #fff; font-size: 20px; border: none; cursor: pointer; line-height: 1; }
  .ba-close:hover { background: rgba(255,255,255,0.28); }
</style>
<script>
  const lb = document.getElementById('ba-lightbox');
  if (lb) {
    const lbImg = lb.querySelector('.ba-lightbox-img') as HTMLImageElement;
    const open = (src: string, alt: string) => {
      lbImg.src = src; lbImg.alt = alt || '';
      lb.classList.add('open'); lb.setAttribute('aria-hidden', 'false');
      document.body.style.overflow = 'hidden';
    };
    const close = () => {
      lb.classList.remove('open'); lb.setAttribute('aria-hidden', 'true');
      document.body.style.overflow = ''; lbImg.src = '';
    };
    document.querySelectorAll('.ba-img').forEach((img) => {
      img.addEventListener('click', () => open((img as HTMLImageElement).currentSrc || (img as HTMLImageElement).src, (img as HTMLImageElement).alt));
    });
    lb.addEventListener('click', (e) => {
      const t = e.target as HTMLElement;
      if (t === lb || t.classList.contains('ba-close')) close();
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape' && lb.classList.contains('open')) close();
    });
  }
</script>
```

> The `ba-img` class lands on the real `<img>` via `Image.astro`'s `class` pass-through. When `src` is still a placeholder (e.g. on a brand with no images yet), `Image.astro` renders a non-clickable placeholder `<div>` and the lightbox simply has nothing to open — safe.

- [ ] **Step 3: Verify** — `npm run check` (0 new) — NOTE: this will fail the YAML schema until Task 6 updates the `beforeAfter` data shape. So: run `npm run check` and expect ONLY `home/*.yaml` `beforeAfter` content errors (which Task 6 fixes). Confirm no errors in `BeforeAfter.astro`/`config.ts` themselves. (Build will pass after Task 6.) Do NOT commit yet if the collection won't parse — instead proceed to Task 6, then commit Tasks 3+6 together. (Tasks 4 and 5 are independent and can commit before Task 6.)

---

## Task 4: FoundersMastery → cross-fade portrait + both credentials (lift LP)

**Files:** Modify `web/src/components/sections/FoundersMastery.astro`

- [ ] **Step 1: Rewrite `FoundersMastery.astro`** — left = a square portrait that cross-fades `founders[0].image` ↔ `founders[1].image` (8s loop, lifted keyframes from `lp/dental-implant.astro:980-996`); right = BOTH founders' name/role/credentials, always visible. Requires exactly 2 founders.

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  heading: string;
  founders: { name: string; role: string; credentials: string[]; image: { src?: string; alt: string; label?: string } }[];
}
const { heading, founders } = Astro.props;
const [a, b] = founders;
---
<Section tone="anchor">
  <div data-reveal><SectionHeading title={heading} align="center" onDark /></div>
  <div class="mt-8 grid gap-8 md:grid-cols-[280px_1fr] items-center" data-reveal>
    <div class="relative w-full aspect-square overflow-hidden rounded-2xl bg-brand-anchor/40 md:max-w-[280px] mx-auto">
      <div class="doc-x doc-x-a absolute inset-0"><Image src={a?.image.src} alt={a?.image.alt} label={a?.image.label} width={560} height={560} rounded={false} class="w-full h-full object-cover" /></div>
      {b && <div class="doc-x doc-x-b absolute inset-0"><Image src={b.image.src} alt={b.image.alt} label={b.image.label} width={560} height={560} rounded={false} class="w-full h-full object-cover" /></div>}
    </div>
    <div class="grid gap-6 sm:grid-cols-2 md:grid-cols-1 lg:grid-cols-2">
      {founders.map((f) => (
        <div class="rounded-lg bg-brand-neutral-0/5 p-4">
          <h3 class="font-display font-bold text-brand-neutral-0">{f.name}</h3>
          <p class="text-sm text-brand-highlight">{f.role}</p>
          <ul class="mt-2 space-y-1 text-sm text-brand-neutral-200">
            {f.credentials.map((c) => <li>• {c}</li>)}
          </ul>
        </div>
      ))}
    </div>
  </div>
</Section>
<style>
  @keyframes doc-cross-a { 0%,42% { opacity: 1; } 50%,92% { opacity: 0; } 100% { opacity: 1; } }
  @keyframes doc-cross-b { 0%,42% { opacity: 0; } 50%,92% { opacity: 1; } 100% { opacity: 0; } }
  .doc-x-a { animation: doc-cross-a 8s ease-in-out infinite; }
  .doc-x-b { animation: doc-cross-b 8s ease-in-out infinite; }
  @media (prefers-reduced-motion: reduce) {
    .doc-x-a { animation: none; opacity: 1; }
    .doc-x-b { animation: none; opacity: 0; }
  }
</style>
```

- [ ] **Step 2: Verify** — `npm run check` (0 new) + `npm run build`. (Founders images become real in Task 6; until then the cross-fade alternates two placeholders, which still demonstrates the effect.)

- [ ] **Step 3: Commit**

```bash
git add web/src/components/sections/FoundersMastery.astro
git commit -m "feat(motion): FoundersMastery cross-fade portrait + both credentials (lift LP)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 5: Reviews → real square video (lift LP)

**Files:** Modify `web/src/components/sections/Reviews.astro`

- [ ] **Step 1: Replace the video-poster block** in `Reviews.astro`. Currently the right column shows a poster `<Image>`. Replace that right-column `<div>` with a real `<video>` (lifted from `lp/dental-implant.astro:412-422`), driven by the `video` prop:

```astro
    <div class="max-w-[300px] mx-auto w-full" data-reveal>
      {video.src ? (
        <video controls preload="none" playsinline poster={video.poster.src} width="1280" height="1280"
               class="rounded-2xl border border-brand-neutral-200 bg-black w-full aspect-square">
          <source src={video.src} type="video/mp4" />
        </video>
      ) : (
        <Image src={video.poster.src} alt={video.poster.alt} label={video.poster.label} width={300} height={300} />
      )}
      <p class="mt-2 text-center text-sm text-brand-neutral-500">{video.label}</p>
    </div>
```

(The `video` prop already has `{ poster, src?, label }`. When `src` is set → real player; otherwise the poster placeholder. Keep the rest of the `Reviews.astro` layout/reviews grid unchanged; just add `data-reveal` to the reviews grid container too.)

- [ ] **Step 2: Add reveal to the reviews grid** — add `data-reveal-stagger` to the `<div ... grid ... sm:grid-cols-2>` that maps `ReviewCard`, and `data-reveal` to each `<ReviewCard>` (wrap: `{reviews.map((r) => <div data-reveal><ReviewCard .../></div>)}`).

- [ ] **Step 3: Verify** — `npm run check` (0 new) + `npm run build`.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/Reviews.astro
git commit -m "feat(motion): Reviews real square video (preload=none) + reveal (lift LP)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 6: Wire real LP images into the 3 sections (all 3 locales) + verify

**Files:** Modify `web/src/content/home/th.yaml`, `en.yaml`, `zh-cn.yaml`

- [ ] **Step 1: In EACH of the 3 YAML files**, set real `src` for the founders and the video, and REPLACE the `beforeAfter` block with the new `{ image, caption }` shape using the 8 real LP composite images.

Founders — set `image.src` on both founders (keep existing `alt`/`label`):
```yaml
# founders[0] (หมอแฮม / Dr. Ham / Ham 医生)
    image: { src: /images/lp/doctor1.png, alt: <existing alt>, label: <existing label> }
# founders[1] (หมอแพรว / Dr. Praew / Praew 医生)
    image: { src: /images/lp/doctor-praew.png, alt: <existing alt>, label: <existing label> }
```

Video — set `poster.src` + add `src`:
```yaml
video:
  label: <existing label per locale>
  poster: { src: /images/lp/video-poster.jpg, alt: <existing alt>, label: <existing label> }
  src: /videos/review-clip.mp4
```

`beforeAfter` — replace the whole block with 8 entries (captions per locale). **TH (`th.yaml`):**
```yaml
beforeAfter:
  - { image: { src: /images/lp/review1.jpg, alt: เคสรากฟันเทียม ก่อน-หลัง 1 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review2.jpg, alt: เคสรากฟันเทียม ก่อน-หลัง 2 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review3.jpg, alt: เคสรากฟันเทียม ก่อน-หลัง 3 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review4.jpg, alt: เคสรากฟันเทียม ก่อน-หลัง 4 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review5.png, alt: เคสรากฟันเทียม ก่อน-หลัง 5 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review6.png, alt: เคสรากฟันเทียม ก่อน-หลัง 6 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review7.png, alt: เคสรากฟันเทียม ก่อน-หลัง 7 }, caption: ก่อน · หลัง }
  - { image: { src: /images/lp/review8.png, alt: เคสรากฟันเทียม ก่อน-หลัง 8 }, caption: ก่อน · หลัง }
```
**EN (`en.yaml`)** — same `image.src`/order; `alt: Dental implant before-after N`, `caption: Before · After`.
**zh-CN (`zh-cn.yaml`)** — same `image.src`/order; `alt: 种植牙术前术后 N`, `caption: 术前 · 术后`.

> First confirm the exact filenames exist: `ls web/public/images/lp/review*` and `ls web/public/images/lp/doctor*.png web/public/images/lp/video-poster.jpg`. If an extension differs (e.g. `review8` is `.jpg` not `.png`), match the real file. Also confirm `web/public/videos/review-clip.mp4` exists.

- [ ] **Step 2: Verify** — `cd web && npm run check` (0 new — the `beforeAfter` schema from Task 3 now matches the data) + `npm run build` (success; `/`, `/en/`, `/zh-cn/` emitted) + grep the built TH page:
  - `grep -c '/images/lp/review1.jpg' dist/index.html` ≥ 1
  - `grep -c '/images/lp/doctor1.png' dist/index.html` ≥ 1
  - `grep -c 'review-clip.mp4' dist/index.html` ≥ 1
  - `grep -c 'ba-lightbox' dist/index.html` == 1
  Then `npm run preview` → click a before/after image (lightbox opens, Esc/✕ closes), founders portrait cross-fades, review video shows a poster + plays on click. Toggle Reduce Motion → cross-fade stops on founder A, reveals static, no parallax.

- [ ] **Step 3: Commit (includes Task 3's BeforeAfter + config.ts)**

```bash
git add web/src/content/config.ts web/src/components/sections/BeforeAfter.astro web/src/content/home/
git commit -m "feat(motion): BeforeAfter composite gallery + lightbox; wire real LP images (3 locales)

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 7: Full verification + deploy (operator-gated)

- [ ] **Step 1:** `cd web && npm run check` (0 new) + `npm run build` (success, 3 homepage locales + LP + privacy).
- [ ] **Step 2:** `npm run preview` → for `/`, `/en/`, `/zh-cn/`: scroll-reveal spring + stagger on every section; hero sheen drift + desktop image parallax; card/button hover lift; before/after lightbox; founders cross-fade; review video. Then enable OS Reduce Motion + reload → everything static, no opacity:0 trap, lightbox/video still usable. Mobile width (≤767px) → no parallax, no jank.
- [ ] **Step 3:** Lighthouse (mobile) sanity — performance not regressed, CLS ~0.
- [ ] **Step 4 (operator-gated):** `npx wrangler deploy` → smoke-test `https://go.smilescapeclinic.com/`, `/en/`, `/zh-cn/`.

---

## Follow-ups (out of scope)

- Real images for all other sections → Session A (swap `src` in `home/*.yaml`; `Image.astro` handles it).
- Move `review-clip.mp4` (6.7MB) → Cloudflare Stream (Session A); the `<video>` `src` then points at the Stream URL.
- The interactive dental assessment page → workstream B (separate spec).
- **Count-up trimmed** (spec §3.4 listed it as trimmable): the TrustBar items are free-text labels (e.g. "รีวิว 5.0★ Google"), not isolated numbers, so a count-up would need brittle string parsing. Revisit only if the TrustBar is ever restructured into discrete numeric stat tiles. Smooth-scroll IS implemented (Task 1 `html{scroll-behavior:smooth}`).
