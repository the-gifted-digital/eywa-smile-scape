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
  // 'senior' (60+) is a context flag only — it shapes report copy, not the tier.
  if (a.age === '60+') flags.push('senior');
  if (a.duration === 'gt-2y') flags.push('bone');
  // 'unsure' is treated conservatively for bone (a critical eligibility factor).
  if (a.bone === 'yes' || a.bone === 'unsure') flags.push('bone');
  if (a.gums === 'often') flags.push('perio');
  // Only regular smoking flags; 'occasional'/'none' do not affect the tier.
  if (a.smoking === 'regular') flags.push('smoking');
  if (a.diabetes === 'yes-poor') flags.push('medical');
  // 'unsure' is treated conservatively for serious meds/conditions → needs evaluation.
  if (a.medical === 'has-any' || a.medical === 'unsure') flags.push('complex');
  // 'unsure' is intentionally NOT flagged for bruxism (minor factor — avoid over-escalating).
  if (a.bruxism === 'yes') flags.push('bruxism');
  if (a.situation === 'many-all-missing') flags.push('allarch');
  // Note: 'intent' is not scored — it's forwarded to the report/email/n8n only.

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
