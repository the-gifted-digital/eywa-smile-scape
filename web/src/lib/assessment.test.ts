import { test, expect } from 'vitest';
import { scoreAssessment, type Answers } from './assessment';

const base: Answers = {
  age: '40-59', situation: '1-2-missing', duration: '6mo-2y', bone: 'no',
  gums: 'never', smoking: 'none', diabetes: 'no', medical: 'none', bruxism: 'no', intent: 'soon',
};

test('all favorable → tier A, no flags', () => {
  const r = scoreAssessment(base);
  expect(r.tier).toBe('A');
  expect(r.flags).toEqual([]);
});

test('under-18 overrides everything → minor', () => {
  const r = scoreAssessment({ ...base, age: 'under-18', bone: 'yes', medical: 'has-any' });
  expect(r.tier).toBe('minor');
  expect(r.flags).toContain('minor');
});

test('teeth-intact (adult) → info', () => {
  expect(scoreAssessment({ ...base, situation: 'teeth-intact', smoking: 'regular' }).tier).toBe('info');
});

test('antiresorptive meds → tier C', () => {
  expect(scoreAssessment({ ...base, medical: 'has-any' }).tier).toBe('C');
});

test('poorly-controlled diabetes → tier C', () => {
  expect(scoreAssessment({ ...base, diabetes: 'yes-poor' }).tier).toBe('C');
});

test('bone history → tier B with bone flag', () => {
  const r = scoreAssessment({ ...base, bone: 'yes' });
  expect(r.tier).toBe('B');
  expect(r.flags).toContain('bone');
});

test('long edentulous duration sets bone flag → B', () => {
  expect(scoreAssessment({ ...base, duration: 'gt-2y' }).tier).toBe('B');
});

test('regular smoking → B', () => {
  expect(scoreAssessment({ ...base, smoking: 'regular' }).flags).toContain('smoking');
});

test('many/all missing sets allarch (context, still A if no other flags)', () => {
  const r = scoreAssessment({ ...base, situation: 'many-all-missing' });
  expect(r.flags).toContain('allarch');
  expect(r.tier).toBe('A');
});

test('60+ sets senior flag', () => {
  expect(scoreAssessment({ ...base, age: '60+' }).flags).toContain('senior');
});

test('flags are de-duplicated (bone from duration + bone question)', () => {
  const r = scoreAssessment({ ...base, duration: 'gt-2y', bone: 'yes' });
  expect(r.flags.filter((f) => f === 'bone')).toHaveLength(1);
});

test('medical "unsure" is treated conservatively → tier C', () => {
  expect(scoreAssessment({ ...base, medical: 'unsure' }).tier).toBe('C');
});

test('bruxism "unsure" does not escalate → tier A', () => {
  expect(scoreAssessment({ ...base, bruxism: 'unsure' }).tier).toBe('A');
});

test('gum disease (often) → tier B', () => {
  expect(scoreAssessment({ ...base, gums: 'often' }).tier).toBe('B');
});

test('bruxism (yes) → tier B', () => {
  expect(scoreAssessment({ ...base, bruxism: 'yes' }).tier).toBe('B');
});
