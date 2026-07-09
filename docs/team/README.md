# Team — Doctor Profiles

Structured, verbatim extraction of the two founders' official CVs, for use in team pages, About page, `schema.org/Physician` markup, and author / E-E-A-T bylines.

## Doctors

### Founders (Co-CEOs) — data complete

| Nickname | Full name | Role | Profile | Pages on CV |
|---|---|---|---|---|
| **หมอแฮม** / Dr. Ham | ทพ. วรภัทร จรางกุล · Dr. Worapat Jarangkul, D.D.S., M.Sc. | Co-CEO / Medical Director & Lead Implantologist | [dr-worapat-jarangkul.md](dr-worapat-jarangkul.md) | EN 02/04/06/14 · TH 07/08/09/13 |
| **หมอแพรว** / Dr. Praew | ทพญ. พิชชาภา ผุดผ่อง · Dr. Pitchapa Phudphong, D.D.S. | Co-CEO / Co-Founder | [dr-pitchapa-phudphong.md](dr-pitchapa-phudphong.md) | EN 01/03/05 · TH 10/11/12 |

> **SEO entities (2026-07-09):** both founders are registered `Person`/`Physician` entities in `content-plan/entities.md` and loaded to Supabase (`seo_entity_graph` + `seo_authors_reviewers` + `seo_doctor_assignments`) — slugs `dr-woraphat-jarangkul` (หมอแฮม) · `dr-pitchapa-phudphong` (หมอแพรว). Board certification: หมอแพรว holds the *Thai Board of Oral & Maxillofacial Surgery Diploma (2023)*; หมอแฮม has **no board diploma** (verified against CV — D.D.S. gold medal + dual M.Sc. + OMS Certificate Chula 2018 → `board_certifications=[]`). Still pending per doctor: `medical_license_number` (skip — not blocking) · `photo_url` (to follow).

### Team dentists — ⏳ pending

The rest of the dental team will be supplied later (CVs / bios to follow). When they arrive, add each one using the pattern below.

## Adding a new doctor

1. Create `docs/team/dr-<name>.md` (copy an existing profile as the template — same bilingual sections).
2. Append an object to the `doctors` array in [`../../web/src/data/doctors.json`](../../web/src/data/doctors.json), reusing the same field names. Founders carry `position: "Co-CEO …"`; team dentists should use their specialty (e.g. `"Orthodontist"`, `"Endodontist"`) and `schema_org_type: "Physician"` / `"Dentist"`.
3. Add a row to the **Team dentists** table above.
4. If the doctor is also an SEO entity, register them in `content-plan/entities.md` (Person / Physician) and keep the `slug` identical across both files.

## Files

- **`dr-worapat-jarangkul.md`**, **`dr-pitchapa-phudphong.md`** — human-readable bilingual reference (full detail).
- **`../../web/src/data/doctors.json`** — machine-readable, build-ready. Import directly in Astro:
  ```ts
  import doctors from '../data/doctors.json';
  ```
  Mirrors these markdown files. Keep the two in sync if either changes.

## Provenance

- **Source:** `docs/CV Dr/CV docter3 [Recovered]-01..14.jpg` — 14 bilingual CV pages (a designed two-doctor CV; each doctor has an English set and a Thai set).
- **Extracted:** 2026-06-07 (read directly from the images).
- **Years:** Thai pages use the Buddhist era (พ.ศ./BE); English pages use CE. The `*_en` lists in the JSON use CE (BE = CE + 543).

## ⚠️ Open items — confirm with the doctors before publishing

1. **Name spelling — Worapat vs Woraphat.** The CV English reads **"Worapat Jarangkul"**. The existing SEO entity registry (`content-plan/entities.md` #2) and `brand-config.json` use the slug **`dr-woraphat-jarangkul`** (Woraphat). Display name follows the CV; the slug is kept for URL/entity continuity. Decide which English spelling is canonical for the public site.

2. **Dr. Praew — 3 unverified training items.** Her Thai education page (CV image 10) lists three items absent from her English page (image 05) that also appear on Dr. Ham's CV: *Tachakorn Regeneration Course*, *FMR & TMD: Beyond the Teeth*, *International Full Arch Summit 2026*. Likely a copy-paste artifact in the design file. The English list is treated as authoritative. → captured as `education_th_only_extras_unverified` in the JSON.

3. **Personal contact ≠ clinic NAP.** Phone / email / address on each CV are the doctors' **personal** details (gmail addresses, home/condo addresses). They are **not** the clinic's published contact. Clinic NAP lives in `brand-config.json` + `content-plan/branches.md` (สาขารัตนาธิเบศร์ / สาขาศรีนครินทร์). Do not surface personal details publicly without consent.

4. **brand-config.json founders block is now fillable.** `brand-config.json → founders.co_founder` (Dr. Praew) still reads `specialty: "TBD"` with a note "update เมื่อได้ข้อมูลเพิ่ม". That data now exists here — update when ready (left unchanged in this pass to avoid altering the brand config without sign-off).

## Cross-references

- `content-plan/entities.md` — entity #2 (Dr. Woraphat Jarangkul), #8 (Zero Bone Loss Concept).
- `brand-config.json` — `founders` block.
- Dr. Praew's *Zero Bone Loss Concepts Protocol (2025)* training supports the brand's ZBL / Linkevicius E-E-A-T anchor.
