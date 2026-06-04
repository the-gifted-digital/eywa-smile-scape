# SmileScape Brand Repo — Changelog

## [2026-06-05] — Round 23 Section 4 Technology Review (entity fix + tech↔service consistency)

**By:** Operator deep review of Section 4 Technology (44 pages), with a second-pass focus on consistency with the (just-reordered) Section 3 services.

**Verdict:** Section 4 well-structured; brand/device pages (Densah 4.4.4, Airflow 4.4.5, aligner cluster 4.6) already follow the DR-002 service↔tech pattern and their cross-links resolved correctly to the new Section 3 numbers after the R22 reorder. Two entity errors + incomplete tech→service back-links found.

**Entity fixes:**
- **4.5.4 Ceramic (Zirconia) Implant System:** `titanium-implant` → `ceramic-implant` (was mis-tagged as titanium; now aligns with service 3.2.8.11 รากฟันเทียมเซรามิก)
- **4.5.7 Connection Types:** `dental-crown` → `dental-implant` (about implant-abutment connection, not crown)
- (left as-is: 4.4.1 Piezoelectric / 4.4.3 Microscope use `surgical-guide` as the surgical-tech umbrella — acceptable, noted)

**Consistency fix — completed DR-002 tech→service back-links** (these clusters had service→tech but were missing the reverse):
- 4.2 Diagnostic Tech → 3.1 Precision Diagnostics
- 4.3 Implant Planning → 3.1.4 / 3.2.5
- 4.5 Implant Systems → 3.2.11.6 เปรียบเทียบแบรนด์
- **4.7 Prosthetic Tech → 3.5 Restorative & Prosthetic** (the DR-002 link explicitly deferred in R18, now that §3.5 exists)
- 4.7.3 Hybrid Prosthesis → 3.3 All-on-X
- 4.9.1 Cool Light Whitening Unit → 3.9.3.1 Cool Light Whitening (service)

**Files:** `sitemap.md` (Section 4 entities + cross-links + header + R23 note) / `changelog.md` / `README.md`

**Net 0 pages** → Sitemap **728** / Entities **166** (unchanged). Section 4 review complete.

---

## [2026-06-05] — Round 22 Section 3 Category Reorder + Numbering Cleanup + 3.8 Entity Fix

**By:** Operator review — Section 3 top-level category ORDER was not logical (Restorative §3.14 stranded at the end after Demographic; Endodontics among access sections) + several internal numbering gaps from prior consolidations.

**Scope:** scripted migration (Python, two-pass-safe via per-match callback) — ~150 references renumbered across `sitemap.md` + `entities.md` Primary Page column. Page-neutral (728); reorder + renumber only (content placement unchanged). Historical round-notes / changelog FROZEN (reference numbering as-of-their-round).

**1. Top-level category reorder (14 categories, logical grouping):**
| New | Category | Was |
|---|---|---|
| 3.1 | Precision Diagnostics | 3.1 |
| 3.2 | Implant Mastery (hero) | 3.2 |
| 3.3 | All-on-X Full Arch (hero) | 3.3 |
| 3.4 | General Dentistry | 3.6 |
| 3.5 | Restorative & Prosthetic | 3.14 |
| 3.6 | Endodontics | 3.11 |
| 3.7 | Periodontics | 3.7 |
| 3.8 | Oral Surgery | 3.8 |
| 3.9 | Cosmetic Dentistry | 3.4 |
| 3.10 | Orthodontics | 3.5 |
| 3.11 | Pediatric | 3.9 |
| 3.12 | Sedation & GA | 3.10 |
| 3.13 | Demographic-Specific | 3.13 |
| 3.14 | SSO / Q-Clinic | 3.12 |

Logic: Diagnose → Implant hero → core restore/save-tooth (General/Restorative/Endo/Perio/Surgery) → aesthetic (Cosmetic/Ortho) → population (Pediatric/Sedation/Demographic) → access (SSO). Restorative moved out of the tail into the core group.

**2. Numbering gap-close (within-section, no content move):**
- Cosmetic (now 3.9): closed 3.4.3 gap — whitening cluster → 3.9.3(+subs), gum 3.9.4, makeover 3.9.5, price 3.9.6
- SSO (now 3.14): closed 3.12.1/3.12.4 gaps → 3.14.1/3.14.2(+subs)/3.14.3
- Demographic 3.13.1: closed 3.13.1.1/.2 gaps (R9/R10 removals) → 3.13.1.1-.4 ; 3.13.2.2 → 3.13.2.1

**3. R22 entity fix (3.8 Oral Surgery) + 2 new entities:**
- 3.8.2 Oral Pathology + 3.8.3 Cyst: `tooth-extraction` → **`oral-pathology`** (#166, new)
- 3.8.4 Frenectomy: `tooth-extraction` → **`frenectomy`** (#165, new — has search "ตัดเอ็นยึดลิ้น")
- entity type distribution: Procedure 50→52, Total **164→166**

**4. Cross-links added:** 3.8.1 Complex Impaction ↔ 3.4.4 (wisdom routine) / 3.7.4 Gum Recession ↔ 3.2.9.7.3 Root Coverage / 3.1.5 DSD → canonical 3.9.1 / 3.13.1.2 denture → +3.5.4

**Verification:** no duplicate page IDs; 728 numbered rows; Section 3 sub-blocks physically reordered to numeric sequence; cross-links resolve to new numbers (spot-checked 5.10.9→3.10.1.1, 4.6.1→3.10.1.2, 3.2.11.1→3.5.2); percentages (3.3%/3.7%) preserved; top round-note block untouched.

**Note:** sitemap numbers are internal IDs (final URLs derive from slugs). Some inline historical breadcrumbs ("เดิม X") now show new numbers — changelog is authoritative for history.

**Net 0 pages** → Sitemap **728** / Entities **166**

---

## [2026-06-05] — Round 21 DFS-Driven: Veneer Sub-Hub + All-on-X Jaw Consolidation

**By:** Operator authorized live DataForSEO queries to resolve the R19-R20 flags instead of deferring to Stage 1 Gate.

**DFS data (TH, Google Ads volume + Labs intent):**
- `veneer` **2,400/mo LOW** (CPC 1.57) / `composite veneer` **590/mo LOW** / `วีเนียร์` informational / `วีเนียร์ ราคา` commercial
- `all-on-x` 70/mo LOW / `all-on-6` 90/mo LOW / `all on 4` informational + `all on 4 ราคา` commercial / `all-on-4 บน/ล่าง` **no data**
- Note: DFS TH dataset returned null volume for several head terms (วีเนียร์, porcelain veneer, all-on-4, ครอบฟัน) — known limitation; anchors + intent signals were sufficient to decide.

**Decisions & changes (sitemap, net +2 → 728):**
1. **Veneer expansion (3.4) — DONE.** veneer 2,400/mo LOW is the biggest cosmetic keyword found; 3.4 had only 2 sibling pages + no hub. Built **veneer sub-hub 3.4.2** (วีเนียร์ hub Tier B) → 3.4.2.1 Porcelain / 3.4.2.2 Composite / **3.4.2.3 วีเนียร์ ราคา** (commercial) / **3.4.2.4 วีเนียร์ vs ครอบฟัน** (→3.14.1). +3 pages. Number 3.4.3 left as intentional skip (note added; avoids re-renumbering whitening cluster from R19).
2. **All-on-4 jaw split (3.3.4/.5) — CONSOLIDATED.** `all-on-4 บน/ล่าง` returned no search data → merged into single 3.3.4 "All-on-4 บน vs ล่าง". 3.3.6-3.3.11 renumbered → 3.3.5-3.3.10. −1 page.
3. **All-on-4 cannibalization (3.2.8.3) — DEMOTED A→B.** Intent split confirmed (all-on-4 informational / commercial = all-on-4-ราคา at 3.3). 3.2.8.3 = info type-entry → 3.3; 3.3 = commercial canonical. R20 cross-link retained.
4. **All-on-6 — left as-is.** 90/mo LOW; 3.2.8.4 + comparison 3.2.11.3 adequate. No new page.

**Cross-links added:** 3.3.5 (denture-wearers) → 3.14.4 / 3.3.6 (elderly) → 3.13.1 Geriatric hub.

**Ripple:** entities.md porcelain-veneer Primary Page 3.4.2→3.4.2.1 (dental-veneer = veneer hub 3.4.2). No external refs to renumbered 3.3.x pages (verified). Section 3: 240→242 (3.3 12→11, 3.4 11→14).

**Files:** `sitemap.md` (3.4 veneer / 3.3 jaw / 3.2.8.3 / headers / ratio / R21 note) / `entities.md` (porcelain-veneer) / `changelog.md` / `README.md`

**Flags resolved:** Veneer expansion ✅ / All-on-4 dual Tier-A ✅. **Remaining for full keyword research:** per-page volume validation across all sections (Stage 1 Gate full batch).

**Net +2 pages** → Sitemap **728** / Entities **164**

---

## [2026-06-05] — Round 20 Section 3.2 Implant Hero Review (canonical cross-links + tier flag)

**By:** Operator review of §3.2 Implant Mastery (74 pages, hero). Verdict: cleanest section reviewed — strong entity hygiene (method-led, no brand-leak; Osseodensification → `internal-sinus-lift` with Densah brand at Tech 4.4.4), logical structure, `dental-implant` catch-all (25×) all legitimate (overview/candidacy/complex-case demographics/lifetime care). No restructure needed.

**One architectural finding:** All-on-4/6 appears both as implant-type entries (3.2.8.3 Tier A / 3.2.8.4) and as the full §3.3 All-on-X section (Tier A hub) — defensible dual placement (type vs treatment), but lacked cross-links → potential head-term cannibalization.

**Changes — sitemap (page-neutral, 726):**
- Cross-link 3.2.8.3 All-on-4 + 3.2.8.4 All-on-6 → **3.3 (canonical All-on-X home)**
- Cross-link (R18 follow-up) 3.2.11.1 รากเทียม-vs-สะพานฟัน → **3.14.2** / 3.2.11.2 รากเทียม-vs-ฟันปลอม → **3.14.4**
- Inline flag note added under 3.2.8 (Tier/cannibalization)

**Deferred (decided NOT to do now — premature):**
- Tier demotion of 3.2.8.3 (A→C) — cannibalization depends on real SERP data; doc policy = tiers recompute at keyword-research stage. **Flagged for DataForSEO Stage 1 Gate.**
- Soft-tissue cluster (3.2.9.7, 4-level deep, Tier D techniques) — justified E-E-A-T "Global Mastery" showcase; watch for thin at content phase only.

**Net 0 pages** → Sitemap **726** / Entities **164** (unchanged). §3.2 review complete.

---

## [2026-06-05] — Round 19 Section 3.4 Cosmetic Finish (renumber gap-close + Cool Light entity)

**By:** Continuing the Section 3.4 review after R18 pulled crown/bridge/inlay out to §3.14 (which left a numbering gap).

**Changes — sitemap (page-neutral, 726):**
- **Renumber to close gap 3.4.4-.6** (left by R18 restorative move): Whitening 3.4.7→**3.4.4** (+subs Cool Light/Home/Walking Bleach 3.4.4.1-.3) / Gum Contouring 3.4.8→**3.4.5** / Smile Makeover 3.4.9→**3.4.6** / Price 3.4.10→**3.4.7**. Cosmetic now clean sequential, aesthetic-only.
- **Entity fix — Cool Light Whitening (3.4.4.1):** device-leak `cool-light-whitening-unit` → `teeth-whitening` (method). The device entity stays anchored to Tech 4.9.1 (SS-DR-002 brand/device→Tech pattern, same as Densah/Airflow/Damon/Invisalign). Added service↔tech cross-link 3.4.4.1 ↔ 4.9.1.

**Ripple:**
- sitemap: 5.11.8 Gingival Asymmetry "→ link 3.4.8" → **3.4.5**
- entities.md Primary Page: teeth-whitening 3.4.7→3.4.4 / gum-contouring 3.4.8→3.4.5 (cool-light-whitening-unit stays 4.9.1 Tech; internal-bleaching stays 3.11.6 Endo)
- Verified: no other inbound refs to 3.4.7-.10 besides 5.11.8

**Files:** `sitemap.md` (3.4 renumber + Cool Light entity + headers + R19 note) / `entities.md` (2 Primary Pages) / `changelog.md` / `README.md`

**Deferred (flagged in sitemap + README):**
- **Veneer expansion** — Veneer under-built vs Whitening (2 sibling pages, no hub) while "วีเนียร์" is a high-volume TH term. Expand to sub-hub (hub + ราคา + ใครเหมาะ + ดูแล) pending DataForSEO keyword research.

**Net 0 pages** → Sitemap **726** / Entities **164** (unchanged)

---

## [2026-06-05] — Round 18 Restorative & Prosthetic Reorganization (new §3.14) + dental-scaling entity

**By:** Operator review of Section 3.6 — flagged that "General Dentistry" mixed disciplines (รักษาราก + ฟันปลอม "stuck out") and lacked consistency. Investigation surfaced a wider problem: restorative work was split across two sections, with ครอบฟัน/สะพานฟัน/inlay mis-filed under 3.4 Cosmetic.

**Diagnosis — restorative/prosthetic work scattered:**
- 3.6 General: ฟันปลอม (prosthetic, misfit) + รักษาราก (endo — already owned by §3.11)
- 3.4 Cosmetic: ครอบฟัน(5) + สะพานฟัน + inlay/onlay — restorative, not aesthetic (esp. Gold Crown / Implant Crown)

**Decision (operator):** Full reorg — dedicated Restorative & Prosthetic section.

**Changes — sitemap (page-neutral, 726):**
- 🆕 **§3.14 ทันตกรรมบูรณะและประดิษฐ์ (Restorative & Prosthetic)** — 9 pages: ครอบฟัน hub (+zirconia/emax/implant/gold) + สะพานฟัน + inlay/onlay (จาก 3.4) + ฟันปลอม (จาก 3.6). Ties to Prosthodontics Team 2.2.5 + Prosthetic Tech 4.7
- **3.6 General slimmed** → ขูดหินปูน(8) + อุดฟัน + ถอนฟัน + ผ่าฟันคุด(+2). รักษาราก stub (3.6.5) removed → §3.11; ฟันปลอม (3.6.6) → §3.14.4
- **3.4 Cosmetic purified** → aesthetic-only. ครอบ/สะพาน/inlay → §3.14. Numbering gap 3.4.4-.6 left intentionally (note added; avoids renumber ripple on whitening cluster)
- Page math: −7 (3.4) −2 (3.6: 1 moved + 1 deleted) +9 (3.14) = net 0 → **726 unchanged**; Section 3 stays 240

**Changes — dental-scaling entity:**
- Discovered ขูดหินปูน goldmine (12,100/mo) had NO entity — 7 pages mis-tagged `dental-filling` (registry maps that to อุดฟัน 3.6.2)
- entities.md: added **`dental-scaling` (#164, Procedure, K03.6, primary 3.6.1)**; re-tagged 3.6 hub + 3.6.1 cluster (7 pages) → `dental-scaling`; Procedure 49→50, Total **163→164**

**Ripple (entities.md Primary Page):** dental-crown 3.4.4→3.14.1 / zirconia 3.4.4.1→3.14.1.1 / gold-crown 3.4.4.4→3.14.1.4 / removable-denture 3.6.6→3.14.4 / root-canal-treatment 3.6.5→3.11. Verified no hard numbered backlinks to moved pages (refs entity-based, valid); 6.5.1.4 FAQ note updated; 3.6.1.3 SRP → 3.7 cross-link added.

**Files:** `sitemap.md` (3.4/3.6/§3.14 + headers + ratio + R18 note) / `entities.md` (5 Primary Pages + dental-scaling #164 + distribution) / `changelog.md` / `README.md` (164 + R18)

**Deferred:** 4.7→§3.14 DR-002 cross-link (minor) / 3.4 sequential renumber-tidy (gap 3.4.4-.6) / entities.md crown entity-section regroup

**Net 0 pages** → Sitemap **726** / Entities **164**

---

## [2026-06-05] — Round 17 Section 3.5 Remainder: Entity Cleanup + Self-Ligating Fold + Orthognathic Delivery Model

**By:** Operator review of Section 3.5 remainder (3.5.3 Self-Ligating → 3.5.8 Orthognathic), continuing the Section 3.5 deep review from R16.

**Issues identified:**
- Entity brand-leak: 3.5.3 hub + 3.5.3.3/.4 used `damon-system` (Damon = Ormco brand) on service pages — should be method-led (brand lives in Tech 4.6.3). Same SS-DR-002 issue fixed for aligners in R16.
- Entity error: 3.5.4 (จัดฟันเหล็ก / metal braces), 3.5.5 (adults), 3.5.7 (price-all-types) used `clear-aligner` — wrong / catch-all misuse (`clear-aligner` appeared 31× in file).
- Thin/overlap: 3.5.3.3 Metal SL + 3.5.3.4 Ceramic SL (Tier D) overlap 3.5.3.1 "PSL — Metal vs Ceramic Options".

**Operator confirmations:**
- Self-Ligating: clinic offers **both PSL + ASL** → hub name "PSL & ASL" retained; 3.5.3.2 Active-vs-Passive = real 2-option comparison.
- Orthognathic surgery: clinic **refers out** (does not perform in-house OR). Operator wants strong/comprehensive presentation. Resolution: keep all 9 pages but encode **"SmileScape-managed program"** delivery model (clinic owns pre/post-surgical ortho + planning + coordination; surgery via affiliated OMFS @ partner hospital). **Compliance guardrail flagged for Phase F copy** — do NOT claim in-house OR (พ.ร.บ.สถานพยาบาล / สบส. medical-ad rules + Google YMYL/E-E-A-T).

**Changes:**
- 3.5.3 hub entity `damon-system` → `passive-self-ligating`; hub note "ใช้ PSL system" → "PSL + ASL"
- **3.5.3.3 + 3.5.3.4 folded** into 3.5.3.1 (metal/ceramic = in-page sections) → -2 pages
- Damon Tech 4.6.3 backlink "Service booking → 3.5.3.3/.4" → **3.5.3.1**
- 3.5.4 / 3.5.5 / 3.5.7 entity `clear-aligner` → `orthodontic-intervention`
- 3.5.8 hub renamed "...Orthognathic Surgery + Ortho" → "**Orthognathic Surgery Program**" + delivery-model/compliance note row (9 pages retained)

**Files updated:**
- `content-plan/sitemap.md` — 3.5.3 fold + entity fixes, 3.5.8 hub note, Damon backlink, Total Pages (728→726), Section 3 header (242→240), Pages-per-Section, Section 3 Internal Ratio (base 240), R17 round note.
- `docs/changelog.md` — this entry.
- `README.md` — page count → 726 + stage R17 + orthognathic partner-facility open item.

**Net -2 pages** → Sitemap **726**

---

## [2026-06-05] — Round 16 Clear Aligner (3.5.1) Restructure + Invisalign Service/Tech Parity

**By:** Operator sitemap review of Section 3.5. 3.5.1 Clear Aligner sub-hub carried thin direct-print proof-point pages + a hidden near-duplicate of Tech 4.6.0; Invisalign was present in Knowledge/Case but missing Service + Tech layers (asymmetric vs TrioClear).

**Issues identified:**
- 3.5.1.2 "Direct Print Aligner — In-House Lab (Signature #6)" ≈ near-duplicate of Tech 4.6.0 (same title/entity) → cannibalization
- 3.5.1.5 "attachment น้อย" ≈ near-duplicate of Concern 5.10.9 (same entity, mutual link)
- 3.5.1.5/.6 already exist as bullets inside 4.6.0 → thin
- 3.5.1.7 candidacy + 3.5.1.8 limitations overlap (+ overlap with 3.5.1.1)
- Invisalign asymmetry: Service ❌ / Tech ❌ / Knowledge ✅ (6.2.5.2, 6.2.5.5) / Case ✅ (7.5.3)

**Decision (operator):** keep service pages method-led / no brand names (SS-DR-002). Brand keywords (TrioClear, Invisalign) live in Tech 4.6.x + Knowledge 6.2.5 and link back to the Section 3 service page.

**Changes — Services 3.5.1 (11 → 7 rows):**
- 3.5.1.1 renamed "จัดฟันใสคืออะไร" → **"SmileScape In-House Clear Aligner"** (commercial face of Signature #6; direct-print as benefit in prose; generic "คืออะไร/หลักการ/ข้อดี" folded into 3.5.1 hub)
- direct-print-ตรงๆ pages removed from Services (old .2 deep tech / .5 attachment / .6 same-day) → consolidated into Tech 4.6.0
- old .4 "Direct Print vs Thermoformed" → moved to Tech **4.6.0.6**
- old .7 + .8 merged → 3.5.1.4 "ใครเหมาะ/ไม่เหมาะ + ข้อจำกัด"
- renumber: old .3 Progressive → 3.5.1.2 / old .9 ราคา → 3.5.1.5 / old .10 การดูแล → 3.5.1.6
- **NEW 3.5.1.3 "จัดฟันใส Thermoformed — Conventional Clear Aligner" (3rd option)** — method-led, no brand (mirrors TrioClear/Progressive pattern; entity `thermoformed-aligner`)

**Changes — Technology 4.6 (10 → 12 rows):**
- +4.6.0.6 Direct Print vs Thermoformed (moved from old 3.5.1.4)
- +**4.6.2 Invisalign™ / SmartTrack System** (brand keyword placement; → service 3.5.1.3) — parallel to 4.6.1 TrioClear
- renumber: Damon 4.6.2 → 4.6.3 / Digital Ortho Planning 4.6.3 → 4.6.4

**Cross-link / ripple:**
- 4.6.1 TrioClear "Service booking → 3.5.1.3" → **3.5.1.2**
- 4.6.0 "Service → 3.5.1.1 In-House Clear Aligner" (new DR-002 link)
- 5.10.9 "→ link 3.5.1.5" → **3.5.1.1 In-House / 4.6.0**
- 6.2.5.2 Invisalign + 7.5.3 Case → wired "→ service 3.5.1.3"

**Files updated:**
- `content-plan/sitemap.md` — 3.5.1 + 4.6 blocks, ripple links, Total Pages (730→728), Section 3 header (246→242) + Section 4 header (42→44), Pages-per-Section, Section 3 Internal Ratio (base 242), R16 round note.
- `docs/changelog.md` — this entry.

**Flagged (defer to Section 6 review):**
- 6.2.5.10 "In-House vs Outsourced" ≈ duplicate of Tech 4.6.0.5 — candidate to yank (-1)
- Entity: 4.6.2 Invisalign uses generic `thermoformed-aligner` (no brand entity registered). Promote to `invisalign-aligner` if brand-entity parity with TrioClear (`trioclear-aligner`) is desired.

**Net -4 services + 2 tech = -2 pages** → Sitemap **728**

**Final R16 metrics:**
- Sitemap pages: **728**
- Clusters: 20 / Citation pillars: 16
- Signature Offerings: 6 (Direct Print signature commercial face = 3.5.1.1)
- Brand DRs: SS-DR-001..010 / DR-022 / SS-DR-002 (brand-vs-tech split applied to aligner cluster)

---

## [2026-05-30] — Round 15 Section 8.1 Contact Hub Consolidation

**By:** Continuation of the pre-review consolidation pass (R13/R14 thin-page pattern) — Section 8.1 Contact Hub carried thin duplicate sub-pages overlapping the single contact/booking intent.

**Thin-page / duplication identified:**
- 8.1.1 Book Free Consultation + 8.1.2 Line @Smile_Scape were thin sub-pages under the 8.1 Contact hub. Booking + contact intent is best served as ONE comprehensive page (mirrors R14 Section 2.4 "Your First Visit" comprehensive-page pattern).

**Changes:**
- **8.1 consolidated** — 3 pages (1 hub + 8.1.1 + 8.1.2) → 1 comprehensive "ติดต่อ SmileScape — นัดหมายฟรี" page. In-page sections:
  - จองนัดปรึกษาฟรี — Book Free Consultation form (+ 3D X-ray info)
  - Line @Smile_Scape — แชทปรึกษา (QR + LINE OA link)
  - Phone + Email + Hours (NAP for branches at 8.2 / 8.3)
- **8.1 = canonical booking + contact action** (was 8.1.1 at R14). Section 2.4 cross-link updated 8.1.1 → 8.1.

**Files updated:**
- `content-plan/sitemap.md` — 8.1 consolidated (table rows) + Section 8 header count (~17→~15) + Pages-per-Section line + Top-of-file Total Pages (~728→~726) + R15 round note + Section 2.4 cross-link 8.1.1→8.1.
- `docs/changelog.md` — this entry.
- `README.md` — page count (~728→~726) + stage note bumped to R15.

**Net -2 pages** → Sitemap **~726**

**Final R15 metrics:**
- Sitemap pages: **~726**
- Clusters: 20 / Entities: 163 / Edges: 271 / Citation pillars: 16
- Signature Offerings: 6 / Clinical Protocols: 1
- Brand DRs: SS-DR-001..010 / brand-config: v1.11

---

## [2026-05-22 LATE NIGHT 2] — Round 14 Section 2.4 Consolidation + Canonical Cross-Links

**By:** Operator review caught duplication in Section 2.4 (5 pages) overlapping with 5.13.3 + 6.5.4.x + 8.1.1.

**Duplication identified:**
- 0% Financing: 4 places (2.4.4 + 5.13.3 + 6.5.4.1 + 6.5.4.2)
- Free Consultation: 2 places (2.4.3 + 8.1.1)

**Changes:**
- **2.4 consolidated** — 5 pages (1 hub + 4 sub) → 1 comprehensive Patient Journey page. In-page sections:
  - What to Expect — สิ่งที่จะเกิดขึ้นในวันแรก
  - 5-Step Treatment Process (→ link 3.2.5 implant Digital 100%)
  - Free Consultation & 3D X-ray ปรึกษาฟรี (→ link 8.1.1 booking action)
  - Payment Plans 0% (→ link 5.13.3 canonical / 6.5.4.2 FAQ)
- **5.13.3 promoted Tier C→B** = canonical detail page for "0% financing"
- **8.1.1 promoted Tier C→B** = canonical booking action
- **6.5.4.1 vs 6.5.4.2 scope clarified:** 6.5.4.1 = broad pricing overview / 6.5.4.2 = 0%-specific deep details

**Files updated:**
- `content-plan/sitemap.md` — Section 2.4 consolidated + canonical cross-link notes on 5.13.3 / 8.1.1 / 6.5.4.1 / 6.5.4.2. Section 2 header count updated. Top-of-file totals updated.
- `docs/changelog.md` — this entry.

**Net -4 pages** → Sitemap **~728**

**Strategic gains:**
- No more 0% financing duplication (was 4 places → canonical 5.13.3 + FAQ 6.5.4.2)
- No more consultation duplication (was 2 → canonical 8.1.1)
- "Your First Visit" page works better as comprehensive journey (storytelling flow)
- DR-021 internal linking pattern clearer (Patient Journey 2.4 → canonical pages)

**Final R14 metrics:**
- Sitemap pages: **~728**
- Clusters: 20 / Entities: 163 / Edges: 271 / Citation pillars: 16
- Signature Offerings: 6 / Clinical Protocols: 1
- Brand DRs: SS-DR-001..010 / brand-config: v1.11

---

## [2026-05-22 LATE NIGHT] — Round 13 Pre-Review QA Cleanup (Final Audit Before Operator Review)

**By:** Final deep audit before operator deep-review — catch all inconsistencies / thin-page risks / numbering issues.

**Critical Fixes:**
1. **Section header page counts** were stale (R0 numbers — 32/187/35/109/55/18). Corrected to actuals via script recount: Section 2 ~38 / Section 3 ~262 / Section 4 ~42 / Section 5 ~190 / Section 7 ~38 / Section 8 ~17.
2. **Entity count metadata** claimed 167, actual rows = 163 — corrected entities.md total.
3. **Edge count metadata** claimed 264, actual rows = 271 — corrected relationships.md Health Check.
4. **Total sitemap pages** claim ~722 → actual ~733 (after R13 -7 consolidation).

**Thin-Page Consolidation (DR-016 risk):**
- **5.22 Lifestyle:** 6 pages (1 hub + 5 sub-pages all Tier D, no DFS) → **1 comprehensive page** with in-page sections. Net -5.
- **3.13.4 Special Needs:** 4 pages (1 hub + Autism/Dementia/GA-ref) → **1 comprehensive page** with in-page sections (low individual volume + thematic overlap). Net -3.

**Numbering Notes:**
- 3.5.2 gap note added (R11 merged old TrioClear page into 3.5.1.3 Progressive Force) — visual gap explained.
- 3.12.x gap (R9 consolidation), 3.13.1.x gap (R9 deletion), 3.13.2.x gap (R9 consolidation) — already noted in respective hubs (R9 verified).

**Files updated:**
- `content-plan/sitemap.md` — Section header counts (6 lines fixed) + Top-of-file totals updated + 5.22/3.13.4 consolidated + 3.5.2 gap note + R13 changelog header.
- `content-plan/entities.md` — Total claim 167→163 with audit note.
- `content-plan/relationships.md` — Total claim 264→271 + entity count 167→163 with audit note.
- `content-plan/egp-output-summary.md` — R12/R13 expansion notes added + final totals.
- `docs/changelog.md` — this entry.
- `README.md` — page count update + R13 audit note.

**Findings NOT requiring action (noted for future):**
- Section 3 sub-section order (R-chronological vs topical) — renumbering = too disruptive
- Section 5 sub-section order (R0 + R5 mixed) — renumbering = too disruptive
- Section 4.6.0 placement before 4.6.1 — unusual but acceptable
- ~155 Tier D deep sub-pages — most have strategic value (authority/citation/E-E-A-T); only 5.22+3.13.4 had clear thin-page risk

**Final R13 lock metrics:**
- Sitemap pages: **~733** (was claimed 722, audited count R13)
- Clusters: 20
- Entities: **163** (was claimed 167)
- Edges: **271** (was claimed 264)
- Bidirectional edges: 81
- evidenced_by edges: 26
- Citation pillars: 16
- Signature Offerings: 6
- Clinical Protocols: 1 (ZBL)
- Brand DRs: SS-DR-001..010
- brand-config: v1.11

**Status:** ✅ **Ready for operator deep review**. All Phase E planning complete pending DataForSEO full keyword batch (R14) and operator data sync.

---

## [2026-05-22 NIGHT] — Round 12 SS-DR-002 Compliance Cleanup (Brand-Name Audit)

**By:** Operator-identified violations of SS-DR-002 (locked R0 2026-04-08) introduced in R2 (PSL/Damon) + R3 (Densah Bur) + R11 (Direct Print/Clear Aligner restructure with TrioClear/Invisalign mentions in Section 3).

**SS-DR-002 principle:**
- Section 3 (Services) = method-led naming (no external product brands)
- Section 4 (Technology) = brand names OK + tech specs
- Section 6 (Knowledge) = ดัก brand search intent

**Operator refinement (R12):** External product brands → Section 4/6 only. Doctor-named techniques (Sausage / Strip Graft / Ice Berg / Garage / Osseodensification concept) + SmileScape's own brand allowed in Section 3 — they're INSEPARABLE from the technique itself.

**Files updated:**
- `content-plan/sitemap.md` — 7 strict renames + 1 borderline:
  - **3.2.9.4.2** Crestal Sinus Lift with **Densah Bur** → "Crestal Sinus Lift via **Osseodensification**" (method-led)
  - **3.5.1.3** จัดฟันใส **TrioClear** (Progressive) → "จัดฟันใสแบบ **Progressive Force** — Multi-Layer Material"
  - **3.5.1.4** Direct Print vs Thermoformed (**Invisalign/TrioClear**) → "Direct Print vs **Thermoformed Aligner** — Method Comparison"
  - **3.5.1.9** ราคา SmileScape — Direct Print vs **Invisalign/TrioClear** → "ราคา SmileScape — **In-House Direct Print vs Outsourced Lab Tier**"
  - **3.5.3.1** PSL — **Damon Q / Damon Clear** → "PSL — **Metal vs Ceramic Options**"
  - **3.5.3.3** **Damon Q** (Metal PSL) → "**Metal Self-Ligating Bracket**"
  - **3.5.3.4** **Damon Clear** (Ceramic PSL) → "**Ceramic Self-Ligating Bracket**"
  - **3.6.1.2** **Airflow** / Air Polishing → "**Air Polishing** System" (borderline — EMS brand kept at 4.4.5)
- Cross-link notes added on Section 4 brand pages (4.4.4 Densah / 4.4.5 EMS Airflow / 4.6.1 TrioClear / 4.6.2 Damon) — making DR-002 funnel pattern explicit: Brand-intent → Tech page → Service page link.
- `docs/decision-records.md` — SS-DR-002 updated with R12 audit note + compliance refinement.
- `docs/changelog.md` — this entry.

**Patient flow after fix:**
```
Patient: "จัดฟันใส TrioClear ราคา"
  → Lands on 6.2.5.1 "TrioClear คืออะไร" (brand-intent capture)
  → cross-link → 4.6.1 TrioClear Progressive Aligner System (tech detail)
  → cross-link → 3.5.1.3 "จัดฟันใสแบบ Progressive Force" (Service booking — method-led)
  → CONVERSION
```

**Strategic gains:**
- **DR-002 compliance restored** — brand positioning consistency
- **Cleaner Section 3 service catalog** — sells methodology not brand inventory
- **Brand intent funnel preserved** — Section 4 + 6 still capture brand searches
- **Explicit cross-links** — DR-021 bidirectional linking now has clear Section 4/6 → Section 3 conversion paths

**Process learning:** Added compliance-check note in SS-DR-002 — every sitemap-edit task should audit against DR-002 before commit.

**Cumulative project status (R12 lock):**
- Sitemap pages: ~722 (no count change — renames only)
- Clusters: 20 / Entities: 167 / Edges: 264 / Citation pillars: 16
- Brand DRs: SS-DR-001..010 / brand-config: v1.11
- Signature Offerings: 6 / Clinical Protocols: 1

**No new pending operator (R12 = structural compliance cleanup)**

---

## [2026-05-22 EVENING] — Round 11 Clear Aligner Elevation + Direct Print Signature #6 (SS-DR-010)

**By:** Operator inputs:
1. **Direct Print In-House Clear Aligner = clinic capability** (real, not speculative)
2. **Photopolymer 3D direct-print technology** (Graphy TC-85DAC or Tera Harz TC-85, brand TBD)
3. **Key differentiator: fewer attachments** vs thermoformed aligners (Invisalign/TrioClear)

**External research (PubMed 6 citations):**
- PMID 36311049 — Direct 3D printed aligner outcomes (2022)
- PMID 33916462 — Photopolymer aligner material properties (2021)
- PMID 39921085 — Recent clinical outcomes (2024)
- PMID 38337260 — Direct Print vs Thermoformed comparison (2024)
- PMID 40123039 — 2025 Systematic Review
- PMID 42076391 — Tera Harz TC-85 specific properties

**Files updated:**
- `brand-config.json` — v1.10 → v1.11. **Signature Offering #6 added** (Direct Print Clear Aligner In-House Lab). 5 → 6 signature offerings total.
- `content-plan/entities.md` — 161 → 167 entities (+6 R11):
  - `direct-print-clear-aligner` (Treatment, brand-scope=['smile-scape']) — Signature anchor
  - `in-house-aligner-lab` (Concept, brand-scope=['smile-scape'])
  - `photopolymer-resin-tc85` (Product)
  - `aligner-attachment` (Device)
  - `3d-printer-aligner` (Device)
  - `thermoformed-aligner` (Concept) — comparison anchor
- `content-plan/relationships.md` — 249 → 264 edges (+15 R11). Y section: subtype/alternative/uses/evidenced_by chains for Direct Print + In-House Lab + comparison with Thermoformed.
- `content-plan/sitemap.md` — ~702 → ~722 pages (+20 R11):
  - **Section 3.5.1 promoted Tier A** + restructured as sub-hub (10 sub-pages):
    - 3.5.1.1 จัดฟันใสคืออะไร (Tier B)
    - 3.5.1.2 🌟 SmileScape Direct Print Aligner — Signature #6 hero (Tier A)
    - 3.5.1.3 TrioClear Progressive (2nd option, Tier C)
    - 3.5.1.4 Direct Print vs Thermoformed comparison (Tier B)
    - 3.5.1.5 ทำไม Direct Print ใช้ attachment น้อยกว่า (Tier B)
    - 3.5.1.6 Same-Day Aligner Capability (Tier B)
    - 3.5.1.7-10 Candidacy + Limitations + Pricing + Care
  - **Section 4.6.0 NEW** — In-House Aligner Lab — Direct Print Production sub-hub (6 pages): 4.6.0.1 3D Printer / 4.6.0.2 Photopolymer Resin / 4.6.0.3 Workflow / 4.6.0.4 QC + FDA / 4.6.0.5 In-house vs Outsourced
  - **Section 6.2.5 +3** — Direct Print Knowledge insights (6.2.5.8-10)
  - **Section 6.4.15** — Direct Print Evidence Summary
  - **Section 5.10.9** — Cross-ref concern page (จัดฟันใส attachment น้อย → 3.5.1.5)
- `content-plan/citation-pool-seed.md` — **Pillar 16 NEW** Direct Print Clear Aligner (8 citations incl 6 PubMed PMIDs + 2 manufacturer). 15 → 16 pillars total.
- `docs/decision-records.md` — **SS-DR-010** added (Direct Print = Signature #6). Future placeholders renumbered SS-DR-011..014.
- `content-plan/egp-output-summary.md` — R11 expansion note + recount.
- `docs/changelog.md` — this entry.
- `README.md` — page count 702 → ~722 + Signature #6 noted in operator pending.

**Strategic gains:**
- **6 Signature Offerings** (was 5) — value-premium clinic now has unique differentiator across full service stack
- **UNIQUE TH market positioning** for in-house aligner manufacturing (most clinics outsource)
- **Premium pricing support** — fewer attachments + same-day capability = patient experience superior
- **AI citation surface** — Pillar 16 = 6 PubMed PMIDs ready for AI Knowledge Graph
- **DR-021 internal linking** — 15 new edges for Direct Print integration

**Cumulative project status (R11 lock):**
- Sitemap pages: **~722**
- Clusters: 20 / Entities: 167 / Edges: 264 / Citation pillars: 16
- Bidirectional edges: 81 / evidenced_by edges: 26
- Brand DRs: SS-DR-001..010 / brand-config: v1.11
- Signature Offerings: **6** / Clinical Protocols: 1 (ZBL)

**Pending operator (R11 additions):**
- Confirm 3D printer model (Asiga / SprintRay / Formlabs)
- Confirm photopolymer brand (Graphy TC-85DAC / Tera Harz TC-85 / other)
- Confirm production volume + warranty terms + lab certification
- Confirm หมอแฮม role in in-house lab (Medical Director oversight?)

---

## [2026-05-22 LATE PM] — Round 10 Team Audit (Pediatric Confirmed + Geriatric Team Removed)

**By:** Operator inputs:
1. ✅ **Pediatric Dentist CONFIRMED on staff** (was 2.2.10 pending since R2)
2. ❌ **No dedicated Geriatric/Special-Care specialist team** (R8 had speculatively added 2.2.11 — now removed)

**Files updated:**
- `brand-config.json` — v1.9 → v1.10. `_changelog_1_10` documents R10 team audit.
- `content-plan/sitemap.md` — Net -1 page (~703 → ~702):
  - **2.2.10 Pediatric Team** — Tier C→B + "Pediatric Dentist on staff ✓ R10 confirmed"
  - **2.2.11 Geriatric/Special-Care Team REMOVED** (no dedicated specialist; R8 was speculative)
  - **3.13.1 Geriatric Dentistry service hub** — keep service section, note delivery via general team + Periodontist + Endodontist (not a dedicated geriatric team)
- `README.md` — page count 703 → ~702 + pending list cleanup (Pediatric Team + Geriatric Team resolved).
- `docs/changelog.md` — this entry.

**Strategic clarification:** Geriatric Dentistry (Section 3.13.1) is a **service offering** delivered via the existing clinical team (general dentists + Periodontist + Endodontist for senior-specific gum/endo issues) — not a dedicated specialty team. Service authenticity > org chart fiction. Same pattern as Section 3.10 Sedation/GA which is delivered via anesthesiologist + general team (no dedicated "sedation team" per se).

**Cumulative project status (R10 lock):**
- Sitemap pages: **~702**
- Clusters: 20 / Entities: 161 / Edges: 249 / Citation pillars: 15
- brand-config: v1.10

**Pending operator (R10 cleanup):**
- ✅ R10 RESOLVED: Pediatric Dentist confirmed (was #10)
- ✅ R10 RESOLVED: No geriatric specialist team — service via general team (was R8 #13)
- Remaining: หมอแฮม Versah + Linkevicius training certs / Doctor Praeo credentials / Branch addresses / Brand inventory verifications / SSO annual cap year / DataForSEO full batch (R11)

---

## [2026-05-22 PM] — Round 9 Audit + Operator Confirmations (Specialists Confirmed + 3.12 Restructure + Thin-Page Cleanup)

**By:** Operator confirmations + DFS-validated audit decisions

**Operator inputs:**
1. ✅ **Periodontist + Endodontist specialists CONFIRMED on staff** (was R3 TBD)
2. ❌ **Home visit dentistry NOT offered**
3. ❌ **Bedridden patient dentistry NOT offered**
4. ❓ **3.12.1-4 consolidation question** + 3.13.2.1-4 thin-page risk question

**DFS findings (R9):**
- 🔥 **ตรวจสิทธิประกันสังคม 2,400/mo TH LOW** — R4 GOLDMINE missed → 3.12.3 EXPANDED
- 🔥 **เอกสารประกันสังคม 720/mo TH LOW** — combined 3,120/mo SSO check goldmine
- Pregnancy sub-pages: pregnancy gingivitis 20/mo / ตั้งครรภ์เหงือกบวม 10/mo / others NULL → thin-page confirmed

**Files updated:**
- `brand-config.json` — v1.8 → v1.9. `_changelog_1_9` documents audit decisions.
- `content-plan/sitemap.md` — Net -3 pages (~706 → ~703):
  - **2.2.7 Periodontics Team** — Tier C→B + "Periodontist specialist on staff ✓ R9 confirmed"
  - **2.2.9 Endodontist Team** — Tier C→B + "Endodontist specialist on staff ✓ R9 confirmed"
  - **3.12 SSO restructure:**
    - 3.12.1 consolidated → hub in-page section
    - 3.12.4 consolidated → hub in-page section
    - **3.12.3 EXPANDED to sub-hub with 4 sub-pages** — DFS goldmine 3,120/mo: 3.12.3.1 Online check (sso.go.th + SSO Connect app) / 3.12.3.2 Documents checklist / 3.12.3.3 First-time use at SmileScape / 3.12.3.4 Article 39/40 guidance
    - 3.12.2 + 3.12.5 unchanged
  - **3.13.1.1 Home Visit + 3.13.1.2 Bedridden DELETED** — replaced with R9 update note in hub
  - **3.13.2 Pregnancy CONSOLIDATED** — comprehensive single page with in-page sections (Pre-pregnancy / Emergency / Q2 window / Breastfeeding). 3.13.2.2 Pregnancy Gingivitis kept standalone (clinical condition + entity + EFP evidence)
- `content-plan/entities.md` — `bedridden-dentistry` entity kept but Primary Page cleared (federation reuse, not SmileScape-offered)
- `content-plan/egp-output-summary.md` — R9 audit note.
- `docs/changelog.md` — this entry.
- `README.md` — page count 706 → ~703 + pending operator items cleanup (Periodontist + Endodontist + Peri-Implantitis specialist credentials moved from "pending" to "confirmed" / Home visit + Bedridden capability removed from pending — clinic doesn't offer).

**Strategic gains:**
- **3,120/mo SSO check goldmine** unlocked at 3.12.3 sub-hub
- **Service authenticity** — sitemap reflects actual capabilities (no false advertising)
- **DR-016 thin-page risk mitigated** — pregnancy sub-pages consolidated to comprehensive single page (better E-E-A-T)
- **Specialist credibility** — Periodontist + Endodontist confirmed = 3.7.7 + 3.11 + 5.6.3 (gum) + 5.14 (acute pain) all have authority anchor

**Cumulative project status (R9 lock):**
- Sitemap pages: **~703**
- Clusters: 20 / Entities: 161 / Edges: 249 / Citation pillars: 15
- Bidirectional edges: 73 / evidenced_by edges: 25
- Brand DRs: SS-DR-001..009 / brand-config: v1.9

**Pending operator (R9 cleanup):**
- ✅ Removed: Periodontist + Endodontist + Peri-Implantitis specialist credentials (confirmed on staff)
- ✅ Removed: Home Visit + Bedridden capability questions (clinic doesn't offer)
- Remaining: Geriatric Team specialist names + credentials, หมอแฮม Versah + Linkevicius training certs, Doctor Praeo credentials, brand inventory verifications, DataForSEO full batch.

---

## [2026-05-22] — Round 8 Demographic-Specific Dentistry Services (Section 3.13 NEW)

**By:** Operator question "เรามีพูดถึงทันตกรรมสำหรับคนเฉพาะกลุ่มไหม" + DFS reconnaissance

**Gap identified:** Concern + FAQ coverage strong (Section 5.8 = 13 pages, 5.20 Pregnancy = 8 pages, 5.12 Kids = 6 pages, 6.5.3 FAQ Patient Group = 4 pages), but **Section 3 service layer only had Pediatric** (3.9) dedicated. No service-side landing for senior / pregnancy / diabetes / cardiac / special-needs patients.

**Files updated:**
- `brand-config.json` — v1.7 → v1.8. Added 4 specialties to `specialty_focus`: geriatric_dentistry, pregnancy_dental_care, medical_compromised_dentistry, special_needs_dentistry.
- `content-plan/clusters.md` — 19 → 20 clusters. NEW cluster `demographic-dentistry` under Domain H Specialty Services.
- `content-plan/entities.md` — 155 → 161 entities (+6 R8). New Treatment+Concept entities: `geriatric-dentistry`, `pregnancy-dental-care`, `medical-compromised-dentistry`, `bedridden-dentistry`, `medical-clearance-protocol` (Concept), `special-needs-dentistry`.
- `content-plan/relationships.md` — 232 → 249 edges (+17 R8). X1-X4 sub-clusters: hierarchy, service↔concern bidirectional, MRONJ requires_assessment, brand integration. 10 bidirectional edges.
- `content-plan/sitemap.md` — ~681p → ~706p (+25 R8).
  - **Section 3.13 NEW** — ทันตกรรมสำหรับคนเฉพาะกลุ่ม (master hub + 4 sub-hubs):
    - **3.13.1 ทันตกรรมผู้สูงอายุ / Geriatric** (6 pages): Home visit / Bedridden / Comorbidity / Overdenture senior / Implant senior / Xerostomia
    - **3.13.2 ทันตกรรมหญิงตั้งครรภ์ / Pregnancy** (4 pages): Pre-pregnancy / Pregnancy gingivitis / Emergency protocol / Q2 safe window
    - **3.13.3 Medical-Compromised** (8 pages): Diabetes / Cardiac / BP+anticoagulants / Cancer-radiation-chemo / Immunocompromised / Bisphosphonate-MRONJ / Liver-Kidney / Medical clearance protocol
    - **3.13.4 Special Needs** (3 pages): Autism-ADHD-Down's / Dementia / GA dentistry crossref
  - **Section 2.2.11 NEW** — Geriatric / Special-Care Dentistry Team page
  - Section 5.8 hub primary entity updated to `medical-compromised-dentistry` + cross-ref to 3.13 service
  - Section 5.20 hub cross-ref to 3.13.2 service
- `content-plan/egp-output-summary.md` — R8 expansion note.
- `docs/changelog.md` — this entry.
- `README.md` — page count 681 → ~706 + status update.

**DFS findings (R8):**
- ⭐ **ทันตกรรมผู้สูงอายุ** 70/mo TH LOW (6) — primary anchor, validates Geriatric service section
- geriatric dentistry 30/mo TH LOW — English variant, professional-search
- ทำฟันคนท้อง / ตั้งครรภ์ถอนฟัน 10/mo each TH LOW
- เบาหวานทำฟัน / โรคหัวใจทำฟัน / ความดันทำฟัน — DFS NULL (gap, real demand unreported)

**Strategic rationale:**
- **Service-side demographic positioning** = premium implant clinic credibility for high-value demographics (senior implant market, comorbid patient implant market)
- **Aging Thailand market** — service section gives SmileScape topical authority for geriatric dentistry
- **Concern → Service funnel architecture** — Section 5.8/5.20 concerns now have clear service destination (3.13.x), not just FAQ
- **DR-021 internal linking** — 10 new bidirectional edges (Service↔Concern) increases reciprocal-detection density
- **MRONJ critical risk** — 3.13.3.6 + 3.13.3.8 medical clearance protocol creates safety-net pages for Bisphosphonate patients

**Cumulative project status (R8 lock):**
- Sitemap pages: **~706**
- Clusters: 20 / Entities: 161 / Edges: 249 / Citation pillars: 15
- Bidirectional edges: 73 (+10 R8)
- evidenced_by edges: 25

**Pending operator (R8 additions):**
- Home visit dentistry — does SmileScape offer at-home senior care? (affects 3.13.1.1)
- Bedridden patient capability (affects 3.13.1.2)
- Geriatric/Special-Care team specialist names + credentials (affects 2.2.11)

---

## [2026-05-22 EARLY] — Round 7 FAQ Canonical Source (SS-DR-009)

**By:** Operator-identified overlap problem ("FAQ ใน section 5 กับ 6 มีความงง มีความทับซ้อนกัน") → consolidation to Section 6.5

**Problem analyzed:**
- Section 5.9 FAQ (concern-context, 5 pages) + Section 6.5 FAQ (knowledge-context, 5 pages) = duplicate Q&A potential
- 5+ concrete overlap scenarios identified (ฝังรากเจ็บไหม / ผ่อน 0% / ประกันสังคม / etc.)
- Internal linking ambiguity for DR-021 reciprocal-detection
- AI citation surface fragmented = Knowledge Graph confusion

**Files updated:**
- `brand-config.json` — v1.6 → v1.7. Added `content_strategy.faq_canonical_location = "section_6.5"` flag + `_faq_canonical_note` explanatory comment.
- `docs/decision-records.md` — **Added SS-DR-009 FAQ Canonical Source Decision**. Locks Section 6.5 as single canonical FAQ home. Section 5.9 deprecated. Rationale: AI citation unified, DR-021 linking clean, operator clarity.
- `content-plan/sitemap.md`:
  - **DELETED Section 5.9** (6 pages: 1 hub + 5 sub) — replaced with deprecation notice + cross-reference to 6.5
  - **EXPANDED Section 6.5** from 6 → 29 pages (1 master hub + 5 sub-hubs):
    - **6.5.1 FAQ by Service** (10 pages): รากเทียม / All-on-X / จัดฟัน / วีเนียร์-ครอบ / เด็ก / Endo / Sedation / Peri-Implantitis / Bone Graft / Soft Tissue
    - **6.5.2 FAQ by Concern** (6 pages): Safety / Timeline / After-care / Pain-Emergency / Aesthetics / Decision
    - **6.5.3 FAQ by Patient Group** (4 pages): Senior / Pregnancy / Pediatric / Medical Comorbidities
    - **6.5.4 FAQ Cost & Insurance** (5 pages): Price / Installment / SSO / UCS-CGA-Private / Tax
    - **6.5.5 FAQ Quick Reference** (2 pages): Top 10 + Voice Search (Speakable schema)
  - Updated Section 6 master structure table: 127 → 150 pages
  - Updated sitemap header: ~664 → ~681 pages (net +17 = -6 deletion + 23 expansion)
- `content-plan/egp-output-summary.md` — R7 expansion note added.
- `docs/changelog.md` — this entry.

**Internal linking pattern updates (DR-021):**
- Section 3 services (10) → 6.5.1.x service FAQ canonicals
- Section 5 concerns (multiple clusters) → 6.5.2.x topic FAQ canonicals
- Section 5.8/5.20 patient groups → 6.5.3.x demographic FAQ canonicals
- Section 3.12 + 5.13 cost/insurance → 6.5.4.x financial FAQ canonicals
- Voice Search optimization → 6.5.5.2 Speakable

**Strategic gains:**
- **Single source of truth** — no duplicate Q&A across pages
- **AI citation surface unified** — Knowledge Graph has 1 FAQ entity anchor
- **DR-021 reciprocal-detection clean** — every page → exactly ONE 6.5.x target
- **Schema.org FAQPage** consistent on every 6.5.x leaf
- **Speakable extension** for Voice Search at 6.5.5.2
- **Operator clarity** — content team writes FAQ in ONE structured place

**Cumulative project status (R7 lock):**
- Sitemap pages: **~681**
- Clusters: 19 / Entities: 155 / Edges: 232 / Citation pillars: 15

**No new pending operator actions (R7 = structural restructure, no operator data dependencies)**

---

## [2026-05-21 LATE NIGHT] — Round 6 Citation Pool Pillars 6-15 Expansion

**By:** Operator reminder "อย่าลืม propose citation ให้ด้วยนะ" + PubMed MCP targeted searches

**Files updated:**
- `content-plan/citation-pool-seed.md` — Phase B.2 initial 5 pillars → **15 pillars (+10 R6)**. New pillars added:
  - **P6 Soft Tissue D-2 Hybrid** — Urban 2017 textbook (Strip/Ice Berg/Garage primary source) + CAF/VISTA/Tunneling citations + Avila-Ortiz keratinized SR (PMID 32710810)
  - **P7 Densah / Osseodensification** — Huwais original concept + 5 PubMed SRs/meta-analyses (PMIDs 37975644 / 38002660 / 40377845 / 33139057 / 33671038)
  - **P8 Zero Bone Loss Concept (Linkevicius)** — Linkevicius 2019 Quintessence textbook (ISBN 978-0867158243) + 5 PMIDs (34076631 / 20605308 / 33527729 / 32250061 / 35476860)
  - **P9 Peri-Implantitis Service** — Schwarz EFP 2018 World Workshop consensus (PMID 25626479) + 2023 SR (PMID 37271498) + 2025 update (PMID 40501397) + EFP 2023 clinical practice guidelines
  - **P10 Pediatric Dentistry** — AAPD Reference Manual + WHO 2022 children oral health + Cochrane fluoride varnishes (Marinho 2013) + Cochrane pit-fissure sealants (Ahovuo-Saloranta 2017)
  - **P11 Endodontics by Specialist** — ESE + AAE guidelines + Setzer endodontic microscope outcomes (PubMed depth pending)
  - **P12 Sedation/GA Dentistry** — AAPD Behavior Guidance + ASA 2018 moderate sedation guidelines + Thai regulatory pending
  - **P13 Insurance / SSO Q-Clinic** — sso.go.th regulatory database primary source (Tier 1 government)
  - **P14 R5 Concern Conditions** — AAOMS 2022 MRONJ Position Paper (PMID 35336535) + 3 MRONJ SRs (PMIDs 37449761 / 39113433 / 35911799) + Cochrane Dry Socket (Daly 2012) + AAOP Orofacial Pain guidelines + Manfredini Bruxism consensus
  - **P15 Dental Caries** — WHO 2019 caries implementation manual + Cochrane fluoride toothpaste (Walsh 2019) + Pitts 2017 Nat Rev DP + Cochrane sealants
- `content-plan/relationships.md` — **+17 evidenced_by edges** (W section). Connects brand-stance entities to authority citations: ZBL→Linkevicius, Osseodensification→Densah-bur, Peri-Implantitis Treatment→Schwarz consensus, CAF/Tunneling/VISTA→Root coverage authority anchors, Dental Caries→Fluoride evidence, MRONJ→AAOMS 2022, etc. **evidenced_by edge count 8 → 25** (+213% R6).
- `content-plan/egp-output-summary.md` — Round 6 expansion note + citation count update.
- `docs/changelog.md` — this entry.

**Brand Stance Topics expansion (Pattern E per DR-019):** +6 new brand-stance entries connecting R2-R5 service additions to authority citations (Densah/ZBL/Q-Clinic/Peri-Implantitis/Caries/Perio claims).

**Operator action items expansion:** Initial 7 → 20 total. Round 6 additions cover textbook acquisitions (Linkevicius 2019, AAPD Manual), credential verification (Linkevicius training, Versah training, Q-Clinic registration), regulatory pulls (sso.go.th, ทันตแพทยสภา, ราชวิทยาลัยฯ), and targeted PubMed depth searches for Phase F.

**Citation pool stats (R6 lock):**
- Total pillars: **15** (was 5 — +10 R6)
- Total citations identified: **~80**
- PubMed PMIDs verified: **~25**
- Tier 1 government/regulatory sources: **8**
- Tier 4 textbooks: **3** (Urban 2017 / Linkevicius 2019 / AAPD Reference Manual)
- Brand authority anchors: **4 named** (Urban / Huwais / Linkevicius / Kern)

**Strategic frame (R6):**
- Citation pool now **mirrors entire sitemap structure** — every R2-R5 service/concept has at least 1 Tier 1-3 citation pillar
- **AI citation surface for Knowledge Graph** = comprehensive E-E-A-T anchor depth before content production starts
- `evidenced_by` edges = 25 typed relationships → DR-019 Pattern E backing graph ready for Stage 1.5 flat-load
- Phase F per-page citations will EXPAND from these pillars, not start from scratch

**Pending operator actions (R6 — see citation-pool-seed.md Action Items 8-20)**

---

## [2026-05-21 NIGHT] — Round 5 Section 5 Concern Universe Deep-Expansion

**By:** Operator request "deep review concern keyword + bidirectional internal linking density" + DFS reconnaissance (5 batches, 60+ keywords)

**Strategic rationale:** DR-021 `seo_page_internal_links` junction table with reciprocal-detection trigger requires both endpoints **at planning time**. Bidirectional linking density argument: adding concern pages later breaks established link graph; comprehensive coverage at planning time = maximum link density.

**Files updated:**
- `content-plan/sitemap.md` — ~569p → ~664p (+95 R5)
  - **Block V (Re-tier 7 pages):** 5.6.2 ฟันผุ C→A (DFS 22.2k/mo) / 5.6.3 เหงือกบวม C→A (DFS 28.8k combined) / 5.11.1 เหงือกร่น C→A (DFS 9.9k) / 5.6.5 ฟันร้าว D→B / 5.6.6 กลิ่นปาก D→B / 5.6.7 ฟันโยก D→B / 5.5.6 ฟันสึก D→C
  - **Block W1 (5.6.2 ฟันผุ expansion):** +6 pages (white spot / pulpitis / asymptomatic / prevention / interproximal / root caries)
  - **Block W2 (5.6.3 เหงือกบวม expansion):** +8 pages (perio signs / abscess / acute / BoP / silent / orthodontic / peri-implant / chronic)
  - **Block W3 (5.14 NEW Acute Pain & Emergency):** +9 pages
  - **Block W4 (5.15 NEW TMJ / Bruxism):** +8 pages
  - **Block W5 (5.16 NEW Wear/Trauma):** +8 pages (incl ฟันแตก 3.6k goldmine)
  - **Block W6 (5.17 NEW Halitosis):** +9 pages
  - **Block W7 (5.18 NEW Xerostomia):** +7 pages
  - **Block W8 (5.19 NEW Post-Op & Recovery):** +11 pages
  - **Block W9 (5.20 NEW Pregnancy):** +8 pages
  - **Block W10 (5.21 NEW Choose Dentist/Clinic):** +8 pages
  - **Block W11 (5.8 Medical Comorbidities expansion):** +7 pages (cancer / immunocompromised / joint replacement / Bisphosphonate MRONJ ⚠️ / radiation / liver-kidney / autoimmune)
  - **Block W12 (5.22 NEW Lifestyle):** +6 pages
- `content-plan/entities.md` — 144 → 155 entities (+11 R5 Condition entities). New: dental-caries (Condition), white-spot-lesion, root-caries, dental-abscess, bruxism, tmj-disorder, halitosis, xerostomia, tooth-fracture, dry-socket, pregnancy-gingivitis. Re-tiered Implant brand entities' Primary Page references aligned.
- `content-plan/relationships.md` — 184 → 215 edges (+31 R5). V1-V7 sub-clusters of bidirectional reciprocal links: pain/caries cluster (7) / periodontal-gum (5) / TMJ-bruxism (4) / wear-trauma (3) / post-op (2) / halitosis multi-cause (4) / xerostomia cross-refs (3) + parent_of hierarchies. **18 of 31 = bidirectional** = high reciprocal density supporting DR-021 trigger.
- `content-plan/egp-output-summary.md` — Round 5 expansion note + recount.
- `docs/changelog.md` — this entry.
- `README.md` — page count 569 → ~664.

**DFS goldmine findings (Round 5 — 5 batches, 60+ keywords TH locale):**
- 🔥 **เหงือกบวม** 22,200/mo TH LOW (7) — previously single D-tier page, now Tier A hub + 8 sub-pages
- 🔥 **ฟันผุ** 22,200/mo TH LOW (3) — previously single D-tier page, now Tier A hub + 6 sub-pages
- 🔥 **เหงือกร่น** 9,900/mo TH LOW (21) — re-tiered C→A
- 🔥 **เลือดออกตามไรฟัน** 6,600/mo TH LOW (2)
- 🔥 **ฟันแตก** 3,600/mo TH LOW (6)
- **เด็กฟันผุ** 3,600/mo TH LOW (17)
- **ฟันเหลือง** 2,400/mo TH MEDIUM (53)
- **ปากแห้ง** 1,900/mo TH LOW (10)
- **ฟันโยก** 1,300/mo TH LOW (9)
- **ฟันบิ่น** 1,000/mo TH LOW (1)
- **ฟันสึก** 1,000/mo TH LOW
- **กลิ่นปาก** 590/mo TH MEDIUM (59)
- **น้ำลายเหม็น** 590/mo TH MEDIUM (51)
- **Combined goldmine: ~73,000/mo TH mostly LOW competition** = current Section 5 underpaged by ~10x volume coverage

**Strategic frame (Round 5):**
- **Section 5 = Pain-led intent** (broader/higher volume than Section 3 brand-led intent) — re-tier reflects actual demand reality
- **Bidirectional linking density** = DR-021 reciprocal-detection trigger has rich graph from day 1, not retrofitted
- **Concern → Service funnel architecture** preserved: each new concern hub links to relevant Section 3 services
- AI citation surface for "ปวดฟัน X" / "เหงือกบวม Y" / etc. queries — high E-E-A-T anchor density

**No new pending operator actions (Round 5 = DFS-driven, no operator data dependencies)**

**Next phase:** Round 6 = DFS Full Batch (Stage 1 Gate prerequisite) — full sitemap volume validation + final Tier optimization

---

## [2026-05-21 EVE] — Round 4 Q-Clinic SSO Cluster (Insurance & Access)

**By:** Operator-driven request "อยากให้มีเรื่องราวทุกมุมเกี่ยวกับประกันสังคม" + DFS reconnaissance
**Files updated:**
- `brand-config.json` — v1.5 → v1.6. Added `insurance_acceptance` block. **SSO Q-Clinic = TRUE (operator confirmed)** — direct billing, patient ไม่ต้องสำรองจ่าย. Annual cap 900 baht (operator to verify if 1,200 updated cap applies). Denture caps 1,500-4,400 baht/5yr by type. บัตรทอง / ราชการ acceptance TBD.
- `content-plan/clusters.md` — 18 → 19 clusters / 8 → 9 domains. NEW Domain I: Insurance & Access. NEW cluster: `insurance-coverage-th`.
- `content-plan/entities.md` — 139 → 144 entities (+5 R4). New Concept entities: `social-security-dental-benefit`, `sso-direct-billing-q-clinic` (brand-scope ['smile-scape'] = SmileScape's Q-Clinic differentiator), `universal-coverage-th` (บัตรทอง), `civil-servant-dental-benefit` (ราชการ/CGA), `private-dental-insurance-th`.
- `content-plan/relationships.md` — 171 → 184 edges (+13 R4). U section: Q-Clinic → SmileScape brand + branches (smilescape-rattanathibet + smilescape-srinakarin), SSO covers scaling/filling/extraction/wisdom-tooth/denture, alternative_to bait + civil servant + private, related_to dental-implant (upsell pathway — NOT covered).
- `content-plan/sitemap.md` — ~544p → ~569p (+25 R4). **Block R (3.12 SSO Service Hub):** +6 pages — hero positioning around Q-Clinic direct billing (3.12.2 Tier B). **Block S (5.13 expansion):** +13 pages — 10-page SSO sub-hub (900 บาท cap / scaling-filling-extraction / dentures / wisdom tooth / vs บัตรทอง / unemployment scenarios / ม.33-39-40 / family coverage / how-to-reimburse / Q-Clinic explainer) + ราชการ + private insurance + tax deduction. **Block T (Branch SSO 8.2.6 + 8.3.6):** +2 pages — local SSO landing for รัตนาธิเบศร์ + ศรีนครินทร์ branches. **Block U (Section 6 Insights):** +4 pages — 6.2.7 Insurance Insights ×3 (overview / Q-Clinic explainer / receipt requirements) + 6.5.5 SSO FAQ.
- `content-plan/egp-output-summary.md` — Round 4 expansion note + recount.
- `docs/changelog.md` — this entry.
- `README.md` — page count 544 → ~569 + pending operator: บัตรทอง/ราชการ acceptance + annual cap verification.

**DFS reconnaissance findings (Round 4):**
- ⭐ **คลินิก ทำฟัน ประกันสังคม [city]** — multi-city long-tail pattern (10-30/mo each in ลพบุรี/ลำปาง/ภูเก็ต/ดอนเมือง) → confirms branch-level SSO pages capture local intent
- ⭐ **ทำฟัน ประกันสังคม ไม่ต้องสำรองจ่าย** — high-intent navigational keyword → critical Q-Clinic positioning differentiator
- 📊 **ประกันสังคม 900** — 110/mo TH LOW competition (with declining trend May 2025 480 → Apr 2026 20 suggesting recent cap change awareness)
- 📊 **ประกันสังคม ทำฟัน ปลอมได้ไหม** — 30/mo TH commercial intent → denture coverage page priority
- 📊 **ประกันสังคม ทำฟัน 1200** — 10/mo transactional → cap year referenced in new cap or specific procedure cost
- 📊 **มีประกันสังคม ใช้บัตรทอง ทำฟัน ได้ไหม** — 10-30/mo → cross-coverage education opportunity
- 📊 **สามีข้าราชการ ภรรยาประกันสังคม ทำฟัน** — 10/mo → family/spousal coverage long-tail
- 📊 **ว่างงาน เบิกค่าทำฟัน ประกันสังคม** — active intent → ม.39 unemployment scenarios

**Strategic frame (Round 4):**
- **Q-Clinic positioning** = key differentiator most clinics either don't advertise or don't qualify for. SmileScape captures booking signal directly.
- Educational long-tail (5.13.2.1-10) builds topical authority + AI citation surface for "ประกันสังคมทำฟัน" Knowledge Graph
- **Conversion bridge** — Section 3.12.5 explicit upsell pathway "ทำพื้นฐานด้วยประกัน + ต่อยอด Implant/Aesthetic" — turns SSO entrants into premium service candidates
- Cross-coverage content (vs บัตรทอง / vs ราชการ / vs ประกันชีวิต) = unique angle, low competition

**Pending operator actions (added Round 4):**
- บัตรทอง / 30 บาท — SmileScape acceptance status + billing modality (affects 5.13.2.5 content)
- ราชการ / CGA (กรมบัญชีกลาง) — direct billing capability (affects 5.13.5)
- Private insurance — accepted insurer list (AIA / Cigna / Allianz / Muang Thai / etc.) (affects 5.13.6)
- Annual SSO cap verification — 900 vs 1,200 บาท (2026 status — affects 5.13.2.1 main content)
- Q-Clinic registration number (สำหรับ verify ที่หน้า website)

---

## [2026-05-21 PM] — Round 3 DFS-Informed Expansion (Peri-Implantitis Service + Gold Crown + ZBL Framework + Scaling Goldmine)

**By:** Operator-driven batch + DFS reconnaissance (4 batches, ~30 keywords TH locale)
**Files updated:**
- `brand-config.json` — v1.4 → v1.5. Added `clinical_protocols[0]` Zero Bone Loss Concept (Tomas Linkevicius framework — separate from signature_offerings per SS-DR-008). Extended `specialty_focus` with peri_implantitis_treatment, pediatric_dentistry, endodontics_specialist, sedation_dentistry (reflects R2 service additions).
- `content-plan/entities.md` — 131 → 139 entities (+8 R3). New: zero-bone-loss-concept (Concept, brand-scope smile-scape), dr-tomas-linkevicius (Person, external authority), gold-crown (Treatment — DFS 320/mo TH validated), peri-implantitis-treatment (Procedure), implantoplasty (Procedure), regenerative-peri-implantitis-surgery (Procedure), resective-peri-implantitis-surgery (Procedure), dental-laser-therapy (Procedure).
- `content-plan/relationships.md` — 151 → 171 edges (+20 R3). T1: ZBL Brand Framework edges (9) — evidenced_by Linkevicius, related_to dental-implant/warranty/SMILE-DNA/Family-Standard/keratinized-mucosa, dr-woraphat→ZBL+Linkevicius. T2: Peri-Implantitis Service edges (9). T3: Gold Crown edges (2).
- `content-plan/sitemap.md` — ~525p → ~544p (+19 R3). **Block N (Peri-Implantitis Service 3.7.7):** +10p hub + 9 sub-pages (Diagnosis / Non-surgical / Surgical / Regenerative / Resective / Implantoplasty / Laser / Decision tree / Maintenance) — DFS-validated 140/mo TH. **Block O (Gold Crown 3.4.4.4):** +2p (service page + 6.2.4.13 comparison) — DFS-validated 320/mo TH LOW competition. **Block P (Zero Bone Loss Framework):** +2p (2.1.6 brand framework page + 6.4.14 Linkevicius evidence summary) — DFS confirms low direct volume (20/mo), used as E-E-A-T anchor not traffic target. **Block Q (ขูดหินปูน cluster expansion 3.6.1):** +5p long-tail pages — DFS-discovered 12,100/mo TH LOW competition (R3 traffic goldmine). Plus header counts updated + Section 6 master structure recalc.
- `content-plan/egp-output-summary.md` — Round 3 expansion note + updated final tally (18 clusters / 139 entities / 171 edges / 5 signature offerings + 1 clinical protocol).
- `docs/decision-records.md` — Added **SS-DR-008** Zero Bone Loss Concept as Brand Clinical Framework (vs Signature Offering — operator decision). Rationale: ZBL = philosophy/approach, not a named procedure/technique like Sausage/Densah/Soft Tissue.
- `README.md` — page count 525 → ~544. Added pending operator: หมอแฮม Linkevicius training credential.
- `docs/changelog.md` — this entry.

**DFS reconnaissance findings (Round 3):**
- ✅ **peri-implantitis** 140/mo TH LOW competition → justifies dedicated service hub
- ✅ **gold crown** 320/mo TH LOW (CPC 6.75) → validates dedicated page (English term dominates; Thai variants returned no DFS data)
- ✅ **zero bone loss concept** 20/mo TH MEDIUM → confirms E-E-A-T anchor not traffic target
- ✅ **acteon** 90/mo TH LOW (CPC 1.88) → R2 brand-anchor approach validated
- 🎯 **ขูดหินปูน** 12,100/mo TH LOW (CPC 0.43) → MAJOR cluster opportunity discovered → Block Q added (5 long-tail pages)
- 📊 **ฟอกสีฟัน** 3,600/mo TH HIGH (89) → R2 Cool Light positioning validated as competitive niche
- 📊 **airflow** 1,600/mo TH LOW → ambiguous keyword (multi-meaning), R2 placement holds
- ⚠️ Many Thai service phrases returned NULL data (likely <50/mo OR DFS gap) — does not necessarily mean zero demand

**Strategic frame (Round 3):**
- ZBL chose Brand Framework over Signature Offering #6 — preserves meaning of "signature technique" (named procedures). ZBL joins SMILE DNA + Family Standard as brand triad.
- ขูดหินปูน goldmine discovery shows DFS-informed planning value before Phase next full DFS batch.
- Authority anchors (Urban / Huwais / Linkevicius / Kern) all in place — SmileScape "Global Mastery" claim now has 4 referenceable masters supporting Dr. Woraphat's credentials.

**Pending operator actions (added Round 3):**
- หมอแฮม Linkevicius training credential / Zero Bone Loss textbook ownership (for Section 2.2.2 + brand-config clinical_protocols[0] anchor)
- Peri-Implantitis specialist credential (if Periodontist on team)
- Gold crown supplier / lab confirmation (which gold alloy: noble/high-noble/PFM)

---

## [2026-05-21] — Round 2 Sitemap Expansion + Section 6 Restructure + Densah Signature

**By:** Operator-driven batch (10-point feedback + technique deep-dive + Section 6 restructure)
**Files updated:**
- `content-plan/sitemap.md` — ~414p → ~525p (+111). Added Section 3.9 Pediatric (13p), 3.10 Sedation/GA (8p), 3.11 Endo Specialist (10p). Expanded 3.2.9.4 Sinus Lift with Densah (+2), 3.2.9.5 Ridge Aug with RPM (+2), 3.2.9.7 Soft Tissue D-2 Hybrid (+13: 3 sub-hubs + 10 standalone Urban + named techniques), 3.4.7 Whitening with Cool Light (+3), 3.5.3 PSL clarification (+4), 3.5.8 Orthognathic Surgery (+9), 3.6.1 Scaling with Airflow (+3), 3.8.6 Torus Removal/Alveoloplasty (+5). Section 2.2 added Endo + Pediatric teams (+2). Section 4 rebrand: 4.2.1 → Acteon CBCT, 4.2.2 → 3Shape TRIOS. Added 4.4.4 Densah Bur, 4.4.5 Airflow, 4.9 Cosmetic Tech / Cool Light unit. Section 5 added 5.1.8 tooth-loss urgency hook, 5.10.7-8 jaw asymmetry, 5.11.5-9 gum concern hooks → world-class soft tissue funnel. **Section 6 restructured** into 6 sub-sections per operator decision: 6.1 Clinical Guides (Pillar) / 6.2 Clinical Insights (long-tail SEO, 78p) / 6.3 Glossary / 6.4 Clinical Evidence & Research Summaries (NEW, 14p) / 6.5 FAQ Knowledge Hub (NEW, 5p) / 6.6 Case-based Learning (NEW, 10p) — total 121p L5.
- `brand-config.json` — v1.3 → v1.4. Implant brands: Osstem out, Neodent in (Brazil, Straumann Group, value_premium). Signature offering #5 added: Internal Sinus Lift with Densah (Osseodensification, Salah Huwais authority). Soft tissue signature note expanded to include Urban techniques.
- `content-plan/entities.md` — 83 → 131 entities (+48 in R2). +3 specialty clusters (pediatric-dentistry 10, endodontics-specialist 7, dental-anesthesia 4). +5 bone-regen entities (densah-bur, osseodensification, internal-sinus-lift, lateral-window-sinus-lift, rpm-membrane). +9 soft-tissue entities (strip-graft, ice-berg, garage, vipct, caf, tunneling, vista, tcaf, black-triangle). +4 tech entities (acteon-cbct, trios-intraoral-scanner, airflow-air-polishing, cool-light-whitening-unit). +2 ortho (orthognathic-surgery, passive-self-ligating). +3 oral surgery (torus-removal, alveoloplasty, tuberectomy). Osstem-implant removed → replaced by neodent-implant.
- `content-plan/clusters.md` — 15 → 18 clusters across 8 domains. New Domain H: Specialty Services (pediatric / endo / anesthesia).
- `content-plan/relationships.md` — 101 → 151 edges (+50). New parent_of hierarchies for specialty clusters. New uses edges for Densah/RPM/microscope. New evidenced_by edges anchoring Urban + Huwais authority. Osstem→Neodent edge swap.
- `content-plan/egp-output-summary.md` — recalc all counts (cluster 18, entity 131, edge 151), updated domain coverage + entity type distribution + signature systems summary (5 instead of 4 — added Densah).
- `docs/decision-records.md` — SS-DR-001 updated (Osstem out / Neodent in / 4-tier brand strategy). **SS-DR-007 added** (Densah/Osseodensification as Signature Offering #5).
- `README.md` — page count ~414 → ~525. Added operator pending action: Dr. Woraphat Versah training credential confirmation for Densah signature anchor.
- `docs/changelog.md` — this entry.

**Trigger:** Operator review of 414p sitemap → 10-point feedback (Osstem swap, Neodent add, pediatric coverage, airflow scaling, cool light whitening, 3Shape IOS, Acteon CBCT, orthognathic surgery, GA dentistry, endodontist specialist) + soft tissue technique deep-dive (Urban Strip Graft/Ice Berg/Garage + classic CAF/Tunneling/VISTA/TCAF/VIPCT) + bone regen RPM membrane + Densah/Osseodensification signature decision + tooth-loss urgency + PSL clarification + black triangle + gum funnel concerns + Section 6 restructure.

**Strategic frame:**
- D-2 Hybrid soft tissue (13 pages) selected after explicit thin-page vs authority-strength trade-off analysis — operator delegated decision per content-quality-can-sustain-page evaluation per technique.
- Densah promoted to Signature #5 — pending operator confirmation of หมอแฮม Versah training certificate / Huwais workshop attendance.

**Pending operator actions (added Round 2):**
- Dr. Woraphat Versah training / Huwais workshop credential (for Section 2.2.2 + brand-config.json signature #5 anchor)
- Pediatric Team / Endodontist Team specialist names + credentials (for Section 2.2.9 + 2.2.10)
- Verify Neodent brand inventory (which series — GM / Drive / Easy Cone)
- Verify 3Shape TRIOS model (TRIOS 5 / TRIOS 4 / TRIOS Move)
- Verify Acteon CBCT model (X-Mind Trium / X-Mind Prime)

## [2026-05-12 PM] — Spec Stack Paired Batch Lock (v3.19 / v1.15 / v1.5 LOCKED / v1.13 / v1.13)

**By:** EYWA Protocol paired batch lock — operator-approved early lock (99.99%-Google-aligned assessment)
**Files updated:**
- `brand-config.json` — `eywa_spec_snapshot` block bumped: Bible 3.15→3.19, Schema 1.11→1.15, Templates DRAFT v1.3→v1.5 LOCKED, Handover 1.9→1.13, DR 1.9→1.13. DR-013/014/019/020/021/022 moved from proposed→locked (prior opt-in DR-020/021/022 now formalized). DR-026 + DR-027 added as proposed.

**Trigger:** Spec commits 1d347a4 (DR-013), e8c502a (DR-014), efd09cc (DR-019/020/021/022 paired batch).

**Impact on SmileScape:** SmileScape was the Lean Phase B field test — DR-022 lock validates the pattern. Content_Templates LOCKED at v1.5 (T1-T22) formalizes the templates used in 414p sitemap. DR-021 internal linking schema now available for Stage 1.5 entry (12 page_master linking cols + seo_page_internal_links junction).

## [2026-05-10] — Repo Bootstrap

Initialized eywa-smile-scape brand repo with full structure mirroring VTH BioDent layout.

**Files created:**
- `README.md` — brand overview + folder map
- `brand-config.json` — federation config (v1.0)
- `docs/brand-concept.md` — synthesized brand identity v1.0 (~13 sections)
- `docs/decision-records.md` — 6 brand-specific DRs locked (SS-DR-001..006)
- `docs/changelog.md` — this file

**Files migrated from legacy:**
- `content-plan/sitemap.md` — 414p WIP (pending client feedback)
- `docs/source-concept.md` — operator's original concept (preserved)
- `docs/research-deep-dive.md` — research from April 2026
- `docs/master-example-peri-implantitis.html` — sample content reference
- `docs/seo-playbook-original.html` — earlier SEO playbook
- `theme/brand-assets/` — 3 logo files (primary transparent + secondary + scaled)

**Folder structure created:**
```
docs/{signature-programs/}
content-plan/{archive/}
content-drafts/{pillar-pages, supporting-pages, citations}/
theme/{brand-assets, custom-css, elementor-templates-overrides}/
deployment/{acf-overrides/}
multilingual/
reports/
```

**Stage status (per EYWA Handover v1.6):**
- Phase A (Brand Understanding): ✅ DONE — brand-concept.md complete
- Phase B (Research): 🟡 PARTIAL — research-deep-dive.md done, full KW pending DataForSEO
- Phase B.2 (Citation Pool Seeding): ❌ NOT STARTED
- Phase C (Entity Genesis): ❌ NOT STARTED
- Phase D (Cluster & Domain): ❌ NOT STARTED
- Phase E (Sitemap): 🟡 IN PROGRESS — 414p WIP, pending client feedback
- Stage 1 Gate: ❌ NOT REACHED
- Stage 1.5 Migration: ❌ NOT STARTED (blocked by DR-021 lock 2026-06-07)
- Stage 2 Content Production: ❌ NOT STARTED

**Pending operator actions:**
1. Client feedback on 414p sitemap
2. Doctor Praeo full credentials
3. Branch addresses + contact details
4. Implant brand inventory completeness check
5. Technology inventory check
6. KW research data (DataForSEO)

---

*Initialized 2026-05-10 by Architect from operator's pre-EYWA work + memory synthesis*
