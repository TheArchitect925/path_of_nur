// Path of Nur — the picture-book scene grammar, shared.
//
// This is the helper half of tooling/art_src/kids_books/generate_kids_books_art.mjs
// (palette, skies, silhouettes, animals, the child cast) lifted verbatim so the
// story-scene generator next to this file draws in the same hand. Keep it in
// step with the source when a helper there changes; nothing here is edited by
// hand except the export list and setCanvas at the bottom.
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

/// Each image resets the canvas and the gradient defs before drawing.
export function setCanvas(w, h) { W = w; H = h; DEFS = ''; gradN = 0; }
export { IVORY, INK, WOOD, SEA, GREEN, SAND, STONE, WALL, SKY, W, DEFS, gradN, mulberry32, f, skyRect, glow, vignette, stars, crescent, fullMoon, sun, lightRays, hills, dunes, mountains, groundBand, cloud, stormCloud, rain, star8, sparkle, firefly, lantern, hangLine, dome, minaret, mosque, city, palm, tree, grass, rock, sea, bigWaves, bubbles, ship, ark, plank, nails, hammer, saw, fish, well, bucket, rope, camel, sheep, bird, dove, cow, wheat, sack, jar, statue, gourdPlant, room, archWindow, cushion, CUSHION_COLORS, blanket, coinBox, coin, bowlOfDates, glass, table, kaaba, prayerMat, LINE, CAST, child, pillarHouse, scene, CREAM, GOLD, DEEPGOLD, INK_SOFT, WOOD_DARK, WOOD_LIGHT, SEA_DEEP, SEA_LIGHT, SEA_FOAM, GREEN_DEEP, LEAF, LEAF_LIGHT, SAND_DARK, SAND_LIGHT, STONE_DARK, STONE_LIGHT, WALL_DEEP, FLOOR, H, SKIN, TROUSER, CAP, CAP_BAND };
