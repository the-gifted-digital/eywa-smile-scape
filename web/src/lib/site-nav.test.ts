import { describe, it, expect } from 'vitest';
import { pick, getHeader, getFooter, getAltLocales } from './site-nav';

describe('pick', () => {
  it('returns the requested locale when present', () => {
    expect(pick({ th: 'ก', en: 'a' }, 'en')).toBe('a');
  });
  it('falls back to en when locale missing', () => {
    expect(pick({ th: 'ก', en: 'a' }, 'zh-cn')).toBe('a');
  });
  it('falls back to th when en also missing', () => {
    expect(pick({ th: 'ก' }, 'zh-cn')).toBe('ก');
  });
});

describe('getHeader', () => {
  it('has both mega panels with the flagship first', () => {
    const h = getHeader('th');
    const panels = h.nav.filter((n) => n.panel).map((n) => n.panel);
    expect(panels).toEqual(['implant', 'services']);
    expect(h.megaPanels.implant.promo).toBeTruthy();
  });
  it('marks unbuilt service links as soon', () => {
    const h = getHeader('th');
    const services = h.megaPanels.services.columns.flatMap((c) => c.links);
    expect(services.some((l) => l.soon)).toBe(true);
  });
});

describe('getFooter', () => {
  it('has two branches with phone + map', () => {
    const f = getFooter('th');
    expect(f.branches).toHaveLength(2);
    expect(f.branches[0].phoneTel).toBe('+66984624949');
    expect(f.branches[0].mapUrl).toMatch(/^https?:\/\//);
  });
});

describe('getAltLocales', () => {
  it('builds per-locale URLs from a non-default path', () => {
    const alt = getAltLocales('/en/implant-check/', 'https://go.example.com');
    expect(alt.th).toBe('https://go.example.com/implant-check/');
    expect(alt.en).toBe('https://go.example.com/en/implant-check/');
    expect(alt['zh-cn']).toBe('https://go.example.com/zh-cn/implant-check/');
  });
});
