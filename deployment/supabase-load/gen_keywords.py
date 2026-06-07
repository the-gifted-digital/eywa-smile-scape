# deployment/supabase-load/gen_keywords.py
from _lib import *

kws = []; seen = set(); infence = False
for ln in open(SRC + "/keyword-seed-list.md", encoding="utf-8"):
    s = ln.rstrip("\n")
    if s.lstrip().startswith("```"):
        infence = not infence; continue
    if not infence: continue
    k = s.strip()
    if not k or k.startswith("#") or k.startswith("|"): continue
    k = k.split("  ")[0].strip()           # drop trailing intent tags if any
    if "[" in k or "]" in k: continue       # skip template/annotation placeholders ([service]/[BRAND]/[condition])
    if k in seen: continue
    seen.add(k); kws.append(k)
print("unique keywords:", len(kws))

vals = ",\n".join("  (" + q(k) + ")" for k in kws)
sql = ("-- 10_keywords.sql — seed SmileScape keyword LIST into seo_x_ads_keywords_contextual_master.\n"
       "-- Load keyword + brand only; DFS full run enriches metrics/SERP/intent afterward.\n"
       "-- fingerprint = '{brand_lower}::{loc}::{lang}::{kw}'; loc/lang pulled byte-exact from a TH row\n"
       "--   so DFS (same fingerprint) UPDATEs these seeded rows. brand='Smile Scape Clinic'.\n"
       "-- Source: content-plan/keyword-seed-list.md (" + str(len(kws)) + " unique).\n"
       "insert into public.seo_x_ads_keywords_contextual_master (fingerprint, keyword, brand)\n"
       "select 'smile scape clinic::'||loc.l||'::'||loc.g||'::'||k.kw, k.kw, 'Smile Scape Clinic'\n"
       "from (values\n" + vals + "\n) as k(kw)\n"
       "cross join (\n"
       "  select split_part(fingerprint,'::',2) l, split_part(fingerprint,'::',3) g\n"
       "  from public.seo_x_ads_keywords_contextual_master\n"
       "  where brand='TC Smile Dental' and fingerprint like '%::%::%::%'\n"
       "  limit 1\n) loc\n"
       "on conflict (fingerprint) do nothing;\n\n"
       "-- validation\n"
       "select count(*) ss_keywords,\n"
       "       count(*) filter (where fingerprint like 'smile scape clinic::%') fp_ok\n"
       "from public.seo_x_ads_keywords_contextual_master where brand='Smile Scape Clinic';\n")
open(OUT + "/10_keywords.sql", "w", encoding="utf-8").write(sql)
print("bytes:", len(sql), "-> 10_keywords.sql")
