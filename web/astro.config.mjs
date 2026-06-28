import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import partytown from '@astrojs/partytown';

// SmileScape Dental Clinic — Astro config.
// Mirrors the EYWA Astro stack profile (DR-EYWA-MKT-005) as adopted live by
// eywa-polyvex (thaipolyvex.com). Differences from polyvex:
//   - site = smilescapeclinic.com
//   - i18n th (default) / en, TH-first, EN falls back to TH (SS-DR-012)
export default defineConfig({
  site: 'https://smilescapeclinic.com',
  trailingSlash: 'always',

  // TH-first multilingual (SS-DR-012). Default locale (th) served at root with
  // NO prefix; en served under /en/; zh-cn served under /zh-cn/.
  i18n: {
    defaultLocale: 'th',
    locales: ['th', 'en', 'zh-cn'],
    routing: { prefixDefaultLocale: false },
    fallback: { en: 'th', 'zh-cn': 'th' },
  },

  integrations: [
    sitemap({
      i18n: {
        defaultLocale: 'th',
        locales: { th: 'th-TH', en: 'en-US', 'zh-cn': 'zh-CN' },
      },
    }),
    partytown({ config: { forward: ['dataLayer.push'] } }),
  ],

  // Tailwind v4 runs through PostCSS (postcss.config.mjs), NOT @tailwindcss/vite —
  // the Vite plugin calls a classic-Vite API (createIdResolver) that Astro 7's
  // Rolldown-based Vite doesn't implement. The @astrojs/tailwind integration was
  // dropped (no Astro 6/7 support). The DTCG token bridge still lives in
  // tailwind.config.mjs, loaded via `@config` in src/styles/global.css.

  build: { format: 'directory', inlineStylesheets: 'always', assets: '_astro' },
  compressHTML: true,
});
