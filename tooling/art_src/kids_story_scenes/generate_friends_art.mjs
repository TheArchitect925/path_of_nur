// Path of Nur — art for the Friends of the Prophet ﷺ shelf (C4b).
//
// Khadijah, Abu Bakr, Bilal, Ali, Fatimah, Anas, the Thirsty Dog and the
// Three Men in the Cave. Same hand as the K3 scene kit: silhouettes, animals
// with a little expression, no people at all (companions are shown by what
// they saw and held: a cloak on a bed, a millstone, a shoe of water), no
// faces, no text baked in, a firefly on every scene, subjects between y=215
// and y=985 of 1200. Khadijah reuses the ﷺ scenes and draws nothing new.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_friends_art.mjs           # all
//   node tooling/art_src/kids_story_scenes/generate_friends_art.mjs dog_      # a subset
//
// Output:
//   assets/images/kids_books/scenes/<name>.webp              (1600x1200)
//   assets/images/kids_stories/covers/companion_<name>_cover.webp (1024x1024)
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as K from './scene_kit.mjs';
import * as S from './story_helpers.mjs';

const {
  IVORY, CREAM, GOLD, DEEPGOLD, INK, INK_SOFT, WOOD, WOOD_DARK, WOOD_LIGHT, SEA, SEA_LIGHT, SEA_FOAM,
  GREEN, GREEN_DEEP, LEAF, LEAF_LIGHT, SAND, SAND_DARK, SAND_LIGHT, STONE, STONE_DARK, STONE_LIGHT, WALL, WALL_DEEP,
  SKY, skyRect, glow, vignette, stars, crescent, sun, lightRays, hills, dunes, mountains, stormCloud, rain, sparkle,
  firefly, lantern, hangLine, city, palm, tree, grass, rock, dove, cow, well, scene, groundBand, jar, sack, wheat,
  room, archWindow, table,
} = K;

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = {
  scenes: [join(ROOT, 'assets/images/kids_books/scenes'), 1600, 1200],
  covers: [join(ROOT, 'assets/images/kids_stories/covers'), 1024, 1024],
};
const ONLY = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const SCENES = [];
const add = (name, fn, kind = 'scenes') => SCENES.push([kind, name, fn]);
let W = 1600, H = 1200;
const withFirefly = (parts, x, y) => scene([...parts, firefly(x, y, 1.2)]);

// ------------------------------------------------------------- helpers --
// A dog standing, tongue out when `panting`; head to +x unless flipped.
function dogStanding(x, gy, s, { color = '#8A5A36', flip = false, panting = true, headDown = false } = {}) {
  const hx = 130, hy = headDown ? -58 : -130;
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<path d="M -70 -60 V 0 M -30 -60 V 0 M 30 -60 V 0 M 70 -60 V 0" stroke="${color}" stroke-width="18" stroke-linecap="round"/>` +
    `<ellipse cx="0" cy="-90" rx="110" ry="44" fill="${color}"/>` +
    `<path d="M -110 -100 q -40 -30 -30 -80" stroke="${color}" stroke-width="12" fill="none" stroke-linecap="round"/>` +
    `<path d="M 90 -110 L ${hx - 10} ${hy + 10}" stroke="${color}" stroke-width="40" stroke-linecap="round"/>` +
    `<circle cx="${hx}" cy="${hy}" r="36" fill="${color}"/><ellipse cx="${hx + 36}" cy="${hy + 10}" rx="26" ry="16" fill="${color}"/>` +
    `<path d="M ${hx + 8} ${hy - 30} l 8 -34 l 18 30 Z" fill="${color}"/><circle cx="${hx + 10}" cy="${hy - 8}" r="4" fill="${IVORY}"/>` +
    (panting && !headDown ? `<path d="M ${hx + 44} ${hy + 22} q 6 26 -6 34" stroke="#D9736A" stroke-width="10" fill="none" stroke-linecap="round"/>` : '') +
    `</g>`;
}
const waterShoe = (x, gy, s, filled = true) => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<path d="M -90 0 H 70 Q 120 0 120 -40 V -70 Q 120 -100 90 -100 H -20 Q -90 -100 -90 -40 Z" fill="#6E4629"/>` +
  `<path d="M -90 -40 Q -90 -100 -20 -100 H 90" stroke="#4A2F22" stroke-width="8" fill="none"/>` +
  (filled ? `<ellipse cx="35" cy="-96" rx="52" ry="12" fill="${SEA_LIGHT}"/><circle cx="60" cy="-120" r="5" fill="${SEA_FOAM}"/>` : '') + `</g>`;
const bed = (x, gy, s, blanket = GREEN, lump = true) => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<rect x="-270" y="-120" width="540" height="120" rx="16" fill="${WOOD}"/><rect x="-270" y="-230" width="30" height="120" rx="8" fill="${WOOD_DARK}"/><rect x="240" y="-190" width="30" height="80" rx="8" fill="${WOOD_DARK}"/>` +
  `<rect x="-255" y="-160" width="510" height="56" rx="18" fill="${CREAM}"/>` +
  (lump ? `<path d="M -230 -150 Q -100 -250 60 -170 Q 160 -120 250 -150 V -104 H -230 Z" fill="${blanket}"/>` : `<path d="M -230 -150 Q 0 -170 250 -150 V -104 H -230 Z" fill="${blanket}"/>`) +
  `<ellipse cx="-190" cy="-168" rx="60" ry="22" fill="${IVORY}"/></g>`;
const millstone = (x, gy, s) => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<ellipse cx="0" cy="-22" rx="160" ry="44" fill="${STONE_DARK}"/><rect x="-160" y="-60" width="320" height="38" fill="${STONE_DARK}"/><ellipse cx="0" cy="-60" rx="160" ry="44" fill="${STONE}"/>` +
  `<ellipse cx="0" cy="-64" rx="34" ry="12" fill="${STONE_DARK}"/><path d="M 100 -74 l 34 -90" stroke="${WOOD_DARK}" stroke-width="18" stroke-linecap="round"/>` +
  [[-120, -8], [-90, 4], [150, -2], [190, 8], [60, 10]].map(([dx, dy]) => `<circle cx="${dx}" cy="${dy}" r="6" fill="${SAND_LIGHT}"/>`).join('') + `</g>`;
const waterSkin = (x, gy, s) => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<path d="M -70 0 Q -120 -90 -60 -170 Q -20 -220 60 -210 Q 110 -200 100 -120 Q 90 -50 60 0 Z" fill="#8A5A36"/><path d="M 40 -212 q 10 -30 40 -30" stroke="${WOOD_DARK}" stroke-width="14" fill="none" stroke-linecap="round"/>` +
  `<path d="M -50 -60 q 40 -20 90 0" stroke="#6E4629" stroke-width="8" fill="none" opacity="0.6"/></g>`;
const mat = (x, gy, s, color = '#8A4A28', blanket = '#4A5D8A') => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<rect x="-200" y="-40" width="400" height="40" rx="14" fill="${color}"/><path d="M -170 -40 Q -60 -120 80 -60 Q 150 -30 180 -40 Z" fill="${blanket}"/><ellipse cx="-150" cy="-52" rx="46" ry="16" fill="${IVORY}"/></g>`;
const boulder = (x, gy, s, color = STONE_DARK, light = STONE) => `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<path d="M -210 0 Q -250 -150 -100 -230 Q 60 -290 190 -180 Q 260 -90 210 0 Z" fill="${color}"/><path d="M -130 -170 q 70 -50 160 -20" stroke="${light}" stroke-width="12" fill="none" opacity="0.5" stroke-linecap="round"/></g>`;
const ball = (x, y, r, a = '#B84A4A', b = CREAM) => `<g transform="translate(${x} ${y})"><circle r="${r}" fill="${a}"/><path d="M ${-r} 0 A ${r} ${r} 0 0 1 ${r} 0 Z" fill="${b}" opacity="0.8"/><circle r="${r}" fill="none" stroke="${INK_SOFT}" stroke-width="4"/></g>`;
const hoop = (x, y, r) => `<g transform="translate(${x} ${y})"><circle r="${r}" fill="none" stroke="${WOOD_DARK}" stroke-width="12"/><path d="M ${r * 0.7} ${-r * 0.7} l 120 -110" stroke="${WOOD}" stroke-width="12" stroke-linecap="round"/></g>`;
// Cave walls seen from inside: everything dark except an arched mouth.
const caveWalls = (cx, baseY, rx, top, color = '#0E0F16') => `<path d="M 0 0 H ${W} V ${H} H 0 Z M ${cx - rx} ${baseY} Q ${cx} ${top} ${cx + rx} ${baseY} Z" fill="${color}" fill-rule="evenodd"/>`;
const chest = (x, gy, s) => `<g transform="translate(${x} ${gy}) scale(${s})"><rect x="-140" y="-120" width="280" height="120" rx="12" fill="${WOOD}"/><rect x="-140" y="-120" width="280" height="18" fill="${WOOD_DARK}"/><rect x="-140" y="-150" width="280" height="40" rx="12" fill="${WOOD_DARK}"/><rect x="-16" y="-110" width="32" height="30" rx="6" fill="${DEEPGOLD}"/></g>`;
const tag = (x, y, s = 1) => `<g transform="translate(${x} ${y}) scale(${s})"><path d="M 0 0 l 40 -30 h 90 v 60 h -90 Z" fill="${CREAM}" stroke="${WOOD_DARK}" stroke-width="4"/><path d="M 0 0 q -30 -40 -60 -20" stroke="${WOOD_DARK}" stroke-width="4" fill="none"/></g>`;
const sky3 = (color, base, seed) => mountains(color, base, [[0, base], [360, base - 520], [760, base - 300], [1160, base - 600], [1600, base - 260]], seed);

// ================================================================ Abu Bakr ==
add('friends_cave_inside', () => withFirefly([
  skyRect(SKY.day), sun(1000, 520, 50, CREAM, '#E8C089'), hills('#8A5348', 880, 40), caveWalls(800, 985, 330, 380), glow(800, 820, 520, CREAM, 0.14),
  S.spiderWeb(690, 560, 150, IVORY, 0.8), S.nest(1010, 880, 1.0), dove(1010, 850, 0.8), S.pebbles(5, 14, 200, 1400, 985, '#2B3140'), vignette(0.22),
], 400, 640));

// =================================================================== Bilal ==
add('bilal_desert_rock', () => withFirefly([
  skyRect(SKY.amber), sun(800, 250, 120, CREAM, '#E8B36A', 16), dunes(SAND, SAND_DARK, 760), groundBand(SAND_DARK, 985),
  S.windStreaks(4, 30, 0, W, 780, 985, SAND_LIGHT, 0.4), boulder(800, 985, 0.9, STONE_DARK, STONE), glow(800, 640, 220, CREAM, 0.28), sparkle(800, 620, 18), vignette(0.16),
], 1240, 560));

// ===================================================================== Ali ==
add('ali_green_cloak_bed', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), hangLine(420, 470, 0.9), lantern(420, 470, 0.9), groundBand('#4A2F22', 985), bed(720, 985, 1.0, GREEN, true), glow(720, 800, 300, GOLD, 0.15), vignette(0.22),
], 1300, 560));
add('ali_trusts_shelf', () => withFirefly([
  room(true), archWindow(400, 130, 240, 340, false), table(H * 0.72), chest(620, 864, 0.7), tag(700, 790, 0.9), S.bag(860, 864, 1.0), jar(1020, 864, 0.9), tag(1090, 800, 0.8), sack(1220, 864, 0.9), groundBand('#4A2F22', 985), vignette(0.18),
], 1300, 500));

// ================================================================= Fatimah ==
add('fatimah_millstone', () => withFirefly([
  skyRect(SKY.day), sun(300, 220, 70), S.house(1250, 985, 1.1, WALL, null, WALL_DEEP), palm(260, 985, 1.0, GREEN_DEEP), groundBand(SAND_DARK, 985),
  millstone(760, 985, 1.0), waterSkin(1100, 985, 0.9), wheat(520, 985, 1.0), wheat(560, 985, 0.9), vignette(0.14),
], 1000, 520));
add('fatimah_bedtime_words', () => withFirefly([
  skyRect(SKY.roomEvening), archWindow(1220, 130, 240, 340, true), groundBand('#4A2F22', 985), bed(660, 985, 1.0, '#8A4A6A', false),
  ...[[420, 470], [700, 400], [980, 450]].flatMap(([x, y]) => [sparkle(x, y, 18), sparkle(x + 60, y - 50, 12), sparkle(x - 50, y + 50, 10), glow(x, y, 120, GOLD, 0.18)]), vignette(0.22),
], 1320, 560));

// ==================================================================== Anas ==
add('anas_door_basket', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), city(820, WALL_DEEP, null, 7, 0.8), S.house(800, 985, 1.5, WALL, null, WALL_DEEP), S.doorway(800, 985, 1.3, WALL, WOOD_DARK, true),
  palm(260, 985, 1.1, GREEN_DEEP), palm(1380, 985, 0.9, GREEN_DEEP), groundBand(SAND_DARK, 985), S.basket(560, 940, 0.9), S.plateOfDates(560, 905, 0.9, 3), vignette(0.14),
], 1100, 520));
add('anas_street_play', () => withFirefly([
  skyRect(SKY.day), sun(1240, 220, 70), city(800, WALL, null, 11, 0.9), palm(200, 985, 1.0, GREEN_DEEP), groundBand('#B0743B', 985),
  dove(600, 400, 0.9), ball(640, 940, 44), ball(760, 960, 26, '#4A5D8A'), hoop(1080, 880, 90), S.pebbles(7, 12, 300, 1300, 985, STONE_LIGHT), vignette(0.14),
], 420, 560));

// ============================================================= Thirsty Dog ==
add('dog_desert_well', () => withFirefly([
  skyRect(SKY.amber), sun(1240, 240, 100, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 780), groundBand(SAND_DARK, 985), S.windStreaks(3, 24, 0, W, 800, 985, SAND_LIGHT, 0.35),
  well(700, 985, 1.2, true), S.puddle(1120, 976, 90, 14, '#7A5A3A'), dogStanding(1180, 985, 0.9, { flip: true }), vignette(0.16),
], 380, 560));
add('dog_shoe_water', () => withFirefly([
  skyRect(SKY.amber), sun(1240, 240, 100, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 780), groundBand(SAND_DARK, 985),
  well(640, 985, 1.2, true), waterShoe(1000, 985, 1.2), sparkle(1060, 840, 12, SEA_FOAM), dogStanding(1330, 985, 0.8, { flip: true }), vignette(0.16),
], 380, 560));
add('dog_drinking', () => withFirefly([
  skyRect(SKY.amber), sun(1240, 240, 100, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 780), groundBand(SAND_DARK, 985),
  well(560, 985, 1.2, true), waterShoe(900, 985, 1.1), dogStanding(1160, 985, 0.95, { flip: true, headDown: true, panting: false }), glow(980, 860, 200, GOLD, 0.2), vignette(0.16),
], 380, 560));

// ======================================================== Three in the Cave ==
add('cave_rock_sealed', () => withFirefly([
  skyRect(SKY.storm), stormCloud(500, 240, 400, 110), stormCloud(1200, 220, 420, 120), rain(9, 90, 220, 985, SEA_FOAM, 0.3, 60, 70),
  sky3('#4A3560', 985, 0.9), S.cave(800, 985, 1.2, STONE_DARK, '#0E0F16'), boulder(800, 985, 1.1, STONE, STONE_LIGHT), vignette(0.24),
], 1300, 600));
add('cave_milk_bowl', () => withFirefly([
  skyRect(SKY.roomEvening), archWindow(1220, 130, 220, 320, true), hangLine(400, 500, 0.9), lantern(400, 500, 0.9), groundBand('#3E2619', 985),
  mat(520, 985, 1.0, '#8A4A28', '#4A5D8A'), mat(900, 985, 1.0, '#6E4629', '#8A4A6A'), S.bowl(1250, 985, 1.4, true), glow(1250, 930, 160, CREAM, 0.25), vignette(0.24),
], 1000, 620));
add('cave_herd_wages', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills('#7C9F6E', 720, 60), groundBand('#5F8A5A', 985), tree(1450, 985, 1.2),
  S.ram(380, 985, 0.9), S.ram(560, 985, 0.8, true), S.ram(700, 985, 0.9), cow(1000, 985, 1.0, true, '#8A5A36'), cow(1300, 985, 0.9, true, INK_SOFT, true), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 1100, 520));
add('cave_rock_gap', () => withFirefly([
  skyRect(SKY.dayClear), sun(700, 520, 50, CREAM, '#E8C089'), hills('#8A5348', 900, 40), boulder(920, 985, 1.15, STONE_DARK, STONE), caveWalls(800, 985, 330, 380), glow(640, 840, 420, CREAM, 0.16),
  S.pebbles(5, 14, 200, 1400, 985, '#2B3140'), vignette(0.24),
], 1200, 640));
add('cave_rock_open', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 80, CREAM, '#E8C089', 12), sky3('#4A3560', 985, 0.9), S.cave(800, 985, 1.2, STONE_DARK, '#0E0F16', CREAM), boulder(1280, 985, 0.9, STONE, STONE_LIGHT),
  dove(600, 500, 0.9), dove(1000, 460, 0.8, IVORY, true), grass(3, 985, 30, '#5F8A5A'), vignette(0.16),
], 1100, 600));

// ================================================================= covers ==
const cover = (key, fn) => add(`companion_${key}_cover`, fn, 'covers');
cover('ali', () => withFirefly([room(false), archWindow(760, 110, 200, 300, true), hangLine(260, 400, 0.8), lantern(260, 400, 0.8), groundBand('#4A2F22', 860), bed(512, 860, 0.8, GREEN, true), vignette(0.22)], 820, 560));
cover('fatimah', () => withFirefly([skyRect(SKY.roomEvening), archWindow(240, 110, 200, 300, true), groundBand('#4A2F22', 860), bed(560, 860, 0.78, '#8A4A6A', false), ...[[300, 460], [520, 380], [760, 440]].flatMap(([x, y]) => [sparkle(x, y, 16), sparkle(x + 50, y - 40, 10), glow(x, y, 100, GOLD, 0.18)]), vignette(0.22)], 860, 600));
cover('anas', () => withFirefly([skyRect(SKY.dayClear), sun(220, 200, 60, CREAM, '#E8C089'), S.house(560, 860, 1.25, WALL, null, WALL_DEEP), S.doorway(560, 860, 1.05, WALL, WOOD_DARK, true), palm(170, 860, 0.9, GREEN_DEEP), groundBand(SAND_DARK, 860), S.basket(340, 826, 0.75), S.plateOfDates(340, 800, 0.75, 3), vignette(0.14)], 860, 520));
cover('thirsty_dog', () => withFirefly([skyRect(SKY.amber), sun(800, 220, 80, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 660), groundBand(SAND_DARK, 860), well(400, 860, 1.0, true), waterShoe(620, 860, 0.9), dogStanding(800, 860, 0.72, { flip: true }), vignette(0.16)], 240, 520));
cover('three_in_cave', () => withFirefly([skyRect(SKY.storm), stormCloud(300, 220, 300, 90), stormCloud(760, 200, 320, 100), mountains('#4A3560', 860, [[0, 860], [220, 400], [500, 560], [800, 340], [1024, 600]], 0.9), S.cave(512, 860, 1.0, STONE_DARK, '#0E0F16'), boulder(512, 860, 0.95, STONE, STONE_LIGHT), vignette(0.24)], 820, 520));

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
