// Path of Nur — salah posture art (8 scenes, 16:9).
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
// the figure facing left (toward the mihrab). Limbs are round-capped
// strokes, the robe a single filled path, the head a disc — no face.
const limb = (pts, w = 34) =>
  `<path d="M ${pts.map(([x, y]) => `${x} ${y}`).join(' L ')}" stroke="${INK}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" fill="none"/>`;
const head = (cx, cy, r = 46) => `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${INK}"/>`;
const foot = (cx, cy, rx = 52, ry = 13) => `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="${INK}"/>`;
const shadow = (cx, cy, rx) => `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="16" fill="${GROUND}" opacity="0.35"/>`;

const standingRobe =
  `<path d="M -78 -410 Q -108 -240 -116 -8 L 118 -8 Q 110 -240 80 -410 Q 0 -446 -78 -410 Z" fill="${INK}"/>`;

const POSES = {
  // Standing, hands folded at the chest: in silhouette the folded forearms
  // are only a soft swell on the front of the robe.
  qiyam: () =>
    shadow(0, 2, 150) + foot(-42, -6) + foot(34, -2, 48) + standingRobe +
    `<ellipse cx="-88" cy="-298" rx="34" ry="30" fill="${INK}"/>` +
    `<path d="M -78 -318 Q -120 -300 -80 -276" stroke="${INK}" stroke-width="22" stroke-linecap="round" fill="none"/>` +
    head(-8, -480),
  // Standing after ruku, the near arm hanging along the front of the robe.
  qawmah: () =>
    shadow(0, 2, 150) + foot(-42, -6) + foot(34, -2, 48) + standingRobe +
    limb([[-70, -392], [-104, -300], [-108, -206]], 34) +
    head(-8, -480),
  // Bowing: back level, hands on the knees.
  ruku: () =>
    shadow(-80, 2, 220) + foot(-42, -6) + foot(34, -2, 48) +
    `<path d="M -84 -330 Q -108 -190 -112 -8 L 112 -8 Q 104 -190 82 -330 Z" fill="${INK}"/>` +
    `<path d="M -340 -350 Q -360 -300 -300 -276 L 70 -284 Q 110 -330 60 -356 Z" fill="${INK}"/>` +
    limb([[-300, -316], [-190, -226], [-114, -176]]) +
    limb([[-240, -312], [-160, -220], [-84, -166]], 28) +
    head(-386, -300),
  // Prostrating: forehead on the mat, hands beside the head, feet behind.
  sujud: () =>
    shadow(-40, 2, 330) +
    // thighs and folded shins: a mound with the raised hips at its crest
    `<path d="M -70 -262 Q 120 -300 196 -150 Q 224 -50 160 -8 L -60 -8 Q -84 -120 -70 -262 Z" fill="${INK}"/>` +
    foot(238, -12, 44, 14) + foot(268, -8, 40, 12) +
    // the back: a full-width slope from the hips down to the shoulders
    `<path d="M -40 -290 Q 40 -300 46 -230 L -220 -84 Q -292 -52 -318 -122 Z" fill="${INK}"/>` +
    limb([[-270, -110], [-340, -70], [-412, -22]]) +
    limb([[-236, -92], [-296, -54], [-364, -16]], 28) +
    head(-338, -48),
  // Sitting between the two sujud, hands on the thighs.
  jalsah: () => sitting(0),
  // Final sitting for tashahhud: the same seat, index finger raised.
  tashahhud: () => sitting(0) +
    `<path d="M -128 -132 L -168 -150" stroke="${INK}" stroke-width="12" stroke-linecap="round"/>`,
  // Salam: the head turns to the right, then to the left.
  salamRight: () => sitting(28),
  salamLeft: () => sitting(-28),
};

function sitting(turn) {
  return shadow(0, 2, 210) +
    // heels tucked under, knees forward on the mat
    `<path d="M -180 -8 Q -176 -70 -128 -84 L 60 -186 Q 150 -212 184 -118 Q 202 -40 166 -8 Z" fill="${INK}"/>` +
    foot(176, -10, 42, 13) +
    `<path d="M -56 -338 Q -78 -250 -70 -176 L 108 -176 Q 96 -250 64 -338 Q 0 -364 -56 -338 Z" fill="${INK}"/>` +
    limb([[-40, -322], [-70, -230], [-124, -128]]) +
    limb([[26, -318], [10, -226], [-40, -130]], 28) +
    `<g transform="rotate(${turn} -6 -350)">${head(-12, -408)}<path d="M -20 -364 L -2 -344" stroke="${INK}" stroke-width="26" stroke-linecap="round"/></g>`;
}

// ------------------------------------------------------------- the scene --
function scene(pose) {
  const s = skyV(SKY_DAWN);
  const halo = glow2(900, 520, 420, CREAM, 0.38);
  const figure = `<g transform="translate(900 776)">${POSES[pose]()}</g>`;
  return svgDoc(
    `<defs>${s.def}${halo.def}</defs>${s.rect}` +
    stars(7, 14, 60, W - 60, 40, 300, CREAM) +
    // distant dunes, then the wall the mihrab sits in
    `<path d="M0 640 Q ${W * 0.28} 560 ${W * 0.6} 630 T ${W} 600 V ${H} H 0 Z" fill="#6E4629" opacity="0.55"/>` +
    `<rect x="0" y="700" width="${W}" height="${H - 700}" fill="${GROUND}"/>` +
    `<path d="M0 700 Q ${W * 0.35} 680 ${W * 0.7} 704 T ${W} 696 V ${H} H 0 Z" fill="#3E2619"/>` +
    mihrab(330, 740, 300, 470) +
    halo.el +
    mat(900, 700, 720, 110) +
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
