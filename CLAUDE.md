# SmileScape (eywa-smile-scape) — Session Briefing

> Auto-loaded by every Claude Code session in this repo. Read the banner first.
> When the live deployment state changes, **update this banner** so all sessions stay in sync.

## ⚡ CURRENT LIVE STATUS — updated 2026-06-12 (SS-DR-017)

- **`go.smilescapeclinic.com` is the LIVE *temporary production* domain.** Astro → Cloudflare Workers + Static Assets. Treat it as real production (Google-Ads landing pages, demos, sharing) while content is filled in.
- **WordPress still serves the apex `smilescapeclinic.com`.** Do **NOT** add an apex route or repoint apex DNS until the formal cutover.
- **The whole `go.` domain is `noindex` — keep it that way until cutover.** Enforced by two independent layers; do not weaken either:
  1. Per-page `<meta name="robots" content="noindex,follow">` — the default in `web/src/layouts/Base.astro` **and** `Landing.astro`. New pages inherit it automatically.
  2. Host-scoped `X-Robots-Tag: noindex` in `web/worker/index.ts` for every non-apex host. Requires `assets.run_worker_first: true` in `web/wrangler.jsonc` (without it, static assets bypass the worker and the header is skipped). Self-disables on apex at cutover.
- **`astro.config.mjs` `site` stays `https://smilescapeclinic.com` (apex) on purpose** — canonicals/hreflang/sitemap pre-point at the future apex. Don't "fix" this to `go.` (harmless while noindex; makes cutover a near-no-op).
- **Apex cutover is NOT done.** Full step-by-step in **SS-DR-017** (`docs/decision-records.md`). Do not start it without operator go-ahead (content-complete + compliance-cleared).
- **Deploy:** `cd web && npm run build && npx wrangler deploy` → ships everything to `go.smilescapeclinic.com`. Active branch: **`web-skeleton`**.

## Map / where to look
- **Decisions:** `docs/decision-records.md` — SmileScape entries are `SS-DR-0xx` (latest: SS-DR-017).
- **Handover / current state:** `docs/HANDOVER-2026-06-07.md`.
- **Web app:** `web/` (Astro 7 + Tailwind 4, i18n th default / en / zh-cn, fonts self-hosted). Worker also handles `POST /api/assessment-lead` → n8n + Resend.
  - **Stack notes (upgraded 2026-06-29, 4→7):** Tailwind v4 runs via **`@tailwindcss/postcss`** (`postcss.config.mjs`), NOT `@tailwindcss/vite` — the Vite plugin breaks on Astro 7's Rolldown-based Vite (`createIdResolver`). `@astrojs/tailwind` removed (no Astro 6/7 support). The DTCG token bridge (`design/brand-foundation/tokens.json` → `tailwind.config.mjs`) is preserved via `@config` in `src/styles/global.css`, which `@import 'tailwindcss/index.css'` (explicit path — Vite won't resolve the bare `tailwindcss` specifier). Content collections use **Content Layer `glob()` loaders** in `src/content.config.ts` (moved from `src/content/config.ts`). global.css has two v4-preflight shims (border-color + button cursor); tailwind.config restores v3 `DEFAULT`/`sm` aliases for bare `shadow`/`rounded`/`blur`.
- **Media/DAM pipeline (Session A, blocked on R2):** `docs/SESSION-A-MEDIA-PIPELINE.md` (SS-DR-015/016).
- **Supabase schema + data load (Session B):** `deployment/supabase-load/`.
- **Content templates (separate branch `content-templates`, not merged):** see `docs/`.

## Standing constraints
- Don't drop `noindex` on `go.` pages, and don't touch the apex until the SS-DR-017 cutover.
- Pending operator inputs: per-branch NAP / Google Place IDs / socials, compliance review of before-after photos + guarantee wording, media migration off the repo to Cloudflare.
