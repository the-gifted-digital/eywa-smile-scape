import { describe, it, expect } from 'vitest';
import { resolveActiveDecor, todayInBangkok, type DecorPreset } from './decor';

// Christmas: whole December, repeats every year, all locales.
const christmas: DecorPreset = {
  key: 'christmas',
  start: '12-01',
  end: '12-31',
  repeatYearly: true,
  theme: 'snow',
  motifs: ['snowman', 'christmas-tree', 'deer'],
};

// A window that wraps across New Year (Dec 24 → Jan 2).
const newyear: DecorPreset = {
  key: 'newyear',
  start: '12-24',
  end: '01-02',
  repeatYearly: true,
  theme: 'snow',
  motifs: ['snowman'],
};

describe('resolveActiveDecor — date windows (repeatYearly)', () => {
  it('is active inside the window (mid-December, any year)', () => {
    expect(resolveActiveDecor([christmas], '2026-12-15', 'th')?.key).toBe('christmas');
    expect(resolveActiveDecor([christmas], '2031-12-15', 'th')?.key).toBe('christmas');
  });
  it('is inclusive on both boundary days', () => {
    expect(resolveActiveDecor([christmas], '2026-12-01', 'th')?.key).toBe('christmas');
    expect(resolveActiveDecor([christmas], '2026-12-31', 'th')?.key).toBe('christmas');
  });
  it('is inactive the day before and the day after', () => {
    expect(resolveActiveDecor([christmas], '2026-11-30', 'th')).toBeNull();
    expect(resolveActiveDecor([christmas], '2027-01-01', 'th')).toBeNull();
  });
  it('accepts presets written as full YYYY-MM-DD when repeatYearly', () => {
    const p = { ...christmas, start: '2000-12-01', end: '2000-12-31' };
    expect(resolveActiveDecor([p], '2026-12-10', 'th')?.key).toBe('christmas');
  });
});

describe('resolveActiveDecor — year-wrapping window', () => {
  it('is active on both sides of New Year', () => {
    expect(resolveActiveDecor([newyear], '2026-12-31', 'th')?.key).toBe('newyear');
    expect(resolveActiveDecor([newyear], '2027-01-01', 'th')?.key).toBe('newyear');
    expect(resolveActiveDecor([newyear], '2026-12-24', 'th')?.key).toBe('newyear');
    expect(resolveActiveDecor([newyear], '2027-01-02', 'th')?.key).toBe('newyear');
  });
  it('is inactive just outside the wrapping window', () => {
    expect(resolveActiveDecor([newyear], '2026-12-23', 'th')).toBeNull();
    expect(resolveActiveDecor([newyear], '2027-01-03', 'th')).toBeNull();
  });
});

describe('resolveActiveDecor — explicit one-off dates (no repeat)', () => {
  const oneoff: DecorPreset = {
    key: 'launch', start: '2026-12-20', end: '2026-12-27', theme: 'snow', motifs: ['deer'],
  };
  it('is active only in that specific year/window', () => {
    expect(resolveActiveDecor([oneoff], '2026-12-25', 'th')?.key).toBe('launch');
  });
  it('does not repeat the next year', () => {
    expect(resolveActiveDecor([oneoff], '2027-12-25', 'th')).toBeNull();
  });
  it('fails closed when a one-off preset is mis-written with MM-DD dates', () => {
    // No repeatYearly + bare MM-DD is a config mistake → never activates (warns in dev).
    const bad: DecorPreset = { key: 'bad', start: '12-01', end: '12-31', theme: 'snow', motifs: ['deer'] };
    expect(resolveActiveDecor([bad], '2026-12-15', 'th')).toBeNull();
  });
});

describe('resolveActiveDecor — locale targeting', () => {
  const cny: DecorPreset = {
    key: 'cny', start: '02-10', end: '02-17', repeatYearly: true,
    theme: 'snow', motifs: ['snowman'], locales: ['zh-cn'],
  };
  it('shows only for the targeted locale', () => {
    expect(resolveActiveDecor([cny], '2026-02-12', 'zh-cn')?.key).toBe('cny');
    expect(resolveActiveDecor([cny], '2026-02-12', 'th')).toBeNull();
    expect(resolveActiveDecor([cny], '2026-02-12', 'en')).toBeNull();
  });
});

describe('resolveActiveDecor — enabled flag', () => {
  it('is skipped when enabled === false even inside the window', () => {
    expect(resolveActiveDecor([{ ...christmas, enabled: false }], '2026-12-15', 'th')).toBeNull();
  });
});

describe('resolveActiveDecor — override', () => {
  it("'off' forces null even inside an active window", () => {
    expect(resolveActiveDecor([christmas], '2026-12-15', 'th', 'off')).toBeNull();
  });
  it('a preset key forces that preset on, off-window', () => {
    expect(resolveActiveDecor([christmas], '2026-06-19', 'th', 'christmas')?.key).toBe('christmas');
  });
  it('a preset key forces on even for a non-targeted locale or disabled preset', () => {
    const cny: DecorPreset = {
      key: 'cny', start: '02-10', end: '02-17', repeatYearly: true,
      theme: 'snow', motifs: ['snowman'], locales: ['zh-cn'], enabled: false,
    };
    expect(resolveActiveDecor([cny], '2026-06-19', 'th', 'cny')?.key).toBe('cny');
  });
  it('an unknown override key is ignored (falls back to date logic)', () => {
    expect(resolveActiveDecor([christmas], '2026-12-15', 'th', 'nope')?.key).toBe('christmas');
    expect(resolveActiveDecor([christmas], '2026-06-19', 'th', 'nope')).toBeNull();
  });
});

describe('resolveActiveDecor — ordering', () => {
  it('returns the first matching preset', () => {
    const a: DecorPreset = { key: 'a', start: '12-01', end: '12-31', repeatYearly: true, theme: 'snow', motifs: ['deer'] };
    const b: DecorPreset = { key: 'b', start: '12-10', end: '12-20', repeatYearly: true, theme: 'snow', motifs: ['snowman'] };
    expect(resolveActiveDecor([a, b], '2026-12-15', 'th')?.key).toBe('a');
  });
  it('returns null when no preset matches', () => {
    expect(resolveActiveDecor([christmas], '2026-07-01', 'th')).toBeNull();
  });
});

describe('todayInBangkok', () => {
  it('formats as YYYY-MM-DD', () => {
    expect(todayInBangkok(new Date('2026-06-19T05:00:00Z'))).toMatch(/^\d{4}-\d{2}-\d{2}$/);
  });
  it('uses Asia/Bangkok (UTC+7) — late-UTC instant rolls to the next Bangkok day', () => {
    // 2026-06-19 18:30 UTC = 2026-06-20 01:30 in Bangkok
    expect(todayInBangkok(new Date('2026-06-19T18:30:00Z'))).toBe('2026-06-20');
  });
  it('a morning-UTC instant stays the same Bangkok day', () => {
    expect(todayInBangkok(new Date('2026-12-25T02:00:00Z'))).toBe('2026-12-25');
  });
});
