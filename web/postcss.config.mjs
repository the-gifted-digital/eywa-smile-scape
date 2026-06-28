// Tailwind v4 via PostCSS. Astro 7 ships Rolldown-based Vite, which the
// @tailwindcss/vite plugin is not yet compatible with (it relies on the classic
// Vite `createIdResolver` API). The PostCSS plugin avoids Vite's resolver
// internals entirely. Tailwind's `@import "tailwindcss"` + `@config` directives
// in src/styles/global.css are processed here.
export default {
  plugins: {
    '@tailwindcss/postcss': {},
  },
};
