/// <reference path="../.astro/types.d.ts" />

interface ImportMetaEnv {
  /** Google Tag Manager container ID (e.g. GTM-XXXXXXX). Analytics is a no-op when unset. */
  readonly PUBLIC_GTM_ID?: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
