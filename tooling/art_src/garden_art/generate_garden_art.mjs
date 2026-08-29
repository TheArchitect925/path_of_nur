// Path of Nur — Living Garden Vista art generator.
// One LAYOUT object is the single source of truth for every coordinate in the
// 2000x1200 design space; running the script emits
// lib/features/garden/data/garden_scene_layout.g.dart, per-layer SVG masters
// in svg/, and (with rsvg-convert + cwebp on PATH) the WebP layers in
// assets/images/garden_art/. `--preview` additionally composes full scenes to
// preview_*.png for visual QA; the P7 milestone gallery reuses the same
// composition.
//
// Style contract: painterly calm — volumetric foliage lit from the upper
// left, soft gradient skies, warm ivory light, gold accents, atmospheric
// haze. No faces, no figures, no text baked into artwork.
import { execFileSync } from 'node:child_process';
import { existsSync, mkdirSync, writeFileSync } from 'node:fs';
import { dirname, join } from 'node:path';
import { fileURLToPath } from 'node:url';

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO = join(HERE, '..', '..', '..');
const SVG_OUT = join(HERE, 'svg');
const WEBP_OUT = join(REPO, 'assets', 'images', 'garden_art');
const DART_OUT = join(REPO, 'lib', 'features', 'garden', 'data', 'garden_scene_layout.g.dart');
const EXPORT_SCALE = 0.8;

/* ================================ LAYOUT ================================ */

const CANVAS = { w: 2000, h: 1200, horizonY: 600 };
const HZN = CANVAS.horizonY;

const CROPS = {
  hero: { x: 130, y: 0, w: 1740, h: 1200 },
  homeCard: { x: 100, y: 280, w: 1800, h: 800 },
};

const REGIONS = {
  ground: [0, 540, 2000, 660],
  water: [1040, 560, 960, 640],
};

const ELEMENTS = {
  loteTree:    { z: 30, rect: [1700, 520, 260, 270], base: [1830, 770] },
  datePalm:    { z: 32, rect: [90, 640, 440, 420],   base: [300, 1040] },
  olive:       { z: 34, rect: [380, 800, 300, 220],  base: [520, 1010] },
  fig:         { z: 36, rect: [600, 830, 270, 200],  base: [735, 1020] },
  centralTree: { z: 40, rect: [620, 300, 760, 700],  base: [1000, 990] },
  pomegranate: { z: 44, rect: [1440, 860, 250, 190], base: [1565, 1040] },
  grapeVine:   { z: 46, rect: [1640, 830, 300, 195], base: [1785, 1015] },
  gourd:       { z: 48, rect: [1090, 1060, 220, 90], base: [1195, 1132] },
  rayhan:      { z: 50, rect: [750, 1030, 220, 110], base: [855, 1124] },
  hoopoe:      { z: 52, rect: [1080, 990, 150, 120], base: [1150, 1052] },
  ant:         { z: 54, rect: [900, 1120, 140, 40],  base: [970, 1140] },
};

const MOTION = {
  streamCenterline: [
    [1490, 620], [1462, 750], [1396, 820], [1430, 890],
    [1352, 960], [1392, 1030], [1308, 1105], [1330, 1205],
  ],
  fireflyRegion: [600, 700, 700, 220],
  beeAnchors: [[700, 905], [940, 846], [610, 834]],
  fishAnchor: [1360, 1058],
  beehiveAnchor: [872, 664],
  birdBand: [200, 360],
};

/* =============================== PALETTES =============================== */

const IVORY = '#F0E4C0', CREAM = '#F5E7BE', GOLD = '#E2C177', DEEPGOLD = '#B98A3E';

const SKIES = {
  dawn:    { day: [[0, '#3D4E79'], [0.42, '#7A6488'], [0.7, '#C08A5A'], [1, '#EFC183']],
             night: [[0, '#101323'], [0.5, '#181C31'], [0.8, '#232A44'], [1, '#2E3550']] },
  morning: { day: [[0, '#39628C'], [0.45, '#6E93A6'], [0.75, '#A9BFAE'], [1, '#EAD3A2']],
             night: [[0, '#141127'], [0.55, '#201A37'], [1, '#2E2649']] },
  warm:    { day: [[0, '#8A5E3C'], [0.5, '#C08A52'], [0.8, '#E3B276'], [1, '#F2D6A0']],
             night: [[0, '#191330'], [0.5, '#2A2145'], [1, '#4A3560']] },
  evening: { day: [[0, '#3A2E55'], [0.5, '#5C4370'], [0.78, '#9A5F55'], [1, '#D99A66']],
             night: [[0, '#0D091C'], [0.5, '#141024'], [1, '#241B3C']] },
};

const GROUNDS = {
  day: {
    farHill: '#8BA08A', midHill: '#6B8A57', meadowHi: '#8AA663', meadowLo: '#57774B',
    nearHi: '#4C6944', nearLo: '#37502F', trunk: '#5E4632', trunkLit: '#7E5F42',
    leaf: ['#3C5A3F', '#5A7A4A', '#7E9C5F', '#A5BE7B'],
    water: ['#A8C2BE', '#6E93A0', '#3E5F74'], sea: ['#9FBDB9', '#527C90'],
    grass: '#4E6B44', dapple: CREAM,
  },
  night: {
    farHill: '#2A3444', midHill: '#28362B', meadowHi: '#35482F', meadowLo: '#243422',
    nearHi: '#1F2E1E', nearLo: '#162216', trunk: '#2E2118', trunkLit: '#463526',
    leaf: ['#1C2B1E', '#2A3D2A', '#3A5236', '#54704A'],
    water: ['#31456A', '#22334F', '#141F38'], sea: ['#25395A', '#131D36'],
    grass: '#243522', dapple: '#8FA0C8',
  },
};

/* ============================ SVG PRIMITIVES ============================ */

let uid = 0;
const id = (p) => `${p}${++uid}`;
function mulberry32(a) {
  return function () {
    a |= 0; a = (a + 0x6D2B79F5) | 0;
    let t = Math.imul(a ^ (a >>> 15), 1 | a);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}
function svgDoc(region, inner, defs) {
  const [x, y, w, h] = region;
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="${x} ${y} ${w} ${h}"><defs>${defs.join('')}</defs>${inner}</svg>`;
}
function lgV(defs, stops, x1 = 0, y1 = 0, x2 = 0, y2 = 1) {
  const g = id('lg');
  defs.push(`<linearGradient id="${g}" x1="${x1}" y1="${y1}" x2="${x2}" y2="${y2}">${stops
    .map(([o, c, a]) => `<stop offset="${o}" stop-color="${c}"${a !== undefined ? ` stop-opacity="${a}"` : ''}/>`)
    .join('')}</linearGradient>`);
  return `url(#${g})`;
}
function glowEl(defs, cx, cy, r, color, a) {
  const g = id('rg');
  defs.push(`<radialGradient id="${g}"><stop offset="0" stop-color="${color}" stop-opacity="${a}"/><stop offset="1" stop-color="${color}" stop-opacity="0"/></radialGradient>`);
  return `<circle cx="${cx}" cy="${cy}" r="${r}" fill="url(#${g})"/>`;
}
function glow2(defs, cx, cy, r, color, a = 0.5) {
  return glowEl(defs, cx, cy, r, color, a * 0.42) + glowEl(defs, cx, cy, r * 0.46, color, a);
}
function softFilter(defs, dev = 7) {
  const f = id('soft');
  defs.push(`<filter id="${f}" x="-40%" y="-40%" width="180%" height="180%"><feGaussianBlur stdDeviation="${dev}"/></filter>`);
  return f;
}
function roughFilter(defs, scaleAmt = 11) {
  const f = id('rough');
  defs.push(`<filter id="${f}" x="-12%" y="-12%" width="124%" height="124%"><feTurbulence type="fractalNoise" baseFrequency="0.030 0.045" numOctaves="2" seed="8" result="n"/><feDisplacementMap in="SourceGraphic" in2="n" scale="${scaleAmt}"/></filter>`);
  return f;
}
function stars(seed, n, x0, x1, y0, y1) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0);
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${(1.6 + rnd() * 2).toFixed(1)}" fill="${IVORY}" opacity="${(0.4 + rnd() * 0.4).toFixed(2)}"/>`;
  }
  return out;
}
function crescent(cx, cy, r) {
  return `<path d="M ${cx} ${cy - r} A ${r} ${r} 0 1 0 ${cx} ${cy + r} A ${r * 1.18} ${r * 1.18} 0 0 1 ${cx} ${cy - r} Z" fill="${IVORY}"/>`;
}
function sparkle(x, y, r, fill = GOLD, op = 0.9) {
  return `<path d="M ${x} ${y - r} L ${x + r * 0.28} ${y - r * 0.28} L ${x + r} ${y} L ${x + r * 0.28} ${y + r * 0.28} L ${x} ${y + r} L ${x - r * 0.28} ${y + r * 0.28} L ${x - r} ${y} L ${x - r * 0.28} ${y - r * 0.28} Z" fill="${fill}" opacity="${op}"/>`;
}
function cloudSoft(defs, cx, cy, s, op, warm) {
  const f = softFilter(defs);
  let c = `<ellipse cx="${cx}" cy="${cy}" rx="${150 * s}" ry="${40 * s}" fill="#FDF8EA"/>
  <ellipse cx="${cx - 70 * s}" cy="${cy + 10 * s}" rx="${90 * s}" ry="${30 * s}" fill="#FDF8EA"/>
  <ellipse cx="${cx + 80 * s}" cy="${cy + 8 * s}" rx="${100 * s}" ry="${28 * s}" fill="#FDF8EA"/>
  <ellipse cx="${cx - 10 * s}" cy="${cy - 22 * s}" rx="${80 * s}" ry="${30 * s}" fill="#FFFDF4"/>`;
  if (warm) c += `<ellipse cx="${cx}" cy="${cy + 22 * s}" rx="${130 * s}" ry="${18 * s}" fill="${warm}" opacity="0.5"/>`;
  return `<g filter="url(#${f})" opacity="${op}">${c}</g>`;
}
// Volumetric foliage: scattered shaded blobs, lit from the upper left.
function foliage(defs, cx, cy, rx, ry, seed, pal, rough = true) {
  const rnd = mulberry32(seed);
  let out = `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="${pal[0]}"/>`;
  const n = Math.max(10, Math.round(12 + (rx * ry) / 2200));
  for (let i = 0; i < n; i++) {
    const a = rnd() * Math.PI * 2, rr = Math.sqrt(rnd());
    const x = cx + Math.cos(a) * rx * rr * 0.94, y = cy + Math.sin(a) * ry * rr * 0.94;
    const lf = (((cx - x) / rx) * 0.45 + ((cy - y) / ry) * 0.85 + 1) / 2;
    const col = lf > 0.7 ? pal[2] : lf > 0.38 ? pal[1] : pal[0];
    out += `<circle cx="${x.toFixed(0)}" cy="${y.toFixed(0)}" r="${(rx * 0.15 + rnd() * rx * 0.17).toFixed(0)}" fill="${col}"/>`;
  }
  for (let i = 0; i < 5; i++) {
    const a = -Math.PI * 0.72 + (rnd() - 0.5) * 0.9;
    out += `<circle cx="${(cx + Math.cos(a) * rx * 0.78).toFixed(0)}" cy="${(cy + Math.sin(a) * ry * 0.78).toFixed(0)}" r="${(rx * 0.09 + rnd() * rx * 0.07).toFixed(0)}" fill="${pal[3] || pal[2]}" opacity="0.9"/>`;
  }
  if (!rough) return `<g>${out}</g>`;
  const f = roughFilter(defs);
  return `<g filter="url(#${f})">${out}</g>`;
}
function shadowEl(defs, cx, cy, rx, ry, op = 0.2) {
  const g = id('sh');
  defs.push(`<radialGradient id="${g}"><stop offset="0" stop-color="#0E1710" stop-opacity="${op}"/><stop offset="1" stop-color="#0E1710" stop-opacity="0"/></radialGradient>`);
  return `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="url(#${g})"/>`;
}
function chaikin(pts, iters = 2) {
  let p = pts;
  for (let k = 0; k < iters; k++) {
    const q = [p[0]];
    for (let i = 0; i < p.length - 1; i++) {
      const [x1, y1] = p[i], [x2, y2] = p[i + 1];
      q.push([x1 * 0.75 + x2 * 0.25, y1 * 0.75 + y2 * 0.25], [x1 * 0.25 + x2 * 0.75, y1 * 0.25 + y2 * 0.75]);
    }
    q.push(p[p.length - 1]);
    p = q;
  }
  return p;
}

/* ============================ LAYER PAINTERS ============================ */

const FULL = [0, 0, CANVAS.w, CANVAS.h];

function paintSky(ambKey, tod) {
  const defs = [];
  let g = `<rect x="0" y="0" width="${CANVAS.w}" height="${CANVAS.h}" fill="${lgV(defs, SKIES[ambKey][tod])}"/>`;
  const hazeColor = SKIES[ambKey][tod].slice(-1)[0][1];
  g += `<rect x="0" y="${HZN - 170}" width="${CANVAS.w}" height="210" fill="${lgV(defs, [[0, hazeColor, 0], [1, hazeColor, 0.55]])}"/>`;
  if (tod === 'night') {
    g += stars(21, 34, 60, 1940, 50, 470) + glow2(defs, 330, 180, 140, IVORY, 0.5) + crescent(330, 180, 64);
  } else if (ambKey === 'dawn') {
    g += glow2(defs, 620, 470, 420, '#FBE3B0', 0.75) + `<circle cx="620" cy="470" r="64" fill="#FBEED2"/>`;
    g += cloudSoft(defs, 1360, 250, 1.1, 0.5, '#E8B36A') + cloudSoft(defs, 420, 180, 0.8, 0.35, '#E8B36A');
  } else if (ambKey === 'morning') {
    g += glow2(defs, 560, 300, 300, '#F8ECC8', 0.55) + `<circle cx="560" cy="300" r="52" fill="#FBF3DC"/>`;
    g += cloudSoft(defs, 1310, 220, 1.2, 0.55) + cloudSoft(defs, 820, 140, 0.7, 0.35) + cloudSoft(defs, 1680, 330, 0.8, 0.3);
  } else if (ambKey === 'warm') {
    g += glow2(defs, 660, 430, 460, '#FBE3B0', 0.8) + `<circle cx="660" cy="430" r="70" fill="#FDF0D2"/>`;
    g += cloudSoft(defs, 1420, 260, 1, 0.4, '#E8B36A');
  } else {
    g += glow2(defs, 470, 300, 300, '#F2D5A2', 0.6) + `<circle cx="470" cy="300" r="60" fill="#F5E3BC"/>`;
    g += stars(31, 12, 900, 1940, 60, 300) + cloudSoft(defs, 1460, 250, 0.9, 0.3, '#9A5F55');
  }
  return svgDoc(FULL, g, defs);
}

function paintGround(tod) {
  const G = GROUNDS[tod];
  const defs = [];
  const rough = roughFilter(defs);
  const far = softFilter(defs, 6);
  // Far band with a gentle bay saddle on the right — the water layers place
  // the sea inside this window at high tiers; at low tiers it reads as a
  // distant valley.
  let g = `<g filter="url(#${far})" opacity="0.95"><path d="M -60 ${CANVAS.h} L -60 ${HZN + 30}
    C 240 ${HZN - 4} 560 ${HZN + 36} 900 ${HZN + 18}
    C 1080 ${HZN + 8} 1180 ${HZN + 14} 1260 ${HZN + 32}
    C 1400 ${HZN + 78} 1720 ${HZN + 78} 1900 ${HZN + 30}
    C 1960 ${HZN + 10} 2060 ${HZN + 16} 2060 ${HZN + 16} L 2060 ${CANVAS.h} Z" fill="${G.farHill}"/></g>`;
  g += `<g filter="url(#${rough})"><path d="M -60 ${CANVAS.h} L -60 786
    C 340 706 820 762 1150 792 C 1450 818 1740 756 2060 788 L 2060 ${CANVAS.h} Z" fill="${G.midHill}"/></g>`;
  g += `<g filter="url(#${rough})"><path d="M -60 ${CANVAS.h} L -60 908 Q 500 838 1010 886 Q 1520 932 2060 878 L 2060 ${CANVAS.h} Z" fill="${lgV(defs, [[0, G.meadowHi], [1, G.meadowLo]], 0, 0.45, 0, 1)}"/></g>`;
  g += `<g filter="url(#${rough})"><path d="M -60 ${CANVAS.h} L -60 1072 Q 800 1018 2060 1058 V ${CANVAS.h} Z" fill="${lgV(defs, [[0, G.nearHi], [1, G.nearLo]], 0, 0.8, 0, 1)}"/></g>`;
  const soft = softFilter(defs);
  g += `<g filter="url(#${soft})" opacity="${tod === 'night' ? 0.25 : 0.5}">
    <path d="M 60 946 q 420 -26 900 -8" stroke="${G.dapple}" stroke-width="26" fill="none" opacity="0.10"/>
    <path d="M 220 1002 q 520 -20 1240 4" stroke="${G.dapple}" stroke-width="30" fill="none" opacity="0.09"/>
    <ellipse cx="620" cy="962" rx="170" ry="26" fill="${G.dapple}" opacity="0.15"/>
    <ellipse cx="1120" cy="1012" rx="140" ry="22" fill="${G.dapple}" opacity="0.12"/>
    <ellipse cx="330" cy="1062" rx="120" ry="20" fill="${G.dapple}" opacity="0.12"/>
    <ellipse cx="1660" cy="1002" rx="150" ry="22" fill="${G.dapple}" opacity="0.11"/></g>`;
  const rnd = mulberry32(97);
  for (let i = 0; i < 52; i++) {
    const x = 40 + rnd() * 1920, y = 1000 + rnd() * 180, h = 14 + rnd() * 22, b = (rnd() - 0.5) * 10;
    g += `<path d="M ${x.toFixed(0)} ${y.toFixed(0)} q ${b.toFixed(1)} ${(-h * 0.6).toFixed(1)} ${(b * 1.4).toFixed(1)} ${(-h).toFixed(1)}" stroke="${G.grass}" stroke-width="3" fill="none" stroke-linecap="round" opacity="${(0.35 + rnd() * 0.3).toFixed(2)}"/>`;
    if (tod === 'day' && rnd() > 0.84) g += `<circle cx="${(x + b * 1.4).toFixed(0)}" cy="${(y - h - 2).toFixed(0)}" r="2.6" fill="${rnd() > 0.5 ? CREAM : GOLD}" opacity="0.8"/>`;
  }
  return svgDoc(REGIONS.ground, g, defs);
}

function paintWater(tier, tod) {
  const G = GROUNDS[tod];
  const [hi, mid, deep] = G.water;
  const defs = [];
  const rough = roughFilter(defs);
  let g = '';
  const seaVisible = tier >= 4;
  if (seaVisible) {
    const full = tier >= 5;
    const [seaHi, seaLo] = G.sea;
    // Stays inside the ground layer's bay saddle (bottom ~HZN+78) with soft
    // horizontal fades so it melts into the flanking hills.
    const fade = lgV(defs, [[0, seaHi, 0], [0.16, seaHi, 1], [0.86, seaLo, 1], [1, seaLo, 0]], 0, 0, 1, 0);
    g += `<rect x="1200" y="${HZN - 10}" width="770" height="${full ? 82 : 56}" fill="${fade}"/>`;
    g += `<rect x="1250" y="${HZN - 10}" width="660" height="4" fill="${IVORY}" opacity="0.3"/>`;
    if (full) {
      g += `<ellipse cx="1480" cy="${HZN + 34}" rx="140" ry="5" fill="${IVORY}" opacity="0.2"/>
        <ellipse cx="1690" cy="${HZN + 58}" rx="90" ry="4" fill="${IVORY}" opacity="0.16"/>
        <path d="M 1330 ${HZN + 46} q 60 6 120 0 M 1560 ${HZN + 70} q 70 7 140 0" stroke="${IVORY}" stroke-width="2.5" opacity="0.22" fill="none"/>`;
    }
  }
  if (tier <= 1) {
    g += `<g filter="url(#${rough})">
      <ellipse cx="1350" cy="1082" rx="86" ry="24" fill="${mid}"/>
      <ellipse cx="1350" cy="1078" rx="62" ry="15" fill="${lgV(defs, [[0, hi], [1, deep]])}"/></g>
      <ellipse cx="1338" cy="1078" rx="30" ry="4" fill="${IVORY}" opacity="0.2"/>
      <path d="M 1275 1094 q 30 10 74 8" stroke="${G.nearLo}" stroke-width="5" opacity="0.5" fill="none"/>`;
  } else {
    const mw = [0, 0, 46, 78, 114, 152][tier];
    const startY = seaVisible ? HZN + 22 : 706;
    const cl = [
      [1490, startY, seaVisible ? mw * 0.5 : Math.max(7, mw * 0.1)],
      [1462, 750, mw * 0.24], [1396, 820, mw * 0.36], [1430, 890, mw * 0.5],
      [1352, 960, mw * 0.62], [1392, 1030, mw * 0.76], [1308, 1105, mw * 0.9], [1330, 1205, mw],
    ];
    const left = chaikin(cl.map(([x, y, w]) => [x - w, y]));
    const right = chaikin(cl.map(([x, y, w]) => [x + w, y]).reverse());
    const poly = [...left, ...right].map(([x, y]) => `${x.toFixed(0)},${y.toFixed(0)}`).join(' ');
    const inner = [
      ...chaikin(cl.map(([x, y, w]) => [x - w * 0.42, y])),
      ...chaikin(cl.map(([x, y, w]) => [x + w * 0.42, y]).reverse()),
    ].map(([x, y]) => `${x.toFixed(0)},${y.toFixed(0)}`).join(' ');
    g += `<g filter="url(#${rough})">
      <polygon points="${poly}" fill="${lgV(defs, [[0, hi], [0.45, mid], [1, deep]])}"/>
      <polygon points="${poly}" fill="none" stroke="${G.nearLo}" stroke-width="6" opacity="0.4"/>
      <polygon points="${inner}" fill="${deep}" opacity="0.4"/></g>`;
    if (!seaVisible) {
      const soft = softFilter(defs);
      g += `<g filter="url(#${soft})"><ellipse cx="1490" cy="${startY + 8}" rx="34" ry="12" fill="${hi}" opacity="0.8"/></g>`;
    }
    const ctr = chaikin(cl.map(([x, y]) => [x, y]));
    for (let i = 6; i < ctr.length - 6; i += 7) {
      const [x1, y1] = ctr[i], [x2, y2] = ctr[i + 4];
      const off = (i % 2 ? 9 : -8) * ((y1 - HZN) / 600 + 0.3);
      g += `<path d="M ${(x1 + off).toFixed(0)} ${y1.toFixed(0)} L ${(x2 + off).toFixed(0)} ${y2.toFixed(0)}" stroke="${IVORY}" stroke-width="${(2.4 + ((y1 - HZN) / 600) * 3).toFixed(1)}" stroke-linecap="round" fill="none" opacity="0.2"/>`;
    }
  }
  return svgDoc(REGIONS.water, g, defs);
}

/* Tree stages. Stages 1-4 are one layer; 5-10 split into trunk + canopy so
   the canopy can sway on its own GPU layer. */
function treeParts(stageNumber, tod) {
  const G = GROUNDS[tod];
  const [bx, by] = ELEMENTS.centralTree.base;
  const region = ELEMENTS.centralTree.rect;
  const defs = [];
  const rough = roughFilter(defs);
  const shadow = shadowEl(defs, bx + 20, by + 4, 150 + stageNumber * 16, 20 + stageNumber * 2.2, 0.24);
  if (stageNumber === 1) {
    const g = shadow + `<g filter="url(#${rough})"><ellipse cx="${bx}" cy="${by - 8}" rx="26" ry="17" fill="${G.trunk}"/><ellipse cx="${bx - 6}" cy="${by - 12}" rx="12" ry="7" fill="${G.trunkLit}"/></g>` + sparkle(bx, by - 52, 12, CREAM, 0.8);
    return { single: svgDoc(region, g, defs) };
  }
  if (stageNumber === 2 || stageNumber === 3) {
    const height = stageNumber === 2 ? 82 : 124;
    let g = shadow + `<g filter="url(#${rough})">
      <path d="M ${bx} ${by} C ${bx - 2} ${by - height * 0.55} ${bx + 2} ${by - height * 0.75} ${bx} ${by - height}" stroke="#4E6B44" stroke-width="9" fill="none" stroke-linecap="round"/></g>`;
    if (stageNumber === 3) {
      g += `<g filter="url(#${rough})"><path d="M ${bx - 52} ${by - 2} q 20 -12 44 -9 M ${bx + 52} ${by - 2} q -20 -12 -44 -9" stroke="${G.trunk}" stroke-width="7" fill="none" stroke-linecap="round" opacity="0.8"/></g>`;
      g += foliage(defs, bx, by - height - 18, 58, 44, 31, G.leaf);
    } else {
      g += `<g filter="url(#${rough})">
        <path d="M ${bx} ${by - 54} C ${bx - 28} ${by - 58} ${bx - 44} ${by - 74} ${bx - 48} ${by - 92} C ${bx - 24} ${by - 88} ${bx - 8} ${by - 72} ${bx - 2} ${by - 60} Z" fill="${G.leaf[2]}"/>
        <path d="M ${bx} ${by - 68} C ${bx + 26} ${by - 76} ${bx + 38} ${by - 94} ${bx + 40} ${by - 112} C ${bx + 18} ${by - 106} ${bx + 4} ${by - 88} ${bx} ${by - 74} Z" fill="${G.leaf[1]}"/></g>`;
    }
    return { single: svgDoc(region, g, defs) };
  }
  if (stageNumber === 4) {
    const trunkDefs = [];
    const r4 = roughFilter(trunkDefs);
    const sh4 = shadowEl(trunkDefs, bx + 20, by + 4, 214, 29, 0.24);
    const t = 0, trunkH = 160, trunkW = 24, cr = 105;
    const cy0 = by - trunkH - cr * 0.38;
    let g = sh4 + `<g filter="url(#${r4})"><path d="M ${bx - trunkW * 0.55} ${by}
      C ${bx - trunkW * 0.42} ${by - trunkH * 0.5} ${bx - trunkW * 0.3} ${by - trunkH * 0.82} ${bx - trunkW * 0.16} ${by - trunkH}
      L ${bx + trunkW * 0.16} ${by - trunkH}
      C ${bx + trunkW * 0.28} ${by - trunkH * 0.78} ${bx + trunkW * 0.4} ${by - trunkH * 0.48} ${bx + trunkW * 0.55} ${by} Z" fill="${lgV(trunkDefs, [[0, GROUNDS[tod].trunkLit], [1, GROUNDS[tod].trunk]], 0, 0, 1, 0)}"/></g>`;
    g += foliage(trunkDefs, bx, cy0 - cr * 0.06, cr * 1.14, cr * 0.72, 41, G.leaf);
    return { single: svgDoc(region, g, trunkDefs) };
  }
  const t = (stageNumber - 4) / 6;
  const trunkH = 160 + t * 280, trunkW = 24 + t * 54, cr = 105 + t * 205;
  const cy0 = by - trunkH - cr * 0.38;
  // trunk layer
  const trunkDefs = [];
  const tr = roughFilter(trunkDefs);
  let trunkG = shadowEl(trunkDefs, bx + 20, by + 4, 150 + stageNumber * 16, 20 + stageNumber * 2.2, 0.24);
  trunkG += `<g filter="url(#${tr})"><path d="M ${bx - trunkW * 0.55} ${by}
    C ${bx - trunkW * 0.42} ${by - trunkH * 0.5} ${bx - trunkW * 0.3} ${by - trunkH * 0.82} ${bx - trunkW * 0.16} ${by - trunkH}
    L ${bx + trunkW * 0.16} ${by - trunkH}
    C ${bx + trunkW * 0.28} ${by - trunkH * 0.78} ${bx + trunkW * 0.4} ${by - trunkH * 0.48} ${bx + trunkW * 0.55} ${by} Z" fill="${lgV(trunkDefs, [[0, G.trunkLit], [1, G.trunk]], 0, 0, 1, 0)}"/>`;
  if (stageNumber >= 6) {
    trunkG += `<path d="M ${bx - trunkW * 0.1} ${by - trunkH + 8} C ${bx - cr * 0.34} ${by - trunkH - 30} ${bx - cr * 0.6} ${by - trunkH - 52} ${bx - cr * 0.82} ${by - trunkH - 60}" stroke="${G.trunk}" stroke-width="${9 + t * 10}" fill="none" stroke-linecap="round"/>
      <path d="M ${bx + trunkW * 0.1} ${by - trunkH + 8} C ${bx + cr * 0.36} ${by - trunkH - 36} ${bx + cr * 0.62} ${by - trunkH - 58} ${bx + cr * 0.86} ${by - trunkH - 66}" stroke="${G.trunk}" stroke-width="${9 + t * 10}" fill="none" stroke-linecap="round"/>`;
  }
  trunkG += `</g>`;
  // canopy layer
  const canopyDefs = [];
  let canopyG = foliage(canopyDefs, bx, cy0 - cr * 0.06, cr * 1.14, cr * 0.72, 41, G.leaf);
  if (stageNumber >= 6) {
    canopyG += foliage(canopyDefs, bx - cr * 0.86, cy0 + cr * 0.24, cr * 0.6, cr * 0.42, 42, G.leaf) +
      foliage(canopyDefs, bx + cr * 0.84, cy0 + cr * 0.22, cr * 0.56, cr * 0.4, 43, G.leaf);
  }
  if (stageNumber >= 8) {
    canopyG += foliage(canopyDefs, bx - cr * 0.26, cy0 - cr * 0.48, cr * 0.54, cr * 0.38, 44, G.leaf) +
      foliage(canopyDefs, bx + cr * 0.36, cy0 - cr * 0.42, cr * 0.5, cr * 0.36, 45, G.leaf);
  }
  if (stageNumber >= 9) {
    const rnd = mulberry32(7);
    for (let i = 0; i < 10; i++) {
      const a = -Math.PI * 0.95 + rnd() * Math.PI * 0.9, rr = cr * (0.4 + rnd() * 0.5);
      const fx = bx + rr * Math.cos(a), fy = cy0 + rr * Math.sin(a) * 0.68;
      canopyG += `<circle cx="${fx.toFixed(0)}" cy="${fy.toFixed(0)}" r="${(7 + rnd() * 6).toFixed(0)}" fill="${GOLD}"/><circle cx="${(fx - 2).toFixed(0)}" cy="${(fy - 2).toFixed(0)}" r="2.4" fill="#FBF0D0"/>`;
    }
  }
  if (stageNumber >= 10) {
    const rnd = mulberry32(13);
    for (let i = 0; i < 12; i++) {
      const a = rnd() * Math.PI * 2, rr = cr * (0.55 + rnd() * 0.5);
      canopyG += `<circle cx="${(bx + rr * Math.cos(a)).toFixed(0)}" cy="${(cy0 + rr * Math.sin(a) * 0.7).toFixed(0)}" r="${(4 + rnd() * 4).toFixed(0)}" fill="${CREAM}" opacity="0.9"/>`;
    }
    canopyG += sparkle(bx - cr * 0.9, cy0 - cr * 0.75, 14) + sparkle(bx + cr * 0.85, cy0 - cr * 0.4, 11, CREAM);
  }
  return {
    trunk: svgDoc(region, trunkG, trunkDefs),
    canopy: svgDoc(region, canopyG, canopyDefs),
  };
}

/* ============================ PLANT PAINTERS ============================ */

function trunkPathD(x, gy, h, w, lean = 0) {
  return `M ${x - w * 0.55} ${gy}
    C ${x - w * 0.42 + lean * 0.3} ${gy - h * 0.5} ${x - w * 0.3 + lean * 0.8} ${gy - h * 0.82} ${x - w * 0.16 + lean} ${gy - h}
    L ${x + w * 0.16 + lean} ${gy - h}
    C ${x + w * 0.28 + lean * 0.8} ${gy - h * 0.78} ${x + w * 0.4 + lean * 0.3} ${gy - h * 0.48} ${x + w * 0.55} ${gy} Z`;
}

const OLIVE_LEAF = ['#57684E', '#71835F', '#93A47A', '#B8C49A'];

function paintPlant(name, variant, tod = 'day') {
  const G = GROUNDS[tod];
  const defs = [];
  const rough = roughFilter(defs);
  let g = '';
  const region = {
    olive: ELEMENTS.olive.rect, palm: ELEMENTS.datePalm.rect, fig: ELEMENTS.fig.rect,
    pomegranate: ELEMENTS.pomegranate.rect, vine: ELEMENTS.grapeVine.rect,
    gourd: ELEMENTS.gourd.rect, sidr: ELEMENTS.loteTree.rect, rayhan: ELEMENTS.rayhan.rect,
  }[name];
  const base = {
    olive: ELEMENTS.olive.base, palm: ELEMENTS.datePalm.base, fig: ELEMENTS.fig.base,
    pomegranate: ELEMENTS.pomegranate.base, vine: ELEMENTS.grapeVine.base,
    gourd: ELEMENTS.gourd.base, sidr: ELEMENTS.loteTree.base, rayhan: ELEMENTS.rayhan.base,
  }[name];
  const [bx, by] = base;
  const trunkFill = lgV(defs, [[0, G.trunkLit], [1, G.trunk]], 0, 0, 1, 0);
  switch (name) {
    case 'olive': {
      const s = [0.6, 0.82, 1.04][variant - 1];
      g += shadowEl(defs, bx + 14, by + 4, 74 * s, 12, 0.2);
      g += `<g filter="url(#${rough})"><path d="${trunkPathD(bx, by, 92 * s, 13 * s, 4)}" fill="${trunkFill}"/></g>`;
      g += foliage(defs, bx - 2, by - 128 * s, 68 * s, 50 * s, 51, OLIVE_LEAF);
      if (variant >= 2) {
        const rnd = mulberry32(21);
        for (let i = 0; i < (variant === 3 ? 10 : 5); i++) {
          const a = rnd() * Math.PI * 2, r = 58 * s * (0.35 + rnd() * 0.55);
          g += `<circle cx="${(bx + r * Math.cos(a)).toFixed(0)}" cy="${(by - 128 * s + r * Math.sin(a) * 0.75).toFixed(0)}" r="4" fill="#D9E0C2" opacity="0.95"/>`;
        }
      }
      break;
    }
    case 'palm': {
      const s = [0.5, 0.72, 0.95][variant - 1];
      const tipX = bx + 30 * s, tipY = by - 320 * s;
      g += shadowEl(defs, bx + 40 * s, by + 4, 70 * s, 11, 0.2);
      let rings = '';
      for (let i = 0; i < 6; i++) {
        rings += `<path d="M ${bx + 4 * s + i * 3.4 * s} ${by - i * 52 * s} q ${12 * s} ${-6 * s} ${22 * s} 0" stroke="${G.trunk}" stroke-width="${2.5 * s}" opacity="0.4" fill="none"/>`;
      }
      g += `<g filter="url(#${rough})"><path d="M ${bx} ${by} q ${8 * s} ${-180 * s} ${30 * s} ${-320 * s} l ${26 * s} 2 q ${-16 * s} ${150 * s} ${-8 * s} ${318 * s} Z" fill="${trunkFill}"/>${rings}</g>`;
      let fronds = '';
      [[-1, -0.42], [-0.78, -0.9], [-0.2, -1.12], [0.42, -1.02], [0.95, -0.6], [1.15, -0.1]].forEach(([dx, dy], i) => {
        const c1 = i % 2 ? G.leaf[1] : G.leaf[2];
        fronds += `<path d="M ${tipX} ${tipY} q ${dx * 140 * s} ${dy * 115 * s} ${dx * 245 * s} ${dy * 92 * s} q ${-dx * 95 * s} ${-dy * 8 * s + 36 * s} ${-dx * 232 * s} ${-dy * 76 * s + 10 * s} Z" fill="${c1}"/>`;
        fronds += `<path d="M ${tipX} ${tipY} q ${dx * 120 * s} ${dy * 100 * s} ${dx * 225 * s} ${dy * 88 * s}" stroke="${G.leaf[0]}" stroke-width="${3 * s}" fill="none" opacity="0.55"/>`;
      });
      if (variant === 3) {
        fronds += `<circle cx="${tipX - 16 * s}" cy="${tipY + 38 * s}" r="${12 * s}" fill="${GOLD}"/><circle cx="${tipX + 4 * s}" cy="${tipY + 48 * s}" r="${12 * s}" fill="${DEEPGOLD}"/><circle cx="${tipX + 24 * s}" cy="${tipY + 36 * s}" r="${10 * s}" fill="${GOLD}"/><circle cx="${tipX - 6 * s}" cy="${tipY + 34 * s}" r="3" fill="#FBF0D0"/>`;
      }
      g += fronds;
      break;
    }
    case 'fig': {
      const s = [0.55, 0.76, 0.96][variant - 1];
      g += shadowEl(defs, bx + 8, by + 4, 60 * s, 10, 0.18);
      g += `<g filter="url(#${rough})"><path d="M ${bx} ${by} C ${bx - 2} ${by - 42 * s} ${bx + 2} ${by - 60 * s} ${bx} ${by - 80 * s}" stroke="${G.trunk}" stroke-width="${9 * s}" fill="none" stroke-linecap="round"/></g>`;
      g += foliage(defs, bx, by - 118 * s, 54 * s, 42 * s, 61, G.leaf);
      if (variant === 3) {
        g += `<circle cx="${bx - 26 * s}" cy="${by - 100 * s}" r="${8 * s}" fill="#8A5A4A"/><circle cx="${bx + 32 * s}" cy="${by - 112 * s}" r="${8 * s}" fill="#8A5A4A"/><circle cx="${bx - 24 * s}" cy="${by - 102 * s}" r="2.4" fill="#D8B090"/>`;
      }
      break;
    }
    case 'pomegranate': {
      const s = [0.55, 0.78, 1][variant - 1];
      g += shadowEl(defs, bx, by + 4, 58 * s, 10, 0.18);
      g += `<g filter="url(#${rough})"><path d="M ${bx} ${by} C ${bx - 3} ${by - 36 * s} ${bx + 2} ${by - 50 * s} ${bx} ${by - 64 * s}" stroke="${G.trunk}" stroke-width="${8 * s}" fill="none" stroke-linecap="round"/></g>`;
      g += foliage(defs, bx, by - 104 * s, 50 * s, 40 * s, 71, G.leaf);
      const n = variant === 1 ? 0 : variant === 2 ? 3 : 6;
      const rnd = mulberry32(31);
      for (let i = 0; i < n; i++) {
        const a = rnd() * Math.PI * 2, r = 46 * s * (0.3 + rnd() * 0.55);
        const ox = bx + r * Math.cos(a), oy = by - 102 * s + r * Math.sin(a) * 0.7;
        g += `<circle cx="${ox.toFixed(0)}" cy="${oy.toFixed(0)}" r="${8 * s}" fill="#A45C42"/><circle cx="${(ox - 2).toFixed(0)}" cy="${(oy - 2).toFixed(0)}" r="2.2" fill="#E0A882"/>`;
      }
      break;
    }
    case 'vine': {
      const s = [0.6, 0.8, 1][variant - 1];
      g += shadowEl(defs, bx, by + 4, 66 * s, 10, 0.18);
      g += `<g filter="url(#${rough})">
        <rect x="${bx - 62 * s}" y="${by - 118 * s}" width="${7 * s}" height="${118 * s}" rx="3" fill="${G.trunk}"/>
        <rect x="${bx + 56 * s}" y="${by - 118 * s}" width="${7 * s}" height="${118 * s}" rx="3" fill="${G.trunk}"/>
        <rect x="${bx - 70 * s}" y="${by - 124 * s}" width="${140 * s}" height="${8 * s}" rx="4" fill="${G.trunkLit}"/></g>`;
      g += foliage(defs, bx - 30 * s, by - 116 * s, 34 * s, 22 * s, 81, G.leaf);
      g += foliage(defs, bx + 28 * s, by - 112 * s, 32 * s, 20 * s, 82, G.leaf);
      const cluster = (cx, cy, cs) => {
        let c = '';
        for (let i = 0; i < 8; i++) {
          c += `<circle cx="${(cx + ((i % 3) - 1) * 8.5 * cs).toFixed(0)}" cy="${(cy + Math.floor(i / 3) * 8 * cs).toFixed(0)}" r="${(5.2 * cs).toFixed(1)}" fill="${i % 2 ? '#7A5A78' : '#5C4360'}"/>`;
        }
        return c + `<circle cx="${(cx - 4 * cs).toFixed(0)}" cy="${(cy - 2 * cs).toFixed(0)}" r="2" fill="#C8A8C0" opacity="0.9"/>`;
      };
      if (variant >= 2) g += cluster(bx - 38 * s, by - 80 * s, s);
      if (variant === 3) g += cluster(bx + 36 * s, by - 92 * s, s) + cluster(bx - 2 * s, by - 64 * s, s * 0.9);
      break;
    }
    case 'gourd': {
      const s = [0.6, 0.8, 1][variant - 1];
      const gourdShape = (gx, gy, gs, c) =>
        `<ellipse cx="${gx}" cy="${gy}" rx="${16 * gs}" ry="${12 * gs}" fill="${c}"/><ellipse cx="${gx - 4 * gs}" cy="${gy - 4 * gs}" rx="${5 * gs}" ry="${3.5 * gs}" fill="#FBF0D0" opacity="0.7"/><path d="M ${gx} ${gy - 12 * gs} q 2 -6 8 -8" stroke="${G.leaf[1]}" stroke-width="2.4" fill="none"/>`;
      g += `<g filter="url(#${rough})"><path d="M ${bx - 76 * s} ${by} C ${bx - 34 * s} ${by - 28 * s} ${bx + 30 * s} ${by - 4 * s} ${bx + 76 * s} ${by - 24 * s}" stroke="${G.leaf[1]}" stroke-width="${5 * s}" fill="none"/>
        ${foliage(defs, bx - 34 * s, by - 20 * s, 16 * s, 11 * s, 91, G.leaf, false)}${foliage(defs, bx + 16 * s, by - 12 * s, 14 * s, 10 * s, 92, G.leaf, false)}</g>`;
      g += gourdShape(bx - 8 * s, by - 13 * s, s, '#D8C48E');
      if (variant >= 2) g += gourdShape(bx + 46 * s, by - 10 * s, s * 0.85, GOLD);
      if (variant === 3) g += gourdShape(bx - 56 * s, by - 8 * s, s * 0.8, '#D8C48E');
      break;
    }
    case 'sidr': {
      const s = variant === 1 ? 0.6 : 0.78;
      g += glow2(defs, bx, by - 160 * s, variant === 2 ? 180 * s : 140 * s, CREAM, variant === 2 ? 0.5 : 0.3);
      g += shadowEl(defs, bx, by + 4, 60 * s, 10, 0.16);
      g += `<g filter="url(#${rough})"><path d="${trunkPathD(bx, by, 118 * s, 12 * s)}" fill="${trunkFill}"/></g>`;
      g += foliage(defs, bx, by - 165 * s, 72 * s, 54 * s, 55, OLIVE_LEAF);
      const rnd = mulberry32(53);
      for (let i = 0; i < (variant === 2 ? 12 : 6); i++) {
        const a = rnd() * Math.PI * 2, rr = 80 * s * (0.4 + rnd() * 0.6);
        g += `<circle cx="${(bx + rr * Math.cos(a)).toFixed(0)}" cy="${(by - 158 * s + rr * Math.sin(a) * 0.7).toFixed(0)}" r="${(4 + rnd() * 3.5).toFixed(1)}" fill="${rnd() > 0.5 ? CREAM : GOLD}"/>`;
      }
      if (variant === 2) g += sparkle(bx - 64 * s, by - 240 * s, 12, CREAM);
      break;
    }
    case 'rayhan': {
      const s = [0.6, 0.8, 1][variant - 1];
      const tuft = (tx, n, seed) => {
        let t = '';
        const rnd = mulberry32(seed);
        for (let i = 0; i < n; i++) {
          const dx = (i - (n - 1) / 2) * 10 * s + (rnd() - 0.5) * 4;
          t += `<path d="M ${(tx + dx).toFixed(1)} ${by} q ${(dx * 0.5).toFixed(1)} ${-32 * s} ${(dx * 0.2).toFixed(1)} ${-50 * s}" stroke="${G.leaf[2]}" stroke-width="${4.4 * s}" fill="none" stroke-linecap="round"/>`;
          if (variant >= 2) t += `<circle cx="${(tx + dx * 1.2).toFixed(0)}" cy="${(by - 52 * s).toFixed(0)}" r="${3.4 * s}" fill="#C8A8C0" opacity="0.92"/>`;
        }
        return t;
      };
      let tufts = tuft(bx, 5, 1);
      if (variant >= 2) tufts += tuft(bx - 70 * s, 4, 2);
      if (variant === 3) tufts += tuft(bx + 72 * s, 4, 3) + sparkle(bx + 34 * s, by - 68 * s, 7, GOLD, 0.8);
      g += `<g filter="url(#${rough})">${tufts}</g>`;
      break;
    }
  }
  return { svg: svgDoc(region, g, defs), region };
}

const PLANT_VARIANTS = {
  olive: 3, palm: 3, fig: 3, pomegranate: 3, vine: 3, gourd: 3, sidr: 2, rayhan: 3,
};

/* =========================== FILE MANIFEST ============================== */

function buildLayerFiles() {
  const files = {}; // name -> {svg, region}
  for (const ambKey of Object.keys(SKIES)) {
    for (const tod of ['day', 'night']) {
      files[`garden_sky_${ambKey}_${tod}.webp`] = { svg: paintSky(ambKey, tod), region: FULL };
    }
  }
  for (const tod of ['day', 'night']) {
    files[`garden_ground_${tod}.webp`] = { svg: paintGround(tod), region: REGIONS.ground };
  }
  for (let tier = 1; tier <= 5; tier++) {
    const name = `garden_water_e${String(tier).padStart(2, '0')}`;
    files[`${name}.webp`] = { svg: paintWater(tier, 'day'), region: REGIONS.water };
    files[`${name}_night.webp`] = { svg: paintWater(tier, 'night'), region: REGIONS.water };
  }
  for (let stage = 1; stage <= 10; stage++) {
    const s = String(stage).padStart(2, '0');
    const parts = treeParts(stage, 'day');
    if (parts.single) {
      files[`garden_tree_s${s}.webp`] = { svg: parts.single, region: ELEMENTS.centralTree.rect };
    } else {
      files[`garden_tree_s${s}_trunk.webp`] = { svg: parts.trunk, region: ELEMENTS.centralTree.rect };
      files[`garden_tree_s${s}_canopy.webp`] = { svg: parts.canopy, region: ELEMENTS.centralTree.rect };
    }
  }
  for (const [plant, variants] of Object.entries(PLANT_VARIANTS)) {
    for (let variant = 1; variant <= variants; variant++) {
      const painted = paintPlant(plant, variant);
      files[`garden_plant_${plant}_v${variant}.webp`] = { svg: painted.svg, region: painted.region };
    }
  }
  return files;
}

/* ============================ DART EMISSION ============================= */

function rectConst(r) {
  return `GardenLayerRect(${r[0]}, ${r[1]}, ${r[2]}, ${r[3]})`;
}

function emitDart(availableFiles) {
  const placements = Object.entries(ELEMENTS)
    .map(([eid, e]) =>
      `    '${eid}': GardenLayerPlacement(\n` +
      `      z: ${e.z},\n` +
      `      rect: ${rectConst(e.rect)},\n` +
      `      baseX: ${e.base[0]},\n` +
      `      baseY: ${e.base[1]},\n` +
      `    ),`)
    .join('\n');
  const centerline = MOTION.streamCenterline.map((p) => `[${p[0]}, ${p[1]}]`).join(', ');
  const bees = MOTION.beeAnchors.map((p) => `[${p[0]}, ${p[1]}]`).join(', ');
  const files = availableFiles.map((f) => `    '${f}',`).join('\n');
  const dart = `// GENERATED by tooling/art_src/garden_art/generate_garden_art.mjs — do not edit.
// Regenerate with: node tooling/art_src/garden_art/generate_garden_art.mjs
//
// The vista's design space is ${CANVAS.w}x${CANVAS.h}; every coordinate below
// lives in that space. Positions exist ONLY in the generator's LAYOUT — the
// app must read them from here and never hardcode a coordinate in a widget.

class GardenLayerRect {
  const GardenLayerRect(this.x, this.y, this.w, this.h);

  final double x;
  final double y;
  final double w;
  final double h;
}

class GardenLayerPlacement {
  const GardenLayerPlacement({
    required this.z,
    required this.rect,
    required this.baseX,
    required this.baseY,
  });

  final int z;
  final GardenLayerRect rect;
  final double baseX;
  final double baseY;
}

abstract final class GardenSceneLayout {
  static const double canvasWidth = ${CANVAS.w};
  static const double canvasHeight = ${CANVAS.h};
  static const double horizonY = ${CANVAS.horizonY};

  static const GardenLayerRect heroCrop = ${rectConst([CROPS.hero.x, CROPS.hero.y, CROPS.hero.w, CROPS.hero.h])};
  static const GardenLayerRect homeCardCrop = ${rectConst([CROPS.homeCard.x, CROPS.homeCard.y, CROPS.homeCard.w, CROPS.homeCard.h])};
  static const GardenLayerRect groundRect = ${rectConst(REGIONS.ground)};
  static const GardenLayerRect waterRect = ${rectConst(REGIONS.water)};

  static const Map<String, GardenLayerPlacement> elementPlacements = {
${placements}
  };

  static const List<List<double>> streamCenterline = [${centerline}];
  static const GardenLayerRect fireflyRegion = ${rectConst(MOTION.fireflyRegion)};
  static const List<List<double>> beeAnchors = [${bees}];
  static const List<double> fishAnchor = [${MOTION.fishAnchor[0]}, ${MOTION.fishAnchor[1]}];
  static const List<double> beehiveAnchor = [${MOTION.beehiveAnchor[0]}, ${MOTION.beehiveAnchor[1]}];
  static const double birdBandTop = ${MOTION.birdBand[0]};
  static const double birdBandBottom = ${MOTION.birdBand[1]};

  /// WebP layers that exist under assets/images/garden_art/. The asset
  /// resolver walks variants/stages downward through this set and falls back
  /// to the placeholder painter when nothing is available.
  static const Set<String> availableGardenArtFiles = <String>{
${files}
  };
}
`;
  mkdirSync(dirname(DART_OUT), { recursive: true });
  writeFileSync(DART_OUT, dart);
  console.log('wrote', DART_OUT);
}

/* ============================== PIPELINE ================================ */

function hasTool(tool) {
  try {
    execFileSync('which', [tool], { stdio: 'ignore' });
    return true;
  } catch {
    return false;
  }
}

function renderWebp(name, svg, region) {
  const svgPath = join(SVG_OUT, name.replace('.webp', '.svg'));
  writeFileSync(svgPath, svg);
  const w = Math.round(region[2] * EXPORT_SCALE);
  const h = Math.round(region[3] * EXPORT_SCALE);
  const pngPath = svgPath.replace('.svg', '.png');
  execFileSync('rsvg-convert', ['-w', String(w), '-h', String(h), svgPath, '-o', pngPath]);
  execFileSync('cwebp', ['-quiet', '-q', '78', '-alpha_q', '90', pngPath, '-o', join(WEBP_OUT, name)]);
}

/* Composed full-scene preview for visual QA (reused by the P7 milestone
   scenes). Stacks the layer SVG contents in z order inside one document. */
function composeScene({ ambKey = 'morning', tod = 'day', tier = 3, stage = 5, plants = {} }) {
  const inner = (svg) => svg.replace(/^<svg[^>]*>/, '').replace(/<\/svg>$/, '');
  let g = inner(paintSky(ambKey, tod));
  g += inner(paintGround(tod));
  g += inner(paintWater(tier, tod));
  const zOf = { sidr: 30, palm: 32, olive: 34, fig: 36, pomegranate: 44, vine: 46, gourd: 48, rayhan: 50 };
  const back = Object.entries(plants).filter(([n]) => zOf[n] < 40).sort((a, b) => zOf[a[0]] - zOf[b[0]]);
  const front = Object.entries(plants).filter(([n]) => zOf[n] > 40).sort((a, b) => zOf[a[0]] - zOf[b[0]]);
  for (const [plant, variant] of back) g += inner(paintPlant(plant, variant, tod).svg);
  const parts = treeParts(stage, tod);
  if (parts.single) g += inner(parts.single);
  else g += inner(parts.trunk) + inner(parts.canopy);
  for (const [plant, variant] of front) g += inner(paintPlant(plant, variant, tod).svg);
  return `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 ${CANVAS.w} ${CANVAS.h}">${g}</svg>`;
}

/* ================================= MAIN ================================= */

mkdirSync(SVG_OUT, { recursive: true });
mkdirSync(WEBP_OUT, { recursive: true });

const args = process.argv.slice(2);
const layoutOnly = args.includes('--layout-only');
const preview = args.includes('--preview');

const layerFiles = buildLayerFiles();
const names = Object.keys(layerFiles).sort();

if (layoutOnly || !hasTool('rsvg-convert') || !hasTool('cwebp')) {
  if (!layoutOnly) console.warn('rsvg-convert/cwebp not found — emitting layout + SVGs only.');
  for (const name of names) writeFileSync(join(SVG_OUT, name.replace('.webp', '.svg')), layerFiles[name].svg);
  emitDart(existsSync(WEBP_OUT) ? names.filter((n) => existsSync(join(WEBP_OUT, n))) : []);
} else {
  for (const name of names) renderWebp(name, layerFiles[name].svg, layerFiles[name].region);
  emitDart(names);
  console.log(`rendered ${names.length} layers into ${WEBP_OUT}`);
}

if (preview) {
  const allPlants = { olive: 3, palm: 3, fig: 3, pomegranate: 3, vine: 3, gourd: 3, sidr: 2, rayhan: 3 };
  const scenes = [
    ['preview_day_t3_s5', { ambKey: 'morning', tod: 'day', tier: 3, stage: 5, plants: { olive: 1, fig: 1, rayhan: 2, gourd: 1 } }],
    ['preview_day_t5_s10', { ambKey: 'warm', tod: 'day', tier: 5, stage: 10, plants: allPlants }],
    ['preview_night_t5_s10', { ambKey: 'evening', tod: 'night', tier: 5, stage: 10, plants: allPlants }],
    ['preview_dawn_t1_s1', { ambKey: 'dawn', tod: 'day', tier: 1, stage: 1 }],
  ];
  for (const [name, cfg] of scenes) {
    const svgPath = join(SVG_OUT, `${name}.svg`);
    writeFileSync(svgPath, composeScene(cfg));
    if (hasTool('rsvg-convert')) {
      execFileSync('rsvg-convert', ['-w', '1000', '-h', '600', svgPath, '-o', join(SVG_OUT, `${name}.png`)]);
    }
  }
  console.log('previews written to svg/preview_*.png');
}
