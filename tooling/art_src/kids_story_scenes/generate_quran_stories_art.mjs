// Path of Nur — art for the Stories from the Qur'an shelf (C4).
//
// The Sleepers in the Cave, The Year of the Elephant, Luqman, Maryam, The
// Man with Two Gardens, Qarun, The Cow, The Ant and the Hoopoe. Same hand
// as the K3 scene kit: silhouettes, animals with a little expression, no
// people at all (these stories show what was seen), no faces, no text baked
// in, a firefly on every scene, subjects between y=215 and y=985 of 1200.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_quran_stories_art.mjs         # all
//   node tooling/art_src/kids_story_scenes/generate_quran_stories_art.mjs kahf_   # a subset
//
// Output:
//   assets/images/kids_books/scenes/<name>.webp   (1600x1200)
//   assets/images/kids_books/covers/<book>_cover.webp (1024x1024)
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
  rain, sparkle, star8, firefly, lantern, hangLine, city, palm, tree, grass, rock, dove, bird, cow, statue, kaaba,
  minaret, scene, groundBand, f, jar, sack, wheat, well, room, archWindow, table, mulberry32,
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

// ------------------------------------------------------------- helpers --
function elephant(x, gy, s, color = INK_SOFT, flip = false) {
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<path d="M -60 -20 l -6 20 M -20 -20 l -2 20 M 30 -20 l 2 20 M 70 -20 l 6 20" stroke="${color}" stroke-width="26" stroke-linecap="round"/>` +
    `<ellipse cx="0" cy="-120" rx="130" ry="96" fill="${color}"/><circle cx="130" cy="-150" r="64" fill="${color}"/>` +
    `<path d="M 170 -120 q 40 40 20 110 q -6 30 -30 30" stroke="${color}" stroke-width="30" fill="none" stroke-linecap="round"/>` +
    `<path d="M 150 -190 q 60 -40 90 0 q -30 30 -70 30 Z" fill="${color}"/><circle cx="150" cy="-160" r="5" fill="${IVORY}"/>` +
    `<path d="M -130 -110 q -30 20 -20 50" stroke="${color}" stroke-width="10" fill="none" stroke-linecap="round"/></g>`;
}
const dogLying = (x, gy, s, color = '#8A5A36') =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><ellipse cx="0" cy="-30" rx="110" ry="34" fill="${color}"/><circle cx="110" cy="-50" r="30" fill="${color}"/><path d="M 120 -78 l 10 -30 l 16 30 Z" fill="${color}"/>` +
  `<path d="M -110 -30 q -40 -20 -50 -60" stroke="${color}" stroke-width="12" fill="none" stroke-linecap="round"/><circle cx="122" cy="-54" r="4" fill="${IVORY}"/><path d="M -60 0 h 40 M 20 0 h 40" stroke="${color}" stroke-width="14" stroke-linecap="round"/></g>`;
const flock = (seed, n, x0, x1, y0, y1, s = 1) => { const rnd = mulberry32(seed); let out = ''; for (let i = 0; i < n; i++) { const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0); out += bird(x, y, (1.4 + rnd() * 1.6) * s, INK_SOFT) + `<circle cx="${f(x + 20)}" cy="${f(y + 18)}" r="3" fill="${STONE_DARK}"/>`; } return out; };
const coin = (x, y, s) => `<g transform="translate(${x} ${y}) scale(${s})"><circle r="60" fill="${DEEPGOLD}"/><circle r="46" fill="none" stroke="${GOLD}" stroke-width="8"/><circle r="12" fill="${GOLD}"/></g>`;
const keyRing = (x, y, s) => `<g transform="translate(${x} ${y}) scale(${s})" stroke="${DEEPGOLD}" stroke-width="16" fill="none" stroke-linecap="round"><circle r="70"/>` +
  [-40, 0, 40].map((a) => `<g transform="rotate(${a})"><path d="M 0 70 V 230 M -22 190 h 22 M -22 220 h 22"/></g>`).join('') + `</g>`;
const chest = (x, gy, s, open = true) => `<g transform="translate(${x} ${gy}) scale(${s})"><rect x="-140" y="-120" width="280" height="120" rx="12" fill="${WOOD}"/><rect x="-140" y="-120" width="280" height="18" fill="${WOOD_DARK}"/>` +
  (open ? `<path d="M -140 -120 Q -150 -220 0 -220 Q 150 -220 140 -120 Z" fill="${WOOD_DARK}"/><ellipse cx="0" cy="-125" rx="120" ry="26" fill="${GOLD}"/>` + [[-80, -150], [-30, -170], [30, -165], [80, -150], [0, -140]].map(([dx, dy]) => `<circle cx="${dx}" cy="${dy}" r="16" fill="${GOLD}" stroke="${DEEPGOLD}" stroke-width="3"/>`).join('') : `<rect x="-140" y="-150" width="280" height="40" rx="12" fill="${WOOD_DARK}"/>`) +
  `<rect x="-16" y="-110" width="32" height="30" rx="6" fill="${DEEPGOLD}"/></g>`;
const donkey = (x, gy, s, color = INK_SOFT, flip = false) => `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
  `<path d="M -50 -40 l -6 40 M -18 -40 l -2 40 M 18 -40 l 2 40 M 50 -40 l 6 40" stroke="${color}" stroke-width="12" stroke-linecap="round"/><ellipse cx="0" cy="-70" rx="80" ry="40" fill="${color}"/>` +
  `<path d="M 70 -90 q 30 -50 70 -50 q 30 0 40 20" stroke="${color}" stroke-width="26" fill="none" stroke-linecap="round"/><ellipse cx="180" cy="-120" rx="34" ry="22" fill="${color}"/>` +
  `<path d="M 150 -140 l -10 -50 l 24 40 M 175 -145 l 8 -52 l 14 46" stroke="${color}" stroke-width="10" fill="none" stroke-linecap="round"/><circle cx="188" cy="-124" r="4" fill="${IVORY}"/>` +
  `<path d="M -80 -70 q -30 20 -24 60" stroke="${color}" stroke-width="8" fill="none" stroke-linecap="round"/>${S.windStreaks ? '' : ''}</g>`;
const vine = (x, gy, s, alive = true) => { const leaf = alive ? LEAF : '#8A7F70', grape = alive ? '#8A4A6A' : '#5E564C'; return `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M 0 0 q 20 -120 -10 -220 q -20 -80 40 -140" stroke="${alive ? WOOD_DARK : '#5E564C'}" stroke-width="10" fill="none"/>` +
  (alive ? [[-40, -120], [30, -180], [-20, -240], [50, -300]].map(([dx, dy]) => `<path d="M ${dx} ${dy} q 40 -30 60 10 q -40 20 -60 -10 Z" fill="${leaf}"/>`).join('') : `<path d="M -30 -110 l -30 20 M 40 -170 l 30 -20 M 0 -250 l 30 10" stroke="#5E564C" stroke-width="8" stroke-linecap="round"/>`) +
  [[-10, -150], [10, -130], [-24, -130], [0, -110], [20, -110]].map(([dx, dy]) => `<circle cx="${dx}" cy="${dy}" r="10" fill="${grape}"/>`).join('') + `</g>`; };
const gate = (cx, baseY, s, color = DEEPGOLD) => `<g transform="translate(${cx} ${baseY}) scale(${s})"><rect x="-200" y="-320" width="30" height="320" fill="${STONE_LIGHT}"/><rect x="170" y="-320" width="30" height="320" fill="${STONE_LIGHT}"/><path d="M -200 -320 Q 0 -420 200 -320" stroke="${STONE_LIGHT}" stroke-width="28" fill="none"/>` +
  [-120, -60, 0, 60, 120].map((x) => `<rect x="${x - 6}" y="-300" width="12" height="300" fill="${color}"/>`).join('') + `<path d="M -170 -200 H 170" stroke="${color}" stroke-width="10"/></g>`;
const crack = (cx, y, s) => `<g transform="translate(${cx} ${y}) scale(${s})" fill="#1E1610"><path d="M -300 0 L -180 -30 L -60 10 L 40 -20 L 160 20 L 300 -10 L 320 40 L 180 70 L 60 40 L -60 80 L -180 40 L -320 60 Z"/></g>`;
const mustardSeed = (x, y, s) => `<g transform="translate(${x} ${y}) scale(${s})"><circle r="120" fill="none" stroke="${GOLD}" stroke-width="10" opacity="0.7"/><circle r="14" fill="#B8863C"/><circle cx="-4" cy="-4" r="4" fill="${CREAM}" opacity="0.8"/></g>`;
const letterScroll = (x, y, s, deg = -15) => `<g transform="translate(${x} ${y}) rotate(${deg}) scale(${s})">${S.scroll(0, 0, 1)}<circle cx="0" cy="-10" r="14" fill="#8A4A28"/></g>`;
const cowColored = (x, gy, s, color, flip = false) => cow(x, gy, s, true, color, flip);

// ================================================================ Sleepers ==
add('kahf_city_idols', () => withFirefly([
  skyRect(SKY.violetDusk), stars(3, 40, 0, W, 0, 400), crescent(280, 200, 56), city(900, '#6E4038', null, 15, 0.9), groundBand('#4A2F22', 985),
  `<rect x="300" y="900" width="1000" height="70" rx="10" fill="${STONE}"/>`, statue(520, 900, 0.9, STONE_DARK), statue(800, 900, 1.05, STONE_DARK), statue(1080, 900, 0.9, STONE_DARK), vignette(0.22),
], 1400, 640));
add('kahf_cave_entrance', () => withFirefly([
  skyRect(SKY.dawn), sun(1240, 260, 80, CREAM, '#E8B36A'), mountains('#8A5348', 985, [[0, 985], [300, 480], [700, 700], [1100, 400], [1600, 760]]),
  S.cave(800, 985, 1.2, STONE_DARK, '#0E0F16'), dogLying(560, 985, 0.9), grass(3, 985, 30, '#5F8A5A'), vignette(0.18),
], 1200, 560));
add('kahf_sun', () => withFirefly([
  skyRect(SKY.day), sun(300, 260, 90, CREAM, '#E8C089', 12), sun(1300, 260, 90, CREAM, '#E8B36A', 12), `<path d="M 300 260 Q 800 -40 1300 260" stroke="${GOLD}" stroke-width="6" fill="none" stroke-dasharray="18 22" opacity="0.6"/>`,
  mountains('#8A5348', 985, [[0, 985], [300, 520], [700, 720], [1100, 440], [1600, 780]]), S.cave(800, 985, 1.2, STONE_DARK, '#0E0F16'), vignette(0.16),
], 800, 640));
add('kahf_sleep', () => withFirefly([
  skyRect([[0, '#0A0C16'], [0.6, '#1A1F33'], [1, '#232A44']]), `<path d="M 0 0 Q 300 400 200 1200 M 1600 0 Q 1300 400 1400 1200" stroke="#0A0C16" stroke-width="260" fill="none"/>`,
  lightRays(800, -60, 5, 900, 0.8, CREAM, 0.16), glow(800, 700, 320, CREAM, 0.2), dogLying(1100, 985, 0.9, '#6E4629'), S.pebbles(3, 14, 200, 1400, 985, '#3A4266'), vignette(0.3),
], 480, 640));
add('kahf_coin', () => withFirefly([
  skyRect(SKY.day), sun(280, 200, 70), city(720, '#8A5348', null, 21, 0.9), groundBand('#B0743B', 985),
  `<rect x="520" y="860" width="560" height="120" rx="14" fill="${WOOD}"/>`, coin(800, 800, 1.3), glow(800, 800, 220, GOLD, 0.35), S.basket(1180, 940, 0.8), S.fruit(1150, 900, 1.2), jar(360, 985, 0.9), vignette(0.16),
], 1300, 560));

// ================================================================ Elephant ==
add('fil_army', () => withFirefly([
  skyRect(SKY.amber), sun(1300, 240, 90, CREAM, '#E8B36A', 12), dunes(SAND, SAND_DARK, 800), groundBand('#8A5348', 985),
  elephant(900, 985, 1.0), elephant(500, 985, 0.75, INK_SOFT, false), elephant(1300, 985, 0.6, '#5E4A3A', false), S.windStreaks(2, 30, 0, W, 800, 985, SAND_LIGHT, 0.4), vignette(0.18),
], 1450, 560));
add('fil_birds', () => withFirefly([
  skyRect(SKY.day), sun(280, 220, 70), flock(3, 60, 100, 1500, 120, 600, 1.2), dunes(SAND, SAND_DARK, 820), groundBand('#8A5348', 985),
  elephant(1100, 985, 0.9, INK_SOFT, true), rain(6, 60, 300, 900, STONE_DARK, 0.5, 20, 30), vignette(0.16),
], 380, 700));
add('fil_kaaba_safe', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), dove(560, 460, 1.0), dove(1080, 420, 0.9, IVORY, true), bird(800, 360, 3), bird(860, 330, 2.4),
  `<rect x="0" y="760" width="${W}" height="440" fill="${IVORY}"/>`, mountains('#8A7F70', 760, [[0, 760], [300, 560], [700, 700], [1200, 520], [1600, 680]], 0.6), kaaba(800, 985, 0.95), glow(800, 860, 380, CREAM, 0.3), vignette(0.14),
], 1300, 620));

// ================================================================== Luqman ==
add('luqman_tree_shade', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70, CREAM, '#E8C089'), hills('#7C9F6E', 720, 60), groundBand('#4F7C4A', 985), tree(800, 985, 1.8, WOOD_DARK, LEAF, LEAF_LIGHT), S.bench(800, 985, 1.1), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 400, 560));
add('luqman_mustard_seed', () => withFirefly([
  skyRect(SKY.amber), dunes(SAND, SAND_DARK, 800), groundBand('#8A5348', 985), rock(800, 985, 320, 180, STONE_DARK), mustardSeed(800, 800, 1.4), glow(800, 800, 240, GOLD, 0.3), vignette(0.16),
], 1240, 560));
add('luqman_mountain', () => withFirefly([
  skyRect(SKY.dawn), sun(300, 280, 80, CREAM, '#E8B36A'), mountains('#4A3560', 985, [[0, 985], [400, 420], [800, 640], [1200, 360], [1600, 700]], 0.9),
  `<path d="M 200 1100 Q 600 960 1000 985 Q 1300 1000 1500 900" stroke="#C48A5C" stroke-width="80" fill="none" stroke-linecap="round" opacity="0.5"/>`, dunes('#8A5348', '#6E4038', 900), vignette(0.16),
], 1100, 520));
add('luqman_donkey', () => withFirefly([
  skyRect(SKY.day), sun(300, 220, 70), hills('#7C9F6E', 760, 50), groundBand('#5F8A5A', 985), donkey(700, 985, 1.2), `<g stroke="${GOLD}" stroke-width="10" fill="none" stroke-linecap="round" opacity="0.7"><path d="M 980 780 q 40 -40 80 0 M 1020 720 q 60 -60 120 0"/></g>`, grass(4, 985, 40, '#2E5D48'), vignette(0.14),
], 1300, 560));

// ================================================================== Maryam ==
add('maryam_vow', () => withFirefly([
  skyRect(SKY.night), stars(23, 90, 0, W, 0, 520), groundBand('#3E2619', 985), S.mihrab(800, 985, 1.2, '#6E4629', '#3E2619', CREAM), hangLine(800, 600, 0.9), lantern(800, 600, 0.9), sparkle(500, 500, 14), sparkle(1100, 460, 14), vignette(0.24),
], 1200, 640));

// ============================================================= Two Gardens ==
add('gardens_rich', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 700, 60), S.river(860, SEA_LIGHT, SEA),
  vine(300, 985, 1.0), vine(500, 985, 0.9), vine(1100, 985, 1.0), vine(1300, 985, 0.9), palm(800, 800, 0.8, GREEN_DEEP), grass(3, 985, 40, '#2E5D48'), vignette(0.14),
], 900, 560));
add('gardens_boast', () => withFirefly([
  skyRect(SKY.amber), sun(1240, 240, 80, CREAM, '#E8B36A'), hills(LEAF_LIGHT, 760, 50), groundBand('#4F7C4A', 985), gate(800, 985, 1.0), vine(300, 985, 1.0), vine(1300, 985, 1.0), sparkle(600, 500, 14), sparkle(1000, 480, 14), vignette(0.16),
], 400, 560));
add('gardens_ruined', () => withFirefly([
  skyRect(SKY.storm), stormCloud(500, 260, 400, 110), stormCloud(1200, 220, 420, 120), hills('#8A7F70', 760, 40), groundBand('#5E564C', 985),
  vine(300, 985, 1.0, false), vine(560, 985, 0.9, false), vine(1100, 985, 1.0, false), vine(1340, 985, 0.9, false), `<path d="M 0 900 Q 400 880 800 900 T 1600 900" stroke="#8A7F70" stroke-width="30" fill="none" opacity="0.6"/>`, vignette(0.24),
], 850, 560));
add('gardens_regret', () => withFirefly([
  skyRect(SKY.violetDusk), stars(5, 30, 0, W, 0, 400), hills('#5E564C', 800, 40), groundBand('#3E3A34', 985), gate(800, 985, 1.0, '#8A7F70'), vine(400, 985, 1.0, false), vine(1200, 985, 1.0, false), vignette(0.24),
], 1200, 560));

// =================================================================== Qarun ==
add('qarun_keys', () => withFirefly([
  room(false), archWindow(1220, 130, 240, 340, true), table(H * 0.72), keyRing(600, 800, 0.9), keyRing(1000, 780, 0.8), keyRing(800, 900, 0.7), glow(800, 800, 300, GOLD, 0.25), vignette(0.18),
], 380, 560));
add('qarun_treasure', () => withFirefly([
  room(false), archWindow(400, 130, 240, 340, true), groundBand('#4A2F22', 985), chest(560, 985, 1.0), chest(1000, 985, 1.1), chest(1350, 985, 0.7, false), glow(800, 760, 360, GOLD, 0.35), sparkle(700, 600, 14), sparkle(1100, 560, 14), vignette(0.2),
], 1240, 500));
add('qarun_parade', () => withFirefly([
  skyRect(SKY.amber), sun(1240, 240, 80, CREAM, '#E8B36A'), city(880, '#8A5348', null, 13, 0.9), groundBand('#6E4629', 985),
  `<path d="M 0 985 Q 800 900 1600 985 V 1200 H 0 Z" fill="#8A4A28"/>`, chest(800, 940, 0.9), coin(560, 900, 0.5), coin(1040, 910, 0.5), coin(700, 960, 0.4), coin(900, 965, 0.4), glow(800, 800, 320, GOLD, 0.3), vignette(0.16),
], 380, 640));
add('qarun_earth', () => withFirefly([
  skyRect(SKY.storm), stormCloud(800, 220, 600, 150), glow(800, 120, 300, IVORY, 0.2), groundBand('#4A2F22', 985), crack(800, 1010, 1.4), chest(800, 985, 0.8, false), coin(600, 985, 0.4), coin(1000, 990, 0.4), vignette(0.3),
], 1300, 560));

// ===================================================================== Cow ==
add('cow_field', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), hills('#7C9F6E', 720, 60), groundBand('#5F8A5A', 985), cowColored(800, 985, 1.2, '#D9A05B'), grass(2, 985, 50, '#2E5D48'), tree(1350, 900, 1.1), vignette(0.14),
], 400, 560));
add('cow_question', () => withFirefly([
  skyRect(SKY.day), sun(1240, 220, 70), hills('#7C9F6E', 720, 60), groundBand('#5F8A5A', 985),
  cowColored(300, 985, 0.8, INK_SOFT), cowColored(620, 985, 0.8, '#8A5A36', true), cowColored(940, 985, 0.8, '#B5AA98'), cowColored(1280, 985, 0.8, '#D9A05B', true), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 800, 520));
add('cow_yellow', () => withFirefly([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), lightRays(800, 700, 9, 700, 1.6, GOLD, 0.12), hills('#7C9F6E', 720, 60), groundBand('#5F8A5A', 985), glow(800, 840, 320, GOLD, 0.35), cowColored(800, 985, 1.3, '#E8C24A'), sparkle(600, 640, 14), sparkle(1000, 620, 14), grass(2, 985, 40, '#2E5D48'), vignette(0.14),
], 1300, 560));

// ========================================================== Ant & Hoopoe ==
add('ant_valley', () => withFirefly([
  skyRect(SKY.dayClear), sun(1240, 220, 70), hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50), groundBand('#4F7C4A', 985),
  S.windStreaks(2, 20, 900, 1600, 700, 800, SAND_LIGHT, 0.5), S.antHole(700, 985, 1.2), S.ant(560, 970, 1.2), S.ant(640, 975, 1.0), S.ant(860, 972, 1.1, INK, true), S.ant(940, 968, 0.9, INK, true), grass(3, 985, 40, '#2E5D48'), vignette(0.14),
], 400, 560));
add('hoopoe_flight', () => withFirefly([
  skyRect(SKY.day), sun(280, 220, 70), cloud(1100, 220, 130, 38, 0.5), mountains('#4A3560', 900, [[0, 900], [400, 660], [800, 800], [1200, 600], [1600, 760]], 0.7), K.sea(940, '#4F7C9A', '#1E4B6E', '#12304A', SEA_FOAM, 16),
  S.hoopoe(760, 500, 1.6), letterScroll(900, 560, 0.7), vignette(0.16),
], 1300, 400));

// ================================================================= covers ==
const cover = (key, fn) => add(`${key}_cover`, fn, 'covers');
cover('sleepers', () => withFirefly([skyRect(SKY.dawn), sun(800, 220, 60, CREAM, '#E8B36A'), mountains('#8A5348', 860, [[0, 860], [200, 380], [500, 600], [800, 300], [1024, 620]]), S.cave(512, 860, 1.0, STONE_DARK, '#0E0F16'), dogLying(330, 860, 0.7), vignette(0.18)], 780, 500));
cover('elephant', () => withFirefly([skyRect(SKY.day), flock(3, 40, 60, 960, 100, 460, 1.0), dunes(SAND, SAND_DARK, 700), groundBand('#8A5348', 860), elephant(560, 860, 0.8), kaaba(200, 800, 0.4), vignette(0.16)], 860, 560));
cover('luqman', () => withFirefly([skyRect(SKY.dayClear), sun(820, 200, 60, CREAM, '#E8C089'), hills('#7C9F6E', 640, 40), groundBand('#4F7C4A', 860), tree(512, 860, 1.4, WOOD_DARK, LEAF, LEAF_LIGHT), S.bench(512, 860, 0.9), vignette(0.14)], 240, 520));
cover('maryam', () => withFirefly([skyRect(SKY.dawn), sun(220, 240, 60, CREAM, '#E8B36A'), hills('#7C9F6E', 700, 40), S.stream(760, SEA_LIGHT, SEA), palm(512, 860, 1.3, GREEN_DEEP), S.datePalmCluster(560, 640, 0.9), vignette(0.16)], 800, 400));
cover('two_gardens', () => withFirefly([skyRect(SKY.dayClear), sun(220, 200, 60, CREAM, '#E8C089'), hills(LEAF_LIGHT, 620, 40), S.river(740, SEA_LIGHT, SEA), vine(200, 860, 0.8), vine(360, 860, 0.7), vine(680, 860, 0.8), vine(840, 860, 0.7), vignette(0.14)], 512, 440));
cover('qarun', () => withFirefly([room(false), archWindow(760, 110, 200, 300, true), groundBand('#4A2F22', 860), chest(400, 860, 0.8), chest(680, 860, 0.9), glow(512, 660, 280, GOLD, 0.35), keyRing(512, 560, 0.6), vignette(0.2)], 240, 520));
cover('cow', () => withFirefly([skyRect(SKY.dayClear), sun(220, 200, 60, CREAM, '#E8C089'), hills('#7C9F6E', 640, 40), groundBand('#5F8A5A', 860), glow(512, 740, 240, GOLD, 0.3), cowColored(512, 860, 1.0, '#E8C24A'), grass(2, 860, 30, '#2E5D48'), vignette(0.14)], 820, 520));
cover('ant_hoopoe', () => withFirefly([skyRect(SKY.dayClear), sun(820, 200, 60, CREAM, '#E8C089'), hills('#7C9F6E', 640, 40), groundBand('#4F7C4A', 860), S.hoopoe(512, 420, 1.3), S.antHole(512, 860, 1.0), S.ant(400, 846, 1.0), S.ant(620, 848, 1.0, INK, true), grass(3, 860, 30, '#2E5D48'), vignette(0.14)], 240, 560));

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
