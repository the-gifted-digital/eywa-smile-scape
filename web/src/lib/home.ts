import { getEntry } from 'astro:content';

export type Locale = 'th' | 'en';

/** Load the composed homepage data for a locale (falls back to th). */
export async function getHome(locale: Locale) {
  const entry = (await getEntry('home', locale)) ?? (await getEntry('home', 'th'));
  return entry!.data;
}
