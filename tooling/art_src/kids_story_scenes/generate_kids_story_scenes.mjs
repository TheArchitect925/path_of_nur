// Path of Nur — page scenes for the twenty older kids stories (K3).
//
// The picture books (tooling/art_src/kids_books) draw a picture per spread.
// The eight prophet bedtime stories and the adab stories that came before
// them only had a cover and a backdrop, so the reader showed the same
// picture on every page. This draws them a handful of scenes each, in the
// same hand (scene_kit.mjs is the books' grammar, story_helpers.mjs adds
// what these stories need), and the Dart side spreads them over the pages
// through lib/features/kids/bedtime_stories/data/kids_story_scene_plans.dart.
//
// Rules carried over: silhouettes, no faces, no text baked in, prophets are
// never drawn (a prophet scene shows what the prophet saw), a firefly hides
// on every scene, and every subject sits between y=215 and y=985 because
// the reader crops the 4:3 picture to a wide band.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_story_scenes/generate_kids_story_scenes.mjs          # all
//   node tooling/art_src/kids_story_scenes/generate_kids_story_scenes.mjs musa_    # a subset
//
// Output: assets/images/kids_books/scenes/<name>.webp (1600x1200), SVG kept
// next to this file under svg/.
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';
import * as K from './scene_kit.mjs';
import * as S from './story_helpers.mjs';

const {
  IVORY, CREAM, GOLD, DEEPGOLD, INK, INK_SOFT, WOOD, WOOD_DARK, SEA, SEA_DEEP, SEA_LIGHT, SEA_FOAM,
  GREEN, GREEN_DEEP, LEAF, LEAF_LIGHT, SAND, SAND_DARK, SAND_LIGHT, STONE, STONE_DARK, STONE_LIGHT,
  WALL, WALL_DEEP, SKY, skyRect, glow, vignette, stars, crescent, fullMoon, sun, lightRays, hills, dunes,
  mountains, cloud, sparkle, firefly, lantern, hangLine, mosque, city, palm, tree, grass, rock, sea, camel,
  dove, bird, statue, room, archWindow, cushion, table, kaaba, prayerMat, child, scene, minaret, dome,
  well, sheep, glass, bowlOfDates, blanket, hammer,
} = K;

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = join(ROOT, 'assets/images/kids_books/scenes');
const ONLY = process.argv.slice(2).filter((a) => !a.startsWith('--'));
const W = 1600, H = 1200;

const SCENES = [];
const add = (name, fn) => SCENES.push([name, fn]);
const ground = (color, y) => `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/>`;
const floorBand = (y, color = WOOD) => `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/><rect x="0" y="${y}" width="${W}" height="18" fill="#54382A"/>`;

// ================================================================== Adam ==
add('adam_creation', () => scene([
  skyRect(SKY.violetDusk), stars(3, 120, 0, W, 0, 620), crescent(1180, 230, 64),
  mountains('#4A3560', 780, [[0, 780], [280, 520], [560, 700], [860, 460], [1140, 660], [1400, 540], [1600, 700]], 0.85),
  mountains('#2C2347', 860, [[0, 860], [300, 700], [640, 800], [980, 680], [1300, 780], [1600, 720]], 0.9),
  sea(900, '#4F7C9A', '#1E4B6E', '#12304A', SEA_FOAM, 20), firefly(420, 640, 1.2), vignette(0.2),
]));

add('adam_jannah', () => scene([
  skyRect(SKY.dayClear), sun(1240, 250, 70, CREAM, '#E8C089'), cloud(420, 240, 150, 44, 0.55),
  hills(LEAF_LIGHT, 700, 60), hills(LEAF, 790, 50), S.stream(840, SEA_LIGHT, SEA),
  tree(260, 800, 1.4), tree(1340, 780, 1.6, WOOD_DARK, GREEN, LEAF), tree(760, 720, 0.9),
  palm(1120, 800, 0.9, GREEN_DEEP), grass(4, 1000, 26, GREEN_DEEP, 1.2),
  S.fruit(232, 640, 1.2, '#B8683C'), S.fruit(300, 600, 1.1, GOLD), S.fruit(1310, 560, 1.4, '#B8683C'),
  firefly(980, 620, 1.2), vignette(0.14),
]));

add('adam_one_tree', () => scene([
  skyRect(SKY.emeraldLift), hills('#3F5A48', 800, 40), ground('#2E4A3A', 900),
  tree(300, 940, 1.1, WOOD_DARK, GREEN_DEEP, GREEN), tree(1320, 950, 1.2, WOOD_DARK, GREEN_DEEP, GREEN),
  glow(800, 620, 360, GOLD, 0.35), tree(800, 900, 1.9, WOOD, DEEPGOLD, GOLD),
  `<path d="M 560 930 Q 800 990 1040 930" stroke="${GOLD}" stroke-width="10" fill="none" stroke-dasharray="26 22" opacity="0.7"/>`,
  sparkle(640, 520, 14), sparkle(960, 540, 12), firefly(1100, 760, 1.2), vignette(0.18),
]));

add('adam_forgiveness', () => scene([
  skyRect(SKY.night), stars(9, 100, 0, W, 0, 700), lightRays(800, 120, 9, 900, 1.3, CREAM, 0.14),
  glow(800, 300, 320, CREAM, 0.35), crescent(800, 300, 70),
  hills('#1A1F33', 860, 50), hills('#121423', 960, 30),
  child('zayn', { x: 800, y: 1010, s: 0.9, pose: 'sit' }), firefly(1060, 700, 1.3), vignette(0.22),
]));

add('adam_earth', () => scene([
  skyRect(SKY.dawn), sun(800, 520, 100, CREAM, '#E8B36A', 14),
  hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50), ground('#3F5A48', 930),
  `<path d="M 720 1200 Q 780 1000 800 900" stroke="${SAND_LIGHT}" stroke-width="90" fill="none" stroke-linecap="round" opacity="0.6"/>`,
  tree(300, 860, 1.0), tree(1340, 880, 1.2), bird(1100, 380, 2.8), bird(1160, 350, 2.2),
  firefly(520, 700, 1.2), vignette(0.14),
]));

// =============================================================== Ibrahim ==
add('ibrahim_idols', () => scene([
  room(false), archWindow(1240, 120, 240, 340, true),
  [280, 520, 800, 1080].map((x, i) => S.idolStatue(x, 985, 0.9 + (i === 2 ? 0.35 : 0), i === 2 ? INK : STONE_DARK)).join(''),
  hangLine(160, 420, 0.8), lantern(160, 420, 0.8), firefly(1380, 760, 1.2), vignette(0.22),
]));

add('ibrahim_star', () => scene([
  skyRect(SKY.night), stars(11, 80, 0, W, 0, 760, IVORY, 1.8),
  glow(1080, 300, 260, CREAM, 0.45), K.star8(1080, 300, 52, CREAM),
  dunes('#232A44', '#1A1F33', 860), palm(280, 940, 1.0, '#121423'),
  child('zayn', { x: 700, y: 1010, s: 0.9, arms: 'up' }), firefly(1300, 720, 1.2), vignette(0.2),
]));

add('ibrahim_moon', () => scene([
  skyRect(SKY.violet), stars(12, 60, 0, W, 0, 700, IVORY, 1.6), fullMoon(1000, 320, 110),
  dunes('#4A3560', '#2C2347', 860), rock(1400, 960, 120, 50, '#2C2347'),
  child('zayn', { x: 640, y: 1010, s: 0.9, arms: 'up' }), firefly(300, 700, 1.2), vignette(0.2),
]));

add('ibrahim_sunrise', () => scene([
  skyRect(SKY.amber), sun(1000, 420, 120, CREAM, '#E8B36A', 16), cloud(300, 260, 160, 46, 0.5),
  dunes('#B0743B', '#8A5348', 860), palm(280, 940, 1.0, '#6E4038'),
  child('zayn', { x: 640, y: 1010, s: 0.9, arms: 'out' }), firefly(1320, 720, 1.2), vignette(0.14),
]));

add('ibrahim_broken_idols', () => scene([
  room(false), archWindow(1240, 120, 240, 340, false),
  S.statueFallen(320, 985, 0.9), S.statueFallen(760, 985, 0.8), S.statueFallen(1080, 985, 0.7),
  S.idolStatue(1360, 985, 1.25, INK), S.hammerOnShoulder(1300, 690, 1.1),
  firefly(600, 760, 1.2), vignette(0.22),
]));

add('ibrahim_cool_fire', () => scene([
  skyRect(SKY.storm), stars(6, 30, 0, W, 0, 400, IVORY, 1.4),
  hills('#3E4A5E', 800, 40), ground('#2B3140', 880),
  S.fireRing(800, 880, 560, 150), glow(800, 800, 300, CREAM, 0.4),
  tree(800, 880, 1.0, WOOD, LEAF, LEAF_LIGHT), grass(7, 900, 16, LEAF_LIGHT, 1.0),
  dove(1080, 560, 0.9), firefly(520, 700, 1.3), vignette(0.2),
]));

// ================================================================ Ismail ==
add('ismail_home', () => scene([
  skyRect(SKY.day), sun(1220, 260, 76, CREAM, '#E8C089'), cloud(420, 240, 150, 44, 0.5),
  mountains('#B0743B', 760, [[0, 760], [320, 600], [700, 720], [1000, 560], [1300, 700], [1600, 640]], 0.7),
  dunes(SAND, SAND_DARK, 840), S.house(1160, 985, 0.8, WALL, null), palm(420, 960, 1.2, GREEN_DEEP), palm(560, 990, 0.9, GREEN_DEEP),
  well(760, 985, 0.9, true), sheep(300, 1000, 0.8), firefly(960, 680, 1.2), vignette(0.16),
]));

add('ismail_dream', () => scene([
  skyRect(SKY.violet), stars(14, 90, 0, W, 0, 720, IVORY, 1.8), crescent(360, 260, 62),
  glow(1000, 420, 380, CREAM, 0.3), lightRays(1000, 420, 7, 520, 1.1, CREAM, 0.12),
  dunes('#4A3560', '#2C2347', 860), S.house(1200, 985, 0.7, '#2C2347', GOLD),
  child('zayn', { x: 600, y: 1010, s: 0.9, pose: 'sit' }), firefly(800, 760, 1.2), vignette(0.22),
]));

add('ismail_walk', () => scene([
  skyRect(SKY.amber), sun(300, 300, 90, CREAM, '#E8B36A'),
  mountains('#8A5348', 760, [[0, 760], [400, 620], [800, 720], [1200, 580], [1600, 700]], 0.7),
  dunes(SAND, SAND_DARK, 840), dunes(SAND_LIGHT, SAND, 960),
  S.footprints(3, 1100, 1180, 760, 880, 12), S.footprints(4, 1180, 1190, 840, 900, 12, '#8A5348'),
  palm(1380, 940, 1.0, '#6E4038'), firefly(560, 700, 1.2), vignette(0.16),
]));

add('ismail_ram', () => scene([
  skyRect(SKY.dayClear), lightRays(800, 100, 8, 900, 1.2, CREAM, 0.14), sun(800, 220, 70, CREAM, '#E8C089'),
  hills('#7C9F6E', 760, 60), ground('#5F8A5A', 880), rock(1300, 960, 160, 70, STONE),
  S.ram(800, 940, 1.2), grass(5, 990, 22, GREEN_DEEP, 1.2), dove(400, 520, 0.9), firefly(1120, 700, 1.2), vignette(0.14),
]));

add('ismail_eid', () => scene([
  skyRect(SKY.night), stars(17, 100, 0, W, 0, 640), crescent(1160, 240, 80),
  mosque(800, 900, 1.0, '#1A1F33'), ground('#0E1120', 900),
  hangLine(240, 460, 0.9), lantern(240, 460, 0.9), hangLine(1380, 520, 0.8), lantern(1380, 520, 0.8),
  child('safa', { x: 560, y: 1010, s: 0.85, arms: 'up' }), child('zayn', { x: 1040, y: 1010, s: 0.85, arms: 'up', flip: true }),
  firefly(800, 640, 1.2), vignette(0.2),
]));

// ================================================================== Musa ==
add('musa_river_basket', () => scene([
  skyRect(SKY.dawn), sun(1200, 300, 80, CREAM, '#E8B36A'), cloud(400, 240, 150, 44, 0.5),
  palm(200, 760, 1.2, GREEN_DEEP), palm(1400, 740, 1.3, GREEN_DEEP), hills('#6E4629', 760, 20),
  S.river(800, SEA_LIGHT, SEA), S.reeds(2, 0, 420, 900, 14), S.reeds(6, 1200, 1600, 920, 12),
  S.basket(800, 880, 1.0), glow(800, 860, 220, CREAM, 0.3), firefly(1000, 640, 1.2), vignette(0.16),
]));

add('musa_palace', () => scene([
  skyRect(SKY.day), sun(300, 280, 70, CREAM, '#E8C089'),
  S.palace(1000, 780, 0.9, WALL_DEEP, CREAM), palm(240, 800, 1.3, GREEN_DEEP), palm(1500, 820, 1.0, GREEN_DEEP),
  S.river(860, SEA_LIGHT, SEA), S.reeds(8, 0, 300, 940, 8), S.basket(560, 930, 0.8),
  firefly(760, 640, 1.2), vignette(0.16),
]));

add('musa_fire_mountain', () => scene([
  skyRect(SKY.night), stars(19, 90, 0, W, 0, 600),
  mountains('#232A44', 760, [[0, 760], [300, 560], [560, 700], [820, 420], [1100, 640], [1400, 520], [1600, 700]], 1),
  mountains('#1A1F33', 900, [[0, 900], [400, 800], [800, 860], [1200, 780], [1600, 860]], 1),
  S.flames(820, 560, 0.9), tree(820, 560, 0.5, WOOD_DARK, LEAF, LEAF_LIGHT),
  child('zayn', { x: 520, y: 1010, s: 0.9, arms: 'out' }), firefly(1200, 720, 1.2), vignette(0.22),
]));

add('musa_staff', () => scene([
  skyRect(SKY.amber), S.palace(1100, 720, 0.6, '#8A5348', null), dunes(SAND, SAND_DARK, 800), dunes(SAND_LIGHT, SAND, 920),
  `<path d="M 420 980 Q 700 900 1180 960" stroke="${WOOD_DARK}" stroke-width="26" fill="none" stroke-linecap="round"/>`,
  `<path d="M 1180 960 q 40 -20 60 10" stroke="${WOOD_DARK}" stroke-width="26" fill="none" stroke-linecap="round"/>`,
  glow(800, 940, 260, CREAM, 0.35), sparkle(700, 860, 14), sparkle(1000, 880, 12), firefly(360, 700, 1.2), vignette(0.16),
]));

add('musa_sea_split', () => scene([
  skyRect(SKY.storm), cloud(300, 220, 180, 50, 0.6, '#3E4A5E'), cloud(1300, 260, 200, 56, 0.6, '#3E4A5E'),
  lightRays(800, 60, 6, 700, 0.6, CREAM, 0.16),
  S.seaWalls(600, 1000, 520), S.footprints(5, 800, 1160, 800, 760, 8, SAND_DARK),
  firefly(800, 700, 1.3), vignette(0.2),
]));

add('musa_safe_shore', () => scene([
  skyRect(SKY.dawn), sun(1180, 340, 90, CREAM, '#E8B36A', 12), cloud(360, 240, 150, 44, 0.5),
  sea(760, '#7A9AA8', '#4F7C9A', '#1E4B6E', IVORY, 12), dunes(SAND_LIGHT, SAND, 920),
  palm(300, 960, 1.1, '#6E4038'), rock(1440, 1000, 140, 60, SAND_DARK),
  child('safa', { x: 760, y: 1010, s: 0.85, arms: 'up' }), child('amina', { x: 1000, y: 1010, s: 0.8, arms: 'up', flip: true }),
  dove(560, 560, 0.9), firefly(1240, 700, 1.2), vignette(0.14),
]));

// ================================================================= Dawud ==
add('dawud_valley', () => scene([
  skyRect(SKY.day), sun(300, 280, 70, CREAM, '#E8C089'),
  mountains('#7A9AA8', 720, [[0, 720], [400, 520], [800, 680], [1200, 480], [1600, 640]], 0.6),
  hills('#7C9F6E', 820, 40), ground('#5F8A5A', 900),
  `<path d="M 1160 900 v -420 q 0 -80 60 -80 q 60 0 60 80 v 420 Z" fill="#3E4A5E" opacity="0.55"/>`,
  `<ellipse cx="1220" cy="360" rx="80" ry="70" fill="#3E4A5E" opacity="0.55"/>`,
  child('zayn', { x: 420, y: 1010, s: 0.8 }), S.pebbles(2, 6, 300, 700, 1010), firefly(800, 700, 1.2), vignette(0.16),
]));

add('dawud_sling', () => scene([
  skyRect(SKY.amber), hills('#B0743B', 760, 40), dunes(SAND, SAND_DARK, 860),
  S.sling(800, 880, 1.3, -14), S.pebbles(9, 5, 560, 1060, 990, STONE_LIGHT),
  glow(800, 880, 240, CREAM, 0.25), firefly(1200, 700, 1.2), vignette(0.16),
]));

add('dawud_stone_flies', () => scene([
  skyRect(SKY.dayClear), sun(1260, 240, 70, CREAM, '#E8C089'), cloud(500, 220, 140, 40, 0.5),
  hills('#7C9F6E', 800, 40), ground('#5F8A5A', 900),
  `<path d="M 1180 900 v -380 q 0 -70 50 -70 q 50 0 50 70 v 380 Z" fill="#3E4A5E" opacity="0.5"/>`,
  S.stoneArc(520, 900, 1230, 500), child('zayn', { x: 480, y: 1010, s: 0.8, arms: 'up' }),
  firefly(860, 700, 1.2), vignette(0.16),
]));

add('dawud_mountains_birds', () => scene([
  skyRect(SKY.dawn), sun(800, 360, 90, CREAM, '#E8B36A', 12),
  mountains('#8A5348', 720, [[0, 720], [300, 480], [600, 640], [900, 420], [1200, 600], [1600, 500]], 0.8),
  mountains('#6E4038', 860, [[0, 860], [400, 740], [800, 820], [1200, 720], [1600, 800]], 0.9),
  bird(300, 300, 3), bird(420, 260, 2.4), bird(1100, 320, 2.8), bird(1240, 280, 2.2), bird(700, 520, 2.6), dove(1000, 560, 0.9),
  firefly(560, 700, 1.2), vignette(0.16),
]));

add('dawud_justice', () => scene([
  room(true), archWindow(300, 120, 240, 340, false), archWindow(1300, 120, 240, 340, false),
  S.carpet(800, 940, 900, 60, '#8A4A28', GOLD), S.throne(800, 900, 0.85), S.scales(1240, 985, 0.75),
  cushion(360, 985, 110, 160, '#4E8A6C'), firefly(560, 700, 1.2), vignette(0.16),
]));

// =================================================================== Isa ==
add('isa_mihrab', () => scene([
  room(false), S.mihrab(800, 985, 1.0), lightRays(800, 380, 7, 600, 1.0, CREAM, 0.12),
  hangLine(300, 440, 0.8), lantern(300, 440, 0.8), hangLine(1300, 440, 0.8), lantern(1300, 440, 0.8),
  prayerMat(800, 900, 360, 90), firefly(1100, 720, 1.2), vignette(0.2),
]));

add('isa_palm_stream', () => scene([
  skyRect(SKY.dayClear), sun(1240, 260, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 760, 40), ground(LEAF, 860),
  S.stream(900, SEA_LIGHT, SEA), palm(760, 900, 1.6, GREEN_DEEP), S.datePalmCluster(790, 640, 1.2),
  S.datePalmCluster(560, 900, 0.9), grass(11, 950, 20, GREEN_DEEP, 1.1), dove(1100, 520, 0.9), firefly(400, 700, 1.2), vignette(0.14),
]));

add('isa_cradle', () => scene([
  room(true), archWindow(1240, 120, 260, 360, true), glow(700, 760, 320, CREAM, 0.45),
  S.cradle(700, 985, 1.0), hangLine(300, 440, 0.8), lantern(300, 440, 0.8),
  sparkle(560, 560, 14), sparkle(880, 600, 12), firefly(1060, 800, 1.2), vignette(0.18),
]));

add('isa_village_morning', () => scene([
  skyRect(SKY.dawn), sun(1200, 420, 90, CREAM, '#E8B36A', 12), city(880, '#8A5348', null, 21, 0.9), city(960, WALL_DEEP, null, 17, 1.1),
  ground('#6E4629', 960), dove(400, 480, 1.0), dove(1000, 560, 0.9, IVORY, true), dove(620, 620, 0.8),
  child('amina', { x: 700, y: 1010, s: 0.8 }), child('safa', { x: 900, y: 1010, s: 0.8, flip: true }), firefly(1300, 760, 1.2), vignette(0.16),
]));

add('isa_raised', () => scene([
  skyRect(SKY.dayClear), lightRays(800, -40, 10, 1000, 1.4, CREAM, 0.16), glow(800, 320, 380, CREAM, 0.5),
  cloud(400, 460, 180, 50, 0.7), cloud(1200, 400, 200, 56, 0.7), cloud(800, 560, 220, 60, 0.75),
  hills('#7FA6C0', 860, 40), ground('#5F8A5A', 960), dove(800, 300, 1.2), dove(640, 400, 0.8), dove(980, 420, 0.8, IVORY, true),
  firefly(500, 720, 1.2), vignette(0.12),
]));

// ============================================================== Sulaiman ==
add('sulaiman_ants', () => scene([
  skyRect(SKY.day), sun(1260, 240, 70, CREAM, '#E8C089'), hills('#7C9F6E', 740, 50), dunes(SAND, SAND_DARK, 840),
  camel(1240, 780, 0.5), camel(1360, 790, 0.45, INK_SOFT, true), S.antHole(700, 1000, 1.3),
  S.ant(380, 960, 1.1), S.ant(480, 985, 1.0), S.ant(580, 1000, 1.0), S.ant(900, 970, 1.0, INK, true), S.ant(1010, 990, 1.0, INK, true),
  grass(13, 1010, 16, GREEN_DEEP, 1.0), firefly(1000, 640, 1.2), vignette(0.14),
]));

add('sulaiman_wind', () => scene([
  skyRect(SKY.dayClear), sun(300, 260, 70, CREAM, '#E8C089'), cloud(1200, 300, 200, 56, 0.6), cloud(600, 640, 160, 46, 0.5),
  S.windStreaks(5, 14, 0, W, 300, 900, IVORY, 0.4), S.carpet(800, 760, 700, 40, '#8A4A28', GOLD), S.throne(800, 760, 0.6),
  hills('#7FA6C0', 900, 40), city(1000, '#5F8A5A', null, 9, 0.6), firefly(1200, 640, 1.2), vignette(0.14),
]));

add('sulaiman_hoopoe', () => scene([
  skyRect(SKY.amber), sun(1200, 300, 80, CREAM, '#E8B36A'), S.palace(800, 900, 0.8, WALL_DEEP, null), ground('#6E4629', 900),
  S.hoopoe(620, 520, 1.4), S.scroll(700, 600, 1.0), palm(240, 900, 1.2, '#6E4038'), palm(1420, 900, 1.0, '#6E4038'),
  firefly(1100, 680, 1.2), vignette(0.16),
]));

add('sulaiman_sun_kingdom', () => scene([
  skyRect(SKY.dayClear), sun(1240, 240, 70, CREAM, '#E8C089'), S.palace(800, 900, 0.9, STONE, null), ground(SAND_DARK, 900),
  S.sunSymbol(800, 620, 60, GOLD), palm(200, 900, 1.2, GREEN_DEEP), palm(1440, 900, 1.1, GREEN_DEEP),
  child('amina', { x: 500, y: 1010, s: 0.8 }), firefly(1100, 700, 1.2), vignette(0.16),
]));

add('sulaiman_throne', () => scene([
  room(true), archWindow(300, 120, 240, 340, false), archWindow(1300, 120, 240, 340, false),
  S.carpet(800, 950, 1000, 60, '#8A4A28', GOLD), glow(800, 640, 300, CREAM, 0.35), S.throne(800, 900, 0.95),
  sparkle(560, 520, 16), sparkle(1040, 540, 14), firefly(1200, 780, 1.2), vignette(0.16),
]));

add('sulaiman_thankful_night', () => scene([
  skyRect(SKY.night), stars(23, 100, 0, W, 0, 640), crescent(400, 240, 60),
  hills('#1A1F33', 800, 40), ground('#121423', 900), tree(300, 900, 1.0, '#0E1120', '#1A2A3A', '#233A4A'), tree(1300, 900, 1.2, '#0E1120', '#1A2A3A', '#233A4A'),
  hangLine(600, 520, 0.8), lantern(600, 520, 0.8), hangLine(1000, 480, 0.8), lantern(1000, 480, 0.8),
  child('zayn', { x: 800, y: 1010, s: 0.9, pose: 'sit', arms: 'up' }), firefly(1200, 720, 1.3), vignette(0.22),
]));

// ============================================================== Muhammad ==
add('muhammad_makkah_morning', () => scene([
  skyRect(SKY.dawn), sun(1200, 400, 90, CREAM, '#E8B36A', 12),
  mountains('#8A5348', 720, [[0, 720], [300, 560], [600, 680], [1000, 520], [1300, 660], [1600, 600]], 0.7),
  city(880, '#B0743B', null, 15, 0.8), ground('#6E4629', 880), kaaba(800, 1000, 0.55), dove(500, 520, 0.9),
  firefly(1100, 700, 1.2), vignette(0.16),
]));

add('muhammad_orphan_home', () => scene([
  skyRect(SKY.night), stars(27, 80, 0, W, 0, 600), crescent(1200, 240, 60),
  city(860, '#1A1F33', null, 19, 0.8), ground('#0E1120', 880), S.house(700, 985, 0.9, '#232A44', GOLD),
  glow(700, 760, 300, GOLD, 0.25), hangLine(1200, 500, 0.8), lantern(1200, 500, 0.8), firefly(400, 720, 1.3), vignette(0.22),
]));

add('muhammad_caravan', () => scene([
  skyRect(SKY.violetDusk), stars(5, 30, 0, W, 0, 400), crescent(300, 220, 60),
  mountains('#4A3560', 760, [[0, 760], [400, 600], [800, 700], [1200, 560], [1600, 680]], 0.7), dunes('#8A5348', '#6E4038', 840),
  camel(560, 930, 0.9, '#2C2347'), camel(820, 940, 0.9, '#2C2347'), camel(1080, 930, 0.9, '#2C2347'), K.sack(700, 930, 0.6), K.sack(960, 940, 0.6),
  firefly(1300, 700, 1.2), vignette(0.2),
]));

add('muhammad_hira_night', () => scene([
  skyRect(SKY.night), stars(29, 110, 0, W, 0, 640), fullMoon(360, 260, 70),
  mountains('#232A44', 700, [[0, 700], [400, 560], [800, 380], [1200, 560], [1600, 660]], 1), mountains('#1A1F33', 900, [[0, 900], [500, 820], [1000, 860], [1600, 800]], 1),
  S.cave(800, 760, 0.55, '#1A1F33', '#0A0C16', CREAM), glow(800, 680, 160, CREAM, 0.35), firefly(1100, 760, 1.3), vignette(0.22),
]));

add('muhammad_cave_light', () => scene([
  skyRect(SKY.black), stars(31, 60, 0, W, 0, 500),
  mountains('#101326', 800, [[0, 800], [400, 640], [800, 460], [1200, 640], [1600, 760]], 1),
  S.cave(800, 985, 1.1, '#1A1F33', '#0A0C16', null), glow(800, 820, 420, CREAM, 0.55), lightRays(800, 760, 11, 620, 1.7, CREAM, 0.08), glow(800, 820, 220, CREAM, 0.7),
  sparkle(660, 680, 16), sparkle(940, 700, 14), sparkle(800, 600, 12), firefly(1200, 820, 1.3), vignette(0.2),
]));

add('muhammad_home_comfort', () => scene([
  room(false), archWindow(1240, 120, 260, 360, true), hangLine(300, 420, 0.9), lantern(300, 420, 0.9),
  blanket(560, 860, 520, 120, '#4A5D8A', 0.6), cushion(1100, 985, 120, 170, '#8A4A6A'), cushion(420, 985, 110, 160, '#4E8A6C'),
  glow(820, 760, 260, CREAM, 0.3), firefly(1000, 700, 1.2), vignette(0.2),
]));

add('muhammad_makkah_night', () => scene([
  skyRect(SKY.night), stars(33, 100, 0, W, 0, 640), crescent(1200, 240, 70),
  city(880, '#1A1F33', GOLD, 15, 0.8), ground('#0E1120', 880), kaaba(800, 1000, 0.55),
  hangLine(300, 520, 0.8), lantern(300, 520, 0.8), firefly(1000, 720, 1.3), vignette(0.22),
]));

add('muhammad_patience_dawn', () => scene([
  skyRect(SKY.dawn), sun(800, 480, 100, CREAM, '#E8B36A', 14), city(880, '#8A5348', null, 15, 0.8), ground('#6E4629', 880),
  dove(500, 400, 1.0), dove(1100, 440, 0.9, IVORY, true), child('safa', { x: 640, y: 1010, s: 0.8 }), child('zayn', { x: 960, y: 1010, s: 0.8, flip: true }),
  firefly(1300, 720, 1.2), vignette(0.16),
]));

add('muhammad_thawr_cave', () => scene([
  skyRect(SKY.violetDusk), stars(7, 40, 0, W, 0, 400), crescent(1200, 220, 60),
  mountains('#4A3560', 720, [[0, 720], [500, 560], [1000, 640], [1600, 560]], 0.8), ground('#2C2347', 900),
  S.cave(800, 985, 1.0, '#2C2347', '#0A0C16', null), S.spiderWeb(700, 800, 120, IVORY, 0.8), S.nest(940, 850, 1.1), dove(1000, 780, 0.8),
  firefly(400, 760, 1.3), vignette(0.2),
]));

add('muhammad_madinah_welcome', () => scene([
  skyRect(SKY.dayClear), sun(1240, 240, 70, CREAM, '#E8C089'), hills('#7C9F6E', 760, 40),
  city(900, WALL_DEEP, null, 23, 0.8), dome(800, 760, 90, LEAF), ground('#6E4629', 900),
  palm(200, 900, 1.3, GREEN_DEEP), palm(1420, 900, 1.2, GREEN_DEEP),
  hangLine(500, 520, 0.8), lantern(500, 520, 0.8), hangLine(1100, 500, 0.8), lantern(1100, 500, 0.8),
  child('amina', { x: 640, y: 1010, s: 0.8, arms: 'up' }), child('zayn', { x: 960, y: 1010, s: 0.8, arms: 'up', flip: true }),
  dove(800, 600, 0.9), firefly(1300, 700, 1.2), vignette(0.14),
]));

add('muhammad_return_makkah', () => scene([
  skyRect(SKY.dayClear), sun(300, 260, 70, CREAM, '#E8C089'), lightRays(800, 200, 8, 800, 1.2, CREAM, 0.1),
  mountains('#B0743B', 760, [[0, 760], [400, 620], [800, 700], [1200, 580], [1600, 700]], 0.6),
  city(880, WALL_DEEP, null, 15, 0.8), ground(STONE_LIGHT, 880), glow(800, 820, 380, CREAM, 0.3), kaaba(800, 985, 0.85),
  dove(500, 560, 0.9), dove(1100, 600, 0.8, IVORY, true), firefly(1280, 780, 1.2), vignette(0.14),
]));

add('muhammad_mercy_doves', () => scene([
  skyRect(SKY.dawn), sun(800, 400, 100, CREAM, '#E8B36A', 12), city(880, '#8A5348', null, 15, 0.8), ground('#6E4629', 880),
  dove(400, 420, 1.1), dove(700, 320, 0.9), dove(1000, 380, 1.0, IVORY, true), dove(1250, 480, 0.9, IVORY, true), dove(600, 600, 0.8),
  firefly(1100, 740, 1.2), vignette(0.16),
]));

add('muhammad_lights_world', () => scene([
  skyRect(SKY.night), stars(37, 120, 0, W, 0, 600), crescent(1200, 220, 70),
  hills('#1A1F33', 760, 60), hills('#121423', 860, 40), ground('#0E1120', 940),
  city(940, '#0E1120', GOLD, 41, 0.6), mosque(800, 940, 0.55, '#1A1F33'),
  hangLine(300, 520, 0.7), lantern(300, 520, 0.7), hangLine(1300, 560, 0.7), lantern(1300, 560, 0.7), hangLine(600, 440, 0.6), lantern(600, 440, 0.6),
  firefly(1000, 720, 1.3), vignette(0.22),
]));

// ================================================================== Adab ==
add('sharing_lunchbox', () => scene([
  skyRect(SKY.dayClear), sun(1240, 240, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 720, 40), ground(LEAF, 820),
  tree(260, 820, 1.2), S.bench(800, 985, 1.0), S.lunchbox(800, 835, 0.9), S.plateOfDates(800, 700, 0.55, 2),
  child('zayn', { x: 480, y: 1010, s: 0.85 }), child('amina', { x: 1120, y: 1010, s: 0.85, flip: true }),
  firefly(1000, 620, 1.2), vignette(0.14),
]));

add('sharing_plate', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), floorBand(940),
  S.plateOfDates(800, 900, 1.3, 2), child('zayn', { x: 420, y: 1010, s: 0.9, arms: 'out' }), child('amina', { x: 1180, y: 1010, s: 0.9, arms: 'out', flip: true }),
  sparkle(800, 720, 14), firefly(1000, 640, 1.2), vignette(0.16),
]));

add('truth_spilled_cup', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), table(760), S.puddle(700, 800, 260, 60), S.cup(560, 790, 1.0, '#4A5D8A', true),
  child('safa', { x: 1100, y: 1010, s: 0.9, arms: 'down' }), firefly(300, 640, 1.2), vignette(0.16),
]));

add('truth_clean_table', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), lightRays(1240, 320, 5, 700, 0.9, CREAM, 0.12), table(760),
  S.cup(700, 760, 0.9, '#4A5D8A', false), glass(900, 760, 0.9), child('safa', { x: 400, y: 1010, s: 0.9, arms: 'up' }),
  sparkle(760, 640, 12), firefly(1000, 640, 1.2), vignette(0.14),
]));

add('helping_door_bags', () => scene([
  room(true), S.doorway(1100, 985, 1.0, WALL, WOOD_DARK, true), floorBand(985, '#6E4629'),
  S.bag(720, 985, 1.0, SAND_LIGHT), S.bag(560, 985, 0.85, WALL), S.fruit(700, 800, 1.3, '#B8683C'), S.fruit(760, 812, 1.2, GOLD), S.fruit(730, 780, 1.1, '#B8683C'),
  child('zayn', { x: 340, y: 1010, s: 0.9, arms: 'out' }), firefly(900, 640, 1.2), vignette(0.16),
]));

add('helping_water', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), floorBand(940), S.chair(1080, 940, 1.0), glass(760, 900, 1.1),
  child('zayn', { x: 480, y: 1010, s: 0.9, arms: 'out' }), sparkle(760, 740, 12), firefly(1000, 640, 1.2), vignette(0.16),
]));

add('kindness_kitten_wall', () => scene([
  skyRect(SKY.day), sun(1240, 240, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 700, 40),
  `<rect x="0" y="720" width="${W}" height="260" fill="${WALL}"/><rect x="0" y="720" width="${W}" height="24" fill="${WALL_DEEP}"/>`,
  ground(LEAF, 980), grass(17, 1010, 30, GREEN_DEEP, 1.1), S.kitten(760, 985, 1.2, '#8A7F70', false), S.bowl(1020, 985, 1.0, false),
  child('safa', { x: 380, y: 1010, s: 0.9 }), firefly(1200, 640, 1.2), vignette(0.14),
]));

add('kindness_kitten_drinks', () => scene([
  skyRect(SKY.day), sun(1240, 240, 70, CREAM, '#E8C089'), hills(LEAF_LIGHT, 700, 40),
  `<rect x="0" y="720" width="${W}" height="260" fill="${WALL}"/><rect x="0" y="720" width="${W}" height="24" fill="${WALL_DEEP}"/>`,
  ground(LEAF, 980), grass(18, 1010, 30, GREEN_DEEP, 1.1), S.bowl(860, 985, 1.0, true), S.kitten(700, 985, 1.2, '#8A7F70', true, true),
  child('safa', { x: 1160, y: 1010, s: 0.9, pose: 'sit' }), sparkle(860, 820, 12), firefly(400, 640, 1.2), vignette(0.14),
]));

add('masjid_shoes', () => scene([
  skyRect(SKY.dayClear), sun(300, 240, 70, CREAM, '#E8C089'), mosque(800, 700, 0.9, STONE_LIGHT), ground(STONE_LIGHT, 700),
  S.doorway(800, 985, 1.0, STONE_LIGHT, '#8A5A36', true), floorBand(985, STONE),
  S.shoes(420, 985, 1.0, INK_SOFT), S.shoes(560, 985, 0.7, '#8A4A6A'), S.shoes(1160, 985, 1.0, '#4E8A6C'),
  child('zayn', { x: 1040, y: 1010, s: 0.8 }), firefly(1300, 640, 1.2), vignette(0.14),
]));

add('masjid_inside', () => scene([
  room(false), archWindow(300, 120, 240, 340, false), archWindow(1300, 120, 240, 340, false), S.mihrab(800, 900, 0.7),
  floorBand(900, '#8A4A28'), prayerMat(500, 920, 300, 80), prayerMat(1100, 920, 300, 80, '#4E5A78', DEEPGOLD, '#3E4A70'),
  S.quranStand(800, 985, 0.9), hangLine(560, 440, 0.7), lantern(560, 440, 0.7), hangLine(1040, 440, 0.7), lantern(1040, 440, 0.7),
  child('zayn', { x: 400, y: 1010, s: 0.8, pose: 'sit' }), firefly(1200, 700, 1.2), vignette(0.18),
]));

add('ramadan_gold_sky', () => scene([
  skyRect(SKY.amber), sun(1100, 480, 110, CREAM, '#E8B36A', 12), city(900, '#8A5348', GOLD, 25, 0.9), mosque(500, 900, 0.5, '#6E4038'), ground('#6E4629', 900),
  hangLine(1300, 520, 0.8), lantern(1300, 520, 0.8), dove(400, 440, 0.9), firefly(800, 740, 1.2), vignette(0.16),
]));

add('ramadan_tray', () => scene([
  room(true), S.doorway(1120, 985, 1.0, WALL, WOOD_DARK, true), floorBand(985, '#6E4629'), hangLine(300, 420, 0.8), lantern(300, 420, 0.8),
  S.tray(640, 800, 1.0), glass(560, 780, 0.7), glass(740, 780, 0.7),
  child('safa', { x: 420, y: 1010, s: 0.85 }), child('zayn', { x: 860, y: 1010, s: 0.85, flip: true }), firefly(1000, 640, 1.2), vignette(0.16),
]));

add('eid_kitchen', () => scene([
  room(true), S.windowSill(1200, 400, 340, 360, '#7FA6C0'), sun(1200, 380, 60, CREAM, '#E8C089', 10), table(800),
  S.sweets(800, 800, 1.1), bowlOfDates(1080, 800, 0.9), glass(560, 800, 0.9), hangLine(300, 420, 0.8), lantern(300, 420, 0.8),
  sparkle(1000, 660, 12), firefly(400, 640, 1.2), vignette(0.14),
]));

add('eid_window_clothes', () => scene([
  room(true), S.windowSill(600, 460, 380, 400, '#7FA6C0'), sun(600, 420, 70, CREAM, '#E8C089', 12), floorBand(940),
  S.hangingClothes(1180, 300, 0.9), child('zayn', { x: 700, y: 1010, s: 0.9, arms: 'up' }), sparkle(1100, 260, 14), firefly(360, 700, 1.2), vignette(0.14),
]));

add('patience_soil_cup', () => scene([
  room(true), S.windowSill(800, 480, 520, 420, '#7FA6C0'), cloud(700, 420, 100, 30, 0.6), cloud(920, 360, 80, 26, 0.5),
  floorBand(940), S.soilCup(800, 706, 0.85, 0), child('amina', { x: 440, y: 1010, s: 0.9 }), firefly(1200, 640, 1.2), vignette(0.14),
]));

add('patience_night_window', () => scene([
  room(false), S.windowSill(800, 480, 520, 420, '#1A1F33'), stars(41, 30, 560, 1040, 290, 660, IVORY, 1.6), crescent(900, 380, 40),
  floorBand(940, '#54382A'), S.soilCup(800, 706, 0.85, 0), hangLine(300, 420, 0.8), lantern(300, 420, 0.8), firefly(1200, 700, 1.3), vignette(0.2),
]));

add('patience_sprout', () => scene([
  room(true), S.windowSill(800, 480, 520, 420, '#7FA6C0'), sun(900, 380, 60, CREAM, '#E8C089', 10), floorBand(940),
  S.soilCup(800, 706, 0.85, 1), child('amina', { x: 440, y: 1010, s: 0.9, arms: 'up' }), sparkle(860, 520, 14), firefly(1200, 640, 1.2), vignette(0.14),
]));

add('sorry_fallen_blocks', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), floorBand(985, '#8A4A28'), S.blocks(800, 985, 0.9, true),
  child('zayn', { x: 420, y: 1010, s: 0.9 }), child('safa', { x: 1200, y: 1010, s: 0.85, pose: 'sit', flip: true }), firefly(1000, 640, 1.2), vignette(0.16),
]));

add('sorry_rebuilt', () => scene([
  room(true), archWindow(1240, 120, 240, 340, false), floorBand(985, '#8A4A28'), S.blocks(800, 985, 0.9, false),
  child('zayn', { x: 480, y: 1010, s: 0.9, arms: 'out' }), child('safa', { x: 1120, y: 1010, s: 0.85, arms: 'out', flip: true }),
  sparkle(800, 340, 16), firefly(1000, 640, 1.2), vignette(0.16),
]));

// ------------------------------------------------------------------ write --
mkdirSync(SVG_OUT, { recursive: true });
mkdirSync(OUT, { recursive: true });
const report = [];
for (const [name, fn] of SCENES) {
  if (ONLY.length && !ONLY.some((p) => name.startsWith(p))) continue;
  K.setCanvas(W, H);
  const svgPath = join(SVG_OUT, `${name}.svg`);
  writeFileSync(svgPath, fn());
  const png = join(SVG_OUT, `${name}.png`);
  let r = spawnSync('rsvg-convert', ['-w', String(W), '-h', String(H), '-o', png, svgPath]);
  if (r.status !== 0) throw new Error(`rsvg-convert failed for ${name}: ${r.stderr}`);
  const webp = join(OUT, `${name}.webp`);
  r = spawnSync('cwebp', ['-quiet', '-q', '80', png, '-o', webp]);
  if (r.status !== 0) throw new Error(`cwebp failed for ${name}: ${r.stderr}`);
  unlinkSync(png);
  report.push(`${name}.webp ${(statSync(webp).size / 1024).toFixed(1)} KB`);
}
console.log(report.join('\n'));
console.log(`${report.length} images`);
