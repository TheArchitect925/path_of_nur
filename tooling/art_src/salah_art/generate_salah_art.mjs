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
// the figure facing left (toward the mihrab). Two tones make the posture
// legible without a face: an ivory thobe with shaded sleeves, and warm-brown
// hands, feet and head. A kufi tilts with the head, so where the head points
// is always visible; hands sit where the posture puts them.
const ROBE = '#F2E6C8', ROBE_SHADE = '#DCCBA4', ROBE_LINE = '#B9A67E';
const SKIN = '#8A5A3C', KUFI = '#2E5D48', KUFI_LINE = '#1E4B3A';

const robe = (d) =>
  `<path d="${d}" fill="${ROBE}" stroke="${ROBE_LINE}" stroke-width="4" stroke-linejoin="round"/>`;
const sleeve = (pts, w = 40) => {
  const d = `M ${pts.map(([x, y]) => `${x} ${y}`).join(' L ')}`;
  return `<path d="${d}" stroke="${ROBE_LINE}" stroke-width="${w + 6}" stroke-linecap="round" stroke-linejoin="round" fill="none"/>` +
    `<path d="${d}" stroke="${ROBE_SHADE}" stroke-width="${w}" stroke-linecap="round" stroke-linejoin="round" fill="none"/>`;
};
const hand = (cx, cy, r = 19) => `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${SKIN}"/>`;
const flatHand = (cx, cy) => `<ellipse cx="${cx}" cy="${cy}" rx="27" ry="12" fill="${SKIN}"/>`;
const foot = (cx, cy, rx = 42, ry = 12) => `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="${SKIN}"/>`;
const shadow = (cx, cy, rx) => `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="16" fill="${GROUND}" opacity="0.35"/>`;

// The head: a brown disc under a kufi. `tilt` rotates the cap so a bowed or
// prostrating head is unmistakable; the face stays blank.
function head(cx, cy, tilt = 0, r = 46) {
  return `<g transform="rotate(${tilt} ${cx} ${cy})">` +
    `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${SKIN}"/>` +
    `<path d="M ${cx - r} ${cy - 6} A ${r} ${r} 0 0 1 ${cx + r} ${cy - 6} Z" fill="${KUFI}"/>` +
    `<path d="M ${cx - r} ${cy - 6} L ${cx + r} ${cy - 6}" stroke="${KUFI_LINE}" stroke-width="5" stroke-linecap="round"/>` +
    `</g>`;
}

// A gold cue for the salam: the head turns this way.
function turnCue(cx, cy, dir) {
  const x1 = cx + dir * 110, y1 = cy + 44;
  const arrow = dir > 0
    ? `M ${x1 - 16} ${y1 - 22} L ${x1 + 4} ${y1} L ${x1 - 22} ${y1 + 8} Z`
    : `M ${x1 + 16} ${y1 - 22} L ${x1 - 4} ${y1} L ${x1 + 22} ${y1 + 8} Z`;
  return `<path d="M ${cx} ${cy - 70} Q ${cx + dir * 100} ${cy - 66} ${x1} ${y1}" stroke="${GOLD}" stroke-width="7" fill="none" stroke-linecap="round" opacity="0.95"/>` +
    `<path d="${arrow}" fill="${GOLD}" opacity="0.95"/>`;
}

const standingRobe = robe('M -80 -420 Q -110 -250 -118 -8 L 118 -8 Q 110 -250 82 -420 Q 0 -452 -80 -420 Z');

const POSES = {
  // Standing, forearms folded across the chest, both hands showing.
  qiyam: () =>
    shadow(0, 2, 150) + foot(-58, -8) + foot(40, -4, 34, 10) + standingRobe +
    // upper arm down the side, forearm level across the chest and out
    // past the robe's front, so the fold is unmistakable
    sleeve([[-20, -404], [-40, -330], [-134, -326]]) +
    hand(-138, -324) + hand(-104, -306, 15) +
    head(-10, -488),
  // Standing after ruku, the near arm hanging, the hand by the thigh.
  qawmah: () =>
    shadow(0, 2, 150) + foot(-58, -8) + foot(40, -4, 34, 10) + standingRobe +
    sleeve([[-40, -404], [-82, -312], [-92, -216]]) +
    hand(-94, -210) +
    head(-10, -488),
  // Bowing: back level, both hands on the knees, the kufi pointing down.
  ruku: () =>
    shadow(-80, 2, 220) + foot(-58, -8) + foot(40, -4, 34, 10) +
    robe('M -84 -330 Q -110 -190 -114 -8 L 114 -8 Q 106 -190 84 -330 Z') +
    robe('M -350 -352 Q -374 -300 -320 -276 L 80 -286 Q 122 -320 70 -360 Z') +
    // arms straight down from the shoulders, hands gripping the knees
    sleeve([[-300, -318], [-200, -240], [-100, -184]]) +
    sleeve([[-262, -314], [-166, -232], [-72, -178]], 34) +
    hand(-98, -182) + hand(-70, -176, 17) +
    head(-392, -300, -75),
  // Prostrating: forehead on the mat, palms flat beside the head, toes
  // upright behind.
  sujud: () =>
    shadow(-40, 2, 330) +
    robe('M -70 -262 Q 120 -300 196 -150 Q 224 -50 160 -8 L -60 -8 Q -84 -120 -70 -262 Z') +
    `<ellipse cx="236" cy="-24" rx="16" ry="26" fill="${SKIN}"/><ellipse cx="268" cy="-20" rx="14" ry="22" fill="${SKIN}"/>` +
    robe('M -40 -290 Q 40 -300 46 -230 L -220 -84 Q -292 -52 -318 -122 Z') +
    sleeve([[-270, -110], [-340, -72], [-408, -26]]) +
    sleeve([[-236, -92], [-300, -56], [-364, -20]], 34) +
    flatHand(-420, -14) + flatHand(-372, -12) +
    head(-338, -48, -100),
  // Sitting between the two sujud, hands resting on the thighs.
  jalsah: () => sitting(),
  // Final sitting for tashahhud, the index finger raised.
  tashahhud: () => sitting() +
    `<path d="M -126 -128 L -168 -150" stroke="${SKIN}" stroke-width="11" stroke-linecap="round"/>`,
  // Salam: the head turns to the right, then to the left.
  salamRight: () => sitting(18) + turnCue(-12, -410, 1),
  salamLeft: () => sitting(-18) + turnCue(-12, -410, -1),
};

function sitting(turn = 0) {
  return shadow(0, 2, 210) +
    robe('M -180 -8 Q -176 -70 -128 -84 L 60 -186 Q 150 -212 184 -118 Q 202 -40 166 -8 Z') +
    foot(178, -12, 40, 12) +
    robe('M -56 -338 Q -78 -250 -70 -176 L 108 -176 Q 96 -250 64 -338 Q 0 -364 -56 -338 Z') +
    sleeve([[-40, -322], [-70, -230], [-124, -130]]) +
    sleeve([[26, -318], [10, -226], [-40, -132]], 34) +
    hand(-126, -128, 18) + hand(-42, -130, 16) +
    `<g transform="rotate(${turn} -6 -352)">` +
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
