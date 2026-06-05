# SmileScape — Web (Astro)

Static-first website for **SmileScape Dental Clinic** (`smilescapeclinic.com`).
Built with **Astro 4 + Tailwind**, deployed to **Cloudflare Workers (Static Assets)** —
mirroring the EYWA Astro reference stack (DR-EYWA-MKT-005), as run live by polyvex.

## Stack

| Concern        | Choice                                                        |
| -------------- | ------------------------------------------------------------ |
| Framework      | Astro 4 (SSG, content collections)                           |
| Styling        | Tailwind, fed by `../design/brand-foundation/tokens.json` (DR-029) |
| i18n           | TH (default, root) / EN (`/en/`), EN→TH fallback (SS-DR-012) |
| Analytics      | GTM via Partytown — no-op until `PUBLIC_GTM_ID` is set       |
| Deploy         | Cloudflare Workers Static Assets (`wrangler.jsonc`)          |
| Node           | 22 (`.nvmrc`)                                                |

## Commands

```bash
npm install        # install deps
npm run dev        # local dev server
npm run build      # static build → ./dist
npm run preview    # preview the build
npm run check      # astro + TS type check
npx wrangler deploy   # deploy ./dist to Cloudflare (needs CF auth)
```

## Layout

```
web/
├── astro.config.mjs        # site + i18n + integrations
├── tailwind.config.mjs     # imports ../design/brand-foundation/tokens.json
├── wrangler.jsonc          # Cloudflare Workers Static Assets
└── src/
    ├── layouts/Base.astro       # SEO + OG + hreflang + Dentist JSON-LD + analytics
    ├── components/
    │   ├── RelatedContent.astro  # STUB — DR-021 internal-linking render point
    │   ├── FaqBlock.astro        # STUB — FAQ accordion + FAQPage JSON-LD
    │   └── Analytics{Head,Body}.astro
    ├── content/
    │   ├── config.ts             # `pages` + `articles` collections (sitemap-aligned)
    │   └── pages/_example.md      # schema demo (delete when real content starts)
    ├── pages/{index, en/index}.astro
    └── styles/{global,fonts}.css
```

## SKELETON status

This is a scaffold, not the finished site:

- **Colors** in `tokens.json` are dental **placeholders** — lock in the brand session.
- **Fonts** (`public/fonts/`) are not committed yet — see `public/fonts/README.md`.
- **NAP / JSON-LD** values in `Base.astro` are placeholders — fill from operator data.
- `RelatedContent` / `FaqBlock` are **stubs** — the full build resolves relations
  from the content collections + Supabase entity-edge graph (DR-021).
