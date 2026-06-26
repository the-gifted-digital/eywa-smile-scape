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
  it('exposes the four mega-menu panels in nav order', () => {
    const h = getHeader('th');
    const panels = h.nav.filter((n) => n.panel).map((n) => n.panel);
    expect(panels).toEqual(['about', 'services', 'technology', 'concerns']);
  });
  it('gives every mega panel a heading and columns', () => {
    const h = getHeader('th');
    for (const key of ['about', 'services', 'technology', 'concerns'] as const) {
      expect(h.megaPanels[key].heading).toBeTruthy();
      expect((h.megaPanels[key].columns ?? []).length).toBeGreaterThan(0);
    }
  });
  it('restores the real services content', () => {
    const services = getHeader('th').megaPanels.services;
    const labels = (services.columns ?? []).flatMap((c) => c.links).map((l) => l.label);
    expect(labels).toContain('วีเนียร์');
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
