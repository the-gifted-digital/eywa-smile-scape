# deployment/supabase-load/_lib.py — shared helpers + constants for SmileScape Stage-1.5 load
import re

BRAND_ID    = "c93a5e7b-bed3-4b10-8ffa-11cf9fbbaf25"   # brands.id (uuid)
BRAND_SLUG  = "smile-scape-clinic"
BRAND_NAME  = "Smile Scape Clinic"
BRAND_LOWER = "smile scape clinic"
ROOT = "/Volumes/SSD NN/CLAUDE AI/repos/brands/eywa-smile-scape"
SRC  = ROOT + "/content-plan"
OUT  = ROOT + "/deployment/supabase-load"
DASH = {"—", "-", "–", "", "N/A", "n/a", "TBD", "tbd", "?"}

def q(s):
    """SQL-quote a scalar; NULL for empty/dash placeholders."""
    if s is None or (isinstance(s, str) and s.strip() in DASH):
        return "NULL"
    return "'" + str(s).strip().replace("'", "''") + "'"

def cells(line):
    """Split a markdown table row into trimmed cells."""
    p = [c.strip() for c in line.rstrip("\n").split("|")]
    if p and p[0] == "": p = p[1:]
    if p and p[-1] == "": p = p[:-1]
    return p

def is_sep(c):
    """True for a markdown separator row like |---|:--:|."""
    return bool(c) and all(set(x) <= set("-: ") for x in c if x != "")

def norm_scope(raw):
    """"['*'] mixed" / "['smile-scape']" -> SQL text[] literal, normalized to brand slug."""
    toks = re.findall(r"[*A-Za-z0-9\-]+", raw or "")
    out = []
    for t in toks:
        if t in ("mixed",): continue
        if t == "smile-scape": t = "smile-scape-clinic"
        out.append(t)
    if not out: out = ["*"]
    return "array[" + ",".join("'" + t + "'" for t in out) + "]::text[]"

def scope_primary(scope_literal):
    return "'smile-scape-clinic'" if "smile-scape-clinic" in scope_literal else "'*'"

def text_array(items):
    """list[str] -> SQL text[] literal, or NULL."""
    vals = [i.strip().replace("'", "''") for i in (items or []) if i and i.strip() not in DASH]
    return "array[" + ",".join("'" + v + "'" for v in vals) + "]::text[]" if vals else "NULL"

def split_aliases(cell):
    """Aliases cell -> list (comma- or slash-separated, Thai+English)."""
    if not cell or cell.strip() in DASH: return []
    return [a for a in re.split(r"[,/]", cell) if a.strip()]
