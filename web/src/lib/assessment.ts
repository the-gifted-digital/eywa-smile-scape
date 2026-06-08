// Pure, dependency-free scoring for the Implant Readiness Check.
// No imports (must be bundlable by both Astro client and tests).

export type Tier = 'A' | 'B' | 'C' | 'info' | 'minor';
export type Flag =
  | 'minor' | 'senior' | 'bone' | 'perio' | 'smoking'
  | 'medical' | 'complex' | 'bruxism' | 'allarch';
export type Answers = Record<string, string>;
export interface ScoreResult { tier: Tier; flags: Flag[]; }

export function scoreAssessment(a: Answers): ScoreResult {
  const flags: Flag[] = [];
  if (a.age === 'under-18') flags.push('minor');
  if (a.age === '60+') flags.push('senior');
  if (a.duration === 'gt-2y') flags.push('bone');
  if (a.bone === 'yes' || a.bone === 'unsure') flags.push('bone');
  if (a.gums === 'often') flags.push('perio');
  if (a.smoking === 'regular') flags.push('smoking');
  if (a.diabetes === 'yes-poor') flags.push('medical');
  if (a.medical === 'has-any') flags.push('complex');
  if (a.bruxism === 'yes') flags.push('bruxism');
  if (a.situation === 'many-all-missing') flags.push('allarch');

  const uniq = [...new Set(flags)];
  const has = (f: Flag) => uniq.includes(f);

  let tier: Tier;
  if (has('minor')) tier = 'minor';
  else if (a.situation === 'teeth-intact') tier = 'info';
  else if (has('complex') || has('medical')) tier = 'C';
  else if (has('bone') || has('perio') || has('smoking') || has('bruxism')) tier = 'B';
  else tier = 'A';

  return { tier, flags: uniq };
}
