#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SmileScape — Client Content & SEO Master Plan (deliverable generator).

Reads the planning files in content-plan/ and emits a client-facing, English-primary,
A4 print-ready HTML report (combined report.html + per-section files) using the
house "business proposal" visual design. All internal methodology references
(spec versions, decision-record IDs, round/phase/stage labels, infra names) are
scrubbed — the client sees the finished plan, framed as The Gifted -> SmileScape.

Run: python3 reports/client-summary/build_report.py
"""
import os, re, html, shutil
from string import Template

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, "..", ".."))
CP   = os.path.join(ROOT, "content-plan")
SECT = os.path.join(BASE, "sections"); os.makedirs(SECT, exist_ok=True)
ASSET= os.path.join(BASE, "assets");   os.makedirs(ASSET, exist_ok=True)

PREPARED_DATE = "30 May 2026"
PAGES = "726"

def read(p):
    with open(p, encoding="utf-8") as f:
        return f.read()

# ============================================================================
# SCRUBBER — strip internal methodology references for the client-facing doc
# ============================================================================
# inline token scrub (applied to every rendered line of source markdown)
_SCRUB = [
    (re.compile(r'\bSS-DR-\d+\b'), ''),
    (re.compile(r'\bDR-\d+(/\d+)*\b'), ''),
    (re.compile(r'\bRound\s*\d+\b', re.I), ''),
    (re.compile(r'\(\s*R\d+[^)]*\)'), ''),
    (re.compile(r'\bR\d+\s+(expansion|baseline|lock|recount|confirmed|verified|promoted|validated|addition[s]?|note[s]?)\b', re.I), ''),
    (re.compile(r',\s*R\d+\b[^)]*?(?=\))'), ''),       # ", R14 — 2.4 consolidated -4" inside parens
    (re.compile(r'\bR\d+\b'), ''),                      # any remaining bare round-number tag
    (re.compile(r'\bAppendix\s*[A-Z](?:\.\d+)?\b'), ''),
    (re.compile(r'\bDB\b'), ''), (re.compile(r'\bentity_type\b'), ''),
    (re.compile(r'\bPhase\s*[A-F](?:\.\d+)?\b'), ''),
    (re.compile(r'\bStage\s*1(?:\.5)?\b'), ''),
    (re.compile(r'\bBible(\s*Part\s*[\d.]+)?(\s*v[\d.]+)?', re.I), ''),
    (re.compile(r'Handover\s*§?\s*[\d.]*', re.I), ''),
    (re.compile(r'\bSchema(\s*v[\d.]+|\s*§\s*[\d.]+|_Overview\s*§[\d.]+)?', re.I), 'schema'),
    (re.compile(r'\bTemplates?\s*v[\d.]+[^.,)]*', re.I), ''),
    (re.compile(r'\bbrand-config(\.json)?\b'), 'brand configuration'),
    (re.compile(r'\bEUG[\w-]*\b'), ''),
    (re.compile(r'\beug_preflight[\w()]*'), ''),
    (re.compile(r'\bSupabase\b', re.I), 'the database'),
    (re.compile(r'\bn8n\b', re.I), 'automation'),
    (re.compile(r'\basync\b', re.I), ''),
    (re.compile(r'\(\s*automation[^)]*\)'), ''),
    (re.compile(r'\bauto-trigger\b[^).]*', re.I), ''),
    (re.compile(r'\bvol-driven\b', re.I), 'demand-driven'),
    (re.compile(r'\bINSERT\b'), ''),
    (re.compile(r'\bKD enrichment\b', re.I), 'difficulty data'),
    (re.compile(r'\bflat-load\b', re.I), 'data load'),
    (re.compile(r'\bfederation\b', re.I), 'multi-brand'),
    (re.compile(r'\bcontextual_master\b'), ''),
    (re.compile(r'\bseo_[a-z_]+\b'), ''),
    (re.compile(r'\bDFS[- ]?(validated|informed|MCP|goldmine)?\b', re.I), 'search-data'),
    (re.compile(r'VOLUME-IMMUNE', re.I), 'always-on'),
    (re.compile(r'\bLayer\s*1\b'), 'core'),
    (re.compile(r'\bLayer\s*2\b'), 'demand-driven'),
    (re.compile(r'\bP\d+-C\d+\b'), ''),
    (re.compile(r'\bEYWA Protocol(\s*v[\d.]+)?', re.I), 'our methodology'),
    (re.compile(r'\bEYWA\b'), 'our'),
    (re.compile(r'\boperator(-driven|-supplied|-confirmed)?\b', re.I), 'clinic'),
    (re.compile(r'\bTBD\b'), 'to be confirmed'),
    (re.compile(r'\bbrand_scope\s*=?\s*\[[^\]]*\]', re.I), ''),
    (re.compile(r"\['\*'\]"), 'Universal'),
    (re.compile(r"\['smile-scape'\]"), 'Brand-specific'),
    (re.compile(r'\bcpt_activation[\w]*'), ''),
    (re.compile(r'\bclinical_protocols\[\d+\]'), 'clinical protocol'),
    (re.compile(r'\bsignature_offerings?\b'), 'signature offering'),
    (re.compile(r'\s*—\s*(?=[.,)])'), ''),           # dangling em-dash left after removals
    (re.compile(r'\(\s*[,/;·]*\s*\)'), ''),           # empty parens left after removals
    (re.compile(r'\s{2,}'), ' '),
]
def scrub(s):
    for rx, rep in _SCRUB:
        s = rx.sub(rep, s)
    return s.strip(' ·—-,')

# ============================================================================
# Markdown -> HTML (subset) with cleaning controls
# ============================================================================
def _inline(s):
    s = html.escape(s, quote=False)
    s = re.sub(r'\[([^\]]+)\]\(([^)]+)\)', r'<a href="\2">\1</a>', s)
    s = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', s)
    s = re.sub(r'(?<!\*)\*([^*\n]+)\*(?!\*)', r'<em>\1</em>', s)
    s = re.sub(r'`([^`]+)`', r'<code>\1</code>', s)
    return s

def _is_sep(line):
    return bool(re.match(r'^\s*\|?[\s:|-]+\|[\s:|-]*$', line)) and '-' in line

def _cells(line):
    line = line.strip()
    if line.startswith('|'): line = line[1:]
    if line.endswith('|'):   line = line[:-1]
    return [c.strip() for c in line.split('|')]

# internal heading sections to drop entirely (match: heading text contains any token)
DROP_HEADINGS = [
    'eug', 'pre-flight', 'preflight', 'operator action', 'next phase', 'phase c', 'phase d',
    'handover', 'reuse check', 'freshness audit', 'brand stance topics', 'cross-brand',
    'coverage audit', 'how to use this file', 'output file index', 'cluster mapping check',
    'local seo summary', 'graph health', 'scope', 'tier hierarchy', 'edge vocabulary',
    'pillar-supporting ratio', 'icd-10 coverage', 'entity type distribution',
    'relationship coverage', 'brand scope split', 'domain coverage', 'signature system summary',
    'pillar-cluster', 'vocabulary', 'next phase trigger', 'freshness audit', 'reuse check',
]
# paragraph prefixes to drop (internal notes inside otherwise-kept sections)
DROP_PARA = ('operator action', 'brand stance note', 'pubmed notes', 'operator', 'strategic gain',
             'strategic rationale', 'brand stance', '> ', 'eug', 'phase d note', 'note:')

def clean_lines(md, drop_headings=DROP_HEADINGS):
    """Remove internal heading-sections, blockquotes, italic footers, internal paragraphs."""
    lines = md.split('\n')
    out, i, n = [], 0, len(lines)
    skip_until_level = None
    while i < n:
        line = lines[i]
        hm = re.match(r'^(#{1,6})\s+(.*)$', line)
        if hm:
            lvl = len(hm.group(1)); txt = hm.group(2).lower()
            if skip_until_level is not None and lvl > skip_until_level:
                i += 1; continue
            skip_until_level = None
            if any(tok in txt for tok in drop_headings):
                skip_until_level = lvl; i += 1; continue
            out.append(line); i += 1; continue
        if skip_until_level is not None:
            i += 1; continue
        # drop blockquotes
        if line.lstrip().startswith('>'):
            i += 1; continue
        # drop italic-only footer lines  *....*
        if re.match(r'^\s*\*[^*].*\*\s*$', line) and '**' not in line:
            i += 1; continue
        # drop internal paragraphs by prefix
        low = re.sub(r'^\s*[-*]\s*', '', line).lower().lstrip('*> ')
        if any(low.startswith(p) for p in DROP_PARA):
            i += 1; continue
        out.append(line); i += 1
    return '\n'.join(out)

def md_to_html(md, keep_cols=None, drop_cols=None, do_scrub=True):
    """keep_cols/drop_cols: lists of lowercased header-name substrings to keep/drop."""
    lines = md.split('\n'); out, i, n = [], 0, len(lines)
    def maybe_scrub(s): return scrub(s) if do_scrub else s
    while i < n:
        line = lines[i]
        if line.strip().startswith('```'):
            i += 1; chips = []
            while i < n and not lines[i].strip().startswith('```'):
                t = lines[i].strip()
                if t and not t.startswith('['):
                    chips.append('<span class="kw">%s</span>' % html.escape(maybe_scrub(t), quote=False))
                i += 1
            i += 1
            if chips: out.append('<div class="kwgrid">%s</div>' % ''.join(chips))
            continue
        if '|' in line and (i+1) < n and _is_sep(lines[i+1]):
            header = _cells(line); i += 2; body = []
            while i < n and '|' in lines[i] and lines[i].strip():
                body.append(_cells(lines[i])); i += 1
            cols = len(header)
            # column selection
            idx = list(range(cols))
            if keep_cols:
                idx = [j for j in idx if j < len(header) and any(k in header[j].lower() for k in keep_cols)]
            if drop_cols:
                idx = [j for j in idx if not any(k in header[j].lower() for k in drop_cols)]
            if not idx: idx = list(range(cols))
            ncols = len(idx)
            cls = 'wide' if ncols >= 7 else ('mid' if ncols >= 5 else '')
            t = ['<table class="%s"><thead><tr>' % cls]
            for j in idx:
                t.append('<th>%s</th>' % _inline(header[j] if j < len(header) else ''))
            t.append('</tr></thead><tbody>')
            for r in body:
                if len(r) < cols: r += [''] * (cols - len(r))
                cellvals = [maybe_scrub(r[j]) for j in idx]
                if all(c in ('', '—', '-') for c in cellvals[1:]):   # drop annotation-only rows
                    continue
                t.append('<tr>' + ''.join('<td>%s</td>' % _inline(c) for c in cellvals) + '</tr>')
            t.append('</tbody></table>')
            out.append(''.join(t)); continue
        hm = re.match(r'^(#{1,6})\s+(.*)$', line)
        if hm:
            lvl = len(hm.group(1)); txt = maybe_scrub(hm.group(2).strip())
            txt = re.sub(r'^[a-z0-9]+(?:-[a-z0-9]+)+:\s+', '', txt)   # strip "kebab-slug: " cluster prefix
            if lvl == 1: i += 1; continue
            tag = {2:'h3',3:'h4',4:'h5',5:'h6',6:'h6'}[lvl]
            if txt: out.append('<%s class="md">%s</%s>' % (tag, _inline(txt), tag))
            i += 1; continue
        if re.match(r'^\s*---+\s*$', line):
            out.append('<div class="divider"></div>'); i += 1; continue
        if re.match(r'^\s*[-*]\s+', line):
            items = []
            while i < n and re.match(r'^\s*[-*]\s+', lines[i]):
                txt = maybe_scrub(re.sub(r'^\s*[-*]\s+', '', lines[i]))
                if txt: items.append('<li>%s</li>' % _inline(txt))
                i += 1
            if items: out.append('<ul>%s</ul>' % ''.join(items))
            continue
        if not line.strip(): i += 1; continue
        buf = [line]; i += 1
        while i < n and lines[i].strip() and not re.match(r'^\s*(#{1,6}\s|[-*]\s|>|```|---+\s*$)', lines[i]) and '|' not in lines[i]:
            buf.append(lines[i]); i += 1
        txt = maybe_scrub(' '.join(buf))
        if txt: out.append('<p>%s</p>' % _inline(txt))
    return '\n'.join(out)

# ============================================================================
# Design system — adapted from the house business-proposal styling
# ============================================================================
CSS = r"""
:root{
  --bg:#F5FAFE; --bg2:#EBF3FA; --bg3:#E0ECF5; --text:#1a1a1a; --text2:#4a5568; --text3:#8a9aaa;
  --border:#c8daea; --blue:#1153A1; --blue-light:#dce8f5; --blue-dark:#0a3d7a;
  --green:#0f7b6c; --green-bg:#dbeddb; --gold:#c99500; --gold-bg:#faf0d8;
  --red:#d94444; --red-bg:#fce4e4; --white:#fff;
}
*{margin:0;padding:0;box-sizing:border-box}
html{-webkit-print-color-adjust:exact;print-color-adjust:exact}
body{font-family:ui-sans-serif,-apple-system,BlinkMacSystemFont,'Segoe UI',Helvetica,'Sukhumvit Set','Thonburi',Arial,sans-serif;
     color:var(--text);line-height:1.6;font-size:13px;-webkit-font-smoothing:antialiased;background:#fff}

@page{ size:A4; margin:16mm 15mm 16mm; }
@page cover{ size:A4; margin:0; }

a{color:var(--blue);text-decoration:none}
code{background:var(--bg2);padding:.5px 4px;border-radius:3px;font-size:.86em;color:var(--blue-dark);
     font-family:ui-monospace,Menlo,monospace}
.divider{height:1px;background:var(--border);margin:14px 0}

/* section = flows across pages, starts on a fresh page */
.section{ break-before:page; }
.section:first-of-type{ break-before:auto; }

h1{font-size:24px;font-weight:800;color:var(--blue-dark);line-height:1.25;margin:0 0 6px}
h2,h3.md{font-size:16px;font-weight:700;color:var(--blue);margin:22px 0 8px;padding-top:12px;border-top:1px solid var(--border);break-after:avoid}
h3,h4.md{font-size:13.5px;font-weight:700;color:var(--text);margin:14px 0 5px;break-after:avoid}
h5.md,h6.md{font-size:12px;font-weight:700;color:var(--text2);margin:10px 0 4px;break-after:avoid}
p{color:var(--text2);margin:0 0 9px;line-height:1.7}
ul{margin:6px 0 9px 18px} li{margin:3px 0;color:var(--text2);line-height:1.6}
strong{color:var(--text)}

.section-number{font-size:10px;font-weight:700;letter-spacing:2px;text-transform:uppercase;color:var(--blue);margin-bottom:4px}
.page-title-bar{background:linear-gradient(135deg,var(--blue-light),#e8f2fc);padding:15px 22px;border-radius:4px;
   margin-bottom:18px;border-left:4px solid var(--blue);break-after:avoid;break-inside:avoid}
.page-title-bar h1{margin:0;font-size:21px}
.page-title-bar p{margin:3px 0 0;font-size:12px;color:var(--text3)}
.lead{font-size:13.5px;color:var(--text2);line-height:1.75;margin-bottom:14px}
.lead strong{color:var(--blue-dark)}

/* tables */
table{width:100%;border-collapse:collapse;margin:9px 0 14px;font-size:12px}
table.mid{font-size:10.5px} table.wide{font-size:9px}
thead{display:table-header-group}
th{background:var(--bg2);padding:6px 11px;text-align:left;font-weight:700;font-size:10px;color:var(--text2);
   border:1px solid var(--border);letter-spacing:.3px;text-transform:uppercase;vertical-align:bottom}
table.wide th{padding:4px 6px}
td{padding:6px 11px;border:1px solid var(--border);vertical-align:top;background:var(--white);word-break:break-word}
table.mid td{padding:4px 8px} table.wide td{padding:3px 6px}
tbody tr{break-inside:avoid}
tbody tr:nth-child(even) td{background:#FAFCFE}
table.wide td:first-child,table.wide th:first-child{width:20px;text-align:center;color:var(--text3)}

/* callout */
.callout{display:flex;gap:11px;padding:13px 15px;border-radius:4px;margin:13px 0;font-size:12.5px;line-height:1.65;color:var(--text);break-inside:avoid}
.callout .icon{font-size:17px;flex-shrink:0;margin-top:1px}
.c-blue{background:var(--blue-light)} .c-green{background:var(--green-bg)}
.c-gold{background:var(--gold-bg)} .c-red{background:var(--red-bg)}

/* cards + grids */
.card{background:var(--white);border:1px solid var(--border);border-radius:6px;padding:13px;break-inside:avoid}
.card-accent{border-left:4px solid var(--blue)}
.g2{display:grid;grid-template-columns:1fr 1fr;gap:11px}
.g3{display:grid;grid-template-columns:1fr 1fr 1fr;gap:11px}
.g4{display:grid;grid-template-columns:repeat(4,1fr);gap:10px}

/* stat boxes */
.stat-box{text-align:center;padding:13px 9px;background:var(--white);border:1px solid var(--border);border-radius:6px;break-inside:avoid}
.stat-box .num{font-size:25px;font-weight:800;color:var(--blue);line-height:1.05}
.stat-box .label{font-size:9.5px;color:var(--text3);margin-top:4px;line-height:1.3}
.statrow{margin:6px 0 16px}

/* bar chart */
.bars{margin:8px 0 14px}
.bar{display:flex;align-items:center;gap:9px;margin:5px 0;font-size:11.5px;break-inside:avoid}
.bar .lab{width:210px;flex:none;color:var(--text)}
.bar .track{flex:1;background:var(--bg2);border-radius:5px;height:14px;overflow:hidden}
.bar .fill{height:100%;border-radius:5px;background:var(--blue)}
.bar .val{width:96px;flex:none;text-align:right;color:var(--text3);font-size:10.5px}

/* keyword chips */
.kwgrid{display:flex;flex-wrap:wrap;gap:4px;margin:7px 0 13px}
.kw{display:inline-block;background:var(--bg2);color:var(--blue-dark);border:1px solid var(--border);
    border-radius:14px;padding:2px 9px;font-size:9.5px;white-space:nowrap}

/* timeline */
.timeline-item{display:flex;gap:14px;margin-bottom:14px;position:relative;break-inside:avoid}
.timeline-dot{width:10px;height:10px;background:var(--blue);border-radius:50%;margin-top:5px;flex-shrink:0;position:relative}
.timeline-dot::after{content:'';position:absolute;top:10px;left:4px;width:2px;height:calc(100% + 4px);background:var(--border)}
.timeline-item:last-child .timeline-dot::after{display:none}
.timeline-phase{font-size:9.5px;font-weight:700;letter-spacing:1px;text-transform:uppercase;color:var(--blue)}
.timeline-title{font-size:12.5px;font-weight:700;margin:2px 0 3px}
.timeline-desc{font-size:11px;color:var(--text2);line-height:1.55}

.note{font-size:10px;color:var(--text3);margin-top:3px}
.legend{display:flex;gap:14px;flex-wrap:wrap;font-size:10px;color:var(--text3);margin:2px 0 10px}
.legend b{color:var(--blue-dark)}
.pill{display:inline-block;font-size:9px;font-weight:700;letter-spacing:.5px;text-transform:uppercase;
      padding:2px 8px;border-radius:10px;background:var(--green-bg);color:var(--green)}

/* sitemap section blocks */
.smsec{break-inside:avoid-page;margin:14px 0 10px}
.smsec h3.md{margin-top:14px}

/* ===== COVER ===== */
.cover{page:cover;height:297mm;background:linear-gradient(160deg,#0a3d7a 0%,#1153A1 42%,#7BA4DD 100%);
  color:#fff;display:flex;flex-direction:column;justify-content:center;padding:80px 64px;position:relative;
  overflow:hidden;break-after:page}
.cover::before{content:'';position:absolute;top:-200px;right:-200px;width:600px;height:600px;border-radius:50%;background:rgba(255,255,255,.04)}
.cover::after{content:'';position:absolute;bottom:-150px;left:-150px;width:420px;height:420px;border-radius:50%;background:rgba(255,255,255,.03)}
.cover .conf{font-size:11px;letter-spacing:4px;text-transform:uppercase;color:rgba(255,255,255,.4);font-weight:600;margin-bottom:64px}
.cover .logo{height:78px;opacity:.9;filter:brightness(0) invert(1);margin-bottom:40px}
.cover .label{font-size:13px;letter-spacing:3px;text-transform:uppercase;color:rgba(255,255,255,.55);font-weight:500;margin-bottom:14px}
.cover .title{font-size:40px;font-weight:800;line-height:1.18;margin-bottom:14px}
.cover .subtitle{font-size:16px;font-weight:400;color:rgba(255,255,255,.7);max-width:560px;line-height:1.65;margin-bottom:18px}
.cover .cdiv{width:48px;height:2px;background:rgba(255,255,255,.25);margin:22px 0}
.cover .meta{font-size:12.5px;color:rgba(255,255,255,.55);line-height:2.1}
.cover .meta strong{color:rgba(255,255,255,.8);font-weight:600}
.cover .statline{display:grid;grid-template-columns:repeat(4,1fr);gap:14px;margin-top:30px;border-top:1px solid rgba(255,255,255,.18);padding-top:20px}
.cover .statline .n{font-size:26px;font-weight:800;color:#fff}
.cover .statline .l{font-size:9.5px;color:rgba(255,255,255,.6);margin-top:2px}

/* TOC */
.toc .row{display:flex;justify-content:space-between;align-items:baseline;padding:11px 0;border-bottom:1px solid var(--border)}
.toc .row .l{font-weight:600;color:var(--text)} .toc .row .no{font-weight:800;color:var(--blue);margin-right:12px}
.toc .row .d{font-size:11.5px;color:var(--text3);text-align:right;max-width:54%}
footer.end{margin-top:18px;border-top:2px solid var(--blue);padding-top:12px;color:var(--text3);font-size:10.5px;line-height:1.6}
footer.end b{color:var(--blue-dark)}

/* ---- page-break safety: never strand a heading or label above its table ---- */
h2,h3.md,h4.md,h5.md,h6.md{break-after:avoid-page;break-inside:avoid}
.page-title-bar{break-after:avoid-page}
p:has(+ table){break-after:avoid-page}
p:has(+ .kwgrid){break-after:avoid-page}
ul:has(+ table){break-after:avoid-page}
/* continuous entity table */
.entity-all td:nth-child(2){font-weight:600;color:var(--text)}
.entity-all th:first-child,.entity-all td:first-child{width:30px;white-space:nowrap;text-align:center}
.entity-all th:nth-child(5),.entity-all td:nth-child(5){width:54px}
.entity-all th:nth-child(6),.entity-all td:nth-child(6){width:44px}
/* cover logo badge (original colours on white — crisp, no filter) */
.cover .logobadge{display:inline-block;background:#fff;border-radius:14px;padding:16px 24px;margin-bottom:36px;box-shadow:0 10px 34px rgba(0,0,0,.18)}
.cover .logobadge img{height:42px;display:block}
"""

# ============================================================================
# small builders
# ============================================================================
def statbox(num, label):
    return '<div class="stat-box"><div class="num">%s</div><div class="label">%s</div></div>' % (num, label)
def bar(lab, pct, val, color="var(--blue)"):
    return ('<div class="bar"><div class="lab">%s</div><div class="track">'
            '<div class="fill" style="width:%s%%;background:%s"></div></div>'
            '<div class="val">%s</div></div>') % (lab, pct, color, val)
def callout(variant, icon, htmltext):
    return '<div class="callout c-%s"><div class="icon">%s</div><div>%s</div></div>' % (variant, icon, htmltext)
def titlebar(no, title, sub):
    return ('<div class="section-number">%s</div><div class="page-title-bar"><h1>%s</h1><p>%s</p></div>'
            % (no, title, sub))

LOGO = "assets/logo.png"

def build_entity_table():
    """One continuous entity table for the whole knowledge graph (no per-cluster header
    fragmentation). Columns: # / Entity / Type / schema.org / ICD-10 / Page / Topic Cluster."""
    lines = read(os.path.join(CP, "entities.md")).split('\n')
    rows, i, n = [], 0, len(lines)
    cluster, cluster_skip = "", False
    SKIP = ('entity type distribution', 'entity type vocabulary', 'eug', 'pre-flight', 'vocabulary')
    while i < n:
        line = lines[i]
        hm = re.match(r'^##\s+(.+)$', line)
        if hm:
            ct = hm.group(1).strip(); low = ct.lower()
            cluster = re.sub(r'^[a-z0-9]+(?:-[a-z0-9]+)+:\s+', '', ct)
            cluster_skip = any(t in low for t in SKIP)
            i += 1; continue
        if '|' in line and (i+1) < n and _is_sep(lines[i+1]):
            header = [c.lower() for c in _cells(line)]; i += 2
            is_entity = any('entity name' in h for h in header)
            def col(name):
                for j, h in enumerate(header):
                    if name in h: return j
                return -1
            ci = {k: col(k) for k in ('entity name', 'type', 'schema', 'icd-10', 'primary page')}
            body = []
            while i < n and '|' in lines[i] and lines[i].strip():
                body.append(_cells(lines[i])); i += 1
            if is_entity and not cluster_skip:
                for r in body:
                    def g(k):
                        j = ci[k]; return r[j].strip() if 0 <= j < len(r) else ''
                    name = g('entity name')
                    if not name or name in ('—', '-'): continue
                    rows.append((name, g('type'), g('schema'), g('icd-10'), g('primary page'), cluster))
            continue
        i += 1
    out = ['<table class="wide entity-all"><thead><tr><th>#</th><th>Entity</th><th>Type</th>'
           '<th>schema.org</th><th>ICD-10</th><th>Page</th><th>Topic Cluster</th></tr></thead><tbody>']
    for idx, (name, typ, schema, icd, page, cl) in enumerate(rows, 1):
        icd = '' if icd in ('—', '-') else icd
        cells = [str(idx)] + [_inline(scrub(x)) for x in (name, typ, schema, icd, page, cl)]
        out.append('<tr>' + ''.join('<td>%s</td>' % c for c in cells) + '</tr>')
    out.append('</tbody></table>')
    return ''.join(out), len(rows)

ENTITY_TABLE_HTML, ENTITY_COUNT = build_entity_table()

# ============================================================================
# COVER + TOC
# ============================================================================
cover = Template("""
<section class="cover">
  <div class="conf">Confidential · Prepared for SmileScape Clinic</div>
  <div class="logobadge"><img src="$logo" alt="SmileScape Clinic"></div>
  <div class="label">Content &amp; SEO — Master Plan</div>
  <div class="title">Content Architecture &amp;<br>Search Strategy Blueprint</div>
  <div class="subtitle">Semantic SEO &middot; AI Search Optimization &middot; Topical Authority — the complete content &amp; search architecture we have built for SmileScape Clinic.</div>
  <div class="cdiv"></div>
  <div class="meta">
    <strong>Prepared for:</strong> SmileScape Dental Clinic<br>
    <strong>Prepared by:</strong> The Gifted<br>
    <strong>Date:</strong> $date<br>
    <strong>Status:</strong> Planning complete · Content production in progress
  </div>
  <div class="statline">
    <div><div class="n">$pages+</div><div class="l">Pages Architected</div></div>
    <div><div class="n">163</div><div class="l">Mapped Entities</div></div>
    <div><div class="n">271</div><div class="l">Entity Relationships</div></div>
    <div><div class="n">16</div><div class="l">Evidence Pillars</div></div>
  </div>
</section>
""").substitute(logo=LOGO, date=PREPARED_DATE, pages=PAGES)

toc = """
<section class="section">
""" + titlebar("Contents", "What's Inside", "A complete view of the content &amp; search foundation we built") + """
<div class="toc">
  <div class="row"><div><span class="no">01</span><span class="l">Executive Summary</span></div><span class="d">What we built &amp; where the project stands today</span></div>
  <div class="row"><div><span class="no">02</span><span class="l">Our Approach</span></div><span class="d">The semantic, evidence-first methodology</span></div>
  <div class="row"><div><span class="no">03</span><span class="l">Knowledge Graph — Entities</span></div><span class="d">163 medical entities · schema.org · ICD-10</span></div>
  <div class="row"><div><span class="no">04</span><span class="l">Topic Clusters</span></div><span class="d">20 clusters across 9 domains · hub-and-spoke</span></div>
  <div class="row"><div><span class="no">05</span><span class="l">Evidence Base — Citations</span></div><span class="d">16 evidence pillars · ~80 sources · PubMed</span></div>
  <div class="row"><div><span class="no">06</span><span class="l">Keyword Universe</span></div><span class="d">~680 keywords · 16 clusters · demand goldmines</span></div>
  <div class="row"><div><span class="no">07</span><span class="l">Full Sitemap</span></div><span class="d">The complete """ + PAGES + """+ page architecture</span></div>
  <div class="row"><div><span class="no">08</span><span class="l">Entity Relationships</span></div><span class="d">271 connections · 10 relationship types</span></div>
</div>
"""

# ============================================================================
# 01 — Executive Summary
# ============================================================================
exec_html = '<section class="section">' + titlebar("Section 01", "Executive Summary",
    "What we have built for SmileScape — and where the project stands today") + """
<p class="lead">SmileScape Clinic has world-class clinical capability — a founder with a rare <strong>Dual M.Sc. in Implantology</strong> (Thailand &amp; Germany), advanced global training in bone regeneration and soft-tissue surgery, and an evidence-based, no-over-treatment philosophy. This document presents the <strong>complete content &amp; search architecture</strong> we have built to translate that clinical excellence into digital authority — the foundation now driving content production.</p>

<div class="callout c-green"><div class="icon">&#9989;</div><div><strong>Project status — Content Production, in progress.</strong> The full strategic foundation below is complete and locked: knowledge graph, topic clusters, evidence base, keyword universe, and the entire """ + PAGES + """+ page sitemap. Priority pages are now being written, doctor-reviewed, and published.</div></div>

<h2>What we built — at a glance</h2>
<div class="g4 statrow">""" + ''.join([
    statbox(PAGES+"+", "Pages architected · 8 sections"),
    statbox("163", "Mapped medical entities"),
    statbox("271", "Entity relationships"),
    statbox("16", "Evidence pillars"),
]) + """</div>
<div class="g4 statrow">""" + ''.join([
    statbox("20", "Topic clusters · 9 domains"),
    statbox("~680", "Researched keywords"),
    statbox("6", "Signature offerings"),
    statbox("12", "Medical schema types"),
]) + """</div>

<h2>Three pillars of the plan</h2>
<div class="g3">
  <div class="card card-accent"><h3 style="color:var(--blue);margin-top:0">Semantic Foundation</h3><p style="font-size:11.5px;margin:0">An entity-first architecture that Google and AI engines understand at a deep, machine-readable level — not keyword stuffing, but structured medical expertise.</p></div>
  <div class="card card-accent"><h3 style="color:var(--blue);margin-top:0">Evidence-Backed</h3><p style="font-size:11.5px;margin:0">Every clinical claim is anchored to peer-reviewed research, WHO/ADA guidelines and PubMed sources — the trust signals Google's YMYL standard demands.</p></div>
  <div class="card card-accent"><h3 style="color:var(--blue);margin-top:0">Built to Convert</h3><p style="font-size:11.5px;margin:0">Architecture organised around real patient journeys and concerns — turning organic visibility into booked consultations, not vanity traffic.</p></div>
</div>

<h2>Positioning</h2>
<p><strong>Implant-First specialty clinic</strong> — "the real authority in dental implants," with comprehensive dentistry as supporting services, under the brand idea <em>The Lifetime Foundation</em>.</p>
<ul>
  <li><strong>Hero service:</strong> Dental implants — 60.6% of the entire services section</li>
  <li><strong>6 signature offerings:</strong> Blue Diamond Implant System · Sausage Technique · All-on-X Immediate Loading · Soft-Tissue Management · Osseodensification Sinus Lift · In-House Direct-Print Aligner</li>
  <li><strong>Clinical framework:</strong> Zero Bone Loss protocol</li>
  <li><strong>Conversion edge:</strong> Social-security direct billing — patients pay nothing upfront</li>
  <li><strong>2 branches:</strong> Rattanathibet (Nonthaburi) &amp; Srinakarin (Bangkok)</li>
</ul>
"""

# ============================================================================
# 02 — Our Approach (principled methodology; client-facing)
# ============================================================================
approach_html = '<section class="section">' + titlebar("Section 02", "Our Approach",
    "Why this is built differently from typical SEO") + """
<p class="lead">We don't do keyword-first SEO. We build a <strong>semantic, evidence-first content system</strong> — structured so that Google, Bing and AI assistants understand SmileScape's expertise at the deepest possible level. It is the same principle used by the world's leading medical institutions, adapted for the Thai dental market through our proprietary content methodology.</p>

<div class="callout c-gold"><div class="icon">&#9888;&#65039;</div><div><strong>Why medical SEO is different.</strong> Dental and health content falls under Google's strictest quality category — <strong>YMYL (Your Money or Your Life)</strong>. Every page is held to a far higher standard of accuracy, authority and trust than any other industry. Our architecture is built around that reality: real doctors, real evidence, real outcomes.</div></div>

<h2>A six-layer system of understanding</h2>
<p>Each layer gives search engines a different dimension of understanding about SmileScape:</p>
<table>
<thead><tr><th style="width:26px">#</th><th style="width:165px">Layer</th><th>What it does</th></tr></thead>
<tbody>
<tr><td><strong>1</strong></td><td><strong>Schema Markup</strong></td><td>Describes every page to search engines in machine-readable medical language (12+ medical schema types)</td></tr>
<tr><td><strong>2</strong></td><td><strong>Entity Graph</strong></td><td>Maps how 163 medical concepts connect across 20 topic clusters</td></tr>
<tr><td><strong>3</strong></td><td><strong>Medical Codes</strong></td><td>Links content to ICD-10 international diagnostic standards</td></tr>
<tr><td><strong>4</strong></td><td><strong>Knowledge Graph</strong></td><td>Connects entities to Google's Knowledge Graph via schema.org &amp; authoritative IDs</td></tr>
<tr><td><strong>5</strong></td><td><strong>Evidence &amp; Citations</strong></td><td>Every clinical page cites PubMed, WHO, ADA or peer-reviewed sources</td></tr>
<tr><td><strong>6</strong></td><td><strong>E-E-A-T Signals</strong></td><td>Doctor attribution, credentials and review dates — the strongest trust signals for YMYL</td></tr>
</tbody></table>

<h2>How the pieces fit together</h2>
<div class="g2">
  <div class="card"><h3 style="margin-top:0">The build sequence</h3><ul style="font-size:11.5px"><li><strong>Knowledge Graph</strong> — define every concept (Section 03)</li><li><strong>Clusters</strong> — group concepts into authority territories (04)</li><li><strong>Evidence</strong> — back every claim with research (05)</li><li><strong>Keywords</strong> — map real search demand (06)</li><li><strong>Sitemap</strong> — architect every page (07)</li><li><strong>Relationships</strong> — wire it into one intelligent network (08)</li></ul></div>
  <div class="card" style="border:2px solid var(--blue);background:linear-gradient(135deg,#f8fbff,#f0f6fd)">
    <h3 style="margin-top:0;color:var(--blue)">Example — the "Full-Arch Implant" cluster</h3>
    <p style="font-size:11px;line-height:1.9;margin:0">
    <strong style="color:var(--blue)">Conditions:</strong> Edentulism, Bone Atrophy, Ridge Resorption<br>
    <strong style="color:var(--blue)">Procedures:</strong> All-on-4 / All-on-6, Immediate Loading, GBR<br>
    <strong style="color:var(--blue)">Materials:</strong> Titanium, Zirconia, Bone Graft<br>
    <strong style="color:var(--blue)">Technology:</strong> CBCT, Guided Surgery, Digital Planning<br>
    <strong style="color:var(--blue)">Anatomy:</strong> Maxilla, Mandible, Alveolar Bone<br>
    <strong style="color:var(--blue)">People:</strong> Dr. Worapat, Prosthodontics Team</p>
    <p style="font-size:10.5px;color:var(--text3);margin:9px 0 0;border-top:1px solid var(--border);padding-top:7px">One cluster connects 18+ entities across 6 categories — telling Google: "SmileScape has deep, interconnected authority in full-arch implant rehabilitation."</p>
  </div>
</div>
"""

# ============================================================================
# 03 — Entity (Knowledge Graph)
# ============================================================================
ent_bars = ''.join([
    bar("Procedure — surgical / clinical", 100, "49", "var(--blue)"),
    bar("Treatment — services", 80, "39", "var(--blue)"),
    bar("Condition — diagnoses", 55, "27", "var(--green)"),
    bar("Concept — frameworks", 33, "16", "var(--blue-dark)"),
    bar("Device — equipment", 33, "16", "var(--blue-dark)"),
    bar("Product — materials / brands", 18, "9", "var(--gold)"),
    bar("Anatomy", 12, "6", "var(--text3)"),
    bar("Organization", 6, "3", "var(--text3)"),
    bar("Person", 4, "2", "var(--text3)"),
])
entity_html = '<section class="section">' + titlebar("Section 03", "Knowledge Graph — Entities",
    "163 dental concepts, mapped to schema.org and ICD-10") + """
<p class="lead">The <strong>Entity Graph</strong> is the brain of the system. Each entity is one dental concept (e.g. dental implant, GBR, periodontitis) mapped to a schema.org type, ICD-10 diagnostic code and Thai/English aliases — so search engines and AI assistants understand the site by meaning, not just keywords. This is the foundation of modern AI Search visibility.</p>
<div class="g4 statrow">""" + ''.join([statbox("163","Total entities"), statbox("10","Entity types"),
    statbox("12","ICD-10 codes"), statbox("163/163","With graph connections")]) + """</div>
<h2>Entity distribution by type</h2>
<div class="bars">""" + ent_bars + """</div>
<div class="legend"><span><b>Reusable (universal):</b> 110 (84%)</span><span><b>SmileScape-specific:</b> 21 (16%)</span><span><b>Mapped to ICD-10:</b> 12 diagnostic codes</span></div>
<p class="note">The complete entity inventory follows as one continuous reference table — each entity with its type, schema.org class, ICD-10 code, primary page, and topic cluster.</p>
<h2>Complete entity inventory &mdash; """ + str(ENTITY_COUNT) + """ entities</h2>
""" + ENTITY_TABLE_HTML + "</section>"

# ============================================================================
# 04 — Cluster
# ============================================================================
cluster_html = '<section class="section">' + titlebar("Section 04", "Topic Clusters",
    "20 authority territories across 9 domains") + """
<p class="lead">Topic clusters group entities and pages into <strong>authority territories</strong>. Each cluster has a pillar (hub) page and supporting (spoke) pages that interlink — the hub-and-spoke structure Google uses to judge true topical expertise (E-E-A-T). Every cluster meets the pillar-to-supporting balance.</p>
<div class="g4 statrow">""" + ''.join([statbox("20","Topic clusters"), statbox("9","Domains (A–I)"),
    statbox("4","Clusters in the implant domain"), statbox("✓","All balance checks passed")]) + """</div>
""" + md_to_html(clean_lines(read(os.path.join(CP, "clusters.md")))) + "</section>"

# ============================================================================
# 05 — Citation pool
# ============================================================================
cit_tier = """
<h2>How sources are graded</h2>
<table><thead><tr><th style="width:50px">Tier</th><th>Source type</th><th>Examples</th></tr></thead><tbody>
<tr><td><strong>1</strong></td><td>Clinical guidelines &amp; government bodies</td><td>WHO · ADA · EFP · AAPD · Dental Council of Thailand</td></tr>
<tr><td><strong>2</strong></td><td>Peer-reviewed journals</td><td>J Dent · Clin Oral Implants Res · Periodontology 2000</td></tr>
<tr><td><strong>3</strong></td><td>Professional-body consensus</td><td>EAO · EFP · AAE consensus statements</td></tr>
<tr><td><strong>4</strong></td><td>Authoritative textbooks</td><td>Urban · Linkevicius · Misch</td></tr>
<tr><td><strong>5</strong></td><td>Verified clinic data</td><td>SmileScape case audits &amp; outcomes</td></tr>
<tr><td><strong>6</strong></td><td>Reputable secondary sources</td><td>Established health portals</td></tr>
</tbody></table>
"""
citation_html = '<section class="section">' + titlebar("Section 05", "Evidence Base — Citations",
    "16 evidence pillars · ~80 sources · 25 verified PubMed studies") + """
<p class="lead">Medical content lives or dies on credibility. Our <strong>evidence base</strong> organises authoritative research into 16 pillars, graded across a 6-tier hierarchy. Every clinical claim on the site is anchored to this pool — the foundation of E-E-A-T and the reason AI engines will cite SmileScape as a trusted source.</p>
<div class="g4 statrow">""" + ''.join([statbox("16","Evidence pillars"), statbox("~80","Sources compiled"),
    statbox("25","Verified PubMed studies"), statbox("8","Tier-1 guideline bodies")]) + """</div>
""" + cit_tier + md_to_html(clean_lines(read(os.path.join(CP, "citation-pool-seed.md"))),
                            drop_cols=['schema evidence']) + "</section>"

# ============================================================================
# 06 — Seed keyword
# ============================================================================
kw_bars = ''.join([
    bar("Gum swelling (เหงือกบวม)", 100, "22,200/mo", "var(--gold)"),
    bar("Tooth decay (ฟันผุ)", 100, "22,200/mo", "var(--gold)"),
    bar("Scaling / cleaning (ขูดหินปูน)", 55, "12,100/mo", "var(--gold)"),
    bar("Gum recession (เหงือกร่น)", 45, "9,900/mo", "var(--blue)"),
    bar("Bleeding gums (เลือดออกตามไรฟัน)", 30, "6,600/mo", "var(--blue)"),
    bar("Social-security eligibility check", 11, "2,400/mo", "var(--green)"),
    bar("Yellow teeth (ฟันเหลือง)", 11, "2,400/mo", "var(--green)"),
])
keyword_html = '<section class="section">' + titlebar("Section 06", "Keyword Universe",
    "~680 researched keywords across 16 clusters") + """
<p class="lead">Our keyword research maps real Thai &amp; English search demand — organised by topic and by intent (informational, commercial, transactional). Early demand analysis surfaced several <strong>high-volume, low-competition opportunities</strong> the clinic is uniquely positioned to own.</p>
<div class="g4 statrow">""" + ''.join([statbox("~680","Keywords researched"), statbox("16","Keyword clusters"),
    statbox("16","Geo modifiers"), statbox("4","Search-intent types")]) + """</div>
<h2>High-opportunity demand (early findings)</h2>
<div class="bars">""" + kw_bars + """</div>
<p class="note">Full keyword lists by cluster follow. Search volume, difficulty and CPC are validated continuously as the site is indexed.</p>
""" + md_to_html(clean_lines(read(os.path.join(CP, "keyword-seed-list.md"))),
                 drop_cols=['layer']) + "</section>"

# ============================================================================
# 07 — Full Sitemap
# ============================================================================
sm_pages = """
<table class="mid"><thead><tr><th>#</th><th>Section</th><th style="text-align:right">Pages</th><th>Role</th></tr></thead><tbody>
<tr><td>1</td><td><strong>Home</strong></td><td style="text-align:right">1</td><td>Main landing — The Lifetime Foundation</td></tr>
<tr><td>2</td><td><strong>Our Uniqueness &amp; Team</strong></td><td style="text-align:right">~34</td><td>Brand story, doctors, credentials, authority</td></tr>
<tr><td>3</td><td><strong>Services &amp; Programs</strong></td><td style="text-align:right">~262</td><td>All treatments — implant mastery is the core (60.6%)</td></tr>
<tr><td>4</td><td><strong>Technology</strong></td><td style="text-align:right">~35</td><td>Digital diagnostics, equipment, in-house lab</td></tr>
<tr><td>5</td><td><strong>Treatment by Concern</strong></td><td style="text-align:right">~173</td><td>Patient problems &amp; worries (problem-led journeys)</td></tr>
<tr><td>6</td><td><strong>Knowledge Hub</strong></td><td style="text-align:right">154</td><td>Clinical guides, FAQ, evidence, glossary</td></tr>
<tr><td>7</td><td><strong>Case Studies</strong></td><td style="text-align:right">~38</td><td>Real results &amp; patient stories</td></tr>
<tr><td>8</td><td><strong>Contact &amp; Local</strong></td><td style="text-align:right">~15</td><td>Booking &amp; 2 branch local-SEO hubs</td></tr>
<tr style="background:var(--blue-light)"><td colspan="2" style="font-weight:800;background:var(--blue-light)">Total</td><td style="text-align:right;font-weight:800;color:var(--blue);background:var(--blue-light)">~726</td><td style="background:var(--blue-light)"></td></tr>
</tbody></table>
"""
tier_bars = ''.join([
    bar("Tier A — strategic hero pages", 18, "~12", "var(--blue-dark)"),
    bar("Tier B — key pages", 38, "~60", "var(--blue)"),
    bar("Tier C — supporting pages", 100, "~290", "var(--green)"),
    bar("Tier D — depth / authority pages", 56, "~163", "var(--gold)"),
])
# Build the FULL sitemap expansion (Sections 1-8), cleaned
_sm_raw = read(os.path.join(CP, "sitemap.md"))
_m = re.search(r'(^##\s+Section\s+1:.*)', _sm_raw, re.M | re.S)
_sm_body = _m.group(1) if _m else _sm_raw
# cut the trailing "## Summary Statistics" internal block
_sm_body = re.split(r'\n##\s+Summary Statistics', _sm_body)[0]
_sm_clean = clean_lines(_sm_body, drop_headings=['summary statistics'])
_sm_rendered = md_to_html(_sm_clean, keep_cols=['#', 'page name', 'tier', 'funnel', 'primary entity'])

sitemap_html = '<section class="section">' + titlebar("Section 07", "Full Sitemap — Site Architecture",
    "The complete " + PAGES + "+ page architecture, laid out in full") + """
<p class="lead">This is the entire website blueprint — every section, sub-section and page we have architected for SmileScape, <strong>""" + PAGES + """+ pages</strong> across 8 sections. The structure is prioritised into tiers (A–D) and organised so that the highest-value, highest-intent pages anchor each topic, with supporting pages building depth and authority around them.</p>
<div class="g4 statrow">""" + ''.join([statbox(PAGES+"+","Total pages"), statbox("8","Top-level sections"),
    statbox("60.6%","Implant share of services"), statbox("4","Priority tiers")]) + """</div>

<h2>Pages per section</h2>
""" + sm_pages + """
<h2>Priority distribution</h2>
<div class="bars">""" + tier_bars + """</div>
<p class="note">Tier mix is refined continuously as live search volume confirms which pages carry the most demand.</p>

<h2>The complete page architecture</h2>
<p>Every page below is planned with its name, priority tier, funnel stage and the primary medical entity it anchors. Page names appear in Thai (the language of the site); &#127775; marks a signature page and &#9733; a featured technology.</p>
<div class="legend"><span><b>Tier:</b> A = hero · B = key · C = supporting · D = depth</span><span><b>Funnel:</b> top / mid / bottom of patient journey</span></div>
""" + _sm_rendered + "</section>"

# ============================================================================
# 08 — Relation
# ============================================================================
relation_html = '<section class="section">' + titlebar("Section 08", "Entity Relationships",
    "271 connections wiring the knowledge graph into one network") + """
<p class="lead">Relationships are the wiring between entities — they tell search engines <em>how</em> concepts relate: a treatment <em>treats</em> a condition, a technique <em>uses</em> a device, a claim is <em>evidenced by</em> research. This network is what powers meaningful internal linking and lets AI understand SmileScape's clinical context as a connected whole.</p>
<div class="g4 statrow">""" + ''.join([statbox("271","Relationships"), statbox("10","Relationship types"),
    statbox("81","Two-way links"), statbox("26","Evidence links")]) + """</div>

<h2>The relationship vocabulary</h2>
<table class="mid"><thead><tr><th style="width:150px">Type</th><th>Meaning</th></tr></thead><tbody>
<tr><td><code>parent_of</code></td><td>Taxonomic parent to child</td></tr>
<tr><td><code>subtype_of</code></td><td>Clinical specialization / variant</td></tr>
<tr><td><code>treats</code></td><td>A treatment addresses a condition</td></tr>
<tr><td><code>symptom_of</code></td><td>A sign or sequela of a disease</td></tr>
<tr><td><code>uses</code></td><td>A technique employs a device or material</td></tr>
<tr><td><code>alternative_to</code></td><td>Competing or equivalent clinical option</td></tr>
<tr><td><code>part_of</code></td><td>Anatomical / structural component</td></tr>
<tr><td><code>requires_assessment</code></td><td>Clinical work needs a diagnostic step</td></tr>
<tr><td><code>evidenced_by</code></td><td>A claim is backed by research evidence</td></tr>
<tr><td><code>related_to</code></td><td>Non-hierarchical association</td></tr>
</tbody></table>
<p class="note">The full relationship map follows, grouped by clinical theme.</p>
""" + md_to_html(clean_lines(read(os.path.join(CP, "relationships.md")), drop_headings=DROP_HEADINGS + ['edge vocabulary', 'graph health']),
                 drop_cols=['bidirectional']) + """
<footer class="end"><b>SmileScape Dental Clinic — Content &amp; SEO Master Plan</b><br>
Prepared by The Gifted · """ + PREPARED_DATE + """ · Confidential. Figures reflect the current architecture and are refined as content is produced and live search data is validated.</footer>
</section>"""

# ============================================================================
# assemble
# ============================================================================
SECTIONS = [
    ("00-cover", cover, True),
    ("01-toc", toc, False),
    ("02-executive-summary", exec_html, False),
    ("03-approach", approach_html, False),
    ("04-entity", entity_html, False),
    ("05-cluster", cluster_html, False),
    ("06-citation-pool", citation_html, False),
    ("07-seed-keyword", keyword_html, False),
    ("08-sitemap", sitemap_html, False),
    ("09-relation", relation_html, False),
]

def wrap_doc(title, inner):
    return ('<!doctype html><html lang="en"><head><meta charset="utf-8">'
            '<meta name="viewport" content="width=device-width,initial-scale=1">'
            '<title>' + title + '</title><style>' + CSS + '</style></head><body>'
            + inner + '</body></html>')

# normalize: some section vars already include the <section> wrapper, some (toc/exec/...) start with it
def as_section(name, content):
    c = content.strip()
    if c.startswith('<section'):
        return c if c.endswith('</section>') else (c + '</section>')
    return '<section class="section">' + c + '</section>'

# per-section standalone files
for name, content, is_cover in SECTIONS:
    body = content if is_cover else as_section(name, content)
    if is_cover:
        body = body.replace('src="assets/logo.png"', 'src="../assets/logo.png"')
    with open(os.path.join(SECT, name + ".html"), "w", encoding="utf-8") as f:
        f.write(wrap_doc("SmileScape — " + name, body))

# combined
parts = []
for name, content, is_cover in SECTIONS:
    parts.append(content if is_cover else as_section(name, content))
with open(os.path.join(BASE, "report.html"), "w", encoding="utf-8") as f:
    f.write(wrap_doc("SmileScape — Content & SEO Master Plan", '\n'.join(parts)))

# logo
src_logo = os.path.join(ROOT, "theme", "brand-assets",
                        "AW-Final_Logo_Smile-Scape_25.10.22-Primary_Transparency-e1744119892792.png")
logo_ok = False
try:
    shutil.copy(src_logo, os.path.join(ASSET, "logo.png")); logo_ok = True
except Exception:
    pass

print("OK build complete")
print("report.html bytes:", os.path.getsize(os.path.join(BASE, "report.html")))
print("sections:", ", ".join(n for n, _, _ in SECTIONS))
print("logo copied:", logo_ok)
# leak check: scan combined output for internal tokens that should be gone
combined = read(os.path.join(BASE, "report.html"))
leaks = {}
for pat in [r'\bDR-\d', r'SS-DR', r'\bRound \d', r'\bR\d+\b', r'Phase [A-F]\b', r'Stage 1', r'Bible',
            r'Handover', r'Schema v', r'brand_scope', r'EUG', r'Supabase', r'\bn8n\b', r'DFS',
            r'VOLUME-IMMUNE', r'operator', r'\bTBD\b', r'eug_', r'P\d+-C\d+', r'entity_type', r'\bDB\b']:
    m = re.findall(pat, combined)
    if m: leaks[pat] = len(m)
print("LEAKS:", leaks if leaks else "none")
