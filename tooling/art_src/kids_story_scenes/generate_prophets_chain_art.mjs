// Path of Nur — art for the eleven prophets who never had a book (C2b).
//
// Idris, Hud, Salih, Lut, Shuayb, Ayyub, Harun, Ishaq & Yaqub, Zakariya &
// Yahya, Ilyas & Alyasa, Dhul-Kifl. Same hand as the K3 story scenes
// (scene_kit.mjs + story_helpers.mjs): silhouettes, no faces, no text baked
// in, prophets never drawn (a prophet scene shows what the prophet saw), a
// firefly on every scene, subjects between y=215 and y=985 of 1200.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_prophets_chain_art.mjs        # all
//   node tooling/art_src/kids_story_scenes/generate_prophets_chain_art.mjs hud_   # a subset
//
// Output:
//   assets/images/kids_books/scenes/<name>.webp                        (1600x1200)
//   assets/images/prophets/bedtime_stories/covers/<key>_cover.webp     (1024x1024)
//   assets/images/prophets/bedtime_stories/backdrops/<key>_backdrop.webp (1600x1200)
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as K from './scene_kit.mjs';
import * as S from './story_helpers.mjs';

const {
  IVORY, CREAM, GOLD, DEEPGOLD, INK, INK_SOFT, WOOD, WOOD_DARK, WOOD_LIGHT, SEA, SEA_DEEP, SEA_LIGHT, SEA_FOAM,
  GREEN, GREEN_DEEP, LEAF, LEAF_LIGHT, SAND, SAND_DARK, SAND_LIGHT, STONE, STONE_DARK, STONE_LIGHT,
  WALL, WALL_DEEP, SKY, skyRect, glow, vignette, stars, crescent, fullMoon, sun, lightRays, hills, dunes,
  mountains, cloud, stormCloud, rain, sparkle, star8, firefly, lantern, hangLine, city, palm, tree, grass, rock,
  camel, dove, bird, sheep, cow, jar, well, room, archWindow, table, scene, groundBand, f,
} = K;

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = {
  scenes: [join(ROOT, 'assets/images/kids_books/scenes'), 1600, 1200],
  covers: [join(ROOT, 'assets/images/prophets/bedtime_stories/covers'), 1024, 1024],
  backdrops: [join(ROOT, 'assets/images/prophets/bedtime_stories/backdrops'), 1600, 1200],
};
const ONLY = process.argv.slice(2).filter((a) => !a.startsWith('--'));

const SCENES = [];
const add = (name, fn, kind = 'scenes') => SCENES.push([kind, name, fn]);
// W/H follow the canvas: scenes and backdrops are 1600x1200, covers 1024x1024.
let W = 1600, H = 1200;

// ---------------------------------------------------------- new helpers --
const pillar = (x, baseY, h, w, color) =>
  `<rect x="${x - w / 2}" y="${baseY - h}" width="${w}" height="${h}" fill="${color}"/>` +
  `<rect x="${x - w * 0.8}" y="${baseY - h - w * 0.35}" width="${w * 1.6}" height="${w * 0.35}" rx="4" fill="${color}"/>` +
  `<rect x="${x - w * 0.7}" y="${baseY - w * 0.3}" width="${w * 1.4}" height="${w * 0.3}" rx="4" fill="${color}"/>`;

const tilted = (inner, cx, cy, deg) => `<g transform="rotate(${deg} ${cx} ${cy})">${inner}</g>`;

function crackedGround(seed, y0, color = '#8A5348', lineColor = '#5E3A2E', n = 18) {
  const rnd = K.mulberry32(seed);
  let out = `<rect x="0" y="${y0}" width="${W}" height="${H - y0}" fill="${color}"/><g stroke="${lineColor}" stroke-width="5" fill="none" stroke-linecap="round" opacity="0.7">`;
  for (let i = 0; i < n; i++) {
    const x = rnd() * W, y = y0 + 20 + rnd() * (H - y0 - 40);
    out += `<path d="M ${f(x)} ${f(y)} l ${f(30 + rnd() * 90)} ${f(-20 + rnd() * 40)} l ${f(20 + rnd() * 60)} ${f(10 + rnd() * 40)}"/>`;
  }
  return out + '</g>';
}

const bareTree = (x, gy, s, color = WOOD_DARK) =>
  `<g transform="translate(${x} ${gy}) scale(${s})" stroke="${color}" stroke-linecap="round" fill="none">` +
  `<path d="M 0 0 V -180" stroke-width="18"/><path d="M 0 -120 l -70 -70 M -70 -190 l -30 -50 M -70 -190 l 30 -50" stroke-width="12"/>` +
  `<path d="M 0 -150 l 80 -60 M 80 -210 l 40 -50 M 80 -210 l -20 -60" stroke-width="12"/><path d="M 0 -180 l 10 -60" stroke-width="10"/></g>`;

const tent = (cx, baseY, s, cloth = '#8A5A36', lit = null) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -220 0 L 0 -240 L 220 0 Z" fill="${cloth}"/><path d="M -200 0 L 0 -220 L 200 0 Z" fill="${cloth}" opacity="0.6"/>` +
  (lit ? `<path d="M -50 0 L 0 -110 L 50 0 Z" fill="${lit}"/>` : `<path d="M -40 0 L 0 -90 L 40 0 Z" fill="#3B2A1E"/>`) +
  `<path d="M 0 -240 V -290" stroke="${WOOD_DARK}" stroke-width="8"/></g>` + (lit ? glow(cx, baseY - 60 * s, 160 * s, CREAM, 0.35) : '');

const staff = (x, baseY, s, deg, color = WOOD_DARK) =>
  `<g transform="translate(${x} ${baseY}) rotate(${deg}) scale(${s})"><path d="M 0 0 V -300 q 0 -40 30 -50" stroke="${color}" stroke-width="18" fill="none" stroke-linecap="round"/></g>`;

const reedPen = (x, y, s, deg = -30) =>
  `<g transform="translate(${x} ${y}) rotate(${deg}) scale(${s})"><path d="M 0 0 L 220 0" stroke="${SAND_DARK}" stroke-width="16" stroke-linecap="round"/><path d="M 0 0 l 24 -8 l 0 16 Z" fill="${INK}"/><path d="M 60 -8 H 180" stroke="${SAND}" stroke-width="4"/></g>`;

const tablet = (cx, cy, w, h, deg = -6) =>
  `<g transform="rotate(${deg} ${cx} ${cy})"><rect x="${cx - w / 2}" y="${cy - h / 2}" width="${w}" height="${h}" rx="10" fill="${STONE_LIGHT}"/>` +
  [0.25, 0.4, 0.55, 0.7].map((t) => `<path d="M ${cx - w * 0.36} ${cy - h / 2 + h * t} H ${cx + w * (0.36 - (t === 0.7 ? 0.2 : 0))}" stroke="${STONE_DARK}" stroke-width="5" stroke-linecap="round" opacity="0.7"/>`).join('') + `</g>`;

const needleAndCloth = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -200 0 Q -220 -60 -160 -70 H 140 Q 200 -60 180 0 Z" fill="#4E8A6C"/><path d="M -170 -70 Q -150 -110 -100 -120 H 120 Q 170 -110 150 -70 Z" fill="#5FA083"/>` +
  `<path d="M -40 -160 L 120 -40" stroke="${STONE_LIGHT}" stroke-width="8" stroke-linecap="round"/><ellipse cx="-36" cy="-156" rx="8" ry="14" fill="none" stroke="${STONE_LIGHT}" stroke-width="4" transform="rotate(-40 -36 -156)"/>` +
  `<path d="M -40 -160 q -60 -20 -110 20 q -30 30 -10 60" stroke="#B8683C" stroke-width="5" fill="none"/>` +
  `<rect x="-230" y="-200" width="50" height="70" rx="8" fill="#B8683C"/><rect x="-230" y="-190" width="50" height="50" fill="#D9A05B"/></g>`;

const crookedHouse = (cx, baseY, s, deg, color = WALL_DEEP) => tilted(S.house(cx, baseY, s, color, null, WOOD_DARK), cx, baseY, deg);

const splash = (cx, cy, s, color = SEA_LIGHT) =>
  `<g transform="translate(${cx} ${cy}) scale(${s})" fill="${color}"><ellipse cx="0" cy="0" rx="140" ry="34" opacity="0.9"/><ellipse cx="0" cy="0" rx="90" ry="20" fill="${SEA}" opacity="0.6"/>` +
  `<path d="M -60 -10 q -10 -60 -40 -90 M 0 -20 q 0 -70 -10 -110 M 50 -12 q 20 -60 50 -80 M 20 -18 q 10 -50 40 -60" stroke="${color}" stroke-width="10" fill="none" stroke-linecap="round"/>` +
  `<circle cx="-110" cy="-90" r="8"/><circle cx="60" cy="-120" r="7"/><circle cx="110" cy="-70" r="6"/></g>`;

const stall = (cx, baseY, s, awning = '#8A4A28') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><rect x="-130" y="-120" width="260" height="120" fill="${WOOD}"/><rect x="-140" y="-140" width="280" height="24" fill="${WOOD_DARK}"/>` +
  `<path d="M -160 -150 H 160 L 140 -230 H -140 Z" fill="${awning}"/><path d="M -160 -150 H 160" stroke="${CREAM}" stroke-width="10" stroke-dasharray="26 26"/>` +
  `<rect x="-140" y="-300" width="10" height="160" fill="${WOOD_DARK}"/><rect x="130" y="-300" width="10" height="160" fill="${WOOD_DARK}"/></g>`;

const rockHouses = (baseY, color = '#8A5348', dark = '#5E3A2E') =>
  mountains(color, baseY, [[0, baseY], [200, baseY - 420], [520, baseY - 300], [900, baseY - 480], [1250, baseY - 340], [1600, baseY - 420]]) +
  [[240, 0.9], [480, 0.8], [760, 1.0], [1020, 0.85], [1320, 0.9]].map(([x, s]) =>
    `<path d="M ${x - 60 * s} ${baseY} V ${baseY - 120 * s} A ${60 * s} ${60 * s} 0 0 1 ${x + 60 * s} ${baseY - 120 * s} V ${baseY} Z" fill="${dark}"/>` +
    `<rect x="${x - 90 * s}" y="${baseY - 200 * s}" width="${180 * s}" height="${14 * s}" fill="${dark}" opacity="0.6"/>`).join('');

const fireflyAt = (x, y) => firefly(x, y, 1.2);
const withFirefly = (parts, x, y) => scene([...parts, fireflyAt(x, y)]);

// ================================================================= Idris ==
add('idris_stars', () => withFirefly([
  skyRect(SKY.night), stars(41, 140, 0, W, 0, 760), crescent(1240, 220, 64), star8(420, 300, 22), star8(760, 200, 16), star8(1000, 380, 14),
  mountains('#1A1F33', 900, [[0, 900], [400, 700], [800, 820], [1200, 660], [1600, 800]]),
  groundBand('#10132A', 960), `<rect x="480" y="880" width="640" height="90" rx="14" fill="#232A44"/>`,
  tablet(760, 925, 260, 70, -3), reedPen(940, 940, 0.9, -20), vignette(0.22),
], 320, 640));

add('idris_pen', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), hangLine(360, 420, 0.9), lantern(360, 420, 0.9),
  table(H * 0.72), tablet(700, 900, 320, 110, -4), reedPen(960, 920, 1.0, -28), jar(1180, 985, 0.6, '#3B2A1E'),
  S.scroll(420, 940, 0.9), vignette(0.16),
], 900, 640));

add('idris_needle', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), hangLine(1240, 420, 0.9), lantern(1240, 420, 0.9),
  table(H * 0.72), needleAndCloth(820, 985, 1.0), vignette(0.16),
], 1000, 640));

add('idris_high', () => withFirefly([
  skyRect(SKY.dawn), lightRays(800, 260, 11, 900, 1.6, CREAM, 0.12), sun(800, 300, 80, CREAM, '#E8B36A'),
  cloud(240, 700, 220, 60, 0.7), cloud(1340, 740, 240, 66, 0.7), cloud(800, 820, 300, 70, 0.75),
  mountains('#4A3560', 985, [[0, 985], [500, 700], [800, 360], [1100, 720], [1600, 985]], 0.9),
  glow(800, 380, 260, CREAM, 0.4), sparkle(640, 480, 16), sparkle(960, 440, 14), vignette(0.16),
], 1100, 560));

// =================================================================== Hud ==
const adPillars = (baseY, color = STONE_DARK) =>
  [[260, 520, 70], [520, 640, 84], [800, 720, 96], [1080, 620, 84], [1340, 500, 70]].map(([x, h, w]) => pillar(x, baseY, h, w, color)).join('');

add('hud_pillars', () => withFirefly([
  skyRect(SKY.amber), sun(1300, 240, 90, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 800),
  adPillars(985, '#5E4A3A'), `<rect x="180" y="985" width="1240" height="26" fill="#4A3A2E"/>`, groundBand('#8A5348', 1010), vignette(0.16),
], 660, 700));

add('hud_dry_land', () => withFirefly([
  skyRect([[0, '#C9A36A'], [0.6, '#E0BE88'], [1, '#EAD2A4']]), sun(1200, 220, 100, '#FFF4D6', '#F0D8A0', 0),
  crackedGround(5, 720, '#B0743B', '#7A4A2E'), bareTree(420, 985, 1.2), bareTree(1240, 985, 0.9), rock(900, 985, 90, 40, '#8A5348'), vignette(0.14),
], 760, 520));

add('hud_cloud', () => withFirefly([
  skyRect([[0, '#C9A36A'], [0.6, '#E0BE88'], [1, '#EAD2A4']]),
  stormCloud(400, 520, 420, 120), stormCloud(900, 460, 520, 140), stormCloud(1400, 540, 380, 110),
  crackedGround(5, 720, '#B0743B', '#7A4A2E'), adPillars(985, '#5E4A3A'), vignette(0.2),
], 1200, 300));

add('hud_wind', () => withFirefly([
  skyRect(SKY.storm), S.windStreaks(3, 90, 0, W, 100, 900, IVORY, 0.35), rain(8, 80, 0, 1000, SAND_LIGHT, 0.4, 260, 40),
  dunes('#8A5348', '#6E4038', 820),
  tilted(pillar(400, 985, 560, 76, '#5E4A3A'), 400, 985, -12), tilted(pillar(800, 985, 700, 92, '#5E4A3A'), 800, 985, 7), tilted(pillar(1200, 985, 600, 80, '#5E4A3A'), 1200, 985, -18),
  S.windStreaks(9, 60, 0, W, 300, 985, SAND_LIGHT, 0.5), vignette(0.26),
], 1440, 460));

add('hud_calm', () => withFirefly([
  skyRect(SKY.dawn), sun(300, 260, 80, CREAM, '#E8B36A', 12), cloud(1100, 220, 140, 40, 0.5),
  hills('#7C9F6E', 760, 50), S.stream(880, SEA_LIGHT, SEA), palm(1300, 900, 1.1, GREEN_DEEP), palm(300, 940, 0.9, GREEN_DEEP),
  grass(4, 985, 50, '#2E5D48'), dove(760, 520, 1.0), vignette(0.14),
], 1000, 640));

// ================================================================= Salih ==
add('salih_rock_houses', () => withFirefly([
  skyRect(SKY.day), sun(320, 220, 70, CREAM, '#E8C089'), cloud(1200, 240, 130, 38, 0.5), rockHouses(985), groundBand('#6E4038', 985), vignette(0.16),
], 1440, 640));

add('salih_camel', () => withFirefly([
  skyRect(SKY.amber), sun(1260, 240, 90, CREAM, '#E8B36A', 12),
  mountains('#8A5348', 985, [[0, 985], [300, 520], [700, 760], [1100, 440], [1600, 800]], 0.9),
  glow(760, 800, 320, CREAM, 0.4), camel(760, 985, 1.5, INK_SOFT), S.pebbles(3, 20, 0, W, 985, STONE_LIGHT), groundBand('#B0743B', 985), vignette(0.16),
], 1180, 640));

add('salih_well', () => withFirefly([
  skyRect(SKY.dayClear), sun(300, 220, 70), dunes(SAND, SAND_DARK, 760), groundBand('#8A5348', 985),
  well(500, 985, 1.0, true), camel(1040, 985, 1.2, INK_SOFT, true), jar(1360, 985, 0.9), jar(1460, 985, 0.7, '#5A3A28'), vignette(0.16),
], 800, 560));

add('salih_quake', () => withFirefly([
  skyRect(SKY.storm), stormCloud(500, 220, 400, 120), stormCloud(1200, 180, 460, 130), glow(800, 120, 300, IVORY, 0.25),
  rockHouses(985, '#5E3A2E', '#2E1A14'), crackedGround(7, 985, '#4A2F22', '#1E1610', 14), vignette(0.3),
], 200, 620));

add('salih_after', () => withFirefly([
  skyRect(SKY.dawn), lightRays(1240, 300, 7, 800, 1.2, CREAM, 0.1), sun(1240, 300, 80, CREAM, '#E8B36A'), rockHouses(985, '#6E4038', '#3E2619'), groundBand('#4A2F22', 985), dove(600, 480, 0.9), vignette(0.18),
], 420, 640));

// =================================================================== Lut ==
add('lut_city', () => withFirefly([
  skyRect(SKY.violetDusk), stars(11, 40, 0, W, 0, 400), crescent(260, 200, 56),
  hills('#4A3560', 820, 40, 0.8), groundBand('#2C2347', 985),
  crookedHouse(300, 985, 1.0, -9, '#6E4038'), crookedHouse(620, 985, 1.2, 8, '#8A5348'), crookedHouse(960, 985, 0.95, -12, '#6E4038'), crookedHouse(1280, 985, 1.1, 10, '#8A5348'), vignette(0.22),
], 1480, 620));

add('lut_guests', () => withFirefly([
  skyRect(SKY.night), stars(13, 80, 0, W, 0, 600), groundBand('#1A1F33', 985),
  `<rect x="300" y="420" width="1000" height="565" fill="#4A3560"/>`, S.doorway(800, 985, 1.3, '#4A3560', WOOD_DARK, true), glow(800, 760, 260, CREAM, 0.45),
  hangLine(1150, 560, 0.9), lantern(1150, 560, 0.9), vignette(0.24),
], 420, 560));

add('lut_night_road', () => withFirefly([
  skyRect(SKY.night), stars(17, 120, 0, W, 0, 640), fullMoon(1240, 220, 70), dunes('#232A44', '#1A1F33', 800),
  `<path d="M 700 1200 Q 760 1000 900 940 Q 1040 880 980 820" stroke="#3A4266" stroke-width="120" fill="none" stroke-linecap="round" opacity="0.7"/>`,
  palm(300, 900, 1.1, '#10132A'), rock(1420, 985, 90, 40, '#10132A'), vignette(0.22),
], 560, 640));

add('lut_morning', () => withFirefly([
  skyRect(SKY.dawn), sun(300, 260, 80, CREAM, '#E8B36A', 12), stormCloud(1200, 420, 420, 110), stormCloud(1450, 500, 300, 90),
  hills('#8A5348', 720, 50, 0.7), dunes(SAND, SAND_DARK, 820),
  `<path d="M 300 1200 Q 500 1000 700 985 Q 900 970 1100 900" stroke="#C48A5C" stroke-width="90" fill="none" stroke-linecap="round" opacity="0.5"/>`, vignette(0.16),
], 760, 560));

// ================================================================ Shuayb ==
add('shuayb_market', () => withFirefly([
  skyRect(SKY.day), sun(260, 200, 70), city(700, '#8A5348', null, 13, 0.9), groundBand('#B0743B', 985),
  stall(400, 985, 1.0, '#8A4A28'), stall(1200, 985, 1.0, '#2E5D48'), S.scales(800, 985, 1.0), S.basket(560, 940, 0.7), S.fruit(1130, 880, 1.2), S.fruit(1170, 870, 1.0, '#D9A05B'), vignette(0.16),
], 980, 520));

add('shuayb_scales', () => withFirefly([
  skyRect(SKY.amber), glow(800, 640, 420, CREAM, 0.3), groundBand('#6E4629', 985), `<rect x="0" y="985" width="${W}" height="24" fill="#54382A"/>`,
  tilted(S.scales(800, 985, 2.0), 800, 800, -9), S.pebbles(5, 8, 560, 700, 985, GOLD), vignette(0.16),
], 1240, 480));

add('shuayb_trees', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70), hills('#5F8A5A', 800, 50),
  tree(220, 985, 1.4, WOOD_DARK, LEAF, LEAF_LIGHT), tree(520, 940, 1.1), tree(820, 985, 1.5, WOOD_DARK, GREEN, LEAF), tree(1120, 950, 1.2), tree(1420, 985, 1.3, WOOD_DARK, LEAF, LEAF_LIGHT),
  grass(2, 985, 60, '#2E5D48'), vignette(0.16),
], 680, 560));

add('shuayb_shade_day', () => withFirefly([
  skyRect(SKY.storm), stormCloud(800, 300, 700, 180), stormCloud(300, 420, 400, 110), stormCloud(1350, 400, 380, 100), glow(800, 640, 500, IVORY, 0.14),
  city(900, '#3E2619', null, 13, 0.9), groundBand('#2E1A14', 985), vignette(0.3),
], 1300, 700));

add('shuayb_fair', () => withFirefly([
  skyRect(SKY.emeraldLift), stars(31, 30, 0, W, 0, 400, CREAM, 2), glow(800, 700, 400, CREAM, 0.35), groundBand('#2E4A3A', 985),
  S.scales(800, 985, 2.0), sparkle(560, 560, 18), sparkle(1040, 520, 16), sparkle(800, 460, 14), vignette(0.16),
], 1220, 620));

// ================================================================= Ayyub ==
const gardenGreen = (sheepCount) => [
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), cloud(1100, 220, 130, 38, 0.5), hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50),
  S.stream(880, SEA_LIGHT, SEA), S.house(1240, 860, 0.9, WALL, CREAM), tree(300, 900, 1.2), tree(900, 860, 0.9),
  ...Array.from({ length: sheepCount }, (_, i) => sheep(200 + i * 170, 985 - (i % 2) * 24, 0.7)), grass(3, 985, 50, '#2E5D48'),
];
add('ayyub_garden_green', () => withFirefly([...gardenGreen(5), vignette(0.14)], 1400, 560));

add('ayyub_garden_dry', () => withFirefly([
  skyRect([[0, '#9A8E80'], [0.6, '#C2B49E'], [1, '#D9CBB0']]), sun(280, 220, 70, '#F0E4C0', '#D9CBB0', 0),
  hills('#8A7F70', 700, 60), crackedGround(6, 820, '#8A6A4E', '#5E4A3A', 20), S.house(1240, 860, 0.9, '#B5AA98', null, '#8A7F70'), bareTree(300, 900, 1.2), bareTree(900, 860, 0.9), vignette(0.2),
], 700, 620));

add('ayyub_spring', () => withFirefly([
  skyRect(SKY.dawn), sun(1240, 260, 80, CREAM, '#E8B36A', 12), crackedGround(6, 800, '#B0743B', '#7A4A2E', 14),
  splash(800, 900, 1.3), glow(800, 860, 300, SEA_FOAM, 0.35), grass(9, 985, 20, '#2E5D48'), vignette(0.16),
], 1100, 620));

add('ayyub_garden_again', () => withFirefly([...gardenGreen(7), lightRays(280, 220, 9, 900, 1.6, CREAM, 0.1), vignette(0.14)], 1400, 560));

// ================================================================= Harun ==
add('harun_two_staffs', () => withFirefly([
  skyRect(SKY.violetDusk), stars(5, 40, 0, W, 0, 400), crescent(1300, 200, 56), dunes('#8A5348', '#6E4038', 820), groundBand('#4A3560', 985),
  tent(800, 985, 1.1, '#6E4629', CREAM), staff(560, 985, 1.0, 12), staff(1040, 985, 1.0, -10), vignette(0.2),
], 1160, 560));

add('harun_tents', () => withFirefly([
  skyRect(SKY.night), stars(21, 110, 0, W, 0, 640), fullMoon(300, 220, 64),
  mountains('#232A44', 900, [[0, 900], [500, 560], [800, 380], [1100, 600], [1600, 860]]), groundBand('#10132A', 985),
  tent(360, 985, 0.7, '#4A3560', CREAM), tent(760, 985, 0.9, '#4A3560', CREAM), tent(1160, 985, 0.75, '#4A3560'), tent(1440, 985, 0.6, '#4A3560', CREAM), vignette(0.22),
], 980, 540));

add('harun_calf', () => withFirefly([
  skyRect(SKY.amber), glow(800, 700, 360, GOLD, 0.35), dunes(SAND, SAND_DARK, 800), groundBand('#8A5348', 985),
  `<rect x="620" y="900" width="360" height="85" rx="10" fill="${STONE}"/>`, cow(800, 900, 1.3, true, GOLD),
  S.pebbles(4, 16, 500, 1100, 985, GOLD), sparkle(560, 700, 12, GOLD), sparkle(1060, 680, 12, GOLD), vignette(0.16),
], 1300, 560));

// ======================================================== Ishaq & Yaqub ==
add('ishaq_tent_lamp', () => withFirefly([
  skyRect(SKY.night), stars(23, 120, 0, W, 0, 640), crescent(280, 220, 60), dunes('#232A44', '#1A1F33', 800), groundBand('#10132A', 985),
  tent(800, 985, 1.2, '#4A3560', CREAM), hangLine(1200, 560, 0.8), lantern(1200, 560, 0.8), vignette(0.22),
], 480, 600));

add('ishaq_flocks', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70), hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50), groundBand('#4F7C4A', 985),
  well(360, 985, 0.9, true), sheep(700, 985, 0.8), sheep(860, 950, 0.75), sheep(1020, 985, 0.8, IVORY, INK_SOFT, true), sheep(1200, 960, 0.7), sheep(1360, 985, 0.8, '#E8DCC0'),
  tree(1480, 900, 1.0), grass(3, 985, 40, '#2E5D48'), vignette(0.14),
], 1000, 560));

add('yaqub_twelve', () => withFirefly([
  skyRect(SKY.violetDusk), stars(7, 60, 0, W, 0, 500), crescent(1320, 200, 52), dunes('#8A5348', '#6E4038', 820), groundBand('#4A3560', 985),
  tent(800, 985, 1.3, '#6E4629', CREAM),
  ...[[160, 0.42], [300, 0.46], [440, 0.4], [580, 0.44], [1020, 0.44], [1160, 0.4], [1300, 0.46], [1440, 0.42]].map(([x, s]) => tent(x, 985, s, '#4A3560')),
  ...[[240, 0.36], [1340, 0.36], [400, 0.3], [1200, 0.3]].map(([x, s]) => tent(x, 900, s, '#3E2A45')), vignette(0.2),
], 800, 560));

add('yaqub_waiting', () => withFirefly([
  skyRect(SKY.violetDusk), stars(9, 50, 0, W, 0, 480), dunes('#8A5348', '#6E4038', 800), groundBand('#4A3560', 985),
  `<path d="M 800 985 Q 1000 900 1500 700" stroke="#C48A5C" stroke-width="70" fill="none" stroke-linecap="round" opacity="0.45"/>`,
  tent(520, 985, 1.2, '#6E4629', CREAM), hangLine(760, 620, 0.9), lantern(760, 620, 0.9), vignette(0.22),
], 1220, 520));

// ====================================================== Zakariya & Yahya ==
add('zakariya_whisper', () => withFirefly([
  skyRect(SKY.night), stars(29, 90, 0, W, 0, 520), groundBand('#3E2619', 985), S.mihrab(800, 985, 1.2, '#6E4629', '#3E2619', CREAM),
  hangLine(800, 600, 0.9), lantern(800, 600, 0.9), vignette(0.24),
], 1180, 620));

add('zakariya_three_nights', () => withFirefly([
  skyRect(SKY.night), stars(33, 100, 0, W, 0, 500), crescent(400, 260, 56), crescent(800, 200, 56), crescent(1200, 260, 56),
  hills('#232A44', 820, 40), groundBand('#10132A', 985), S.house(800, 985, 1.2, '#4A3560', CREAM, '#2C2347'), vignette(0.22),
], 1000, 620));

add('yahya_garden', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills('#7C9F6E', 720, 60), hills('#5F8A5A', 820, 50), groundBand('#4F7C4A', 985),
  tree(300, 920, 1.2), tree(1300, 900, 1.3), S.quranStand(800, 985, 1.1), dove(600, 560, 1.0), dove(1000, 500, 0.9, IVORY, true), bird(1200, 420, 3), bird(1260, 390, 2.4),
  grass(2, 985, 50, '#2E5D48'), sparkle(700, 760, 12), sparkle(920, 740, 12), vignette(0.14),
], 1420, 620));

// ====================================================== Ilyas & Alyasa ==
add('ilyas_baal', () => withFirefly([
  skyRect(SKY.violetDusk), stars(3, 40, 0, W, 0, 400), hills('#4A3560', 800, 50), groundBand('#2C2347', 985),
  `<rect x="620" y="900" width="360" height="85" rx="10" fill="${STONE_DARK}"/>`, S.idolStatue(800, 900, 1.1, STONE_DARK), S.fruit(700, 960, 1.2), S.fruit(900, 960, 1.0, '#D9A05B'), jar(1100, 985, 0.7), vignette(0.22),
], 400, 640));

add('ilyas_mountain_sky', () => withFirefly([
  skyRect(SKY.day), lightRays(1240, 260, 9, 900, 1.5, CREAM, 0.12), sun(1240, 260, 80, CREAM, '#E8C089'), stormCloud(360, 300, 320, 100), rain(4, 60, 320, 700, SEA_FOAM, 0.4),
  mountains('#3F5A48', 985, [[0, 985], [300, 560], [600, 760], [900, 420], [1250, 700], [1600, 620]]), bird(700, 500, 3), bird(760, 470, 2.4), bird(820, 520, 2), vignette(0.16),
], 1000, 620));

add('alyasa_river', () => withFirefly([
  skyRect(SKY.dawn), sun(1240, 260, 80, CREAM, '#E8B36A'), hills('#7C9F6E', 700, 60), S.river(840, SEA_LIGHT, SEA), tree(260, 860, 1.1), tree(1380, 840, 1.2), palm(700, 880, 0.9, GREEN_DEEP), S.reeds(4, 900, 1300, 985, 10), vignette(0.14),
], 900, 560));

// ============================================================= Dhul-Kifl ==
add('dhulkifl_scroll', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), hangLine(360, 420, 0.9), lantern(360, 420, 0.9), table(H * 0.72),
  S.scroll(760, 940, 1.4), jar(1100, 985, 0.6, '#3B2A1E'), reedPen(1000, 950, 0.8, -35), vignette(0.16),
], 980, 640));

add('dhulkifl_dawn', () => withFirefly([
  skyRect(SKY.dawn), sun(1200, 300, 80, CREAM, '#E8B36A', 12), city(900, '#8A5348', null, 17, 0.9), city(985, '#6E4038', GOLD, 4, 1.1), groundBand('#4A2F22', 985), vignette(0.16),
], 500, 640));

// ================================================================ covers ==
const cover = (key, fn) => add(`${key}_cover`, fn, 'covers');
const backdrop = (key, fn) => add(`${key}_backdrop`, fn, 'backdrops');

cover('idris', () => withFirefly([skyRect(SKY.night), stars(41, 90, 0, W, 0, 700), crescent(220, 180, 50), star8(512, 260, 26), groundBand('#10132A', 800), `<rect x="212" y="720" width="600" height="90" rx="14" fill="#232A44"/>`, tablet(470, 765, 240, 64, -3), reedPen(640, 780, 0.8, -20), vignette(0.22)], 760, 460));
backdrop('idris', () => scene([skyRect(SKY.night), stars(41, 140, 0, W, 0, 760), crescent(1240, 220, 64), mountains('#1A1F33', 900, [[0, 900], [400, 700], [800, 820], [1200, 660], [1600, 800]]), groundBand('#10132A', 985), vignette(0.22)]));

cover('hud', () => withFirefly([skyRect(SKY.amber), stormCloud(700, 230, 420, 120), [[200, 380, 56], [400, 480, 66], [620, 420, 60], [840, 500, 66]].map(([x, h, w]) => pillar(x, 860, h, w, '#5E4A3A')).join(''), dunes(SAND, SAND_DARK, 700), groundBand('#8A5348', 860), vignette(0.18)], 900, 640));
backdrop('hud', () => scene([skyRect(SKY.amber), sun(1300, 240, 90, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 800), groundBand('#8A5348', 985), vignette(0.16)]));

cover('salih', () => withFirefly([skyRect(SKY.amber), mountains('#8A5348', 860, [[0, 860], [200, 420], [500, 640], [800, 360], [1024, 620]], 0.9), glow(512, 700, 260, CREAM, 0.4), camel(512, 860, 1.2, INK_SOFT), groundBand('#B0743B', 860), vignette(0.16)], 820, 520));
backdrop('salih', () => scene([skyRect(SKY.day), sun(320, 220, 70, CREAM, '#E8C089'), rockHouses(985), groundBand('#6E4038', 985), vignette(0.16)]));

cover('lut', () => withFirefly([skyRect(SKY.night), stars(17, 90, 0, W, 0, 600), fullMoon(800, 200, 60), dunes('#232A44', '#1A1F33', 660), `<path d="M 420 1024 Q 480 860 600 800 Q 720 740 680 680" stroke="#3A4266" stroke-width="100" fill="none" stroke-linecap="round" opacity="0.7"/>`, palm(200, 760, 0.9, '#10132A'), vignette(0.22)], 360, 520));
backdrop('lut', () => scene([skyRect(SKY.violetDusk), stars(11, 40, 0, W, 0, 400), crescent(260, 200, 56), hills('#4A3560', 820, 40, 0.8), groundBand('#2C2347', 985), vignette(0.22)]));

cover('shuayb', () => withFirefly([skyRect(SKY.emeraldLift), glow(512, 600, 320, CREAM, 0.35), groundBand('#2E4A3A', 860), S.scales(512, 860, 1.6), sparkle(300, 380, 16), sparkle(740, 340, 14), vignette(0.16)], 820, 500));
backdrop('shuayb', () => scene([skyRect(SKY.day), sun(260, 200, 70), city(700, '#8A5348', null, 13, 0.9), groundBand('#B0743B', 985), vignette(0.16)]));

cover('ayyub', () => withFirefly([skyRect(SKY.dawn), sun(800, 220, 70, CREAM, '#E8B36A', 12), crackedGround(6, 640, '#B0743B', '#7A4A2E', 10), splash(512, 760, 1.1), glow(512, 720, 260, SEA_FOAM, 0.35), grass(9, 860, 14, '#2E5D48'), vignette(0.16)], 260, 520));
backdrop('ayyub', () => scene([...gardenGreen(5), vignette(0.14)]));

cover('harun', () => withFirefly([skyRect(SKY.violetDusk), stars(5, 30, 0, W, 0, 360), crescent(820, 180, 50), dunes('#8A5348', '#6E4038', 680), groundBand('#4A3560', 860), tent(512, 860, 0.9, '#6E4629', CREAM), staff(330, 860, 0.9, 12), staff(700, 860, 0.9, -10), vignette(0.2)], 780, 460));
backdrop('harun', () => scene([skyRect(SKY.night), stars(21, 110, 0, W, 0, 640), fullMoon(300, 220, 64), mountains('#232A44', 900, [[0, 900], [500, 560], [800, 380], [1100, 600], [1600, 860]]), groundBand('#10132A', 985), vignette(0.22)]));

cover('ishaq_yaqub', () => withFirefly([skyRect(SKY.night), stars(23, 90, 0, W, 0, 600), crescent(220, 200, 50), dunes('#232A44', '#1A1F33', 680), groundBand('#10132A', 860), tent(512, 860, 1.0, '#4A3560', CREAM), vignette(0.22)], 800, 520));
backdrop('ishaq_yaqub', () => scene([skyRect(SKY.dayClear), sun(1240, 220, 70), hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50), groundBand('#4F7C4A', 985), vignette(0.14)]));

cover('zakariya_yahya', () => withFirefly([skyRect(SKY.night), stars(33, 90, 0, W, 0, 460), crescent(260, 240, 44), crescent(512, 180, 44), crescent(764, 240, 44), hills('#232A44', 700, 30), groundBand('#10132A', 860), S.house(512, 860, 1.0, '#4A3560', CREAM, '#2C2347'), vignette(0.22)], 820, 560));
backdrop('zakariya_yahya', () => scene([skyRect(SKY.night), stars(29, 90, 0, W, 0, 520), groundBand('#3E2619', 985), S.mihrab(800, 985, 1.2, '#6E4629', '#3E2619', CREAM), vignette(0.24)]));

cover('ilyas_alyasa', () => withFirefly([skyRect(SKY.day), lightRays(800, 220, 7, 700, 1.4, CREAM, 0.12), sun(800, 220, 60, CREAM, '#E8C089'), stormCloud(240, 260, 220, 80), rain(4, 30, 280, 560, SEA_FOAM, 0.4), mountains('#3F5A48', 860, [[0, 860], [200, 500], [420, 680], [640, 380], [860, 620], [1024, 520]]), bird(500, 420, 2.6), vignette(0.16)], 700, 520));
backdrop('ilyas_alyasa', () => scene([skyRect(SKY.dawn), sun(1240, 260, 80, CREAM, '#E8B36A'), hills('#7C9F6E', 700, 60), S.river(840, SEA_LIGHT, SEA), tree(260, 860, 1.1), tree(1380, 840, 1.2), vignette(0.14)]));

cover('dhul_kifl', () => withFirefly([room(false), archWindow(760, 100, 200, 300, true), hangLine(240, 340, 0.8), lantern(240, 340, 0.8), table(H * 0.72), S.scroll(480, 800, 1.2), reedPen(680, 800, 0.7, -35), vignette(0.16)], 640, 560));
backdrop('dhul_kifl', () => scene([skyRect(SKY.dawn), sun(1200, 300, 80, CREAM, '#E8B36A', 12), city(900, '#8A5348', null, 17, 0.9), groundBand('#4A2F22', 985), vignette(0.16)]));

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
