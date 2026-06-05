import { defineConfig } from 'astro/config';
import sitemap from '@astrojs/sitemap';
import tailwind from '@astrojs/tailwind';
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
  // NO prefix; en served under /en/. zh is a future locale (add when ready).
  i18n: {
    defaultLocale: 'th',
    locales: ['th', 'en'],
    routing: { prefixDefaultLocale: false },
    fallback: { en: 'th' },
  },

  integrations: [
    sitemap({
      i18n: {
        defaultLocale: 'th',
        locales: { th: 'th-TH', en: 'en-US' },
      },
    }),
    tailwind({ applyBaseStyles: false }),
    partytown({ config: { forward: ['dataLayer.push'] } }),
  ],

  build: { format: 'directory', inlineStylesheets: 'always', assets: '_astro' },
  compressHTML: true,
});
