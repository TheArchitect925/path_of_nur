// Path of Nur — batch-2 kids art generator (FULL SET, 59 scenes).
// Same visual language as learn_art v2 (tooling/art_src/learn_art/):
// soft gradient skies anchored to app theme tokens, large calm silhouettes,
// warm ivory light, gold accents; no faces, no figures, no baked-in text.
// Story moments are told through objects, places, and gentle animal
// silhouettes — never people — matching the app-wide art language.
//
// Packs and output ratios (webp targets in the 40–120 KB budget):
//   ks_cover    (1024x1024) 11  assets/images/kids_stories/covers/
//   ks_backdrop (1600x1200) 11  assets/images/kids_stories/backdrops/
//   ks_scene    (1600x1200)  2  assets/images/kids_stories/scenes/
//   pb_cover    (1024x1024) 11  assets/images/prophets/bedtime_stories/covers/
//   pb_backdrop (1600x1200) 11  assets/images/prophets/bedtime_stories/backdrops/
//   qt          (1024x768)  13  assets/images/quran_teacher/...
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const OUT = fileURLToPath(new URL('./svg/', import.meta.url));

const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';

const SKY = {
  dawn: [[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']],
  day: [[0, '#31547A'], [0.6, '#7A9AA8'], [1, '#E8C089']],
  night: [[0, '#121423'], [0.55, '#1A1F33'], [1, '#232A44']],
  violet: [[0, '#151024'], [0.55, '#211A38'], [1, '#2C2347']],
  violetLift: [[0, '#211A38'], [0.6, '#2C2347'], [1, '#4A3560']],
  violetDusk: [[0, '#2C2347'], [0.6, '#4A3560'], [1, '#8A5348']],
  emerald: [[0, '#0D271E'], [0.5, '#16382C'], [1, '#2E5D48']],
  emeraldLift: [[0, '#1E4B3A'], [0.55, '#2E5D48'], [1, '#7C7F58']],
  amber: [[0, '#B0743B'], [0.6, '#D19A56'], [1, '#E8C089']],
  // Pastel classroom recipes for the quran_teacher pack.
  pastelSky: [[0, '#EDE8D8'], [0.55, '#D9E0D2'], [1, '#A9C4BC']],
  pastelWarm: [[0, '#F2ECDA'], [0.6, '#EBDCC0'], [1, '#DDBE94']],
  pastelBlue: [[0, '#EDEAE0'], [0.55, '#D4DCE2'], [1, '#A6BBCB']],
  pastelNight: [[0, '#3A3F5C'], [0.6, '#565C80'], [1, '#8B8FB0']],
};

let W = 1600, H = 1200;

function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

const svgDoc = (inner) =>
  `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${W} ${H}">${inner}</svg>`;

let gradN = 0;
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

function stars(seed, n, x0, x1, y0, y1, color = IVORY) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0);
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${(1.6 + rnd() * 2.6).toFixed(1)}" fill="${color}" opacity="${(0.35 + rnd() * 0.5).toFixed(2)}"/>`;
  }
  return out;
}

// Mask-based crescent: a lit disc with an offset bite, safe over gradients.
// (The learn_art arc-path crescent renders as a zero-area sliver in newer
// librsvg — the inner arc's endpoints exceed its diameter. Never copy it.)
function crescent(cx, cy, r, lit) {
  const id = `cr${gradN++}`;
  return `<defs><mask id="${id}">` +
    `<rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="black"/>` +
    `<circle cx="${cx}" cy="${cy}" r="${r}" fill="white"/>` +
    `<circle cx="${cx + r * 0.46}" cy="${cy - r * 0.2}" r="${r * 0.88}" fill="black"/>` +
    `</mask></defs>` +
    `<rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="${lit}" mask="url(#${id})"/>`;
}

const fullMoon = (cx, cy, r, lit = IVORY) =>
  `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${lit}"/>` +
  `<circle cx="${cx - r * 0.3}" cy="${cy - r * 0.15}" r="${r * 0.16}" fill="#DDD0A8" opacity="0.7"/>` +
  `<circle cx="${cx + r * 0.25}" cy="${cy + r * 0.3}" r="${r * 0.11}" fill="#DDD0A8" opacity="0.6"/>`;

const hills = (color, yTop, amp = 60) =>
  `<path d="M0 ${yTop + amp} Q ${W * 0.22} ${yTop - amp} ${W * 0.5} ${yTop} T ${W} ${yTop - amp * 0.4} V ${H} H 0 Z" fill="${color}"/>`;

const dunes = (c1, c2, yTop) =>
  `<path d="M0 ${yTop} Q ${W * 0.3} ${yTop - 90} ${W * 0.62} ${yTop - 10} T ${W} ${yTop - 50} V ${H} H 0 Z" fill="${c1}"/>` +
  `<path d="M0 ${yTop + 90} Q ${W * 0.4} ${yTop + 10} ${W * 0.78} ${yTop + 80} T ${W} ${yTop + 60} V ${H} H 0 Z" fill="${c2}"/>`;

const groundBand = (color, y = H * 0.79) =>
  `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/>`;

const cloud = (cx, cy, rx, ry, op) =>
  `<g opacity="${op}" fill="${CREAM}"><ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}"/><ellipse cx="${cx - rx * 0.55}" cy="${cy + ry * 0.35}" rx="${rx * 0.6}" ry="${ry * 0.75}"/><ellipse cx="${cx + rx * 0.55}" cy="${cy + ry * 0.3}" rx="${rx * 0.65}" ry="${ry * 0.7}"/></g>`;

const sparkle = (x, y, r, fill = GOLD, op = 0.9) =>
  `<path d="M ${x} ${y - r} Q ${x + r * 0.18} ${y - r * 0.18} ${x + r} ${y} Q ${x + r * 0.18} ${y + r * 0.18} ${x} ${y + r} Q ${x - r * 0.18} ${y + r * 0.18} ${x - r} ${y} Q ${x - r * 0.18} ${y - r * 0.18} ${x} ${y - r} Z" fill="${fill}" opacity="${op}"/>`;

function star8(cx, cy, r, fill = GOLD, inner) {
  let p = '';
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * Math.PI * 2 - Math.PI / 2;
    const b = a + Math.PI / 8;
    p += `${cx + Math.cos(a) * r},${cy + Math.sin(a) * r} ${cx + Math.cos(b) * r * 0.45},${cy + Math.sin(b) * r * 0.45} `;
  }
  return `<polygon points="${p}" fill="${fill}"/>` +
    (inner ? `<circle cx="${cx}" cy="${cy}" r="${r * 0.22}" fill="${inner}"/>` : '');
}

function lantern(cx, cy, s, body = GOLD, glass = CREAM) {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
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
    `<path d="M ${x - wdt * 0.9} ${baseY - hgt} H ${x + wdt * 0.9} L ${x} ${baseY - hgt - wdt * 2.2} Z" fill="${color}"/>`;
}

function mosqueSilhouette(cx, baseY, scale, color) {
  const w = 620 * scale;
  return `<rect x="${cx - w / 2}" y="${baseY - 150 * scale}" width="${w}" height="${150 * scale}" fill="${color}"/>` +
    dome(cx, baseY - 150 * scale, 150 * scale, color) +
    minaret(cx - w / 2 - 40 * scale, baseY, 360 * scale, 44 * scale, color) +
    minaret(cx + w / 2 + 40 * scale, baseY, 360 * scale, 44 * scale, color);
}

function palm(x, gy, s, color) {
  const fr = (a) => `<path d="M 0 -170 q ${90 * Math.cos(a)} ${-46 - 34 * Math.sin(a)} ${168 * Math.cos(a)} ${-14 * Math.sin(a) + 26}" stroke="${color}" stroke-width="17" fill="none" stroke-linecap="round"/>`;
  return `<g transform="translate(${x} ${gy}) scale(${s})">` +
    `<path d="M -14 0 Q 4 -90 -6 -170 L 16 -170 Q 18 -90 12 0 Z" fill="${color}"/>` +
    `<g transform="translate(2 0)">${fr(0.3)}${fr(1.2)}${fr(2.0)}${fr(2.9)}${fr(-0.6)}</g></g>`;
}

// --- pack-specific helpers ---

const steam = (cx, cy, s, color = CREAM, op = 0.8) =>
  `<path d="M ${cx} ${cy} q ${-18 * s} ${-26 * s} 0 ${-52 * s} q ${18 * s} ${-26 * s} 0 ${-52 * s}" stroke="${color}" stroke-width="${9 * s}" stroke-linecap="round" fill="none" opacity="${op}"/>`;

function bowl(cx, baseY, s, body = '#B8683C', rim = CREAM) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -110 -60 A 110 110 0 0 0 110 -60 L 96 -34 Q 0 12 -96 -34 Z" fill="${body}"/>` +
    `<ellipse cx="0" cy="-60" rx="110" ry="24" fill="${rim}"/>` +
    `<ellipse cx="0" cy="-60" rx="86" ry="16" fill="#D9A05B"/>` +
    `<rect x="-34" y="-6" width="68" height="12" rx="6" fill="#8A4A28"/></g>`;
}

const breadLoaf = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<ellipse cx="0" cy="0" rx="96" ry="34" fill="#D9A05B"/>` +
  `<ellipse cx="0" cy="-10" rx="96" ry="30" fill="#E8C089"/>` +
  `<path d="M -50 -18 q 10 -10 20 0 M -6 -24 q 10 -10 20 0 M 38 -16 q 10 -10 20 0" stroke="#B8683C" stroke-width="6" fill="none" stroke-linecap="round"/></g>`;

const cup = (cx, baseY, s, body = '#5E8A6A') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -34 -76 L -26 0 H 26 L 34 -76 Z" fill="${body}"/>` +
  `<ellipse cx="0" cy="-76" rx="34" ry="10" fill="${CREAM}"/></g>`;

function tableBand(y, wood = '#6E4629', runner = '#8A5A36') {
  return `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${wood}"/>` +
    `<rect x="0" y="${y}" width="${W}" height="26" fill="#54382A"/>` +
    `<rect x="${W * 0.14}" y="${y + 26}" width="${W * 0.72}" height="${H - y}" fill="${runner}" opacity="0.55"/>`;
}

function archWindow(cx, topY, w, h, frame, skyStops, inner) {
  const s = skyV(skyStops);
  const skyId = gradN - 1;
  const id = `win${gradN++}`;
  const r = w / 2;
  return `<defs>${s.def}<clipPath id="${id}"><path d="M ${cx - r} ${topY + h} V ${topY + r} A ${r} ${r} 0 0 1 ${cx + r} ${topY + r} V ${topY + h} Z"/></clipPath></defs>` +
    `<path d="M ${cx - r - 18} ${topY + h + 18} V ${topY + r} A ${r + 18} ${r + 18} 0 0 1 ${cx + r + 18} ${topY + r} V ${topY + h + 18} Z" fill="${frame}"/>` +
    `<g clip-path="url(#${id})"><rect x="${cx - r}" y="${topY}" width="${w}" height="${h + r}" fill="url(#sky${skyId})"/>${inner}</g>`;
}

function tree(cx, baseY, s, trunk = '#54382A', leaf = '#5E8A6A', leaf2 = '#4A7A58') {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -18 0 L -10 -150 Q 0 -170 10 -150 L 18 0 Z" fill="${trunk}"/>` +
    `<path d="M -8 -120 Q -60 -140 -88 -180" stroke="${trunk}" stroke-width="14" fill="none" stroke-linecap="round"/>` +
    `<path d="M 8 -140 Q 60 -160 84 -200" stroke="${trunk}" stroke-width="14" fill="none" stroke-linecap="round"/>` +
    `<circle cx="-90" cy="-210" r="86" fill="${leaf2}"/>` +
    `<circle cx="90" cy="-230" r="92" fill="${leaf2}"/>` +
    `<circle cx="0" cy="-280" r="120" fill="${leaf}"/>` +
    `<circle cx="-48" cy="-196" r="70" fill="${leaf}"/>` +
    `<circle cx="52" cy="-186" r="64" fill="${leaf}"/>` +
    sparkle(-30, -290, 12, CREAM) + sparkle(66, -250, 10, GOLD) +
    `</g>`;
}

function cat(cx, baseY, s, body = '#54382A') {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})" fill="${body}">` +
    `<ellipse cx="0" cy="-44" rx="52" ry="58"/>` +
    `<circle cx="0" cy="-118" r="34"/>` +
    `<path d="M -26 -138 L -20 -170 L -2 -144 Z"/>` +
    `<path d="M 26 -138 L 20 -170 L 2 -144 Z"/>` +
    `<path d="M 44 -30 Q 96 -20 92 -74" stroke="${body}" stroke-width="18" fill="none" stroke-linecap="round"/>` +
    `</g>`;
}

const milkBowl = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -54 -26 A 54 54 0 0 0 54 -26 L 44 -8 Q 0 12 -44 -8 Z" fill="#B8683C"/>` +
  `<ellipse cx="0" cy="-26" rx="54" ry="13" fill="${CREAM}"/></g>`;

function ark(cx, cy, s, hull = '#54382A', cabin = '#8A5A36') {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<path d="M -220 0 Q 0 96 220 0 L 168 -64 H -168 Z" fill="${hull}"/>` +
    `<rect x="-96" y="-140" width="192" height="80" rx="16" fill="${cabin}"/>` +
    `<rect x="-30" y="-208" width="60" height="70" rx="12" fill="${hull}"/>` +
    `<circle cx="0" cy="-100" r="16" fill="${CREAM}"/>` +
    `<circle cx="-120" cy="-32" r="13" fill="${CREAM}"/><circle cx="0" cy="-24" r="13" fill="${CREAM}"/><circle cx="120" cy="-32" r="13" fill="${CREAM}"/>` +
    `</g>`;
}

const wave = (yTop, amp, color, op = 1) =>
  `<path d="M0 ${yTop} Q ${W * 0.125} ${yTop - amp} ${W * 0.25} ${yTop} T ${W * 0.5} ${yTop} T ${W * 0.75} ${yTop} T ${W} ${yTop} V ${H} H 0 Z" fill="${color}" opacity="${op}"/>`;

function sun(cx, cy, r, core = '#E8B36A', ray = '#E8C089') {
  let rays = '';
  for (let i = 0; i < 12; i++) {
    const a = (i / 12) * Math.PI * 2;
    const x1 = cx + Math.cos(a) * r * 1.22, y1 = cy + Math.sin(a) * r * 1.22;
    const x2 = cx + Math.cos(a) * r * 1.62, y2 = cy + Math.sin(a) * r * 1.62;
    rays += `<line x1="${x1.toFixed(0)}" y1="${y1.toFixed(0)}" x2="${x2.toFixed(0)}" y2="${y2.toFixed(0)}" stroke="${ray}" stroke-width="${(r * 0.14).toFixed(0)}" stroke-linecap="round"/>`;
  }
  return rays + `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${core}"/>` +
    `<circle cx="${cx}" cy="${cy}" r="${r * 0.72}" fill="#EFCF8C"/>`;
}

function closedBook(cx, cy, s, cover = '#31547A', page = CREAM, mark = '#B8683C') {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<rect x="-150" y="-104" width="300" height="208" rx="18" fill="${cover}"/>` +
    `<rect x="-150" y="-104" width="42" height="208" rx="18" fill="#274363"/>` +
    `<rect x="-96" y="-104" width="246" height="14" fill="${page}" opacity="0.9"/>` +
    `<rect x="-96" y="90" width="246" height="14" fill="${page}" opacity="0.9"/>` +
    `<rect x="60" y="-104" width="34" height="150" fill="${mark}"/>` +
    `<path d="M 60 46 H 94 L 77 24 Z" fill="${mark}"/>` +
    sparkle(-30, -20, 26, GOLD) +
    `</g>`;
}

const datePlate = (cx, cy, rxp = 200) =>
  `<ellipse cx="${cx}" cy="${cy + 20}" rx="${rxp * 1.2}" ry="${rxp * 0.17}" fill="#332450" opacity="0.8"/>` +
  `<ellipse cx="${cx}" cy="${cy}" rx="${rxp}" ry="${rxp * 0.13}" fill="${CREAM}"/>` +
  `<ellipse cx="${cx - rxp * 0.3}" cy="${cy - 12}" rx="30" ry="14" fill="#54382A"/>` +
  `<ellipse cx="${cx + rxp * 0.05}" cy="${cy - 18}" rx="30" ry="14" fill="#54382A"/>` +
  `<ellipse cx="${cx + rxp * 0.36}" cy="${cy - 10}" rx="30" ry="14" fill="#54382A"/>`;

const teacup = (cx, baseY, s, body = '#B8683C') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -50 -60 Q -50 10 0 10 Q 50 10 50 -60 Z" fill="${body}"/>` +
  `<ellipse cx="0" cy="-60" rx="50" ry="14" fill="${CREAM}"/>` +
  `<path d="M 50 -46 Q 88 -40 52 -8" stroke="${body}" stroke-width="12" fill="none"/>` +
  `<ellipse cx="0" cy="22" rx="66" ry="10" fill="#54382A" opacity="0.4"/></g>`;

const flower = (cx, cy, s, petal = '#C97B63', core = GOLD) =>
  `<g transform="translate(${cx} ${cy}) scale(${s})">` +
  [0, 72, 144, 216, 288].map((a) => `<ellipse cx="0" cy="-16" rx="10" ry="17" fill="${petal}" transform="rotate(${a})"/>`).join('') +
  `<circle r="9" fill="${core}"/></g>`;

function plantPot(cx, baseY, s, pot = '#B8683C', stem = '#4A7A58', leaf = '#5E8A6A') {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -64 -96 H 64 L 48 0 H -48 Z" fill="${pot}"/>` +
    `<rect x="-70" y="-110" width="140" height="22" rx="8" fill="#8A4A28"/>` +
    `<path d="M 0 -110 V -190" stroke="${stem}" stroke-width="11" stroke-linecap="round"/>` +
    `<path d="M 0 -160 Q -44 -172 -56 -212" stroke="${stem}" stroke-width="9" fill="none" stroke-linecap="round"/>` +
    `<ellipse cx="-58" cy="-218" rx="26" ry="15" fill="${leaf}" transform="rotate(-34 -58 -218)"/>` +
    `<ellipse cx="16" cy="-206" rx="30" ry="17" fill="${leaf}" transform="rotate(24 16 -206)"/>` +
    `<circle cx="0" cy="-196" r="7" fill="${GOLD}"/></g>`;
}

const giftBox = (cx, baseY, s, body = '#5E8A6A', ribbon = GOLD) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<rect x="-70" y="-110" width="140" height="110" rx="12" fill="${body}"/>` +
  `<rect x="-14" y="-110" width="28" height="110" fill="${ribbon}"/>` +
  `<rect x="-80" y="-132" width="160" height="30" rx="10" fill="${body}"/>` +
  `<rect x="-14" y="-132" width="28" height="30" fill="${ribbon}"/>` +
  `<path d="M 0 -132 Q -34 -168 -10 -172 Q 4 -172 0 -140 Q -4 -172 10 -172 Q 34 -168 0 -132" fill="${ribbon}"/></g>`;

function garland(y, n, c1 = GOLD, c2 = '#5E8A6A') {
  let out = `<path d="M 0 ${y} Q ${W / 2} ${y + 90} ${W} ${y}" stroke="${DEEPGOLD}" stroke-width="6" fill="none"/>`;
  for (let i = 1; i <= n; i++) {
    const t = i / (n + 1);
    const x = W * t, yy = y + 90 * 4 * t * (1 - t) * 0.5 + 2;
    out += `<path d="M ${x - 26} ${yy} H ${x + 26} L ${x} ${yy + 44} Z" fill="${i % 2 ? c1 : c2}"/>`;
  }
  return out;
}

const shoes = (cx, baseY, s, body = '#8A5A36') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})" fill="${body}">` +
  `<path d="M -66 0 Q -66 -34 -38 -34 Q -12 -34 -12 0 Z"/>` +
  `<path d="M 12 0 Q 12 -34 40 -34 Q 66 -34 66 0 Z"/></g>`;

const broom = (cx, baseY, s, stick = '#8A5A36', head = '#D9A05B') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<line x1="60" y1="-330" x2="-16" y2="-70" stroke="${stick}" stroke-width="14" stroke-linecap="round"/>` +
  `<path d="M -52 -80 L 22 -58 L -8 22 Q -60 8 -76 -30 Z" fill="${head}"/>` +
  `<path d="M -66 -18 L -22 6 M -56 -44 L -2 -22" stroke="#B8683C" stroke-width="6"/></g>`;

const basket = (cx, baseY, s, body = '#B8683C', weave = '#8A4A28') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -96 -80 H 96 L 76 0 H -76 Z" fill="${body}"/>` +
  `<path d="M -88 -54 H 88 M -82 -28 H 82" stroke="${weave}" stroke-width="8"/>` +
  `<path d="M -50 -80 Q 0 -140 50 -80" stroke="${weave}" stroke-width="12" fill="none"/>` +
  `<ellipse cx="-26" cy="-88" rx="24" ry="14" fill="${CREAM}"/><ellipse cx="20" cy="-92" rx="24" ry="14" fill="#E8C089"/></g>`;

function mihrabArch(cx, baseY, w, h, frame = '#1E4B3A', inner = '#16382C') {
  const r = w / 2;
  return `<path d="M ${cx - r - 26} ${baseY} V ${baseY - h + r} Q ${cx - r - 26} ${baseY - h - 40} ${cx} ${baseY - h - 60} Q ${cx + r + 26} ${baseY - h - 40} ${cx + r + 26} ${baseY - h + r} V ${baseY} Z" fill="${frame}"/>` +
    `<path d="M ${cx - r} ${baseY} V ${baseY - h + r} Q ${cx - r} ${baseY - h - 10} ${cx} ${baseY - h - 28} Q ${cx + r} ${baseY - h - 10} ${cx + r} ${baseY - h + r} V ${baseY} Z" fill="${inner}"/>`;
}

const birdV = (cx, cy, s, color = '#54382A') =>
  `<path d="M ${cx - 26 * s} ${cy} Q ${cx - 8 * s} ${cy - 18 * s} ${cx} ${cy} Q ${cx + 8 * s} ${cy - 18 * s} ${cx + 26 * s} ${cy}" stroke="${color}" stroke-width="${6 * s}" fill="none" stroke-linecap="round"/>`;

function camel(cx, baseY, s, body = '#8A5A36') {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})" fill="${body}">` +
    `<ellipse cx="0" cy="-70" rx="86" ry="48"/>` +
    `<circle cx="-14" cy="-116" r="30"/>` +
    `<path d="M 60 -84 Q 96 -110 100 -150 Q 112 -128 104 -96 Q 96 -70 70 -64 Z"/>` +
    `<path d="M 96 -152 q 10 -18 24 -14 q -4 12 -12 18 Z"/>` +
    `<rect x="-64" y="-36" width="16" height="52" rx="8"/>` +
    `<rect x="-26" y="-36" width="16" height="52" rx="8"/>` +
    `<rect x="18" y="-36" width="16" height="52" rx="8"/>` +
    `<rect x="52" y="-36" width="16" height="52" rx="8"/>` +
    `<rect x="-48" y="-118" width="72" height="26" rx="12" fill="${GOLD}"/>` +
    `</g>`;
}

function well(cx, baseY, s, stone = '#7A6A56', roof = '#8A5A36') {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -96 -100 H 96 V 0 H -96 Z" fill="${stone}"/>` +
    `<path d="M -96 -46 H 96 M -96 -72 H 96 M -50 -100 V 0 M 50 -100 V 0" stroke="#5E5142" stroke-width="7"/>` +
    `<ellipse cx="0" cy="-100" rx="96" ry="20" fill="#4A4034"/>` +
    `<line x1="-84" y1="-100" x2="-84" y2="-210" stroke="${roof}" stroke-width="14"/>` +
    `<line x1="84" y1="-100" x2="84" y2="-210" stroke="${roof}" stroke-width="14"/>` +
    `<path d="M -116 -200 H 116 L 0 -264 Z" fill="${roof}"/>` +
    `<line x1="0" y1="-210" x2="0" y2="-150" stroke="#5E5142" stroke-width="8"/>` +
    `<rect x="-22" y="-150" width="44" height="34" rx="8" fill="${GOLD}"/></g>`;
}

function fish(cx, cy, s, body = '#31547A', belly = '#4A6E96') {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<path d="M -180 0 Q -60 -96 90 -34 Q 150 -10 176 22 Q 120 70 20 66 Q -90 60 -180 0 Z" fill="${body}"/>` +
    `<path d="M -180 0 Q -90 40 20 52 Q 110 58 176 22 Q 120 70 20 66 Q -90 60 -180 0 Z" fill="${belly}" opacity="0.7"/>` +
    `<path d="M -180 0 L -238 -46 Q -216 0 -238 44 Z" fill="${body}"/>` +
    `<path d="M -20 -52 Q 6 -88 44 -78 Q 26 -52 8 -44 Z" fill="${body}"/>` +
    `<circle cx="120" cy="-6" r="10" fill="${CREAM}"/></g>`;
}

const jug = (cx, baseY, s, body = '#5E8A6A') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -50 0 Q -66 -60 -34 -96 L -26 -128 H 26 L 34 -96 Q 66 -60 50 0 Z" fill="${body}"/>` +
  `<ellipse cx="0" cy="-128" rx="26" ry="9" fill="${CREAM}"/>` +
  `<path d="M -34 -108 Q -84 -96 -60 -50" stroke="${body}" stroke-width="13" fill="none"/></g>`;

const apple = (cx, cy, s) =>
  `<g transform="translate(${cx} ${cy}) scale(${s})">` +
  `<path d="M 0 -96 q -6 -30 18 -44" stroke="#54382A" stroke-width="12" fill="none" stroke-linecap="round"/>` +
  `<ellipse cx="34" cy="-124" rx="26" ry="15" fill="#5E8A6A" transform="rotate(24 34 -124)"/>` +
  `<path d="M -4 -88 Q -110 -96 -108 -6 Q -106 74 -40 86 Q -14 92 0 80 Q 14 92 40 86 Q 106 74 108 -6 Q 110 -96 4 -88 Q 0 -84 -4 -88 Z" fill="#C05A4A"/>` +
  `<path d="M -60 -50 Q -80 -30 -78 6" stroke="#E8C089" stroke-width="12" fill="none" stroke-linecap="round" opacity="0.6"/></g>`;

const ball = (cx, cy, r) =>
  `<circle cx="${cx}" cy="${cy}" r="${r}" fill="#31547A"/>` +
  `<path d="M ${cx - r} ${cy} A ${r} ${r * 0.55} 0 0 0 ${cx + r} ${cy}" fill="#C05A4A" opacity="0.9"/>` +
  `<path d="M ${cx - r} ${cy} A ${r} ${r * 0.35} 0 0 1 ${cx + r} ${cy}" stroke="${CREAM}" stroke-width="${r * 0.12}" fill="none"/>` +
  `<circle cx="${cx - r * 0.34}" cy="${cy - r * 0.4}" r="${r * 0.16}" fill="${CREAM}" opacity="0.7"/>`;

const juiceCup = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
  `<path d="M -64 -180 L -48 0 H 48 L 64 -180 Z" fill="#E8965A"/>` +
  `<path d="M -60 -140 L -50 -20 H 50 L 60 -140 Z" fill="#F0A96B"/>` +
  `<ellipse cx="0" cy="-180" rx="64" ry="16" fill="${CREAM}"/>` +
  `<line x1="26" y1="-186" x2="66" y2="-280" stroke="#C05A4A" stroke-width="14" stroke-linecap="round"/>` +
  `<circle cx="-28" cy="-206" r="18" fill="#E8C089"/></g>`;

function nest(cx, baseY, s) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -120 -40 Q 0 30 120 -40 Q 96 60 0 60 Q -96 60 -120 -40 Z" fill="#8A5A36"/>` +
    `<path d="M -110 -30 Q 0 24 110 -30 M -88 4 Q 0 44 88 4" stroke="#54382A" stroke-width="9" fill="none"/>` +
    `<ellipse cx="-38" cy="-38" rx="30" ry="36" fill="${CREAM}"/>` +
    `<ellipse cx="16" cy="-46" rx="30" ry="36" fill="${IVORY}"/>` +
    `<ellipse cx="62" cy="-34" rx="28" ry="34" fill="#EFCF8C"/></g>`;
}

const doorway = (cx, baseY, w, h, frame = '#8A5A36', light = '#EFCF8C') => {
  const r = w / 2;
  return `<path d="M ${cx - r - 20} ${baseY} V ${baseY - h + r} Q ${cx - r - 20} ${baseY - h - 30} ${cx} ${baseY - h - 44} Q ${cx + r + 20} ${baseY - h - 30} ${cx + r + 20} ${baseY - h + r} V ${baseY} Z" fill="${frame}"/>` +
    `<path d="M ${cx - r} ${baseY} V ${baseY - h + r} Q ${cx - r} ${baseY - h} ${cx} ${baseY - h - 16} Q ${cx + r} ${baseY - h} ${cx + r} ${baseY - h + r} V ${baseY} Z" fill="${light}"/>`;
};

// ---------------------------------------------------------------- scenes ---

const scenes = [];
const add = (dir, name, w, h, fn) => scenes.push([dir, name, w, h, fn]);

// ============================ kids_stories covers (1024x1024) ==============

add('ks_cover', 'bismillah_before_eating_cover', 1024, 1024, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(512, 470, 370, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    archWindow(512, 76, 290, 260, '#8A5A36', SKY.night,
      stars(31, 8, 380, 650, 86, 290, CREAM) + crescent(566, 190, 40, IVORY)) +
    gl.el +
    hangLine(150, 396, 0.7) + lantern(150, 396, 0.7) +
    hangLine(874, 396, 0.7) + lantern(874, 396, 0.7) +
    tableBand(646) +
    steam(444, 596, 0.95) + steam(512, 584, 1.15) + steam(580, 596, 0.95) +
    bowl(512, 726, 1.0) +
    breadLoaf(252, 736, 0.9) +
    cup(792, 730, 0.95) +
    sparkle(330, 520, 12) + sparkle(710, 505, 11, CREAM) +
    `<rect x="0" y="964" width="1024" height="60" fill="#4A2F22"/>`);
});

add('ks_cover', 'sharing_with_others_cover', 1024, 1024, () => {
  const s = skyV(SKY.day);
  const gl = glow2(512, 520, 380, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(210, 170, 130, 44, 0.5) + cloud(830, 250, 140, 48, 0.36) + gl.el +
    tableBand(640, '#8A5A36', '#B8683C') +
    // one loaf split in two, shared between two plates
    `<ellipse cx="330" cy="770" rx="150" ry="24" fill="${CREAM}"/>` +
    `<ellipse cx="694" cy="770" rx="150" ry="24" fill="${CREAM}"/>` +
    `<g transform="rotate(-8 330 740)">${breadLoaf(330, 740, 0.8)}</g>` +
    `<g transform="rotate(8 694 740)">${breadLoaf(694, 740, 0.8)}</g>` +
    `<ellipse cx="440" cy="742" rx="26" ry="12" fill="#54382A"/>` +
    `<ellipse cx="512" cy="732" rx="26" ry="12" fill="#54382A"/>` +
    `<ellipse cx="584" cy="742" rx="26" ry="12" fill="#54382A"/>` +
    sparkle(512, 560, 16) + sparkle(300, 540, 11, CREAM) + sparkle(740, 540, 11, CREAM) +
    `<rect x="0" y="964" width="1024" height="60" fill="#54382A"/>`);
});

add('ks_cover', 'telling_the_truth_cover', 1024, 1024, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(512, 480, 360, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    archWindow(806, 120, 220, 210, '#8A5A36', SKY.day, cloud(806, 240, 90, 32, 0.7)) +
    gl.el + hangLine(200, 380, 0.75) + lantern(200, 380, 0.75) +
    tableBand(650) +
    // the tipped cup, the spill, and the caring cloth beside it
    `<g transform="rotate(74 430 724)">${cup(430, 724, 1.0, '#5E8A6A')}</g>` +
    `<path d="M 470 742 Q 560 726 640 748 Q 700 764 690 782 Q 600 800 500 786 Q 440 776 470 742 Z" fill="#A9C4BC" opacity="0.85"/>` +
    `<g transform="rotate(-10 800 740)"><rect x="740" y="700" width="130" height="86" rx="14" fill="${CREAM}"/><path d="M 752 726 H 858 M 752 752 H 858" stroke="#D8C49A" stroke-width="8"/></g>` +
    sparkle(560, 560, 14) +
    `<rect x="0" y="964" width="1024" height="60" fill="#4A2F22"/>`);
});

add('ks_cover', 'helping_parents_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(700, 560, 360, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    doorway(770, 880, 260, 480, '#8A5A36', '#EFCF8C') + gl.el +
    broom(330, 880, 1.1) +
    basket(600, 880, 1.0) +
    `<g transform="translate(880 880) scale(0.9)"><rect x="-70" y="-40" width="140" height="18" rx="8" fill="${CREAM}"/><rect x="-70" y="-64" width="140" height="18" rx="8" fill="#A9C4BC"/><rect x="-70" y="-88" width="140" height="18" rx="8" fill="#E8C089"/></g>` +
    sparkle(500, 520, 14) + sparkle(240, 620, 11, CREAM) +
    groundBand('#6E4629', 880));
});

add('ks_cover', 'kindness_to_animals_cover', 1024, 1024, () => {
  const s = skyV(SKY.day);
  const gl = glow2(370, 480, 330, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(200, 170, 130, 44, 0.5) + cloud(840, 260, 145, 48, 0.36) +
    gl.el +
    hills('#5E8A6A', 760, 52) +
    tree(370, 820, 1.0) +
    cat(700, 812, 1.0) +
    milkBowl(864, 812, 0.95) +
    sparkle(800, 600, 13, CREAM) + sparkle(560, 440, 11) +
    groundBand('#4A7A58', 820));
});

add('ks_cover', 'masjid_manners_cover', 1024, 1024, () => {
  const s = skyV(SKY.emerald);
  const gl = glow2(512, 470, 360, GOLD, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    mihrabArch(512, 830, 300, 520, '#1E4B3A', '#16382C') + gl.el +
    hangLine(512, 420, 0.9, GOLD, 310) + lantern(512, 420, 0.9) +
    hangLine(340, 500, 0.7, GOLD, 310) + lantern(340, 500, 0.7) +
    hangLine(684, 500, 0.7, GOLD, 310) + lantern(684, 500, 0.7) +
    `<rect x="284" y="700" width="456" height="112" rx="18" fill="#B8683C" opacity="0.9"/>` +
    `<path d="M 512 716 Q 452 760 512 796 Q 572 760 512 716 Z" fill="${GOLD}" opacity="0.9"/>` +
    shoes(512, 940, 1.0, '#0D271E') +
    sparkle(390, 380, 11, CREAM) + sparkle(640, 380, 11, CREAM) +
    groundBand('#0D271E', 890));
});

add('ks_cover', 'ramadan_kindness_cover', 1024, 1024, () => {
  const s = skyV(SKY.violetLift);
  const gl = glow2(512, 460, 380, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(61, 16, 40, 984, 40, 330) + crescent(830, 170, 56, IVORY) + gl.el +
    doorway(300, 880, 240, 440, '#332450', '#EFCF8C') +
    hangLine(700, 430, 1.0) + lantern(700, 430, 1.0) +
    basket(700, 880, 1.15, '#8A5A36', '#54382A') +
    `<ellipse cx="700" cy="758" rx="26" ry="13" fill="#54382A"/>` +
    sparkle(520, 620, 14) + sparkle(880, 560, 11, CREAM) +
    groundBand('#211A38', 880));
});

add('ks_cover', 'eid_gratitude_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(512, 480, 380, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    garland(60, 8) +
    crescent(830, 240, 52, IVORY) + gl.el +
    giftBox(360, 880, 1.1, '#5E8A6A', GOLD) +
    giftBox(620, 880, 0.85, '#B8683C', CREAM) +
    `<ellipse cx="800" cy="866" rx="130" ry="20" fill="${CREAM}"/>` +
    `<ellipse cx="770" cy="852" rx="24" ry="12" fill="#54382A"/>` +
    `<ellipse cx="830" cy="848" rx="24" ry="12" fill="#54382A"/>` +
    sparkle(250, 420, 15) + sparkle(700, 380, 12, CREAM) + sparkle(500, 300, 11) +
    groundBand('#8A5A36', 880));
});

add('ks_cover', 'patience_cover', 1024, 1024, () => {
  const s = skyV(SKY.day);
  const gl = glow2(680, 400, 330, '#EFCF8C', 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    sun(680, 340, 96) + gl.el +
    cloud(220, 240, 130, 44, 0.5) +
    `<rect x="120" y="620" width="784" height="34" rx="14" fill="#8A5A36"/>` +
    plantPot(400, 620, 1.05) +
    plantPot(660, 620, 0.75, '#B8683C', '#4A7A58', '#A9C79B') +
    `<rect x="0" y="654" width="1024" height="370" fill="#E8DCC0"/>` +
    jug(830, 960, 0.95) +
    sparkle(530, 500, 12, DEEPGOLD, 0.6));
});

add('ks_cover', 'saying_sorry_and_forgiving_cover', 1024, 1024, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(512, 500, 360, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    archWindow(512, 90, 260, 240, '#8A5A36', SKY.dawn, sun(512, 240, 56)) +
    gl.el +
    tableBand(660, '#6E4629', '#8A5A36') +
    teacup(390, 780, 1.05, '#5E8A6A') +
    teacup(634, 780, 1.05, '#B8683C') +
    steam(390, 700, 0.8) + steam(634, 700, 0.8) +
    flower(512, 760, 2.0) +
    sparkle(310, 560, 12, CREAM) + sparkle(720, 560, 12, CREAM) +
    `<rect x="0" y="964" width="1024" height="60" fill="#4A2F22"/>`);
});

add('ks_cover', 'seerah_journey_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(760, 520, 320, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(71, 9, 40, 984, 40, 220) + crescent(210, 180, 58, IVORY) +
    dunes('#8A5A36', '#6E4629', 700) + gl.el +
    `<path d="M 140 960 Q 400 880 620 900 Q 840 916 900 760" stroke="${CREAM}" stroke-width="17" stroke-linecap="round" stroke-dasharray="3 46" fill="none" opacity="0.9"/>` +
    camel(700, 760, 1.0, '#54382A') +
    palm(220, 800, 0.85, '#54382A') +
    star8(880, 300, 60, GOLD, CREAM) +
    `<path d="M0 1024 L0 950 Q 512 900 1024 940 V 1024 Z" fill="#4A2F22"/>`);
});

// ========================= kids_stories backdrops (1600x1200) ==============
// Backdrops sit behind reader text: same scene family, calmer, emptier middle.

add('ks_backdrop', 'bismillah_before_eating_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(800, 560, 470, CREAM, 0.35);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    hangLine(240, 420, 0.8) + lantern(240, 420, 0.8) +
    hangLine(1360, 420, 0.8) + lantern(1360, 420, 0.8) +
    tableBand(950) +
    steam(760, 918, 0.9, CREAM, 0.6) + steam(830, 908, 1.0, CREAM, 0.6) +
    bowl(800, 1030, 0.9) +
    sparkle(560, 640, 12, GOLD, 0.6) + sparkle(1060, 620, 11, CREAM, 0.6));
});

add('ks_backdrop', 'sharing_with_others_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.day);
  const gl = glow2(800, 520, 470, CREAM, 0.32);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(300, 220, 170, 56, 0.4) + cloud(1290, 300, 180, 58, 0.3) + gl.el +
    tableBand(960, '#8A5A36', '#B8683C') +
    `<ellipse cx="560" cy="1070" rx="160" ry="24" fill="${CREAM}" opacity="0.9"/>` +
    `<ellipse cx="1040" cy="1070" rx="160" ry="24" fill="${CREAM}" opacity="0.9"/>` +
    sparkle(800, 700, 13, GOLD, 0.55));
});

add('ks_backdrop', 'telling_the_truth_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(800, 540, 470, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    archWindow(1290, 150, 240, 230, '#8A5A36', SKY.day, cloud(1290, 280, 100, 34, 0.7)) +
    hangLine(300, 430, 0.8) + lantern(300, 430, 0.8) +
    tableBand(960) +
    `<g transform="rotate(-8 1180 1060)"><rect x="1110" y="1020" width="140" height="92" rx="14" fill="${CREAM}" opacity="0.95"/><path d="M 1124 1048 H 1238 M 1124 1076 H 1238" stroke="#D8C49A" stroke-width="8"/></g>` +
    sparkle(660, 660, 12, GOLD, 0.55));
});

add('ks_backdrop', 'helping_parents_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(1080, 620, 430, CREAM, 0.38);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    doorway(1180, 1060, 300, 560, '#8A5A36', '#EFCF8C') + gl.el +
    broom(360, 1060, 1.0) +
    sparkle(700, 560, 13, GOLD, 0.55) + sparkle(900, 700, 11, CREAM, 0.5) +
    groundBand('#6E4629', 1060));
});

add('ks_backdrop', 'kindness_to_animals_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.day);
  const gl = glow2(480, 560, 420, CREAM, 0.32);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(280, 210, 160, 52, 0.42) + cloud(1300, 320, 170, 56, 0.3) + gl.el +
    hills('#5E8A6A', 920, 60) +
    tree(400, 1000, 1.05) +
    birdV(1060, 360, 1.4, '#54382A') + birdV(1160, 320, 1.1, '#54382A') +
    milkBowl(1240, 990, 0.9) +
    groundBand('#4A7A58', 1000));
});

add('ks_backdrop', 'masjid_manners_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.emerald);
  const gl = glow2(800, 520, 470, GOLD, 0.32);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    mihrabArch(800, 1020, 360, 640, '#1E4B3A', '#16382C') + gl.el +
    hangLine(560, 520, 0.8, GOLD, 340) + lantern(560, 520, 0.8) +
    hangLine(1040, 520, 0.8, GOLD, 340) + lantern(1040, 520, 0.8) +
    `<rect x="520" y="880" width="560" height="120" rx="18" fill="#B8683C" opacity="0.55"/>` +
    groundBand('#0D271E', 1050));
});

add('ks_backdrop', 'ramadan_kindness_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.violetLift);
  const gl = glow2(800, 620, 470, CREAM, 0.38);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(41, 22, 60, 1540, 40, 460) +
    crescent(1330, 200, 78, IVORY) + gl.el +
    hangLine(330, 560, 1.0) + lantern(330, 560, 1.0) +
    hangLine(620, 460, 0.85) + lantern(620, 460, 0.85) +
    hangLine(980, 530, 1.1) + lantern(980, 530, 1.1) +
    hangLine(1280, 600, 0.8) + lantern(1280, 600, 0.8) +
    datePlate(800, 990) +
    sparkle(500, 700, 13) + sparkle(1130, 720, 12, CREAM) +
    groundBand('#211A38', 1040));
});

add('ks_backdrop', 'eid_gratitude_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(800, 540, 470, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    garland(56, 11) +
    crescent(1300, 260, 62, IVORY) + gl.el +
    giftBox(340, 1050, 1.0, '#5E8A6A', GOLD) +
    `<ellipse cx="1240" cy="1036" rx="150" ry="22" fill="${CREAM}"/>` +
    sparkle(640, 460, 14, GOLD, 0.6) + sparkle(1000, 420, 12, CREAM, 0.55) +
    groundBand('#8A5A36', 1050));
});

add('ks_backdrop', 'patience_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.day);
  const gl = glow2(1120, 420, 380, '#EFCF8C', 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    sun(1120, 360, 90) + gl.el +
    cloud(320, 260, 150, 50, 0.42) +
    `<rect x="180" y="760" width="1240" height="34" rx="14" fill="#8A5A36"/>` +
    plantPot(420, 760, 0.9) +
    `<rect x="0" y="794" width="1600" height="406" fill="#E8DCC0"/>`);
});

add('ks_backdrop', 'saying_sorry_and_forgiving_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.amber);
  const gl = glow2(800, 560, 470, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    archWindow(280, 130, 240, 230, '#8A5A36', SKY.dawn, sun(280, 270, 52)) +
    tableBand(970, '#6E4629', '#8A5A36') +
    teacup(660, 1070, 0.9, '#5E8A6A') +
    teacup(940, 1070, 0.9, '#B8683C') +
    flower(800, 1050, 1.6) +
    sparkle(1100, 620, 12, GOLD, 0.55));
});

add('ks_backdrop', 'seerah_journey_backdrop', 1600, 1200, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(1240, 700, 340, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(191, 10, 60, 1540, 40, 260) + crescent(260, 220, 84, IVORY) +
    dunes('#8A5A36', '#6E4629', 880) + gl.el +
    `<g opacity="0.9">${mosqueSilhouette(1270, 860, 0.4, '#54382A')}</g>` +
    `<path d="M 320 1180 Q 560 1060 800 1080 Q 1080 1100 1240 900" stroke="${CREAM}" stroke-width="22" stroke-linecap="round" stroke-dasharray="4 60" fill="none" opacity="0.9"/>` +
    palm(360, 1010, 0.85, '#54382A') +
    `<path d="M0 1200 L0 1130 Q 800 1080 1600 1120 V 1200 Z" fill="#4A2F22"/>`);
});

// ============================= kids_stories scenes (1600x1200) =============

add('ks_scene', 'bismillah_before_eating_scene_1', 1600, 1200, () => {
  // Scene 1: the meal is served, and the child pauses to remember Allah.
  const s = skyV(SKY.amber);
  const gl = glow2(800, 520, 440, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    archWindow(800, 90, 320, 280, '#8A5A36', SKY.night,
      stars(81, 10, 640, 960, 100, 340, CREAM) + crescent(880, 220, 46, IVORY)) +
    gl.el +
    hangLine(300, 430, 0.85) + lantern(300, 430, 0.85) +
    hangLine(1300, 430, 0.85) + lantern(1300, 430, 0.85) +
    tableBand(880) +
    bowl(800, 1010, 1.05) +
    breadLoaf(480, 1010, 0.95) + cup(1130, 1006, 1.0) +
    sparkle(800, 700, 18, GOLD) +
    `<rect x="0" y="1140" width="1600" height="60" fill="#4A2F22"/>`);
});

add('ks_scene', 'bismillah_before_eating_scene_2', 1600, 1200, () => {
  // Scene 2: the same table, warmer and shared — barakah in the meal.
  const s = skyV(SKY.dawn);
  const gl = glow2(800, 500, 500, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    hangLine(300, 400, 0.85) + lantern(300, 400, 0.85) +
    hangLine(1300, 400, 0.85) + lantern(1300, 400, 0.85) +
    tableBand(880, '#8A5A36', '#B8683C') +
    steam(720, 850, 1.0) + steam(800, 836, 1.2) + steam(880, 850, 1.0) +
    bowl(800, 1000, 1.05) +
    `<ellipse cx="470" cy="1000" rx="150" ry="24" fill="${CREAM}"/>` +
    breadLoaf(470, 986, 0.85) +
    `<ellipse cx="1140" cy="1000" rx="150" ry="24" fill="${CREAM}"/>` +
    `<ellipse cx="1106" cy="986" rx="26" ry="13" fill="#54382A"/>` +
    `<ellipse cx="1170" cy="982" rx="26" ry="13" fill="#54382A"/>` +
    sparkle(560, 640, 16) + sparkle(1050, 620, 14, CREAM) + sparkle(800, 560, 13) +
    `<rect x="0" y="1140" width="1600" height="60" fill="#54382A"/>`);
});

// ===================== prophets bedtime covers (1024x1024) =================

add('pb_cover', 'adam_cover', 1024, 1024, () => {
  const s = skyV(SKY.emeraldLift);
  const gl = glow2(512, 380, 380, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    `<line x1="512" y1="120" x2="512" y2="330" stroke="${CREAM}" stroke-width="7" opacity="0.5"/>` +
    `<line x1="380" y1="140" x2="440" y2="320" stroke="${CREAM}" stroke-width="5" opacity="0.35"/>` +
    `<line x1="644" y1="140" x2="584" y2="320" stroke="${CREAM}" stroke-width="5" opacity="0.35"/>` +
    hills('#4A7A58', 760, 60) +
    tree(512, 830, 1.15, '#54382A', '#5E8A6A', '#4A7A58') +
    flower(280, 880, 1.6) + flower(760, 890, 1.4, '#C97B63') + flower(220, 940, 1.3, '#E8B36A') +
    groundBand('#2C4A33', 840));
});

add('pb_cover', 'nuh_cover', 1024, 1024, () => {
  const s = skyV(SKY.violet);
  const gl = glow2(512, 380, 380, CREAM, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(51, 26, 40, 984, 40, 480) + gl.el +
    crescent(810, 180, 70, IVORY) +
    cloud(230, 260, 130, 40, 0.22) +
    ark(512, 690, 1.1) +
    wave(740, 40, '#2C3F66') +
    wave(830, 36, '#22304F') +
    wave(920, 30, '#1A2440') +
    sparkle(260, 550, 13, CREAM) + sparkle(760, 480, 11, GOLD));
});

add('pb_cover', 'ibrahim_cover', 1024, 1024, () => {
  const s = skyV(SKY.night);
  const gl = glow2(512, 330, 330, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(91, 34, 40, 984, 40, 620) + gl.el +
    star8(512, 320, 120, GOLD, CREAM) +
    star8(250, 210, 46, IVORY) + star8(800, 250, 40, IVORY) +
    dunes('#2C3F66', '#22304F', 800) +
    palm(820, 900, 0.9, '#141B30') +
    `<path d="M0 1024 L0 960 H 1024 V 1024 Z" fill="#101627"/>`);
});

add('pb_cover', 'ismail_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(512, 620, 360, '#A9C4BC', 0.55);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(101, 8, 40, 984, 40, 200) +
    dunes('#8A5A36', '#6E4629', 640) + gl.el +
    // the Zamzam spring welling up between the dunes
    `<ellipse cx="512" cy="800" rx="230" ry="60" fill="#4A6E96"/>` +
    `<ellipse cx="512" cy="790" rx="190" ry="44" fill="#A9C4BC"/>` +
    `<circle cx="470" cy="712" r="14" fill="#A9C4BC" opacity="0.9"/>` +
    `<circle cx="530" cy="688" r="10" fill="#A9C4BC" opacity="0.8"/>` +
    `<circle cx="500" cy="664" r="7" fill="#A9C4BC" opacity="0.7"/>` +
    `<path d="M 420 770 q 46 16 92 0 M 540 782 q 40 14 80 0" stroke="${CREAM}" stroke-width="8" fill="none" stroke-linecap="round" opacity="0.8"/>` +
    `<circle cx="430" cy="756" r="10" fill="${CREAM}" opacity="0.8"/>` +
    `<circle cx="588" cy="762" r="8" fill="${CREAM}" opacity="0.8"/>` +
    palm(230, 840, 0.95, '#54382A') + palm(830, 850, 0.8, '#54382A') +
    `<path d="M0 1024 L0 930 Q 512 880 1024 920 V 1024 Z" fill="#4A2F22"/>`);
});

add('pb_cover', 'yusuf_cover', 1024, 1024, () => {
  const s = skyV(SKY.violet);
  const gl = glow2(512, 350, 360, CREAM, 0.4);
  const rnd = mulberry32(111);
  let eleven = '';
  for (let i = 0; i < 11; i++) {
    const a = (i / 11) * Math.PI * 2 - Math.PI / 2;
    const rr = 260 + rnd() * 60;
    eleven += star8(512 + Math.cos(a) * rr, 350 + Math.sin(a) * rr * 0.7, 26 + rnd() * 12, IVORY);
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(121, 18, 40, 984, 40, 560) + gl.el +
    sun(512, 350, 80, '#E8B36A', '#B98A3E') +
    crescent(512, 350, 0.01, 'none') + eleven +
    crescent(830, 620, 44, IVORY) +
    dunes('#332450', '#241C3E', 830) +
    well(512, 990, 0.95, '#4A3560', '#332450'));
});

add('pb_cover', 'musa_cover', 1024, 1024, () => {
  const s = skyV(SKY.day);
  const gl = glow2(512, 420, 360, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    // the sea parts: two calm wave walls and a dry path between them
    `<path d="M 0 460 Q 200 420 380 460 Q 460 480 440 560 L 440 1024 L 0 1024 Z" fill="#2C6E8A"/>` +
    `<path d="M 1024 460 Q 824 420 644 460 Q 564 480 584 560 L 584 1024 L 1024 1024 Z" fill="#2C6E8A"/>` +
    `<path d="M 0 540 Q 220 500 400 550 L 400 1024 L 0 1024 Z" fill="#245C74" opacity="0.9"/>` +
    `<path d="M 1024 540 Q 804 500 624 550 L 624 1024 L 1024 1024 Z" fill="#245C74" opacity="0.9"/>` +
    `<path d="M 420 470 q 20 -26 44 0 M 560 470 q 20 -26 44 0" stroke="${CREAM}" stroke-width="9" fill="none" opacity="0.8"/>` +
    `<path d="M 440 1024 L 440 560 Q 512 520 584 560 L 584 1024 Z" fill="#D9A05B"/>` +
    `<path d="M 480 1024 L 486 620 M 544 1024 L 538 620" stroke="#B8683C" stroke-width="7" opacity="0.6"/>` +
    sparkle(512, 350, 16, CREAM));
});

add('pb_cover', 'dawud_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(512, 400, 340, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    `<path d="M 0 700 L 240 420 L 430 660 L 620 380 L 830 640 L 1024 470 V 1024 H 0 Z" fill="#4A5D8A"/>` +
    `<path d="M 0 800 L 300 580 L 560 780 L 820 600 L 1024 740 V 1024 H 0 Z" fill="#31547A"/>` +
    birdV(360, 300, 1.6, '#332450') + birdV(500, 250, 1.3, '#332450') + birdV(640, 310, 1.5, '#332450') +
    sparkle(512, 420, 14, GOLD) +
    groundBand('#232A44', 880));
});

add('pb_cover', 'sulaiman_cover', 1024, 1024, () => {
  const s = skyV(SKY.emeraldLift);
  const gl = glow2(512, 430, 360, GOLD, 0.42);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    mihrabArch(512, 880, 340, 540, '#1E4B3A', '#16382C') +
    hangLine(512, 470, 0.85, GOLD, 300) + lantern(512, 470, 0.85) +
    hangLine(408, 560, 0.6, GOLD, 340) + lantern(408, 560, 0.6) +
    hangLine(616, 560, 0.6, GOLD, 340) + lantern(616, 560, 0.6) +
    `<rect x="392" y="748" width="240" height="90" rx="14" fill="#B8683C" opacity="0.9"/>` +
    `<path d="M 512 760 Q 470 792 512 822 Q 554 792 512 760 Z" fill="${GOLD}" opacity="0.9"/>` +
    // the hoopoe perches on the arch's left shoulder
    `<g transform="translate(362 344) rotate(-10)">` +
    `<path d="M -46 10 Q -86 22 -104 8 Q -84 34 -44 26 Z" fill="#8A4A28"/>` +
    `<ellipse cx="0" cy="0" rx="42" ry="27" fill="#B8683C"/>` +
    `<circle cx="36" cy="-16" r="17" fill="#B8683C"/>` +
    `<path d="M 50 -18 L 74 -12" stroke="#54382A" stroke-width="7" stroke-linecap="round"/>` +
    `<ellipse cx="24" cy="-38" rx="7" ry="16" fill="#C05A4A" transform="rotate(-26 24 -38)"/>` +
    `<ellipse cx="35" cy="-40" rx="7" ry="17" fill="#C05A4A" transform="rotate(-6 35 -40)"/>` +
    `<ellipse cx="46" cy="-37" rx="7" ry="15" fill="#C05A4A" transform="rotate(16 46 -37)"/>` +
    `<circle cx="42" cy="-18" r="4" fill="#16382C"/>` +
    `<line x1="-6" y1="26" x2="-6" y2="44" stroke="#54382A" stroke-width="5"/>` +
    `<line x1="10" y1="26" x2="10" y2="44" stroke="#54382A" stroke-width="5"/>` +
    `</g>` +
    sparkle(700, 320, 13, CREAM) + sparkle(260, 520, 11, CREAM, 0.7) +
    groundBand('#0D271E', 900));
});

add('pb_cover', 'yunus_cover', 1024, 1024, () => {
  const s = skyV(SKY.night);
  const gl = glow2(512, 300, 320, CREAM, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(131, 20, 40, 984, 40, 330) + crescent(820, 170, 54, IVORY) + gl.el +
    wave(500, 44, '#2C3F66') +
    // the little boat rides the surface above the great fish
    `<g transform="rotate(-4 512 508)">` +
    `<path d="M 382 508 Q 512 568 642 508 L 606 470 H 418 Z" fill="#54382A"/>` +
    `<rect x="500" y="380" width="12" height="92" fill="#3D2A20"/>` +
    `<path d="M 512 388 Q 588 416 512 452 Z" fill="${CREAM}"/>` +
    `</g>` +
    fish(512, 760, 1.5) +
    wave(950, 34, '#1A2440') +
    sparkle(300, 420, 12, CREAM));
});

add('pb_cover', 'isa_cover', 1024, 1024, () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(512, 480, 360, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(141, 10, 40, 984, 40, 240) +
    star8(512, 220, 64, GOLD, CREAM) + gl.el +
    hills('#8A5A36', 780, 50) +
    palm(512, 860, 1.25, '#54382A') +
    `<ellipse cx="512" cy="920" rx="200" ry="40" fill="#4A6E96"/>` +
    `<ellipse cx="512" cy="912" rx="160" ry="28" fill="#A9C4BC"/>` +
    `<ellipse cx="400" cy="806" rx="20" ry="12" fill="#B8683C"/>` +
    `<ellipse cx="620" cy="798" rx="20" ry="12" fill="#B8683C"/>` +
    `<path d="M0 1024 L0 950 Q 512 910 1024 944 V 1024 Z" fill="#4A2F22"/>`);
});

add('pb_cover', 'muhammad_cover', 1024, 1024, () => {
  const s = skyV(SKY.emerald);
  const gl = glow2(512, 420, 400, GOLD, 0.4);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(151, 18, 40, 984, 40, 320) +
    crescent(830, 180, 60, IVORY) + gl.el +
    mosqueSilhouette(512, 840, 0.75, '#0D271E') +
    hangLine(200, 500, 0.8, GOLD) + lantern(200, 500, 0.8) +
    sparkle(700, 300, 13, CREAM) + sparkle(320, 360, 11) +
    groundBand('#0D271E', 850));
});

// =================== prophets bedtime backdrops (1600x1200) ================

const pbBackdrop = (skyName, deco) => () => {
  const s = skyV(SKY[skyName]);
  const gl = glow2(800, 520, 500, CREAM, 0.32);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` + deco());
};

add('pb_backdrop', 'adam_backdrop', 1600, 1200, pbBackdrop('emeraldLift', () =>
  hills('#4A7A58', 900, 60) +
  tree(340, 980, 0.95) +
  flower(1200, 1010, 1.5) + flower(1330, 1050, 1.2, '#E8B36A') +
  groundBand('#2C4A33', 980)));

add('pb_backdrop', 'nuh_backdrop', 1600, 1200, pbBackdrop('violet', () =>
  stars(52, 24, 60, 1540, 40, 420) + crescent(1300, 190, 66, IVORY) +
  ark(1200, 780, 0.7) +
  wave(830, 42, '#2C3F66') + wave(950, 36, '#22304F') + wave(1070, 30, '#1A2440')));

add('pb_backdrop', 'ibrahim_backdrop', 1600, 1200, pbBackdrop('night', () =>
  stars(92, 40, 60, 1540, 40, 640) +
  star8(1200, 300, 70, GOLD, CREAM) + star8(420, 220, 44, IVORY) +
  dunes('#2C3F66', '#22304F', 920) +
  `<path d="M0 1200 L0 1090 H 1600 V 1200 Z" fill="#101627"/>`));

add('pb_backdrop', 'ismail_backdrop', 1600, 1200, pbBackdrop('dawn', () =>
  dunes('#8A5A36', '#6E4629', 780) +
  `<ellipse cx="800" cy="960" rx="260" ry="60" fill="#4A6E96"/>` +
  `<ellipse cx="800" cy="950" rx="210" ry="44" fill="#A9C4BC"/>` +
  palm(300, 1000, 0.9, '#54382A') + palm(1320, 1010, 0.75, '#54382A') +
  `<path d="M0 1200 L0 1110 Q 800 1060 1600 1100 V 1200 Z" fill="#4A2F22"/>`));

add('pb_backdrop', 'yusuf_backdrop', 1600, 1200, pbBackdrop('violet', () =>
  stars(122, 26, 60, 1540, 40, 520) +
  star8(400, 260, 40, IVORY) + star8(1240, 220, 46, IVORY) + star8(1000, 400, 30, IVORY) +
  crescent(1330, 560, 48, IVORY) +
  dunes('#332450', '#241C3E', 950) +
  well(1230, 1130, 0.8, '#4A3560', '#332450')));

add('pb_backdrop', 'musa_backdrop', 1600, 1200, pbBackdrop('day', () =>
  `<path d="M 0 520 Q 300 470 560 530 Q 660 552 640 640 L 640 1200 L 0 1200 Z" fill="#2C6E8A"/>` +
  `<path d="M 1600 520 Q 1300 470 1040 530 Q 940 552 960 640 L 960 1200 L 1600 1200 Z" fill="#2C6E8A"/>` +
  `<path d="M 640 1200 L 640 640 Q 800 590 960 640 L 960 1200 Z" fill="#D9A05B"/>`));

add('pb_backdrop', 'dawud_backdrop', 1600, 1200, pbBackdrop('dawn', () =>
  `<path d="M 0 780 L 380 470 L 680 740 L 980 430 L 1300 720 L 1600 520 V 1200 H 0 Z" fill="#4A5D8A"/>` +
  `<path d="M 0 900 L 460 660 L 860 880 L 1280 680 L 1600 840 V 1200 H 0 Z" fill="#31547A"/>` +
  birdV(600, 320, 1.5, '#332450') + birdV(760, 270, 1.2, '#332450') +
  groundBand('#232A44', 1020)));

add('pb_backdrop', 'sulaiman_backdrop', 1600, 1200, pbBackdrop('emeraldLift', () =>
  mihrabArch(800, 1050, 420, 660, '#1E4B3A', '#16382C') +
  hangLine(560, 560, 0.8, GOLD, 380) + lantern(560, 560, 0.8) +
  hangLine(1040, 560, 0.8, GOLD, 380) + lantern(1040, 560, 0.8) +
  groundBand('#0D271E', 1070)));

add('pb_backdrop', 'yunus_backdrop', 1600, 1200, pbBackdrop('night', () =>
  stars(132, 24, 60, 1540, 40, 380) + crescent(1300, 200, 60, IVORY) +
  wave(620, 46, '#2C3F66') +
  fish(800, 900, 1.3) +
  wave(1100, 34, '#1A2440')));

add('pb_backdrop', 'isa_backdrop', 1600, 1200, pbBackdrop('dawn', () =>
  stars(142, 10, 60, 1540, 40, 220) + star8(800, 220, 54, GOLD, CREAM) +
  hills('#8A5A36', 920, 50) +
  palm(1200, 1010, 1.05, '#54382A') +
  `<ellipse cx="800" cy="1060" rx="230" ry="44" fill="#4A6E96"/>` +
  `<ellipse cx="800" cy="1052" rx="185" ry="30" fill="#A9C4BC"/>` +
  `<path d="M0 1200 L0 1120 Q 800 1080 1600 1110 V 1200 Z" fill="#4A2F22"/>`));

add('pb_backdrop', 'muhammad_backdrop', 1600, 1200, pbBackdrop('emerald', () =>
  stars(152, 20, 60, 1540, 40, 300) + crescent(1310, 190, 64, IVORY) +
  mosqueSilhouette(800, 1000, 0.85, '#0D271E') +
  groundBand('#0D271E', 1010)));

// ======================= quran_teacher pack (1024x768) =====================

const qtScene = (skyName, deco, ground = null) => () => {
  const s = skyV(SKY[skyName]);
  const gl = glow2(512, 380, 320, CREAM, 0.5);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` + deco() +
    (ground ?? `<rect x="0" y="660" width="1024" height="108" fill="#DDBE94"/>`));
};

add('qt', 'soft_placeholder', 1024, 768, qtScene('pastelSky', () =>
  `<g opacity="0.55">${mihrabArch(512, 640, 300, 380, '#A9C4BC', '#D9E0D2')}</g>` +
  crescent(512, 330, 66, '#EDE8D8') +
  sparkle(360, 250, 14, '#B98A3E', 0.4) + sparkle(680, 230, 12, '#B98A3E', 0.35),
  `<rect x="0" y="660" width="1024" height="108" fill="#8FB48A"/>`));

add('qt', 'alif_apple', 1024, 768, qtScene('pastelWarm', () =>
  apple(512, 400, 1.35) +
  `<ellipse cx="512" cy="530" rx="200" ry="24" fill="#B98A3E" opacity="0.22"/>`));

add('qt', 'ba_ball', 1024, 768, qtScene('pastelSky', () =>
  ball(512, 380, 150) +
  `<ellipse cx="512" cy="548" rx="210" ry="24" fill="#31547A" opacity="0.18"/>`));

add('qt', 'ta_tree', 1024, 768, qtScene('pastelSky', () =>
  tree(512, 560, 0.85),
  `<path d="M0 560 Q 256 528 512 550 T 1024 545 V 768 H 0 Z" fill="#A9C79B"/><rect x="0" y="700" width="1024" height="68" fill="#8FB48A"/>`));

add('qt', 'jeem_juice', 1024, 768, qtScene('pastelWarm', () =>
  juiceCup(512, 520, 1.1) +
  `<ellipse cx="512" cy="548" rx="190" ry="22" fill="#B98A3E" opacity="0.22"/>`));

add('qt', 'seen_sun', 1024, 768, qtScene('pastelSky', () =>
  cloud(200, 170, 120, 40, 0.7) + cloud(850, 240, 130, 42, 0.55) +
  sun(512, 340, 130),
  `<path d="M0 640 Q 256 600 512 628 T 1024 620 V 768 H 0 Z" fill="#A9C79B"/><rect x="0" y="700" width="1024" height="68" fill="#8FB48A"/>`));

add('qt', 'meem_moon', 1024, 768, qtScene('pastelNight', () =>
  stars(201, 16, 60, 964, 60, 420, '#EDE8D8') +
  crescent(512, 330, 130, '#F0E4C0') +
  sparkle(330, 220, 13, '#EDE8D8', 0.8) + sparkle(700, 480, 11, '#EDE8D8', 0.7),
  `<rect x="0" y="660" width="1024" height="108" fill="#565C80"/>`));

add('qt', 'noon_nest', 1024, 768, qtScene('pastelSky', () =>
  `<path d="M 200 660 Q 512 560 824 660" stroke="#8A5A36" stroke-width="22" fill="none" stroke-linecap="round"/>` +
  nest(512, 480, 1.15) +
  birdV(760, 220, 1.2, '#8A5A36'),
  `<path d="M0 640 Q 256 610 512 632 T 1024 626 V 768 H 0 Z" fill="#A9C79B"/><rect x="0" y="700" width="1024" height="68" fill="#8FB48A"/>`));

add('qt', 'waw_water', 1024, 768, qtScene('pastelBlue', () =>
  cup(512, 520, 1.6, '#4A6E96') +
  `<path d="M 470 380 q -18 -40 12 -66 q -8 44 20 66 Z" fill="#A9C4BC"/>` +
  `<circle cx="560" cy="360" r="12" fill="#A9C4BC"/>` +
  `<ellipse cx="512" cy="548" rx="180" ry="22" fill="#31547A" opacity="0.16"/>`));

add('qt', 'maa_water', 1024, 768, qtScene('pastelBlue', () =>
  jug(400, 520, 1.3, '#4A6E96') +
  `<path d="M 452 420 Q 540 430 590 500" stroke="#A9C4BC" stroke-width="17" fill="none" stroke-linecap="round"/>` +
  cup(650, 520, 1.1, '#4A6E96') +
  `<ellipse cx="520" cy="548" rx="230" ry="24" fill="#31547A" opacity="0.16"/>`));

add('qt', 'shams_sun', 1024, 768, qtScene('pastelWarm', () =>
  sun(512, 350, 140, '#E8965A', '#E8C089') +
  cloud(210, 210, 110, 38, 0.6),
  `<rect x="0" y="660" width="1024" height="108" fill="#DDBE94"/>`));

add('qt', 'qamar_moon', 1024, 768, qtScene('pastelNight', () =>
  stars(211, 20, 60, 964, 60, 480, '#EDE8D8') +
  fullMoon(512, 340, 130) +
  sparkle(320, 200, 13, '#EDE8D8', 0.8) + sparkle(730, 260, 11, '#EDE8D8', 0.7),
  `<rect x="0" y="660" width="1024" height="108" fill="#565C80"/>`));

add('qt', 'kitab_book', 1024, 768, qtScene('pastelWarm', () =>
  sparkle(250, 200, 16, DEEPGOLD, 0.55) + sparkle(800, 180, 13, DEEPGOLD, 0.5) +
  closedBook(512, 390, 1.15) +
  `<ellipse cx="512" cy="530" rx="240" ry="26" fill="#B98A3E" opacity="0.25"/>`));

// ------------------------------------------------------------------ write --

const byDir = {};
for (const [dir, name, w, h, fn] of scenes) {
  W = w; H = h;
  const sub = join(OUT, dir);
  mkdirSync(sub, { recursive: true });
  writeFileSync(join(sub, `${name}.svg`), fn());
  byDir[dir] = (byDir[dir] ?? 0) + 1;
}
console.log(Object.entries(byDir).map(([k, v]) => `${k}:${v}`).join(' '), '=',
  scenes.length, 'scenes');
