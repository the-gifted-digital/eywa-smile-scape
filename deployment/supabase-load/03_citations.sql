-- 03_citations.sql — seo_citations (SmileScape). MERGE: insert net-new only
-- (skip rows whose citation_slug/doi/pubmed_pmid already exist — shared ['*'] pool).
-- title synthesized from authors+journal+year (seed has no explicit title). tier5 -> brand scope.
insert into public.seo_citations
  (citation_slug, title, authors, publication_year, pubmed_pmid, doi,
   journal_name, citation_tier, citation_type, brand_scope)
select 'p1-c1','Howe MS, Keys W, Richards D. Journal of Dentistry. 2019.','Howe MS, Keys W, Richards D',2019,NULL,'10.1016/j.jdent.2019.03.008','Journal of Dentistry',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c1' or x.doi='10.1016/j.jdent.2019.03.008')
union all
select 'p1-c2','Kupka JR, König J, Al-Nawas B et al.. Clinical Oral Investigations. 2024.','Kupka JR, König J, Al-Nawas B et al.',2024,NULL,'10.1007/s00784-024-05929-3','Clinical Oral Investigations',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c2' or x.doi='10.1007/s00784-024-05929-3')
union all
select 'p1-c3','Pjetursson BE, Thoma D, Jung R et al.. Clinical Oral Implants Research. 2012.','Pjetursson BE, Thoma D, Jung R et al.',2012,NULL,'10.1111/j.1600-0501.2012.02546.x','Clinical Oral Implants Research',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c3' or x.doi='10.1111/j.1600-0501.2012.02546.x')
union all
select 'p1-c4','ทันตแพทยสภา (Dental Council of Thailand). หลักเกณฑ์การให้บริการทางทันตกรรม.','ทันตแพทยสภา (Dental Council of Thailand)',NULL,NULL,NULL,'หลักเกณฑ์การให้บริการทางทันตกรรม',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c4')
union all
select 'p1-c5','European Association for Osseointegration (EAO). EAO Consensus Report.','European Association for Osseointegration (EAO)',NULL,NULL,NULL,'EAO Consensus Report',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c5')
union all
select 'p2-c1','Buser D, **Urban I**, Monje A et al.. Periodontology 2000. 2023.','Buser D, **Urban I**, Monje A et al.',2023,NULL,'10.1111/prd.12539','Periodontology 2000',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c1' or x.doi='10.1111/prd.12539')
union all
select 'p2-c2','**Urban IA**, Jovanovic SA, Lozada JL. Int J Oral Maxillofac Implants. 2009.','**Urban IA**, Jovanovic SA, Lozada JL',2009,'19587874',NULL,'Int J Oral Maxillofac Implants',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c2' or x.pubmed_pmid='19587874')
union all
select 'p2-c3','**Urban IA**, Lozada JL, Wessing B et al.. Int J Periodontics Restorative Dent. 2016.','**Urban IA**, Lozada JL, Wessing B et al.',2016,NULL,'10.11607/prd.2627','Int J Periodontics Restorative Dent',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c3' or x.doi='10.11607/prd.2627')
union all
select 'p2-c4','Milinkovic I, Cordaro L. Int J Oral Maxillofac Surg. 2014.','Milinkovic I, Cordaro L',2014,NULL,'10.1016/j.ijom.2013.12.004','Int J Oral Maxillofac Surg',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c4' or x.doi='10.1016/j.ijom.2013.12.004')
union all
select 'p2-c5','Urban IA. *Vertical and Horizontal Ridge Augmentation: New Concepts*. 2017.','Urban IA',2017,NULL,NULL,'*Vertical and Horizontal Ridge Augmentation: New Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c5')
union all
select 'p2-c6','SmileScape Clinic internal. Case audit: Sausage Technique outcomes 2024-2025.','SmileScape Clinic internal',NULL,NULL,NULL,'Case audit: Sausage Technique outcomes 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c6')
union all
select 'p3-c1','Abdunabi A, Morris M, Nader SA et al.. J Appl Oral Sci. 2019.','Abdunabi A, Morris M, Nader SA et al.',2019,NULL,'10.1590/1678-7757-2018-0600','J Appl Oral Sci',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c1' or x.doi='10.1590/1678-7757-2018-0600')
union all
select 'p3-c2','Tsigarida A, Chochlidakis K. Int J Prosthodont. 2021.','Tsigarida A, Chochlidakis K',2021,NULL,'10.11607/ijp.6911','Int J Prosthodont',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c2' or x.doi='10.11607/ijp.6911')
union all
select 'p3-c3','Cheng Q, Su YY, Wang X, Chen S. Int J Oral Maxillofac Implants. 2020.','Cheng Q, Su YY, Wang X, Chen S',2020,NULL,'10.11607/jomi.7548','Int J Oral Maxillofac Implants',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c3' or x.doi='10.11607/jomi.7548')
union all
select 'p3-c4','ILAPEO Brazil — consensus/teaching protocol. ILAPEO Immediate Loading Protocol.','ILAPEO Brazil — consensus/teaching protocol',NULL,NULL,NULL,'ILAPEO Immediate Loading Protocol',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c4')
union all
select 'p3-c5','SmileScape Clinic internal. All-on-X case audit 2024-2025.','SmileScape Clinic internal',NULL,NULL,NULL,'All-on-X case audit 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c5')
union all
select 'p4-c1','Alhamwi AM, Burhan AS, Idris MI et al.. Clinical Oral Investigations. 2024.','Alhamwi AM, Burhan AS, Idris MI et al.',2024,NULL,'10.1007/s00784-024-05629-y','Clinical Oral Investigations',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c1' or x.doi='10.1007/s00784-024-05629-y')
union all
select 'p4-c2','TrioClear — Modern Dental Group. Clinical evidence documentation.','TrioClear — Modern Dental Group',NULL,NULL,NULL,'Clinical evidence documentation',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c2')
union all
select 'p4-c3','ADA / AAO. Clinical guideline on orthodontic treatment outcomes.','ADA / AAO',NULL,NULL,NULL,'Clinical guideline on orthodontic treatment outcomes',3,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c3')
union all
select 'p4-c4','SmileScape Clinic internal. TrioClear case audit 2024-2025.','SmileScape Clinic internal',NULL,NULL,NULL,'TrioClear case audit 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c4')
union all
select 'p5-c1','Benic GI, Mir-Mari J, Hämmerle CHF. Int J Oral Maxillofac Implants. 2014.','Benic GI, Mir-Mari J, Hämmerle CHF',2014,NULL,'10.11607/jomi.2014suppl.g4.1','Int J Oral Maxillofac Implants',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c1' or x.doi='10.11607/jomi.2014suppl.g4.1')
union all
select 'p5-c2','EFP — European Federation of Periodontology. Consensus on peri-implant soft tissue management.','EFP — European Federation of Periodontology',NULL,NULL,NULL,'Consensus on peri-implant soft tissue management',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c2')
union all
select 'p5-c3','Ricardo Kern, Brazil — published technique. Soft tissue management protocol reference.','Ricardo Kern, Brazil — published technique',NULL,NULL,NULL,'Soft tissue management protocol reference',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c3')
union all
select 'p5-c4','SmileScape Clinic internal. Soft tissue management case audit.','SmileScape Clinic internal',NULL,NULL,NULL,'Soft tissue management case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c4')
union all
select 'p6-c1','**Urban IA**. *Vertical and Horizontal Ridge Augmentation: New Concepts*. 2017.','**Urban IA**',2017,NULL,NULL,'*Vertical and Horizontal Ridge Augmentation: New Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c1')
union all
select 'p6-c2','**Urban IA**, Monje A, Lozada JL. Various publications on soft tissue augmentation. 2017.','**Urban IA**, Monje A, Lozada JL',2017,NULL,NULL,'Various publications on soft tissue augmentation',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c2')
union all
select 'p6-c3','Tavelli L, Barootchi S, Avila-Ortiz G et al.. J Clin Periodontol — Root Coverage SR. 2018.','Tavelli L, Barootchi S, Avila-Ortiz G et al.',2018,NULL,NULL,'J Clin Periodontol — Root Coverage SR',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c3')
union all
select 'p6-c4','Zucchelli G, Mounssif I. Periodontology 2000 — CAF technique.','Zucchelli G, Mounssif I',NULL,NULL,NULL,'Periodontology 2000 — CAF technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c4')
union all
select 'p6-c5','Zadeh HH. Int J Periodontics Restorative Dent — VISTA technique. 2011.','Zadeh HH',2011,NULL,NULL,'Int J Periodontics Restorative Dent — VISTA technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c5')
union all
select 'p6-c6','Allen EP. J Periodontol — Tunneling technique. 1994.','Allen EP',1994,NULL,NULL,'J Periodontol — Tunneling technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c6')
union all
select 'p6-c7','Thoma DS, Naenni N, Figuero E et al.. J Clin Periodontol — Keratinized mucosa SR. 2018.','Thoma DS, Naenni N, Figuero E et al.',2018,'29498129',NULL,'J Clin Periodontol — Keratinized mucosa SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c7' or x.pubmed_pmid='29498129')
union all
select 'p6-c8','Avila-Ortiz G, Gonzalez-Martin O, Couso-Queiruga E, Wang HL. J Clin Periodontol — keratinized peri-implant SR. 2020.','Avila-Ortiz G, Gonzalez-Martin O, Couso-Queiruga E, Wang HL',2020,'32710810',NULL,'J Clin Periodontol — keratinized peri-implant SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c8' or x.pubmed_pmid='32710810')
union all
select 'p6-c9','SmileScape Clinic internal. Urban soft-tissue technique case audit.','SmileScape Clinic internal',NULL,NULL,NULL,'Urban soft-tissue technique case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c9')
union all
select 'p7-c1','**Huwais S**. Original osseodensification concept. 2017.','**Huwais S**',2017,NULL,NULL,'Original osseodensification concept',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c1')
union all
select 'p7-c2','Various authors. Osseodensification SR + meta-analysis. 2023.','Various authors',2023,'37975644',NULL,'Osseodensification SR + meta-analysis',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c2' or x.pubmed_pmid='37975644')
union all
select 'p7-c3','Various authors. Osseodensification clinical outcomes meta. 2023.','Various authors',2023,'38002660',NULL,'Osseodensification clinical outcomes meta',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c3' or x.pubmed_pmid='38002660')
union all
select 'p7-c4','Various authors. Densah sinus lift outcomes systematic review. 2025.','Various authors',2025,'40377845',NULL,'Densah sinus lift outcomes systematic review',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c4' or x.pubmed_pmid='40377845')
union all
select 'p7-c5','Various authors. Osseodensification bone density study. 2020.','Various authors',2020,'33139057',NULL,'Osseodensification bone density study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c5' or x.pubmed_pmid='33139057')
union all
select 'p7-c6','Various authors. Osseodensification bone density implant. 2020.','Various authors',2020,'33671038',NULL,'Osseodensification bone density implant',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c6' or x.pubmed_pmid='33671038')
union all
select 'p7-c7','Versah (manufacturer). Densah Bur clinical evidence documentation.','Versah (manufacturer)',NULL,NULL,NULL,'Densah Bur clinical evidence documentation',3,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c7')
union all
select 'p7-c8','SmileScape Clinic internal. Densah sinus lift case audit.','SmileScape Clinic internal',NULL,NULL,NULL,'Densah sinus lift case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c8')
union all
select 'p8-c1','**Linkevicius T**. *Zero Bone Loss Concepts*. 2019.','**Linkevicius T**',2019,NULL,NULL,'*Zero Bone Loss Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c1')
union all
select 'p8-c2','**Linkevicius T**, Puisys A, Steigmann M et al.. Various crestal bone studies. 2010.','**Linkevicius T**, Puisys A, Steigmann M et al.',2010,NULL,NULL,'Various crestal bone studies',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c2')
union all
select 'p8-c3','Linkevicius T, Apse P, Grybauskas S, Puisys A. Clinical Oral Implants Research — Tissue thickness. 2009.','Linkevicius T, Apse P, Grybauskas S, Puisys A',2009,NULL,NULL,'Clinical Oral Implants Research — Tissue thickness',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c3')
union all
select 'p8-c4','Linkevicius T, Linkevicius R, Alkimavicius J et al.. Clinical Oral Implants Research — Subcrestal placement long-term. 2020.','Linkevicius T, Linkevicius R, Alkimavicius J et al.',2020,'32250061',NULL,'Clinical Oral Implants Research — Subcrestal placement long-term',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c4' or x.pubmed_pmid='32250061')
union all
select 'p8-c5','SmileScape Clinic internal. ZBL Protocol adoption + outcomes audit.','SmileScape Clinic internal',NULL,NULL,NULL,'ZBL Protocol adoption + outcomes audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c5')
union all
select 'p9-c1','**Schwarz F**, Becker K, Sahm N et al.. EFP/AAP World Workshop Consensus on Peri-Implantitis. 2018.','**Schwarz F**, Becker K, Sahm N et al.',2018,'25626479',NULL,'EFP/AAP World Workshop Consensus on Peri-Implantitis',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c1' or x.pubmed_pmid='25626479')
union all
select 'p9-c2','Various — Schwarz peri-implantitis SR. J Clin Periodontol — Peri-implantitis treatment SR. 2023.','Various — Schwarz peri-implantitis SR',2023,'37271498',NULL,'J Clin Periodontol — Peri-implantitis treatment SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c2' or x.pubmed_pmid='37271498')
union all
select 'p9-c3','Recent peri-implantitis treatment. Clinical Oral Implants Research. 2025.','Recent peri-implantitis treatment',2025,'40501397',NULL,'Clinical Oral Implants Research',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c3' or x.pubmed_pmid='40501397')
union all
select 'p9-c4','EFP — European Federation of Periodontology. Peri-implantitis clinical practice guidelines. 2023.','EFP — European Federation of Periodontology',2023,NULL,NULL,'Peri-implantitis clinical practice guidelines',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c4')
union all
select 'p9-c5','Renvert S, Polyzois IN. Periodontology 2000 — Peri-implantitis decontamination. 2018.','Renvert S, Polyzois IN',2018,NULL,NULL,'Periodontology 2000 — Peri-implantitis decontamination',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c5')
union all
select 'p9-c6','SmileScape Clinic internal. Peri-implantitis salvage case audit.','SmileScape Clinic internal',NULL,NULL,NULL,'Peri-implantitis salvage case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c6')
union all
select 'p10-c1','AAPD (American Academy of Pediatric Dentistry). Reference Manual of Pediatric Dentistry.','AAPD (American Academy of Pediatric Dentistry)',NULL,NULL,NULL,'Reference Manual of Pediatric Dentistry',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c1')
union all
select 'p10-c2','WHO. Promoting oral health in children. 2022.','WHO',2022,NULL,NULL,'Promoting oral health in children',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c2')
union all
select 'p10-c3','Marinho VCC et al.. Cochrane — Fluoride varnishes for caries prevention. 2013.','Marinho VCC et al.',2013,NULL,NULL,'Cochrane — Fluoride varnishes for caries prevention',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c3')
union all
select 'p10-c4','Ahovuo-Saloranta A et al.. Cochrane — Pit and fissure sealants. 2017.','Ahovuo-Saloranta A et al.',2017,NULL,NULL,'Cochrane — Pit and fissure sealants',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c4')
union all
select 'p10-c5','ราชวิทยาลัยทันตแพทย์เด็ก (Royal College of Pediatric Dentistry Thailand). TH clinical guidelines.','ราชวิทยาลัยทันตแพทย์เด็ก (Royal College of Pediatric Dentistry Thailand)',NULL,NULL,NULL,'TH clinical guidelines',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c5')
union all
select 'p10-c6','SmileScape Clinic internal. Pediatric patient outcomes.','SmileScape Clinic internal',NULL,NULL,NULL,'Pediatric patient outcomes',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c6')
union all
select 'p11-c1','ESE (European Society of Endodontology). Quality guidelines for endodontic treatment. 2006.','ESE (European Society of Endodontology)',2006,NULL,NULL,'Quality guidelines for endodontic treatment',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c1')
union all
select 'p11-c2','AAE (American Association of Endodontists). Treatment standards + position papers.','AAE (American Association of Endodontists)',NULL,NULL,NULL,'Treatment standards + position papers',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c2')
union all
select 'p11-c3','Setzer FC, Kim S. J Endod — Endodontic microscope success. 2014.','Setzer FC, Kim S',2014,NULL,NULL,'J Endod — Endodontic microscope success',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c3')
union all
select 'p11-c4','Setzer FC, Shah SB, Kohli MR et al.. J Endod — Apicoectomy outcomes SR. 2010.','Setzer FC, Shah SB, Kohli MR et al.',2010,NULL,NULL,'J Endod — Apicoectomy outcomes SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c4')
union all
select 'p11-c5','SmileScape Clinic internal. Endodontic specialist case audit.','SmileScape Clinic internal',NULL,NULL,NULL,'Endodontic specialist case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c5')
union all
select 'p12-c1','AAPD. Behavior Guidance + Sedation Reference Manual.','AAPD',NULL,NULL,NULL,'Behavior Guidance + Sedation Reference Manual',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c1')
union all
select 'p12-c2','ASA (American Society of Anesthesiologists). Practice guidelines for moderate procedural sedation. 2018.','ASA (American Society of Anesthesiologists)',2018,NULL,NULL,'Practice guidelines for moderate procedural sedation',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c2')
union all
select 'p12-c3','ราชวิทยาลัยทันตแพทย์ — ทันตกรรมประดิษฐ์ / วิสัญญี. Thai guidelines for dental sedation.','ราชวิทยาลัยทันตแพทย์ — ทันตกรรมประดิษฐ์ / วิสัญญี',NULL,NULL,NULL,'Thai guidelines for dental sedation',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c3')
union all
select 'p12-c4','Various — pediatric sedation SR. Cochrane / J Dent Anesth Pain Med. 2020.','Various — pediatric sedation SR',2020,NULL,NULL,'Cochrane / J Dent Anesth Pain Med',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c4')
union all
select 'p12-c5','SmileScape Clinic internal. Sedation cases + anesthesiologist team.','SmileScape Clinic internal',NULL,NULL,NULL,'Sedation cases + anesthesiologist team',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c5')
union all
select 'p14-c1','Halitosis. Aylıkcı BU, Çolak H.','Halitosis',NULL,NULL,NULL,'Aylıkcı BU, Çolak H',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c1')
union all
select 'p14-c2','Halitosis. ADA.','Halitosis',NULL,NULL,NULL,'ADA',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c2')
union all
select 'p14-c3','Xerostomia. Tanasiewicz M, Hildebrandt T, Obersztyn I.','Xerostomia',NULL,NULL,NULL,'Tanasiewicz M, Hildebrandt T, Obersztyn I',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c3')
union all
select 'p14-c4','Bruxism. Manfredini D, Lobbezoo F.','Bruxism',NULL,NULL,NULL,'Manfredini D, Lobbezoo F',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c4')
union all
select 'p14-c5','TMJ. de Leeuw R, Klasser GD.','TMJ',NULL,NULL,NULL,'de Leeuw R, Klasser GD',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c5')
union all
select 'p14-c6','Dry Socket. Daly BJM, Sharif MO, Newton T et al.','Dry Socket',NULL,NULL,NULL,'Daly BJM, Sharif MO, Newton T et al.',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c6')
union all
select 'p14-c7','MRONJ. **AAOMS Position Paper** — Medication-Related Osteonecrosis of the Jaw. 2022.','MRONJ',2022,NULL,NULL,'**AAOMS Position Paper** — Medication-Related Osteonecrosis of the Jaw',3,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c7')
union all
select 'p14-c8','MRONJ. Ruggiero SL, Dodson TB, Aghaloo T et al.','MRONJ',NULL,NULL,NULL,'Ruggiero SL, Dodson TB, Aghaloo T et al.',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c8')
union all
select 'p14-c9','MRONJ. Various — MRONJ extraction outcomes SR. 2023.','MRONJ',2023,'37449761',NULL,'Various — MRONJ extraction outcomes SR',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c9' or x.pubmed_pmid='37449761')
union all
select 'p15-c1','WHO. Ending childhood dental caries: WHO implementation manual. 2019.','WHO',2019,NULL,NULL,'Ending childhood dental caries: WHO implementation manual',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c1')
union all
select 'p15-c2','ADA — Council on Scientific Affairs. Topical fluoride for caries prevention.','ADA — Council on Scientific Affairs',NULL,NULL,NULL,'Topical fluoride for caries prevention',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c2')
union all
select 'p15-c3','Walsh T et al.. Cochrane — Fluoride toothpastes for caries prevention. 2019.','Walsh T et al.',2019,NULL,NULL,'Cochrane — Fluoride toothpastes for caries prevention',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c3')
union all
select 'p15-c4','Pitts NB, Zero DT, Marsh PD et al.. Nat Rev Dis Primers — Dental caries. 2017.','Pitts NB, Zero DT, Marsh PD et al.',2017,NULL,NULL,'Nat Rev Dis Primers — Dental caries',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c4')
union all
select 'p15-c5','Ahovuo-Saloranta A et al.. Cochrane — Pit and fissure sealants. 2017.','Ahovuo-Saloranta A et al.',2017,NULL,NULL,'Cochrane — Pit and fissure sealants',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c5')
union all
select 'p15-c6','Hayes M et al.. J Dent Res — Root caries SR. 2016.','Hayes M et al.',2016,NULL,NULL,'J Dent Res — Root caries SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c6')
union all
select 'p15-c7','SmileScape Clinic internal. Caries patient outcomes.','SmileScape Clinic internal',NULL,NULL,NULL,'Caries patient outcomes',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c7')
union all
select 'p16-c1','Direct Print outcomes. Various — Direct 3D printed aligner. 2022.','Direct Print outcomes',2022,'36311049',NULL,'Various — Direct 3D printed aligner',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c1' or x.pubmed_pmid='36311049')
union all
select 'p16-c2','Material properties. Various — Photopolymer aligner materials. 2021.','Material properties',2021,'33916462',NULL,'Various — Photopolymer aligner materials',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c2' or x.pubmed_pmid='33916462')
union all
select 'p16-c3','Clinical outcomes 2024. Various — Recent Direct Print clinical. 2024.','Clinical outcomes 2024',2024,'39921085',NULL,'Various — Recent Direct Print clinical',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c3' or x.pubmed_pmid='39921085')
union all
select 'p16-c4','Direct Print vs Thermoformed. Various — Comparison study. 2024.','Direct Print vs Thermoformed',2024,'38337260',NULL,'Various — Comparison study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c4' or x.pubmed_pmid='38337260')
union all
select 'p16-c5','2025 Systematic Review. Various — Direct Print SR. 2025.','2025 Systematic Review',2025,'40123039',NULL,'Various — Direct Print SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c5' or x.pubmed_pmid='40123039')
union all
select 'p16-c6','Tera Harz TC-85 specific. Various — TC-85 material study. 2025.','Tera Harz TC-85 specific',2025,'42076391',NULL,'Various — TC-85 material study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c6' or x.pubmed_pmid='42076391')
union all
select 'p16-c7','Manufacturer. Graphy Inc — TC-85DAC FDA clearance + clinical.','Manufacturer',NULL,NULL,NULL,'Graphy Inc — TC-85DAC FDA clearance + clinical',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c7')
union all
select 'p16-c8','Manufacturer. Tera Harz / Versa Wax — TC-85 documentation.','Manufacturer',NULL,NULL,NULL,'Tera Harz / Versa Wax — TC-85 documentation',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c8')
union all
select 'p16-c9','Brand. SmileScape Clinic internal.','Brand',NULL,NULL,NULL,'SmileScape Clinic internal',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c9')
;

-- validation
select count(*) ours_present from public.seo_citations where citation_slug like 'p%-c%';
