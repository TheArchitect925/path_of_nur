// Path of Nur — salah posture art (9 scenes, 16:9).
// Same visual language as learn_art v2 / kids_art: gradient sky anchored to
// the app's Dawn Amber recipe, calm silhouettes, warm ivory light, gold
// accents. The praying figure is a faceless robed silhouette — the one
// figure the app draws, because a posture cannot be shown without one — and
// it faces the mihrab on the left, the way the trainer's vector glyph does.
//
// Usage (from the repo root):
//   node tooling/art_src/salah_art/generate_salah_art.mjs          # svg + webp
//   node tooling/art_src/salah_art/generate_salah_art.mjs --preview # + png previews
//
// Output: assets/images/salah_art/posture_<name>.webp (1600x900, q78).
import { mkdirSync, writeFileSync, statSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const ASSET_OUT = join(ROOT, 'assets', 'images', 'salah_art');
const PREVIEW = process.argv.includes('--preview');

const W = 1600, H = 900;
const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';
const INK = '#3A2A1E';          // the silhouette
const GROUND = '#4A2F22';
const MAT = '#8A4A28', MAT_EDGE = '#B98A3E', MAT_INNER = '#7A3E22';
const ARCH = '#1E4B3A', NICHE = '#16382C', ARCH_LIGHT = '#2E5D48';
const SKY_DAWN = [[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']];

let gradN = 0;
const svgDoc = (inner) =>
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}">${inner}</svg>`;

function skyV(stops) {
  const id = `sky${gradN++}`;
  const s = stops.map(([o, c]) => `<stop offset="${o}" stop-color="${c}"/>`).join('');
  return {
    def: `<linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1">${s}</linearGradient>`,
    rect: `<rect width="${W}" height="${H}" fill="url(#${id})"/>`,
  };
}

function glow2(cx, cy, r, color, a = 0.5) {
  const id = `gl${gradN++}`;
  return {
    def: `<radialGradient id="${id}"><stop offset="0" stop-color="${color}" stop-opacity="${a}"/><stop offset="0.55" stop-color="${color}" stop-opacity="${a * 0.4}"/><stop offset="1" stop-color="${color}" stop-opacity="0"/></radialGradient>`,
    el: `<circle cx="${cx}" cy="${cy}" r="${r}" fill="url(#${id})"/>`,
  };
}

function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

function stars(seed, n, x0, x1, y0, y1, color = IVORY) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0);
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${(1.6 + rnd() * 2.4).toFixed(1)}" fill="${color}" opacity="${(0.35 + rnd() * 0.5).toFixed(2)}"/>`;
  }
  return out;
}

function lantern(cx, cy, s, body = GOLD, glass = CREAM) {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<rect x="-34" y="-96" width="68" height="14" rx="6" fill="${body}"/>` +
    `<path d="M -40 -82 L 40 -82 L 46 20 Q 0 40 -46 20 Z" fill="${body}"/>` +
    `<path d="M -28 -70 L 28 -70 L 32 12 Q 0 26 -32 12 Z" fill="${glass}" opacity="0.92"/>` +
    `<circle cx="0" cy="-30" r="14" fill="${GOLD}" opacity="0.9"/>` +
    `<rect x="-14" y="30" width="28" height="12" rx="5" fill="${body}"/>` +
    `</g>`;
}
const hangLine = (cx, yTo, color = GOLD, yFrom = 0) =>
  `<path d="M ${cx} ${yFrom} V ${yTo}" stroke="${color}" stroke-width="6" stroke-linecap="round"/>`;

// The mihrab niche the figure faces: a pointed arch with a lit interior.
function mihrab(cx, baseY, w, h) {
  const x0 = cx - w / 2, x1 = cx + w / 2, top = baseY - h;
  const outer = `M ${x0 - 40} ${baseY} V ${top + w * 0.55} Q ${x0 - 40} ${top - 30} ${cx} ${top - 110} Q ${x1 + 40} ${top - 30} ${x1 + 40} ${top + w * 0.55} V ${baseY} Z`;
  const inner = `M ${x0} ${baseY} V ${top + w * 0.55} Q ${x0} ${top + 20} ${cx} ${top - 50} Q ${x1} ${top + 20} ${x1} ${top + w * 0.55} V ${baseY} Z`;
  const g = glow2(cx, top + h * 0.45, w * 0.7, CREAM, 0.42);
  return `<defs>${g.def}</defs>` +
    `<path d="${outer}" fill="${ARCH}"/>` +
    `<path d="${inner}" fill="${NICHE}"/>` +
    g.el +
    `<path d="${inner}" fill="none" stroke="${DEEPGOLD}" stroke-width="10" opacity="0.7"/>` +
    hangLine(cx, top + 150, GOLD, top - 40) + lantern(cx, top + 150, 0.9);
}

// Prayer mat seen slightly from above: a soft parallelogram with a gold
// border and a woven inner field.
function mat(cx, y, w, h) {
  const skew = 90;
  const outer = `M ${cx - w / 2 + skew} ${y} L ${cx + w / 2 + skew} ${y} L ${cx + w / 2 - skew} ${y + h} L ${cx - w / 2 - skew} ${y + h} Z`;
  const inner = `M ${cx - w / 2 + skew + 34} ${y + 18} L ${cx + w / 2 + skew - 34} ${y + 18} L ${cx + w / 2 - skew - 34} ${y + h - 18} L ${cx - w / 2 - skew + 34} ${y + h - 18} Z`;
  return `<path d="${outer}" fill="${MAT}"/>` +
    `<path d="${outer}" fill="none" stroke="${MAT_EDGE}" stroke-width="8" opacity="0.85"/>` +
    `<path d="${inner}" fill="${MAT_INNER}"/>` +
    `<path d="${inner}" fill="none" stroke="${MAT_EDGE}" stroke-width="4" opacity="0.5"/>`;
}

// ------------------------------------------------------------ the figure --
// All poses are drawn in a local frame: x=0 under the hips, y=0 on the mat,
// the figure facing left (toward the mihrab). What makes a posture legible
// without a face: ink outlines around every shape, a coloured kurta over
// ivory trousers so the legs read as legs, mitten hands placed where the
// posture puts them, and a cap and beard that turn with the head.
const LINE = '#3A2A1E';
const KURTA = '#4E8A6C', KURTA_SHADE = '#3E7358';
const TROUSER = '#F2E6C8', TROUSER_SHADE = '#DCCBA4';
const SKIN = '#B57A52', BEARD = '#4A2F22';
const CAP = '#F5EFDD', CAP_BAND = '#B98A3E';

const shape = (d, fill) =>
  `<path d="${d}" fill="${fill}" stroke="${LINE}" stroke-width="5" stroke-linejoin="round"/>`;
const limb = (pts, w, fill) => {
  const d = `M ${pts.map(([x, y]) => `${x} ${y}`).join(' L ')}`;
  return `<path d="${d}" stroke="${LINE}" stroke-width="${w + 9}" stroke-linecap="round" stroke-linejoin="round" fill="none"/>` +
    `<path d="${d}" stroke="${fill}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" fill="none"/>`;
};
const sleeve = (pts, w = 40) => limb(pts, w, KURTA_SHADE);
const trouserLeg = (pts, w = 52) => limb(pts, w, TROUSER);
// A mitten: an ellipse with a thumb bump, rotated to the wrist's angle.
const hand = (cx, cy, angle = 0, s = 1) =>
  `<g transform="translate(${cx} ${cy}) rotate(${angle}) scale(${s})">` +
  `<ellipse cx="0" cy="0" rx="26" ry="19" fill="${SKIN}" stroke="${LINE}" stroke-width="5"/>` +
  `<circle cx="-10" cy="-16" r="9" fill="${SKIN}" stroke="${LINE}" stroke-width="4"/></g>`;
const foot = (cx, cy, angle = 0) =>
  `<ellipse cx="${cx}" cy="${cy}" rx="44" ry="14" transform="rotate(${angle} ${cx} ${cy})" fill="${SKIN}" stroke="${LINE}" stroke-width="5"/>`;
const shadow = (cx, cy, rx) => `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="16" fill="${GROUND}" opacity="0.35"/>`;

// The head, facing left: a blank face, a beard on the front-underside, a
// cap with a gold band. `tilt` rotates everything, so a bowed head shows
// the crown of the cap and a prostrating head the beard against the mat.
function head(cx, cy, tilt = 0, r = 46) {
  return `<g transform="rotate(${tilt} ${cx} ${cy})">` +
    `<path d="M ${cx - r + 6} ${cy + 14} Q ${cx - r - 10} ${cy + 60} ${cx - 8} ${cy + 62} Q ${cx + 30} ${cy + 56} ${cx + 34} ${cy + 26} Z" fill="${BEARD}" stroke="${LINE}" stroke-width="5" stroke-linejoin="round"/>` +
    `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${SKIN}" stroke="${LINE}" stroke-width="5"/>` +
    `<path d="M ${cx - r} ${cy - 4} A ${r} ${r} 0 0 1 ${cx + r} ${cy - 4} Z" fill="${CAP}" stroke="${LINE}" stroke-width="5" stroke-linejoin="round"/>` +
    `<path d="M ${cx - r + 2} ${cy - 4} L ${cx + r - 2} ${cy - 4}" stroke="${CAP_BAND}" stroke-width="8" stroke-linecap="round"/>` +
    `</g>`;
}

// A gold cue for the salam: the head turns this way.
function turnCue(cx, cy, dir) {
  const x1 = cx + dir * 120, y1 = cy + 40;
  const arrow = dir > 0
    ? `M ${x1 - 16} ${y1 - 22} L ${x1 + 4} ${y1} L ${x1 - 22} ${y1 + 8} Z`
    : `M ${x1 + 16} ${y1 - 22} L ${x1 - 4} ${y1} L ${x1 + 22} ${y1 + 8} Z`;
  return `<path d="M ${cx} ${cy - 78} Q ${cx + dir * 110} ${cy - 74} ${x1} ${y1}" stroke="${GOLD}" stroke-width="7" fill="none" stroke-linecap="round" opacity="0.95"/>` +
    `<path d="${arrow}" fill="${GOLD}" opacity="0.95"/>`;
}

// Standing: trousers from the hem down, a kurta to just below the knee.
const standingLegs = () =>
  trouserLeg([[30, -220], [34, -30]], 54) + foot(46, -6) +
  trouserLeg([[-44, -220], [-52, -30]], 56) + foot(-64, -8);
const standingKurta = () =>
  shape('M -80 -420 Q -106 -300 -110 -196 L 112 -196 Q 108 -300 82 -420 Q 0 -452 -80 -420 Z', KURTA);

const POSES = {
  // The opening takbir: hands raised beside the ears, palms forward.
  takbir: () =>
    shadow(0, 2, 150) + standingLegs() + standingKurta() +
    hand(52, -456, -80, 0.9) +
    sleeve([[-24, -400], [-84, -372], [-96, -440]]) + hand(-98, -472, -80) +
    head(-10, -488),
  // Standing, forearms folded across the chest, the far hand under the near.
  qiyam: () =>
    shadow(0, 2, 150) + standingLegs() + standingKurta() +
    sleeve([[48, -318], [-66, -312]], 36) + hand(-72, -306, 10, 0.9) +
    sleeve([[-20, -404], [-40, -330], [-124, -326]]) + hand(-134, -322, -10) +
    head(-10, -488),
  // Standing after ruku, arms at the sides.
  qawmah: () =>
    shadow(0, 2, 150) + standingLegs() + standingKurta() +
    hand(78, -224, 80, 0.9) +
    sleeve([[-36, -404], [-84, -320], [-92, -226]]) + hand(-96, -212, 80) +
    head(-10, -488),
  // Bowing: back level, both hands gripping the knees, the cap facing down.
  ruku: () =>
    shadow(-80, 2, 220) +
    trouserLeg([[30, -220], [34, -30]], 54) + foot(46, -6) +
    trouserLeg([[-44, -220], [-52, -30]], 56) + foot(-64, -8) +
    shape('M -84 -330 Q -108 -250 -110 -196 L 112 -196 Q 106 -250 84 -330 Z', KURTA) +
    shape('M -350 -352 Q -374 -300 -320 -276 L 80 -286 Q 122 -320 70 -360 Z', KURTA) +
    sleeve([[-262, -314], [-166, -232], [-64, -180]], 34) + hand(-58, -176, 20, 0.9) +
    sleeve([[-300, -318], [-200, -240], [-96, -186]]) + hand(-96, -180, 20) +
    head(-392, -300, -75),
  // Prostrating: forehead on the mat, palms flat beside the head, shins on
  // the mat and toes upright behind.
  sujud: () =>
    shadow(-40, 2, 330) +
    trouserLeg([[0, -60], [232, -34]], 60) +
    `<ellipse cx="248" cy="-40" rx="18" ry="30" fill="${SKIN}" stroke="${LINE}" stroke-width="5"/>` +
    shape('M -70 -262 Q 120 -300 196 -150 Q 214 -90 160 -46 L -40 -46 Q -84 -160 -70 -262 Z', KURTA) +
    shape('M -40 -290 Q 40 -300 46 -230 L -220 -84 Q -292 -52 -318 -122 Z', KURTA) +
    sleeve([[-236, -92], [-300, -56], [-364, -20]], 34) + hand(-378, -14, 0, 0.9) +
    sleeve([[-270, -110], [-340, -72], [-408, -26]]) + hand(-426, -14, 0) +
    head(-338, -48, -100),
  // Sitting between the two sujud, hands resting on the thighs.
  jalsah: () => sitting(),
  // Final sitting for tashahhud, the index finger raised.
  tashahhud: () => sitting() +
    `<path d="M -126 -132 L -172 -150" stroke="${LINE}" stroke-width="20" stroke-linecap="round"/>` +
    `<path d="M -126 -132 L -172 -150" stroke="${SKIN}" stroke-width="11" stroke-linecap="round"/>`,
  // Salam: the head turns to the right, then to the left.
  salamRight: () => sitting(18) + turnCue(-12, -410, 1),
  salamLeft: () => sitting(-18) + turnCue(-12, -410, -1),
};

function sitting(turn = 0) {
  return shadow(0, 2, 210) +
    // shins along the mat, feet tucked behind, thighs up to the lap
    trouserLeg([[-120, -70], [150, -40]], 58) + foot(176, -18, -10) +
    trouserLeg([[-140, -80], [40, -170]], 60) +
    shape('M -56 -338 Q -78 -250 -70 -176 L 108 -176 Q 96 -250 64 -338 Q 0 -364 -56 -338 Z', KURTA) +
    shape('M -70 -176 Q -110 -150 -130 -96 L 60 -100 Q 100 -140 108 -176 Z', KURTA) +
    sleeve([[26, -318], [10, -226], [-40, -132]], 34) + hand(-46, -126, 20, 0.9) +
    sleeve([[-40, -322], [-70, -230], [-124, -130]]) + hand(-128, -124, 20) +
    `<g transform="rotate(${turn} -6 -352)">` +
    `<path d="M -22 -366 L -2 -344" stroke="${LINE}" stroke-width="32" stroke-linecap="round"/>` +
    `<path d="M -22 -366 L -2 -344" stroke="${SKIN}" stroke-width="24" stroke-linecap="round"/>` +
    head(-12, -410) +
    `</g>`;
}

// ------------------------------------------------------------- the scene --
function scene(pose) {
  const s = skyV(SKY_DAWN);
  const halo = glow2(880, 500, 440, CREAM, 0.42);
  const figure = `<g transform="translate(880 778) scale(1.08)">${POSES[pose]()}</g>`;
  return svgDoc(
    `<defs>${s.def}${halo.def}</defs>${s.rect}` +
    stars(7, 14, 60, W - 60, 40, 300, CREAM) +
    // distant dunes, then the wall the mihrab sits in
    `<path d="M0 640 Q ${W * 0.28} 560 ${W * 0.6} 630 T ${W} 600 V ${H} H 0 Z" fill="#6E4629" opacity="0.55"/>` +
    `<rect x="0" y="700" width="${W}" height="${H - 700}" fill="${GROUND}"/>` +
    `<path d="M0 700 Q ${W * 0.35} 680 ${W * 0.7} 704 T ${W} 696 V ${H} H 0 Z" fill="#3E2619"/>` +
    mihrab(300, 740, 260, 430) +
    halo.el +
    mat(880, 700, 780, 110) +
    figure);
}

// ------------------------------------------------------------------ write --
mkdirSync(SVG_OUT, { recursive: true });
mkdirSync(ASSET_OUT, { recursive: true });
const report = [];
for (const pose of Object.keys(POSES)) {
  const name = `posture_${pose.replace(/([A-Z])/g, '_$1').toLowerCase()}`;
  const svgPath = join(SVG_OUT, `${name}.svg`);
  writeFileSync(svgPath, scene(pose));
  const png = join(SVG_OUT, `${name}.png`);
  let r = spawnSync('rsvg-convert', ['-w', String(W), '-h', String(H), '-o', png, svgPath]);
  if (r.status !== 0) throw new Error(`rsvg-convert failed for ${name}: ${r.stderr}`);
  const webp = join(ASSET_OUT, `${name}.webp`);
  r = spawnSync('cwebp', ['-quiet', '-q', '78', png, '-o', webp]);
  if (r.status !== 0) throw new Error(`cwebp failed for ${name}: ${r.stderr}`);
  if (PREVIEW) {
    spawnSync('rsvg-convert', ['-w', '800', '-h', '450', '-o', join(SVG_OUT, `preview_${name}.png`), svgPath]);
  }
  report.push(`${name}.webp ${(statSync(webp).size / 1024).toFixed(1)} KB`);
}
console.log(report.join('\n'));
