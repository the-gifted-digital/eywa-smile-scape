-- 03_citations.sql — seo_citations (SmileScape). MERGE: insert net-new only
-- (skip rows whose citation_slug/doi/pubmed_pmid already exist — shared ['*'] pool).
-- title synthesized from authors+journal+year (seed has no explicit title). tier5 -> brand scope.
insert into public.seo_citations
  (citation_slug, title, authors, publication_year, pubmed_pmid, doi,
   journal_name, citation_tier, citation_type, brand_scope)
select 'p1-c1','Howe MS, Keys W, Richards D. Journal of Dentistry. 2019.',array['Howe MS','Keys W','Richards D']::text[],2019,NULL,'10.1016/j.jdent.2019.03.008','Journal of Dentistry',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c1' or x.doi='10.1016/j.jdent.2019.03.008')
union all
select 'p1-c2','Kupka JR, König J, Al-Nawas B et al.. Clinical Oral Investigations. 2024.',array['Kupka JR','König J','Al-Nawas B et al.']::text[],2024,NULL,'10.1007/s00784-024-05929-3','Clinical Oral Investigations',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c2' or x.doi='10.1007/s00784-024-05929-3')
union all
select 'p1-c3','Pjetursson BE, Thoma D, Jung R et al.. Clinical Oral Implants Research. 2012.',array['Pjetursson BE','Thoma D','Jung R et al.']::text[],2012,NULL,'10.1111/j.1600-0501.2012.02546.x','Clinical Oral Implants Research',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c3' or x.doi='10.1111/j.1600-0501.2012.02546.x')
union all
select 'p1-c4','ทันตแพทยสภา (Dental Council of Thailand). หลักเกณฑ์การให้บริการทางทันตกรรม.',array['ทันตแพทยสภา (Dental Council of Thailand)']::text[],NULL,NULL,NULL,'หลักเกณฑ์การให้บริการทางทันตกรรม',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c4')
union all
select 'p1-c5','European Association for Osseointegration (EAO). EAO Consensus Report.',array['European Association for Osseointegration (EAO)']::text[],NULL,NULL,NULL,'EAO Consensus Report',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p1-c5')
union all
select 'p2-c1','Buser D, **Urban I**, Monje A et al.. Periodontology 2000. 2023.',array['Buser D','**Urban I**','Monje A et al.']::text[],2023,NULL,'10.1111/prd.12539','Periodontology 2000',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c1' or x.doi='10.1111/prd.12539')
union all
select 'p2-c2','**Urban IA**, Jovanovic SA, Lozada JL. Int J Oral Maxillofac Implants. 2009.',array['**Urban IA**','Jovanovic SA','Lozada JL']::text[],2009,'19587874',NULL,'Int J Oral Maxillofac Implants',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c2' or x.pubmed_pmid='19587874')
union all
select 'p2-c3','**Urban IA**, Lozada JL, Wessing B et al.. Int J Periodontics Restorative Dent. 2016.',array['**Urban IA**','Lozada JL','Wessing B et al.']::text[],2016,NULL,'10.11607/prd.2627','Int J Periodontics Restorative Dent',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c3' or x.doi='10.11607/prd.2627')
union all
select 'p2-c4','Milinkovic I, Cordaro L. Int J Oral Maxillofac Surg. 2014.',array['Milinkovic I','Cordaro L']::text[],2014,NULL,'10.1016/j.ijom.2013.12.004','Int J Oral Maxillofac Surg',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c4' or x.doi='10.1016/j.ijom.2013.12.004')
union all
select 'p2-c5','Urban IA. *Vertical and Horizontal Ridge Augmentation: New Concepts*. 2017.',array['Urban IA']::text[],2017,NULL,NULL,'*Vertical and Horizontal Ridge Augmentation: New Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c5')
union all
select 'p2-c6','SmileScape Clinic internal. Case audit: Sausage Technique outcomes 2024-2025.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Case audit: Sausage Technique outcomes 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p2-c6')
union all
select 'p3-c1','Abdunabi A, Morris M, Nader SA et al.. J Appl Oral Sci. 2019.',array['Abdunabi A','Morris M','Nader SA et al.']::text[],2019,NULL,'10.1590/1678-7757-2018-0600','J Appl Oral Sci',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c1' or x.doi='10.1590/1678-7757-2018-0600')
union all
select 'p3-c2','Tsigarida A, Chochlidakis K. Int J Prosthodont. 2021.',array['Tsigarida A','Chochlidakis K']::text[],2021,NULL,'10.11607/ijp.6911','Int J Prosthodont',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c2' or x.doi='10.11607/ijp.6911')
union all
select 'p3-c3','Cheng Q, Su YY, Wang X, Chen S. Int J Oral Maxillofac Implants. 2020.',array['Cheng Q','Su YY','Wang X','Chen S']::text[],2020,NULL,'10.11607/jomi.7548','Int J Oral Maxillofac Implants',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c3' or x.doi='10.11607/jomi.7548')
union all
select 'p3-c4','ILAPEO Brazil — consensus/teaching protocol. ILAPEO Immediate Loading Protocol.',array['ILAPEO Brazil — consensus/teaching protocol']::text[],NULL,NULL,NULL,'ILAPEO Immediate Loading Protocol',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c4')
union all
select 'p3-c5','SmileScape Clinic internal. All-on-X case audit 2024-2025.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'All-on-X case audit 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p3-c5')
union all
select 'p4-c1','Alhamwi AM, Burhan AS, Idris MI et al.. Clinical Oral Investigations. 2024.',array['Alhamwi AM','Burhan AS','Idris MI et al.']::text[],2024,NULL,'10.1007/s00784-024-05629-y','Clinical Oral Investigations',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c1' or x.doi='10.1007/s00784-024-05629-y')
union all
select 'p4-c2','TrioClear — Modern Dental Group. Clinical evidence documentation.',array['TrioClear — Modern Dental Group']::text[],NULL,NULL,NULL,'Clinical evidence documentation',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c2')
union all
select 'p4-c3','ADA / AAO. Clinical guideline on orthodontic treatment outcomes.',array['ADA / AAO']::text[],NULL,NULL,NULL,'Clinical guideline on orthodontic treatment outcomes',3,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c3')
union all
select 'p4-c4','SmileScape Clinic internal. TrioClear case audit 2024-2025.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'TrioClear case audit 2024-2025',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p4-c4')
union all
select 'p5-c1','Benic GI, Mir-Mari J, Hämmerle CHF. Int J Oral Maxillofac Implants. 2014.',array['Benic GI','Mir-Mari J','Hämmerle CHF']::text[],2014,NULL,'10.11607/jomi.2014suppl.g4.1','Int J Oral Maxillofac Implants',2,'meta_analysis',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c1' or x.doi='10.11607/jomi.2014suppl.g4.1')
union all
select 'p5-c2','EFP — European Federation of Periodontology. Consensus on peri-implant soft tissue management.',array['EFP — European Federation of Periodontology']::text[],NULL,NULL,NULL,'Consensus on peri-implant soft tissue management',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c2')
union all
select 'p5-c3','Ricardo Kern, Brazil — published technique. Soft tissue management protocol reference.',array['Ricardo Kern','Brazil — published technique']::text[],NULL,NULL,NULL,'Soft tissue management protocol reference',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c3')
union all
select 'p5-c4','SmileScape Clinic internal. Soft tissue management case audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Soft tissue management case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p5-c4')
union all
select 'p6-c1','**Urban IA**. *Vertical and Horizontal Ridge Augmentation: New Concepts*. 2017.',array['**Urban IA**']::text[],2017,NULL,NULL,'*Vertical and Horizontal Ridge Augmentation: New Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c1')
union all
select 'p6-c2','**Urban IA**, Monje A, Lozada JL. Various publications on soft tissue augmentation. 2017.',array['**Urban IA**','Monje A','Lozada JL']::text[],2017,NULL,NULL,'Various publications on soft tissue augmentation',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c2')
union all
select 'p6-c3','Tavelli L, Barootchi S, Avila-Ortiz G et al.. J Clin Periodontol — Root Coverage SR. 2018.',array['Tavelli L','Barootchi S','Avila-Ortiz G et al.']::text[],2018,NULL,NULL,'J Clin Periodontol — Root Coverage SR',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c3')
union all
select 'p6-c4','Zucchelli G, Mounssif I. Periodontology 2000 — CAF technique.',array['Zucchelli G','Mounssif I']::text[],NULL,NULL,NULL,'Periodontology 2000 — CAF technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c4')
union all
select 'p6-c5','Zadeh HH. Int J Periodontics Restorative Dent — VISTA technique. 2011.',array['Zadeh HH']::text[],2011,NULL,NULL,'Int J Periodontics Restorative Dent — VISTA technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c5')
union all
select 'p6-c6','Allen EP. J Periodontol — Tunneling technique. 1994.',array['Allen EP']::text[],1994,NULL,NULL,'J Periodontol — Tunneling technique',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c6')
union all
select 'p6-c7','Thoma DS, Naenni N, Figuero E et al.. J Clin Periodontol — Keratinized mucosa SR. 2018.',array['Thoma DS','Naenni N','Figuero E et al.']::text[],2018,'29498129',NULL,'J Clin Periodontol — Keratinized mucosa SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c7' or x.pubmed_pmid='29498129')
union all
select 'p6-c8','Avila-Ortiz G, Gonzalez-Martin O, Couso-Queiruga E, Wang HL. J Clin Periodontol — keratinized peri-implant SR. 2020.',array['Avila-Ortiz G','Gonzalez-Martin O','Couso-Queiruga E','Wang HL']::text[],2020,'32710810',NULL,'J Clin Periodontol — keratinized peri-implant SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c8' or x.pubmed_pmid='32710810')
union all
select 'p6-c9','SmileScape Clinic internal. Urban soft-tissue technique case audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Urban soft-tissue technique case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p6-c9')
union all
select 'p7-c1','**Huwais S**. Original osseodensification concept. 2017.',array['**Huwais S**']::text[],2017,NULL,NULL,'Original osseodensification concept',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c1')
union all
select 'p7-c2','Various authors. Osseodensification SR + meta-analysis. 2023.',array['Various authors']::text[],2023,'37975644',NULL,'Osseodensification SR + meta-analysis',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c2' or x.pubmed_pmid='37975644')
union all
select 'p7-c3','Various authors. Osseodensification clinical outcomes meta. 2023.',array['Various authors']::text[],2023,'38002660',NULL,'Osseodensification clinical outcomes meta',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c3' or x.pubmed_pmid='38002660')
union all
select 'p7-c4','Various authors. Densah sinus lift outcomes systematic review. 2025.',array['Various authors']::text[],2025,'40377845',NULL,'Densah sinus lift outcomes systematic review',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c4' or x.pubmed_pmid='40377845')
union all
select 'p7-c5','Various authors. Osseodensification bone density study. 2020.',array['Various authors']::text[],2020,'33139057',NULL,'Osseodensification bone density study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c5' or x.pubmed_pmid='33139057')
union all
select 'p7-c6','Various authors. Osseodensification bone density implant. 2020.',array['Various authors']::text[],2020,'33671038',NULL,'Osseodensification bone density implant',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c6' or x.pubmed_pmid='33671038')
union all
select 'p7-c7','Versah (manufacturer). Densah Bur clinical evidence documentation.',array['Versah (manufacturer)']::text[],NULL,NULL,NULL,'Densah Bur clinical evidence documentation',3,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c7')
union all
select 'p7-c8','SmileScape Clinic internal. Densah sinus lift case audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Densah sinus lift case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p7-c8')
union all
select 'p8-c1','**Linkevicius T**. *Zero Bone Loss Concepts*. 2019.',array['**Linkevicius T**']::text[],2019,NULL,NULL,'*Zero Bone Loss Concepts*',4,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c1')
union all
select 'p8-c2','**Linkevicius T**, Puisys A, Steigmann M et al.. Various crestal bone studies. 2010.',array['**Linkevicius T**','Puisys A','Steigmann M et al.']::text[],2010,NULL,NULL,'Various crestal bone studies',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c2')
union all
select 'p8-c3','Linkevicius T, Apse P, Grybauskas S, Puisys A. Clinical Oral Implants Research — Tissue thickness. 2009.',array['Linkevicius T','Apse P','Grybauskas S','Puisys A']::text[],2009,NULL,NULL,'Clinical Oral Implants Research — Tissue thickness',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c3')
union all
select 'p8-c4','Linkevicius T, Linkevicius R, Alkimavicius J et al.. Clinical Oral Implants Research — Subcrestal placement long-term. 2020.',array['Linkevicius T','Linkevicius R','Alkimavicius J et al.']::text[],2020,'32250061',NULL,'Clinical Oral Implants Research — Subcrestal placement long-term',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c4' or x.pubmed_pmid='32250061')
union all
select 'p8-c5','SmileScape Clinic internal. ZBL Protocol adoption + outcomes audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'ZBL Protocol adoption + outcomes audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p8-c5')
union all
select 'p9-c1','**Schwarz F**, Becker K, Sahm N et al.. EFP/AAP World Workshop Consensus on Peri-Implantitis. 2018.',array['**Schwarz F**','Becker K','Sahm N et al.']::text[],2018,'25626479',NULL,'EFP/AAP World Workshop Consensus on Peri-Implantitis',3,'expert_opinion',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c1' or x.pubmed_pmid='25626479')
union all
select 'p9-c2','Various — Schwarz peri-implantitis SR. J Clin Periodontol — Peri-implantitis treatment SR. 2023.',array['Various — Schwarz peri-implantitis SR']::text[],2023,'37271498',NULL,'J Clin Periodontol — Peri-implantitis treatment SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c2' or x.pubmed_pmid='37271498')
union all
select 'p9-c3','Recent peri-implantitis treatment. Clinical Oral Implants Research. 2025.',array['Recent peri-implantitis treatment']::text[],2025,'40501397',NULL,'Clinical Oral Implants Research',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c3' or x.pubmed_pmid='40501397')
union all
select 'p9-c4','EFP — European Federation of Periodontology. Peri-implantitis clinical practice guidelines. 2023.',array['EFP — European Federation of Periodontology']::text[],2023,NULL,NULL,'Peri-implantitis clinical practice guidelines',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c4')
union all
select 'p9-c5','Renvert S, Polyzois IN. Periodontology 2000 — Peri-implantitis decontamination. 2018.',array['Renvert S','Polyzois IN']::text[],2018,NULL,NULL,'Periodontology 2000 — Peri-implantitis decontamination',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c5')
union all
select 'p9-c6','SmileScape Clinic internal. Peri-implantitis salvage case audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Peri-implantitis salvage case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p9-c6')
union all
select 'p10-c1','AAPD (American Academy of Pediatric Dentistry). Reference Manual of Pediatric Dentistry.',array['AAPD (American Academy of Pediatric Dentistry)']::text[],NULL,NULL,NULL,'Reference Manual of Pediatric Dentistry',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c1')
union all
select 'p10-c2','WHO. Promoting oral health in children. 2022.',array['WHO']::text[],2022,NULL,NULL,'Promoting oral health in children',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c2')
union all
select 'p10-c3','Marinho VCC et al.. Cochrane — Fluoride varnishes for caries prevention. 2013.',array['Marinho VCC et al.']::text[],2013,NULL,NULL,'Cochrane — Fluoride varnishes for caries prevention',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c3')
union all
select 'p10-c4','Ahovuo-Saloranta A et al.. Cochrane — Pit and fissure sealants. 2017.',array['Ahovuo-Saloranta A et al.']::text[],2017,NULL,NULL,'Cochrane — Pit and fissure sealants',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c4')
union all
select 'p10-c5','ราชวิทยาลัยทันตแพทย์เด็ก (Royal College of Pediatric Dentistry Thailand). TH clinical guidelines.',array['ราชวิทยาลัยทันตแพทย์เด็ก (Royal College of Pediatric Dentistry Thailand)']::text[],NULL,NULL,NULL,'TH clinical guidelines',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c5')
union all
select 'p10-c6','SmileScape Clinic internal. Pediatric patient outcomes.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Pediatric patient outcomes',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p10-c6')
union all
select 'p11-c1','ESE (European Society of Endodontology). Quality guidelines for endodontic treatment. 2006.',array['ESE (European Society of Endodontology)']::text[],2006,NULL,NULL,'Quality guidelines for endodontic treatment',1,'clinical_guideline',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c1')
union all
select 'p11-c2','AAE (American Association of Endodontists). Treatment standards + position papers.',array['AAE (American Association of Endodontists)']::text[],NULL,NULL,NULL,'Treatment standards + position papers',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c2')
union all
select 'p11-c3','Setzer FC, Kim S. J Endod — Endodontic microscope success. 2014.',array['Setzer FC','Kim S']::text[],2014,NULL,NULL,'J Endod — Endodontic microscope success',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c3')
union all
select 'p11-c4','Setzer FC, Shah SB, Kohli MR et al.. J Endod — Apicoectomy outcomes SR. 2010.',array['Setzer FC','Shah SB','Kohli MR et al.']::text[],2010,NULL,NULL,'J Endod — Apicoectomy outcomes SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c4')
union all
select 'p11-c5','SmileScape Clinic internal. Endodontic specialist case audit.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Endodontic specialist case audit',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p11-c5')
union all
select 'p12-c1','AAPD. Behavior Guidance + Sedation Reference Manual.',array['AAPD']::text[],NULL,NULL,NULL,'Behavior Guidance + Sedation Reference Manual',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c1')
union all
select 'p12-c2','ASA (American Society of Anesthesiologists). Practice guidelines for moderate procedural sedation. 2018.',array['ASA (American Society of Anesthesiologists)']::text[],2018,NULL,NULL,'Practice guidelines for moderate procedural sedation',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c2')
union all
select 'p12-c3','ราชวิทยาลัยทันตแพทย์ — ทันตกรรมประดิษฐ์ / วิสัญญี. Thai guidelines for dental sedation.',array['ราชวิทยาลัยทันตแพทย์ — ทันตกรรมประดิษฐ์ / วิสัญญี']::text[],NULL,NULL,NULL,'Thai guidelines for dental sedation',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c3')
union all
select 'p12-c4','Various — pediatric sedation SR. Cochrane / J Dent Anesth Pain Med. 2020.',array['Various — pediatric sedation SR']::text[],2020,NULL,NULL,'Cochrane / J Dent Anesth Pain Med',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c4')
union all
select 'p12-c5','SmileScape Clinic internal. Sedation cases + anesthesiologist team.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Sedation cases + anesthesiologist team',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p12-c5')
union all
select 'p14-c1','Halitosis. Aylıkcı BU, Çolak H.',array['Halitosis']::text[],NULL,NULL,NULL,'Aylıkcı BU, Çolak H',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c1')
union all
select 'p14-c2','Halitosis. ADA.',array['Halitosis']::text[],NULL,NULL,NULL,'ADA',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c2')
union all
select 'p14-c3','Xerostomia. Tanasiewicz M, Hildebrandt T, Obersztyn I.',array['Xerostomia']::text[],NULL,NULL,NULL,'Tanasiewicz M, Hildebrandt T, Obersztyn I',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c3')
union all
select 'p14-c4','Bruxism. Manfredini D, Lobbezoo F.',array['Bruxism']::text[],NULL,NULL,NULL,'Manfredini D, Lobbezoo F',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c4')
union all
select 'p14-c5','TMJ. de Leeuw R, Klasser GD.',array['TMJ']::text[],NULL,NULL,NULL,'de Leeuw R, Klasser GD',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c5')
union all
select 'p14-c6','Dry Socket. Daly BJM, Sharif MO, Newton T et al.',array['Dry Socket']::text[],NULL,NULL,NULL,'Daly BJM, Sharif MO, Newton T et al.',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c6')
union all
select 'p14-c7','MRONJ. **AAOMS Position Paper** — Medication-Related Osteonecrosis of the Jaw. 2022.',array['MRONJ']::text[],2022,NULL,NULL,'**AAOMS Position Paper** — Medication-Related Osteonecrosis of the Jaw',3,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c7')
union all
select 'p14-c8','MRONJ. Ruggiero SL, Dodson TB, Aghaloo T et al.',array['MRONJ']::text[],NULL,NULL,NULL,'Ruggiero SL, Dodson TB, Aghaloo T et al.',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c8')
union all
select 'p14-c9','MRONJ. Various — MRONJ extraction outcomes SR. 2023.',array['MRONJ']::text[],2023,'37449761',NULL,'Various — MRONJ extraction outcomes SR',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p14-c9' or x.pubmed_pmid='37449761')
union all
select 'p15-c1','WHO. Ending childhood dental caries: WHO implementation manual. 2019.',array['WHO']::text[],2019,NULL,NULL,'Ending childhood dental caries: WHO implementation manual',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c1')
union all
select 'p15-c2','ADA — Council on Scientific Affairs. Topical fluoride for caries prevention.',array['ADA — Council on Scientific Affairs']::text[],NULL,NULL,NULL,'Topical fluoride for caries prevention',1,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c2')
union all
select 'p15-c3','Walsh T et al.. Cochrane — Fluoride toothpastes for caries prevention. 2019.',array['Walsh T et al.']::text[],2019,NULL,NULL,'Cochrane — Fluoride toothpastes for caries prevention',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c3')
union all
select 'p15-c4','Pitts NB, Zero DT, Marsh PD et al.. Nat Rev Dis Primers — Dental caries. 2017.',array['Pitts NB','Zero DT','Marsh PD et al.']::text[],2017,NULL,NULL,'Nat Rev Dis Primers — Dental caries',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c4')
union all
select 'p15-c5','Ahovuo-Saloranta A et al.. Cochrane — Pit and fissure sealants. 2017.',array['Ahovuo-Saloranta A et al.']::text[],2017,NULL,NULL,'Cochrane — Pit and fissure sealants',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c5')
union all
select 'p15-c6','Hayes M et al.. J Dent Res — Root caries SR. 2016.',array['Hayes M et al.']::text[],2016,NULL,NULL,'J Dent Res — Root caries SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c6')
union all
select 'p15-c7','SmileScape Clinic internal. Caries patient outcomes.',array['SmileScape Clinic internal']::text[],NULL,NULL,NULL,'Caries patient outcomes',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p15-c7')
union all
select 'p16-c1','Direct Print outcomes. Various — Direct 3D printed aligner. 2022.',array['Direct Print outcomes']::text[],2022,'36311049',NULL,'Various — Direct 3D printed aligner',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c1' or x.pubmed_pmid='36311049')
union all
select 'p16-c2','Material properties. Various — Photopolymer aligner materials. 2021.',array['Material properties']::text[],2021,'33916462',NULL,'Various — Photopolymer aligner materials',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c2' or x.pubmed_pmid='33916462')
union all
select 'p16-c3','Clinical outcomes 2024. Various — Recent Direct Print clinical. 2024.',array['Clinical outcomes 2024']::text[],2024,'39921085',NULL,'Various — Recent Direct Print clinical',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c3' or x.pubmed_pmid='39921085')
union all
select 'p16-c4','Direct Print vs Thermoformed. Various — Comparison study. 2024.',array['Direct Print vs Thermoformed']::text[],2024,'38337260',NULL,'Various — Comparison study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c4' or x.pubmed_pmid='38337260')
union all
select 'p16-c5','2025 Systematic Review. Various — Direct Print SR. 2025.',array['2025 Systematic Review']::text[],2025,'40123039',NULL,'Various — Direct Print SR',2,'systematic_review',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c5' or x.pubmed_pmid='40123039')
union all
select 'p16-c6','Tera Harz TC-85 specific. Various — TC-85 material study. 2025.',array['Tera Harz TC-85 specific']::text[],2025,'42076391',NULL,'Various — TC-85 material study',2,'other',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c6' or x.pubmed_pmid='42076391')
union all
select 'p16-c7','Manufacturer. Graphy Inc — TC-85DAC FDA clearance + clinical.',array['Manufacturer']::text[],NULL,NULL,NULL,'Graphy Inc — TC-85DAC FDA clearance + clinical',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c7')
union all
select 'p16-c8','Manufacturer. Tera Harz / Versa Wax — TC-85 documentation.',array['Manufacturer']::text[],NULL,NULL,NULL,'Tera Harz / Versa Wax — TC-85 documentation',3,'industry_publication',array['*']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c8')
union all
select 'p16-c9','Brand. SmileScape Clinic internal.',array['Brand']::text[],NULL,NULL,NULL,'SmileScape Clinic internal',5,'other',array['smile-scape-clinic']::text[] where not exists (select 1 from public.seo_citations x where x.citation_slug='p16-c9')
;

-- validation
select count(*) ours_present from public.seo_citations where citation_slug like 'p%-c%';
