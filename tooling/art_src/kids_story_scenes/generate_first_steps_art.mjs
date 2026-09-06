// Path of Nur — art for the First Steps books (C3).
//
// Thirteen foundations books told through the cast: Safa (7), Zayn (5) and
// Amina (4), drawn the way the salah trainer draws its figure (outline,
// plain face). Same hand as the K3 scene kit: silhouettes, no faces, no
// text baked in, a firefly on every scene, subjects between y=215 and
// y=985 of 1200 because the reader crops the 4:3 picture to a wide band.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_first_steps_art.mjs          # all
//   node tooling/art_src/kids_story_scenes/generate_first_steps_art.mjs steps_wudu  # a subset
//
// Output:
//   assets/images/kids_books/scenes/steps_<name>.webp   (1600x1200)
//   assets/images/kids_books/covers/<book>_cover.webp   (1024x1024)
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as K from './scene_kit.mjs';
import * as S from './story_helpers.mjs';

const {
  IVORY, CREAM, GOLD, DEEPGOLD, INK, INK_SOFT, WOOD, WOOD_DARK, WOOD_LIGHT, SEA, SEA_DEEP, SEA_LIGHT, SEA_FOAM,
  GREEN, GREEN_DEEP, LEAF, LEAF_LIGHT, SAND, SAND_DARK, SAND_LIGHT, STONE, STONE_DARK, STONE_LIGHT, WALL, WALL_DEEP,
  SKY, skyRect, glow, vignette, stars, crescent, fullMoon, sun, lightRays, hills, dunes, mountains, cloud, stormCloud,
  rain, sparkle, star8, firefly, lantern, hangLine, mosque, minaret, dome, city, palm, tree, grass, rock, dove, bird,
  room, archWindow, table, prayerMat, kaaba, coinBox, coin, bowlOfDates, glass, cushion, child, scene, groundBand, f,
  LINE, SKIN, CAST, TROUSER, CAP, CAP_BAND, sack, jar,
} = K;

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = {
  scenes: [join(ROOT, 'assets/images/kids_books/scenes'), 1600, 1200],
  covers: [join(ROOT, 'assets/images/kids_books/covers'), 1024, 1024],
};
const ONLY = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const SCENES = [];
const add = (name, fn, kind = 'scenes') => SCENES.push([kind, name, fn]);
let W = 1600, H = 1200;
const withFirefly = (parts, x, y) => scene([...parts, firefly(x, y, 1.2)]);
const floorBand = (y, color = WOOD) => `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/><rect x="0" y="${y}" width="${W}" height="18" fill="#54382A"/>`;

// ---------------------------------------------------------------- cast --
// A child in sujud: forehead to the ground, the way a child copies it.
function childSujud(who, { x, y, s = 1, flip = false }) {
  const c = CAST[who];
  const o = (d, fill) => `<path d="${d}" fill="${fill}" stroke="${LINE}" stroke-width="7" stroke-linejoin="round"/>`;
  let out = o('M -40 0 L -10 -170 Q 40 -220 120 -190 Q 170 -170 180 -80 L 200 0 Z', c.kurta);
  out += o('M -40 0 L -70 -60 Q -30 -90 10 -60 Z', TROUSER);
  out += `<circle cx="228" cy="-14" r="34" fill="${SKIN}" stroke="${LINE}" stroke-width="7"/>`;
  if (c.head === 'scarf') out += o('M 190 -30 Q 200 -80 240 -70 Q 290 -60 280 -6 Q 270 30 232 24 Q 196 20 190 -30 Z', c.scarf) + `<circle cx="228" cy="-14" r="26" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>`;
  else out += o('M 196 -36 Q 228 -74 262 -36 Z', CAP);
  out += `<path d="M 60 -160 L 150 -20" stroke="${LINE}" stroke-width="28" stroke-linecap="round"/><path d="M 60 -160 L 150 -20" stroke="${c.kurta}" stroke-width="16" stroke-linecap="round"/><circle cx="150" cy="-20" r="14" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>`;
  return `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})">${out}</g>`;
}
// A sleeping child: a bed, a blanket, a head on the pillow.
function childAsleep(who, { x, y, s = 1 }) {
  const c = CAST[who];
  return `<g transform="translate(${x} ${y}) scale(${s})">` +
    `<rect x="-260" y="-120" width="520" height="120" rx="20" fill="${WOOD}"/><rect x="-250" y="-140" width="500" height="40" rx="14" fill="${IVORY}"/>` +
    `<rect x="-250" y="-180" width="150" height="60" rx="24" fill="${CREAM}"/>` +
    `<path d="M -100 -130 Q 0 -200 250 -150 V -100 H -100 Z" fill="${c.kurta}"/>` +
    `<circle cx="-170" cy="-170" r="40" fill="${SKIN}" stroke="${LINE}" stroke-width="7"/>` +
    (c.head === 'scarf' ? `<path d="M -215 -180 Q -210 -240 -160 -230 Q -115 -225 -120 -170 Q -125 -130 -170 -128 Q -215 -130 -215 -180 Z" fill="${c.scarf}" stroke="${LINE}" stroke-width="6"/><circle cx="-170" cy="-170" r="30" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>` : '') +
    `</g>`;
}
const ball = (x, y, s, color = '#B8683C') => `<g transform="translate(${x} ${y}) scale(${s})"><circle r="40" fill="${color}" stroke="${LINE}" stroke-width="6"/><path d="M -40 0 Q 0 -30 40 0 M -40 0 Q 0 30 40 0" stroke="${LINE}" stroke-width="5" fill="none"/></g>`;

// ------------------------------------------------------------ objects --
const soundArcs = (cx, cy, n = 3, r0 = 90, color = GOLD) => Array.from({ length: n }, (_, i) => `<path d="M ${cx + (r0 + i * 60) * 0.7} ${cy - (r0 + i * 60) * 0.7} A ${r0 + i * 60} ${r0 + i * 60} 0 0 1 ${cx + (r0 + i * 60) * 0.7} ${cy + (r0 + i * 60) * 0.7}" stroke="${color}" stroke-width="10" fill="none" stroke-linecap="round" opacity="${0.8 - i * 0.2}"/>`).join('');
const tap = (x, y, s) => `<g transform="translate(${x} ${y}) scale(${s})"><rect x="-14" y="-160" width="28" height="140" rx="10" fill="${STONE_LIGHT}"/><path d="M 0 -150 H 90 Q 120 -150 120 -120 V -90" stroke="${STONE_LIGHT}" stroke-width="28" fill="none" stroke-linecap="round"/><rect x="-40" y="-190" width="80" height="24" rx="10" fill="${STONE}"/><path d="M 120 -90 v 120" stroke="${SEA_LIGHT}" stroke-width="16" stroke-linecap="round" opacity="0.85"/></g>`;
const basin = (cx, baseY, s) => `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -180 -90 A 180 180 0 0 0 180 -90 L 160 -60 Q 0 0 -160 -60 Z" fill="${STONE_LIGHT}"/><ellipse cx="0" cy="-90" rx="180" ry="40" fill="${STONE}"/><ellipse cx="0" cy="-90" rx="150" ry="28" fill="${SEA_LIGHT}"/></g>`;
const suitcase = (x, y, s, color = '#8A4A28') => `<g transform="translate(${x} ${y}) scale(${s})"><rect x="-110" y="-150" width="220" height="150" rx="14" fill="${color}"/><rect x="-40" y="-176" width="80" height="30" rx="12" fill="none" stroke="${WOOD_DARK}" stroke-width="10"/><rect x="-110" y="-90" width="220" height="12" fill="${WOOD_DARK}" opacity="0.5"/></g>`;
const scrollPen = (x, y, s, flip = false) => `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})">${S.scroll(0, 0, 1.2)}<path d="M 40 -40 L 160 -120" stroke="${SAND_DARK}" stroke-width="14" stroke-linecap="round"/><path d="M 40 -40 l 16 -22 l 10 18 Z" fill="${INK}"/></g>`;
const goldenGate = (cx, baseY, s) => `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -260 0 V -320 Q -260 -520 0 -520 Q 260 -520 260 -320 V 0 Z" fill="${DEEPGOLD}"/><path d="M -220 0 V -320 Q -220 -480 0 -480 Q 220 -480 220 -320 V 0 Z" fill="${GOLD}"/>` +
  [-150, -75, 0, 75, 150].map((x) => `<rect x="${x - 8}" y="-470" width="16" height="470" fill="${DEEPGOLD}"/>`).join('') + `<path d="M -220 -200 H 220" stroke="${DEEPGOLD}" stroke-width="14"/></g>` + glow(cx, baseY - 260 * s, 380 * s, CREAM, 0.4);
const riverBands = (yTop) => [['#4F7C9A', SEA_FOAM], ['#F3EEE1', '#FFFFFF'], ['#D9A05B', '#E8C089'], ['#8A4A6A', '#B07A9A']].map(([c, hi], i) => `<path d="M0 ${yTop + i * 62 + 30} Q ${W * 0.25} ${yTop + i * 62 - 20} ${W * 0.5} ${yTop + i * 62 + 20} T ${W} ${yTop + i * 62} V ${yTop + i * 62 + 62} H 0 Z" fill="${c}"/><path d="M ${W * 0.1} ${yTop + i * 62 + 22} q 60 -14 120 0" stroke="${hi}" stroke-width="6" fill="none" opacity="0.6"/>`).join('');
const fruitTree = (x, gy, s) => tree(x, gy, s, WOOD_DARK, LEAF, LEAF_LIGHT) + [[-60, -190], [30, -240], [70, -160], [-20, -140]].map(([dx, dy]) => S.fruit(x + dx * s, gy + dy * s, s * 1.1, '#B8683C')).join('');
const namesLattice = (cx, cy, seed = 99) => { const rnd = K.mulberry32(seed); let out = ''; for (let i = 0; i < 99; i++) { const a = rnd() * Math.PI * 2, r = 80 + rnd() * 420; out += sparkle(cx + Math.cos(a) * r, cy + Math.sin(a) * r * 0.6, 8 + rnd() * 10, GOLD, 0.5 + rnd() * 0.5); } return out; };
const lanternRow = (y, n = 6, s = 0.9) => Array.from({ length: n }, (_, i) => { const x = 200 + i * 240; return hangLine(x, y, s) + lantern(x, y, s); }).join('');
const bookRow = (cx, baseY, s, colors = ['#4A5D8A', '#2E5D48', '#8A4A28', '#B98A3E']) => `<g transform="translate(${cx} ${baseY}) scale(${s})">` + colors.map((c, i) => `<rect x="${-260 + i * 130}" y="${-200 - (i % 2) * 20}" width="110" height="${200 + (i % 2) * 20}" rx="8" fill="${c}"/><rect x="${-250 + i * 130}" y="${-190 - (i % 2) * 20}" width="90" height="14" fill="${GOLD}" opacity="0.7"/>`).join('') + `</g>`;
const steppingStones = (seed = 3) => { let out = ''; for (let i = 0; i < 12; i++) { const t = i / 11; const x = 160 + t * 1280, y = 985 - Math.sin(t * Math.PI) * 120 - (i % 2) * 40; out += `<ellipse cx="${f(x)}" cy="${f(y)}" rx="54" ry="22" fill="${STONE_LIGHT}"/>`; } return out; };
const whiteCloths = (x, y, s) => `<g transform="translate(${x} ${y}) scale(${s})"><path d="M -300 0 Q 0 30 300 0" stroke="${WOOD_DARK}" stroke-width="6" fill="none"/><path d="M -240 6 V 160 H -120 V 10 Z" fill="${IVORY}"/><path d="M -60 12 V 170 H 60 V 12 Z" fill="${IVORY}"/><path d="M 120 10 V 160 H 240 V 4 Z" fill="${IVORY}"/></g>`;

// ============================================================ Who Is Allah ==
add('steps_allah_sky', () => withFirefly([
  skyRect(SKY.day, 0, H, 0, 800), skyRect(SKY.night, 0, H, 800, W), `<rect x="770" y="0" width="60" height="${H}" fill="#3A4A6A" opacity="0.5"/>`,
  sun(400, 300, 90, CREAM, '#E8C089', 12), stars(23, 90, 820, W, 0, 700), crescent(1200, 280, 70), star8(1400, 500, 22),
  hills('#7C9F6E', 780, 60), hills('#3F5A48', 880, 50), groundBand('#2E4A3A', 985), tree(800, 985, 1.2, WOOD_DARK, LEAF, LEAF_LIGHT), vignette(0.16),
], 1000, 620));
add('steps_allah_garden', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), cloud(1000, 200, 130, 38, 0.5), hills('#7C9F6E', 720, 60), hills('#5F8A5A', 820, 50), groundBand('#4F7C4A', 985),
  tree(260, 940, 1.2), tree(1340, 920, 1.3), dove(700, 460, 1.0), bird(1100, 400, 3), bird(1160, 370, 2.4),
  [[200, 985], [420, 970], [1000, 975], [1200, 985], [1480, 980]].map(([x, y]) => sparkle(x, y, 12, '#E2C177') + sparkle(x + 36, y + 10, 9, '#F0E4C0')).join(''),
  child('safa', { x: 620, y: 985, s: 1.0, arms: 'up' }), child('zayn', { x: 900, y: 985, s: 0.88, arms: 'up', flip: true }), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 1400, 560));
add('steps_allah_night_lamp', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), floorBand(985, '#8A4A28'), hangLine(400, 420, 0.9), lantern(400, 420, 0.9),
  child('amina', { x: 800, y: 985, s: 0.95, pose: 'sit', arms: 'out' }), glow(800, 800, 260, CREAM, 0.3), vignette(0.2),
], 1000, 640));
add('steps_allah_names', () => withFirefly([
  skyRect(SKY.emeraldLift), glow(800, 600, 560, CREAM, 0.3), namesLattice(800, 600), star8(800, 600, 60, GOLD), hills('#3F5A48', 960, 40), groundBand('#2E4A3A', 985), vignette(0.16),
], 300, 400));

// ============================================================ The Words ==
add('steps_words_arch', () => withFirefly([
  skyRect(SKY.emeraldLift), stars(31, 40, 0, W, 0, 500, CREAM, 2), groundBand('#2E4A3A', 985), S.mihrab(800, 985, 1.3, GREEN_DEEP, '#16382C', CREAM),
  hangLine(800, 600, 1.0), lantern(800, 600, 1.0), sparkle(500, 400, 16), sparkle(1100, 360, 14), vignette(0.18),
], 1240, 620));
add('steps_words_kids', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), floorBand(985, '#8A4A28'), hangLine(1240, 420, 0.9), lantern(1240, 420, 0.9),
  child('safa', { x: 620, y: 985, s: 1.0, arms: 'out' }), child('zayn', { x: 980, y: 985, s: 0.88, arms: 'out', flip: true }), vignette(0.16),
], 800, 620));
add('steps_words_lantern_heart', () => withFirefly([
  skyRect(SKY.violetDusk), stars(7, 60, 0, W, 0, 500), glow(800, 640, 420, GOLD, 0.35), hangLine(800, 700, 1.4), lantern(800, 700, 1.4),
  sparkle(560, 520, 18), sparkle(1040, 500, 16), sparkle(660, 820, 12), sparkle(940, 840, 12), dunes('#4A3560', '#2C2347', 880), vignette(0.2),
], 1200, 400));

// ============================================================ We believe ==
add('steps_iman_lanterns', () => withFirefly([
  skyRect(SKY.night), stars(13, 80, 0, W, 0, 500), lanternRow(640, 6, 0.95), groundBand('#10132A', 985), city(985, '#1A1F33', null, 5, 0.8), vignette(0.22),
], 800, 900));
add('steps_iman_books', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), floorBand(985, '#8A4A28'), `<rect x="380" y="760" width="840" height="24" rx="6" fill="${WOOD_DARK}"/>`,
  bookRow(800, 760, 1.0), glow(800, 640, 300, CREAM, 0.25), vignette(0.16),
], 420, 560));
add('steps_iman_path', () => withFirefly([
  skyRect(SKY.dawn), lightRays(1440, 300, 7, 800, 1.2, CREAM, 0.12), sun(1440, 300, 70, CREAM, '#E8B36A'), dunes(SAND, SAND_DARK, 800), groundBand('#8A5348', 985),
  steppingStones(), star8(160, 780, 22), star8(1440, 640, 26), vignette(0.16),
], 800, 560));

// ============================================================ Five times ==
add('steps_salah_dawn_window', () => withFirefly([
  room(false), archWindow(800, 100, 320, 420, false), floorBand(985, '#8A4A28'), prayerMat(800, 880, 560, 100), hangLine(300, 420, 0.9), lantern(300, 420, 0.9), vignette(0.18),
], 1240, 620));
add('steps_salah_kids_standing', () => withFirefly([
  room(true), archWindow(1220, 130, 240, 340, false), floorBand(985, '#8A4A28'), prayerMat(560, 900, 380, 90), prayerMat(1000, 900, 380, 90),
  child('safa', { x: 560, y: 985, s: 1.0 }), child('zayn', { x: 1000, y: 985, s: 0.88 }), vignette(0.16),
], 380, 620));
add('steps_salah_sujud', () => withFirefly([
  room(true), archWindow(1220, 130, 240, 340, false), floorBand(985, '#8A4A28'), prayerMat(560, 900, 420, 90), prayerMat(1060, 900, 420, 90),
  childSujud('safa', { x: 420, y: 985, s: 1.0 }), childSujud('zayn', { x: 940, y: 985, s: 0.88 }), vignette(0.16),
], 700, 560));

// ================================================================= Wudu ==
add('steps_wudu_tap', () => withFirefly([
  skyRect([[0, '#DCE8E1'], [0.7, '#C9D8D2'], [1, '#B5C8C1']]), `<rect x="0" y="0" width="${W}" height="${H}" fill="#EEEBE2" opacity="0.4"/>`, floorBand(985, '#8A7F70'),
  tap(700, 760, 1.4), basin(820, 985, 1.2), S.puddle(1200, 985, 90, 18), vignette(0.14),
], 1100, 500));
add('steps_wudu_kid_basin', () => withFirefly([
  skyRect([[0, '#DCE8E1'], [0.7, '#C9D8D2'], [1, '#B5C8C1']]), floorBand(985, '#8A7F70'), tap(1040, 760, 1.2), basin(1140, 985, 1.0),
  child('zayn', { x: 700, y: 985, s: 1.0, arms: 'out' }), `<g stroke="${SEA_LIGHT}" stroke-width="8" stroke-linecap="round" opacity="0.8"><path d="M 880 760 q 20 -30 40 0 M 930 740 q 20 -30 40 0"/></g>`, vignette(0.14),
], 380, 560));
add('steps_wudu_feet', () => withFirefly([
  skyRect([[0, '#DCE8E1'], [0.7, '#C9D8D2'], [1, '#B5C8C1']]), floorBand(985, '#8A7F70'), S.puddle(800, 985, 260, 40), S.shoes(1200, 985, 1.2),
  `<ellipse cx="700" cy="960" rx="60" ry="24" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/><ellipse cx="880" cy="965" rx="60" ry="24" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>`,
  `<g stroke="${SEA_LIGHT}" stroke-width="8" stroke-linecap="round" opacity="0.8"><path d="M 640 900 q 20 -40 40 0 M 900 890 q 20 -40 40 0 M 780 880 q 20 -40 40 0"/></g>`, tap(400, 760, 1.2), vignette(0.14),
], 1300, 560));
add('steps_wudu_ready', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), floorBand(985, '#8A4A28'), prayerMat(800, 900, 520, 100),
  child('safa', { x: 800, y: 985, s: 1.0 }), sparkle(600, 560, 14), sparkle(1000, 540, 14), sparkle(800, 460, 12), vignette(0.16),
], 1240, 620));

// ============================================================= The Call ==
add('steps_adhan_minaret', () => withFirefly([
  skyRect(SKY.dawn), sun(300, 300, 80, CREAM, '#E8B36A', 12), city(900, '#8A5348', null, 11, 0.9), minaret(800, 985, 700, 80, '#3A2A1E'), soundArcs(860, 420, 3, 90),
  groundBand('#4A2F22', 985), dove(1200, 460, 0.9), vignette(0.16),
], 1360, 640));
add('steps_adhan_kids_listen', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70), hills('#7C9F6E', 760, 50), groundBand('#5F8A5A', 985), mosque(1300, 985, 0.55, GREEN), soundArcs(1160, 700, 3, 60),
  child('zayn', { x: 520, y: 985, s: 0.9 }), ball(700, 950, 0.9), child('safa', { x: 880, y: 985, s: 1.0, flip: true }), vignette(0.14),
], 300, 560));
add('steps_adhan_walk', () => withFirefly([
  skyRect(SKY.amber), sun(280, 240, 80, CREAM, '#E8B36A'), hills('#8A5348', 780, 40), groundBand('#6E4629', 985), mosque(1200, 985, 0.8, GREEN),
  `<path d="M 200 1100 Q 700 1000 1100 960" stroke="#C48A5C" stroke-width="80" fill="none" stroke-linecap="round" opacity="0.5"/>`,
  child('safa', { x: 560, y: 985, s: 1.0, flip: true }), child('zayn', { x: 760, y: 985, s: 0.88, flip: true }), vignette(0.16),
], 1000, 560));

// ============================================================== Sharing ==
add('steps_share_basket', () => withFirefly([
  room(true), archWindow(1220, 130, 240, 340, false), table(H * 0.72), S.basket(700, 900, 1.3), S.fruit(640, 850, 1.4), S.fruit(700, 830, 1.3, '#D9A05B'), S.fruit(760, 855, 1.2),
  bowlOfDates(1100, 985, 0.9), glow(800, 700, 260, CREAM, 0.25), vignette(0.16),
], 420, 600));
add('steps_share_give', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), floorBand(985, '#8A4A28'), hangLine(1240, 420, 0.9), lantern(1240, 420, 0.9),
  child('amina', { x: 620, y: 985, s: 0.85, arms: 'out' }), child('zayn', { x: 980, y: 985, s: 0.88, arms: 'out', flip: true }), S.bag(800, 850, 0.9, SAND_LIGHT), sparkle(800, 640, 14), vignette(0.16),
], 1000, 620));
add('steps_share_tree', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills('#7C9F6E', 760, 50), groundBand('#4F7C4A', 985), fruitTree(800, 985, 1.5),
  coin(560, 960, 0.8), coin(1040, 965, 0.8, 20), coin(800, 975, 0.7, -10), sparkle(600, 520, 14), sparkle(1000, 480, 12), vignette(0.14),
], 1300, 560));

// ============================================================== Ramadan ==
add('steps_ramadan_moon', () => withFirefly([
  skyRect(SKY.violetDusk), stars(5, 40, 0, W, 0, 400), crescent(1180, 260, 40), city(880, '#4A3560', GOLD, 9, 0.9), `<rect x="0" y="880" width="${W}" height="320" fill="#2C2347"/>`,
  `<rect x="200" y="860" width="1200" height="30" fill="#3E2A45"/>`, child('safa', { x: 640, y: 985, s: 1.0, arms: 'up' }), child('zayn', { x: 900, y: 985, s: 0.88, arms: 'up', flip: true }), vignette(0.2),
], 400, 560));
add('steps_ramadan_suhoor', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), table(H * 0.72), hangLine(400, 420, 0.9), lantern(400, 420, 0.9), bowlOfDates(700, 985, 0.9), glass(960, 985, 1.0), S.tray(1200, 985, 0.9), vignette(0.2),
], 1000, 620));
add('steps_ramadan_masjid_night', () => withFirefly([
  skyRect(SKY.night), stars(21, 100, 0, W, 0, 600), crescent(300, 220, 60), mosque(800, 985, 1.1, GREEN_DEEP), groundBand('#10132A', 985),
  hangLine(500, 560, 0.9), lantern(500, 560, 0.9), hangLine(1100, 560, 0.9), lantern(1100, 560, 0.9), glow(800, 800, 300, CREAM, 0.3), vignette(0.22),
], 1400, 640));
add('steps_ramadan_eid', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), lightRays(280, 220, 9, 900, 1.6, CREAM, 0.1), mosque(1200, 985, 0.7, GREEN), hills('#7C9F6E', 800, 40), groundBand('#5F8A5A', 985),
  child('safa', { x: 520, y: 985, s: 1.0, arms: 'up' }), child('zayn', { x: 760, y: 985, s: 0.88, arms: 'up', flip: true }), S.sweets(300, 985, 1.0), sparkle(640, 520, 16), sparkle(900, 480, 14), vignette(0.14),
], 1000, 560));

// ================================================================= Hajj ==
add('steps_hajj_ihram', () => withFirefly([
  room(true), archWindow(1220, 130, 240, 340, false), floorBand(985, '#8A4A28'), whiteCloths(700, 520, 1.0), suitcase(1100, 985, 1.0), S.shoes(760, 985, 1.1), vignette(0.16),
], 380, 620));
add('steps_hajj_tawaf', () => withFirefly([
  skyRect(SKY.dayClear), `<rect x="0" y="700" width="${W}" height="500" fill="${IVORY}"/>`, `<ellipse cx="800" cy="900" rx="620" ry="180" fill="none" stroke="${STONE_LIGHT}" stroke-width="40"/>`,
  S.footprints(3, 200, 900, 1400, 900, 24, SAND_DARK), kaaba(800, 880, 0.7), minaret(140, 700, 400, 40, STONE_LIGHT), minaret(1460, 700, 400, 40, STONE_LIGHT), vignette(0.14),
], 1200, 540));
add('steps_hajj_arafat', () => withFirefly([
  skyRect(SKY.amber), sun(1200, 240, 100, CREAM, '#E8B36A', 12), mountains('#8A5348', 985, [[0, 985], [500, 700], [800, 520], [1100, 720], [1600, 985]], 0.9), dunes(SAND, SAND_DARK, 900),
  glow(800, 560, 320, CREAM, 0.4), sparkle(600, 640, 14), sparkle(1000, 600, 14), vignette(0.16),
], 400, 620));
add('steps_hajj_pebbles', () => withFirefly([
  skyRect(SKY.day), sun(300, 220, 70), dunes(SAND, SAND_DARK, 800), groundBand('#B0743B', 985), `<rect x="700" y="640" width="200" height="345" rx="20" fill="${STONE}"/>`,
  S.pebbles(5, 30, 300, 1300, 985, STONE_LIGHT), S.pebbles(7, 12, 640, 960, 700, STONE_DARK), vignette(0.16),
], 1300, 560));

// ================================================================ Qur'an ==
add('steps_quran_shelf', () => withFirefly([
  room(false), archWindow(400, 130, 240, 340, true), floorBand(985, '#8A4A28'), `<rect x="600" y="620" width="600" height="24" rx="6" fill="${WOOD_DARK}"/>`,
  `<rect x="820" y="470" width="160" height="150" rx="10" fill="${GREEN_DEEP}"/><rect x="830" y="480" width="140" height="130" rx="8" fill="none" stroke="${GOLD}" stroke-width="5"/>`, glow(900, 540, 260, CREAM, 0.3), vignette(0.18),
], 1240, 620));
add('steps_quran_stand', () => withFirefly([
  room(true), archWindow(1220, 130, 240, 340, false), floorBand(985, '#8A4A28'), S.quranStand(800, 985, 1.4), glow(800, 800, 300, CREAM, 0.35), lightRays(800, 700, 5, 400, 1.1, CREAM, 0.1), vignette(0.16),
], 420, 600));
add('steps_quran_kids_reading', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), floorBand(985, '#8A4A28'), S.quranStand(800, 985, 1.1),
  child('safa', { x: 560, y: 985, s: 1.0, pose: 'sit' }), child('zayn', { x: 1060, y: 985, s: 0.88, pose: 'sit', flip: true }), vignette(0.16),
], 1240, 560));
add('steps_quran_sunrise', () => withFirefly([
  skyRect(SKY.dawn), lightRays(800, 300, 9, 900, 1.5, CREAM, 0.12), sun(800, 320, 90, CREAM, '#E8B36A'), hills('#7C9F6E', 780, 50), groundBand('#5F8A5A', 985),
  S.quranStand(800, 985, 1.2), dove(500, 500, 0.9), dove(1100, 460, 0.8, IVORY, true), vignette(0.14),
], 1300, 620));

// =============================================================== Angels ==
add('steps_angels_light', () => withFirefly([
  skyRect(SKY.night), stars(33, 120, 0, W, 0, 900), lightRays(800, 300, 13, 1000, 2.0, CREAM, 0.14), glow(800, 300, 420, CREAM, 0.5), star8(800, 300, 80, IVORY), star8(400, 500, 30, GOLD), star8(1200, 460, 34, GOLD),
  hills('#1A1F33', 960, 40), groundBand('#10132A', 985), vignette(0.2),
], 1000, 700));
add('steps_angels_scrolls', () => withFirefly([
  room(false), archWindow(800, 100, 320, 420, true), table(H * 0.72), scrollPen(500, 940, 1.0), scrollPen(1100, 940, 1.0, true), glow(800, 760, 260, CREAM, 0.3), vignette(0.18),
], 800, 640));
add('steps_angels_rain', () => withFirefly([
  skyRect(SKY.day), stormCloud(500, 300, 360, 100), stormCloud(1100, 240, 420, 110), rain(4, 90, 320, 900, SEA_FOAM, 0.4), lightRays(800, 120, 7, 700, 1.4, CREAM, 0.1),
  hills('#7C9F6E', 780, 50), groundBand('#5F8A5A', 985), tree(300, 985, 1.1), tree(1300, 960, 1.2), grass(2, 985, 40, '#2E5D48'), vignette(0.16),
], 800, 640));
add('steps_angels_sleep', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), floorBand(985, '#8A4A28'), childAsleep('amina', { x: 760, y: 985, s: 1.0 }), glow(760, 820, 360, CREAM, 0.3), star8(400, 500, 26, GOLD), star8(1100, 560, 22, GOLD), vignette(0.2),
], 400, 640));

// =========================================================== Our Prophet ==
add('steps_meet_lantern', () => withFirefly([
  skyRect(SKY.dawn), lightRays(800, 500, 9, 800, 1.6, CREAM, 0.1), glow(800, 640, 400, GOLD, 0.35), hangLine(800, 700, 1.5), lantern(800, 700, 1.5), dove(520, 520, 1.0), dove(1080, 480, 0.9, IVORY, true), dunes(SAND, SAND_DARK, 880), vignette(0.16),
], 1200, 400));
add('steps_meet_dua', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), floorBand(985, '#8A4A28'), prayerMat(800, 900, 520, 100), child('safa', { x: 800, y: 985, s: 1.0, pose: 'sit', arms: 'out' }), glow(800, 760, 260, CREAM, 0.3), vignette(0.16),
], 1240, 620));
add('steps_meet_books', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), floorBand(985, '#8A4A28'), `<rect x="380" y="760" width="840" height="24" rx="6" fill="${WOOD_DARK}"/>`, bookRow(800, 760, 1.0, ['#2E5D48', '#2E5D48', '#2E5D48', '#2E5D48']), glow(800, 640, 300, CREAM, 0.25), vignette(0.16),
], 420, 560));

// ================================================================ Jannah ==
add('steps_jannah_rivers', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 620, 60), riverBands(700), grass(3, 985, 40, '#2E5D48'), tree(200, 700, 1.0), tree(1400, 680, 1.1), vignette(0.14),
], 1200, 480));
add('steps_jannah_fruit', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 720, 60), groundBand('#4F7C4A', 985), fruitTree(400, 985, 1.3), fruitTree(1100, 985, 1.5), S.stream(920, SEA_LIGHT, SEA), sparkle(760, 520, 14), vignette(0.14),
], 800, 520));
add('steps_jannah_door', () => withFirefly([
  skyRect(SKY.emeraldLift), stars(31, 40, 0, W, 0, 500, CREAM, 2), hills('#3F5A48', 900, 40), groundBand('#2E4A3A', 985), goldenGate(800, 985, 1.0), sparkle(420, 400, 18), sparkle(1180, 360, 16), vignette(0.16),
], 1300, 560));
add('steps_jannah_kids', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 720, 60), groundBand('#4F7C4A', 985), fruitTree(1100, 985, 1.5),
  child('safa', { x: 520, y: 985, s: 1.0, pose: 'sit' }), child('amina', { x: 760, y: 985, s: 0.85, pose: 'sit', flip: true }), sparkle(640, 640, 16), sparkle(900, 600, 14), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 1300, 520));

// ================================================================ covers ==
const cover = (key, fn) => add(`${key}_cover`, fn, 'covers');
cover('who_is_allah', () => withFirefly([skyRect(SKY.day, 0, H, 0, 512), skyRect(SKY.night, 0, H, 512, W), sun(256, 260, 70, CREAM, '#E8C089', 12), stars(23, 60, 520, W, 0, 600), crescent(760, 240, 50), hills('#3F5A48', 780, 40), groundBand('#2E4A3A', 860), tree(512, 860, 1.0), vignette(0.16)], 640, 520));
cover('shahada', () => withFirefly([skyRect(SKY.emeraldLift), stars(31, 30, 0, W, 0, 400, CREAM, 2), groundBand('#2E4A3A', 860), S.mihrab(512, 860, 1.1, GREEN_DEEP, '#16382C', CREAM), hangLine(512, 520, 0.9), lantern(512, 520, 0.9), vignette(0.18)], 820, 500));
cover('what_we_believe', () => withFirefly([skyRect(SKY.night), stars(13, 60, 0, W, 0, 400), Array.from({ length: 6 }, (_, i) => hangLine(112 + i * 160, 520, 0.7) + lantern(112 + i * 160, 520, 0.7)).join(''), groundBand('#10132A', 860), vignette(0.22)], 512, 760));
cover('five_times_a_day', () => withFirefly([skyRect(SKY.day), sun(120, 500, 34, CREAM, '#E8B36A'), sun(330, 260, 40, CREAM, '#E8C089', 12), sun(512, 160, 46, CREAM, '#E8C089', 12), sun(700, 260, 40, CREAM, '#E8B36A'), crescent(900, 500, 34), hills('#7C9F6E', 700, 40), groundBand('#4A2F22', 800), prayerMat(512, 740, 500, 120), vignette(0.16)], 820, 620));
cover('wudu', () => withFirefly([skyRect([[0, '#DCE8E1'], [0.7, '#C9D8D2'], [1, '#B5C8C1']]), groundBand('#8A7F70', 860), tap(440, 640, 1.2), basin(540, 860, 1.0), S.puddle(800, 860, 70, 16), vignette(0.14)], 760, 420));
cover('the_call', () => withFirefly([skyRect(SKY.dawn), sun(220, 260, 60, CREAM, '#E8B36A', 12), city(800, '#8A5348', null, 11, 0.7), minaret(512, 860, 560, 66, '#3A2A1E'), soundArcs(560, 380, 3, 70), groundBand('#4A2F22', 860), vignette(0.16)], 840, 620));
cover('sharing', () => withFirefly([skyRect(SKY.dayClear), sun(220, 200, 60, CREAM, '#E8C089'), hills('#7C9F6E', 680, 40), groundBand('#4F7C4A', 860), fruitTree(512, 860, 1.2), coin(360, 840, 0.7), coin(660, 845, 0.7, 20), vignette(0.14)], 800, 500));
cover('ramadan', () => withFirefly([skyRect(SKY.violetDusk), stars(5, 30, 0, W, 0, 360), crescent(760, 220, 40), city(760, '#4A3560', GOLD, 9, 0.7), groundBand('#2C2347', 860), bowlOfDates(512, 860, 0.9), vignette(0.2)], 300, 520));
cover('hajj', () => withFirefly([skyRect(SKY.dayClear), `<rect x="0" y="600" width="${W}" height="424" fill="${IVORY}"/>`, `<ellipse cx="512" cy="760" rx="400" ry="120" fill="none" stroke="${STONE_LIGHT}" stroke-width="30"/>`, kaaba(512, 740, 0.6), minaret(90, 600, 300, 30, STONE_LIGHT), minaret(934, 600, 300, 30, STONE_LIGHT), vignette(0.14)], 800, 480));
cover('quran', () => withFirefly([room(true), archWindow(760, 110, 200, 300, false), floorBand(860, '#8A4A28'), S.quranStand(512, 860, 1.2), glow(512, 700, 240, CREAM, 0.35), vignette(0.16)], 260, 520));
cover('angels', () => withFirefly([skyRect(SKY.night), stars(33, 80, 0, W, 0, 800), lightRays(512, 260, 11, 800, 2.0, CREAM, 0.14), glow(512, 260, 300, CREAM, 0.5), star8(512, 260, 60, IVORY), star8(240, 460, 24, GOLD), star8(800, 420, 26, GOLD), groundBand('#10132A', 860), vignette(0.2)], 680, 640));
cover('our_prophet', () => withFirefly([skyRect(SKY.dawn), glow(512, 520, 300, GOLD, 0.35), hangLine(512, 560, 1.3), lantern(512, 560, 1.3), dove(300, 400, 0.9), dove(740, 380, 0.8, IVORY, true), dunes(SAND, SAND_DARK, 760), vignette(0.16)], 780, 300));
cover('jannah', () => withFirefly([skyRect(SKY.emeraldLift), stars(31, 30, 0, W, 0, 400, CREAM, 2), hills('#3F5A48', 780, 30), groundBand('#2E4A3A', 860), goldenGate(512, 860, 0.8), sparkle(240, 300, 16), sparkle(800, 260, 14), vignette(0.16)], 820, 500));

// ------------------------------------------------------------------ write --
mkdirSync(SVG_OUT, { recursive: true });
for (const [dir] of Object.values(OUT)) mkdirSync(dir, { recursive: true });
const report = [];
for (const [kind, name, fn] of SCENES) {
  if (ONLY.length && !ONLY.some((p) => name.startsWith(p))) continue;
  const [dir, w, h] = OUT[kind];
  W = w; H = h; K.setCanvas(w, h);
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
console.log(`${report.length} images`);
