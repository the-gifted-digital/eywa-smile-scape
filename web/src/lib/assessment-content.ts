import { getEntry } from 'astro:content';
import type { Locale } from './home';

/** Load assessment content for a locale (falls back to th). */
export async function getAssessment(locale: Locale) {
  const entry = (await getEntry('assessment', locale)) ?? (await getEntry('assessment', 'th'));
  return entry!.data;
}
