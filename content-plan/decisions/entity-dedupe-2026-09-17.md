# D5 — entity dedupe candidates (similarity layer run 2026-09-17, wave 16cl)

SOP: memory `similarity-layer-before-dedupe` + `eywa-vth-biodent/content-plan/similarity-layer-2026-08-06.md` · winner rule = DR-046 (`load_from`; ลำดับ Deezy → VTH → smile-scape; ไม่ใช่จำนวนหน้า) · loser: `entity_lifecycle='merged'` + `aliases.merged_from` บนผู้ชนะ + ลบ embedding ของ loser · ห้ามลบแถว

## สิ่งที่ทำก่อนอ่าน view
- re-embed 178 entity (source_text drift หลัง D3/D4 rewrite 166 + ใหม่ 8) ด้วย `eywa-protocol-spec/scripts/entity-identity/embed-entities.mjs` (รันจาก `/Volumes/SSD NN/CLAUDE AI/tmp/embed-run` symlink node_modules ของ vth) → 710/710 สด · script ฝั่ง vth `web/scripts/embed-entities.mjs` ล้าสมัย (ยัง `.neq lifecycle`) — spec เป็นตัวจริง
- view ผลรวม: `v_entity_near_duplicates` 45 คู่ (key = `fingerprint` ent_… ไม่ใช่ slug — ต้อง join กลับ) · `v_entity_semantic_duplicates` 21 คู่ · scope ที่แตะ entity ที่หน้า smile-scape ใช้ = 35 คู่ + 16 กลุ่มจาก D2 audit

## ตารางตัดสิน (usage = brand P<primary>/R<related>, หน้า active)

### A. smile-scape ต้องย้ายหน้าไปหาผู้ชนะ (DR-046 ข้อ 4)
| # | loser (smile ใช้) | winner | เหตุผล | ผลกระทบ |
|---|---|---|---|---|
| A1 | `cbct` Cone Beam CT — smile R29 · vth P2/R20 · wikidata Q1224951 | `cbct-scan` 3D CBCT Scan — **load_from deezy** · deezy P1/R37 smile P7/R6 vth R10 | procedure เดียวกัน · cos 0.250 (สรุปเคยขัดกันเรื่อง dose — แก้แล้วใน D3) | smile 29 related · vth 22 (แจ้ง vth) · ย้าย wikidata ไปผู้ชนะ |
| A2 | `private-dental-insurance-th` (TH Dental) — smile P2/R17 | `private-insurance-dental` — **load_from deezy** · deezy P8/R8 vth P1 | ชื่อต่างแค่ "(TH)" trgm 0.94 · concept เดียวกัน | smile 19 (primary 5.13.4 · 5.13.6) |
| A3 | `dental-scaling` (cluster restorative ✗) — smile P8/R8 · + `scaling` vth P4 | `scaling-polishing` — **load_from deezy** · cluster preventive-general ✓ · deezy P3/R8 | ขูดหินปูน routine 3 ชื่อ 3 คลัสเตอร์ | smile 16 (primary 3.4.1.x ×8) · vth 4 (แจ้ง) |
| A4 | `pregnancy-dental-care` (treatment, demographic-dentistry) — smile P2/R6 | `pregnancy-dental` (concept, cross-cutting) — deezy P1 vth P2 · ไม่มี load_from ทั้งคู่ → ลำดับแบรนด์ | trgm 0.79 หัวข้อเดียวกัน | smile 8 (primary 3.13.2 · 5.8.3) · type จะกลายเป็น concept |
| A5 | `dental-anxiety` "Dental Anxiety / Phobia" (cluster dental-anesthesia ✗) — smile P1/R10 | `dental-phobia` (cross-cutting) — vth P1/R8 · ไม่มี load_from ทั้งคู่ → VTH นำ | condition เดียวกัน trgm 0.64 | smile 11 (primary 5.4.4) · เสนอ rename ผู้ชนะเป็น "Dental Anxiety / Phobia" (กว้างกว่า) |

### B. คิว VTH/Deezy — smile ไม่ต้องขยับ (แจ้งต่อ ไม่ทำเอง)
| คู่ | winner (DR-046) | หมายเหตุ |
|---|---|---|
| `deep-cleaning` (vth 8) → `deep-scaling` (deezy-loaded; smile 15 อยู่ผู้ชนะแล้ว) | deep-scaling | trgm 0.83 cos 0.183 |
| `prf-technology` (vth 3) → `prf-platelet-rich-fibrin` (deezy 2 smile 9 vth 2) | prf-platelet-rich-fibrin | device เดียวกัน |
| `viscosupplementation-tmj` (vth 2) → `ha-injection-tmj` (smile 5 vth 12) | ha-injection-tmj | HA = viscosupplementation |
| `pediatric-dentist` (deezy 3) → `pediatric-dentistry` (smile 29) | pediatric-dentistry | type specialty ทั้งคู่ · deezy ตัดสิน |
| `pediatric-sealant` (deezy 1) → `dental-sealant` | dental-sealant | cluster_conflict · deezy ตัดสิน |
| vth-only: `nightlase-snoring`↔`nightlase` · `sleep-study`↔`polysomnography` (cos 0.156 nsim 0.00) · `oral-appliance-therapy`↔`mad` · `myofunctional-therapy`↔`omt-airway`↔`certified-myologist` · `uv-implant`↔`uv-device` · `gbt-airflow-prophylaxis`↔`gbt-airflow` · `aligner-vs-braces`(deezy-loaded)↔`braces-vs-aligner`(vth 1) | — | อยู่ใน similarity doc ของ vth แล้วบางส่วน |

### C. ไม่ยุบ — หัวคำ vs คำมุม / ชนิดต่างกัน (DR-048)
`laser-perio` vs `periodontal-treatment` (modality ⊂ treatment) · `periodontal-disease` vs `periodontitis` (umbrella vs specific, wikidata ต่างกัน) · `peri-implantitis` (condition) vs `peri-implantitis-treatment` · `alveolar-bone-loss` (condition) vs `alveolar-bone` (anatomy) · `tmj-disorder` (condition) vs `tmj-pain` (symptom) · `tmj-injection` (umbrella) vs corticosteroid/HA · `zygomatic-system` (device, smile R2) vs `zygomatic-implant` (treatment) — แบบเดียวกับ Nobel Biocare vs Nobel Biocare Implant · `single-missing-tooth` vs `missing-tooth` · `all-on-4/5/6/X` · `immediate-loading` vs `full-arch-immediate-loading`

### D. entity ต้องห้าม (operator 2026-09-17)
`universal-coverage-th` · `civil-servant-dental-benefit` — หลัง wave 16cl ไม่มีหน้าแบรนด์ไหนใช้ (0 ทั้ง 3 แบรนด์) → เสนอ `entity_lifecycle='dropped'` + note (ห้ามลบแถวตาม DR-046 ข้อ 3)

## เกตปิดงาน (จาก SOP)
trigram-pairs ที่ smile ใช้ทั้งสองฝั่ง = 0 · semantic cluster_conflict = 0 · embedding ที่ชี้ entity merged = 0
