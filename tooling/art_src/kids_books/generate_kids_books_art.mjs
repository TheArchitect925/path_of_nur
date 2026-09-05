// Path of Nur — kids picture-book art (tier B: the pipeline, picture-book tier).
// Same visual language as kids_art / salah_art: gradient skies anchored to
// the app's theme recipes, calm silhouettes, warm ivory light, gold accents,
// no faces, no text baked in. What this tier adds: three depth layers,
// weather, animals with a little expression, the child cast drawn the way
// the salah trainer draws its figure (outline, plain face), and a firefly
// hidden on every unique scene. Prophets are never drawn: a prophet spread
// shows what the prophet saw.
//
// Usage (from the repo root):
//   node tooling/art_src/kids_books/generate_kids_books_art.mjs            # all
//   node tooling/art_src/kids_books/generate_kids_books_art.mjs yunus_     # a subset
//
// Output:
//   assets/images/kids_books/atlas/<name>.webp                (1600x1200)
//   assets/images/kids_books/scenes/<name>.webp               (1600x1200)
//   assets/images/kids_books/covers/<name>.webp               (1024x1024)
//   assets/images/prophets/bedtime_stories/covers/<p>_cover.webp     (1024x1024)
//   assets/images/prophets/bedtime_stories/backdrops/<p>_backdrop.webp (1600x1200)
import { mkdirSync, writeFileSync, statSync, unlinkSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { spawnSync } from 'node:child_process';

const HERE = fileURLToPath(new URL('./', import.meta.url));
const SVG_OUT = join(HERE, 'svg');
const ROOT = fileURLToPath(new URL('../../../', import.meta.url));
const OUT = {
  atlas: join(ROOT, 'assets/images/kids_books/atlas'),
  scenes: join(ROOT, 'assets/images/kids_books/scenes'),
  covers: join(ROOT, 'assets/images/kids_books/covers'),
  pbCovers: join(ROOT, 'assets/images/prophets/bedtime_stories/covers'),
  pbBackdrops: join(ROOT, 'assets/images/prophets/bedtime_stories/backdrops'),
};
const ONLY = process.argv.slice(2).filter((a) => !a.startsWith('--'));

// ------------------------------------------------------------- palette --
const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';
const INK = '#3A2A1E', INK_SOFT = '#4A3626';
const WOOD = '#6E4629', WOOD_DARK = '#3B2A1E', WOOD_LIGHT = '#8A5A36';
const SEA = '#1E4B6E', SEA_DEEP = '#12304A', SEA_LIGHT = '#4F7C9A', SEA_FOAM = '#A9C4CF';
const GREEN = '#2E5D48', GREEN_DEEP = '#16382C', LEAF = '#3F7A5E', LEAF_LIGHT = '#6FA07C';
const SAND = '#D9A05B', SAND_DARK = '#B0743B', SAND_LIGHT = '#E8C089';
const STONE = '#8A7F70', STONE_DARK = '#5E564C', STONE_LIGHT = '#B5AA98';
const WALL = '#D3A26A', WALL_DEEP = '#B8864F', FLOOR = '#6E4629';

const SKY = {
  dawn: [[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']],
  day: [[0, '#31547A'], [0.6, '#7A9AA8'], [1, '#E8C089']],
  dayClear: [[0, '#2F5A8C'], [0.6, '#7FA6C0'], [1, '#D9E2D2']],
  night: [[0, '#121423'], [0.55, '#1A1F33'], [1, '#232A44']],
  violet: [[0, '#151024'], [0.55, '#211A38'], [1, '#2C2347']],
  violetDusk: [[0, '#2C2347'], [0.6, '#4A3560'], [1, '#8A5348']],
  emeraldLift: [[0, '#1E4B3A'], [0.55, '#2E5D48'], [1, '#7C7F58']],
  amber: [[0, '#B0743B'], [0.6, '#D19A56'], [1, '#E8C089']],
  storm: [[0, '#1F2530'], [0.5, '#3E4A5E'], [1, '#6C7A8C']],
  black: [[0, '#05060B'], [0.7, '#0A0C16'], [1, '#101326']],
  deepSea: [[0, '#2A5F86'], [0.35, '#1E4B6E'], [1, '#0B1E30']],
  room: [[0, '#C99A63'], [0.7, '#D9AE78'], [1, '#E8C089']],
  roomEvening: [[0, '#8A5A36'], [0.7, '#B8864F'], [1, '#D3A26A']],
};

let W = 1600, H = 1200;
let DEFS = '';
let gradN = 0;

function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const f = (n) => Number(n).toFixed(1).replace(/\.0$/, '');

// ------------------------------------------------------------- helpers --
function skyRect(stops, y0 = 0, y1 = H, x0 = 0, x1 = W) {
  const id = `sky${gradN++}`;
  DEFS += `<linearGradient id="${id}" x1="0" y1="0" x2="0" y2="1">` +
    stops.map(([o, c]) => `<stop offset="${o}" stop-color="${c}"/>`).join('') +
    `</linearGradient>`;
  return `<rect x="${x0}" y="${y0}" width="${x1 - x0}" height="${y1 - y0}" fill="url(#${id})"/>`;
}

function glow(cx, cy, r, color, a = 0.5) {
  const id = `gl${gradN++}`;
  DEFS += `<radialGradient id="${id}"><stop offset="0" stop-color="${color}" stop-opacity="${a}"/><stop offset="0.5" stop-color="${color}" stop-opacity="${a * 0.4}"/><stop offset="1" stop-color="${color}" stop-opacity="0"/></radialGradient>`;
  return `<circle cx="${cx}" cy="${cy}" r="${r}" fill="url(#${id})"/>`;
}

function vignette(a = 0.28) {
  const id = `vg${gradN++}`;
  DEFS += `<radialGradient id="${id}" cx="0.5" cy="0.5" r="0.75"><stop offset="0.55" stop-color="#000" stop-opacity="0"/><stop offset="1" stop-color="#000" stop-opacity="${a}"/></radialGradient>`;
  return `<rect width="${W}" height="${H}" fill="url(#${id})"/>`;
}

function stars(seed, n, x0, x1, y0, y1, color = IVORY, big = 2.6) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0);
    out += `<circle cx="${f(x)}" cy="${f(y)}" r="${f(1.4 + rnd() * big)}" fill="${color}" opacity="${f(0.35 + rnd() * 0.55)}"/>`;
  }
  return out;
}

function crescent(cx, cy, r, lit = IVORY) {
  const id = `cr${gradN++}`;
  DEFS += `<mask id="${id}"><rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="black"/><circle cx="${cx}" cy="${cy}" r="${r}" fill="white"/><circle cx="${cx + r * 0.46}" cy="${cy - r * 0.2}" r="${r * 0.88}" fill="black"/></mask>`;
  return glow(cx, cy, r * 2.6, lit, 0.35) +
    `<rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="${lit}" mask="url(#${id})"/>`;
}

const fullMoon = (cx, cy, r, lit = IVORY) =>
  glow(cx, cy, r * 2.4, lit, 0.4) +
  `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${lit}"/>` +
  `<circle cx="${cx - r * 0.3}" cy="${cy - r * 0.15}" r="${r * 0.16}" fill="#DDD0A8" opacity="0.7"/>` +
  `<circle cx="${cx + r * 0.25}" cy="${cy + r * 0.3}" r="${r * 0.11}" fill="#DDD0A8" opacity="0.6"/>`;

function sun(cx, cy, r, disc = CREAM, halo = '#E8B36A', rays = 0) {
  let out = glow(cx, cy, r * 3.2, halo, 0.55) + `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${disc}"/>`;
  for (let i = 0; i < rays; i++) {
    const a = (i / rays) * Math.PI * 2;
    out += `<line x1="${f(cx + Math.cos(a) * r * 1.4)}" y1="${f(cy + Math.sin(a) * r * 1.4)}" x2="${f(cx + Math.cos(a) * r * 2.4)}" y2="${f(cy + Math.sin(a) * r * 2.4)}" stroke="${disc}" stroke-width="${f(r * 0.12)}" stroke-linecap="round" opacity="0.7"/>`;
  }
  return out;
}

function lightRays(cx, cy, n, len, spread, color = CREAM, op = 0.18) {
  let out = '';
  for (let i = 0; i < n; i++) {
    const a = -Math.PI / 2 - spread / 2 + (spread * i) / (n - 1);
    const x2 = cx + Math.cos(a) * len, y2 = cy + Math.sin(a) * len;
    const wdt = 26 + (i % 2) * 22;
    out += `<path d="M ${cx} ${cy} L ${f(x2 - wdt)} ${f(y2)} L ${f(x2 + wdt)} ${f(y2)} Z" fill="${color}" opacity="${op}"/>`;
  }
  return out;
}

const hills = (color, yTop, amp = 60, op = 1) =>
  `<path d="M0 ${yTop + amp} Q ${W * 0.22} ${yTop - amp} ${W * 0.5} ${yTop} T ${W} ${yTop - amp * 0.4} V ${H} H 0 Z" fill="${color}" opacity="${op}"/>`;

const dunes = (c1, c2, yTop) =>
  `<path d="M0 ${yTop} Q ${W * 0.3} ${yTop - 90} ${W * 0.62} ${yTop - 10} T ${W} ${yTop - 50} V ${H} H 0 Z" fill="${c1}"/>` +
  `<path d="M0 ${yTop + 90} Q ${W * 0.4} ${yTop + 10} ${W * 0.78} ${yTop + 80} T ${W} ${yTop + 60} V ${H} H 0 Z" fill="${c2}"/>`;

const mountains = (color, base, peaks, op = 1) => {
  let d = `M0 ${base}`;
  for (const [x, y] of peaks) d += ` L ${x} ${y}`;
  d += ` L ${W} ${base} V ${H} H 0 Z`;
  return `<path d="${d}" fill="${color}" opacity="${op}"/>`;
};

const groundBand = (color, y) => `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/>`;

const cloud = (cx, cy, rx, ry, op = 0.7, color = CREAM) =>
  `<g opacity="${op}" fill="${color}"><ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}"/><ellipse cx="${cx - rx * 0.55}" cy="${cy + ry * 0.35}" rx="${rx * 0.6}" ry="${ry * 0.75}"/><ellipse cx="${cx + rx * 0.55}" cy="${cy + ry * 0.3}" rx="${rx * 0.65}" ry="${ry * 0.7}"/><ellipse cx="${cx + rx * 0.1}" cy="${cy - ry * 0.5}" rx="${rx * 0.5}" ry="${ry * 0.7}"/></g>`;

const stormCloud = (cx, cy, rx, ry) => cloud(cx, cy, rx, ry, 0.9, '#2B3140') + cloud(cx + rx * 0.3, cy + ry * 0.4, rx * 0.8, ry * 0.8, 0.8, '#3E4A5E');

function rain(seed, n, y0, y1, color = SEA_FOAM, op = 0.35, slant = 60, len = 70) {
  const rnd = mulberry32(seed);
  let out = `<g stroke="${color}" stroke-width="5" stroke-linecap="round" opacity="${op}">`;
  for (let i = 0; i < n; i++) {
    const x = rnd() * W, y = y0 + rnd() * (y1 - y0);
    out += `<line x1="${f(x)}" y1="${f(y)}" x2="${f(x - slant * 0.4)}" y2="${f(y + len)}"/>`;
  }
  return out + '</g>';
}

function star8(cx, cy, r, fill = GOLD) {
  let p = '';
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * Math.PI * 2 - Math.PI / 2, b = a + Math.PI / 8;
    p += `${f(cx + Math.cos(a) * r)},${f(cy + Math.sin(a) * r)} ${f(cx + Math.cos(b) * r * 0.45)},${f(cy + Math.sin(b) * r * 0.45)} `;
  }
  return glow(cx, cy, r * 2.2, fill, 0.35) + `<polygon points="${p}" fill="${fill}"/>`;
}

const sparkle = (x, y, r, fill = GOLD, op = 0.9) =>
  `<path d="M ${x} ${y - r} Q ${x + r * 0.18} ${y - r * 0.18} ${x + r} ${y} Q ${x + r * 0.18} ${y + r * 0.18} ${x} ${y + r} Q ${x - r * 0.18} ${y + r * 0.18} ${x - r} ${y} Q ${x - r * 0.18} ${y - r * 0.18} ${x} ${y - r} Z" fill="${fill}" opacity="${op}"/>`;

// The firefly: the one light a child looks for on every unique scene.
function firefly(x, y, s = 1) {
  return glow(x, y, 46 * s, '#FFE9A8', 0.55) +
    `<ellipse cx="${x}" cy="${y + 3 * s}" rx="${5.5 * s}" ry="${8 * s}" fill="#5A4A2A"/>` +
    `<circle cx="${x}" cy="${y + 7 * s}" r="${6 * s}" fill="#FFF4C8"/>` +
    `<circle cx="${x}" cy="${y + 7 * s}" r="${3 * s}" fill="#FFFBEA"/>` +
    `<path d="M ${x - 4 * s} ${y - 2 * s} q ${-12 * s} ${-10 * s} ${-6 * s} ${-16 * s} M ${x + 4 * s} ${y - 2 * s} q ${12 * s} ${-10 * s} ${6 * s} ${-16 * s}" stroke="#FFF4C8" stroke-width="${2 * s}" fill="none" opacity="0.8"/>`;
}

function lantern(cx, cy, s, body = GOLD, glass = CREAM) {
  return glow(cx, cy - 20 * s, 90 * s, CREAM, 0.4) +
    `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<rect x="-8" y="-96" width="16" height="18" rx="5" fill="${DEEPGOLD}"/>` +
    `<path d="M -34 -78 H 34 L 26 -58 H -26 Z" fill="${body}"/>` +
    `<rect x="-30" y="-58" width="60" height="86" rx="14" fill="${glass}"/>` +
    `<rect x="-30" y="-58" width="60" height="86" rx="14" fill="none" stroke="${body}" stroke-width="7"/>` +
    `<line x1="-10" y1="-58" x2="-10" y2="28" stroke="${body}" stroke-width="4"/>` +
    `<line x1="10" y1="-58" x2="10" y2="28" stroke="${body}" stroke-width="4"/>` +
    `<path d="M -26 28 H 26 L 18 46 H -18 Z" fill="${body}"/>` +
    `<circle cx="0" cy="60" r="8" fill="${DEEPGOLD}"/></g>`;
}

const hangLine = (cx, yTo, s, color = GOLD, yFrom = 0) =>
  `<line x1="${cx}" y1="${yFrom}" x2="${cx}" y2="${yTo - 96 * s}" stroke="${color}" stroke-width="${4 * s}" opacity="0.8"/>`;

function dome(cx, baseY, rx, color) {
  return `<path d="M ${cx - rx} ${baseY} Q ${cx - rx} ${baseY - rx * 1.15} ${cx} ${baseY - rx * 1.3} Q ${cx + rx} ${baseY - rx * 1.15} ${cx + rx} ${baseY} Z" fill="${color}"/>` +
    `<line x1="${cx}" y1="${baseY - rx * 1.3}" x2="${cx}" y2="${baseY - rx * 1.62}" stroke="${color}" stroke-width="${rx * 0.09}"/>` +
    crescent(cx, baseY - rx * 1.78, rx * 0.16, color);
}

function minaret(x, baseY, hgt, wdt, color) {
  return `<rect x="${x - wdt / 2}" y="${baseY - hgt}" width="${wdt}" height="${hgt}" fill="${color}"/>` +
    `<rect x="${x - wdt * 0.8}" y="${baseY - hgt * 0.72}" width="${wdt * 1.6}" height="${wdt * 0.5}" fill="${color}"/>` +
    `<path d="M ${x - wdt * 0.9} ${baseY - hgt} H ${x + wdt * 0.9} L ${x} ${baseY - hgt - wdt * 2.2} Z" fill="${color}"/>`;
}

function mosque(cx, baseY, scale, color) {
  const w = 620 * scale;
  return `<rect x="${cx - w / 2}" y="${baseY - 150 * scale}" width="${w}" height="${150 * scale}" fill="${color}"/>` +
    dome(cx, baseY - 150 * scale, 150 * scale, color) +
    dome(cx - w * 0.36, baseY - 150 * scale, 60 * scale, color) +
    dome(cx + w * 0.36, baseY - 150 * scale, 60 * scale, color) +
    minaret(cx - w / 2 - 40 * scale, baseY, 380 * scale, 44 * scale, color) +
    minaret(cx + w / 2 + 40 * scale, baseY, 380 * scale, 44 * scale, color);
}

// A skyline of flat-roofed houses with arches and a dome or two, the way a
// child draws a town: silhouettes, with windows lit when asked.
function city(baseY, color, lit = null, seed = 3, scale = 1) {
  const rnd = mulberry32(seed);
  let out = '', x = -40;
  while (x < W + 40) {
    const w = (90 + rnd() * 140) * scale, h = (90 + rnd() * 220) * scale;
    out += `<rect x="${f(x)}" y="${f(baseY - h)}" width="${f(w)}" height="${f(h)}" fill="${color}"/>`;
    if (rnd() > 0.72) out += dome(x + w / 2, baseY - h, w * 0.32, color);
    if (lit) {
      const rows = Math.floor(h / (70 * scale));
      for (let r = 0; r < rows; r++) if (rnd() > 0.45)
        out += `<rect x="${f(x + w * 0.3)}" y="${f(baseY - h + 24 * scale + r * 70 * scale)}" width="${f(16 * scale)}" height="${f(26 * scale)}" rx="${f(8 * scale)}" fill="${lit}" opacity="0.9"/>`;
    }
    x += w + 8 * scale;
  }
  return out;
}

function palm(x, gy, s, color) {
  const fr = (a) => `<path d="M 0 -170 q ${f(90 * Math.cos(a))} ${f(-46 - 34 * Math.sin(a))} ${f(168 * Math.cos(a))} ${f(-14 * Math.sin(a) + 26)}" stroke="${color}" stroke-width="17" fill="none" stroke-linecap="round"/>`;
  return `<g transform="translate(${x} ${gy}) scale(${s})">` +
    `<path d="M -14 0 Q 4 -90 -6 -170 L 16 -170 Q 18 -90 12 0 Z" fill="${color}"/>` +
    `<g transform="translate(2 0)">${fr(0.3)}${fr(1.2)}${fr(2.0)}${fr(2.9)}${fr(-0.6)}</g></g>`;
}

const tree = (x, gy, s, trunk = WOOD_DARK, leaf = LEAF, leaf2 = LEAF_LIGHT) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -14 0 L -8 -150 H 8 L 14 0 Z" fill="${trunk}"/>` +
  `<circle cx="-60" cy="-170" r="70" fill="${leaf}"/><circle cx="60" cy="-180" r="76" fill="${leaf}"/><circle cx="0" cy="-230" r="86" fill="${leaf2}"/><circle cx="0" cy="-170" r="70" fill="${leaf2}"/></g>`;

const grass = (seed, y, n, color, s = 1) => {
  const rnd = mulberry32(seed);
  let out = `<g stroke="${color}" stroke-width="${6 * s}" stroke-linecap="round" fill="none">`;
  for (let i = 0; i < n; i++) {
    const x = rnd() * W, h = (30 + rnd() * 40) * s;
    out += `<path d="M ${f(x)} ${y} q ${f(-10 * s)} ${f(-h * 0.6)} ${f(4 * s)} ${f(-h)} M ${f(x + 14 * s)} ${y} q ${f(8 * s)} ${f(-h * 0.5)} ${f(-2 * s)} ${f(-h * 0.8)}"/>`;
  }
  return out + '</g>';
};

const rock = (x, y, rx, ry, color = STONE_DARK) =>
  `<path d="M ${x - rx} ${y} Q ${x - rx * 0.8} ${y - ry * 1.4} ${x - rx * 0.1} ${y - ry} Q ${x + rx * 0.7} ${y - ry * 1.5} ${x + rx} ${y} Z" fill="${color}"/>`;

// --- water ---
function sea(yTop, c1 = SEA_LIGHT, c2 = SEA, c3 = SEA_DEEP, foam = SEA_FOAM, amp = 28) {
  return `<rect x="0" y="${yTop}" width="${W}" height="${H - yTop}" fill="${c2}"/>` +
    `<path d="M0 ${yTop + amp} Q ${W * 0.15} ${yTop - amp} ${W * 0.3} ${yTop + amp * 0.5} T ${W * 0.6} ${yTop + amp * 0.4} T ${W * 0.9} ${yTop + amp * 0.6} T ${W * 1.1} ${yTop} V ${H} H 0 Z" fill="${c1}" opacity="0.55"/>` +
    `<path d="M0 ${yTop + amp * 4} Q ${W * 0.2} ${yTop + amp * 2.6} ${W * 0.4} ${yTop + amp * 4} T ${W * 0.8} ${yTop + amp * 3.6} T ${W * 1.2} ${yTop + amp * 4} V ${H} H 0 Z" fill="${c3}" opacity="0.7"/>` +
    `<path d="M0 ${yTop + amp * 7} Q ${W * 0.25} ${yTop + amp * 5.4} ${W * 0.5} ${yTop + amp * 7} T ${W} ${yTop + amp * 6.6} V ${H} H 0 Z" fill="${c3}"/>` +
    `<g stroke="${foam}" stroke-width="5" fill="none" opacity="0.5" stroke-linecap="round">` +
    `<path d="M ${W * 0.08} ${yTop + amp * 2.2} q 40 -14 80 0"/><path d="M ${W * 0.55} ${yTop + amp * 1.8} q 50 -16 100 0"/><path d="M ${W * 0.78} ${yTop + amp * 5} q 40 -12 80 0"/><path d="M ${W * 0.3} ${yTop + amp * 5.6} q 60 -18 120 0"/></g>`;
}

function bigWaves(yTop, colors = [SEA_LIGHT, SEA, SEA_DEEP, '#081A2A'], amp = 120) {
  let out = '';
  colors.forEach((c, i) => {
    const y = yTop + i * amp * 0.9;
    out += `<path d="M0 ${y + amp} Q ${W * (0.12 + i * 0.05)} ${y - amp} ${W * (0.3 + i * 0.04)} ${y} T ${W * (0.62 + i * 0.03)} ${y - amp * 0.4} T ${W} ${y + amp * 0.2} V ${H} H 0 Z" fill="${c}"/>` +
      `<path d="M ${W * (0.12 + i * 0.05)} ${y - amp * 0.35} q 60 -40 130 -10" stroke="${SEA_FOAM}" stroke-width="8" fill="none" opacity="0.45" stroke-linecap="round"/>`;
  });
  return out;
}

const bubbles = (seed, n, x0, x1, y0, y1) => {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) out += `<circle cx="${f(x0 + rnd() * (x1 - x0))}" cy="${f(y0 + rnd() * (y1 - y0))}" r="${f(4 + rnd() * 12)}" fill="none" stroke="${SEA_FOAM}" stroke-width="3" opacity="${f(0.3 + rnd() * 0.4)}"/>`;
  return out;
};

// --- vessels ---
function ship(cx, y, s, tilt = 0) {
  return `<g transform="translate(${cx} ${y}) rotate(${tilt}) scale(${s})">` +
    `<path d="M -220 -60 Q -240 40 -160 60 H 160 Q 240 40 220 -60 L 170 -60 L 150 -20 H -150 L -170 -60 Z" fill="${WOOD}"/>` +
    `<path d="M -150 -20 H 150 L 130 20 H -130 Z" fill="${WOOD_DARK}"/>` +
    `<rect x="-8" y="-380" width="16" height="330" fill="${WOOD_DARK}"/>` +
    `<path d="M 8 -360 L 190 -120 L 8 -120 Z" fill="${CREAM}"/>` +
    `<path d="M -8 -330 L -150 -120 L -8 -120 Z" fill="${IVORY}"/>` +
    `<path d="M -8 -380 L -70 -360 L -8 -340 Z" fill="${GOLD}"/>` +
    `</g>`;
}

function ark(cx, baseY, s, lit = false) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -420 -150 Q -470 -40 -380 0 H 380 Q 470 -40 420 -150 Z" fill="${WOOD}"/>` +
    `<g stroke="${WOOD_DARK}" stroke-width="6" opacity="0.6"><path d="M -430 -110 H 430"/><path d="M -410 -70 H 410"/><path d="M -390 -30 H 390"/></g>` +
    `<rect x="-300" y="-330" width="600" height="180" rx="14" fill="${WOOD_LIGHT}"/>` +
    `<path d="M -330 -330 L 0 -440 L 330 -330 Z" fill="${WOOD_DARK}"/>` +
    `<rect x="-60" y="-290" width="120" height="120" rx="60" fill="${lit ? CREAM : WOOD_DARK}"/>` +
    `<rect x="-230" y="-280" width="70" height="70" rx="35" fill="${lit ? GOLD : WOOD_DARK}"/>` +
    `<rect x="160" y="-280" width="70" height="70" rx="35" fill="${lit ? GOLD : WOOD_DARK}"/>` +
    `</g>` + (lit ? glow(cx, baseY - 230 * s, 200 * s, CREAM, 0.3) : '');
}

const plank = (x, y, w, h, angle = 0) =>
  `<g transform="translate(${x} ${y}) rotate(${angle})"><rect x="0" y="0" width="${w}" height="${h}" rx="6" fill="${WOOD_LIGHT}"/><rect x="0" y="0" width="${w}" height="${h * 0.3}" rx="6" fill="${WOOD}" opacity="0.5"/></g>`;

const nails = (seed, n, x0, x1, y0, y1) => {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) out += `<rect x="${f(x0 + rnd() * (x1 - x0))}" y="${f(y0 + rnd() * (y1 - y0))}" width="6" height="26" rx="3" fill="${DEEPGOLD}" transform="rotate(${f(rnd() * 60 - 30)} ${f(x0 + (x1 - x0) / 2)} ${f(y0)})"/>`;
  return out;
};

const hammer = (x, y, s, a = -20) =>
  `<g transform="translate(${x} ${y}) rotate(${a}) scale(${s})"><rect x="-8" y="-20" width="16" height="200" rx="6" fill="${WOOD_LIGHT}"/><rect x="-60" y="-60" width="120" height="50" rx="10" fill="${STONE_DARK}"/></g>`;

const saw = (x, y, s, a = 10) =>
  `<g transform="translate(${x} ${y}) rotate(${a}) scale(${s})"><path d="M 0 0 H 240 L 250 40 L 240 60 L 220 44 L 200 60 L 180 44 L 160 60 L 140 44 L 120 60 L 100 44 L 80 60 L 60 44 L 40 60 L 20 44 L 0 60 Z" fill="${STONE_LIGHT}"/><rect x="-70" y="-6" width="80" height="60" rx="16" fill="${WOOD}"/></g>`;

// --- the fish ---
function fish(cx, cy, s, body = '#0F2438', belly = '#183A55', open = true, flip = false) {
  return `<g transform="translate(${cx} ${cy}) scale(${flip ? -s : s} ${s})">` +
    `<path d="M -420 0 Q -300 -190 40 -170 Q 300 -150 380 -40 L 520 -150 L 470 0 L 520 150 L 380 40 Q 300 150 40 170 Q -300 190 -420 0 Z" fill="${body}"/>` +
    `<path d="M -380 40 Q -200 150 60 140 Q 300 130 370 40 Q 200 100 -100 100 Q -300 90 -380 40 Z" fill="${belly}" opacity="0.8"/>` +
    (open ? `<path d="M -420 0 Q -330 -20 -250 -30 L -250 20 Q -330 20 -420 0 Z" fill="#050A12"/>` : '') +
    `<circle cx="-230" cy="-70" r="24" fill="${IVORY}"/><circle cx="-224" cy="-66" r="12" fill="${INK}"/>` +
    `<path d="M 60 -60 q 60 -30 120 0" stroke="${belly}" stroke-width="10" fill="none" stroke-linecap="round" opacity="0.7"/>` +
    `<path d="M -30 -170 q 30 -80 90 -60 q -40 20 -50 70 Z" fill="${body}"/>` +
    `</g>`;
}

// --- desert things ---
function well(cx, baseY, s, withFrame = true) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    (withFrame ? `<rect x="-150" y="-330" width="18" height="300" fill="${WOOD_DARK}"/><rect x="132" y="-330" width="18" height="300" fill="${WOOD_DARK}"/><rect x="-170" y="-350" width="340" height="22" rx="8" fill="${WOOD}"/><rect x="-24" y="-372" width="48" height="26" rx="8" fill="${WOOD_DARK}"/>` : '') +
    `<path d="M -170 -60 Q -170 -110 0 -110 Q 170 -110 170 -60 V 0 Q 0 40 -170 0 Z" fill="${STONE}"/>` +
    `<g stroke="${STONE_DARK}" stroke-width="5" opacity="0.6"><path d="M -150 -40 H 150"/><path d="M -168 -10 H 168"/><path d="M -100 -60 V -10 M -30 -40 V 0 M 40 -60 V -10 M 110 -40 V 0"/></g>` +
    `<ellipse cx="0" cy="-110" rx="170" ry="40" fill="${STONE_LIGHT}"/>` +
    `<ellipse cx="0" cy="-110" rx="130" ry="26" fill="#0B0D18"/>` +
    `</g>`;
}

const bucket = (x, y, s) =>
  `<g transform="translate(${x} ${y}) scale(${s})"><path d="M -40 -50 L -30 30 H 30 L 40 -50 Z" fill="${WOOD}"/><ellipse cx="0" cy="-50" rx="40" ry="10" fill="${WOOD_LIGHT}"/><path d="M -40 -50 Q 0 -110 40 -50" stroke="${WOOD_DARK}" stroke-width="6" fill="none"/></g>`;

const rope = (x1, y1, x2, y2) =>
  `<path d="M ${x1} ${y1} L ${x2} ${y2}" stroke="${SAND_DARK}" stroke-width="7" stroke-linecap="round"/>`;

function camel(x, gy, s, color = INK_SOFT, flip = false) {
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<ellipse cx="0" cy="-90" rx="90" ry="44" fill="${color}"/><ellipse cx="0" cy="-130" rx="46" ry="34" fill="${color}"/>` +
    `<path d="M 70 -110 q 60 -10 70 -90 q 6 -30 40 -30 q 30 0 36 30 l -30 10 q -14 6 -26 -6 l -6 40 q -10 50 -60 60 Z" fill="${color}"/>` +
    `<path d="M -70 -60 l -10 62 h 18 l 6 -50 M -20 -56 l -4 58 h 18 l 2 -50 M 30 -58 l -2 60 h 18 l 0 -52 M 66 -70 l 4 72 h 18 l -6 -64" stroke="${color}" stroke-width="10" stroke-linecap="round" fill="none"/>` +
    `<path d="M -90 -100 q -30 20 -20 50" stroke="${color}" stroke-width="10" stroke-linecap="round" fill="none"/></g>`;
}

const sheep = (x, gy, s, fleece = IVORY, dark = INK_SOFT, flip = false) =>
  `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
  `<path d="M -40 -20 l -6 20 M -14 -20 l -2 20 M 14 -20 l 2 20 M 40 -20 l 6 20" stroke="${dark}" stroke-width="9" stroke-linecap="round"/>` +
  `<ellipse cx="0" cy="-50" rx="62" ry="38" fill="${fleece}"/><circle cx="-34" cy="-72" r="20" fill="${fleece}"/><circle cx="4" cy="-84" r="22" fill="${fleece}"/><circle cx="38" cy="-72" r="20" fill="${fleece}"/>` +
  `<ellipse cx="62" cy="-66" rx="24" ry="18" fill="${dark}"/><ellipse cx="72" cy="-84" rx="8" ry="14" fill="${dark}"/><circle cx="70" cy="-68" r="3.5" fill="${IVORY}"/></g>`;

const bird = (x, y, s, color = INK_SOFT) =>
  `<path d="M ${x} ${y} q ${10 * s} ${-10 * s} ${20 * s} 0 q ${10 * s} ${-10 * s} ${20 * s} 0" stroke="${color}" stroke-width="${4 * s}" fill="none" stroke-linecap="round"/>`;

const dove = (x, y, s, color = IVORY, flip = false) =>
  `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})"><ellipse cx="0" cy="0" rx="34" ry="16" fill="${color}"/><path d="M -6 -6 q -20 -50 30 -60 q -10 30 6 50 Z" fill="${color}"/><circle cx="30" cy="-8" r="10" fill="${color}"/><path d="M 40 -8 l 12 3 l -12 4 Z" fill="${GOLD}"/><path d="M -34 0 l -20 -8 l 4 14 Z" fill="${color}"/></g>`;

function cow(x, gy, s, fat, color = INK_SOFT, flip = false) {
  const rx = fat ? 84 : 58, ry = fat ? 46 : 26, ly = fat ? -40 : -24;
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<path d="M -50 ${ly} l -6 ${-ly} M -18 ${ly} l -2 ${-ly} M 18 ${ly} l 2 ${-ly} M 50 ${ly} l 6 ${-ly}" stroke="${color}" stroke-width="${fat ? 12 : 8}" stroke-linecap="round"/>` +
    `<ellipse cx="0" cy="${-ry - 10}" rx="${rx}" ry="${ry}" fill="${color}"/>` +
    (fat ? '' : `<g stroke="#1E1610" stroke-width="4" opacity="0.5"><path d="M -30 ${-ry - 30} v 30 M -10 ${-ry - 34} v 36 M 10 ${-ry - 34} v 36 M 30 ${-ry - 30} v 30"/></g>`) +
    `<ellipse cx="${rx + 10}" cy="${-ry - 30}" rx="${fat ? 30 : 22}" ry="${fat ? 24 : 18}" fill="${color}"/>` +
    `<path d="M ${rx - 6} ${-ry - 50} q -10 -26 6 -34 M ${rx + 26} ${-ry - 50} q 10 -26 -6 -34" stroke="${color}" stroke-width="7" fill="none" stroke-linecap="round"/>` +
    `<circle cx="${rx + 20}" cy="${-ry - 34}" r="3.5" fill="${IVORY}"/>` +
    `<path d="M ${-rx} ${-ry - 4} q -30 20 -20 50" stroke="${color}" stroke-width="7" fill="none" stroke-linecap="round"/></g>`;
}

const wheat = (x, gy, s, color = GOLD) =>
  `<g transform="translate(${x} ${gy}) scale(${s})" stroke="${color}" stroke-linecap="round" fill="none"><path d="M 0 0 V -160" stroke-width="6"/>` +
  [-150, -130, -110, -90, -70].map((y) => `<path d="M 0 ${y} q -22 -6 -30 -30 M 0 ${y} q 22 -6 30 -30" stroke-width="7"/>`).join('') + `</g>`;

const sack = (x, gy, s, color = SAND_DARK) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -70 0 Q -80 -110 -40 -140 L -30 -170 H 30 L 40 -140 Q 80 -110 70 0 Z" fill="${color}"/><path d="M -34 -150 H 34" stroke="${WOOD_DARK}" stroke-width="8" stroke-linecap="round"/><path d="M -50 -60 q 50 20 100 0" stroke="${WOOD_DARK}" stroke-width="4" fill="none" opacity="0.4"/></g>`;

const jar = (x, gy, s, color = '#8A4A28') =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -50 0 Q -70 -90 -40 -140 Q -20 -160 -24 -180 H 24 Q 20 -160 40 -140 Q 70 -90 50 0 Z" fill="${color}"/><ellipse cx="0" cy="-180" rx="26" ry="8" fill="${WOOD_DARK}"/></g>`;

function statue(x, gy, s, color = STONE_DARK) {
  return `<g transform="translate(${x} ${gy}) scale(${s})">` +
    `<rect x="-70" y="-60" width="140" height="60" fill="${color}"/><rect x="-50" y="-260" width="100" height="200" rx="12" fill="${color}"/>` +
    `<rect x="-34" y="-330" width="68" height="76" rx="30" fill="${color}"/><rect x="-60" y="-350" width="120" height="30" rx="6" fill="${color}"/></g>`;
}

const gourdPlant = (x, gy, s) =>
  `<g transform="translate(${x} ${gy}) scale(${s})">` +
  `<path d="M -300 0 q 60 -160 300 -220 q 240 -60 320 -240" stroke="${GREEN}" stroke-width="18" fill="none" stroke-linecap="round"/>` +
  `<path d="M -160 -60 q -60 -120 60 -130 q -30 70 -60 130 Z M 40 -160 q -100 -90 0 -180 q 40 90 0 180 Z M 190 -230 q 20 -130 130 -120 q -30 80 -130 120 Z M 320 -420 q -110 -60 -60 -170 q 80 60 60 170 Z M -20 -190 q 90 -60 150 20 q -90 40 -150 -20 Z" fill="${LEAF}"/>` +
  `<path d="M -240 -40 q -50 -90 30 -100 q -10 60 -30 100 Z M 130 -300 q -90 -30 -60 -120 q 60 40 60 120 Z" fill="${LEAF_LIGHT}"/>` +
  `<path d="M 100 -120 q -50 60 0 100 q 50 -40 0 -100 Z" fill="${GOLD}"/><path d="M 250 -270 q -40 50 0 90 q 40 -40 0 -90 Z" fill="${SAND}"/></g>`;

// --- home things ---
function room(warm = true) {
  const s = skyRect(warm ? SKY.room : SKY.roomEvening, 0, H * 0.72);
  return s + `<rect x="0" y="${H * 0.72}" width="${W}" height="${H * 0.28}" fill="${FLOOR}"/>` +
    `<rect x="0" y="${H * 0.72}" width="${W}" height="22" fill="#54382A"/>` +
    `<rect x="${W * 0.1}" y="${H * 0.78}" width="${W * 0.8}" height="${H * 0.22}" rx="18" fill="#8A5A36" opacity="0.6"/>` +
    `<path d="M ${W * 0.16} ${H * 0.82} H ${W * 0.84} M ${W * 0.14} ${H * 0.9} H ${W * 0.86}" stroke="${DEEPGOLD}" stroke-width="4" opacity="0.35"/>`;
}

function archWindow(cx, topY, w, h, night = true) {
  const inner = night ? skyRect(SKY.night, topY, topY + h, cx - w / 2, cx + w / 2) : skyRect(SKY.day, topY, topY + h, cx - w / 2, cx + w / 2);
  const id = `aw${gradN++}`;
  DEFS += `<clipPath id="${id}"><path d="M ${cx - w / 2} ${topY + h} V ${topY + w / 2} A ${w / 2} ${w / 2} 0 0 1 ${cx + w / 2} ${topY + w / 2} V ${topY + h} Z"/></clipPath>`;
  return `<path d="M ${cx - w / 2 - 22} ${topY + h + 16} V ${topY + w / 2} A ${w / 2 + 22} ${w / 2 + 22} 0 0 1 ${cx + w / 2 + 22} ${topY + w / 2} V ${topY + h + 16} Z" fill="${WOOD}"/>` +
    `<g clip-path="url(#${id})">${inner}${night ? stars(9, 18, cx - w / 2, cx + w / 2, topY, topY + h * 0.7, IVORY, 1.8) + crescent(cx + w * 0.2, topY + h * 0.32, w * 0.12) : sun(cx + w * 0.2, topY + h * 0.3, w * 0.1)}</g>`;
}

const cushion = (x, y, w, h, color, angle = 0) =>
  `<g transform="translate(${x} ${y}) rotate(${angle})"><rect x="${-w / 2}" y="${-h}" width="${w}" height="${h}" rx="${h * 0.35}" fill="${color}"/><rect x="${-w / 2 + 10}" y="${-h + 8}" width="${w - 20}" height="${h * 0.3}" rx="${h * 0.2}" fill="#FFF" opacity="0.14"/></g>`;

const CUSHION_COLORS = ['#B8683C', '#2E5D48', '#B98A3E', '#4A5D8A', '#8A4A28'];

function blanket(x, y, w, h, color = '#4A5D8A', fold = 0.5) {
  return `<path d="M ${x - w / 2} ${y} Q ${x - w / 2 + w * 0.2} ${y - h * fold} ${x} ${y - h} Q ${x + w / 2 - w * 0.2} ${y - h * fold} ${x + w / 2} ${y} Z" fill="${color}"/>` +
    `<path d="M ${x - w * 0.3} ${y} Q ${x - w * 0.1} ${y - h * 0.7} ${x + w * 0.05} ${y - h * 0.85}" stroke="#FFF" stroke-width="6" fill="none" opacity="0.15"/>`;
}

const coinBox = (x, gy, s) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><rect x="-120" y="-150" width="240" height="150" rx="14" fill="${WOOD}"/><rect x="-120" y="-150" width="240" height="30" rx="10" fill="${WOOD_DARK}"/><rect x="-50" y="-142" width="100" height="14" rx="7" fill="#1A1208"/>` +
  `<circle cx="0" cy="-80" r="36" fill="none" stroke="${GOLD}" stroke-width="6" opacity="0.6"/>${star8(0, -80, 18, GOLD)}</g>`;

const coin = (x, y, s, a = 0) =>
  `<g transform="translate(${x} ${y}) rotate(${a}) scale(${s})"><ellipse cx="0" cy="0" rx="30" ry="30" fill="${GOLD}"/><ellipse cx="0" cy="0" rx="20" ry="20" fill="none" stroke="${DEEPGOLD}" stroke-width="4"/></g>`;

const bowlOfDates = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -110 -60 A 110 110 0 0 0 110 -60 L 96 -34 Q 0 12 -96 -34 Z" fill="#B8683C"/>` +
  [[-70, -74], [-30, -84], [10, -78], [50, -86], [80, -70], [-10, -98], [34, -100]].map(([x, y]) => `<ellipse cx="${x}" cy="${y}" rx="22" ry="12" fill="#5A2E14" transform="rotate(${x * 0.3} ${x} ${y})"/>`).join('') +
  `<ellipse cx="0" cy="-60" rx="110" ry="24" fill="none" stroke="${CREAM}" stroke-width="6"/></g>`;

const glass = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -34 -110 L -26 0 H 26 L 34 -110 Z" fill="${SEA_FOAM}" opacity="0.85"/><path d="M -30 -70 L -25 -6 H 25 L 30 -70 Z" fill="${SEA_LIGHT}" opacity="0.6"/><ellipse cx="0" cy="-110" rx="34" ry="8" fill="${CREAM}"/></g>`;

const table = (y, color = WOOD) =>
  `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/><rect x="0" y="${y}" width="${W}" height="24" fill="#54382A"/><rect x="${W * 0.14}" y="${y + 24}" width="${W * 0.72}" height="${H - y}" fill="${WOOD_LIGHT}" opacity="0.5"/>`;

function kaaba(cx, baseY, s) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -220 0 V -300 L 0 -360 L 220 -300 V 0 L 0 -50 Z" fill="#0F0F12"/>` +
    `<path d="M -220 -300 L 0 -250 L 220 -300 L 0 -360 Z" fill="#1E1E24"/>` +
    `<path d="M -220 0 L 0 -50 V -250 L -220 -300 Z" fill="#141418"/>` +
    `<path d="M -220 -230 L 0 -180 L 220 -230 V -190 L 0 -140 L -220 -190 Z" fill="${GOLD}"/>` +
    `<path d="M -220 -224 L 0 -174 M -220 -196 L 0 -146 M 0 -174 L 220 -224 M 0 -146 L 220 -196" stroke="${DEEPGOLD}" stroke-width="3" opacity="0.6"/>` +
    `<rect x="30" y="-140" width="60" height="90" rx="6" fill="${GOLD}" transform="skewY(-13)"/>` +
    `</g>`;
}

function prayerMat(cx, y, w, h, mat = '#8A4A28', edge = DEEPGOLD, inner = '#7A3E22') {
  const skew = w * 0.11;
  const outer = `M ${cx - w / 2 + skew} ${y} L ${cx + w / 2 + skew} ${y} L ${cx + w / 2 - skew} ${y + h} L ${cx - w / 2 - skew} ${y + h} Z`;
  const innerP = `M ${cx - w / 2 + skew + 34} ${y + 18} L ${cx + w / 2 + skew - 34} ${y + 18} L ${cx + w / 2 - skew - 34} ${y + h - 18} L ${cx - w / 2 - skew + 34} ${y + h - 18} Z`;
  return `<path d="${outer}" fill="${mat}"/><path d="${outer}" fill="none" stroke="${edge}" stroke-width="8" opacity="0.85"/><path d="${innerP}" fill="${inner}"/><path d="${innerP}" fill="none" stroke="${edge}" stroke-width="4" opacity="0.5"/>` +
    `<path d="M ${cx - w * 0.16} ${y + h * 0.78} Q ${cx - w * 0.16} ${y + h * 0.25} ${cx} ${y + h * 0.16} Q ${cx + w * 0.16} ${y + h * 0.25} ${cx + w * 0.16} ${y + h * 0.78} Z" fill="none" stroke="${edge}" stroke-width="5" opacity="0.6"/>`;
}

// --- the cast: faceless children in the salah-figure style ---
const LINE = '#3A2A1E', SKIN = '#B57A52', TROUSER = '#F2E6C8', CAP = '#F5EFDD', CAP_BAND = '#B98A3E';
const CAST = {
  safa: { kurta: '#8A4A6A', head: 'scarf', scarf: '#E2C177' },
  zayn: { kurta: '#4E8A6C', head: 'cap' },
  amina: { kurta: '#B8683C', head: 'scarf', scarf: '#F2E6C8' },
};

function child(who, { x, y, s = 1, pose = 'stand', arms = 'down', flip = false }) {
  const c = CAST[who];
  const o = (d, fill) => `<path d="${d}" fill="${fill}" stroke="${LINE}" stroke-width="7" stroke-linejoin="round"/>`;
  const arm = (sx, sy, ex, ey) =>
    `<path d="M ${sx} ${sy} L ${ex} ${ey}" stroke="${LINE}" stroke-width="30" stroke-linecap="round"/>` +
    `<path d="M ${sx} ${sy} L ${ex} ${ey}" stroke="${c.kurta}" stroke-width="18" stroke-linecap="round"/>` +
    `<circle cx="${ex}" cy="${ey}" r="14" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>`;
  let body = '';
  let hy;
  if (pose === 'stand') {
    body += o('M -36 -120 H -6 V -6 H -36 Z', TROUSER) + o('M 6 -120 H 36 V -6 H 6 Z', TROUSER);
    body += `<ellipse cx="-22" cy="-4" rx="26" ry="9" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/><ellipse cx="22" cy="-4" rx="26" ry="9" fill="${SKIN}" stroke="${LINE}" stroke-width="6"/>`;
    body += o('M -48 -236 Q -62 -160 -52 -104 H 52 Q 62 -160 48 -236 Q 0 -252 -48 -236 Z', c.kurta);
    const ay = arms === 'up' ? -300 : arms === 'out' ? -200 : -140;
    const ax = arms === 'up' ? 84 : arms === 'out' ? 110 : 72;
    body += arm(-46, -222, -ax, ay) + arm(46, -222, ax, ay);
    hy = -296;
  } else {
    body += o('M -74 -70 Q -84 -14 -44 -6 H 44 Q 84 -14 74 -70 Q 0 -96 -74 -70 Z', TROUSER);
    body += o('M -44 -206 Q -58 -140 -50 -66 H 50 Q 58 -140 44 -206 Q 0 -222 -44 -206 Z', c.kurta);
    body += arm(-42, -196, -70, -90) + arm(42, -196, 70, -90);
    hy = -262;
  }
  let head;
  if (c.head === 'scarf') {
    head = o(`M -66 ${hy - 4} Q -66 ${hy - 82} 0 ${hy - 78} Q 66 ${hy - 82} 66 ${hy - 4} Q 74 ${hy + 60} 0 ${hy + 74} Q -74 ${hy + 60} -66 ${hy - 4} Z`, c.scarf) +
      `<circle cx="0" cy="${hy}" r="42" fill="${SKIN}" stroke="${LINE}" stroke-width="7"/>`;
  } else {
    head = `<circle cx="0" cy="${hy}" r="50" fill="${SKIN}" stroke="${LINE}" stroke-width="7"/>` +
      o(`M -50 ${hy - 14} Q 0 ${hy - 82} 50 ${hy - 14} Z`, CAP) +
      `<path d="M -50 ${hy - 14} Q 0 ${hy - 30} 50 ${hy - 14}" stroke="${CAP_BAND}" stroke-width="7" fill="none"/>`;
  }
  return `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})">${body}${head}</g>`;
}

// House-of-Islam: a domed roof carried by five gold pillars on a plinth.
function pillarHouse(cx, baseY, s, roof = GREEN, pillar = GOLD, plinth = STONE_LIGHT) {
  let pillars = '';
  for (let i = 0; i < 5; i++) {
    const x = -320 + i * 160;
    pillars += `<rect x="${x - 22}" y="-330" width="44" height="300" rx="10" fill="${pillar}"/><rect x="${x - 34}" y="-346" width="68" height="24" rx="8" fill="${DEEPGOLD}"/><rect x="${x - 34}" y="-40" width="68" height="18" rx="6" fill="${DEEPGOLD}"/>`;
  }
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<rect x="-420" y="-24" width="840" height="24" rx="8" fill="${plinth}"/>` + pillars +
    `<rect x="-420" y="-380" width="840" height="50" rx="10" fill="${roof}"/>` +
    dome(0, -380, 230, roof) +
    `<path d="M -300 -380 Q -300 -470 -220 -470 Q -140 -470 -140 -380 Z M 140 -380 Q 140 -470 220 -470 Q 300 -470 300 -380 Z" fill="${roof}"/>` +
    `</g>`;
}

// ---------------------------------------------------------------- scene --
// The parts are built before scene() runs, so the gradients they registered
// are already in DEFS; the write loop resets DEFS before each builder.
function scene(parts) {
  const body = parts.join('');
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}"><defs>${DEFS}</defs>${body}</svg>`;
}

const SCENES = [];
const add = (dir, name, w, h, fn) => SCENES.push([dir, name, w, h, fn]);
const foreground = (color, y = H * 0.9, op = 1) => `<path d="M0 ${y + 30} Q ${W * 0.3} ${y - 30} ${W * 0.55} ${y + 10} T ${W} ${y - 10} V ${H} H 0 Z" fill="${color}" opacity="${op}"/>`;

// ================================================================= atlas ==
add('atlas', 'sea_day', 1600, 1200, () => scene([
  skyRect(SKY.dayClear), sun(1180, 260, 70, CREAM, '#E8C089'),
  cloud(340, 250, 150, 44, 0.6), cloud(820, 170, 110, 34, 0.5), cloud(1320, 420, 130, 38, 0.45),
  mountains('#7FA6C0', 700, [[0, 700], [260, 560], [520, 660], [760, 520], [1000, 640], [1260, 560], [1600, 680]], 0.5),
  sea(700), bird(300, 380, 3), bird(360, 340, 2.4), bird(1280, 520, 2.6),
  rock(120, H, 180, 90, '#2A4A5E'), rock(1520, H, 200, 110, '#2A4A5E'), vignette(0.18),
]));

add('atlas', 'sea_night', 1600, 1200, () => scene([
  skyRect(SKY.night), stars(21, 90, 0, W, 0, 640), fullMoon(1180, 220, 80),
  sea(700, '#2C4F6E', '#16324B', '#0B1E30', '#7A9AA8', 24),
  `<path d="M 1100 720 Q 1180 760 1260 720 M 1060 820 Q 1180 880 1300 820 M 1120 940 Q 1180 980 1240 940" stroke="${IVORY}" stroke-width="6" fill="none" opacity="0.35" stroke-linecap="round"/>`,
  rock(140, H, 200, 100, '#0A1520'), vignette(0.22),
]));

add('atlas', 'desert_road_dusk', 1600, 1200, () => scene([
  skyRect(SKY.violetDusk), stars(5, 30, 0, W, 0, 400), crescent(1240, 200, 60),
  mountains('#4A3560', 760, [[0, 760], [300, 600], [560, 700], [900, 560], [1200, 680], [1600, 620]], 0.7),
  dunes('#8A5348', '#6E4038', 820),
  `<path d="M 700 1200 Q 760 1000 900 940 Q 1040 880 980 820" stroke="#C48A5C" stroke-width="120" fill="none" stroke-linecap="round" opacity="0.55"/>`,
  `<path d="M 700 1200 Q 760 1000 900 940 Q 1040 880 980 820" stroke="#D9A05B" stroke-width="60" fill="none" stroke-linecap="round" opacity="0.35"/>`,
  palm(340, 900, 1.2, '#2C2347'), palm(1380, 960, 0.9, '#2C2347'), rock(1500, 1040, 80, 40, '#4A3560'),
  vignette(0.2),
]));

add('atlas', 'city_morning', 1600, 1200, () => scene([
  skyRect(SKY.dawn), sun(1200, 420, 90, CREAM, '#E8B36A', 12), cloud(300, 220, 140, 40, 0.5),
  city(900, '#8A5348', null, 11, 0.9), city(980, '#B0743B', null, 7, 1.15),
  `<rect x="0" y="980" width="${W}" height="220" fill="#6E4629"/>`,
  city(1080, '#4A2F22', null, 5, 0.5), vignette(0.18),
]));

add('atlas', 'city_night', 1600, 1200, () => scene([
  skyRect(SKY.night), stars(13, 110, 0, W, 0, 700), crescent(320, 220, 70),
  city(900, '#1A1F33', GOLD, 11, 0.9), city(980, '#232A44', GOLD, 7, 1.15),
  `<rect x="0" y="980" width="${W}" height="220" fill="#0E1120"/>`, city(1080, '#0A0D18', null, 5, 0.5),
  vignette(0.22),
]));

add('atlas', 'garden_day', 1600, 1200, () => scene([
  skyRect(SKY.dayClear), sun(280, 220, 70, CREAM, '#E8C089'), cloud(900, 200, 120, 36, 0.55), cloud(1300, 300, 100, 30, 0.45),
  hills('#7C9F6E', 700, 60), hills('#5F8A5A', 800, 50),
  `<path d="M 0 1010 Q 400 940 800 1000 T 1600 980 V 1200 H 0 Z" fill="#4F7C9A" opacity="0.8"/>`,
  hills('#3F7A5E', 1080, 30), tree(300, 900, 1.1), tree(1250, 880, 1.3), tree(760, 940, 0.8),
  grass(3, 1085, 60, '#2E5D48'),
  [[200, 1060], [420, 1040], [640, 1070], [1000, 1050], [1400, 1060], [1520, 1090]].map(([x, y]) => sparkle(x, y, 12, '#E2C177', 0.9) + sparkle(x + 40, y + 16, 9, '#F0E4C0', 0.8)).join(''),
  vignette(0.14),
]));

add('atlas', 'masjid_day', 1600, 1200, () => scene([
  skyRect(SKY.day), sun(300, 200, 60, CREAM, '#E8C089'), cloud(1100, 220, 130, 38, 0.5),
  hills('#6E8A80', 760, 40, 0.5), mosque(800, 900, 1.1, GREEN),
  `<rect x="0" y="900" width="${W}" height="300" fill="${IVORY}"/>`, `<rect x="0" y="900" width="${W}" height="18" fill="${DEEPGOLD}" opacity="0.6"/>`,
  `<path d="M 0 1010 H 1600 M 0 1110 H 1600" stroke="${DEEPGOLD}" stroke-width="3" opacity="0.3"/>`,
  hangLine(500, 520, 0.9), lantern(500, 520, 0.9), hangLine(1100, 520, 0.9), lantern(1100, 520, 0.9),
  vignette(0.14),
]));

// ================================================================= yunus ==
add('scenes', 'yunus_ship_calm', 1600, 1200, () => scene([
  skyRect(SKY.dayClear), sun(1220, 240, 70), cloud(320, 230, 140, 42, 0.6), cloud(760, 180, 100, 30, 0.5),
  mountains('#7FA6C0', 720, [[0, 720], [300, 600], [700, 690], [1100, 580], [1600, 700]], 0.45),
  sea(720), ship(760, 740, 1.05, 2), bird(1120, 420, 3), bird(1180, 380, 2.4), firefly(1370, 620, 1.2),
  rock(1520, H, 200, 100, '#2A4A5E'), vignette(0.16),
]));

add('scenes', 'yunus_storm', 1600, 1200, () => scene([
  skyRect(SKY.storm), stormCloud(400, 220, 260, 90), stormCloud(1100, 160, 300, 100), stormCloud(1500, 300, 200, 80),
  glow(760, 120, 320, IVORY, 0.22), rain(4, 140, 100, 900, SEA_FOAM, 0.3),
  bigWaves(620), ship(800, 700, 1.0, -14), bigWaves(900, ['#1E4B6E', '#12304A', '#081A2A'], 100),
  rain(9, 60, 500, 1200, SEA_FOAM, 0.25), firefly(1320, 480, 1.1), vignette(0.28),
]));

add('scenes', 'yunus_fish', 1600, 1200, () => scene([
  skyRect(SKY.deepSea), lightRays(800, -100, 7, 900, 1.2, SEA_FOAM, 0.12),
  bubbles(3, 40, 0, W, 100, 1100), fish(820, 620, 1.05), bubbles(8, 18, 300, 700, 500, 800),
  firefly(360, 380, 1.2), `<path d="M0 1120 Q 300 1060 600 1120 T 1200 1100 T 1600 1120 V 1200 H 0 Z" fill="#061220"/>`,
  vignette(0.3),
]));

add('scenes', 'yunus_dark', 1600, 1200, () => scene([
  skyRect(SKY.black),
  `<g fill="none" stroke="#1A2136" stroke-width="18" opacity="0.6"><path d="M 200 1300 Q 100 600 800 -100"/><path d="M 600 1300 Q 400 600 1000 -100"/><path d="M 1000 1300 Q 800 600 1300 -100"/><path d="M 1400 1300 Q 1200 600 1700 -100"/></g>`,
  bubbles(5, 14, 200, 1400, 200, 1000), glow(800, 640, 380, '#FFE9A8', 0.22), firefly(800, 620, 1.9),
  vignette(0.35),
]));

add('scenes', 'yunus_shore', 1600, 1200, () => scene([
  skyRect(SKY.dawn), sun(360, 300, 90, CREAM, '#E8B36A', 12), cloud(1100, 220, 130, 40, 0.5),
  sea(660, '#4F7C9A', '#1E4B6E', '#12304A', SEA_FOAM, 22),
  `<path d="M 0 1200 V 900 Q 500 780 900 900 Q 1300 1000 1600 860 V 1200 Z" fill="${SAND}"/>`,
  `<path d="M 0 1200 V 980 Q 500 900 900 980 Q 1300 1060 1600 960 V 1200 Z" fill="${SAND_LIGHT}"/>`,
  `<path d="M 900 900 Q 1300 1000 1600 860" stroke="${SEA_FOAM}" stroke-width="14" fill="none" opacity="0.6"/>`,
  fish(300, 760, 0.45, '#0F2438', '#183A55', false, true),
  `<ellipse cx="1180" cy="1010" rx="14" ry="9" fill="${IVORY}"/><ellipse cx="1320" cy="1060" rx="12" ry="8" fill="${CREAM}"/><ellipse cx="640" cy="1080" rx="16" ry="10" fill="${IVORY}"/>`,
  firefly(1420, 700, 1.2), vignette(0.16),
]));

add('scenes', 'yunus_plant', 1600, 1200, () => scene([
  skyRect(SKY.amber), sun(280, 220, 90, CREAM, '#E8B36A', 14), cloud(1200, 240, 120, 36, 0.4),
  dunes(SAND, SAND_DARK, 820), `<ellipse cx="880" cy="1040" rx="420" ry="70" fill="#8A5348" opacity="0.45"/>`,
  gourdPlant(700, 1000, 1.2), grass(6, 1080, 30, '#2E5D48'), firefly(1260, 620, 1.2), vignette(0.16),
]));

// =================================================================== nuh ==
add('scenes', 'nuh_idols', 1600, 1200, () => scene([
  skyRect(SKY.violetDusk), stars(2, 40, 0, W, 0, 500), crescent(280, 200, 60),
  mountains('#4A3560', 720, [[0, 720], [400, 580], [800, 700], [1200, 560], [1600, 680]], 0.7),
  hills('#6E4038', 860, 40), `<rect x="0" y="960" width="${W}" height="240" fill="#4A2F22"/>`,
  `<rect x="300" y="900" width="1000" height="70" rx="10" fill="${STONE}"/>`,
  statue(520, 900, 0.9, STONE_DARK), statue(800, 900, 1.05, STONE_DARK), statue(1080, 900, 0.9, STONE_DARK),
  firefly(1360, 760, 1.2), vignette(0.24),
]));

add('scenes', 'nuh_day_and_night', 1600, 1200, () => scene([
  skyRect(SKY.dayClear, 0, H, 0, 800), skyRect(SKY.night, 0, H, 800, W),
  `<rect x="760" y="0" width="80" height="${H}" fill="#3A4A6A" opacity="0.5"/>`,
  sun(300, 260, 80, CREAM, '#E8C089', 12), stars(17, 60, 820, W, 0, 600), fullMoon(1300, 240, 70),
  hills('#7C9F6E', 760, 60), hills('#3F5A48', 860, 50), `<rect x="0" y="960" width="${W}" height="240" fill="#2E4A3A"/>`,
  tree(800, 960, 1.4, WOOD_DARK, '#3F7A5E', '#5F8A5A'), firefly(1080, 700, 1.2), vignette(0.18),
]));

add('scenes', 'nuh_ark_dry', 1600, 1200, () => scene([
  skyRect(SKY.amber), sun(1260, 240, 90, CREAM, '#E8B36A', 12), cloud(300, 200, 140, 40, 0.5),
  dunes(SAND, SAND_DARK, 780), `<rect x="0" y="1000" width="${W}" height="200" fill="#8A5348"/>`,
  `<rect x="280" y="940" width="120" height="70" fill="${WOOD_DARK}"/><rect x="1200" y="940" width="120" height="70" fill="${WOOD_DARK}"/>`,
  ark(800, 960, 0.95), plank(120, 1020, 260, 34, -6), plank(140, 1060, 260, 34, 4), plank(1280, 1040, 240, 32, 6),
  nails(3, 14, 1180, 1400, 1000, 1080), hammer(1440, 900, 0.7, -30), saw(60, 900, 0.7, 12),
  firefly(1120, 660, 1.2), vignette(0.16),
]));

add('scenes', 'nuh_animals', 1600, 1200, () => scene([
  skyRect(SKY.day), sun(260, 200, 70), cloud(1000, 180, 140, 40, 0.5), cloud(1400, 300, 100, 30, 0.4),
  hills('#7C9F6E', 760, 50), `<rect x="0" y="1000" width="${W}" height="200" fill="#5F8A5A"/>`,
  ark(1120, 860, 0.8),
  `<path d="M 260 1060 L 900 780 L 900 830 L 300 1100 Z" fill="${WOOD_LIGHT}"/><path d="M 260 1060 L 900 780" stroke="${WOOD_DARK}" stroke-width="8"/>`,
  sheep(420, 1050, 0.9), sheep(520, 1005, 0.9), camel(700, 940, 0.9), camel(820, 890, 0.85),
  dove(980, 640, 1.1), dove(1060, 600, 0.9, IVORY, true), bird(520, 500, 3), bird(600, 470, 2.6),
  sheep(160, 1130, 0.8, IVORY, INK_SOFT), sheep(80, 1160, 0.7, '#E8DCC0', INK_SOFT),
  firefly(1380, 560, 1.2), vignette(0.16),
]));

add('scenes', 'nuh_flood', 1600, 1200, () => scene([
  skyRect(SKY.storm), stormCloud(300, 200, 280, 90), stormCloud(1000, 140, 320, 100), stormCloud(1450, 320, 220, 80),
  rain(4, 160, 60, 900, SEA_FOAM, 0.3, 60, 80),
  bigWaves(520, ['#4F7C9A', '#1E4B6E', '#12304A'], 130), ark(820, 700, 0.85, true),
  bigWaves(880, ['#1E4B6E', '#12304A', '#081A2A'], 110), rain(9, 70, 500, 1200, SEA_FOAM, 0.22),
  firefly(340, 460, 1.1), vignette(0.28),
]));

add('scenes', 'nuh_calm', 1600, 1200, () => scene([
  skyRect(SKY.dawn), lightRays(800, 160, 9, 1100, 1.4, CREAM, 0.14), sun(800, 220, 90, CREAM, '#E8B36A'),
  cloud(300, 300, 200, 60, 0.7), cloud(1300, 260, 220, 66, 0.7), cloud(800, 380, 160, 44, 0.5),
  sea(760, '#7A9AA8', '#4F7C9A', '#1E4B6E', IVORY, 10), ark(800, 800, 0.42, true),
  `<path d="M 700 860 Q 800 900 900 860 M 640 960 Q 800 1020 960 960" stroke="${IVORY}" stroke-width="6" fill="none" opacity="0.4" stroke-linecap="round"/>`,
  dove(1180, 560, 1.0), firefly(420, 620, 1.2), vignette(0.14),
]));

add('scenes', 'nuh_judi', 1600, 1200, () => scene([
  skyRect(SKY.emeraldLift), sun(1240, 260, 80, CREAM, '#E8C089', 12), cloud(300, 260, 150, 44, 0.6), cloud(700, 180, 110, 34, 0.5),
  mountains('#3F5A48', 900, [[0, 900], [300, 700], [560, 820], [1600, 600]], 0.55),
  mountains('#2E4A3A', 1000, [[0, 1000], [500, 560], [800, 380], [1100, 600], [1600, 900]]),
  `<path d="M 700 500 L 800 380 L 900 500 Z" fill="${IVORY}" opacity="0.5"/>`, ark(800, 520, 0.36),
  hills('#5F8A5A', 1080, 30), tree(220, 1120, 0.7), tree(1400, 1100, 0.8), bird(1000, 400, 3), bird(1060, 370, 2.4),
  firefly(520, 760, 1.2), vignette(0.16),
]));

// ================================================================= yusuf ==
const elevenStars = (cx, cy, r) => {
  let out = '';
  for (let i = 0; i < 11; i++) {
    const a = Math.PI + (i / 10) * Math.PI;
    out += star8(cx + Math.cos(a) * r, cy + Math.sin(a) * r * 0.62, 26 + (i % 3) * 6, GOLD);
  }
  return out;
};

add('scenes', 'yusuf_dream', 1600, 1200, () => scene([
  skyRect(SKY.violet), stars(23, 120, 0, W, 0, 900, IVORY, 2), elevenStars(800, 720, 620),
  sun(560, 380, 70, CREAM, '#E8B36A', 12), crescent(1040, 380, 60),
  hills('#2C2347', 960, 50), hills('#211A38', 1060, 30), firefly(800, 560, 1.4), vignette(0.2),
]));

add('scenes', 'yusuf_well', 1600, 1200, () => scene([
  skyRect(SKY.violetDusk), stars(3, 30, 0, W, 0, 400), crescent(1300, 200, 60),
  mountains('#4A3560', 760, [[0, 760], [400, 620], [800, 720], [1200, 580], [1600, 700]], 0.6),
  dunes('#B0743B', '#8A5348', 840), well(800, 1040, 1.0, false), rock(200, 1120, 90, 40, '#6E4038'), rock(1400, 1100, 120, 50, '#6E4038'),
  tree(1280, 940, 0.8, WOOD_DARK, '#3F5A48', '#4A6A50'), firefly(1020, 760, 1.2), vignette(0.22),
]));

add('scenes', 'yusuf_caravan', 1600, 1200, () => scene([
  skyRect(SKY.amber), sun(1280, 260, 100, CREAM, '#E8B36A', 12),
  dunes(SAND, SAND_DARK, 760), camel(1180, 760, 0.7), camel(1320, 780, 0.65), camel(1040, 800, 0.72),
  `<rect x="0" y="1000" width="${W}" height="200" fill="#8A5348"/>`,
  well(560, 1120, 1.0, true), rope(560, 750, 560, 900), bucket(560, 900, 1.0), glow(560, 900, 160, CREAM, 0.45),
  firefly(900, 620, 1.2), vignette(0.16),
]));

add('scenes', 'yusuf_prison', 1600, 1200, () => scene([
  skyRect([[0, '#2A2420'], [0.6, '#3A2F28'], [1, '#1E1814']]),
  `<g stroke="#1E1814" stroke-width="4" opacity="0.5">${[200, 400, 600, 800, 1000].map((y) => `<path d="M 0 ${y} H 1600"/>`).join('')}${[300, 700, 1100, 1500].map((x) => `<path d="M ${x} 0 V 200 M ${x + 200} 200 V 400 M ${x} 400 V 600 M ${x + 200} 600 V 800 M ${x} 800 V 1000"/>`).join('')}</g>`,
  archWindow(800, 160, 300, 380, true),
  `<g stroke="#1E1814" stroke-width="16" stroke-linecap="round"><path d="M 740 240 V 540 M 800 200 V 540 M 860 240 V 540"/></g>`,
  `<path d="M 650 540 L 1000 540 L 1300 1200 L 300 1200 Z" fill="${IVORY}" opacity="0.14"/>`,
  `<rect x="0" y="1000" width="${W}" height="200" fill="#1A1410"/>`,
  jar(280, 1010, 0.8, '#5A3A28'), firefly(1080, 800, 1.3), vignette(0.32),
]));

add('scenes', 'yusuf_cows', 1600, 1200, () => scene([
  skyRect(SKY.day), sun(300, 220, 70), cloud(1100, 220, 140, 40, 0.5),
  hills('#7C9F6E', 720, 50), `<path d="M 0 900 Q 400 840 800 900 T 1600 880 V 1200 H 0 Z" fill="#4F7C9A"/>`,
  `<path d="M 0 900 Q 400 840 800 900 T 1600 880" stroke="${SEA_FOAM}" stroke-width="8" fill="none" opacity="0.5"/>`,
  hills('#5F8A5A', 1020, 30),
  [0, 1, 2, 3, 4, 5, 6].map((i) => cow(180 + i * 200, 860 - (i % 2) * 30, 0.62, true)).join(''),
  [0, 1, 2, 3, 4, 5, 6].map((i) => cow(240 + i * 190, 1140 - (i % 2) * 20, 0.62, false)).join(''),
  firefly(1460, 640, 1.2), vignette(0.16),
]));

add('scenes', 'yusuf_grain', 1600, 1200, () => scene([
  skyRect(SKY.amber), sun(280, 220, 80, CREAM, '#E8B36A', 12), cloud(1200, 200, 120, 36, 0.45),
  dunes(SAND, SAND_DARK, 760),
  `<rect x="880" y="520" width="640" height="440" fill="${WALL_DEEP}"/><path d="M 860 520 L 1200 380 L 1540 520 Z" fill="${WOOD}"/>`,
  `<path d="M 1130 960 V 760 A 70 70 0 0 1 1270 760 V 960 Z" fill="#3B2A1E"/><rect x="920" y="620" width="60" height="80" rx="30" fill="#3B2A1E"/><rect x="1420" y="620" width="60" height="80" rx="30" fill="#3B2A1E"/>`,
  `<rect x="0" y="960" width="${W}" height="240" fill="#8A5348"/>`,
  sack(260, 1040, 1.0), sack(420, 1060, 0.9), sack(340, 940, 0.85), jar(600, 1050, 0.9), jar(720, 1070, 0.8),
  wheat(120, 1000, 1.2), wheat(170, 1010, 1.0), wheat(90, 1020, 0.9), wheat(1400, 1080, 1.1), wheat(1460, 1090, 0.9),
  firefly(1060, 660, 1.2), vignette(0.16),
]));

add('scenes', 'yusuf_bowing', 1600, 1200, () => scene([
  skyRect(SKY.dawn), lightRays(800, 700, 11, 900, 2.2, CREAM, 0.1), elevenStars(800, 760, 640),
  sun(600, 460, 60, CREAM, '#E8B36A', 12), crescent(1000, 460, 52),
  `<path d="M 480 900 L 540 640 H 1060 L 1120 900 Z" fill="#8A5348"/><path d="M 520 640 L 560 560 H 1040 L 1080 640 Z" fill="#6E4038"/><rect x="760" y="760" width="80" height="140" rx="40" fill="${GOLD}"/>`,
  glow(800, 830, 200, GOLD, 0.35), `<rect x="0" y="900" width="${W}" height="300" fill="#4A2F22"/>`,
  palm(240, 900, 1.1, '#3A2A1E'), palm(1380, 900, 0.9, '#3A2A1E'), firefly(1220, 700, 1.2), vignette(0.18),
]));

// =============================================================== pillars ==
const roomFloorY = () => H * 0.72;
add('scenes', 'pillars_fallen', 1600, 1200, () => scene([
  room(true), archWindow(1220, 140, 260, 360, false), hangLine(380, 420, 0.9), lantern(380, 420, 0.9),
  blanket(800, 1040, 700, 160, '#4A5D8A', 0.3),
  cushion(560, 1060, 180, 60, CUSHION_COLORS[0], -18), cushion(1020, 1050, 180, 60, CUSHION_COLORS[1], 22), cushion(800, 1090, 170, 60, CUSHION_COLORS[2], 6),
  child('safa', { x: 330, y: 1090, s: 1.0, arms: 'out' }), child('zayn', { x: 1290, y: 1100, s: 0.88, arms: 'down', flip: true }),
  firefly(1000, 640, 1.2), vignette(0.16),
]));

add('scenes', 'pillars_cushions', 1600, 1200, () => scene([
  room(true), archWindow(1220, 140, 260, 360, false), hangLine(380, 420, 0.9), lantern(380, 420, 0.9),
  [0, 1, 2, 3, 4].map((i) => cushion(560 + i * 120, 1000, 100, 150, CUSHION_COLORS[i])).join(''),
  blanket(800, 1000, 760, 120, '#4A5D8A', 0.2),
  child('zayn', { x: 330, y: 1090, s: 0.9, pose: 'sit' }), child('safa', { x: 1290, y: 1090, s: 1.0, pose: 'sit', flip: true }),
  firefly(1000, 700, 1.2), vignette(0.16),
]));

add('scenes', 'pillars_house', 1600, 1200, () => scene([
  skyRect(SKY.emeraldLift), stars(31, 40, 0, W, 0, 500, CREAM, 2), glow(800, 640, 560, CREAM, 0.3),
  hills('#3F5A48', 960, 40), `<rect x="0" y="1020" width="${W}" height="180" fill="#2E4A3A"/>`,
  pillarHouse(800, 1020, 1.0), sparkle(300, 300, 18), sparkle(1300, 260, 16), sparkle(1400, 700, 14),
  firefly(1160, 560, 1.2), vignette(0.16),
]));

add('scenes', 'pillars_mat', 1600, 1200, () => scene([
  skyRect(SKY.day),
  // five suns along the day: fajr, dhuhr, asr, maghrib, and the isha moon
  sun(160, 720, 44, CREAM, '#E8B36A'), sun(480, 320, 50, CREAM, '#E8C089', 12), sun(800, 180, 56, CREAM, '#E8C089', 12), sun(1120, 320, 50, CREAM, '#E8B36A'), crescent(1440, 720, 44),
  `<path d="M 160 720 Q 800 -80 1440 720" stroke="${GOLD}" stroke-width="6" fill="none" stroke-dasharray="18 22" opacity="0.6"/>`,
  hills('#7C9F6E', 880, 40), `<rect x="0" y="960" width="${W}" height="240" fill="#4A2F22"/>`,
  prayerMat(800, 900, 720, 200), firefly(1240, 560, 1.2), vignette(0.16),
]));

add('scenes', 'pillars_coins', 1600, 1200, () => scene([
  room(false), archWindow(400, 140, 260, 360, true), hangLine(1240, 420, 0.9), lantern(1240, 420, 0.9),
  table(H * 0.72), coinBox(1000, 860, 1.0), coin(930, 640, 0.9, 20), coin(1160, 700, 0.7, -30), coin(600, 900, 0.8, 10), coin(700, 880, 0.7, 40),
  child('zayn', { x: 560, y: 1150, s: 1.05, arms: 'up' }), firefly(1320, 660, 1.2), vignette(0.16),
]));

add('scenes', 'pillars_dates', 1600, 1200, () => scene([
  room(false), archWindow(800, 100, 320, 420, true), hangLine(260, 400, 0.9), lantern(260, 400, 0.9), hangLine(1340, 400, 0.9), lantern(1340, 400, 0.9),
  table(H * 0.72), bowlOfDates(800, 1000, 1.05), glass(1080, 1000, 1.0), glass(520, 1000, 0.9),
  child('safa', { x: 1290, y: 1150, s: 1.0, pose: 'sit', flip: true }), firefly(560, 700, 1.2), vignette(0.18),
]));

add('scenes', 'pillars_kaaba', 1600, 1200, () => scene([
  skyRect(SKY.dayClear), sun(280, 220, 70), cloud(1100, 200, 140, 40, 0.5), cloud(1400, 340, 100, 30, 0.4),
  `<rect x="0" y="760" width="${W}" height="440" fill="${IVORY}"/>`, `<rect x="0" y="760" width="${W}" height="16" fill="${DEEPGOLD}" opacity="0.5"/>`,
  minaret(120, 760, 420, 40, STONE_LIGHT), minaret(1480, 760, 420, 40, STONE_LIGHT), minaret(400, 760, 300, 30, '#C9BFAA'), minaret(1200, 760, 300, 30, '#C9BFAA'),
  `<ellipse cx="800" cy="1060" rx="520" ry="110" fill="${STONE_LIGHT}" opacity="0.5"/>`, glow(800, 900, 420, CREAM, 0.3),
  kaaba(800, 1060, 0.95), dove(1120, 560, 0.9), dove(500, 600, 0.8, IVORY, true), firefly(1280, 780, 1.2), vignette(0.14),
]));

add('scenes', 'pillars_standing', 1600, 1200, () => scene([
  room(true), archWindow(1220, 140, 260, 360, false), hangLine(380, 420, 0.9), lantern(380, 420, 0.9),
  [0, 1, 2, 3, 4].map((i) => cushion(560 + i * 120, 1060, 100, 160, CUSHION_COLORS[i])).join(''),
  `<path d="M 440 900 L 800 620 L 1160 900 Z" fill="#4A5D8A"/><path d="M 470 900 L 800 660 L 1130 900 Z" fill="#5A6FA0" opacity="0.5"/><rect x="440" y="896" width="720" height="14" rx="7" fill="#3A4A70"/>`,
  child('safa', { x: 330, y: 1090, s: 1.0, arms: 'up' }), child('zayn', { x: 1290, y: 1100, s: 0.88, arms: 'up', flip: true }),
  sparkle(800, 560, 16), sparkle(700, 620, 10), sparkle(900, 640, 12), firefly(1010, 760, 1.2), vignette(0.16),
]));

// ================================================================ covers ==
add('pbCovers', 'yunus_cover', 1024, 1024, () => scene([
  skyRect(SKY.deepSea), lightRays(512, -60, 6, 700, 1.1, SEA_FOAM, 0.12), bubbles(3, 30, 0, W, 60, 900),
  fish(520, 560, 0.62), firefly(240, 300, 1.3), `<path d="M0 940 Q 250 880 512 940 T 1024 930 V 1024 H 0 Z" fill="#061220"/>`, vignette(0.3),
]));

add('pbCovers', 'nuh_cover', 1024, 1024, () => scene([
  skyRect(SKY.dawn), lightRays(512, 120, 7, 700, 1.2, CREAM, 0.12), sun(512, 150, 60, CREAM, '#E8B36A'),
  cloud(200, 240, 150, 46, 0.7), cloud(840, 200, 160, 50, 0.7),
  bigWaves(520, ['#4F7C9A', '#1E4B6E', '#12304A'], 100), ark(520, 640, 0.6, true), bigWaves(800, ['#1E4B6E', '#12304A', '#081A2A'], 80),
  dove(300, 420, 0.8), firefly(800, 420, 1.2), vignette(0.2),
]));

add('pbCovers', 'yusuf_cover', 1024, 1024, () => scene([
  skyRect(SKY.violet), stars(23, 80, 0, W, 0, 700, IVORY, 2), elevenStars(512, 560, 400),
  sun(380, 320, 44, CREAM, '#E8B36A', 12), crescent(660, 320, 40),
  dunes('#4A3560', '#2C2347', 720), well(512, 940, 0.7, false), firefly(760, 700, 1.2), vignette(0.22),
]));

add('covers', 'five_pillars_cover', 1024, 1024, () => scene([
  skyRect(SKY.emeraldLift), stars(31, 30, 0, W, 0, 400, CREAM, 2), glow(512, 560, 420, CREAM, 0.3),
  hills('#3F5A48', 820, 30), `<rect x="0" y="880" width="${W}" height="144" fill="#2E4A3A"/>`,
  pillarHouse(512, 880, 0.78), sparkle(160, 200, 16), sparkle(860, 180, 14), firefly(800, 520, 1.2), vignette(0.16),
]));

// ============================================================= backdrops ==
add('pbBackdrops', 'yunus_backdrop', 1600, 1200, () => scene([
  skyRect(SKY.night), stars(21, 90, 0, W, 0, 640), fullMoon(1180, 220, 80), sea(700, '#2C4F6E', '#16324B', '#0B1E30', '#7A9AA8', 24),
  fish(400, 1040, 0.5, '#0B1E30', '#12304A', false, true), vignette(0.22),
]));
add('pbBackdrops', 'nuh_backdrop', 1600, 1200, () => scene([
  skyRect(SKY.dawn), cloud(300, 300, 200, 60, 0.6), cloud(1300, 260, 220, 66, 0.6), sun(800, 220, 90, CREAM, '#E8B36A'),
  sea(760, '#7A9AA8', '#4F7C9A', '#1E4B6E', IVORY, 10), vignette(0.14),
]));
add('pbBackdrops', 'yusuf_backdrop', 1600, 1200, () => scene([
  skyRect(SKY.violet), stars(23, 120, 0, W, 0, 900, IVORY, 2), elevenStars(800, 720, 620), hills('#2C2347', 960, 50), hills('#211A38', 1060, 30), vignette(0.2),
]));

// ------------------------------------------------------------------ write --
mkdirSync(SVG_OUT, { recursive: true });
for (const dir of Object.values(OUT)) mkdirSync(dir, { recursive: true });
const report = [];
for (const [dir, name, w, h, fn] of SCENES) {
  if (ONLY.length && !ONLY.some((p) => name.startsWith(p))) continue;
  W = w; H = h; gradN = 0; DEFS = '';
  const svgPath = join(SVG_OUT, `${name}.svg`);
  writeFileSync(svgPath, fn());
  const png = join(SVG_OUT, `${name}.png`);
  let r = spawnSync('rsvg-convert', ['-w', String(w), '-h', String(h), '-o', png, svgPath]);
  if (r.status !== 0) throw new Error(`rsvg-convert failed for ${name}: ${r.stderr}`);
  const webp = join(OUT[dir], `${name}.webp`);
  r = spawnSync('cwebp', ['-quiet', '-q', '80', png, '-o', webp]);
  if (r.status !== 0) throw new Error(`cwebp failed for ${name}: ${r.stderr}`);
  unlinkSync(png);
  report.push(`${dir}/${name}.webp ${(statSync(webp).size / 1024).toFixed(1)} KB`);
}
console.log(report.join('\n'));
console.log(`${report.length} images`);
