// Path of Nur — "Storybook" card art generator.
// v2 (2026-08-28): palette consolidated to 5 sky recipes anchored to app theme
// tokens (lib/core/theme/app_backgrounds.dart), scrim-safe composition (hero at
// ~40-45% line, calm bottom band, shared ~80% horizon), two-layer glows,
// de-duplicated heroes, kids day palettes + bloom cameo, level-journey arc.
// Style rules: soft gradient skies, large calm silhouettes, warm ivory light,
// gold accents; no faces, no figures, no text baked into artwork
// (single Arabic letterforms in kids_arabic are pictorial subjects, not copy).
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const OUT = fileURLToPath(new URL('./svg/', import.meta.url));
mkdirSync(OUT, { recursive: true });

const W = 1600, H = 1200;
const GY = 950; // shared ground line (~80% height) so card rows align
const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';

// Five sky recipes tied to the app's background gradients.
const SKY = {
  dawn: [[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']],
  day: [[0, '#31547A'], [0.6, '#7A9AA8'], [1, '#E8C089']],
  night: [[0, '#121423'], [0.55, '#1A1F33'], [1, '#232A44']], // app night bg trio
  emerald: [[0, '#0D271E'], [0.5, '#16382C'], [1, '#2E5D48']], // Masjid Emerald family
  emeraldLift: [[0, '#1E4B3A'], [0.55, '#2E5D48'], [1, '#7C7F58']],
  violet: [[0, '#151024'], [0.55, '#211A38'], [1, '#2C2347']], // Layali family
  violetLift: [[0, '#211A38'], [0.6, '#2C2347'], [1, '#4A3560']],
  violetDusk: [[0, '#2C2347'], [0.6, '#4A3560'], [1, '#8A5348']],
  amber: [[0, '#B0743B'], [0.6, '#D19A56'], [1, '#E8C089']],
};

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

// two-layer glow: bright core + wide faint halo (cleaner falloff than one haze)
function glow2(cx, cy, r, color, a = 0.5) {
  const halo = glow(cx, cy, r, color, a * 0.42);
  const core = glow(cx, cy, r * 0.46, color, a);
  return { def: halo.def + core.def, el: halo.el + core.el };
}

function stars(seed, n, x0, x1, y0, y1, color = IVORY) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0);
    const y = y0 + rnd() * (y1 - y0);
    const r = 2.0 + rnd() * 2.2;
    const o = 0.5 + rnd() * 0.38;
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${r.toFixed(1)}" fill="${color}" opacity="${o.toFixed(2)}"/>`;
  }
  return out;
}

// waxing crescent drawn as a single path (no sky-colored cutout — safe over gradients)
function crescent(cx, cy, r, lit) {
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

// calm flat band from the shared ground line down — kept quiet for the card scrim
function groundBand(color, y = GY) {
  return `<path d="M0 ${H} L0 ${y} Q 800 ${y - 26} 1600 ${y} V ${H} Z" fill="${color}"/>`;
}

function cloud(cx, cy, rx, ry, op) {
  return `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="${IVORY}" opacity="${op}"/>`;
}

function sparkle(x, y, r, fill = GOLD, op = 0.9) {
  return `<path d="M ${x} ${y - r} L ${x + r * 0.28} ${y - r * 0.28} L ${x + r} ${y} L ${x + r * 0.28} ${y + r * 0.28} L ${x} ${y + r} L ${x - r * 0.28} ${y + r * 0.28} L ${x - r} ${y} L ${x - r * 0.28} ${y - r * 0.28} Z" fill="${fill}" opacity="${op}"/>`;
}

// mosque silhouette: central dome + finial + optional minarets + body
function dome(cx, baseY, rx, color) {
  const ry = rx * 1.06;
  return `<path d="M ${cx - rx} ${baseY} A ${rx} ${ry} 0 0 1 ${cx + rx} ${baseY} Z" fill="${color}"/>` +
    `<rect x="${cx - 5}" y="${baseY - ry - 52}" width="10" height="58" rx="5" fill="${color}"/>` +
    crescent(cx, baseY - ry - 82, 26, color);
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

// cord from the top edge down to a hanging lantern's own hook line
function hangLine(cx, yTo, s, color = GOLD, yFrom = 0) {
  return `<line x1="${cx}" y1="${yFrom}" x2="${cx}" y2="${yTo}" stroke="${color}" stroke-width="${8 * s}"/>`;
}

// shepherd-hook lamp post used along the level-journey road
function lampPost(x, gy, s) {
  const ls = 0.9 * s;
  const poleTop = gy - 420 * s;
  const armEndX = x + 46 * s, armEndY = poleTop + 40 * s;
  const cy = armEndY + 210 * ls;
  const gl = glow(armEndX, cy - 40 * ls, 170 * s, '#F5D57B', 0.4);
  return {
    def: gl.def,
    el: `<rect x="${x - 7 * s}" y="${poleTop}" width="${14 * s}" height="${420 * s}" rx="${6 * s}" fill="#241C3E"/>` +
      `<path d="M ${x} ${poleTop} q ${44 * s} 4 ${46 * s} ${40 * s}" stroke="#241C3E" stroke-width="${12 * s}" fill="none"/>` +
      gl.el + lantern(armEndX, cy, ls),
  };
}

// rehal: iconic X-shaped folding stand with a thick open mushaf resting in the V.
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
  if (inner) g += star8(cx, cy, r * 0.5, inner);
  return g;
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

// small potted-bloom cameo — the approved kids character, reused across kids scenes
function bloomPot(cx, gy, s) {
  let petals = '';
  for (let i = 0; i < 5; i++) {
    const a = -Math.PI / 2 + (i * Math.PI * 2) / 5;
    petals += `<circle cx="${(cx + 24 * s * Math.cos(a)).toFixed(0)}" cy="${(gy - 214 * s + 24 * s * Math.sin(a)).toFixed(0)}" r="${18 * s}" fill="${CREAM}"/>`;
  }
  return `<ellipse cx="${cx}" cy="${gy}" rx="${92 * s}" ry="${13 * s}" fill="#000" opacity="0.14"/>` +
    `<path d="M ${cx - 62 * s} ${gy - 84 * s} h ${124 * s} l ${-16 * s} ${84 * s} h ${-92 * s} Z" fill="#A5633C"/>` +
    `<rect x="${cx - 74 * s}" y="${gy - 112 * s}" width="${148 * s}" height="${30 * s}" rx="${10 * s}" fill="#B4714A"/>` +
    `<path d="M ${cx} ${gy - 112 * s} C ${cx} ${gy - 150 * s} ${cx} ${gy - 170 * s} ${cx - 2 * s} ${gy - 192 * s}" stroke="#3E5A34" stroke-width="${9 * s}" fill="none" stroke-linecap="round"/>` +
    `<path d="M ${cx - 2 * s} ${gy - 148 * s} C ${cx - 34 * s} ${gy - 146 * s} ${cx - 52 * s} ${gy - 130 * s} ${cx - 58 * s} ${gy - 112 * s} C ${cx - 30 * s} ${gy - 114 * s} ${cx - 10 * s} ${gy - 128 * s} ${cx - 4 * s} ${gy - 142 * s} Z" fill="#4C6742"/>` +
    petals + `<circle cx="${cx}" cy="${gy - 214 * s}" r="${13 * s}" fill="${GOLD}"/>`;
}

// reed pen
function qalam(cx, cy, s, deg) {
  return `<g transform="rotate(${deg} ${cx} ${cy})">` +
    `<rect x="${cx - 160 * s}" y="${cy - 13 * s}" width="${280 * s}" height="${26 * s}" rx="${13 * s}" fill="#8A5A36"/>` +
    `<rect x="${cx + 84 * s}" y="${cy - 13 * s}" width="${14 * s}" height="${26 * s}" fill="#54382A" opacity="0.6"/>` +
    `<path d="M ${cx + 118 * s} ${cy - 13 * s} L ${cx + 186 * s} ${cy} L ${cx + 118 * s} ${cy + 13 * s} Z" fill="#D8C49A"/>` +
    `<line x1="${cx + 150 * s}" y1="${cy}" x2="${cx + 186 * s}" y2="${cy}" stroke="#54382A" stroke-width="${3 * s}"/>` +
    `</g>`;
}

function inkwell(cx, gy, s) {
  return `<rect x="${cx - 55 * s}" y="${gy - 80 * s}" width="${110 * s}" height="${80 * s}" rx="${16 * s}" fill="#3D2A20"/>` +
    `<rect x="${cx - 26 * s}" y="${gy - 98 * s}" width="${52 * s}" height="${22 * s}" rx="${8 * s}" fill="${DEEPGOLD}"/>` +
    `<ellipse cx="${cx}" cy="${gy - 88 * s}" rx="${16 * s}" ry="${5 * s}" fill="${CREAM}" opacity="0.5"/>`;
}

// arched double door on a night hill — reserved for level_new_to_islam
function sceneDoor(sky1, sky2, doorGlow, frame, ground) {
  const s = skyV([[0, sky1], [1, sky2]]);
  const gl = glow2(800, 640, 460, doorGlow, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(11, 20, 60, 1540, 60, 500)}${crescent(1210, 210, 92, IVORY)}${hills(ground, 960, 70)}${gl.el}` +
    `<path d="M 640 1030 v -420 a 160 160 0 0 1 320 0 v 420 Z" fill="${frame}"/>` +
    `<path d="M 668 1030 v -400 a 132 132 0 0 1 264 0 v 400 Z" fill="${doorGlow}"/>` +
    `<path d="M 800 1030 v -540" stroke="${frame}" stroke-width="12"/>` +
    `<path d="M 700 1030 L 560 1120 M 900 1030 L 1040 1120" stroke="${doorGlow}" stroke-width="44" stroke-linecap="round" opacity="0.35"/>` +
    `<path d="M0 ${H} L0 1030 H ${W} V ${H} Z" fill="${ground}"/>` +
    // first steps of the journey road, leading to the threshold
    `<ellipse cx="690" cy="1150" rx="52" ry="17" fill="${CREAM}" opacity="0.9"/>` +
    `<ellipse cx="752" cy="1096" rx="42" ry="14" fill="${CREAM}" opacity="0.85"/>` +
    `<ellipse cx="790" cy="1052" rx="32" ry="11" fill="${CREAM}" opacity="0.8"/>`);
}

const scenes = [];
const add = (file, fn) => scenes.push([file, fn]);

/* ============================= ADULT ISLANDS ============================= */

add('island_foundations', () => {
  const s = skyV(SKY.dawn);
  const sun = glow2(800, 520, 430, CREAM, 0.8);
  const body = '#3D2117';
  const arches = [560, 800, 1040].map((x) =>
    `<path d="M ${x - 78} 940 v -140 a 78 78 0 0 1 156 0 v 140 Z" fill="#E8B36A"/>`).join('');
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${stars(11, 10, 60, 1540, 50, 260)}${sun.el}<circle cx="800" cy="520" r="108" fill="${CREAM}"/>` +
    hills('#5E3527', 905, 55) +
    `<rect x="330" y="700" width="940" height="240" fill="${body}"/>` + arches +
    dome(800, 700, 225, body) +
    minaret(250, 940, 470, 62, body) + minaret(1350, 940, 470, 62, body) +
    groundBand('#301A12', 940));
});

add('island_quran', () => {
  const s = skyV(SKY.night);
  const gl = glow2(800, 590, 470, '#F5D57B', 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(21, 28, 60, 1540, 50, 520)}${crescent(300, 220, 92, IVORY)}` +
    hills('#1D2038', 905, 55) + gl.el +
    `<ellipse cx="800" cy="902" rx="250" ry="22" fill="#0E1120" opacity="0.5"/>` +
    rehal(800, 900, 1.5) +
    groundBand('#141728') +
    hangLine(1300, 260, 1.0) + lantern(1300, 410, 1.0));
});

add('island_worship', () => {
  const s = skyV(SKY.emerald);
  const gl = glow2(800, 560, 420, '#F5D57B', 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(31, 22, 60, 1540, 40, 380)}` +
    `<path d="M 430 950 v -400 a 370 420 0 0 1 740 0 v 400 Z" fill="#0A1F18"/>` +
    `<path d="M 480 950 v -372 a 320 372 0 0 1 640 0 v 372 Z" fill="#1E4B3A"/>${gl.el}` +
    hangLine(800, 350, 1.35, GOLD, 210) + lantern(800, 500, 1.35) +
    prayerMat(800, 940, 1.25, '#12332A', CREAM) +
    groundBand('#081B15'));
});

add('island_character', () => {
  const s = skyV(SKY.emeraldLift);
  const gl = glow2(640, 460, 440, CREAM, 0.34);
  let blossoms = '';
  const rnd = mulberry32(7);
  for (let i = 0; i < 18; i++) {
    const a = -Math.PI * 0.55 + rnd() * Math.PI * 0.75;
    const rr = 130 + rnd() * 130;
    blossoms += `<circle cx="${(650 + rr * Math.cos(a)).toFixed(0)}" cy="${(470 + rr * Math.sin(a) * 0.8).toFixed(0)}" r="${(9 + rnd() * 10).toFixed(0)}" fill="${rnd() > 0.45 ? CREAM : GOLD}" opacity="0.95"/>`;
  }
  const petals = `<circle cx="920" cy="640" r="8" fill="${CREAM}" opacity="0.7"/><circle cx="980" cy="740" r="7" fill="${GOLD}" opacity="0.6"/><circle cx="890" cy="830" r="6" fill="${CREAM}" opacity="0.5"/>`;
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(261, 18, 60, 1540, 40, 300)}${crescent(1300, 210, 88, IVORY)}${gl.el}` +
    hills('#3A4A33', 905, 70) +
    `<circle cx="540" cy="530" r="165" fill="#33452C"/><circle cx="770" cy="545" r="150" fill="#33452C"/><circle cx="650" cy="420" r="185" fill="#33452C"/>` +
    `<circle cx="490" cy="580" r="115" fill="#3F5438"/><circle cx="820" cy="590" r="108" fill="#3F5438"/><circle cx="590" cy="470" r="140" fill="#3F5438"/><circle cx="740" cy="470" r="130" fill="#3F5438"/>` +
    `<circle cx="600" cy="400" r="88" fill="#4C6742"/><circle cx="712" cy="390" r="96" fill="#4C6742"/><circle cx="666" cy="500" r="110" fill="#46603E"/>` +
    blossoms + petals +
    `<path d="M 636 960 C 632 860 636 790 650 706" stroke="#4A3526" stroke-width="62" fill="none" stroke-linecap="round"/>` +
    `<path d="M 648 730 C 610 668 566 636 502 620" stroke="#4A3526" stroke-width="27" fill="none" stroke-linecap="round"/>` +
    `<path d="M 652 716 C 702 662 756 640 812 636" stroke="#4A3526" stroke-width="27" fill="none" stroke-linecap="round"/>` +
    `<path d="M 650 720 C 658 648 672 596 700 548" stroke="#4A3526" stroke-width="20" fill="none" stroke-linecap="round"/>` +
    `<line x1="812" y1="636" x2="812" y2="676" stroke="${DEEPGOLD}" stroke-width="7"/>` +
    lantern(812, 856, 0.8) +
    `<circle cx="884" cy="770" r="6" fill="${CREAM}" opacity="0.8"/><circle cx="760" cy="810" r="5" fill="${GOLD}" opacity="0.7"/><circle cx="910" cy="880" r="5" fill="${GOLD}" opacity="0.55"/>` +
    groundBand('#242F20') +
    `<path d="M 300 950 q 8 -34 0 -52 M 322 950 q 10 -26 4 -44 M 1180 950 q -8 -34 0 -52 M 1158 950 q -10 -26 -4 -44" stroke="#3A4A33" stroke-width="10" fill="none" stroke-linecap="round"/>` +
    `<circle cx="342" cy="898" r="9" fill="${GOLD}" opacity="0.9"/><circle cx="1142" cy="898" r="9" fill="${CREAM}" opacity="0.9"/>`);
});

add('island_stories', () => {
  const s = skyV(SKY.violetDusk);
  const gl = glow2(1180, 310, 340, IVORY, 0.55);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(41, 24, 60, 1540, 40, 460)}${gl.el}${fullMoon(1180, 310, 105, IVORY)}` +
    `<g opacity="0.85">${mosqueSilhouette(430, 870, 0.52, '#241C3E')}</g>` +
    dunes('#4A3560', '#332450', 880) +
    palm(1210, 1080, 1.0, '#241C3E') +
    `<path d="M0 ${H} L0 1080 H ${W} V ${H} Z" fill="#1D1733"/>`);
});

// Games & Quizzes: interlocking octagram tiles, one lifting into place
add('island_games', () => {
  const s = skyV(SKY.night);
  const gl = glow2(760, 430, 320, '#F5D57B', 0.6);
  // outline of the empty slot the lifted piece belongs in
  const slotPts = [];
  for (let i = 0; i < 16; i++) {
    const a = (Math.PI / 8) * i - Math.PI / 2;
    const rr = i % 2 === 0 ? 140 : 140 * 0.42;
    slotPts.push(`${(760 + rr * Math.cos(a)).toFixed(1)},${(790 + rr * Math.sin(a)).toFixed(1)}`);
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(51, 22, 60, 1540, 40, 380)}${crescent(250, 210, 74, IVORY)}` +
    hills('#1D2038', 905, 55) +
    `<ellipse cx="470" cy="934" rx="170" ry="18" fill="#0E1120" opacity="0.5"/>` +
    `<ellipse cx="1050" cy="934" rx="170" ry="18" fill="#0E1120" opacity="0.5"/>` +
    star8(470, 790, 140, DEEPGOLD, '#8A6A34') +
    star8(1050, 790, 140, DEEPGOLD, '#8A6A34') +
    `<polygon points="${slotPts.join(' ')}" fill="none" stroke="${GOLD}" stroke-width="8" stroke-dasharray="20 22" opacity="0.55"/>` +
    gl.el +
    `<g transform="rotate(-14 760 420)">${star8(760, 420, 128, GOLD, CREAM)}</g>` +
    sparkle(620, 330, 16) + sparkle(930, 500, 13) + sparkle(880, 280, 10) +
    groundBand('#141728'));
});

/* ============================= GUIDED PATHS ============================= */

// five glowing arches at dawn — the pillars the deen rests on
add('path_foundations', () => {
  const s = skyV(SKY.dawn);
  const sun = glow2(800, 460, 420, CREAM, 0.7);
  const arches = [420, 610, 800, 990, 1180].map((x, i) =>
    `<path d="M ${x - 80} 940 v -160 a 80 80 0 0 1 160 0 v 160 Z" fill="${i === 2 ? '#F0D89A' : '#E8B36A'}"/>`).join('');
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${stars(61, 10, 60, 1540, 40, 240)}${sun.el}` +
    `<circle cx="800" cy="450" r="95" fill="${CREAM}"/>` +
    hills('#5E4030', 905, 50) +
    `<rect x="230" y="620" width="1140" height="320" fill="#3D2A20"/>` +
    `<rect x="230" y="600" width="1140" height="22" fill="#54382A"/>` +
    arches +
    groundBand('#33241B', 940));
});

add('path_salah', () => {
  const s = skyV(SKY.dawn);
  const sun = glow2(800, 830, 380, CREAM, 0.7);
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}${stars(71, 10, 60, 1540, 40, 300)}${sun.el}<circle cx="800" cy="830" r="88" fill="${CREAM}"/>` +
    hills('#5E4030', 905, 55) +
    minaret(280, 950, 640, 78, '#3D2A20') +
    `<g opacity="0.94">${mosqueSilhouette(1150, 950, 0.58, '#3D2A20')}</g>` +
    groundBand('#33241B'));
});

// learning to read: open book, rays of first light, a reed pen at rest
add('path_quran_beginner', () => {
  const s = skyV(SKY.amber);
  const gl = glow2(800, 540, 460, CREAM, 0.6);
  let rays = '';
  for (let i = 0; i < 7; i++) {
    const a = -Math.PI / 2 + (i - 3) * 0.3;
    rays += `<line x1="800" y1="520" x2="${800 + 540 * Math.cos(a)}" y2="${520 + 540 * Math.sin(a)}" stroke="${CREAM}" stroke-width="26" stroke-linecap="round" opacity="0.22"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${rays}${gl.el}` +
    `<ellipse cx="800" cy="950" rx="580" ry="100" fill="#8A5A36"/>` +
    openBook(800, 540, 2.1) +
    qalam(1120, 830, 1.5, -10) +
    groundBand('#6E4629'));
});

add('path_daily_dhikr', () => {
  const s = skyV(SKY.night);
  const gl = glow2(800, 560, 440, '#F5D57B', 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(81, 32, 60, 1540, 40, 480)}${crescent(1230, 240, 100, IVORY)}${gl.el}` +
    `<ellipse cx="800" cy="946" rx="620" ry="90" fill="#1D2038"/>` +
    misbaha(800, 560, 270) +
    groundBand('#141728'));
});

add('path_character', () => {
  const s = skyV(SKY.emeraldLift);
  const gl = glow2(800, 520, 380, CREAM, 0.4);
  const bloom = glow2(792, 500, 150, '#F5D57B', 0.55);
  let petals = '';
  for (let i = 0; i < 5; i++) {
    const a = -Math.PI / 2 + (i * Math.PI * 2) / 5;
    petals += `<circle cx="${(792 + 40 * Math.cos(a)).toFixed(0)}" cy="${(504 + 40 * Math.sin(a)).toFixed(0)}" r="30" fill="${CREAM}"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}${bloom.def}</defs>${s.rect}${stars(91, 20, 60, 1540, 40, 360)}${gl.el}${crescent(300, 230, 84, IVORY)}` +
    `<ellipse cx="800" cy="944" rx="200" ry="24" fill="#1C2418"/>` +
    `<path d="M 686 804 h 228 l -30 140 h -168 Z" fill="#A5633C"/>` +
    `<path d="M 686 804 h 228 l -30 140 h -84 q 40 -60 22 -140 Z" fill="#8A4F30" opacity="0.55"/>` +
    `<rect x="668" y="762" width="264" height="46" rx="14" fill="#B4714A"/>` +
    `<path d="M 716 886 l 22 -22 22 22 22 -22 22 22 22 -22 22 22 22 -22 22 22" stroke="${CREAM}" stroke-width="7" fill="none" opacity="0.55"/>` +
    `<ellipse cx="800" cy="776" rx="112" ry="15" fill="#3A2A20"/>` +
    `<path d="M 800 776 C 798 720 802 666 794 598" stroke="#3E5A34" stroke-width="16" fill="none" stroke-linecap="round"/>` +
    `<path d="M 798 712 C 742 704 700 676 686 624 C 740 618 786 648 798 690 Z" fill="#4C6742"/>` +
    `<path d="M 800 666 C 856 654 894 622 902 570 C 848 568 806 602 799 646 Z" fill="#3F5438"/>` +
    `<path d="M 796 620 C 758 610 734 590 726 558 C 762 556 790 578 795 606 Z" fill="#4C6742"/>` +
    `${bloom.el}${petals}<circle cx="792" cy="504" r="22" fill="${GOLD}"/>` +
    sparkle(700, 428, 16) + sparkle(886, 450, 13) + sparkle(846, 382, 10) +
    groundBand('#242F20') +
    `<path d="M 560 950 q 8 -30 0 -46 M 1044 950 q -8 -30 0 -46" stroke="#3A4A33" stroke-width="9" fill="none" stroke-linecap="round"/>`);
});

add('path_stories', () => {
  const s = skyV(SKY.violetDusk);
  const gl = glow2(800, 520, 380, IVORY, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(101, 24, 60, 1540, 40, 420)}${gl.el}${crescent(800, 310, 96, IVORY)}` +
    `<path d="M 260 860 C 400 780 640 780 800 860 C 960 780 1200 780 1340 860 L 1340 1020 C 1200 940 960 940 800 1020 C 640 940 400 940 260 1020 Z" fill="#EFE3C0"/>` +
    `<path d="M 320 866 Q 560 810 780 868 Q 700 812 560 808 Q 430 810 320 866 Z" fill="#C9A25E" opacity="0.7"/>` +
    `<path d="M 830 866 Q 1060 808 1290 864 Q 1180 810 1040 810 Q 930 812 830 866 Z" fill="#C9A25E" opacity="0.7"/>` +
    `<line x1="800" y1="860" x2="800" y2="1020" stroke="#8A7A54" stroke-width="8" opacity="0.5"/>` +
    `<path d="M0 ${H} L0 1020 C 400 940 1200 940 1600 1020 V ${H} Z" fill="#1D1733"/>`);
});

add('path_kids_starter', () => {
  const s = skyV(SKY.day);
  const gl = glow2(1240, 780, 300, CREAM, 0.5);
  let stones = '';
  const pts = [[430, 1120], [610, 1060], [790, 1020], [960, 970], [1110, 920]];
  pts.forEach(([x, y], i) => { stones += `<ellipse cx="${x}" cy="${y}" rx="${86 - i * 8}" ry="${30 - i * 2}" fill="${CREAM}" opacity="0.95"/>`; });
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(320, 260, 160, 54, 0.5) + cloud(1200, 180, 190, 60, 0.4) +
    hills('#5E8A6A', 880, 90) + gl.el +
    `<g opacity="0.95">${mosqueSilhouette(1250, 900, 0.42, '#33544A')}</g>` +
    `<path d="M0 ${H} L0 980 Q 800 900 1600 960 V ${H} Z" fill="#4A7A58"/>${stones}` +
    star8(260, 480, 74, CREAM) +
    bloomPot(1430, 1150, 0.85));
});

/* ============================= LEVEL PATHS =============================
   One journey, four stations: threshold door → lantern-lit road →
   night of study → moonlit shore with the pearl. */

add('level_new_to_islam', () => sceneDoor('#121423', '#3A2E63', '#F0D89A', '#141728', '#1A142E'));

add('level_building_consistency', () => {
  const s = skyV(SKY.night);
  const posts = [[430, 1110, 1.0], [700, 1030, 0.88], [950, 960, 0.76], [1150, 905, 0.66], [1310, 860, 0.56]]
    .map(([x, gy, ps]) => lampPost(x, gy, ps));
  return svgDoc(`<defs>${s.def}${posts.map((p) => p.def).join('')}</defs>${s.rect}` +
    stars(111, 26, 60, 1540, 40, 420) + crescent(230, 210, 78, IVORY) +
    hills('#1D2038', 905, 60) + groundBand('#141728') +
    `<path d="M 250 1160 Q 560 1080 830 1010 T 1330 880" stroke="${CREAM}" stroke-width="20" stroke-linecap="round" stroke-dasharray="4 56" fill="none" opacity="0.85"/>` +
    posts.map((p) => p.el).join(''));
});

add('level_deepening_knowledge', () => {
  const s = skyV(SKY.night);
  const gl = glow2(680, 580, 430, '#F5D57B', 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(121, 40, 60, 1540, 40, 520)}${gl.el}` +
    hills('#1D2038', 905, 55) +
    `<ellipse cx="760" cy="936" rx="560" ry="26" fill="#0E1120" opacity="0.5"/>` +
    openBook(660, 600, 1.8) +
    inkwell(1390, 905, 1.05) +
    qalam(1050, 885, 1.2, -8) +
    groundBand('#141728'));
});

add('level_refinement', () => {
  const s = skyV(SKY.violet);
  const moon = glow2(880, 290, 330, IVORY, 0.6);
  const pearl = glow2(880, 878, 230, CREAM, 0.9);
  let shimmer = '';
  [716, 746, 776].forEach((y, i) => {
    shimmer += `<ellipse cx="880" cy="${y}" rx="${100 + i * 36}" ry="6" fill="${IVORY}" opacity="${(0.1 - i * 0.03).toFixed(3)}"/>`;
  });
  return svgDoc(`<defs>${s.def}${moon.def}${pearl.def}</defs>${s.rect}${stars(131, 30, 60, 1540, 40, 520)}${moon.el}${fullMoon(880, 290, 92, IVORY)}` +
    `<rect x="0" y="700" width="${W}" height="260" fill="#141B33"/>` +
    `<rect x="0" y="700" width="${W}" height="5" fill="#24314E" opacity="0.7"/>` +
    shimmer +
    `<path d="M0 ${H} L0 960 Q 800 918 1600 960 V ${H} Z" fill="#2A2142"/>` +
    `<g transform="rotate(-6 880 936)"><path d="M 780 936 A 100 100 0 0 1 980 936 Z" fill="#B79661"/>` +
    `<path d="M 880 936 L 810 868 M 880 936 L 880 838 M 880 936 L 950 868" stroke="#8A6A34" stroke-width="7" opacity="0.8"/></g>` +
    `${pearl.el}<circle cx="880" cy="878" r="46" fill="${CREAM}"/><circle cx="866" cy="864" r="12" fill="#FFFDF2" opacity="0.95"/>` +
    `<ellipse cx="880" cy="942" rx="108" ry="22" fill="#EFE3C0"/>` +
    sparkle(770, 790, 13, CREAM) + sparkle(994, 812, 10, CREAM));
});

/* ============================= KIDS ============================= */

// stack of storybooks with a ribbon bookmark
add('kids_story_library', () => {
  const s = skyV(SKY.violetLift);
  const gl = glow2(800, 620, 420, CREAM, 0.5);
  const book = (cx, y, h, w, c, r) =>
    `<g transform="rotate(${r} ${cx} ${y + h / 2})"><rect x="${cx - w / 2}" y="${y}" width="${w}" height="${h}" rx="20" fill="${c}"/>` +
    `<rect x="${cx + w / 2 - 34}" y="${y + 14}" width="26" height="${h - 28}" rx="8" fill="${CREAM}" opacity="0.85"/></g>`;
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(141, 24, 60, 1540, 40, 440)}${crescent(1270, 230, 80, IVORY)}${gl.el}` +
    `<ellipse cx="800" cy="902" rx="330" ry="26" fill="#141026" opacity="0.55"/>` +
    book(810, 745, 120, 560, '#6E3F2E', 1.5) +
    book(775, 640, 108, 510, '#8A5A36', -2.5) +
    book(830, 540, 104, 460, '#B0743B', 2) +
    crescent(700, 592, 28, CREAM) +
    `<path d="M 930 548 C 950 620 940 660 975 692" stroke="${GOLD}" stroke-width="20" fill="none" stroke-linecap="round"/>` +
    `<path d="M 975 692 l 30 -10 -14 32 Z" fill="${GOLD}"/>` +
    sparkle(560, 450, 14) + sparkle(1050, 420, 11) +
    hills('#241C3E', 905, 55) + groundBand('#1A142E'));
});

add('kids_quran', () => {
  const s = skyV(SKY.day);
  const sun = glow2(1200, 290, 300, CREAM, 0.7);
  return svgDoc(`<defs>${s.def}${sun.def}</defs>${s.rect}` +
    cloud(330, 240, 160, 52, 0.5) + cloud(900, 170, 140, 46, 0.38) +
    `${sun.el}<circle cx="1200" cy="290" r="84" fill="${CREAM}"/>` +
    hills('#5E8A6A', 880, 80) +
    `<ellipse cx="760" cy="902" rx="210" ry="20" fill="#2C4A33" opacity="0.5"/>` +
    rehal(760, 900, 1.2, '#54382A') +
    bloomPot(1090, 900, 0.7) +
    `<path d="M0 ${H} L0 950 Q 800 910 1600 950 V ${H} Z" fill="#4A7A58"/>` +
    sparkle(520, 560, 13, CREAM) + sparkle(980, 500, 11, CREAM));
});

// first letters, floating like balloons: ta, alif, ba
add('kids_arabic', () => {
  const s = skyV(SKY.day);
  const gl = glow2(820, 480, 400, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(280, 210, 150, 50, 0.5) + cloud(1330, 300, 170, 56, 0.4) + gl.el +
    // ta (small, cream) upper-left
    `<path d="M 280 300 C 280 384 326 410 402 410 C 478 410 524 384 524 300" stroke="${CREAM}" stroke-width="32" fill="none" stroke-linecap="round"/>` +
    `<circle cx="376" cy="248" r="15" fill="${CREAM}"/><circle cx="428" cy="248" r="15" fill="${CREAM}"/>` +
    // alif (tall, gold) center-left
    `<path d="M 660 320 C 648 430 648 540 664 646 " stroke="${GOLD}" stroke-width="48" fill="none" stroke-linecap="round"/>` +
    // ba (wide, gold) right
    `<path d="M 850 470 C 850 610 928 650 1040 650 C 1152 650 1230 610 1230 470" stroke="${GOLD}" stroke-width="46" fill="none" stroke-linecap="round"/>` +
    `<circle cx="1040" cy="716" r="24" fill="${DEEPGOLD}"/>` +
    sparkle(560, 250, 14) + sparkle(1310, 560, 12) + sparkle(760, 720, 10, CREAM) +
    hills('#5E8A6A', 905, 70) + groundBand('#4A7A58'));
});

add('kids_hadith', () => {
  const s = skyV(SKY.emeraldLift);
  const gl = glow2(740, 560, 440, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(151, 14, 60, 1540, 40, 300)}${gl.el}${crescent(1290, 220, 78, IVORY)}` +
    openBook(740, 560, 2.0) +
    bloomPot(1330, 935, 0.62) +
    hills('#2C4A33', 905, 60) + groundBand('#1F3626'));
});

// misbaha draped on an arched windowsill, light rising to the crescent
add('kids_duas', () => {
  const s = skyV(SKY.violetLift);
  const gl = glow2(800, 540, 380, IVORY, 0.42);
  let beads = '';
  for (let i = 0; i <= 14; i++) {
    const t = i / 14;
    const x = (1 - t) * (1 - t) * 660 + 2 * (1 - t) * t * 800 + t * t * 940;
    const y = (1 - t) * (1 - t) * 872 + 2 * (1 - t) * t * 952 + t * t * 872;
    beads += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="14" fill="${i % 7 === 0 ? CREAM : GOLD}"/>`;
  }
  const rising = [[780, 770, 9, 0.85], [830, 692, 8, 0.7], [768, 616, 7, 0.6], [842, 540, 6, 0.5], [792, 470, 5, 0.4]]
    .map(([x, y, r, o]) => `<circle cx="${x}" cy="${y}" r="${r}" fill="${IVORY}" opacity="${o}"/>`).join('');
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(161, 26, 60, 1540, 40, 480)}${gl.el}` +
    archWindow(800, 540, 540, 660, '#1A142E', '#7A5FA0') +
    crescent(880, 400, 74, IVORY) + rising +
    `<rect x="500" y="866" width="600" height="30" rx="12" fill="#332450"/>` +
    beads +
    `<line x1="940" y1="886" x2="940" y2="948" stroke="${GOLD}" stroke-width="8"/>` +
    `<circle cx="940" cy="962" r="15" fill="${CREAM}"/>` +
    groundBand('#1A142E'));
});

add('kids_games', () => {
  const s = skyV(SKY.day);
  return svgDoc(`<defs>${s.def}</defs>${s.rect}` +
    cloud(300, 240, 170, 56, 0.45) + cloud(1290, 720, 190, 60, 0.28) +
    kite(420, 330, 0.8, CREAM, GOLD) +
    kite(940, 460, 2.0) +
    star8(300, 750, 92, GOLD, CREAM) +
    hills('#5E8A6A', 905, 70) + groundBand('#4A7A58'));
});

add('kids_hadith_stories', () => {
  const s = skyV(SKY.amber);
  const gl = glow2(780, 540, 430, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(171, 12, 60, 1540, 40, 280, CREAM)}${gl.el}` +
    scroll(780, 540, 1.8) +
    hangLine(1290, 330, 1.0) + lantern(1290, 480, 1.0) +
    hills('#8A5A36', 905, 50) + groundBand('#54382A'));
});

add('kids_prophet_stories', () => {
  const s = skyV(SKY.violetDusk);
  const gl = glow2(560, 300, 320, CREAM, 0.55);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(181, 26, 60, 1540, 40, 500)}${gl.el}` +
    star8(560, 300, 130, CREAM, GOLD) +
    dunes('#4A3560', '#332450', 900) +
    palm(1150, 1090, 1.1, '#241C3E') +
    `<path d="M0 ${H} L0 1090 H ${W} V ${H} Z" fill="#1D1733"/>`);
});

add('kids_seerah', () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(1240, 700, 320, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${stars(191, 10, 60, 1540, 40, 260)}${crescent(260, 220, 84, IVORY)}` +
    dunes('#8A5A36', '#6E4629', 880) + gl.el +
    `<g opacity="0.9">${mosqueSilhouette(1270, 860, 0.4, '#54382A')}</g>` +
    `<path d="M 320 1180 Q 560 1060 800 1080 Q 1080 1100 1240 900" stroke="${CREAM}" stroke-width="22" stroke-linecap="round" stroke-dasharray="4 60" fill="none" opacity="0.9"/>` +
    palm(360, 1010, 0.85, '#54382A') +
    `<path d="M0 ${H} L0 1130 Q 800 1080 1600 1120 V ${H} Z" fill="#4A2F22"/>`);
});

// stacking blocks and a ball — play shapes in the set's own palette
add('kids_fun_learning', () => {
  const s = skyV(SKY.day);
  const gl = glow2(760, 620, 420, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(300, 220, 160, 54, 0.5) + cloud(1310, 320, 180, 58, 0.38) + gl.el +
    `<ellipse cx="700" cy="944" rx="300" ry="22" fill="#2C4A33" opacity="0.5"/>` +
    `<ellipse cx="1080" cy="944" rx="110" ry="16" fill="#2C4A33" opacity="0.5"/>` +
    `<g transform="rotate(-4 580 840)"><rect x="480" y="740" width="200" height="200" rx="26" fill="${GOLD}"/>${star8(580, 840, 54, CREAM)}</g>` +
    `<g transform="rotate(3 800 840)"><rect x="700" y="740" width="200" height="200" rx="26" fill="#A9C79B"/>${crescent(806, 840, 40, CREAM)}</g>` +
    `<g transform="rotate(-3 690 640)"><rect x="590" y="540" width="200" height="200" rx="26" fill="${CREAM}"/>${star8(690, 640, 48, GOLD)}</g>` +
    `<circle cx="1080" cy="876" r="64" fill="#7A9AA8"/>` +
    `<path d="M 1018 872 Q 1080 838 1142 872" stroke="${CREAM}" stroke-width="13" fill="none"/>` +
    sparkle(950, 480, 14) + sparkle(480, 620, 12, CREAM) +
    hills('#5E8A6A', 905, 70) + groundBand('#4A7A58'));
});

for (const [name, fn] of scenes) {
  writeFileSync(join(OUT, `${name}.svg`), fn());
  console.log('wrote', name);
}
console.log(`${scenes.length} scenes`);
