// Path of Nur — the two scenes the Good Manners rewrite (C5) still needed.
//
// The manners books read on their K3 scenes (generate_kids_story_scenes.mjs);
// only Bismillah Before Eating had no cast picture, so Amina gets her soup.
// Same hand as the kit: outline cast, plain faces, a firefly on every scene,
// subjects between y=215 and y=985 of 1200.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_manners_art.mjs
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as K from './scene_kit.mjs';
import * as S from './story_helpers.mjs';

const { CREAM, GOLD, WOOD, SEA_LIGHT, room, archWindow, table, lantern, hangLine, glass, sparkle, firefly, child, scene, vignette, H } = K;

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = { scenes: [join(ROOT, 'assets/images/kids_books/scenes'), 1600, 1200] };
const SCENES = [];
const add = (name, fn, kind = 'scenes') => SCENES.push([kind, name, fn]);
const withFirefly = (parts, x, y) => scene([...parts, firefly(x, y, 1.2)]);

const soupBowl = (x, gy, s, full = true) => `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -120 -60 Q -120 0 0 0 Q 120 0 120 -60 Z" fill="#B0743B"/><ellipse cx="0" cy="-60" rx="120" ry="30" fill="#8A5A36"/>` +
  (full ? `<ellipse cx="0" cy="-62" rx="104" ry="22" fill="#E8B36A"/><path d="M -40 -110 q 10 -20 0 -40 M 0 -116 q 10 -20 0 -40 M 40 -110 q 10 -20 0 -40" stroke="${CREAM}" stroke-width="6" fill="none" stroke-linecap="round" opacity="0.7"/>` : `<ellipse cx="0" cy="-62" rx="104" ry="22" fill="#6E4629"/>`) + `</g>`;
const bread = (x, gy, s) => `<g transform="translate(${x} ${gy}) scale(${s})"><ellipse cx="0" cy="-16" rx="90" ry="26" fill="#D9A05B"/><ellipse cx="0" cy="-24" rx="84" ry="22" fill="#E8C089"/><path d="M -40 -30 q 8 -8 16 0 M 0 -34 q 8 -8 16 0 M 36 -30 q 8 -8 16 0" stroke="#B0743B" stroke-width="5" fill="none" stroke-linecap="round"/></g>`;

add('manners_amina_soup', () => withFirefly([
  room(true), archWindow(1240, 120, 240, 340, false), hangLine(360, 420, 0.9), lantern(360, 420, 0.9), table(H * 0.72),
  soupBowl(820, 864, 1.0, true), bread(1080, 864, 1.0), glass(600, 864, 1.0), child('amina', { x: 440, y: 1010, s: 0.9, arms: 'out' }), vignette(0.16),
], 1000, 640));
add('manners_amina_thanks', () => withFirefly([
  room(true), archWindow(1240, 120, 240, 340, false), hangLine(360, 420, 0.9), lantern(360, 420, 0.9), table(H * 0.72),
  soupBowl(820, 864, 1.0, false), glass(600, 864, 1.0), sparkle(820, 700, 16, GOLD), child('amina', { x: 440, y: 1010, s: 0.9, arms: 'up' }), vignette(0.16),
], 1000, 640));

mkdirSync(SVG_OUT, { recursive: true });
for (const [dir] of Object.values(OUT)) mkdirSync(dir, { recursive: true });
const report = [];
for (const [kind, name, fn] of SCENES) {
  const [dir, w, h] = OUT[kind];
  K.setCanvas(w, h);
  const svgPath = join(SVG_OUT, `${name}.svg`);
  writeFileSync(svgPath, fn());
  const png = join(SVG_OUT, `${name}.png`);
  let r = spawnSync('rsvg-convert', ['-w', String(w), '-h', String(h), '-o', png, svgPath]);
  if (r.status !== 0) throw new Error(`rsvg-convert failed for ${name}: ${r.stderr}`);
  const webp = join(dir, `${name}.webp`);
  r = spawnSync('cwebp', ['-quiet', '-q', '80', png, '-o', webp]);
  if (r.status !== 0) throw new Error(`cwebp failed for ${name}: ${r.stderr}`);
  unlinkSync(png);
  report.push(`${kind}/${name}.webp ${(statSync(webp).size / 1024).toFixed(1)} KB`);
}
console.log(report.join('\n'));
