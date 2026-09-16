# Citation audit vs PubMed — ช่วง C (wave 16ch, 2026-09-17)

## ขอบเขตและวิธี

- seo_citations 979 แถว · มี pubmed_pmid 908 · ไม่มี PMID 71 (DOI 1 · ไม่มีทั้งคู่ 70 — ส่วนใหญ่ load_source ของแบรนด์อื่น/guideline ไทย ตรวจกับ PubMed ไม่ได้)
- ดึง metadata จริงจาก PubMed ด้วย E-utilities efetch (batch 200 PMID × 5 calls) — แหล่งเดียวกับ PubMed MCP แต่ไม่ต้องยิง 908 tool calls · **ไม่พบ PMID ที่หายจาก PubMed · ไม่พบ retraction**
- เทียบ 3 ชั้น: (1) title ratio (SequenceMatcher) (2) year/url/retraction (3) key_findings vs abstract — เชิงกลก่อน (คำอังกฤษ + ตัวเลขใน key_findings ต้องพบใน abstract ≥70%) แถวที่ยืนยันเชิงกลไม่ได้ → **อ่าน abstract เทียบทีละแถว inline** (ไม่ใช้ agent ตามที่ตกลง)
- ขอบเขตการแก้: เฉพาะแถวที่ผูกกับหน้า smile-scape (715 แถว / มี PMID 692) · แถว brand_scope=vth-biodent และแถว `*` ที่หน้าเราไม่ใช้ → รายงานอย่างเดียว ไม่แตะ

## ผล

| ชั้น | ตรวจ | ผ่านเชิงกล | อ่านเอง | ผิดจริง | แก้ |
|---|---|---|---|---|---|
| title | 908 | 885 | 23 | 23 (ratio<0.85 — paper เดียวกันทั้งหมด แค่ตัด/ย่อ/สะกด) | 20 linked แก้ตาม PubMed · 3 ไม่ linked รายงาน |
| key_findings เนื้อหา | 908 | 659 | **158 linked อ่านครบ** | **0 wrong-paper · 0 overclaim** | — |
| key_findings NULL | 5 | — | — | 5 | 2 linked เขียนจาก abstract · 3 ไม่ linked (37380944, 36260463, 36995724 scope `*`) รายงาน |
| citation_type | 908 | — | 60 flag → อ่าน 40 linked | 8 | 8 [TIER-FIX] |
| year | 908 | 907 | 1 | 36115712 DB 2022 / PubMed 2024 (epub vs print) | ไม่แก้ |
| url ไม่ใช่ pubmed | 99 | — | — | DOI url ถูกต้อง (G4 ผ่าน) | ไม่ใช่ปัญหา |

**ข้อค้นพบหลัก: key_findings ที่ผูกกับหน้า smile-scape ทั้ง 158 แถวที่อ่าน ตรงกับ abstract ทุกแถว** — ตัวเลข (n, %, OR, HR, CI) ที่อ้างใน key_findings ตรวจพบใน abstract ครบ · element แบบ ⚠️/🔴/💡 เป็น writer-guidance ที่สอดคล้องกับข้อจำกัดที่ abstract ระบุ · ข้อผิดพลาดแบบ 33270049/21366627 (แก้ไปแล้วรอบก่อน) ไม่พบซ้ำ

## [TIER-FIX] 8 แถว (citation_type → tier)

| PMID | เดิม | ใหม่ | เหตุผล |
|---|---|---|---|
| 33339979 | cross_sectional/5 | expert_opinion/6 | EBD critical summary (pubtype Comment) |
| 26486206 | cohort_study/5 | expert_opinion/6 (study_type in_vitro) | SEM in-vitro |
| 23633830 | cohort_study/5 | expert_opinion/6 | narrative review |
| 21998774 | cohort_study/5 | expert_opinion/6 | narrative review |
| 36311049 | cohort_study/5 | expert_opinion/6 | narrative review |
| 38858787 | rct/2 | cross_sectional/5 | registration-accuracy study ไม่มี intervention |
| 37370027 | rct/2 | expert_opinion/6 (study_type in_vitro) | in-vitro crossover ในนักศึกษา |
| 39654301 | systematic_review/1 | expert_opinion/6 | scoping review → expert_opinion ตาม STUDY_TYPE_SYNONYM (COMMENT 08-24 ใหม่กว่า log 08-18 ที่เลือก tier 5 "ไม่มีฐาน") |

## ที่ดูแล้ว **ไม่แก้** (ambiguous — บันทึกไว้ให้ gate owner)

- 6 guideline ที่ PubMed tag ทั้ง Practice Guideline + Systematic Review (31668170, 25626479, 37634915, 25639826, 38449041, 24177407) — คง clinical_guideline/T3; G14 รายงาน study_type=SR ตามที่ออกแบบ
- 33680330 (abstract = SR 175→19 studies แต่ PubMed index แค่ Review) stored expert_opinion — COMMENT อนุญาตทั้งสองทาง
- 25123761 Periodontol 2000 (PubMed tag SR แต่เนื้อหาเป็น narrative) stored expert_opinion — คง
- 30496104 GBD 2017 stored systematic_review — เป็น modelling study ไม่ใช่ SR ของ trial แต่ไม่มี type ที่ตรงใน CHECK 17 ค่า
- SR/MA ปี 2024–2026 ที่ PubMed ยังไม่ index pubtype (8 แถว) — คง
- 25 consensus/position paper stored clinical_guideline แม้ PubMed ไม่ tag Practice Guideline — เป็น guideline-class จริง คง

## Backlog นอก scope (ไม่แตะ)

- แถวไม่ linked กับหน้า smile-scape ที่ยืนยันเชิงกลไม่ได้ **69 แถว** (scope `*` 58 · vth-biodent 11) — ถ้าแบรนด์ไหนจะผูกใช้ ต้องอ่านเทียบ abstract ก่อน: 39347062, 34185861, 36206494, 36231647, 41581901, 41366915, 26854877, 17625094, 36552293, 38825767, 38443242, 28987222, 32234083, 27578151, 39342210, 28012784, 36001494, 34954846, 41648698, 37380944, 11314315, 38571778, 34204017, 27694789, 37186539, 39076626, 31588866, 41138999, 41114452, 36991526, 36260463, 31858481, 38198389, 37273018, 40633480, 37847828, 30065258, 37047909, 36068685, 34779939, 40645839, 36995724, 20831934, 33998045, 36358372, 22580543, 34146924, 40118084, 29926497, 31002742, 33820631, 38132412, 36525781, 37753744, 39395893, 33141943, 37612199, 37589382, 27741329, 30818312, 31605905, 40838275, 32699903, 42447651, 32560622, 40476896, 40084997, 38300176, 35356038
- title ไม่ตรง 3 แถว scope `*` ไม่ linked: 30554035 (0.69) · 36595096 (0.71) · 36643274 (0.64) — paper เดียวกัน แค่สะกด/ตัด
- key_findings NULL 3 แถว scope `*` ไม่ linked: 37380944 · 36260463 · 36995724
- 4 แถว PubMed ไม่มี abstract (29334501 ASA sedation guideline · 17474923 · 21632481 · 26580836) — key_findings มี 385–627 ตัวอักษร ตรวจกับ abstract ไม่ได้ ต้องเทียบ full text ถ้าจะยืนยัน
- 71 แถวไม่มี PMID — ตรวจกับ PubMed ไม่ได้ (ส่วนใหญ่ guideline ไทย/แหล่ง Crossref)

## maintenance_log

ทุกแถว linked ที่มี PMID (692) ได้บรรทัด `[PMID-VERIFY 2026-09-17 wave16ch]` ระบุ title ratio · วิธีตรวจ key_findings (อ่านเอง / เชิงกล) · การแก้ถ้ามี — ตาม COMMENT ของ verification_status
