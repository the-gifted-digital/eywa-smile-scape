import { test, expect } from 'vitest';
import { buildAssessmentEmail, type EmailReport } from './assessment-email';

const report: EmailReport = {
  tierTitle: 'You look well-prepared',
  tierSummary: 'Most factors favor implants.',
  whyBullets: ['No smoking', 'Healthy gums'],
  nextSteps: ['Consult', 'Plan'],
  relatedLinks: [{ label: 'Bone grafting', url: 'https://go.example.com/x' }],
  ctaUrl: 'https://go.example.com/#booking',
  ctaLabel: 'Book a consult',
};

test('includes greeting, tier title, why, steps, cta', () => {
  const { subject, html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: false });
  expect(subject.length).toBeGreaterThan(0);
  expect(html).toContain('Nin');
  expect(html).toContain('You look well-prepared');
  expect(html).toContain('No smoking');
  expect(html).toContain('Book a consult');
});

test('related block hidden when relatedOn=false', () => {
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: false });
  expect(html).not.toContain('Bone grafting');
});

test('related block shown when relatedOn=true', () => {
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report, relatedOn: true });
  expect(html).toContain('Bone grafting');
});

test('escapes HTML in dynamic content', () => {
  const r = { ...report, tierTitle: '<script>x</script>' };
  const { html } = buildAssessmentEmail({ name: 'Nin', locale: 'en', report: r, relatedOn: false });
  expect(html).not.toContain('<script>x</script>');
  expect(html).toContain('&lt;script&gt;');
});

test('falls back to th chrome for unknown locale', () => {
  // @ts-expect-error testing fallback
  const { subject } = buildAssessmentEmail({ name: 'A', locale: 'xx', report, relatedOn: false });
  expect(subject.length).toBeGreaterThan(0);
});
