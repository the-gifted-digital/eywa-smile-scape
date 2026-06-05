/**
 * SmileScape Tailwind config — consumes design tokens from ../design/brand-foundation/tokens.json
 *
 * Per EYWA DR-029 (Universal Brand Design System) + DR-EYWA-MKT-005 (Astro stack profile):
 *   tokens.json is the source of truth → tailwind.config.mjs imports it → CSS regenerates on build.
 *
 * To change colors / typography / spacing: edit ../design/brand-foundation/tokens.json,
 * then `npm run dev` or `npm run build` regenerates the Tailwind CSS bundle.
 *
 * In components, use semantic Tailwind classes that map to tokens:
 *   ✅ bg-brand-primary, text-brand-anchor, bg-brand-paper, font-sans
 *   ❌ bg-blue-600, text-slate-900  (raw Tailwind palette — bypasses the token system)
 *
 * Brand palette exposed (SKELETON — dental placeholder, lock in brand session):
 *   brand.anchor          — deep navy-teal for dark surfaces, footer, deep contrast
 *   brand.primary         — clean clinical blue (CTAs, links, wordmark)
 *   brand.primary-deep    — hover/active state of primary
 *   brand.primary-soft    — light blue tint (card bg, chip bg)
 *   brand.highlight       — sky blue (inline emphasis, hover-fill)
 *   brand.ice             — ultralight blue (section bg alternate)
 *   brand.paper           — warm off-white (section bg alternate — pair with ONE, not both)
 *   brand.accent          — fresh mint/teal (clean & healthy moments only, NEVER warm)
 *   brand.neutral.{0..1000} — slate scale (0=white, 1000=black)
 */

import tokens from '../design/brand-foundation/tokens.json' with { type: 'json' };

// Helpers to extract DTCG-format token values
const v = (node) => node?.value;
const palette = (group) =>
  Object.fromEntries(
    Object.entries(group)
      .filter(([k]) => !k.startsWith('_'))
      .map(([k, n]) => [k, v(n)])
  );

const color = tokens.color;
const type = tokens.typography;

/** @type {import('tailwindcss').Config} */
export default {
  content: ['./src/**/*.{astro,html,js,jsx,md,mdx,svelte,ts,tsx,vue}'],
  theme: {
    extend: {
      fontFamily: {
        sans: v(type.fontFamily.sans).split(',').map((s) => s.trim().replace(/^['"]|['"]$/g, '')),
        mono: v(type.fontFamily.mono).split(',').map((s) => s.trim().replace(/^['"]|['"]$/g, '')),
      },
      colors: {
        brand: {
          // Anchor + primary family
          anchor: v(color.brand.anchor),
          primary: v(color.brand.primary),
          'primary-deep': v(color.brand['primary-deep']),
          'primary-soft': v(color.brand['primary-soft']),

          // Supporting blues
          highlight: v(color.brand.highlight),
          ice: v(color.brand.ice),

          // Alternate light surface
          paper: v(color.brand.paper),

          // Single sanctioned accent (mint/teal — NEVER warm)
          accent: v(color.brand.accent),

          // Neutral scale (Tailwind-default slate)
          neutral: palette(color.brand.neutral),
        },
      },
      fontSize: palette(type.scale),
      lineHeight: palette(type.lineHeight),
      letterSpacing: palette(type.letterSpacing),
      fontWeight: palette(type.fontWeight),
      spacing: palette(tokens.spacing),
      screens: palette(tokens.breakpoint),
      maxWidth: palette(tokens.layout.maxWidth),
      borderRadius: palette(tokens.radius),
      boxShadow: palette(tokens.shadow),
      transitionDuration: palette(tokens.motion.duration),
      transitionTimingFunction: palette(tokens.motion.ease),
    },
  },
  plugins: [],
};
