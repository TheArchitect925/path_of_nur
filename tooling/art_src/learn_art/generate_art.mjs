// Path of Nur — "Storybook" card art generator (Option A style, approved 2026-08-28).
// Emits 1600x1200 (4:3) SVG masters composed from shared motifs.
// Style rules: soft gradient skies, large calm silhouettes, warm ivory light,
// gold accents; no faces, no figures, no text baked into artwork.
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const OUT = new URL('./svg/', import.meta.url).pathname;
mkdirSync(OUT, { recursive: true });

const W = 1600, H = 1200;
const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';

// deterministic PRNG so re-runs are identical
function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

let uid = 0;
const id = (p) => `${p}${++uid}`;

function svgDoc(inner) {
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}">${inner}</svg>`;
}

function skyV(stops) {
  const g = id('sky');
  const s = stops.map(([o, c]) => `<stop offset="${o}" stop-color="${c}"/>`).join('');
  return {
    def: `<linearGradient id="${g}" x1="0" y1="0" x2="0" y2="1">${s}</linearGradient>`,
    rect: `<rect width="${W}" height="${H}" fill="url(#${g})"/>`,
  };
}

function glow(cx, cy, r, color, a) {
  const g = id('glow');
  return {
    def: `<radialGradient id="${g}"><stop offset="0" stop-color="${color}" stop-opacity="${a}"/><stop offset="1" stop-color="${color}" stop-opacity="0"/></radialGradient>`,
    el: `<circle cx="${cx}" cy="${cy}" r="${r}" fill="url(#${g})"/>`,
  };
}

function stars(seed, n, x0, x1, y0, y1, color = IVORY) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0);
    const y = y0 + rnd() * (y1 - y0);
    const r = 2.2 + rnd() * 3.6;
    const o = 0.35 + rnd() * 0.5;
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${r.toFixed(1)}" fill="${color}" opacity="${o.toFixed(2)}"/>`;
  }
  return out;
}

// waxing crescent drawn as a single path (no sky-colored cutout — safe over gradients)
function crescent(cx, cy, r, lit, _skyColor) {
  return `<path d="M ${cx} ${cy - r} A ${r} ${r} 0 1 0 ${cx} ${cy + r} A ${r * 1.18} ${r * 1.18} 0 0 1 ${cx} ${cy - r} Z" fill="${lit}"/>`;
}

function fullMoon(cx, cy, r, lit) {
  return `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${lit}"/><circle cx="${cx - r * 0.3}" cy="${cy - r * 0.15}" r="${r * 0.16}" fill="#000" opacity="0.05"/><circle cx="${cx + r * 0.25}" cy="${cy + r * 0.3}" r="${r * 0.11}" fill="#000" opacity="0.05"/>`;
}

function hills(color, yTop, amp = 60) {
  return `<path d="M0 ${H} L0 ${yTop + amp} Q ${W * 0.25} ${yTop - amp} ${W * 0.5} ${yTop + amp * 0.4} T ${W} ${yTop} L ${W} ${H} Z" fill="${color}"/>`;
}

function dunes(c1, c2, yTop) {
  return `<path d="M0 ${H} L0 ${yTop + 90} Q ${W * 0.3} ${yTop - 70} ${W * 0.62} ${yTop + 60} T ${W} ${yTop - 20} L ${W} ${H} Z" fill="${c1}"/>` +
    `<path d="M0 ${H} L0 ${yTop + 210} Q ${W * 0.35} ${yTop + 90} ${W * 0.7} ${yTop + 190} T ${W} ${yTop + 150} L ${W} ${H} Z" fill="${c2}"/>`;
}

// mosque silhouette: central dome + finial + optional minarets + body
function dome(cx, baseY, rx, color) {
  const ry = rx * 1.06;
  return `<path d="M ${cx - rx} ${baseY} A ${rx} ${ry} 0 0 1 ${cx + rx} ${baseY} Z" fill="${color}"/>` +
    `<rect x="${cx - 5}" y="${baseY - ry - 52}" width="10" height="58" rx="5" fill="${color}"/>` +
    crescent(cx, baseY - ry - 82, 26, color, 'none').split('<circle').slice(0, 2).join('<circle');
}

function finialCrescent(cx, cy, r, color) {
  return `<path d="M ${cx} ${cy - r} a ${r} ${r} 0 1 0 0.01 0 Z" fill="none" stroke="${color}" stroke-width="10"/>`;
}

function minaret(x, baseY, hgt, wdt, color) {
  const capH = wdt * 1.15;
  return `<rect x="${x - wdt / 2}" y="${baseY - hgt}" width="${wdt}" height="${hgt}" rx="${wdt * 0.18}" fill="${color}"/>` +
    `<path d="M ${x - wdt * 0.85} ${baseY - hgt} h ${wdt * 1.7} l ${-wdt * 0.25} ${-wdt * 0.4} h ${-wdt * 1.2} Z" fill="${color}"/>` +
    `<path d="M ${x - wdt / 2} ${baseY - hgt - wdt * 0.4} A ${wdt / 2} ${capH} 0 0 1 ${x + wdt / 2} ${baseY - hgt - wdt * 0.4} Z" fill="${color}"/>` +
    `<rect x="${x - 3}" y="${baseY - hgt - wdt * 0.4 - capH - 34}" width="6" height="40" fill="${color}"/>`;
}

function mosqueSilhouette(cx, baseY, scale, color) {
  const bw = 560 * scale;
  return `<rect x="${cx - bw / 2}" y="${baseY - 150 * scale}" width="${bw}" height="${150 * scale}" fill="${color}"/>` +
    dome(cx, baseY - 150 * scale, 190 * scale, color) +
    minaret(cx - bw / 2 - 70 * scale, baseY, 420 * scale, 56 * scale, color) +
    minaret(cx + bw / 2 + 70 * scale, baseY, 420 * scale, 56 * scale, color);
}

function lantern(cx, cy, s, body = GOLD, glass = CREAM) {
  return `<line x1="${cx}" y1="${cy - 210 * s}" x2="${cx}" y2="${cy - 150 * s}" stroke="${body}" stroke-width="${8 * s}"/>` +
    `<path d="M ${cx - 55 * s} ${cy - 150 * s} h ${110 * s} l ${18 * s} ${34 * s} v ${120 * s} q 0 ${56 * s} ${-73 * s} ${56 * s} t ${-73 * s} ${-56 * s} v ${-120 * s} Z" fill="${body}"/>` +
    `<rect x="${cx - 26 * s}" y="${cy - 118 * s}" width="${52 * s}" height="${150 * s}" rx="${10 * s}" fill="${glass}"/>` +
    `<circle cx="${cx}" cy="${cy + 78 * s}" r="${16 * s}" fill="${body}"/>`;
}

// rehal: iconic X-shaped folding stand with a thick open mushaf resting in the V.
// The book is layered — protruding cover, stacked page block, curved top pages —
// so it reads as a bound volume, not a pamphlet.
function rehal(cx, baseY, s, wood = '#3D2A20', page = CREAM, pageShade = '#D8C49A', cover = '#4A2F22') {
  const legW = 26 * s, top = baseY - 250 * s, sy = baseY - 208 * s;
  let g = `<path d="M ${cx + 130 * s} ${baseY} L ${cx - 96 * s} ${top}" stroke="${wood}" stroke-width="${legW}" fill="none" stroke-linecap="round"/>` +
    `<path d="M ${cx - 130 * s} ${baseY} L ${cx + 96 * s} ${top}" stroke="${wood}" stroke-width="${legW}" fill="none" stroke-linecap="round"/>`;
  for (const m of [-1, 1]) {
    g += `<path d="M ${cx} ${sy + 10 * s} L ${cx + m * 204 * s} ${sy - 78 * s} L ${cx + m * 198 * s} ${sy - 104 * s} L ${cx} ${sy - 16 * s} Z" fill="${cover}"/>`;
    g += `<path d="M ${cx} ${sy} L ${cx + m * 192 * s} ${sy - 88 * s} L ${cx + m * 188 * s} ${sy - 112 * s} L ${cx} ${sy - 24 * s} Z" fill="${pageShade}"/>`;
    g += `<path d="M ${cx} ${sy - 26 * s} Q ${cx + m * 70 * s} ${sy - 72 * s} ${cx + m * 184 * s} ${sy - 114 * s} L ${cx + m * 178 * s} ${sy - 136 * s} Q ${cx + m * 66 * s} ${sy - 96 * s} ${cx} ${sy - 50 * s} Z" fill="${page}"/>`;
  }
  g += `<line x1="${cx}" y1="${sy + 10 * s}" x2="${cx}" y2="${sy - 50 * s}" stroke="${wood}" stroke-width="${8 * s}"/>`;
  return g;
}

function openBook(cx, cy, s, cover = '#EFE3C0', lines = '#8A7A54') {
  let g = `<path d="M ${cx} ${cy - 40 * s} C ${cx - 60 * s} ${cy - 78 * s} ${cx - 170 * s} ${cy - 78 * s} ${cx - 230 * s} ${cy - 40 * s} L ${cx - 230 * s} ${cy + 110 * s} C ${cx - 170 * s} ${cy + 72 * s} ${cx - 60 * s} ${cy + 72 * s} ${cx} ${cy + 110 * s} C ${cx + 60 * s} ${cy + 72 * s} ${cx + 170 * s} ${cy + 72 * s} ${cx + 230 * s} ${cy + 110 * s} L ${cx + 230 * s} ${cy - 40 * s} C ${cx + 170 * s} ${cy - 78 * s} ${cx + 60 * s} ${cy - 78 * s} ${cx} ${cy - 40 * s} Z" fill="${cover}"/>` +
    `<line x1="${cx}" y1="${cy - 40 * s}" x2="${cx}" y2="${cy + 110 * s}" stroke="${lines}" stroke-width="${5 * s}" opacity="0.5"/>`;
  for (let i = 0; i < 3; i++) {
    const y = cy + (-10 + i * 30) * s;
    g += `<line x1="${cx - 190 * s}" y1="${y}" x2="${cx - 55 * s}" y2="${y - 12 * s}" stroke="${lines}" stroke-width="${7 * s}" stroke-linecap="round" opacity="0.55"/>`;
    g += `<line x1="${cx + 55 * s}" y1="${y - 12 * s}" x2="${cx + 190 * s}" y2="${y}" stroke="${lines}" stroke-width="${7 * s}" stroke-linecap="round" opacity="0.55"/>`;
  }
  return g;
}

function scroll(cx, cy, s, paper = '#EFE3C0', roll = '#D8C49A', lines = '#8A7A54') {
  let g = `<rect x="${cx - 170 * s}" y="${cy - 120 * s}" width="${340 * s}" height="${240 * s}" rx="${16 * s}" fill="${paper}"/>` +
    `<rect x="${cx - 205 * s}" y="${cy - 120 * s}" width="${40 * s}" height="${240 * s}" rx="${20 * s}" fill="${roll}"/>` +
    `<rect x="${cx + 165 * s}" y="${cy - 120 * s}" width="${40 * s}" height="${240 * s}" rx="${20 * s}" fill="${roll}"/>`;
  for (let i = 0; i < 4; i++) {
    const y = cy - 60 * s + i * 48 * s;
    const wl = (i === 3 ? 160 : 250) * s;
    g += `<line x1="${cx - wl / 2}" y1="${y}" x2="${cx + wl / 2}" y2="${y}" stroke="${lines}" stroke-width="${9 * s}" stroke-linecap="round" opacity="0.6"/>`;
  }
  return g;
}

function star8(cx, cy, r, fill, inner = null) {
  const pts = [];
  for (let i = 0; i < 16; i++) {
    const a = (Math.PI / 8) * i - Math.PI / 2;
    const rr = i % 2 === 0 ? r : r * 0.42;
    pts.push(`${(cx + rr * Math.cos(a)).toFixed(1)},${(cy + rr * Math.sin(a)).toFixed(1)}`);
  }
  let g = `<polygon points="${pts.join(' ')}" fill="${fill}"/>`;
  if (inner) g += star8Inner(cx, cy, r * 0.5, inner);
  return g;
}
function star8Inner(cx, cy, r, fill) {
  const pts = [];
  for (let i = 0; i < 16; i++) {
    const a = (Math.PI / 8) * i - Math.PI / 2;
    const rr = i % 2 === 0 ? r : r * 0.42;
    pts.push(`${(cx + rr * Math.cos(a)).toFixed(1)},${(cy + rr * Math.sin(a)).toFixed(1)}`);
  }
  return `<polygon points="${pts.join(' ')}" fill="${fill}"/>`;
}

function kite(cx, cy, s, fill = GOLD, light = CREAM, tail = IVORY) {
  return `<path d="M ${cx} ${cy - 130 * s} L ${cx + 100 * s} ${cy} L ${cx} ${cy + 130 * s} L ${cx - 100 * s} ${cy} Z" fill="${fill}"/>` +
    `<path d="M ${cx} ${cy - 130 * s} L ${cx + 100 * s} ${cy} L ${cx} ${cy} Z" fill="${light}"/>` +
    `<path d="M ${cx} ${cy + 130 * s} q ${-50 * s} ${90 * s} ${-130 * s} ${120 * s}" stroke="${tail}" stroke-width="${7 * s}" fill="none"/>` +
    `<path d="M ${cx - 92 * s} ${cy + 224 * s} l ${26 * s} ${-14 * s} M ${cx - 134 * s} ${cy + 244 * s} l ${26 * s} ${-14 * s}" stroke="${fill}" stroke-width="${9 * s}" stroke-linecap="round"/>`;
}

function misbaha(cx, cy, r, bead = GOLD, accent = CREAM) {
  let g = '';
  const n = 26;
  for (let i = 0; i < n; i++) {
    const a = (Math.PI * 2 * i) / n - Math.PI / 2;
    const bx = cx + r * Math.cos(a), by = cy + r * Math.sin(a);
    g += `<circle cx="${bx.toFixed(1)}" cy="${by.toFixed(1)}" r="${i % 9 === 0 ? 26 : 19}" fill="${i % 9 === 0 ? accent : bead}"/>`;
  }
  g += `<rect x="${cx - 13}" y="${cy + r + 18}" width="26" height="86" rx="13" fill="${bead}"/>` +
    `<circle cx="${cx}" cy="${cy + r + 130}" r="24" fill="${accent}"/>`;
  return g;
}

function archWindow(cx, cy, w, h, frame, inside) {
  return `<path d="M ${cx - w / 2} ${cy + h / 2} v ${-h * 0.55} a ${w / 2} ${w / 2} 0 0 1 ${w} 0 v ${h * 0.55} Z" fill="${frame}"/>` +
    `<path d="M ${cx - w / 2 + 26} ${cy + h / 2 - 20} v ${-h * 0.5} a ${w / 2 - 26} ${w / 2 - 26} 0 0 1 ${w - 52} 0 v ${h * 0.5} Z" fill="${inside}"/>`;
}

function prayerMat(cx, baseY, s, c1 = '#7A5FA0', c2 = CREAM) {
  return `<path d="M ${cx - 190 * s} ${baseY} l ${60 * s} ${-190 * s} h ${260 * s} l ${60 * s} ${190 * s} Z" fill="${c1}"/>` +
    `<path d="M ${cx - 130 * s} ${baseY - 24 * s} l ${36 * s} ${-128 * s} h ${188 * s} l ${36 * s} ${128 * s} Z" fill="none" stroke="${c2}" stroke-width="${10 * s}" opacity="0.75"/>` +
    `<path d="M ${cx - 44 * s} ${baseY - 56 * s} v ${-36 * s} a ${44 * s} ${44 * s} 0 0 1 ${88 * s} 0 v ${36 * s} Z" fill="${c2}" opacity="0.85"/>`;
}

function palm(x, baseY, s, color) {
  let fronds = '';
  const tipX = x + 26 * s, tipY = baseY - 300 * s;
  const dirs = [[-1, -0.45], [-0.75, -0.95], [-0.15, -1.15], [0.5, -1], [1, -0.55], [1.15, -0.05]];
  for (const [dx, dy] of dirs) {
    fronds += `<path d="M ${tipX} ${tipY} q ${dx * 130 * s} ${dy * 110 * s} ${dx * 230 * s} ${dy * 90 * s} q ${-dx * 90 * s} ${-dy * 10 * s + 34 * s} ${-dx * 218 * s} ${-dy * 74 * s + 10 * s} Z" fill="${color}"/>`;
  }
  return `<path d="M ${x} ${baseY} q ${6 * s} ${-170 * s} ${26 * s} ${-300 * s} l ${26 * s} 0 q ${-14 * s} ${140 * s} ${-8 * s} ${300 * s} Z" fill="${color}"/>` + fronds;
}

function sceneDoor(sky1, sky2, doorGlow, frame, ground) {
  const s = skyV([[0, sky1], [1, sky2]]);
  const gl = glow(800, 640, 460, doorGlow, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(11, 26, 60, 1540, 60, 500)}${crescent(1210, 210, 92, IVORY, sky1)}${hills(ground, 960, 70)}${gl.el}` +
    `<path d="M 640 1030 v -420 a 160 160 0 0 1 320 0 v 420 Z" fill="${frame}"/>` +
    `<path d="M 668 1030 v -400 a 132 132 0 0 1 264 0 v 400 Z" fill="${doorGlow}"/>` +
    `<path d="M 800 1030 v -540 M 800 630 v 0" stroke="${frame}" stroke-width="12"/>` +
    `<path d="M 700 1030 L 560 1120 M 900 1030 L 1040 1120" stroke="${doorGlow}" stroke-width="44" stroke-linecap="round" opacity="0.35"/>` +
    `<path d="M0 ${H} L0 1030 H ${W} V ${H} Z" fill="${ground}"/>`);
}

const scenes = [];
const add = (file, fn) => scenes.push([file, fn]);

/* ============================= ADULT ISLANDS ============================= */

add('island_foundations', () => {
  const s = skyV([[0, '#E8B36A'], [0.55, '#C97E45'], [1, '#8A4B33']]);
  const sun = glow(800, 560, 420, CREAM, 0.75);
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${sun.el}<circle cx="800" cy="560" r="120" fill="${CREAM}"/>` +
    `${hills('#5E3527', 980, 60)}` +
    `<rect x="240" y="800" width="1120" height="220" fill="#3D2117"/>` +
    [0, 1, 2, 3, 4].map(i => `<path d="M ${360 + i * 220 - 62} 1020 v -130 a 62 62 0 0 1 124 0 v 130 Z" fill="#E8B36A"/>`).join('') +
    dome(800, 800, 240, '#3D2117') +
    minaret(180, 1020, 500, 64, '#3D2117') + minaret(1420, 1020, 500, 64, '#3D2117') +
    `<path d="M0 ${H} L0 1020 H ${W} V ${H} Z" fill="#301A12"/>`);
});

add('island_quran', () => {
  const s = skyV([[0, '#232A44'], [0.6, '#2E2A54'], [1, '#4A2E55']]);
  const gl = glow(800, 640, 520, '#F5D57B', 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(21, 40, 60, 1540, 50, 560)}${crescent(300, 230, 100, IVORY, '#232A44')}` +
    `${hills('#1B2038', 990, 50)}${gl.el}` +
    rehal(800, 1000, 1.6) +
    `<path d="M0 ${H} L0 1000 H ${W} V ${H} Z" fill="#161A30"/>` +
    lantern(1310, 420, 1.15));
});

add('island_worship', () => {
  const s = skyV([[0, '#16323C'], [0.6, '#1F4A4C'], [1, '#28564F']]);
  const gl = glow(800, 620, 480, '#F5D57B', 0.35);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(31, 30, 60, 1540, 40, 420)}` +
    `<path d="M 430 1020 v -420 a 370 430 0 0 1 740 0 v 420 Z" fill="#0F2429"/>` +
    `<path d="M 480 1020 v -390 a 320 380 0 0 1 640 0 v 390 Z" fill="#1F4A4C"/>${gl.el}` +
    lantern(800, 430, 1.5) +
    prayerMat(800, 1010, 1.35, '#173B40', CREAM) +
    `<path d="M0 ${H} L0 1020 H ${W} V ${H} Z" fill="#0C1D22"/>`);
});

add('island_character', () => {
  const s = skyV([[0, '#2C4A3E'], [0.6, '#43593C'], [1, '#7C7F58']]);
  const gl = glow(640, 460, 440, CREAM, 0.3);
  // blossoms clustered on the moonlit (upper-right) side of the canopy
  let blossoms = '';
  const rnd = mulberry32(7);
  for (let i = 0; i < 18; i++) {
    const a = -Math.PI * 0.55 + rnd() * Math.PI * 0.75;
    const rr = 130 + rnd() * 130;
    blossoms += `<circle cx="${(650 + rr * Math.cos(a)).toFixed(0)}" cy="${(470 + rr * Math.sin(a) * 0.8).toFixed(0)}" r="${(9 + rnd() * 10).toFixed(0)}" fill="${rnd() > 0.45 ? CREAM : GOLD}" opacity="0.95"/>`;
  }
  // a few petals drifting down on the breeze
  const petals = `<circle cx="920" cy="640" r="8" fill="${CREAM}" opacity="0.7"/><circle cx="980" cy="740" r="7" fill="${GOLD}" opacity="0.6"/><circle cx="890" cy="830" r="6" fill="${CREAM}" opacity="0.5"/>`;
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(261, 24, 60, 1540, 40, 320)}${crescent(1300, 210, 88, IVORY)}${gl.el}` +
    `${hills('#3A4A33', 950, 80)}` +
    // canopy: layered clusters, dark back to lit front
    `<circle cx="540" cy="530" r="165" fill="#33452C"/><circle cx="770" cy="545" r="150" fill="#33452C"/><circle cx="650" cy="420" r="185" fill="#33452C"/>` +
    `<circle cx="490" cy="580" r="115" fill="#3F5438"/><circle cx="820" cy="590" r="108" fill="#3F5438"/><circle cx="590" cy="470" r="140" fill="#3F5438"/><circle cx="740" cy="470" r="130" fill="#3F5438"/>` +
    `<circle cx="600" cy="400" r="88" fill="#4C6742"/><circle cx="712" cy="390" r="96" fill="#4C6742"/><circle cx="666" cy="500" r="110" fill="#46603E"/>` +
    blossoms + petals +
    // trunk and boughs
    `<path d="M 636 1010 C 632 880 636 800 650 706" stroke="#4A3526" stroke-width="62" fill="none" stroke-linecap="round"/>` +
    `<path d="M 648 730 C 610 668 566 636 502 620" stroke="#4A3526" stroke-width="27" fill="none" stroke-linecap="round"/>` +
    `<path d="M 652 716 C 702 662 756 640 812 636" stroke="#4A3526" stroke-width="27" fill="none" stroke-linecap="round"/>` +
    `<path d="M 650 720 C 658 648 672 596 700 548" stroke="#4A3526" stroke-width="20" fill="none" stroke-linecap="round"/>` +
    `<path d="M 610 1010 q 26 -30 26 -70 M 662 1010 q -20 -32 -18 -66" stroke="#3A2A20" stroke-width="16" fill="none" stroke-linecap="round"/>` +
    // lantern hanging from the right bough, with fireflies
    `<line x1="812" y1="636" x2="812" y2="676" stroke="${DEEPGOLD}" stroke-width="7"/>` +
    lantern(812, 856, 0.8) +
    `<circle cx="884" cy="770" r="6" fill="${CREAM}" opacity="0.8"/><circle cx="760" cy="810" r="5" fill="${GOLD}" opacity="0.7"/><circle cx="910" cy="880" r="5" fill="${GOLD}" opacity="0.55"/>` +
    `<path d="M0 ${H} L0 1000 H ${W} V ${H} Z" fill="#242F20"/>` +
    // grass tufts and small flowers along the ground line
    `<path d="M 300 1000 q 8 -34 0 -52 M 322 1000 q 10 -26 4 -44 M 1180 1000 q -8 -34 0 -52 M 1158 1000 q -10 -26 -4 -44" stroke="#3A4A33" stroke-width="10" fill="none" stroke-linecap="round"/>` +
    `<circle cx="342" cy="948" r="9" fill="${GOLD}" opacity="0.9"/><circle cx="1142" cy="948" r="9" fill="${CREAM}" opacity="0.9"/>`);
});

add('island_stories', () => {
  const s = skyV([[0, '#2B3563'], [0.65, '#5A3D67'], [1, '#8A5348']]);
  const gl = glow(1180, 320, 340, IVORY, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(41, 34, 60, 1540, 40, 480)}${gl.el}${fullMoon(1180, 320, 110, IVORY)}` +
    `<g opacity="0.85">${mosqueSilhouette(430, 880, 0.55, '#241C3E')}</g>` +
    dunes('#4A3560', '#332450', 900) +
    palm(1210, 1105, 1.05, '#241C3E') +
    `<path d="M0 ${H} L0 1105 H ${W} V ${H} Z" fill="#1D1733"/>`);
});

add('island_games', () => {
  const s = skyV([[0, '#31547A'], [0.6, '#3E6B8C'], [1, '#7A9AA8']]);
  return svgDoc(`<defs>${s.def}</defs>${s.rect}${stars(51, 18, 60, 1540, 40, 360)}` +
    `<ellipse cx="300" cy="330" rx="150" ry="52" fill="${IVORY}" opacity="0.4"/><ellipse cx="1330" cy="220" rx="180" ry="60" fill="${IVORY}" opacity="0.3"/><ellipse cx="1180" cy="880" rx="170" ry="56" fill="${IVORY}" opacity="0.25"/>` +
    kite(880, 420, 1.7) +
    star8(340, 720, 120, GOLD, CREAM) + star8(1310, 560, 84, CREAM) +
    `${hills('#2C4A66', 1020, 70)}<path d="M0 ${H} L0 1020 H ${W} V ${H} Z" fill="#223A52"/>`);
});

/* ============================= GUIDED PATHS ============================= */

add('path_foundations', () => sceneDoor('#3A2E63', '#6E3F2E', '#F5D57B', '#241C3E', '#2A2142'));

add('path_salah', () => {
  const s = skyV([[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']]);
  const sun = glow(800, 850, 400, CREAM, 0.7);
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${stars(61, 14, 60, 1540, 40, 300)}${sun.el}<circle cx="800" cy="850" r="92" fill="${CREAM}"/>` +
    `${hills('#5E4030', 960, 60)}` +
    minaret(280, 1030, 660, 80, '#3D2A20') +
    `<g opacity="0.94">${mosqueSilhouette(1150, 1030, 0.6, '#3D2A20')}</g>` +
    `<path d="M0 ${H} L0 1030 H ${W} V ${H} Z" fill="#33241B"/>`);
});

add('path_quran_beginner', () => {
  const s = skyV([[0, '#B0743B'], [0.6, '#D19A56'], [1, '#E8C089']]);
  const gl = glow(800, 700, 480, CREAM, 0.6);
  let rays = '';
  for (let i = 0; i < 7; i++) {
    const a = -Math.PI / 2 + (i - 3) * 0.3;
    rays += `<line x1="800" y1="640" x2="${800 + 560 * Math.cos(a)}" y2="${640 + 560 * Math.sin(a)}" stroke="${CREAM}" stroke-width="26" stroke-linecap="round" opacity="0.28"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${rays}${gl.el}` +
    `<ellipse cx="800" cy="1010" rx="560" ry="110" fill="#8A5A36"/>` +
    rehal(800, 1000, 1.6, '#54382A') +
    `<path d="M0 ${H} L0 1040 Q 800 980 1600 1040 V ${H} Z" fill="#6E4629"/>`);
});

add('path_daily_dhikr', () => {
  const s = skyV([[0, '#1A1F33'], [0.6, '#232A44'], [1, '#3A2E63']]);
  const gl = glow(800, 620, 500, '#F5D57B', 0.32);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(71, 44, 60, 1540, 40, 520)}${crescent(1230, 250, 110, IVORY, '#1A1F33')}${gl.el}` +
    `<ellipse cx="800" cy="1010" rx="620" ry="120" fill="#2A2142"/>` +
    misbaha(800, 620, 280) +
    `<path d="M0 ${H} L0 1050 Q 800 990 1600 1050 V ${H} Z" fill="#1D1733"/>`);
});

add('path_character', () => {
  const s = skyV([[0, '#28392B'], [0.6, '#43593C'], [1, '#57694A']]);
  const gl = glow(800, 540, 380, CREAM, 0.4);
  const bloom = glow(792, 520, 150, '#F5D57B', 0.55);
  // five soft petals around a golden heart
  let petals = '';
  for (let i = 0; i < 5; i++) {
    const a = -Math.PI / 2 + (i * Math.PI * 2) / 5;
    petals += `<circle cx="${(792 + 40 * Math.cos(a)).toFixed(0)}" cy="${(524 + 40 * Math.sin(a)).toFixed(0)}" r="30" fill="${CREAM}"/>`;
  }
  const sparkle = (x, y, r) =>
    `<path d="M ${x} ${y - r} L ${x + r * 0.28} ${y - r * 0.28} L ${x + r} ${y} L ${x + r * 0.28} ${y + r * 0.28} L ${x} ${y + r} L ${x - r * 0.28} ${y + r * 0.28} L ${x - r} ${y} L ${x - r * 0.28} ${y - r * 0.28} Z" fill="${GOLD}" opacity="0.9"/>`;
  return svgDoc(`<defs>${s.def}${gl.def}${bloom.def}</defs>${s.rect}${stars(81, 26, 60, 1540, 40, 380)}${gl.el}${crescent(300, 230, 84, IVORY)}` +
    // ground shadow, then the pot: rim, tapered body, patterned band
    `<ellipse cx="800" cy="1004" rx="200" ry="26" fill="#1C2418"/>` +
    `<path d="M 686 864 h 228 l -30 140 h -168 Z" fill="#A5633C"/>` +
    `<path d="M 686 864 h 228 l -30 140 h -84 q 40 -60 22 -140 Z" fill="#8A4F30" opacity="0.55"/>` +
    `<rect x="668" y="822" width="264" height="46" rx="14" fill="#B4714A"/>` +
    `<path d="M 716 946 l 22 -22 22 22 22 -22 22 22 22 -22 22 22 22 -22 22 22" stroke="${CREAM}" stroke-width="7" fill="none" opacity="0.55"/>` +
    `<ellipse cx="800" cy="836" rx="112" ry="15" fill="#3A2A20"/>` +
    // stem and leaves
    `<path d="M 800 836 C 798 770 802 706 794 618" stroke="#3E5A34" stroke-width="16" fill="none" stroke-linecap="round"/>` +
    `<path d="M 798 762 C 742 754 700 726 686 674 C 740 668 786 698 798 740 Z" fill="#4C6742"/>` +
    `<path d="M 800 716 C 856 704 894 672 902 620 C 848 618 806 652 799 696 Z" fill="#3F5438"/>` +
    `<path d="M 796 664 C 758 654 734 634 726 602 C 762 600 790 622 795 650 Z" fill="#4C6742"/>` +
    // the young bloom, glowing
    `${bloom.el}${petals}<circle cx="792" cy="524" r="22" fill="${GOLD}"/>` +
    sparkle(700, 448, 16) + sparkle(886, 470, 13) + sparkle(846, 402, 10) +
    `<path d="M0 ${H} L0 1004 H ${W} V ${H} Z" fill="#242F20"/>` +
    `<path d="M 560 1004 q 8 -30 0 -46 M 1044 1004 q -8 -30 0 -46" stroke="#3A4A33" stroke-width="9" fill="none" stroke-linecap="round"/>`);
});

add('path_stories', () => {
  const s = skyV([[0, '#2B3563'], [0.65, '#4A2E55'], [1, '#6E3F2E']]);
  const gl = glow(800, 560, 380, IVORY, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(91, 30, 60, 1540, 40, 440)}${gl.el}${crescent(800, 330, 96, IVORY, '#2B3563')}` +
    `<path d="M 260 900 C 400 820 640 820 800 900 C 960 820 1200 820 1340 900 L 1340 1060 C 1200 980 960 980 800 1060 C 640 980 400 980 260 1060 Z" fill="#EFE3C0"/>` +
    `<path d="M 320 906 Q 560 850 780 908 Q 700 852 560 848 Q 430 850 320 906 Z" fill="#C9A25E" opacity="0.7"/>` +
    `<path d="M 830 906 Q 1060 848 1290 904 Q 1180 850 1040 850 Q 930 852 830 906 Z" fill="#C9A25E" opacity="0.7"/>` +
    `<line x1="800" y1="900" x2="800" y2="1060" stroke="#8A7A54" stroke-width="8" opacity="0.5"/>` +
    `<path d="M0 ${H} L0 1060 C 400 980 1200 980 1600 1060 V ${H} Z" fill="#1D1733"/>`);
});

add('path_kids_starter', () => {
  const s = skyV([[0, '#3E6B8C'], [0.6, '#7A9AA8'], [1, '#E8C089']]);
  const gl = glow(1240, 780, 300, CREAM, 0.5);
  let stones = '';
  const pts = [[430, 1120], [610, 1060], [790, 1020], [960, 970], [1110, 920]];
  pts.forEach(([x, y], i) => { stones += `<ellipse cx="${x}" cy="${y}" rx="${86 - i * 8}" ry="${30 - i * 2}" fill="${CREAM}" opacity="0.95"/>`; });
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    `<ellipse cx="320" cy="260" rx="160" ry="54" fill="${IVORY}" opacity="0.5"/><ellipse cx="1200" cy="180" rx="190" ry="60" fill="${IVORY}" opacity="0.4"/>` +
    `${hills('#5E8A6A', 880, 90)}${gl.el}` +
    `<g opacity="0.95">${mosqueSilhouette(1250, 900, 0.42, '#33544A')}</g>` +
    `<path d="M0 ${H} L0 980 Q 800 900 1600 960 V ${H} Z" fill="#4A7A58"/>${stones}` +
    star8(260, 480, 74, CREAM));
});

/* ============================= LEVEL PATHS ============================= */

add('level_new_to_islam', () => sceneDoor('#232A44', '#4A2E55', '#F0D89A', '#161A30', '#1D2038'));

add('level_building_consistency', () => {
  const s = skyV([[0, '#1A1F33'], [0.65, '#2E2A54'], [1, '#4A2E55']]);
  let g = `<defs>${s.def}`;
  let els = '';
  const xs = [260, 560, 860, 1160, 1460];
  xs.forEach((x, i) => {
    const gl = glow(x, 640, 200 + i * 26, '#F5D57B', 0.16 + i * 0.09);
    g += gl.def; els += gl.el + lantern(x, 700, 0.85 + i * 0.07);
  });
  return svgDoc(g + `</defs>${s.rect}${stars(101, 34, 60, 1540, 40, 420)}${crescent(200, 210, 76, IVORY, '#1A1F33')}` +
    `${hills('#241C3E', 980, 60)}${els}` +
    `<path d="M0 ${H} L0 1010 Q 800 950 1600 1000 V ${H} Z" fill="#1D1733"/>`);
});

add('level_deepening_knowledge', () => {
  const s = skyV([[0, '#121423'], [0.6, '#232A44'], [1, '#2E2A54']]);
  const gl = glow(560, 700, 420, '#F5D57B', 0.3);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(111, 56, 60, 1540, 40, 560)}${gl.el}` +
    `<ellipse cx="800" cy="1010" rx="640" ry="110" fill="#2A2142"/>` +
    `<rect x="300" y="800" width="440" height="80" rx="14" fill="#6E3F2E"/><rect x="700" y="812" width="30" height="56" rx="8" fill="${CREAM}" opacity="0.85"/>` +
    `<rect x="340" y="722" width="370" height="78" rx="14" fill="#8A5A36"/><rect x="672" y="734" width="28" height="54" rx="8" fill="${CREAM}" opacity="0.85"/>` +
    `<rect x="376" y="648" width="300" height="74" rx="14" fill="#B0743B"/><rect x="640" y="660" width="26" height="50" rx="8" fill="${CREAM}" opacity="0.85"/>` +
    `<rect x="470" y="600" width="20" height="48" rx="6" fill="${GOLD}"/>` +
    `<circle cx="1060" cy="740" r="150" fill="none" stroke="${GOLD}" stroke-width="14"/>` +
    `<circle cx="1060" cy="740" r="96" fill="none" stroke="${GOLD}" stroke-width="8" opacity="0.7"/>` +
    `<line x1="1060" y1="560" x2="1060" y2="920" stroke="${GOLD}" stroke-width="10"/>` +
    `<line x1="930" y1="850" x2="1190" y2="630" stroke="${CREAM}" stroke-width="9"/>` +
    `<circle cx="1060" cy="740" r="20" fill="${CREAM}"/>` +
    `<rect x="1250" y="820" width="90" height="66" rx="14" fill="#3D2A20"/><rect x="1284" y="770" width="22" height="60" rx="8" fill="${GOLD}"/>` +
    `<path d="M0 ${H} L0 1046 Q 800 990 1600 1040 V ${H} Z" fill="#161A30"/>`);
});

add('level_refinement', () => {
  const s = skyV([[0, '#121423'], [0.55, '#1A2038'], [1, '#1F2C46']]);
  const gl = glow(800, 380, 300, IVORY, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(121, 40, 60, 1540, 40, 500)}${gl.el}${crescent(800, 360, 104, IVORY, '#121423')}` +
    `<rect x="0" y="820" width="${W}" height="380" fill="#0E1626"/>` +
    `<ellipse cx="800" cy="820" rx="800" ry="26" fill="#24314E"/>` +
    `<path d="M 760 1010 q 40 14 80 0 M 730 940 q 70 22 140 0 M 700 875 q 100 30 200 0" stroke="${IVORY}" stroke-width="10" fill="none" opacity="0.35" stroke-linecap="round"/>` +
    `<circle cx="800" cy="940" r="64" fill="${IVORY}" opacity="0.14"/><circle cx="800" cy="940" r="34" fill="${IVORY}" opacity="0.2"/>` +
    `<path d="M 270 820 q 8 -140 -16 -210 M 310 820 q 4 -100 24 -170" stroke="#2C3A28" stroke-width="14" fill="none" stroke-linecap="round"/>` +
    `<path d="M 254 610 q -4 -44 22 -66 q 20 30 2 70 Z" fill="#2C3A28"/>`);
});

/* ============================= KIDS ============================= */

add('kids_story_library', () => {
  const s = skyV([[0, '#2B3563'], [1, '#3D2E5C']]);
  const gl = glow(340, 300, 260, IVORY, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(131, 30, 60, 1540, 40, 520)}${gl.el}${crescent(340, 300, 120, '#F0E4C0', '#2B3563')}` +
    `<g opacity="0.96">${mosqueSilhouette(1120, 950, 0.62, '#1E2444')}</g>` +
    `${hills('#181D38', 1010, 70)}<path d="M0 ${H} L0 1010 H ${W} V ${H} Z" fill="#141830" opacity="0.0"/>`);
});

add('kids_quran', () => {
  const s = skyV([[0, '#B0743B'], [1, '#6E3F2E']]);
  const sun = glow(800, 330, 400, '#F5D57B', 0.7);
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${sun.el}<circle cx="800" cy="330" r="120" fill="${CREAM}"/>` +
    `${hills('#4A2F22', 1000, 60)}` +
    rehal(800, 1010, 1.7, '#3D2A20') +
    `<path d="M0 ${H} L0 1010 H ${W} V ${H} Z" fill="#3A2418"/>`);
});

add('kids_arabic', () => {
  const s = skyV([[0, '#1F4A4C'], [1, '#16323C']]);
  const gl = glow(800, 520, 420, '#F5D57B', 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(141, 26, 60, 1540, 40, 420)}${gl.el}` +
    `<line x1="800" y1="0" x2="800" y2="180" stroke="#0F2429" stroke-width="18"/>` +
    lantern(800, 460, 2.6) +
    `${hills('#12333A', 1030, 50)}<path d="M0 ${H} L0 1030 H ${W} V ${H} Z" fill="#0E282E" opacity="0"/>`);
});

add('kids_hadith', () => {
  const s = skyV([[0, '#43593C'], [1, '#28392B']]);
  const gl = glow(800, 600, 460, CREAM, 0.35);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(151, 20, 60, 1540, 40, 320)}${gl.el}${crescent(1290, 230, 84, IVORY, '#43593C')}` +
    openBook(800, 640, 2.1) +
    `${hills('#2C3A28', 1010, 60)}`);
});

add('kids_duas', () => {
  const s = skyV([[0, '#4A3560'], [1, '#2C2144']]);
  const gl = glow(800, 560, 380, IVORY, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(161, 34, 60, 1540, 40, 520)}${gl.el}` +
    archWindow(800, 640, 560, 700, '#1D1733', '#7A5FA0') +
    crescent(800, 520, 90, IVORY, '#7A5FA0') +
    `<circle cx="680" cy="440" r="9" fill="${IVORY}" opacity="0.9"/><circle cx="930" cy="400" r="7" fill="${IVORY}" opacity="0.7"/><circle cx="890" cy="640" r="8" fill="${IVORY}" opacity="0.8"/>` +
    `<path d="M0 ${H} L0 1000 H ${W} V ${H} Z" fill="#1A142E"/>`);
});

add('kids_games', () => {
  const s = skyV([[0, '#31547A'], [1, '#1F3A57']]);
  return svgDoc(`<defs>${s.def}</defs>${s.rect}${stars(171, 22, 60, 1540, 40, 420)}` +
    `<ellipse cx="300" cy="260" rx="170" ry="56" fill="${IVORY}" opacity="0.4"/><ellipse cx="1290" cy="760" rx="190" ry="60" fill="${IVORY}" opacity="0.28"/>` +
    kite(940, 460, 2.1) +
    star8(330, 760, 96, GOLD, CREAM) +
    `${hills('#27476A', 1060, 60)}`);
});

add('kids_hadith_stories', () => {
  const s = skyV([[0, '#8A5A36'], [1, '#54382A']]);
  const gl = glow(800, 580, 440, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(181, 16, 60, 1540, 40, 300, CREAM)}${gl.el}` +
    scroll(800, 600, 1.9) +
    lantern(1290, 780, 1.1) +
    `${hills('#3D2A20', 1030, 50)}`);
});

add('kids_prophet_stories', () => {
  const s = skyV([[0, '#2B3563'], [0.7, '#5A3D67'], [1, '#8A5348']]);
  const gl = glow(560, 300, 320, CREAM, 0.55);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(191, 36, 60, 1540, 40, 520)}${gl.el}` +
    star8(560, 300, 130, CREAM, GOLD) +
    dunes('#4A3560', '#332450', 920) +
    palm(1150, 1120, 1.15, '#241C3E') +
    `<path d="M0 ${H} L0 1120 H ${W} V ${H} Z" fill="#1D1733"/>`);
});

add('kids_seerah', () => {
  const s = skyV([[0, '#4A5D8A'], [0.6, '#B0743B'], [1, '#E8B36A']]);
  const gl = glow(1240, 700, 320, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(201, 12, 60, 1540, 40, 260)}${crescent(260, 220, 84, IVORY, '#4A5D8A')}` +
    dunes('#8A5A36', '#6E4629', 880) + `${gl.el}` +
    `<g opacity="0.9">${mosqueSilhouette(1270, 860, 0.4, '#54382A')}</g>` +
    `<path d="M 320 1180 Q 560 1060 800 1080 Q 1080 1100 1240 900" stroke="${CREAM}" stroke-width="22" stroke-linecap="round" stroke-dasharray="4 60" fill="none" opacity="0.9"/>` +
    palm(360, 1010, 0.85, '#54382A') +
    `<path d="M0 ${H} L0 1130 Q 800 1080 1600 1120 V ${H} Z" fill="#4A2F22"/>`);
});

add('kids_fun_learning', () => {
  const s = skyV([[0, '#4A3560'], [0.6, '#31547A'], [1, '#1F4A4C']]);
  const gl = glow(800, 560, 420, CREAM, 0.35);
  let splashes = '';
  const cols = ['#E2C177', '#F5E7BE', '#A9C79B', '#7A9AA8', '#C98A9A'];
  const rnd = mulberry32(9);
  for (let i = 0; i < 12; i++) {
    splashes += `<circle cx="${(300 + rnd() * 1000).toFixed(0)}" cy="${(260 + rnd() * 420).toFixed(0)}" r="${(14 + rnd() * 26).toFixed(0)}" fill="${cols[i % 5]}" opacity="0.85"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(211, 24, 60, 1540, 40, 400)}${gl.el}${splashes}` +
    `<ellipse cx="700" cy="880" rx="330" ry="200" fill="#EFE3C0"/>` +
    `<circle cx="560" cy="820" r="44" fill="#E2C177"/><circle cx="700" cy="790" r="44" fill="#A9C79B"/><circle cx="840" cy="820" r="44" fill="#7A9AA8"/><circle cx="620" cy="930" r="44" fill="#C98A9A"/>` +
    `<circle cx="810" cy="950" r="58" fill="#D8C49A"/>` +
    `<g transform="rotate(-34 1150 640)"><rect x="1120" y="380" width="60" height="380" rx="26" fill="#8A5A36"/><path d="M 1120 760 h 60 l -8 90 q -22 34 -44 0 Z" fill="${CREAM}"/></g>` +
    `${hills('#173B40', 1070, 50)}`);
});

for (const [name, fn] of scenes) {
  writeFileSync(join(OUT, `${name}.svg`), fn());
  console.log('wrote', name);
}
console.log(`${scenes.length} scenes`);
