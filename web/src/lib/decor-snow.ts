// decor-snow.ts — the "snow" theme runtime (falling snowflakes + crossing motif).
// Split out from DecorLayer.astro so the theme is self-contained and reusable.
// Called by DecorLayer's client script when a preset's theme === 'snow'.
// Snow CSS + keyframes live in DecorLayer.astro's <style is:global> (styles the
// nodes this file injects).
import type { DecorMotif, SnowDensity } from './decor';

const SNOWFLAKE =
  '<path d="M10 4l2 1l2 -1" /><path d="M12 2v6.5l3 1.72" /><path d="M17.928 6.268l.134 2.232l1.866 1.232" /><path d="M20.66 7l-5.629 3.25l.01 3.458" /><path d="M19.928 14.268l-1.866 1.232l-.134 2.232" /><path d="M20.66 17l-5.629 -3.25l-2.99 1.738" /><path d="M14 20l-2 -1l-2 1" /><path d="M12 22v-6.5l-3 -1.72" /><path d="M6.072 17.732l-.134 -2.232l-1.866 -1.232" /><path d="M3.34 17l5.629 -3.25l-.01 -3.458" /><path d="M4.072 9.732l1.866 -1.232l.134 -2.232" /><path d="M3.34 7l5.629 3.25l2.99 -1.738" />';
// navy tints read on light sections, white on dark (navy) sections.
const COLORS = ['rgba(255,255,255,.95)', 'rgba(255,255,255,.85)', 'rgba(143,182,224,.9)', 'rgba(20,56,107,.38)', 'rgba(110,159,216,.85)'];

export function runSnow(host: HTMLElement, density: SnowDensity, motifs: DecorMotif[]) {
  const base = density === 'light' ? 18 : density === 'heavy' ? 56 : 34;
  const count = window.matchMedia('(max-width: 767px)').matches ? Math.ceil(base / 2) : base;

  let flakes = '';
  for (let i = 0; i < count; i++) {
    const size = 11 + Math.floor(Math.random() * 12);
    const left = (Math.random() * 100).toFixed(2);
    const dur = (7 + Math.random() * 6).toFixed(1);
    const delay = (-Math.random() * 12).toFixed(1);
    const sway = Math.round(Math.random() * 60 - 30);
    const spin = (Math.floor(Math.random() * 5) * 100 + 120) * (Math.random() < 0.5 ? -1 : 1);
    const op = (0.5 + Math.random() * 0.45).toFixed(2);
    const col = COLORS[Math.floor(Math.random() * COLORS.length)];
    flakes += `<span class="decor-flake" style="left:${left}%;width:${size}px;height:${size}px;color:${col};opacity:${op};--sway:${sway}px;--spin:${spin}deg;animation-duration:${dur}s;animation-delay:${delay}s"><svg viewBox="0 0 24 24"><use href="#decor-flake-sym" /></svg></span>`;
  }

  host.innerHTML =
    `<svg width="0" height="0" aria-hidden="true" style="position:absolute;width:0;height:0;overflow:hidden"><symbol id="decor-flake-sym" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">${SNOWFLAKE}</symbol></svg>` +
    `<div class="decor-snow">${flakes}</div>` +
    `<div id="decor-motif"></div>`;

  startMotif(motifs);
}

function startMotif(motifs: DecorMotif[]) {
  const slot = document.getElementById('decor-motif');
  if (!slot || !motifs.length) return;

  const I = (paths: string) =>
    `<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${paths}</svg>`;
  const SVGS: Record<DecorMotif, string> = {
    snowman: I('<path d="M12 3a4 4 0 0 1 2.906 6.75a6 6 0 1 1 -5.81 0a4 4 0 0 1 2.904 -6.75" /><path d="M17.5 11.5l2.5 -1.5" /><path d="M6.5 11.5l-2.5 -1.5" /><path d="M12 13h.01" /><path d="M12 16h.01" />'),
    'christmas-tree': I('<path d="M12 3l4 4l-2 1l4 4l-3 1l4 4h-14l4 -4l-3 -1l4 -4l-2 -1l4 -4" /><path d="M14 17v3a1 1 0 0 1 -1 1h-2a1 1 0 0 1 -1 -1v-3" />'),
    deer: I('<path d="M3 3c0 2 1 3 4 3c2 0 3 1 3 3" /><path d="M21 3c0 2 -1 3 -4 3c-2 0 -3 .333 -3 3" /><path d="M12 18c-1 0 -4 -3 -4 -6c0 -2 1.333 -3 4 -3s4 1 4 3c0 3 -3 6 -4 6" /><path d="M15.185 14.889l.095 -.18a4 4 0 1 1 -6.56 0" /><path d="M17 3c0 1.333 -.333 2.333 -1 3" /><path d="M7 3c0 1.333 .333 2.333 1 3" /><path d="M7 6c-2.667 .667 -4.333 1.667 -5 3" /><path d="M17 6c2.667 .667 4.333 1.667 5 3" /><path d="M8.5 10l-1.5 -1" /><path d="M15.5 10l1.5 -1" /><path d="M12 15h.01" />'),
  };

  let prev = '';
  const pick = (): DecorMotif => {
    let m: DecorMotif;
    do {
      m = motifs[Math.floor(Math.random() * motifs.length)];
    } while (m === prev && motifs.length > 1);
    prev = m;
    return m;
  };

  const runOnce = () => {
    if (!slot.isConnected) return;
    slot.innerHTML = `<span class="decor-bob">${SVGS[pick()]}</span>`;
    slot.classList.remove('run');
    void slot.offsetWidth;
    slot.classList.add('run');
  };

  slot.addEventListener('animationend', (e) => {
    if (e.target !== slot || !slot.isConnected) return;
    slot.classList.remove('run');
    setTimeout(runOnce, 15000 + Math.random() * 20000);
  });

  setTimeout(runOnce, 1500);
}
