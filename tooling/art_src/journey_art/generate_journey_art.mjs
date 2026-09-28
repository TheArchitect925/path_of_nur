// Path of Nur — learning-island art (journey layer).
// Same visual language as learn_art v2 and kids_art: soft gradient skies
// anchored to app theme tokens, large calm silhouettes, warm ivory light,
// gold accents; no faces, no figures, no text baked into artwork.
//
// One scene per learning island. Journeys inherit their island's scene as a
// card thumbnail, so every journey in the app carries art. Each scene gets a
// DISTINCT dominant silhouette (they are read at ~48px as thumbnails) and a
// sky that differs from its neighbours. Heroes are de-duplicated against all
// 27 learn_art scenes and all 59 kids_art scenes:
//   taken already — rehal, colonnade, prayer mat, tree, mosque+palm, octagram,
//   door, lantern road, book+qalam, pearl shore, kite, letterforms, blocks,
//   book stack, scroll, ark, well, great fish, parted sea, nest, apple.
import { mkdirSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

const OUT = fileURLToPath(new URL('./svg/', import.meta.url));
mkdirSync(OUT, { recursive: true });

const W = 1600, H = 1200;
const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';

const SKY = {
  dawn: [[0, '#4A5D8A'], [0.55, '#B0743B'], [1, '#E8B36A']],
  day: [[0, '#31547A'], [0.6, '#7A9AA8'], [1, '#E8C089']],
  night: [[0, '#121423'], [0.55, '#1A1F33'], [1, '#232A44']],
  violetLift: [[0, '#211A38'], [0.6, '#2C2347'], [1, '#4A3560']],
  emerald: [[0, '#0D271E'], [0.5, '#16382C'], [1, '#2E5D48']],
  amber: [[0, '#B0743B'], [0.6, '#D19A56'], [1, '#E8C089']],
};

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

// Mask-based crescent — the learn_art arc-path version collapses to a
// zero-area sliver in newer librsvg. Never copy that one.
function crescent(cx, cy, r, lit) {
  const id = `cr${gradN++}`;
  return `<defs><mask id="${id}">` +
    `<rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="black"/>` +
    `<circle cx="${cx}" cy="${cy}" r="${r}" fill="white"/>` +
    `<circle cx="${cx + r * 0.46}" cy="${cy - r * 0.2}" r="${r * 0.88}" fill="black"/>` +
    `</mask></defs>` +
    `<rect x="${cx - r * 1.3}" y="${cy - r * 1.3}" width="${r * 2.6}" height="${r * 2.6}" fill="${lit}" mask="url(#${id})"/>`;
}

const groundBand = (color, y = 950) =>
  `<rect x="0" y="${y}" width="${W}" height="${H - y}" fill="${color}"/>`;

const hills = (color, yTop, amp = 60) =>
  `<path d="M0 ${yTop + amp} Q ${W * 0.22} ${yTop - amp} ${W * 0.5} ${yTop} T ${W} ${yTop - amp * 0.4} V ${H} H 0 Z" fill="${color}"/>`;

const cloud = (cx, cy, rx, ry, op) =>
  `<g opacity="${op}" fill="${CREAM}"><ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}"/><ellipse cx="${cx - rx * 0.55}" cy="${cy + ry * 0.35}" rx="${rx * 0.6}" ry="${ry * 0.75}"/><ellipse cx="${cx + rx * 0.55}" cy="${cy + ry * 0.3}" rx="${rx * 0.65}" ry="${ry * 0.7}"/></g>`;

const sparkle = (x, y, r, fill = GOLD, op = 0.9) =>
  `<path d="M ${x} ${y - r} Q ${x + r * 0.18} ${y - r * 0.18} ${x + r} ${y} Q ${x + r * 0.18} ${y + r * 0.18} ${x} ${y + r} Q ${x - r * 0.18} ${y + r * 0.18} ${x - r} ${y} Q ${x - r * 0.18} ${y - r * 0.18} ${x} ${y - r} Z" fill="${fill}" opacity="${op}"/>`;

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

const palm = (x, gy, s, color) => {
  const fr = (a) => `<path d="M 0 -170 q ${90 * Math.cos(a)} ${-46 - 34 * Math.sin(a)} ${168 * Math.cos(a)} ${-14 * Math.sin(a) + 26}" stroke="${color}" stroke-width="17" fill="none" stroke-linecap="round"/>`;
  return `<g transform="translate(${x} ${gy}) scale(${s})">` +
    `<path d="M -14 0 Q 4 -90 -6 -170 L 16 -170 Q 18 -90 12 0 Z" fill="${color}"/>` +
    `<g transform="translate(2 0)">${fr(0.3)}${fr(1.2)}${fr(2.0)}${fr(-0.6)}</g></g>`;
};

const scenes = [];
const add = (name, fn) => scenes.push([name, fn]);

// 1 — CORE KNOWLEDGE: a muqarnas vault seen from below. Concentric rings of
// arched cells drawing the eye to a central light; the deen's centre.
add('journey_core_knowledge', () => {
  const s = skyV(SKY.night);
  const gl = glow2(800, 560, 460, CREAM, 0.5);
  // concentric rings of small arch cells
  let vault = '';
  const rings = [
    { r: 470, n: 20, h: 96, c: '#1A1F33' },
    { r: 350, n: 15, h: 84, c: '#232A44' },
    { r: 240, n: 11, h: 72, c: '#2C3452' },
    { r: 145, n: 8, h: 58, c: '#39406199' },
  ];
  for (const ring of rings) {
    for (let i = 0; i < ring.n; i++) {
      const a = (i / ring.n) * Math.PI * 2 - Math.PI / 2;
      const x = 800 + Math.cos(a) * ring.r;
      const y = 560 + Math.sin(a) * ring.r * 0.78;
      const w = ring.h * 0.62;
      vault += `<g transform="translate(${x.toFixed(1)} ${y.toFixed(1)}) rotate(${((a * 180) / Math.PI + 90).toFixed(1)})">` +
        `<path d="M ${-w / 2} ${ring.h / 2} V ${-ring.h / 6} Q ${-w / 2} ${-ring.h / 2} 0 ${-ring.h / 2} Q ${w / 2} ${-ring.h / 2} ${w / 2} ${-ring.h / 6} V ${ring.h / 2} Z" fill="${ring.c}" stroke="${GOLD}" stroke-width="3.5" stroke-opacity="0.55"/></g>`;
    }
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(301, 26, 60, 1540, 40, 320) +
    vault + gl.el +
    `<circle cx="800" cy="560" r="86" fill="${CREAM}"/>` +
    `<circle cx="800" cy="560" r="58" fill="${GOLD}"/>` +
    sparkle(800, 560, 40, CREAM) +
    sparkle(410, 300, 14) + sparkle(1210, 320, 12, CREAM));
});

// 2 — PRACTICE & IBADAH: a misbaha drawn as one long draped loop of beads,
// the daily rhythm of dhikr. (island_worship already owns mat + lantern.)
add('journey_practice_worship', () => {
  const s = skyV(SKY.emerald);
  const gl = glow2(800, 600, 470, GOLD, 0.4);
  // beads along a catenary-ish loop
  let beads = '';
  const N = 46;
  for (let i = 0; i <= N; i++) {
    const t = i / N;
    const a = Math.PI * 2 * t - Math.PI / 2;
    const x = 800 + Math.sin(a) * 300;
    const y = 590 + Math.cos(a) * 250 + Math.sin(t * Math.PI) * 60;
    const r = 17 + (i % 7 === 0 ? 6 : 0);
    beads += `<circle cx="${x.toFixed(1)}" cy="${y.toFixed(1)}" r="${r}" fill="${i % 7 === 0 ? CREAM : GOLD}"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    stars(311, 12, 60, 1540, 40, 260, CREAM) +
    beads +
    // the imame (head bead) and tassel hanging below
    `<ellipse cx="800" cy="878" rx="30" ry="46" fill="${CREAM}"/>` +
    `<line x1="800" y1="920" x2="800" y2="1000" stroke="${DEEPGOLD}" stroke-width="10"/>` +
    `<path d="M 770 1000 H 830 L 818 1078 H 782 Z" fill="${DEEPGOLD}"/>` +
    sparkle(500, 380, 14, CREAM) + sparkle(1120, 400, 12) +
    groundBand('#0D271E', 1090));
});

// 3 — UNDERSTANDING ISLAM: a balance (mizan) in equilibrium — weighing,
// reasoning, fiqh. Light rests in both pans.
add('journey_understanding_islam', () => {
  const s = skyV(SKY.dawn);
  const gl = glow2(800, 470, 430, CREAM, 0.45);
  const pan = (cx, cy) =>
    `<line x1="${cx - 96}" y1="${cy - 130}" x2="${cx}" y2="${cy}" stroke="${DEEPGOLD}" stroke-width="6"/>` +
    `<line x1="${cx + 96}" y1="${cy - 130}" x2="${cx}" y2="${cy}" stroke="${DEEPGOLD}" stroke-width="6"/>` +
    `<path d="M ${cx - 118} ${cy} A 118 118 0 0 0 ${cx + 118} ${cy} Z" fill="${GOLD}"/>` +
    `<ellipse cx="${cx}" cy="${cy}" rx="118" ry="24" fill="${CREAM}"/>`;
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    // stand
    `<rect x="784" y="330" width="32" height="600" fill="#54382A"/>` +
    `<path d="M 660 930 H 940 L 900 986 H 700 Z" fill="#54382A"/>` +
    // beam
    `<rect x="380" y="352" width="840" height="26" rx="13" fill="#6E4629"/>` +
    `<circle cx="800" cy="330" r="34" fill="${DEEPGOLD}"/>` +
    pan(430, 630) + pan(1170, 630) +
    sparkle(430, 590, 30, CREAM) + sparkle(1170, 590, 30, CREAM) +
    sparkle(800, 200, 16) +
    hills('#8A5A36', 980, 40) + groundBand('#6E4629', 1040));
});

// 4 — ARABIC LEARNING: the lawh — a wooden writing board with its peg handle,
// leaning on the desk beside a reed pen and inkwell, lit by a small lamp.
add('journey_arabic_learning', () => {
  const s = skyV(SKY.amber);
  const gl = glow2(760, 520, 460, CREAM, 0.45);
  // ruled strokes standing in for writing — no real letterforms
  let ruled = '';
  for (let i = 0; i < 4; i++) {
    const y = 420 + i * 104;
    ruled += `<path d="M 990 ${y} q -74 -24 -158 0 q -84 24 -168 0" stroke="${DEEPGOLD}" stroke-width="14" fill="none" stroke-linecap="round" opacity="${0.9 - i * 0.13}"/>`;
  }
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}${gl.el}` +
    hangLine(300, 300, 0.7) + lantern(300, 300, 0.7) +
    // the board, leaning back a touch
    `<g transform="rotate(-4 760 600)">` +
    // peg handle at the top
    `<rect x="726" y="212" width="68" height="70" rx="26" fill="#6E4629"/>` +
    `<circle cx="760" cy="238" r="16" fill="#4A2F22"/>` +
    // board body with a rounded head
    `<path d="M 452 900 V 358 Q 452 268 760 268 Q 1068 268 1068 358 V 900 Z" fill="#8A5A36"/>` +
    `<path d="M 496 862 V 372 Q 496 310 760 310 Q 1024 310 1024 372 V 862 Z" fill="#EFE3C0"/>` +
    ruled +
    `</g>` +
    // desk
    `<rect x="0" y="900" width="${W}" height="34" fill="#6E4629"/>` +
    `<rect x="0" y="934" width="${W}" height="266" fill="#4A2F22"/>` +
    // reed pen resting on the desk
    `<g transform="rotate(-7 1250 880)">` +
    `<rect x="1130" y="866" width="250" height="16" rx="8" fill="#D9A05B"/>` +
    `<path d="M 1380 866 l 34 8 l -34 8 Z" fill="#3D2A20"/>` +
    `</g>` +
    // inkwell
    `<path d="M 1216 1046 q -20 -74 28 -108 h 84 q 48 34 28 108 Z" fill="#3D2A20"/>` +
    `<ellipse cx="1286" cy="938" rx="58" ry="15" fill="#241C3E"/>` +
    sparkle(1080, 470, 15, CREAM) + sparkle(560, 340, 12));
});

// 5 — DISCOVERY: an arched window opening onto a starfield, one falling star.
add('journey_discovery', () => {
  const s = skyV(SKY.violetLift);
  const gl = glow2(800, 520, 400, CREAM, 0.4);
  const id = 'winclip';
  const r = 260;
  return svgDoc(`<defs>${s.def}${gl.def}` +
    `<clipPath id="${id}"><path d="M ${800 - r} 980 V ${340 + r} A ${r} ${r} 0 0 1 ${800 + r} ${340 + r} V 980 Z"/></clipPath>` +
    `</defs>${s.rect}` +
    // wall
    `<rect width="${W}" height="${H}" fill="#1B1530"/>` +
    // window frame + interior sky
    `<path d="M ${800 - r - 30} 1010 V ${340 + r} A ${r + 30} ${r + 30} 0 0 1 ${800 + r + 30} ${340 + r} V 1010 Z" fill="#332450"/>` +
    `<g clip-path="url(#${id})">${s.rect}` +
    stars(321, 44, 520, 1080, 300, 980) + gl.el +
    crescent(700, 520, 62, IVORY) +
    // falling star
    `<line x1="900" y1="430" x2="1010" y2="330" stroke="${CREAM}" stroke-width="9" stroke-linecap="round" opacity="0.9"/>` +
    sparkle(1012, 328, 22, CREAM) +
    `</g>` +
    // mullion
    `<rect x="788" y="${340}" width="24" height="670" fill="#332450"/>` +
    `<rect x="${800 - r - 30}" y="620" width="${(r + 30) * 2}" height="22" fill="#332450"/>` +
    // sill
    `<rect x="${800 - r - 80}" y="1010" width="${(r + 80) * 2}" height="46" rx="10" fill="#4A3560"/>` +
    sparkle(300, 400, 14, GOLD, 0.6) + sparkle(1330, 700, 12, GOLD, 0.5) +
    groundBand('#150F26', 1056));
});

// 6 — KIDS LEARNING: a garden gate standing ajar on a stepping-stone path,
// a bloom pot in the near grass. Ground is laid first so the path reads on it.
add('journey_kids_learning', () => {
  const s = skyV(SKY.day);
  const gl = glow2(800, 500, 430, CREAM, 0.42);
  const GY = 880;
  // pickets drawn in LOCAL coords: y = 0 is the ground, they rise upward
  const picket = (x, h = 190) =>
    `<path d="M ${x} 0 V ${-h + 26} L ${x + 24} ${-h} L ${x + 48} ${-h + 26} V 0 Z" fill="${CREAM}"/>`;
  const rails = (w) =>
    `<rect x="0" y="-150" width="${w}" height="18" rx="8" fill="#E8C089"/>` +
    `<rect x="0" y="-74" width="${w}" height="18" rx="8" fill="#E8C089"/>`;
  let leftRun = '', rightRun = '', leaf = '';
  for (let x = 0; x <= 420; x += 70) leftRun += picket(x);
  for (let x = 0; x <= 420; x += 70) rightRun += picket(x);
  // the open leaf is foreshortened — it has swung toward the viewer
  for (let x = 0; x <= 108; x += 54) leaf += picket(x, 178);

  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(300, 210, 165, 54, 0.5) + cloud(1300, 285, 175, 56, 0.36) + gl.el +
    hills('#5E8A6A', 820, 44) +
    groundBand('#4A7A58', GY) +
    // stepping stones leading out through the opening
    `<g fill="#D8C49A">` +
    `<ellipse cx="800" cy="1156" rx="128" ry="33"/>` +
    `<ellipse cx="800" cy="1058" rx="100" ry="26"/>` +
    `<ellipse cx="800" cy="978" rx="74" ry="20"/>` +
    `<ellipse cx="800" cy="918" rx="52" ry="14"/>` +
    `</g>` +
    // fence runs either side of the opening
    `<g transform="translate(150 ${GY})">${leftRun}${rails(468)}</g>` +
    `<g transform="translate(982 ${GY})">${rightRun}${rails(468)}</g>` +
    // hinge posts
    `<rect x="628" y="${GY - 216}" width="30" height="216" rx="8" fill="#D9A05B"/>` +
    `<rect x="944" y="${GY - 216}" width="30" height="216" rx="8" fill="#D9A05B"/>` +
    // the leaf, ajar on the left post
    `<g transform="translate(628 ${GY}) rotate(-9)">${leaf}` +
    `<rect x="0" y="-142" width="156" height="16" rx="7" fill="#E8C089"/>` +
    `<rect x="0" y="-72" width="156" height="16" rx="7" fill="#E8C089"/></g>` +
    // bloom pot in the near grass, clear of the fence
    `<g transform="translate(1290 1074)">` +
    `<path d="M -66 -98 H 66 L 50 0 H -50 Z" fill="#B8683C"/>` +
    `<rect x="-72" y="-114" width="144" height="22" rx="9" fill="#8A4A28"/>` +
    `<path d="M 0 -114 V -206" stroke="#2C4A33" stroke-width="12" stroke-linecap="round"/>` +
    `<ellipse cx="-48" cy="-226" rx="28" ry="16" fill="#5E8A6A" transform="rotate(-30 -48 -226)"/>` +
    `<ellipse cx="38" cy="-218" rx="30" ry="17" fill="#5E8A6A" transform="rotate(26 38 -218)"/>` +
    [0, 72, 144, 216, 288].map((a) => `<ellipse cx="0" cy="-234" rx="14" ry="24" fill="#E8B36A" transform="rotate(${a} 0 -216)"/>`).join('') +
    `<circle cy="-216" r="13" fill="${GOLD}"/></g>` +
    sparkle(450, 460, 15, CREAM) + sparkle(1090, 400, 12));
});

// 7 — BROWSE ALL: an archipelago — every island at once, seen from a height.
add('journey_browse_all', () => {
  const s = skyV(SKY.day);
  const gl = glow2(800, 460, 430, CREAM, 0.4);
  const ripple = (cx, cy, rx) =>
    `<path d="M ${cx - rx} ${cy} a ${rx} ${rx * 0.17} 0 0 0 ${rx * 2} 0" fill="none" stroke="${CREAM}" stroke-width="5" opacity="0.2"/>`;
  const isle = (cx, cy, w, h, palmS) =>
    ripple(cx, cy + h * 0.34, w * 0.78) +
    // sand
    `<path d="M ${cx - w / 2} ${cy} Q ${cx} ${cy + h * 0.42} ${cx + w / 2} ${cy} Q ${cx} ${cy - h * 0.9} ${cx - w / 2} ${cy} Z" fill="#D9A05B"/>` +
    // grass cap
    `<path d="M ${cx - w * 0.4} ${cy - h * 0.22} Q ${cx} ${cy - h * 1.02} ${cx + w * 0.4} ${cy - h * 0.22} Q ${cx} ${cy + h * 0.06} ${cx - w * 0.4} ${cy - h * 0.22} Z" fill="#5E8A6A"/>` +
    (palmS ? palm(cx + w * 0.08, cy - h * 0.5, palmS, '#3F5F46') : '');
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    cloud(340, 200, 150, 48, 0.45) + cloud(1240, 258, 165, 52, 0.34) + gl.el +
    // water bands
    `<path d="M0 690 Q 400 652 800 684 T 1600 668 V ${H} H 0 Z" fill="#2C6E8A"/>` +
    `<path d="M0 812 Q 420 778 800 806 T 1600 790 V ${H} H 0 Z" fill="#245C74"/>` +
    isle(1268, 742, 292, 92, 0.4) +
    isle(336, 796, 330, 104, 0.48) +
    isle(800, 900, 512, 164, 0.7) +
    sparkle(630, 410, 14, CREAM) + sparkle(1070, 470, 12) +
    `<rect x="0" y="1104" width="${W}" height="96" fill="#1E4A5E"/>`);
});

// 8 — TOOLS & OTHER: a lamplit shelf — hourglass, folded map, small lamp.
add('journey_tools_other', () => {
  const s = skyV(SKY.night);
  const gl = glow2(1120, 560, 400, CREAM, 0.45);
  return svgDoc(`<defs>${s.def}${gl.def}</defs>${s.rect}` +
    stars(331, 14, 60, 1540, 40, 300, CREAM) + gl.el +
    // shelf
    `<rect x="180" y="820" width="1240" height="34" rx="12" fill="#6E4629"/>` +
    `<rect x="180" y="854" width="1240" height="16" rx="6" fill="#54382A"/>` +
    `<rect x="270" y="870" width="34" height="150" fill="#4A2F22"/>` +
    `<rect x="1296" y="870" width="34" height="150" fill="#4A2F22"/>` +
    // hourglass
    `<g transform="translate(470 820)">` +
    `<rect x="-92" y="-340" width="184" height="26" rx="10" fill="#8A5A36"/>` +
    `<rect x="-92" y="-26" width="184" height="26" rx="10" fill="#8A5A36"/>` +
    `<path d="M -66 -314 H 66 L 12 -170 L 66 -26 H -66 L -12 -170 Z" fill="${CREAM}" opacity="0.32"/>` +
    `<path d="M -58 -306 H 58 L 8 -172 Z" fill="${GOLD}" opacity="0.9"/>` +
    `<path d="M -34 -60 H 34 L 6 -166 Z" fill="${GOLD}"/>` +
    `<line x1="-66" y1="-314" x2="-66" y2="-26" stroke="#8A5A36" stroke-width="9"/>` +
    `<line x1="66" y1="-314" x2="66" y2="-26" stroke="#8A5A36" stroke-width="9"/>` +
    `</g>` +
    // folded map
    `<g transform="translate(830 820)">` +
    `<path d="M -170 0 L -56 -46 L 56 -6 L 170 -56 L 170 0 Z" fill="#D8C49A"/>` +
    `<path d="M -170 -56 L -56 -102 L 56 -62 L 170 -112 L 170 -56 L 56 -6 L -56 -46 L -170 0 Z" fill="#EFE3C0"/>` +
    `<path d="M -56 -102 V -46 M 56 -62 V -6" stroke="#C4B084" stroke-width="5"/>` +
    `<path d="M -120 -72 q 46 -20 92 4 q 46 24 92 -4" stroke="#B8683C" stroke-width="6" fill="none" stroke-dasharray="3 16"/>` +
    `</g>` +
    // small lamp
    hangLine(1150, 560, 0.85, GOLD, 0) + lantern(1150, 560, 0.85) +
    sparkle(1150, 760, 16, CREAM, 0.7) + sparkle(330, 480, 13) +
    groundBand('#101627', 1020));
});

for (const [name, fn] of scenes) {
  writeFileSync(join(OUT, `${name}.svg`), fn());
  console.log('wrote', name);
}
console.log(`${scenes.length} island scenes`);
