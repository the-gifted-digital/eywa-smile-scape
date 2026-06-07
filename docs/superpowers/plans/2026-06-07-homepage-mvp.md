# Homepage MVP (go. root) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the `go.smilescapeclinic.com/` skeleton with a real bilingual (TH `/` + EN `/en/`) homepage built as a full Astro component library, tracking-wired, `noindex,follow`, all images swap-ready placeholders.

**Architecture:** Extend `Base.astro` into the full-site shell (GTM + robots + trimmed nav + global click tracking + sticky CTA). Every homepage section is a component under `src/components/{ui,cards,sections,forms}`; `index.astro`/`en/index.astro` are pure composition fed by a new `home` Astro **data** content-collection (`src/content/home/{th,en}.yaml`). Images flow through one `Image.astro` wrapper so placeholders swap to Cloudflare URLs later with no markup change (DR-035).

**Tech Stack:** Astro 4.16, Tailwind 3.4 (tokens → `brand-*` classes, DR-029), Partytown GTM, content collections (zod), Cloudflare Workers Static Assets. Node 22.

**Spec:** `docs/superpowers/specs/2026-06-07-homepage-mvp-design.md`

---

## Testing approach (read first)

This project has **no unit-test runner** (`web/package.json` scripts = `dev/build/preview/check` only) and static Astro components are presentational. The verification loop for every task is therefore:

- `cd web && npm run check` → `astro check` passes (0 errors). This is the type/template "test".
- `cd web && npm run build` → build succeeds (0 errors/warnings about our files).
- `cd web && npm run preview` → open `http://localhost:4321/` (and `/en/`) and visually confirm the section renders. **Never** open `dist/` via `file://`.
- For tracking/form tasks: confirm `window.dataLayer` receives the event (DevTools console) and the form POSTs.

Where a step says "verify", run the relevant subset above. Commit after each task passes.

**Conventions:** PascalCase component files; `~/` = `web/src/`; **no raw hex / no `bg-blue-*`** — only `brand-*` token classes and `font-sans`/`font-display`; every `<img>` goes through `Image.astro`; no hardcoded "SmileScape"/phone/copy inside components (brand-agnostic — spec §15) — those come from data/props.

---

## File Structure

**Create**
- `web/src/components/ui/Image.astro` — image wrapper (placeholder | local | remote)
- `web/src/components/ui/Button.astro` — CTA link, variants primary/outline/pill
- `web/src/components/ui/SectionHeading.astro` — eyebrow + title + subtitle
- `web/src/components/ui/Section.astro` — vertical-rhythm wrapper
- `web/src/components/cards/Pillar.astro`
- `web/src/components/cards/ServiceCard.astro`
- `web/src/components/cards/DoctorCard.astro`
- `web/src/components/cards/ReviewCard.astro`
- `web/src/components/cards/BranchCard.astro`
- `web/src/components/sections/Hero.astro`
- `web/src/components/sections/TrustBar.astro`
- `web/src/components/sections/WhyPillars.astro`
- `web/src/components/sections/BlueDiamond.astro`
- `web/src/components/sections/ServicesGrid.astro`
- `web/src/components/sections/PartnerLogos.astro`
- `web/src/components/sections/FoundersMastery.astro`
- `web/src/components/sections/TeamRoster.astro`
- `web/src/components/sections/ProcessSteps.astro`
- `web/src/components/sections/BeforeAfter.astro`
- `web/src/components/sections/Reviews.astro`
- `web/src/components/sections/Branches.astro`
- `web/src/components/sections/FinalCta.astro`
- `web/src/components/sections/StickyCta.astro`
- `web/src/components/forms/BookingForm.astro`
- `web/src/content/home/th.yaml`, `web/src/content/home/en.yaml`
- `web/src/lib/home.ts` — typed helper `getHome(locale)`

**Modify**
- `web/src/content/config.ts` — add `home` data collection + schema
- `web/src/lib/analytics.ts` — default GTM id to the real container
- `web/src/layouts/Base.astro` — robots prop, nav trim, global click tracking, StickyCta slot
- `web/src/pages/index.astro` — compose TH homepage
- `web/src/pages/en/index.astro` — compose EN homepage

**Do NOT touch:** `lp/dental-implant.astro`, `layouts/Landing.astro`, `pages/privacy-policy.astro`.

---

## Task 1: `home` content-collection schema + seed data

**Files:**
- Modify: `web/src/content/config.ts`
- Create: `web/src/content/home/th.yaml`
- Create: `web/src/content/home/en.yaml`

- [ ] **Step 1: Add the `home` data collection to `config.ts`**

Append to `web/src/content/config.ts` (before the final `export const collections`), then add `home` to that export.

```ts
// ---------- Home (single composed landing page per locale) ----------
const imageRef = z.object({
  src: z.string().optional(),   // undefined or "placeholder:..." → placeholder box (DR-035 swap point)
  alt: z.string(),
  label: z.string().optional(), // placeholder badge text
});
const cta = z.object({ label: z.string(), href: z.string() });

const home = defineCollection({
  type: 'data',
  schema: z.object({
    meta: z.object({ title: z.string(), description: z.string() }),
    hero: z.object({
      eyebrow: z.string(),
      title: z.string(),
      body: z.string(),
      primaryCta: cta,
      secondaryCta: cta,
      image: imageRef,
    }),
    trustBar: z.array(z.object({ label: z.string() })),
    pillars: z.array(z.object({ icon: z.string(), title: z.string(), body: z.string() })),
    blueDiamond: z.object({
      eyebrow: z.string(),
      title: z.string(),
      priceLabel: z.string(),
      bullets: z.array(z.string()),
      image: imageRef,
      cta,
    }),
    services: z.array(z.object({ title: z.string(), summary: z.string(), href: z.string(), image: imageRef })),
    partners: z.array(z.object({ name: z.string(), logo: imageRef })),
    founders: z.array(z.object({ name: z.string(), role: z.string(), credentials: z.array(z.string()), image: imageRef })),
    doctors: z.array(z.object({ name: z.string(), role: z.string(), image: imageRef })),
    process: z.array(z.object({ step: z.number(), title: z.string(), body: z.string(), image: imageRef })),
    beforeAfter: z.array(z.object({ before: imageRef, after: imageRef, caption: z.string() })),
    reviews: z.array(z.object({ quote: z.string(), name: z.string(), stars: z.number() })),
    video: z.object({ poster: imageRef, src: z.string().optional(), label: z.string() }),
    branches: z.array(z.object({ name: z.string(), mrt: z.string(), address: z.string(), mapUrl: z.string() })),
    faq: z.array(faqItem),
    finalCta: z.object({ title: z.string(), body: z.string(), cta }),
  }),
});

```

Update the export line to:

```ts
export const collections = { pages, articles, home };
```

- [ ] **Step 2: Create `web/src/content/home/th.yaml`** (TH content; every image `src` omitted → placeholder)

```yaml
meta:
  title: SmileScape Dental Clinic
  description: >-
    คลินิกทันตกรรม SmileScape — รากฐานฟันที่มั่นคงเพื่อความสุขที่ยั่งยืนตลอดชีวิต.
    เด่นด้านรากฟันเทียม Blue Diamond รับประกันตลอดชีพ ผ่อน 0%. สาขารัตนาธิเบศร์ และ ศรีนครินทร์.
hero:
  eyebrow: The Lifetime Foundation
  title: รากฐานฟันที่มั่นคง เพื่อความสุขที่ยั่งยืนตลอดชีวิต
  body: คลินิกทันตกรรมเฉพาะทางด้านรากฟันเทียม นำโดยทันตแพทย์ผู้เชี่ยวชาญระดับสากล ด้วยมาตรฐานการวินิจฉัยและการดูแลระยะยาว
  primaryCta: { label: จองคิวปรึกษาฟรี, href: '#booking' }
  secondaryCta: { label: ดูรากฟันเทียม Blue Diamond, href: /lp/dental-implant/ }
  image: { alt: คลินิก SmileScape, label: hero }
trustBar:
  - { label: รีวิว 5.0★ Google }
  - { label: 2 สาขา ติด MRT }
  - { label: รับประกันตลอดชีพ }
  - { label: ผ่อน 0% ไม่ใช้บัตร }
  - { label: วางแผน Digital 100% }
pillars:
  - { icon: implant, title: Implant Mastery, body: ผลลัพธ์รากฟันเทียมแม่นยำ ด้วยดีกรีระดับโลก + วางแผนดิจิทัล 100% }
  - { icon: shield, title: Family-Standard Integrity, body: 'มาตรฐานครอบครัว: เคสที่ไม่กล้าทำให้พ่อแม่ตัวเอง เราไม่ทำ — ไม่ over-treatment' }
  - { icon: clock, title: Efficiency & Comfort, body: ลดเวลาผ่าตัด ลดความเจ็บปวด ฟื้นตัวเร็ว }
  - { icon: heart, title: Lifelong Confidence, body: รากฟันเทียมที่ออกแบบให้ใช้งานได้จริงระยะยาว }
blueDiamond:
  eyebrow: Hero Service
  title: Blue Diamond Implant — รากฟันเทียมตัวเลือกสุดท้ายของคุณ
  priceLabel: เริ่ม 29,900 บาท / ซี่
  bullets:
    - รับประกันตลอดชีพ
    - ผ่อน 0% ไม่ต้องใช้บัตรเครดิต
    - วัสดุนำเข้าเกาหลี (value-premium)
    - Tissue / Operator / Patient Friendly + MegaGen
  image: { alt: Blue Diamond Implant, label: 'Blue Diamond' }
  cta: { label: ดูรายละเอียด Blue Diamond, href: /lp/dental-implant/ }
services:
  - { title: รากฟันเทียม, summary: Single / Multiple implant, href: /lp/dental-implant/, image: { alt: รากฟันเทียม, label: service } }
  - { title: All-on-X รากฟันเทียมทั้งปาก, summary: ฟันทั้งขากรรไกรบนรากเทียม, href: '#booking', image: { alt: All-on-X, label: service } }
  - { title: จัดฟัน / จัดฟันใส, summary: โลหะ · ใส · Clear Aligner, href: '#booking', image: { alt: จัดฟัน, label: service } }
  - { title: วีเนียร์ & Smile Design, summary: ออกแบบรอยยิ้ม, href: '#booking', image: { alt: วีเนียร์, label: service } }
  - { title: ทันตกรรมทั่วไป, summary: อุด ถอน ขูดหินปูน รักษาราก, href: '#booking', image: { alt: ทันตกรรมทั่วไป, label: service } }
  - { title: เฉพาะทางอื่น ๆ, summary: ปริทันต์ · เด็ก · ครอบ-สะพานฟัน, href: '#booking', image: { alt: เฉพาะทาง, label: service } }
partners:
  - { name: MegaGen, logo: { alt: MegaGen, label: LOGO } }
  - { name: Neodent, logo: { alt: Neodent, label: LOGO } }
  - { name: Straumann, logo: { alt: Straumann, label: LOGO } }
  - { name: 3Shape, logo: { alt: 3Shape, label: LOGO } }
  - { name: Acteon, logo: { alt: Acteon, label: LOGO } }
  - { name: Invisalign, logo: { alt: Invisalign, label: LOGO } }
founders:
  - name: ทพ. วรภัทร จรางกุล (หมอแฮม)
    role: Medical Director & Lead Implantologist
    credentials:
      - เกียรตินิยมอันดับ 1 (เหรียญทอง) ทันตแพทยศาสตร์ มหิดล
      - วุฒิบัตรศัลยกรรมช่องปากและขากรรไกร จุฬาฯ
      - Dual M.Sc. Implantology (ไทย + เยอรมนี)
      - Global Masterclasses (Urban / Kern / ILAPEO)
    image: { alt: หมอแฮม, label: หมอแฮม }
  - name: ทพญ. พิชชาภา ผุดผ่อง (หมอแพรว)
    role: ศัลยแพทย์ช่องปากและขากรรไกร · ผู้ร่วมก่อตั้ง
    credentials:
      - ศัลยแพทย์เฉพาะทางช่องปากและแม็กซิลโลเฟเชียล
      - วิทยากรด้านทันตกรรมรากเทียม
      - Co-CEO & ผู้ร่วมก่อตั้ง SmileScape
    image: { alt: หมอแพรว, label: หมอแพรว }
doctors:
  - { name: ทันตแพทย์เฉพาะทางปริทันต์, role: Periodontist, image: { alt: ทันตแพทย์, label: หมอ } }
  - { name: ทันตแพทย์เฉพาะทางรักษาราก, role: Endodontist, image: { alt: ทันตแพทย์, label: หมอ } }
  - { name: ทันตแพทย์เฉพาะทางเด็ก, role: Pediatric Dentist, image: { alt: ทันตแพทย์, label: หมอ } }
  - { name: ทันตแพทย์จัดฟัน, role: Orthodontist, image: { alt: ทันตแพทย์, label: หมอ } }
  - { name: ทันตแพทย์ทั่วไป, role: General Dentist, image: { alt: ทันตแพทย์, label: หมอ } }
  - { name: ทันตแพทย์ศัลยกรรมช่องปาก, role: Oral Surgeon, image: { alt: ทันตแพทย์, label: หมอ } }
process:
  - { step: 1, title: ปรึกษาฟรี, body: ประเมินเคสและเป้าหมาย, image: { alt: ปรึกษา, label: '1' } }
  - { step: 2, title: X-ray & วินิจฉัย, body: สแกน 3 มิติ วางแผนดิจิทัล, image: { alt: x-ray, label: '2' } }
  - { step: 3, title: วางแผนการรักษา, body: ออกแบบแผนเฉพาะบุคคล, image: { alt: วางแผน, label: '3' } }
  - { step: 4, title: รักษา, body: ฝังรากเทียมแม่นยำ, image: { alt: รักษา, label: '4' } }
  - { step: 5, title: ติดตามผล, body: ดูแลระยะยาว, image: { alt: ติดตาม, label: '5' } }
beforeAfter:
  - { caption: เคสตัวอย่าง 1, before: { alt: ก่อน, label: BEFORE }, after: { alt: หลัง, label: AFTER } }
  - { caption: เคสตัวอย่าง 2, before: { alt: ก่อน, label: BEFORE }, after: { alt: หลัง, label: AFTER } }
  - { caption: เคสตัวอย่าง 3, before: { alt: ก่อน, label: BEFORE }, after: { alt: หลัง, label: AFTER } }
reviews:
  - { quote: ดูแลดีมาก อธิบายละเอียด ไม่เจ็บอย่างที่กลัว, name: คุณ A, stars: 5 }
  - { quote: ทำรากฟันเทียมแล้วมั่นใจขึ้นเยอะ, name: คุณ B, stars: 5 }
  - { quote: ทีมงานเป็นกันเอง คลินิกสะอาด, name: คุณ C, stars: 5 }
video:
  label: วิดีโอรีวิว
  poster: { alt: วิดีโอรีวิวคนไข้, label: '▶ รีวิว' }
branches:
  - { name: สาขารัตนาธิเบศร์, mrt: MRT สีม่วง · สถานีแยกนนทบุรี 1, address: 'นนทบุรี (ที่อยู่เต็มรอผู้ดูแล)', mapUrl: 'https://maps.google.com/?q=SmileScape+รัตนาธิเบศร์' }
  - { name: สาขาศรีนครินทร์, mrt: MRT สีเหลือง, address: 'กรุงเทพฯ (ที่อยู่เต็มรอผู้ดูแล)', mapUrl: 'https://maps.google.com/?q=SmileScape+ศรีนครินทร์' }
faq:
  - { q: รากฟันเทียม Blue Diamond ราคาเท่าไหร่?, a: เริ่มต้น 29,900 บาทต่อซี่ รับประกันตลอดชีพ และผ่อน 0% ได้โดยไม่ต้องใช้บัตรเครดิต (เงื่อนไขเป็นไปตามที่คลินิกกำหนด). }
  - { q: SmileScape มีกี่สาขา?, a: ปัจจุบันมี 2 สาขา คือ สาขารัตนาธิเบศร์ (ติด MRT สีม่วง) และสาขาศรีนครินทร์ (ติด MRT สีเหลือง). }
  - { q: ต้องนัดหมายก่อนไหม?, a: แนะนำให้นัดหมายล่วงหน้าผ่านฟอร์มจองคิวหรือ LINE เพื่อความสะดวกและลดเวลารอ. }
finalCta:
  title: เริ่มต้นรากฐานรอยยิ้มที่มั่นคงของคุณวันนี้
  body: ปรึกษาฟรีกับทันตแพทย์เฉพาะทาง
  cta: { label: จองคิวปรึกษาฟรี, href: '#booking' }
```

- [ ] **Step 3: Create `web/src/content/home/en.yaml`** (1:1 EN translation — identical keys)

```yaml
meta:
  title: SmileScape Dental Clinic
  description: >-
    SmileScape Dental Clinic — The Lifetime Foundation. Implant-first specialty
    care, Blue Diamond implant with lifetime warranty and 0% installments. Two
    branches: Rattanathibet & Srinagarindra.
hero:
  eyebrow: The Lifetime Foundation
  title: A stable foundation for a lifetime of confident smiles
  body: An implant-first dental clinic led by globally-trained specialists, with rigorous diagnostics and long-term care.
  primaryCta: { label: Book a free consultation, href: '#booking' }
  secondaryCta: { label: Explore Blue Diamond implants, href: /en/lp/dental-implant/ }
  image: { alt: SmileScape clinic, label: hero }
trustBar:
  - { label: 5.0★ Google reviews }
  - { label: 2 branches by MRT }
  - { label: Lifetime warranty }
  - { label: 0% installments }
  - { label: 100% digital planning }
pillars:
  - { icon: implant, title: Implant Mastery, body: Precise implant outcomes with global degrees and 100% digital planning. }
  - { icon: shield, title: Family-Standard Integrity, body: 'If we wouldn''t do it for our own parents, we won''t do it for you — no over-treatment.' }
  - { icon: clock, title: Efficiency & Comfort, body: Shorter surgery, less pain, faster recovery. }
  - { icon: heart, title: Lifelong Confidence, body: Implants engineered for real long-term use. }
blueDiamond:
  eyebrow: Hero Service
  title: Blue Diamond Implant — your final dental implant selection
  priceLabel: From 29,900 THB / tooth
  bullets:
    - Lifetime warranty
    - 0% installments, no credit card
    - Korea-manufactured (value-premium)
    - Tissue / Operator / Patient Friendly + MegaGen
  image: { alt: Blue Diamond Implant, label: 'Blue Diamond' }
  cta: { label: See Blue Diamond details, href: /en/lp/dental-implant/ }
services:
  - { title: Dental Implants, summary: Single / multiple implant, href: /en/lp/dental-implant/, image: { alt: implants, label: service } }
  - { title: All-on-X full-arch, summary: Full-arch implant restoration, href: '#booking', image: { alt: All-on-X, label: service } }
  - { title: Orthodontics / Clear Aligner, summary: Metal · clear · aligner, href: '#booking', image: { alt: ortho, label: service } }
  - { title: Veneers & Smile Design, summary: Smile design, href: '#booking', image: { alt: veneers, label: service } }
  - { title: General Dentistry, summary: Fillings, extraction, scaling, RCT, href: '#booking', image: { alt: general, label: service } }
  - { title: Other Specialties, summary: Perio · pediatric · crown-bridge, href: '#booking', image: { alt: specialty, label: service } }
partners:
  - { name: MegaGen, logo: { alt: MegaGen, label: LOGO } }
  - { name: Neodent, logo: { alt: Neodent, label: LOGO } }
  - { name: Straumann, logo: { alt: Straumann, label: LOGO } }
  - { name: 3Shape, logo: { alt: 3Shape, label: LOGO } }
  - { name: Acteon, logo: { alt: Acteon, label: LOGO } }
  - { name: Invisalign, logo: { alt: Invisalign, label: LOGO } }
founders:
  - name: Dr. Worapat Jarangkul (Dr. Ham)
    role: Medical Director & Lead Implantologist
    credentials:
      - First-class honours (Gold Medal), Mahidol Dentistry
      - Board cert. Oral & Maxillofacial Surgery, Chulalongkorn
      - Dual M.Sc. Implantology (Thailand + Germany)
      - Global Masterclasses (Urban / Kern / ILAPEO)
    image: { alt: Dr. Ham, label: Dr. Ham }
  - name: Dr. Pitchapa Phudphong (Dr. Praew)
    role: Oral & Maxillofacial Surgeon · Co-Founder
    credentials:
      - Oral & maxillofacial surgeon
      - Implantology educator
      - Co-CEO & co-founder of SmileScape
    image: { alt: Dr. Praew, label: Dr. Praew }
doctors:
  - { name: Periodontist, role: Gum specialist, image: { alt: dentist, label: dr } }
  - { name: Endodontist, role: Root canal specialist, image: { alt: dentist, label: dr } }
  - { name: Pediatric Dentist, role: Kids specialist, image: { alt: dentist, label: dr } }
  - { name: Orthodontist, role: Braces specialist, image: { alt: dentist, label: dr } }
  - { name: General Dentist, role: General care, image: { alt: dentist, label: dr } }
  - { name: Oral Surgeon, role: Surgery, image: { alt: dentist, label: dr } }
process:
  - { step: 1, title: Free consultation, body: Assess case and goals, image: { alt: consult, label: '1' } }
  - { step: 2, title: X-ray & diagnosis, body: 3D scan, digital planning, image: { alt: x-ray, label: '2' } }
  - { step: 3, title: Treatment plan, body: Personalised plan, image: { alt: plan, label: '3' } }
  - { step: 4, title: Treatment, body: Precise implant placement, image: { alt: treat, label: '4' } }
  - { step: 5, title: Follow-up, body: Long-term care, image: { alt: follow, label: '5' } }
beforeAfter:
  - { caption: Case 1, before: { alt: before, label: BEFORE }, after: { alt: after, label: AFTER } }
  - { caption: Case 2, before: { alt: before, label: BEFORE }, after: { alt: after, label: AFTER } }
  - { caption: Case 3, before: { alt: before, label: BEFORE }, after: { alt: after, label: AFTER } }
reviews:
  - { quote: Great care, detailed explanation, far less painful than I feared., name: Patient A, stars: 5 }
  - { quote: Much more confident after my implant., name: Patient B, stars: 5 }
  - { quote: Friendly team, spotless clinic., name: Patient C, stars: 5 }
video:
  label: Patient review video
  poster: { alt: patient review video, label: '▶ review' }
branches:
  - { name: Rattanathibet branch, mrt: MRT Purple · Yaek Nonthaburi 1, address: 'Nonthaburi (full address pending)', mapUrl: 'https://maps.google.com/?q=SmileScape+Rattanathibet' }
  - { name: Srinagarindra branch, mrt: MRT Yellow, address: 'Bangkok (full address pending)', mapUrl: 'https://maps.google.com/?q=SmileScape+Srinagarindra' }
faq:
  - { q: How much is the Blue Diamond implant?, a: From 29,900 THB per tooth with lifetime warranty and 0% installments (no credit card needed; clinic terms apply). }
  - { q: How many branches does SmileScape have?, a: Two — Rattanathibet (MRT Purple) and Srinagarindra (MRT Yellow). }
  - { q: Do I need an appointment?, a: We recommend booking ahead via the form or LINE to reduce waiting time. }
finalCta:
  title: Start your stable smile foundation today
  body: Free consultation with our specialists
  cta: { label: Book a free consultation, href: '#booking' }
```

- [ ] **Step 4: Verify** — `cd web && npm run check` passes (schema compiles, both YAML parse). Expected: 0 errors.

- [ ] **Step 5: Commit**

```bash
cd "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
git add web/src/content/config.ts web/src/content/home/
git commit -m "feat(home): add home data collection + TH/EN seed content"
```

---

## Task 2: `lib/home.ts` typed accessor

**Files:**
- Create: `web/src/lib/home.ts`

- [ ] **Step 1: Create the helper**

```ts
import { getEntry } from 'astro:content';

export type Locale = 'th' | 'en';

/** Load the composed homepage data for a locale (falls back to th). */
export async function getHome(locale: Locale) {
  const entry = (await getEntry('home', locale)) ?? (await getEntry('home', 'th'));
  return entry!.data;
}
```

- [ ] **Step 2: Verify** — `cd web && npm run check`. Expected: 0 errors.

- [ ] **Step 3: Commit**

```bash
git add web/src/lib/home.ts && git commit -m "feat(home): typed getHome(locale) accessor"
```

---

## Task 3: `ui/Image.astro` (DR-035 swap-ready wrapper)

**Files:**
- Create: `web/src/components/ui/Image.astro`

- [ ] **Step 1: Create the component**

```astro
---
// Image.astro — single image seam (DR-035). MVP renders placeholders;
// later set `src` to a Cloudflare URL (https://...) or local /assets path
// with NO markup change. Always pass width/height to prevent CLS.
interface Props {
  src?: string;
  alt: string;
  width: number;
  height: number;
  label?: string;
  class?: string;
  loading?: 'lazy' | 'eager';
  rounded?: boolean;
}
const { src, alt, width, height, label, class: className = '', loading = 'lazy', rounded = true } = Astro.props;
const isPlaceholder = !src || src.startsWith('placeholder:');
const ratio = `${width} / ${height}`;
const radius = rounded ? 'rounded-lg' : '';
---
{isPlaceholder ? (
  <div
    role="img"
    aria-label={alt}
    style={`aspect-ratio:${ratio}`}
    class:list={[
      'flex w-full items-center justify-center bg-brand-neutral-100 border border-brand-neutral-200 text-brand-neutral-400 text-xs font-semibold text-center p-2',
      radius,
      className,
    ]}
  >
    <span>{label ?? alt}</span>
  </div>
) : (
  <img
    src={src}
    alt={alt}
    width={width}
    height={height}
    loading={loading}
    decoding="async"
    class:list={['w-full h-auto object-cover', radius, className]}
  />
)}
```

- [ ] **Step 2: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/ui/Image.astro && git commit -m "feat(ui): Image.astro placeholder/swap wrapper (DR-035)"
```

---

## Task 4: `ui/Button.astro`, `ui/SectionHeading.astro`, `ui/Section.astro`

**Files:**
- Create: `web/src/components/ui/Button.astro`
- Create: `web/src/components/ui/SectionHeading.astro`
- Create: `web/src/components/ui/Section.astro`

- [ ] **Step 1: `Button.astro`**

```astro
---
interface Props {
  href: string;
  variant?: 'primary' | 'outline' | 'ghost';
  class?: string;
}
const { href, variant = 'primary', class: className = '' } = Astro.props;
const base = 'inline-flex items-center justify-center rounded-full px-6 py-3 font-semibold transition-colors';
const styles = {
  primary: 'bg-brand-primary text-brand-neutral-0 hover:bg-brand-primary-deep',
  outline: 'border border-brand-neutral-300 text-brand-anchor hover:border-brand-primary',
  ghost: 'text-brand-primary-deep hover:underline',
};
---
<a href={href} class:list={[base, styles[variant], className]}><slot /></a>
```

- [ ] **Step 2: `SectionHeading.astro`**

```astro
---
interface Props {
  eyebrow?: string;
  title: string;
  subtitle?: string;
  align?: 'left' | 'center';
  onDark?: boolean;   // switch text to light for dark (anchor) sections
}
const { eyebrow, title, subtitle, align = 'left', onDark = false } = Astro.props;
const alignCls = align === 'center' ? 'text-center mx-auto' : '';
const titleCls = onDark ? 'text-brand-neutral-0' : 'text-brand-anchor';
const subCls = onDark ? 'text-brand-neutral-200' : 'text-brand-neutral-700';
const eyebrowCls = onDark ? 'text-brand-highlight' : 'text-brand-primary-deep';
---
<div class:list={['max-w-2xl', alignCls]}>
  {eyebrow && <p class:list={['font-display text-sm font-medium uppercase tracking-[0.2em]', eyebrowCls]}>{eyebrow}</p>}
  <h2 class:list={['mt-2 text-2xl md:text-3xl font-bold', titleCls]}>{title}</h2>
  {subtitle && <p class:list={['mt-3 leading-relaxed', subCls]}>{subtitle}</p>}
</div>
```

- [ ] **Step 3: `Section.astro`**

```astro
---
interface Props {
  id?: string;
  tone?: 'default' | 'ice' | 'paper' | 'anchor';
  class?: string;
}
const { id, tone = 'default', class: className = '' } = Astro.props;
const tones = {
  default: '',
  ice: 'bg-brand-ice',
  paper: 'bg-brand-paper',
  anchor: 'bg-brand-anchor text-brand-neutral-0',
};
---
<section id={id} class:list={[tones[tone], className]}>
  <div class="max-w-6xl mx-auto px-4 py-14 md:py-20">
    <slot />
  </div>
</section>
```

- [ ] **Step 4: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 5: Commit**

```bash
git add web/src/components/ui/ && git commit -m "feat(ui): Button, SectionHeading, Section atoms"
```

---

## Task 5: Card components

**Files:**
- Create: `web/src/components/cards/{Pillar,ServiceCard,DoctorCard,ReviewCard,BranchCard}.astro`

- [ ] **Step 1: `Pillar.astro`**

```astro
---
interface Props { icon: string; title: string; body: string; }
const { title, body } = Astro.props;
---
<div class="rounded-lg border border-brand-neutral-200 bg-brand-neutral-0 p-5">
  <div class="h-9 w-9 rounded-full bg-brand-primary-soft"></div>
  <h3 class="mt-3 font-display font-bold text-brand-anchor">{title}</h3>
  <p class="mt-1 text-sm text-brand-neutral-700 leading-relaxed">{body}</p>
</div>
```

- [ ] **Step 2: `ServiceCard.astro`**

```astro
---
import Image from '~/components/ui/Image.astro';
interface Props { title: string; summary: string; href: string; image: { src?: string; alt: string; label?: string }; }
const { title, summary, href, image } = Astro.props;
---
<a href={href} class="group block rounded-lg border border-brand-neutral-200 bg-brand-neutral-0 overflow-hidden hover:border-brand-primary transition-colors">
  <Image src={image.src} alt={image.alt} label={image.label} width={400} height={240} rounded={false} />
  <div class="p-4">
    <h3 class="font-display font-bold text-brand-anchor group-hover:text-brand-primary-deep">{title}</h3>
    <p class="mt-1 text-sm text-brand-neutral-700">{summary}</p>
  </div>
</a>
```

- [ ] **Step 3: `DoctorCard.astro`**

```astro
---
import Image from '~/components/ui/Image.astro';
interface Props { name: string; role: string; image: { src?: string; alt: string; label?: string }; }
const { name, role, image } = Astro.props;
---
<div class="rounded-lg border border-brand-neutral-200 overflow-hidden bg-brand-neutral-0">
  <Image src={image.src} alt={image.alt} label={image.label} width={300} height={320} rounded={false} />
  <div class="p-3">
    <p class="font-semibold text-brand-anchor text-sm">{name}</p>
    <p class="text-xs text-brand-neutral-500">{role}</p>
  </div>
</div>
```

- [ ] **Step 4: `ReviewCard.astro`**

```astro
---
interface Props { quote: string; name: string; stars: number; }
const { quote, name, stars } = Astro.props;
---
<figure class="rounded-lg border border-brand-neutral-200 bg-brand-neutral-0 p-5">
  <div class="text-brand-accent" aria-label={`${stars} ดาว`}>{'★'.repeat(stars)}</div>
  <blockquote class="mt-2 text-brand-neutral-700">{quote}</blockquote>
  <figcaption class="mt-3 text-sm font-semibold text-brand-anchor">{name}</figcaption>
</figure>
```

- [ ] **Step 5: `BranchCard.astro`**

```astro
---
interface Props { name: string; mrt: string; address: string; mapUrl: string; }
const { name, mrt, address, mapUrl } = Astro.props;
---
<div class="rounded-lg border border-brand-neutral-200 bg-brand-neutral-0 p-5">
  <h3 class="font-display font-bold text-brand-anchor">{name}</h3>
  <p class="mt-1 text-sm text-brand-primary-deep">{mrt}</p>
  <p class="mt-1 text-sm text-brand-neutral-700">{address}</p>
  <a href={mapUrl} class="mt-3 inline-block text-sm font-semibold text-brand-primary-deep hover:underline">เปิดในแผนที่ →</a>
</div>
```

- [ ] **Step 6: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 7: Commit**

```bash
git add web/src/components/cards/ && git commit -m "feat(cards): Pillar, ServiceCard, DoctorCard, ReviewCard, BranchCard"
```

---

## Task 6: Section components — Hero, TrustBar

**Files:**
- Create: `web/src/components/sections/Hero.astro`, `web/src/components/sections/TrustBar.astro`

- [ ] **Step 1: `Hero.astro`** (`data-hero` drives the StickyCta IntersectionObserver)

```astro
---
import Button from '~/components/ui/Button.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  eyebrow: string; title: string; body: string;
  primaryCta: { label: string; href: string };
  secondaryCta: { label: string; href: string };
  image: { src?: string; alt: string; label?: string };
}
const { eyebrow, title, body, primaryCta, secondaryCta, image } = Astro.props;
---
<section data-hero class="bg-brand-anchor text-brand-neutral-0">
  <div class="max-w-6xl mx-auto px-4 py-16 md:py-24 grid md:grid-cols-2 gap-10 items-center">
    <div>
      <p class="font-display text-sm font-medium uppercase tracking-[0.2em] text-brand-highlight">{eyebrow}</p>
      <h1 class="mt-4 text-4xl md:text-5xl font-bold leading-tight">{title}</h1>
      <p class="mt-6 max-w-xl text-lg text-brand-neutral-200">{body}</p>
      <div class="mt-8 flex flex-wrap gap-4">
        <Button href={primaryCta.href} variant="primary">{primaryCta.label}</Button>
        <Button href={secondaryCta.href} variant="outline" class="!border-brand-neutral-0/40 !text-brand-neutral-0 hover:!bg-brand-neutral-0/10">{secondaryCta.label}</Button>
      </div>
    </div>
    <Image src={image.src} alt={image.alt} label={image.label} width={640} height={480} loading="eager" />
  </div>
</section>
```

- [ ] **Step 2: `TrustBar.astro`**

```astro
---
interface Props { items: { label: string }[]; }
const { items } = Astro.props;
---
<div class="bg-brand-ice border-y border-brand-neutral-200">
  <ul class="max-w-6xl mx-auto px-4 py-4 flex flex-wrap justify-center gap-x-6 gap-y-2 text-sm font-medium text-brand-anchor">
    {items.map((it) => <li class="flex items-center gap-1.5"><span class="text-brand-primary">✓</span>{it.label}</li>)}
  </ul>
</div>
```

- [ ] **Step 3: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/Hero.astro web/src/components/sections/TrustBar.astro && git commit -m "feat(sections): Hero + TrustBar"
```

---

## Task 7: Section components — WhyPillars, BlueDiamond

**Files:**
- Create: `web/src/components/sections/WhyPillars.astro`, `web/src/components/sections/BlueDiamond.astro`

- [ ] **Step 1: `WhyPillars.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Pillar from '~/components/cards/Pillar.astro';
interface Props { heading: string; pillars: { icon: string; title: string; body: string }[]; }
const { heading, pillars } = Astro.props;
---
<Section tone="paper">
  <SectionHeading title={heading} align="center" />
  <div class="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
    {pillars.map((p) => <Pillar icon={p.icon} title={p.title} body={p.body} />)}
  </div>
</Section>
```

- [ ] **Step 2: `BlueDiamond.astro`** (⚠ guarantee copy comes from data, not hardcoded)

```astro
---
import Section from '~/components/ui/Section.astro';
import Button from '~/components/ui/Button.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  eyebrow: string; title: string; priceLabel: string; bullets: string[];
  image: { src?: string; alt: string; label?: string };
  cta: { label: string; href: string };
}
const { eyebrow, title, priceLabel, bullets, image, cta } = Astro.props;
---
<Section tone="ice">
  <div class="grid md:grid-cols-2 gap-8 items-center">
    <Image src={image.src} alt={image.alt} label={image.label} width={560} height={420} />
    <div>
      <span class="inline-flex items-center rounded-full bg-brand-accent/15 px-3 py-1 text-sm font-medium text-brand-primary-deep">{eyebrow}</span>
      <h2 class="mt-3 text-2xl md:text-3xl font-bold text-brand-anchor">{title}</h2>
      <p class="mt-2 text-lg font-semibold text-brand-primary-deep">{priceLabel}</p>
      <ul class="mt-4 grid gap-2 text-brand-neutral-700">
        {bullets.map((b) => <li class="flex gap-2"><span class="text-brand-primary">✓</span>{b}</li>)}
      </ul>
      <Button href={cta.href} class="mt-6">{cta.label}</Button>
    </div>
  </div>
</Section>
```

- [ ] **Step 3: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/WhyPillars.astro web/src/components/sections/BlueDiamond.astro && git commit -m "feat(sections): WhyPillars + BlueDiamond"
```

---

## Task 8: Section components — ServicesGrid, PartnerLogos

**Files:**
- Create: `web/src/components/sections/ServicesGrid.astro`, `web/src/components/sections/PartnerLogos.astro`

- [ ] **Step 1: `ServicesGrid.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import ServiceCard from '~/components/cards/ServiceCard.astro';
interface Props { heading: string; subtitle?: string; services: { title: string; summary: string; href: string; image: { src?: string; alt: string; label?: string } }[]; }
const { heading, subtitle, services } = Astro.props;
---
<Section>
  <SectionHeading title={heading} subtitle={subtitle} align="center" />
  <div class="mt-8 grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
    {services.map((s) => <ServiceCard title={s.title} summary={s.summary} href={s.href} image={s.image} />)}
  </div>
</Section>
```

- [ ] **Step 2: `PartnerLogos.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import Image from '~/components/ui/Image.astro';
interface Props { heading: string; partners: { name: string; logo: { src?: string; alt: string; label?: string } }[]; }
const { heading, partners } = Astro.props;
---
<Section tone="paper">
  <p class="text-center text-sm font-medium uppercase tracking-[0.15em] text-brand-neutral-500">{heading}</p>
  <div class="mt-6 grid grid-cols-3 sm:grid-cols-6 gap-4 items-center">
    {partners.map((p) => <Image src={p.logo.src} alt={p.logo.alt} label={p.logo.label} width={160} height={64} />)}
  </div>
</Section>
```

- [ ] **Step 3: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/ServicesGrid.astro web/src/components/sections/PartnerLogos.astro && git commit -m "feat(sections): ServicesGrid + PartnerLogos"
```

---

## Task 9: Section components — FoundersMastery, TeamRoster

**Files:**
- Create: `web/src/components/sections/FoundersMastery.astro`, `web/src/components/sections/TeamRoster.astro`

- [ ] **Step 1: `FoundersMastery.astro`** (MVP = side-by-side cards; LP cross-fade is a later polish pass)

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Image from '~/components/ui/Image.astro';
interface Props { heading: string; founders: { name: string; role: string; credentials: string[]; image: { src?: string; alt: string; label?: string } }[]; }
const { heading, founders } = Astro.props;
---
<Section tone="anchor">
  <SectionHeading title={heading} align="center" onDark />
  <div class="mt-8 grid gap-6 md:grid-cols-2">
    {founders.map((f) => (
      <div class="grid grid-cols-[120px_1fr] gap-4 rounded-lg bg-brand-neutral-0/5 p-4">
        <Image src={f.image.src} alt={f.image.alt} label={f.image.label} width={120} height={150} />
        <div>
          <h3 class="font-display font-bold text-brand-neutral-0">{f.name}</h3>
          <p class="text-sm text-brand-highlight">{f.role}</p>
          <ul class="mt-2 space-y-1 text-sm text-brand-neutral-200">
            {f.credentials.map((c) => <li>• {c}</li>)}
          </ul>
        </div>
      </div>
    ))}
  </div>
</Section>
```

- [ ] **Step 2: `TeamRoster.astro`** (renders full roster server-side; client script shows a random 4–6)

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import DoctorCard from '~/components/cards/DoctorCard.astro';
interface Props { heading: string; subtitle?: string; doctors: { name: string; role: string; image: { src?: string; alt: string; label?: string } }[]; }
const { heading, subtitle, doctors } = Astro.props;
---
<Section>
  <SectionHeading title={heading} subtitle={subtitle} align="center" />
  <div data-team class="mt-8 grid gap-4 grid-cols-2 sm:grid-cols-3 lg:grid-cols-6">
    {doctors.map((d) => (
      <div data-doc class="contents">
        <DoctorCard name={d.name} role={d.role} image={d.image} />
      </div>
    ))}
  </div>
</Section>
<script>
  // Show a random 4–6 of the roster; hide the rest. (go. is noindex → SEO-safe.)
  const wrap = document.querySelector('[data-team]');
  if (wrap) {
    const cards = Array.from(wrap.querySelectorAll('[data-doc]')) as HTMLElement[];
    for (let i = cards.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [cards[i], cards[j]] = [cards[j], cards[i]];
    }
    const show = Math.min(cards.length, 4 + Math.floor(Math.random() * 3)); // 4–6
    cards.forEach((c, idx) => {
      if (idx >= show) c.style.display = 'none';
      else wrap.appendChild(c); // reorder to shuffled order
    });
  }
</script>
```

> Note: `data-doc` uses `class="contents"` so the wrapper doesn't break the grid; toggling `display:none` removes it from layout. If `astro check` flags the `as HTMLElement[]` cast, it is inside a client `<script>` (plain TS) and is valid.

- [ ] **Step 3: Verify** — `npm run check` + `npm run build`. Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/FoundersMastery.astro web/src/components/sections/TeamRoster.astro && git commit -m "feat(sections): FoundersMastery + TeamRoster (random 4-6 shuffle)"
```

---

## Task 10: Section components — ProcessSteps, BeforeAfter

**Files:**
- Create: `web/src/components/sections/ProcessSteps.astro`, `web/src/components/sections/BeforeAfter.astro`

- [ ] **Step 1: `ProcessSteps.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Image from '~/components/ui/Image.astro';
interface Props { heading: string; steps: { step: number; title: string; body: string; image: { src?: string; alt: string; label?: string } }[]; }
const { heading, steps } = Astro.props;
---
<Section tone="ice">
  <SectionHeading title={heading} align="center" />
  <ol class="mt-8 grid gap-4 sm:grid-cols-3 lg:grid-cols-5">
    {steps.map((s) => (
      <li class="rounded-lg bg-brand-neutral-0 border border-brand-neutral-200 p-4">
        <Image src={s.image.src} alt={s.image.alt} label={s.image.label} width={200} height={140} rounded={false} />
        <p class="mt-2 text-xs font-bold text-brand-primary-deep">STEP {s.step}</p>
        <h3 class="font-semibold text-brand-anchor">{s.title}</h3>
        <p class="text-sm text-brand-neutral-700">{s.body}</p>
      </li>
    ))}
  </ol>
</Section>
```

- [ ] **Step 2: `BeforeAfter.astro`** (MVP = simple grid; lightbox lifted from LP in a later polish pass. ⚠ compliance: shown only when `enabled`)

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  heading: string;
  enabled?: boolean; // compliance gate (spec §10)
  items: { before: { src?: string; alt: string; label?: string }; after: { src?: string; alt: string; label?: string }; caption: string }[];
}
const { heading, enabled = true, items } = Astro.props;
---
{enabled && (
  <Section>
    <SectionHeading title={heading} align="center" />
    <div class="mt-8 grid gap-4 sm:grid-cols-3">
      {items.map((it) => (
        <figure class="rounded-lg border border-brand-neutral-200 overflow-hidden">
          <div class="grid grid-cols-2">
            <Image src={it.before.src} alt={it.before.alt} label={it.before.label} width={200} height={200} rounded={false} />
            <Image src={it.after.src} alt={it.after.alt} label={it.after.label} width={200} height={200} rounded={false} />
          </div>
          <figcaption class="p-2 text-xs text-brand-neutral-500 text-center">{it.caption}</figcaption>
        </figure>
      ))}
    </div>
  </Section>
)}
```

- [ ] **Step 3: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add web/src/components/sections/ProcessSteps.astro web/src/components/sections/BeforeAfter.astro && git commit -m "feat(sections): ProcessSteps + BeforeAfter (compliance-gated)"
```

---

## Task 11: Section components — Reviews, Branches, FinalCta

**Files:**
- Create: `web/src/components/sections/Reviews.astro`, `Branches.astro`, `FinalCta.astro`

- [ ] **Step 1: `Reviews.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import ReviewCard from '~/components/cards/ReviewCard.astro';
import Image from '~/components/ui/Image.astro';
interface Props {
  heading: string;
  reviews: { quote: string; name: string; stars: number }[];
  video: { poster: { src?: string; alt: string; label?: string }; src?: string; label: string };
}
const { heading, reviews, video } = Astro.props;
---
<Section tone="paper">
  <SectionHeading title={heading} align="center" />
  <div class="mt-8 grid gap-6 lg:grid-cols-3">
    <div class="lg:col-span-2 grid gap-4 sm:grid-cols-2">
      {reviews.map((r) => <ReviewCard quote={r.quote} name={r.name} stars={r.stars} />)}
    </div>
    <div class="max-w-[280px] mx-auto w-full">
      <Image src={video.poster.src} alt={video.poster.alt} label={video.poster.label} width={280} height={280} />
      <p class="mt-2 text-center text-sm text-brand-neutral-500">{video.label}</p>
    </div>
  </div>
</Section>
```

> Note: real square video (`<video preload="none" poster>`) is lifted from `lp/dental-implant.astro` in the post-image polish pass; MVP shows the poster placeholder.

- [ ] **Step 2: `Branches.astro`**

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
import BranchCard from '~/components/cards/BranchCard.astro';
interface Props { heading: string; branches: { name: string; mrt: string; address: string; mapUrl: string }[]; }
const { heading, branches } = Astro.props;
---
<Section>
  <SectionHeading title={heading} align="center" />
  <div class="mt-8 grid gap-4 sm:grid-cols-2">
    {branches.map((b) => <BranchCard name={b.name} mrt={b.mrt} address={b.address} mapUrl={b.mapUrl} />)}
  </div>
</Section>
```

- [ ] **Step 3: `FinalCta.astro`**

```astro
---
import Button from '~/components/ui/Button.astro';
interface Props { title: string; body: string; cta: { label: string; href: string }; }
const { title, body, cta } = Astro.props;
---
<section class="bg-brand-primary-deep text-brand-neutral-0">
  <div class="max-w-6xl mx-auto px-4 py-14 text-center">
    <h2 class="text-2xl md:text-3xl font-bold">{title}</h2>
    <p class="mt-2 text-brand-neutral-100">{body}</p>
    <Button href={cta.href} class="mt-6 !bg-brand-neutral-0 !text-brand-primary-deep hover:!bg-brand-ice">{cta.label}</Button>
  </div>
</section>
```

- [ ] **Step 4: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 5: Commit**

```bash
git add web/src/components/sections/Reviews.astro web/src/components/sections/Branches.astro web/src/components/sections/FinalCta.astro && git commit -m "feat(sections): Reviews + Branches + FinalCta"
```

---

## Task 12: `forms/BookingForm.astro` (n8n + PDPA + lead_submit)

**Files:**
- Create: `web/src/components/forms/BookingForm.astro`

- [ ] **Step 1: Create the component** (posts to the LP's n8n webhook; pushes `lead_submit` on success)

```astro
---
import Section from '~/components/ui/Section.astro';
import SectionHeading from '~/components/ui/SectionHeading.astro';
interface Props { heading: string; subtitle?: string; }
const { heading, subtitle } = Astro.props;
const WEBHOOK = 'https://nexorcus.app.n8n.cloud/webhook/smilescape-website-lead-form';
---
<Section id="booking" tone="ice">
  <SectionHeading title={heading} subtitle={subtitle} align="center" />
  <form id="ss-booking" class="mt-8 max-w-xl mx-auto grid gap-4" data-webhook={WEBHOOK} novalidate>
    <div class="grid sm:grid-cols-2 gap-4">
      <input name="name" required placeholder="ชื่อ-นามสกุล" class="rounded-lg border border-brand-neutral-300 px-4 py-3" />
      <input name="phone" required inputmode="tel" placeholder="เบอร์โทร" class="rounded-lg border border-brand-neutral-300 px-4 py-3" />
    </div>
    <select name="service" class="rounded-lg border border-brand-neutral-300 px-4 py-3">
      <option value="">เลือกบริการที่สนใจ</option>
      <option>รากฟันเทียม</option><option>All-on-X</option><option>จัดฟัน/จัดฟันใส</option>
      <option>วีเนียร์ / Smile Design</option><option>ทันตกรรมทั่วไป</option><option>อื่น ๆ</option>
    </select>
    <select name="branch" class="rounded-lg border border-brand-neutral-300 px-4 py-3">
      <option value="">เลือกสาขา</option><option>รัตนาธิเบศร์</option><option>ศรีนครินทร์</option>
    </select>
    <label class="flex items-start gap-2 text-sm text-brand-neutral-700">
      <input type="checkbox" name="pdpa" required class="mt-1" />
      ยินยอมให้คลินิกติดต่อกลับและเก็บข้อมูลตามนโยบาย PDPA
    </label>
    <button type="submit" class="rounded-full bg-brand-primary px-6 py-3 font-semibold text-brand-neutral-0 hover:bg-brand-primary-deep">ยืนยันการนัดหมาย</button>
    <p data-msg role="status" class="text-center text-sm"></p>
  </form>
</Section>
<script>
  const form = document.getElementById('ss-booking') as HTMLFormElement | null;
  if (form) {
    const msg = form.querySelector('[data-msg]') as HTMLElement;
    form.addEventListener('submit', async (e) => {
      e.preventDefault();
      if (!form.checkValidity()) { form.reportValidity(); return; }
      const data = Object.fromEntries(new FormData(form).entries());
      msg.textContent = 'กำลังส่ง…';
      try {
        await fetch(form.dataset.webhook!, {
          method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify(data),
        });
        (window as any).dataLayer = (window as any).dataLayer || [];
        (window as any).dataLayer.push({ event: 'lead_submit', form: 'homepage_booking' });
        form.reset();
        msg.textContent = 'ส่งคำขอนัดหมายเรียบร้อย เราจะติดต่อกลับโดยเร็ว ✓';
      } catch {
        msg.textContent = 'ส่งไม่สำเร็จ กรุณาโทร 092 293 6226 หรือทักไลน์';
      }
    });
  }
</script>
```

- [ ] **Step 2: Verify** — `npm run check` + `npm run build`. Expected: 0 errors.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/forms/BookingForm.astro && git commit -m "feat(forms): BookingForm → n8n + PDPA + lead_submit"
```

---

## Task 13: `sections/StickyCta.astro` (lift from Landing.astro)

**Files:**
- Create: `web/src/components/sections/StickyCta.astro`

- [ ] **Step 1: Create the component** — copy the sticky-CTA markup + `<style>` + reveal `<script>` from `web/src/layouts/Landing.astro:112-164` (the `#ssf-sticky-cta` block, its `<style>`, and the IntersectionObserver reveal script). Drop the `line_click`/`call_click` listener from that script — it now lives globally in `Base.astro` (Task 14). Parameterise phone/LINE via props:

```astro
---
interface Props { phoneTel: string; phoneDisplay: string; lineUrl: string; }
const { phoneTel, phoneDisplay, lineUrl } = Astro.props;
---
<div id="ssf-sticky-cta" class="ssf-cta md:hidden fixed bottom-0 inset-x-0 z-50 bg-white border-t border-brand-neutral-200 grid grid-cols-2 gap-2 p-2 shadow-[0_-4px_20px_rgba(20,56,107,0.14)]">
  <a href={`tel:${phoneTel}`} class="flex items-center justify-center gap-2 rounded-full border border-brand-primary py-3 font-semibold text-brand-primary-deep">
    <svg class="phone-ring" width="18" height="18" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M6.62 10.79a15.5 15.5 0 0 0 6.59 6.59l2.2-2.2a1 1 0 0 1 1.02-.24c1.12.37 2.33.57 3.57.57a1 1 0 0 1 1 1V20a1 1 0 0 1-1 1A17 17 0 0 1 3 4a1 1 0 0 1 1-1h3.5a1 1 0 0 1 1 1c0 1.24.2 2.45.57 3.57a1 1 0 0 1-.24 1.02l-2.2 2.2z"/></svg>
    โทรเลย {phoneDisplay}
  </a>
  <a href={lineUrl} class="ssf-line flex items-center justify-center gap-2 rounded-full py-3 font-semibold text-white">
    <svg width="20" height="20" viewBox="0 0 24 24" fill="currentColor" aria-hidden="true"><path d="M12 2C6.48 2 2 5.64 2 10.13c0 4.02 3.55 7.39 8.35 8.02.33.07.77.22.88.5.1.26.07.66.03.92l-.14.85c-.04.26-.2 1.02.89.56s5.86-3.45 8-5.9c1.48-1.63 2.19-3.28 2.19-5.95C22.2 5.64 17.72 2 12 2z"/></svg>
    จองคิวผ่าน LINE
  </a>
</div>
<style>
  .ssf-cta{ transform:translateY(115%); opacity:0; pointer-events:none; transition:transform .34s cubic-bezier(.16,1,.3,1), opacity .34s ease; }
  .ssf-cta.cta-visible{ transform:translateY(0); opacity:1; pointer-events:auto; }
  @keyframes ssf-ring{ 0%,55%,100%{transform:rotate(0)} 58%,66%,74%{transform:rotate(16deg)} 62%,70%,78%{transform:rotate(-16deg)} 82%{transform:rotate(0)} }
  .phone-ring{ display:inline-block; transform-origin:50% 65%; animation:ssf-ring 2s ease-in-out infinite; }
  .ssf-line{ background:#06C755; animation:ssf-line-pulse 1.8s ease-in-out infinite; }
  .ssf-line:hover{ filter:brightness(1.06) }
  @keyframes ssf-line-pulse{ 0%,100%{box-shadow:0 0 0 0 rgba(6,199,85,0)} 50%{box-shadow:0 0 0 7px rgba(6,199,85,.20)} }
  @media (prefers-reduced-motion: reduce){ .phone-ring,.ssf-line{animation:none} .ssf-cta{transition:none} }
</style>
<script>
  const cta = document.getElementById('ssf-sticky-cta');
  const hero = document.querySelector('[data-hero]');
  if (cta) {
    if (hero && 'IntersectionObserver' in window) {
      new IntersectionObserver((entries) => {
        cta.classList.toggle('cta-visible', !entries[0].isIntersecting);
      }, { threshold: 0 }).observe(hero);
    } else { cta.classList.add('cta-visible'); }
  }
</script>
```

> The `#06C755` LINE green and ring shadows are an exact lift of the live brand CTA styling (matches `Landing.astro`); keep as-is for brand parity.

- [ ] **Step 2: Verify** — `npm run check`. Expected: 0 errors.

- [ ] **Step 3: Commit**

```bash
git add web/src/components/sections/StickyCta.astro && git commit -m "feat(sections): StickyCta (lifted from Landing)"
```

---

## Task 14: Upgrade `Base.astro` into the full-site shell

**Files:**
- Modify: `web/src/lib/analytics.ts`
- Modify: `web/src/layouts/Base.astro:17-27` (Props + destructure), `:71-88` (nav), `:122-123` (body/AnalyticsBody), add StickyCta + robots meta + global tracking.

- [ ] **Step 1: Activate GTM by defaulting the container id**

Edit `web/src/lib/analytics.ts` line 5:

```ts
export const GTM_ID = import.meta.env.PUBLIC_GTM_ID ?? 'GTM-NFBVZT43';
```

(GTM id is not secret; this activates `AnalyticsHead`/`AnalyticsBody` site-wide via `Base.astro`. Local override still possible via `.env`.)

- [ ] **Step 2: Add `robots` + `stickyCta` props.** In `Base.astro`, extend the `Props` interface and destructure:

```ts
interface Props {
  title: string;
  description?: string;
  canonical?: string;
  ogType?: string;
  jsonLd?: Record<string, unknown> | Record<string, unknown>[];
  robots?: string;        // NEW — go. policy default
  stickyCta?: boolean;    // NEW
}
const { title, description, canonical, ogType = 'website', jsonLd, robots = 'noindex,follow', stickyCta = false } = Astro.props;
```

- [ ] **Step 3: Emit the robots meta.** After the `<link rel="canonical" ...>` line in `<head>`:

```astro
<meta name="robots" content={robots} />
```

- [ ] **Step 4: Trim the nav** to existing destinations only. Replace the `nav` arrays:

```ts
const nav =
  lang === 'en'
    ? [
        { href: '/en/lp/dental-implant/', label: 'Dental Implants' },
        { href: '/en/#booking', label: 'Book Now', cta: true },
      ]
    : [
        { href: '/lp/dental-implant/', label: 'รากฟันเทียม' },
        { href: '/#booking', label: 'จองคิว', cta: true },
      ];
```

- [ ] **Step 5: Add the global tracking listener + StickyCta import.** In the frontmatter add the contact constants:

```ts
import StickyCta from '~/components/sections/StickyCta.astro';
const PHONE_TEL = '+66922936226';
const PHONE_DISPLAY = '092 293 6226';
const LINE_URL = 'https://maac.io/6yp2p';
```

Before `</body>` (after the footer), add:

```astro
{stickyCta && <StickyCta phoneTel={PHONE_TEL} phoneDisplay={PHONE_DISPLAY} lineUrl={LINE_URL} />}
<script>
  // Global conversion listeners (set GTM triggers: line_click / call_click)
  document.addEventListener('click', (e) => {
    const a = (e.target as HTMLElement).closest('a');
    if (!a) return;
    const href = a.getAttribute('href') || '';
    const dl = ((window as any).dataLayer = (window as any).dataLayer || []);
    if (href.includes('maac.io') || href.includes('lin.ee') || href.includes('line.me')) dl.push({ event: 'line_click', link_url: href });
    else if (href.startsWith('tel:')) dl.push({ event: 'call_click', link_url: href });
  });
</script>
```

- [ ] **Step 6: Verify** — `npm run check` + `npm run build`. Expected: 0 errors. Confirm `privacy-policy.astro` (which uses Base) still builds.

- [ ] **Step 7: Commit**

```bash
git add web/src/lib/analytics.ts web/src/layouts/Base.astro && git commit -m "feat(shell): Base.astro full-site shell — GTM, robots, nav trim, tracking, sticky CTA"
```

---

## Task 15: Compose TH homepage (`index.astro`)

**Files:**
- Modify (replace contents): `web/src/pages/index.astro`

- [ ] **Step 1: Replace `index.astro`** with pure composition

```astro
---
import Base from '~/layouts/Base.astro';
import { getHome } from '~/lib/home';
import Hero from '~/components/sections/Hero.astro';
import TrustBar from '~/components/sections/TrustBar.astro';
import WhyPillars from '~/components/sections/WhyPillars.astro';
import BlueDiamond from '~/components/sections/BlueDiamond.astro';
import ServicesGrid from '~/components/sections/ServicesGrid.astro';
import PartnerLogos from '~/components/sections/PartnerLogos.astro';
import FoundersMastery from '~/components/sections/FoundersMastery.astro';
import TeamRoster from '~/components/sections/TeamRoster.astro';
import ProcessSteps from '~/components/sections/ProcessSteps.astro';
import BeforeAfter from '~/components/sections/BeforeAfter.astro';
import Reviews from '~/components/sections/Reviews.astro';
import Branches from '~/components/sections/Branches.astro';
import FaqBlock from '~/components/FaqBlock.astro';
import BookingForm from '~/components/forms/BookingForm.astro';
import FinalCta from '~/components/sections/FinalCta.astro';

const h = await getHome('th');
// FAQPage JSON-LD is emitted by <FaqBlock> below — do NOT duplicate it here.
---
<Base title={h.meta.title} description={h.meta.description} stickyCta>
  <Hero {...h.hero} />
  <TrustBar items={h.trustBar} />
  <WhyPillars heading="ทำไมต้อง SmileScape" pillars={h.pillars} />
  <BlueDiamond {...h.blueDiamond} />
  <ServicesGrid heading="บริการทันตกรรมครบวงจร" services={h.services} />
  <PartnerLogos heading="พันธมิตรแบรนด์ระดับโลก" partners={h.partners} />
  <FoundersMastery heading="The Global Mastery — ทีมผู้ก่อตั้ง" founders={h.founders} />
  <TeamRoster heading="ทีมทันตแพทย์ของเรา" doctors={h.doctors} />
  <ProcessSteps heading="ขั้นตอนการรักษา" steps={h.process} />
  <BeforeAfter heading="ผลลัพธ์ก่อน-หลัง" items={h.beforeAfter} />
  <Reviews heading="เสียงจากคนไข้" reviews={h.reviews} video={h.video} />
  <Branches heading="สาขาของเรา" branches={h.branches} />
  <div class="max-w-6xl mx-auto px-4"><FaqBlock items={h.faq} /></div>
  <BookingForm heading="นัดหมาย & ปรึกษาทันตแพทย์ฟรี" subtitle="กรอกข้อมูลเพื่อให้เราติดต่อกลับ" />
  <FinalCta {...h.finalCta} />
</Base>
```

- [ ] **Step 2: Verify** — `npm run check` + `npm run build` + `npm run preview` → open `http://localhost:4321/`. Confirm: all 15 sections render top-to-bottom, placeholders sized (no layout shift), sticky CTA appears after scrolling past hero (resize to mobile width), TeamRoster shows 4–6 and reshuffles on reload.

- [ ] **Step 3: Commit**

```bash
git add web/src/pages/index.astro && git commit -m "feat(home): compose TH homepage from components"
```

---

## Task 16: Compose EN homepage (`en/index.astro`)

**Files:**
- Modify (replace contents): `web/src/pages/en/index.astro`

- [ ] **Step 1: Replace `en/index.astro`** — identical to Task 15 but `getHome('en')` and EN section headings

```astro
---
import Base from '~/layouts/Base.astro';
import { getHome } from '~/lib/home';
import Hero from '~/components/sections/Hero.astro';
import TrustBar from '~/components/sections/TrustBar.astro';
import WhyPillars from '~/components/sections/WhyPillars.astro';
import BlueDiamond from '~/components/sections/BlueDiamond.astro';
import ServicesGrid from '~/components/sections/ServicesGrid.astro';
import PartnerLogos from '~/components/sections/PartnerLogos.astro';
import FoundersMastery from '~/components/sections/FoundersMastery.astro';
import TeamRoster from '~/components/sections/TeamRoster.astro';
import ProcessSteps from '~/components/sections/ProcessSteps.astro';
import BeforeAfter from '~/components/sections/BeforeAfter.astro';
import Reviews from '~/components/sections/Reviews.astro';
import Branches from '~/components/sections/Branches.astro';
import FaqBlock from '~/components/FaqBlock.astro';
import BookingForm from '~/components/forms/BookingForm.astro';
import FinalCta from '~/components/sections/FinalCta.astro';

const h = await getHome('en');
// FAQPage JSON-LD is emitted by <FaqBlock> below — do NOT duplicate it here.
---
<Base title={h.meta.title} description={h.meta.description} stickyCta>
  <Hero {...h.hero} />
  <TrustBar items={h.trustBar} />
  <WhyPillars heading="Why SmileScape" pillars={h.pillars} />
  <BlueDiamond {...h.blueDiamond} />
  <ServicesGrid heading="Comprehensive dental services" services={h.services} />
  <PartnerLogos heading="We work with global brands" partners={h.partners} />
  <FoundersMastery heading="The Global Mastery — Founders" founders={h.founders} />
  <TeamRoster heading="Our dental team" doctors={h.doctors} />
  <ProcessSteps heading="Treatment process" steps={h.process} />
  <BeforeAfter heading="Before & after" items={h.beforeAfter} />
  <Reviews heading="Patient voices" reviews={h.reviews} video={h.video} />
  <Branches heading="Our branches" branches={h.branches} />
  <div class="max-w-6xl mx-auto px-4"><FaqBlock items={h.faq} heading="FAQ" /></div>
  <BookingForm heading="Book a free consultation" subtitle="Leave your details and we'll call you back" />
  <FinalCta {...h.finalCta} />
</Base>
```

- [ ] **Step 2: Verify** — `npm run check` + `npm run build` + `npm run preview` → open `http://localhost:4321/en/`. Confirm EN content renders + hreflang `<link rel="alternate" hreflang="en">` points to `/en/`.

- [ ] **Step 3: Commit**

```bash
git add web/src/pages/en/index.astro && git commit -m "feat(home): compose EN homepage"
```

---

## Task 17: Full verification + deploy

**Files:** none (verification only)

- [ ] **Step 1: Clean build**

Run: `cd web && npm run check && npm run build`
Expected: 0 errors; `dist/index.html` and `dist/en/index.html` emitted.

- [ ] **Step 2: Preview assertions**

Run: `cd web && npm run preview` → browse `http://localhost:4321/` and `/en/`. Confirm in DevTools:
- `<meta name="robots" content="noindex,follow">` present on both.
- GTM script (`gtm.js?id=GTM-NFBVZT43`) loads (Network tab); clicking a `tel:`/LINE link pushes `call_click`/`line_click` to `window.dataLayer` (Console: `dataLayer`).
- Submitting the booking form pushes `lead_submit` (use a test entry; expect the success message).
- `<link rel="alternate" hreflang="th"|"en"|"x-default">` correct; FAQPage + Dentist JSON-LD present (`document.querySelectorAll('script[type="application/ld+json"]')`).
- No console errors; placeholders reserve space (no CLS) at 360 / 768 / 1280 widths.

- [ ] **Step 3: Deploy**

Run: `cd web && npx wrangler deploy`
Expected: deploy succeeds. Smoke-test `https://go.smilescapeclinic.com/` and `https://go.smilescapeclinic.com/en/` — homepage renders, robots=noindex, LP link works, form present.

- [ ] **Step 4: Record conventions to memory (spec §15)**

Append to `~/.claude/projects/-Volumes-SSD-NN-CLAUDE-AI-repos-brands-eywa-smile-scape/memory/MEMORY.md` a short note: the homepage component library structure (`ui/cards/sections/forms` + `home` data collection + `Image.astro` swap seam + `getHome(locale)`) is the **first full EYWA Astro component library** and is brand-agnostic — reusable by other brands by swapping tokens + content. Flag the pattern for promotion to the EYWA Content_Templates spec.

- [ ] **Step 5: Final commit (if any uncommitted verification tweaks)**

```bash
git add -A web/ && git commit -m "chore(home): verification fixes + deploy homepage MVP" || echo "nothing to commit"
```

---

## Follow-ups (out of scope — tracked for later)

- Swap placeholders → real images by setting `src` in `home/{th,en}.yaml` (Session A / Cloudflare).
- Polish pass: lift LP's before/after **lightbox**, founder **cross-fade**, and square **video** (`<video preload="none" poster>`) into the respective section components.
- Build the T1–T22 page-type templates reusing this component library (deliverable 2).
- Replace `getHome` with Supabase-hydrated data (Session B).
- Healthcare-marketing-compliance review of guarantee copy + before/after before ad spend / apex cutover.
- Fill NAP / per-branch phone / GBP Place IDs / real doctor roster / partner logos.
- **Wire founders/team to `web/src/data/doctors.json`** (canonical CV-sourced source-of-truth; currently only the 2 founders exist there) instead of duplicating in `home/*.yaml`. Founder names corrected to canonical this session (Worapat **Jarangkul**; Dr. Praew = Oral & Maxillofacial Surgeon, not "TBD"). When real specialist CVs land, add them to doctors.json → TeamRoster picks them up.
