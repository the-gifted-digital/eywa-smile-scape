// Analytics config — Google Tag Manager via Partytown.
// No-op when PUBLIC_GTM_ID is unset (i.e. local dev / skeleton). Set it in
// Cloudflare env / .env once the GTM container exists.

export const GTM_ID = import.meta.env.PUBLIC_GTM_ID ?? 'GTM-NFBVZT43';
export const analyticsEnabled = GTM_ID.length > 0;
