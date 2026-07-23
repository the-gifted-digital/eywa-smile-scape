// web/src/lib/decor.ts
// Seasonal "Decor layer" — config + pure scheduling logic for a temporary,
// date-gated decorative overlay (snow + an occasional crossing motif).
//
// Design: docs/superpowers/specs/2026-06-19-decor-seasonal-overlay-design.md
// The site is statically built, so the date gate is evaluated in the browser
// (see DecorLayer.astro). Timezone is pinned to Asia/Bangkok so every visitor
// flips on/off at the same wall-clock regardless of their device timezone.

export type Locale = 'th' | 'en' | 'zh-cn';
export type DecorTheme = 'snow' | 'mourning';
export type DecorMotif = 'snowman' | 'christmas-tree' | 'deer';
export type SnowDensity = 'light' | 'medium' | 'heavy';

export interface DecorPreset {
  /** Stable id; also the `?decor=<key>` preview-override value. */
  key: string;
  /** Window start, inclusive. 'MM-DD' or 'YYYY-MM-DD'. */
  start: string;
  /** Window end, inclusive. 'MM-DD' or 'YYYY-MM-DD'. */
  end: string;
  /** Compare MM-DD only (ignore year); supports year-wrapping windows. */
  repeatYearly?: boolean;
  theme: DecorTheme;
  /** Crossing motifs — one is chosen at random per crossing. Snow theme only. */
  motifs?: DecorMotif[];
  /** Snowfall density (default 'medium'). Snow theme only. */
  density?: SnowDensity;
  /** Restrict to these locales; omit = all locales. */
  locales?: Locale[];
  /** Per-preset kill switch (default true). */
  enabled?: boolean;
}

// ---- Festival schedule (edit here to add/adjust festivals) ----
export const DECOR_PRESETS: DecorPreset[] = [
  // National mourning — whole site desaturated to grayscale (theme: 'mourning').
  // Ends 2026-07-31 (end of month); extend `end` if the official period is longer.
  // Listed first so it overrides any festival.
  {
    key: 'mourning',
    start: '2026-07-24',
    end: '2026-07-31',
    theme: 'mourning',
  },
  // Christmas snow, the whole of December, every year.
  {
    key: 'christmas',
    start: '12-01',
    end: '12-31',
    repeatYearly: true,
    theme: 'snow',
    motifs: ['snowman', 'christmas-tree', 'deer'],
    density: 'medium',
  },
];

/** "Today" in Asia/Bangkok as 'YYYY-MM-DD' (timezone-pinned, not device-local). */
export function todayInBangkok(now: Date = new Date()): string {
  // en-CA renders ISO-style YYYY-MM-DD.
  return new Intl.DateTimeFormat('en-CA', {
    timeZone: 'Asia/Bangkok',
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
  }).format(now);
}

/** Take the 'MM-DD' tail of a 'MM-DD' or 'YYYY-MM-DD' string. */
function md(date: string): string {
  return date.length > 5 ? date.slice(5) : date;
}

function inWindow(preset: DecorPreset, today: string): boolean {
  if (preset.repeatYearly) {
    const day = md(today);
    const start = md(preset.start);
    const end = md(preset.end);
    // Non-wrapping window (e.g. 12-01..12-31): simple inclusive range.
    if (start <= end) return day >= start && day <= end;
    // Wrapping window (e.g. 12-24..01-02): match either tail of the year.
    return day >= start || day <= end;
  }
  // One-off windows must use full 'YYYY-MM-DD'. A bare 'MM-DD' here would never
  // match (lexicographically a real 'YYYY-..' is always > 'MM-..'), so fail closed
  // and warn rather than silently never showing. Use repeatYearly:true for MM-DD.
  if (preset.start.length <= 5 || preset.end.length <= 5) {
    if (import.meta.env && import.meta.env.DEV) {
      console.warn(
        `[decor] preset "${preset.key}": one-off dates must be YYYY-MM-DD ` +
          `(got ${preset.start}..${preset.end}); set repeatYearly:true for an annual MM-DD window.`,
      );
    }
    return false;
  }
  // One-off explicit dates: ISO strings compare lexicographically.
  return today >= preset.start && today <= preset.end;
}

/**
 * Resolve which decor preset (if any) should be active.
 * @param presets   Ordered list; first match wins.
 * @param today     'YYYY-MM-DD' in the target timezone (see todayInBangkok).
 * @param locale    Current page locale.
 * @param override  From `?decor=` — a preset key forces it on (ignoring date /
 *                  locale / enabled); 'off' forces null; unknown keys are ignored.
 */
export function resolveActiveDecor(
  presets: DecorPreset[],
  today: string,
  locale: Locale,
  override?: string | null,
): DecorPreset | null {
  if (override) {
    if (override === 'off') return null;
    const forced = presets.find((p) => p.key === override);
    if (forced) return forced;
    // Unknown key → ignore the override, continue with normal date logic.
  }

  for (const preset of presets) {
    if (preset.enabled === false) continue;
    if (preset.locales && !preset.locales.includes(locale)) continue;
    if (inWindow(preset, today)) return preset;
  }
  return null;
}
