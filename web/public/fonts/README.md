# Fonts — self-hosted woff2 (PLACEHOLDER)

The brand default typeface is **LINE Seed Sans Thai** (carry-over from the EYWA
Astro reference stack, DR-EYWA-MKT-005). The font files are **not committed yet**.

Until the woff2 files are added here, `src/styles/fonts.css` falls back silently
to the `system-ui` stack — the site builds and renders fine.

## To activate the brand font

1. Download LINE Seed Sans Thai from **seed.line.me** (SIL Open Font License).
2. Drop these three files into this folder:
   - `LINESeedSansTH-Rg.woff2`
   - `LINESeedSansTH-Bd.woff2`
   - `LINESeedSansTH-He.woff2`
3. Uncomment the two `<link rel="preload" …>` lines in `src/layouts/Base.astro`.

> ⚠️ The typeface choice is provisional. Confirm or swap it in the brand session
> before launch (see `design/brand-foundation/tokens.json` → typography._status).
