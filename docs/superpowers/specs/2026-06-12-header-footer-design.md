# SmileScape — Site Header & Footer — Design Spec

> **Status:** Design APPROVED (mockups signed off) — ready for implementation planning.
> **Date:** 2026-06-12
> **Scope:** The shared site **header** and **footer** that live in `web/src/layouts/Base.astro` (every standard page; the LP uses the separate `Landing.astro`).
> **Design method:** Brainstormed via interactive browser mockups (Densmi dental theme as the visual reference, re-skinned to the SmileScape brand). Final mockups: desktop header `desktop-megamenu-v9`, mobile header `mobile-v7`, desktop footer `footer-v4`, mobile footer `mfooter-v4` (under `.superpowers/brainstorm/…`, ephemeral).

---

## 0. Summary

Four responsive regions, one design language:

1. **Desktop header** — two-tier bar (navy utility row + white main row) with **two full-width mega panels** (รากฟันเทียม + บริการ).
2. **Mobile header** — compact bar (logo + language + hamburger) opening a right-side **drawer** with accordion nav.
3. **Desktop footer** — **light** 5-column layout.
4. **Mobile footer** — **light** stacked layout.

Implement as two new responsive components — `SiteHeader.astro` and `SiteFooter.astro` — imported by `Base.astro` (do NOT keep markup inline in the shell, and do NOT split desktop/mobile into separate files; one component each, CSS handles breakpoints).

---

## 1. Shared foundations (reuse, do not reinvent)

- **Tokens only (DR-029):** `brand-*` Tailwind classes — anchor `#14386B`, primary `#217DEA`, primary-deep `#1B66C2`, primary-soft `#D8E6F3`, highlight `#7BA4DD`, ice `#EAF3FB`, paper `#F5FAFE`, accent `#EE9C9C`, neutral ramp. No raw hex in components.
- **Fonts:** `font-display` = Cabinet Grotesk (Latin headings; Thai falls back to Google Sans), `font-sans` = Google Sans (Thai + Latin body/UI). Self-hosted (`src/styles/fonts.css`).
- **Logo (DR-035):** serve via `Image.astro` / `astro:assets`. Export clean variants into `web/src/assets/`:
  - Header = **horizontal colour** lockup (current `public/images/lp/logo-smilescape.png`, 600×106).
  - Footer = **stacked colour** lockup (current `public/images/lp/logo-stacked.png`, 400×248) — shown in its natural colours on the light footer (NOT inverted white; the footer is now light).
- **i18n:** `Astro.currentLocale` (`'th' | 'en' | 'zh-cn'`) + per-locale label maps. The language switcher links to the already-computed `alt.{th,en,'zh-cn'}` URLs in `Base.astro`. All copy below is the **TH** source; **EN + zh-CN translations are required** (operator/content).
- **Contacts:** phone display `098 462 4949` → `tel:+66984624949` *(PLACEHOLDER — real numbers are per-branch, pending operator)*; LINE OA `https://maac.io/6yp2p`; clinic-licence verification (generic, no number) → `https://hosp.hss.moph.go.th/`.
- **Analytics:** the global `line_click` / `call_click` `dataLayer` listeners already in `Base.astro` cover LINE + tel links; booking = form-submit event.
- **Motion:** all transitions must be gated by `prefers-reduced-motion`.

---

## 2. Desktop header — two-tier

Why two tiers: a single row could not fit logo + 7–8 nav tabs + utilities + CTA without squeezing the booking button. The utility row carries the secondary items.

### Tier 1 — Utility bar (navy `anchor`, ~40px)
- **Left:** brand slogan **"A stable foundation for a lifetime of confident smiles"** — English, **Cabinet Grotesk**, no leading icon. (Replaces a phone number: phone is per-branch, so a single global number is wrong here.)
- **Right:** minimal social icons (Facebook · Instagram · TikTok · LINE — bare glyphs, no circular chips, white at ~70% → 100% on hover) · vertical divider · **language switcher** `🌐 TH ▾` (dropdown → ไทย / English / 中文, links to `alt.*`).

### Tier 2 — Main bar (white, sticky, ~72px)
- **Left:** logo (colour, h≈31px).
- **Centre:** nav (8 items): **หน้าแรก · รากฟันเทียม ▾ · บริการ ▾ · เกี่ยวกับเรา · สาขา · บทความ · เช็กความพร้อม · ติดต่อ**. Only **รากฟันเทียม** and **บริการ** open mega panels (chevron). `รากฟันเทียม` is the flagship — styled slightly emphasised (coral dot + primary-deep colour).
- **Right:** primary CTA **"จองคิว →"** (filled primary pill → `#booking`).

### Scroll behaviour
On scroll (>8px) the **utility row collapses to 0** and the main row stays stuck with a soft shadow ("condense on scroll"). Reduced-motion: collapse without transition.

### Mega panel — รากฟันเทียม
Full-width white rounded panel (radius ~22px) dropping below the bar; the page behind is **dimmed + lightly blurred** (backdrop). Structure: **header row** (headline + CTA) → divider → **body**.

- **Header:** headline "รากฟันเทียม — รากฐานฟันที่มั่นคงตลอดชีวิต" · sub "ดูแลโดยทันตแพทย์เฉพาะทางศัลยศาสตร์ช่องปากฯ · CBCT 3D · Guided Surgery" · CTA "ดูหน้ารากฟันเทียม →".
- **Col 1 — ประเภทการรักษา:** รากเทียมซี่เดียว · รากเทียมหลายซี่ / สะพานฟัน · All-on-X (ฟันทั้งปาก) · รากเทียม + ปลูกกระดูก.
- **Col 2 — ตามเคส & ความพร้อม:** เช็กความพร้อมรากเทียม `[พร้อมใช้]` · ปลูกกระดูก / ยกไซนัส `[เร็วๆ นี้]` · รากเทียมทันที (Immediate) `[เร็วๆ นี้]` · เคสยาก / All-on-4 `[เร็วๆ นี้]`.
- **Col 3 — promo card** (navy gradient): **💎 Blue Diamond Implant** · เริ่มต้น **29,900.-** · นำเข้าเกาหลี · รับประกันตลอดชีพ · ผ่อน 0% 10 เดือน · รวมครอบฟัน · CTA "ปรึกษาฟรี →".

### Mega panel — บริการ
Same shell. Header "บริการทันตกรรมครบวงจร" + CTA "ดูบริการทั้งหมด →". Body = 4 link columns + a featured visual card on the right.
- **ความงาม:** วีเนียร์ · ฟอกสีฟัน · Digital Smile Design.
- **จัดฟัน:** จัดฟันใส · Damon System.
- **ทั่วไป & รักษา:** รักษารากฟัน · ถอนฟัน / ฟันคุด · อุดฟัน · ฟันปลอม.
- **เหงือก:** รักษาปริทันต์ · รักษาเหงือกร่น.
- **Right:** branded **placeholder image card** ("ภาพคลินิก & ทีมแพทย์", DR-035 swap seam) — becomes a real image later.

> Most service links are not built yet → render as **`เร็วๆ นี้`** (muted, non-clickable). Only `รากฟันเทียม` LP and `เช็กความพร้อม` are live today. Flipping a link "live" must be a single data change (see §6), never a header rewrite.

### Trigger & accessibility
- Open on **hover** (with small close delay) **and** click; close on backdrop click / `Esc`.
- Must be **keyboard operable**: focusable triggers, `aria-expanded`, open on Enter/Space, `Esc` closes, focus stays usable. (The mockup is mouse-first; production must add the a11y layer.)

---

## 3. Mobile header

### Bar (~58px, white)
- **Left:** logo (colour, h≈28px).
- **Right:** **language button** `🌐 TH ▾` (dropdown ไทย / English / 中文) **+ hamburger ☰**. (No LINE quick-button on the bar — kept minimal.)

### Drawer
Slides in from the **right** (88% width) over a **heavy-blur dark scrim** (`backdrop-filter: blur(16px)` + `rgba(13,34,64,.55)`). Reduced-motion: no slide transition.
- **Head:** logo + close ✕.
- **Nav list** (same 8 items as desktop). **รากฟันเทียม** and **บริการ** are **accordions**:
  - **รากฟันเทียม** (open by default): sub-links (ซี่เดียว · หลายซี่/สะพานฟัน · All-on-X · +ปลูกกระดูก · เช็กความพร้อม `[พร้อมใช้]`) → **compact Blue Diamond card** (💎 · เริ่มต้น 29,900.- · "ปรึกษาฟรี →") → "ดูหน้ารากฟันเทียมทั้งหมด →".
  - **บริการ** (collapsed): grouped sub-links (ความงาม / จัดฟัน · ทั่วไป · เหงือก), mostly `[เร็วๆ นี้]`.
- **Footer (pinned to bottom of drawer):**
  - **Single full-width CTA** — **"นัดปรึกษาทันตแพทย์เฉพาะทาง →"** (gradient primary). **Hover effect:** lift `-2px` + deepened shadow + arrow nudges right + a light **shine sweep** (`::before`). (Reduced single-button decision — replaces the earlier จองคิว + LINE pair.)
  - Phone `098 462 4949` (tel) + social row **FB · IG · TikTok · LINE** (LINE re-homed here after dropping the LINE button).
- Drawer must **trap focus** and close on `Esc` (production a11y).

---

## 4. Footer (LIGHT) — desktop + mobile

Footer background is **light** (`ice` surface; bottom bar `primary-soft`), with a top border for separation from the page. Logo shows in natural colour. Headings = `anchor` (navy); links = `ink`, hover `primary-deep`; `เร็วๆ นี้` = `neutral-300`; map link = `primary`; MRT pill = `primary-deep` on `primary-soft`; Q-Clinic badge = green on light green.

### Brand block
- Stacked colour logo · tagline **"A stable foundation for a lifetime of confident smiles"** (Cabinet Grotesk) · minimal social row (FB · IG · TikTok · LINE).

### Link groups
- **บริการ:** รากฟันเทียม · เช็กความพร้อมรากเทียม · ความงาม `[เร็วๆ นี้]` · จัดฟัน `[เร็วๆ นี้]` · ทันตกรรมทั่วไป `[เร็วๆ นี้]`.
- **ลิงก์ด่วน:** เกี่ยวกับเรา · ทีมแพทย์ · สาขา · บทความ `[เร็วๆ นี้]` · จองคิว · นโยบายความเป็นส่วนตัว. *(Unify desktop/mobile to this list in implementation.)*

### Branches (×2: รัตนาธิเบศร์, ศรีนครินทร์)
Per branch: name · **MRT pill** (สีม่วง · แยกนนทบุรี 1 / สีเหลือง · สวนหลวง ร.9) · **province only** (นนทบุรี / กรุงเทพมหานคร — no street address; the map link covers location) · phone `098 462 4949` · hours · **"เปิดในแผนที่ →"**.
- **Hours formatting differs by device:** desktop = **two lines** ("เปิดทุกวัน" / "เวลา 10.00–20.00"); mobile = **one line** ("เปิดทุกวัน เวลา 10.00–20.00").

### Bottom bar
`© 2026 SmileScape Dental Clinic` · `นโยบายความเป็นส่วนตัว` · `ข้อมูลใช้เพื่อการนัดหมายตามนโยบาย PDPA` · **Q-Clinic verify badge** "✓ คลินิกได้รับอนุญาตถูกต้อง · ตรวจสอบได้ ↗" → external `https://hosp.hss.moph.go.th/` (new tab, `rel="noopener"`).
- **Desktop:** one horizontal row (legal left, badge right).
- **Mobile:** the three legal items stack **one per line**, centred, badge below.

### Desktop layout
5-column grid: `brand (1.6fr) · บริการ · ลิงก์ด่วน · สาขา1 (1.25fr) · สาขา2 (1.25fr)`.

### Mobile layout
Stack: brand → **[ บริการ | ลิงก์ด่วน ] as a 2-column grid** → the two branches stacked full-width → bottom bar.

---

## 5. Decisions log (what we chose + why)

| # | Decision | Rationale |
|---|---|---|
| D1 | Visual language = Densmi-style mega panels, re-skinned to brand | User-provided reference; brand palette already close |
| D2 | Mega-menu IA = **hybrid** (curated strong clusters, not full taxonomy) | Most content pages not built yet |
| D3 | **Two** mega panels: รากฟันเทียม (flagship, own panel) + บริการ | Implant-first positioning; รากฟันเทียม has the most ready content |
| D4 | Desktop header = **two-tier** | 7–8 tabs + utilities won't fit one row; booking CTA was being squeezed |
| D5 | Slogan in utility bar = **English, Cabinet Grotesk**, no icon | User preference; reads as a branded tagline |
| D6 | Language switcher = **dropdown** (desktop utility + mobile bar); **pills** were rejected | 3 locales incl. CJK; dropdown is cleaner. On mobile it sits on the bar (not inside the drawer) |
| D7 | Social = **kept but minimal** (no circular chips), in utility row / footer | Cleaner; header chrome stays light |
| D8 | Unbuilt links show **`เร็วๆ นี้`** (disabled), not hidden | Future-proof IA; flip per-link when pages publish |
| D9 | Mobile drawer CTA = **one button** "นัดปรึกษาทันตแพทย์เฉพาะทาง" + hover effect | User reduced the จองคิว+LINE pair to a single specialist-consult CTA |
| D10 | LINE lives in the **social-icon row** (drawer + footer), not as a standalone button | Still reachable after dropping the LINE button |
| D11 | Mobile drawer scrim = **heavy blur** (16px) + dark | User wanted strong background blur |
| D12 | Footer = **light** theme (both breakpoints), colour logo | User preference; airy/clean. Logo kept as the stacked lockup for now |
| D13 | Q-Clinic = generic **"ตรวจสอบได้" external link** (no licence number) | Numbers are per-branch; a single verify link to สบส. avoids hardcoding and stays verifiable |
| D14 | Branch address in footer = **province only** | Map link covers precise location; keeps footer lean |

---

## 6. Component architecture (implementation target)

- **Extract** `web/src/components/SiteHeader.astro` and `web/src/components/SiteFooter.astro`; `Base.astro` imports them (keeps the shared shell lean; reduces churn — Base is touched by multiple workstreams incl. the `content-templates` branch).
- **One responsive component each** — Tailwind responsive utilities switch desktop ↔ mobile layouts; do NOT create separate desktop/mobile files.
- **Data shape** — drive nav + footer from per-locale data (mirror the `home` collection pattern, or a `lib/site-nav.ts` + label maps). Each nav/link item:
  ```ts
  { label: string; href?: string; soon?: boolean; cta?: boolean }
  ```
  `soon: true` (or missing `href`) → renders the disabled `เร็วๆ นี้` pill. Flipping a page live = set its `href` / clear `soon` (single data edit). This can later integrate the content-templates 4-state link resolver.
- **Branches** — source NAP from `content-plan/branches.md` / the future `seo_branches` table (Supabase seam); footer + mega panels read the same source.
- **Mega-panel service lists** — curated static for now; later driven by the page system / `sitemap.md`.
- **Class-name hygiene** — Tailwind utilities (scoped by nature) avoid the `.phone` collision bug found in the mockup (a contact `.phone` link inherited the device-frame `.phone` sizing). Do not reuse ambiguous semantic class names in any hand-written CSS.

---

## 7. Operator data gaps (BLOCKERS for "real" content)

- **Per-branch NAP:** full street address, **real phone numbers** (currently shared placeholder `098 462 4949`), **Google Place ID / map URL**, **confirmed opening hours** (currently "เปิดทุกวัน 10.00–20.00", placeholder).
- **Social URLs:** real Facebook / Instagram / TikTok / **LINE OA** links.
- **Translations:** EN + zh-CN copy for ALL header/footer strings (slogan, nav, mega-panel headings + links, footer links, branch labels, legal/PDPA, CTA).
- **Logo assets:** export clean header (horizontal) + footer (stacked) logos into `web/src/assets/` for `astro:assets`. (User chose to keep the stacked lockup on the footer for now.)
- **Q-Clinic:** confirmed — use the generic verify link (no licence number needed).

---

## 8. Implementation notes / guardrails

- Tokens-only + `font-sans`/`font-display`; logo via `Image.astro`/`astro:assets` (DR-035).
- i18n via `Astro.currentLocale` + per-locale maps; lang switcher → existing `alt.*`; hreflang already emitted by Base.
- Reuse existing primitives where sensible (`ui/Button.astro`, `ui/Image.astro`).
- Respect `prefers-reduced-motion` for: utility-row collapse, mega-panel reveal, drawer slide, CTA hover, backdrop blur (provide a non-blur fallback).
- Accessibility: mega menu + drawer keyboard/`aria-expanded`/focus-trap/`Esc`; language switcher as a proper menu; verify contrast on the light footer.
- Keep `robots: noindex` default; coordinate `Base.astro` edits with the `content-templates` branch (pull latest before editing).
- Verify with `npm run check` / `build` / `preview` (ignore the ~19 pre-existing errors in `Landing.astro` / `dental-implant.astro` / `AssessmentApp.astro`). Deploy is operator-gated (`npx wrangler deploy`).

---

## 9. Out of scope / later

- Real images for the บริการ panel and any footer imagery (placeholders for now).
- Driving mega-panel taxonomy from the live page system / Supabase.
- Optional: condense-logo-on-scroll, richer hover micro-interactions on desktop nav.
