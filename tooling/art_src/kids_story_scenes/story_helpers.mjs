// Path of Nur — extra silhouettes for the story scenes (K3).
//
// Everything the twenty older stories need that the picture-book kit does
// not already draw: caves and fire, reeds and a basket, the parted sea, a
// sling, scales, thrones, ants and a hoopoe, a cradle, a mihrab, and the
// small things of an adab story (a spilled cup, grocery bags, a kitten,
// shoes at a door, a cup of soil). Same rules as the kit: silhouettes, no
// faces, no text, and prophets are never drawn.
import {
  IVORY, CREAM, GOLD, DEEPGOLD, INK, INK_SOFT, WOOD, WOOD_DARK, WOOD_LIGHT,
  SEA, SEA_DEEP, SEA_LIGHT, SEA_FOAM, GREEN, GREEN_DEEP, LEAF, LEAF_LIGHT,
  SAND, SAND_DARK, SAND_LIGHT, STONE, STONE_DARK, STONE_LIGHT, WALL, WALL_DEEP,
  LINE, SKIN, f, mulberry32, glow, sheep, bird, sparkle, W, H,
} from './scene_kit.mjs';

// ---------------------------------------------------------------- land --
export function cave(cx, baseY, s, rock = STONE_DARK, inner = '#0E0F16', light = null) {
  let out = `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -420 0 Q -400 -240 -160 -330 Q 0 -400 180 -320 Q 420 -230 430 0 Z" fill="${rock}"/>` +
    `<path d="M -150 0 Q -150 -190 0 -200 Q 150 -190 150 0 Z" fill="${inner}"/>`;
  if (light) out += `<path d="M -110 0 Q -110 -150 0 -160 Q 110 -150 110 0 Z" fill="${light}" opacity="0.55"/>`;
  return out + `</g>`;
}

export function flames(cx, baseY, s, colors = ['#E8B36A', '#D9A05B', '#B0743B']) {
  const tongue = (dx, h, w, c, op = 1) =>
    `<path d="M ${dx - w} 0 Q ${dx - w * 0.9} ${-h * 0.45} ${dx} ${-h} Q ${dx + w * 0.9} ${-h * 0.45} ${dx + w} 0 Z" fill="${c}" opacity="${op}"/>`;
  return glow(cx, baseY - 80 * s, 260 * s, '#E8B36A', 0.5) +
    `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    tongue(-60, 150, 50, colors[2]) + tongue(70, 180, 56, colors[2]) + tongue(0, 260, 80, colors[1]) +
    tongue(-20, 180, 44, colors[0]) + tongue(30, 130, 36, CREAM, 0.85) + `</g>`;
}

/// A ring of flame around a patch of cool green: the fire that was told to be
/// cool and safe.
export function fireRing(cx, cy, rx, ry) {
  let out = `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="#B0743B"/>`;
  for (let i = 0; i < 26; i++) {
    const a = (i / 26) * Math.PI * 2;
    const x = cx + Math.cos(a) * rx, y = cy + Math.sin(a) * ry;
    const h = 90 + 60 * ((i * 7) % 5) / 4, w = 34;
    out += `<path d="M ${f(x - w)} ${f(y)} Q ${f(x - w * 0.8)} ${f(y - h * 0.5)} ${f(x)} ${f(y - h)} Q ${f(x + w * 0.8)} ${f(y - h * 0.5)} ${f(x + w)} ${f(y)} Z" fill="${i % 3 ? '#D9A05B' : '#E8B36A'}"/>`;
  }
  out += `<ellipse cx="${cx}" cy="${cy}" rx="${rx * 0.7}" ry="${ry * 0.7}" fill="${LEAF}"/>` +
    `<ellipse cx="${cx}" cy="${cy}" rx="${rx * 0.52}" ry="${ry * 0.52}" fill="${LEAF_LIGHT}" opacity="0.7"/>`;
  return out;
}

export function reeds(seed, x0, x1, gy, n, color = GREEN_DEEP) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), h = 160 + rnd() * 200, lean = (rnd() - 0.5) * 60;
    out += `<path d="M ${f(x)} ${gy} Q ${f(x + lean * 0.4)} ${f(gy - h * 0.6)} ${f(x + lean)} ${f(gy - h)}" stroke="${color}" stroke-width="9" fill="none" stroke-linecap="round"/>` +
      `<ellipse cx="${f(x + lean)}" cy="${f(gy - h)}" rx="9" ry="26" fill="${WOOD}"/>`;
  }
  return out;
}

export function river(yTop, c1 = SEA_LIGHT, c2 = SEA, foam = SEA_FOAM) {
  return `<path d="M0 ${yTop} Q ${W * 0.25} ${yTop - 30} ${W * 0.5} ${yTop} T ${W} ${yTop} V ${H} H 0 Z" fill="${c1}"/>` +
    `<path d="M0 ${yTop + 120} Q ${W * 0.3} ${yTop + 90} ${W * 0.55} ${yTop + 120} T ${W} ${yTop + 110} V ${H} H 0 Z" fill="${c2}"/>` +
    `<path d="M ${W * 0.1} ${yTop + 60} q 80 -14 160 0 M ${W * 0.55} ${yTop + 40} q 90 -14 180 0 M ${W * 0.3} ${yTop + 170} q 70 -12 140 0" stroke="${foam}" stroke-width="6" fill="none" opacity="0.5" stroke-linecap="round"/>`;
}

export function basket(cx, cy, s, weave = WOOD_LIGHT, dark = WOOD) {
  return `<g transform="translate(${cx} ${cy}) scale(${s})">` +
    `<path d="M -120 -20 Q -110 70 0 76 Q 110 70 120 -20 Z" fill="${weave}"/>` +
    `<path d="M -104 0 Q -96 56 0 60 Q 96 56 104 0" stroke="${dark}" stroke-width="6" fill="none" opacity="0.6"/>` +
    `<path d="M -112 20 Q -100 64 0 68 Q 100 64 112 20" stroke="${dark}" stroke-width="6" fill="none" opacity="0.5"/>` +
    `<ellipse cx="0" cy="-20" rx="120" ry="30" fill="${dark}"/>` +
    `<path d="M -90 -24 Q 0 -70 90 -24 Q 0 6 -90 -24 Z" fill="${IVORY}"/>` +
    `<path d="M -50 -34 Q 0 -60 50 -34" stroke="#4A5D8A" stroke-width="10" fill="none" stroke-linecap="round" opacity="0.7"/></g>`;
}

/// Two standing walls of water with a dry path between them.
export function seaWalls(gapX0, gapX1, yTop, colors = [SEA_LIGHT, SEA, SEA_DEEP]) {
  const wall = (x0, x1, dir) => {
    const ridge = dir > 0 ? x1 : x0;
    return `<path d="M ${x0} ${yTop} Q ${(x0 + x1) / 2} ${yTop - 60} ${x1} ${yTop} V ${H} H ${x0} Z" fill="${colors[1]}"/>` +
      `<path d="M ${x0} ${yTop + 40} Q ${(x0 + x1) / 2} ${yTop - 10} ${x1} ${yTop + 40} V ${H} H ${x0} Z" fill="${colors[2]}" opacity="0.7"/>` +
      `<path d="M ${ridge} ${yTop} q ${-30 * dir} 120 0 260 q ${30 * dir} 140 0 300 q ${-24 * dir} 150 0 300" stroke="${SEA_FOAM}" stroke-width="18" fill="none" opacity="0.8"/>` +
      `<path d="M ${ridge - 60 * dir} ${yTop + 20} q ${-16 * dir} 130 0 290 q ${18 * dir} 160 0 320" stroke="${colors[0]}" stroke-width="10" fill="none" opacity="0.6"/>`;
  };
  return wall(0, gapX0, 1) + wall(gapX1, W, -1) +
    `<path d="M ${gapX0} ${yTop + 200} Q ${(gapX0 + gapX1) / 2} ${yTop + 180} ${gapX1} ${yTop + 200} V ${H} H ${gapX0} Z" fill="${SAND}"/>` +
    `<path d="M ${gapX0 + 30} ${H} Q ${(gapX0 + gapX1) / 2} ${yTop + 400} ${gapX1 - 30} ${H} Z" fill="${SAND_LIGHT}" opacity="0.5"/>`;
}

export function footprints(seed, x0, y0, x1, y1, n, color = SAND_DARK) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const t = i / (n - 1), x = x0 + (x1 - x0) * t, y = y0 + (y1 - y0) * t;
    const side = i % 2 ? 1 : -1, s = 0.5 + t * 0.9;
    out += `<ellipse cx="${f(x + side * 18 * s)}" cy="${f(y)}" rx="${f(9 * s)}" ry="${f(15 * s)}" fill="${color}" opacity="${f(0.45 + rnd() * 0.3)}"/>`;
  }
  return out;
}

export function windStreaks(seed, n, x0, x1, y0, y1, color = IVORY, op = 0.35) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), y = y0 + rnd() * (y1 - y0), len = 120 + rnd() * 260;
    out += `<path d="M ${f(x)} ${f(y)} q ${f(len * 0.3)} -22 ${f(len * 0.6)} 0 t ${f(len * 0.4)} 0" stroke="${color}" stroke-width="7" fill="none" stroke-linecap="round" opacity="${op}"/>`;
  }
  return out;
}

export function spiderWeb(cx, cy, r, color = IVORY, op = 0.7) {
  let out = '';
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * Math.PI * 2;
    out += `<line x1="${cx}" y1="${cy}" x2="${f(cx + Math.cos(a) * r)}" y2="${f(cy + Math.sin(a) * r)}" stroke="${color}" stroke-width="3" opacity="${op}"/>`;
  }
  for (let k = 1; k <= 4; k++) {
    const rr = (r * k) / 4;
    let d = '';
    for (let i = 0; i <= 8; i++) {
      const a = (i / 8) * Math.PI * 2, a2 = ((i + 0.5) / 8) * Math.PI * 2;
      const x = cx + Math.cos(a) * rr, y = cy + Math.sin(a) * rr;
      d += (i ? ` Q ${f(cx + Math.cos(a2) * rr * 0.86)} ${f(cy + Math.sin(a2) * rr * 0.86)} ${f(x)} ${f(y)}` : `M ${f(x)} ${f(y)}`);
    }
    out += `<path d="${d}" stroke="${color}" stroke-width="3" fill="none" opacity="${op}"/>`;
  }
  return out;
}

export const nest = (cx, cy, s = 1) =>
  `<g transform="translate(${cx} ${cy}) scale(${s})"><path d="M -70 0 Q -60 40 0 44 Q 60 40 70 0 Z" fill="${WOOD_LIGHT}"/>` +
  `<path d="M -64 4 q 30 20 64 22 q 34 -2 64 -22" stroke="${WOOD_DARK}" stroke-width="5" fill="none" opacity="0.6"/>` +
  `<ellipse cx="-18" cy="-6" rx="16" ry="12" fill="${CREAM}"/><ellipse cx="18" cy="-6" rx="16" ry="12" fill="${CREAM}"/></g>`;

// -------------------------------------------------------------- things --
export function statueFallen(x, gy, s, color = STONE_DARK) {
  return `<g transform="translate(${x} ${gy}) scale(${s})">` +
    `<rect x="-140" y="-70" width="240" height="70" rx="18" fill="${color}"/>` +
    `<circle cx="140" cy="-46" r="44" fill="${color}"/>` +
    `<rect x="-40" y="-110" width="26" height="60" rx="10" fill="${color}" transform="rotate(30 -40 -110)"/>` +
    `<rect x="-200" y="-40" width="50" height="40" rx="8" fill="${color}" opacity="0.8"/></g>`;
}

export const hammerOnShoulder = (x, y, s) =>
  `<g transform="translate(${x} ${y}) scale(${s}) rotate(-25)"><rect x="-8" y="-150" width="16" height="170" rx="6" fill="${WOOD}"/><rect x="-46" y="-186" width="92" height="52" rx="10" fill="${STONE_DARK}"/></g>`;

export function ram(x, gy, s, flip = false) {
  const horn = (sx) =>
    `<path d="M ${sx * 30} -118 q ${sx * 40} -30 ${sx * 34} 20 q -8 30 ${sx * -26} 14" stroke="${DEEPGOLD}" stroke-width="12" fill="none" stroke-linecap="round"/>`;
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<ellipse cx="0" cy="-70" rx="96" ry="60" fill="${IVORY}"/>` +
    `<rect x="-60" y="-40" width="18" height="44" rx="6" fill="${INK_SOFT}"/><rect x="-20" y="-40" width="18" height="44" rx="6" fill="${INK_SOFT}"/>` +
    `<rect x="20" y="-40" width="18" height="44" rx="6" fill="${INK_SOFT}"/><rect x="56" y="-40" width="18" height="44" rx="6" fill="${INK_SOFT}"/>` +
    `<ellipse cx="96" cy="-104" rx="34" ry="26" fill="${INK_SOFT}"/><rect x="86" y="-124" width="14" height="24" rx="6" fill="${INK_SOFT}"/>` +
    `<g transform="translate(66 0)">${horn(1)}</g></g>`;
}

export const sling = (x, y, s, a = -20) =>
  `<g transform="translate(${x} ${y}) rotate(${a}) scale(${s})"><path d="M -120 40 Q -60 -30 0 0 Q 60 30 120 -40" stroke="${WOOD_DARK}" stroke-width="10" fill="none" stroke-linecap="round"/>` +
  `<ellipse cx="0" cy="4" rx="44" ry="26" fill="${WOOD}"/><circle cx="0" cy="0" r="16" fill="${STONE_LIGHT}"/></g>`;

export function pebbles(seed, n, x0, x1, gy, color = STONE_LIGHT) {
  const rnd = mulberry32(seed);
  let out = '';
  for (let i = 0; i < n; i++) {
    const x = x0 + rnd() * (x1 - x0), r = 12 + rnd() * 14;
    out += `<ellipse cx="${f(x)}" cy="${f(gy - r * 0.5)}" rx="${f(r)}" ry="${f(r * 0.7)}" fill="${color}"/>`;
  }
  return out;
}

export const stoneArc = (x0, y0, x1, y1, color = STONE_LIGHT) =>
  `<path d="M ${x0} ${y0} Q ${(x0 + x1) / 2} ${Math.min(y0, y1) - 260} ${x1} ${y1}" stroke="${color}" stroke-width="6" stroke-dasharray="18 26" fill="none" opacity="0.7" stroke-linecap="round"/>` +
  `<circle cx="${x1}" cy="${y1}" r="18" fill="${color}"/>`;

export function scales(cx, baseY, s, metal = GOLD, dark = DEEPGOLD) {
  const pan = (dx, dy) =>
    `<line x1="${dx}" y1="-260" x2="${dx}" y2="${-160 + dy}" stroke="${dark}" stroke-width="5"/>` +
    `<path d="M ${dx - 90} ${-160 + dy} Q ${dx} ${-110 + dy} ${dx + 90} ${-160 + dy} Z" fill="${metal}"/>`;
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<rect x="-14" y="-300" width="28" height="300" rx="8" fill="${dark}"/><rect x="-120" y="-20" width="240" height="20" rx="8" fill="${dark}"/>` +
    `<rect x="-220" y="-272" width="440" height="16" rx="8" fill="${metal}"/>` +
    pan(-200, 0) + pan(200, 0) + `<circle cx="0" cy="-300" r="22" fill="${metal}"/></g>`;
}

export function throne(cx, baseY, s, color = WOOD, trim = GOLD) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<rect x="-150" y="-380" width="300" height="300" rx="40" fill="${color}"/>` +
    `<path d="M -150 -380 Q 0 -470 150 -380 Z" fill="${color}"/>` +
    `<rect x="-150" y="-380" width="300" height="300" rx="40" fill="none" stroke="${trim}" stroke-width="10"/>` +
    `<rect x="-190" y="-200" width="60" height="140" rx="16" fill="${color}" stroke="${trim}" stroke-width="8"/>` +
    `<rect x="130" y="-200" width="60" height="140" rx="16" fill="${color}" stroke="${trim}" stroke-width="8"/>` +
    `<rect x="-130" y="-120" width="260" height="60" rx="18" fill="#8A4A6A"/>` +
    `<rect x="-120" y="-60" width="30" height="60" rx="8" fill="${trim}"/><rect x="90" y="-60" width="30" height="60" rx="8" fill="${trim}"/>` +
    sparkle(0, -420, 22, trim) + `</g>`;
}

export const carpet = (cx, cy, w, h, color = '#8A4A28', edge = GOLD) =>
  `<path d="M ${cx - w / 2} ${cy} q ${w * 0.25} -40 ${w * 0.5} 0 t ${w * 0.5} 0 v ${h} q ${-w * 0.25} 40 ${-w * 0.5} 0 t ${-w * 0.5} 0 Z" fill="${color}"/>` +
  `<path d="M ${cx - w / 2} ${cy} q ${w * 0.25} -40 ${w * 0.5} 0 t ${w * 0.5} 0 v ${h} q ${-w * 0.25} 40 ${-w * 0.5} 0 t ${-w * 0.5} 0 Z" fill="none" stroke="${edge}" stroke-width="8"/>`;

export function ant(x, y, s, color = INK, flip = false) {
  return `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})">` +
    `<ellipse cx="-30" cy="0" rx="26" ry="16" fill="${color}"/><ellipse cx="4" cy="-4" rx="16" ry="12" fill="${color}"/><circle cx="30" cy="-8" r="13" fill="${color}"/>` +
    `<path d="M -10 6 l -18 26 M 4 8 l -4 28 M 16 6 l 18 24 M -20 -8 l -22 -20 M 12 -12 l 12 -26 M 36 -18 l 14 -18 M 40 -14 l 20 -8" stroke="${color}" stroke-width="4" fill="none" stroke-linecap="round"/></g>`;
}

export const antHole = (cx, gy, s = 1) =>
  `<g transform="translate(${cx} ${gy}) scale(${s})"><path d="M -110 0 Q -80 -60 0 -70 Q 80 -60 110 0 Z" fill="${SAND_DARK}"/><ellipse cx="0" cy="-16" rx="40" ry="18" fill="${INK}"/></g>`;

export function hoopoe(x, y, s, flip = false) {
  const body = '#D9A05B', dark = INK;
  return `<g transform="translate(${x} ${y}) scale(${flip ? -s : s} ${s})">` +
    `<ellipse cx="0" cy="0" rx="60" ry="30" fill="${body}"/>` +
    `<path d="M -40 -6 l -70 -30 l 10 40 Z" fill="${dark}"/><path d="M -10 -10 q 30 -40 70 -20 q -30 30 -70 20 Z" fill="${dark}"/>` +
    `<path d="M -4 -12 q 24 -30 50 -14 q -24 16 -50 14 Z" fill="${IVORY}" opacity="0.7"/>` +
    `<circle cx="66" cy="-18" r="20" fill="${body}"/><path d="M 84 -16 l 40 6 l -40 6 Z" fill="${dark}"/>` +
    `<path d="M 60 -36 l -6 -30 M 68 -38 l 2 -34 M 76 -36 l 10 -30 M 52 -32 l -14 -24" stroke="${body}" stroke-width="7" stroke-linecap="round"/>` +
    `<circle cx="54" cy="-66" r="6" fill="${dark}"/><circle cx="70" cy="-72" r="6" fill="${dark}"/><circle cx="86" cy="-66" r="6" fill="${dark}"/></g>`;
}

export const scroll = (x, y, s) =>
  `<g transform="translate(${x} ${y}) scale(${s})"><rect x="-40" y="-26" width="80" height="52" rx="8" fill="${CREAM}"/><rect x="-46" y="-30" width="12" height="60" rx="6" fill="${WOOD}"/><rect x="34" y="-30" width="12" height="60" rx="6" fill="${WOOD}"/><path d="M -24 -8 h 48 M -24 6 h 34" stroke="${DEEPGOLD}" stroke-width="4" stroke-linecap="round" opacity="0.6"/></g>`;

export function sunSymbol(cx, cy, r, color = GOLD) {
  let out = `<circle cx="${cx}" cy="${cy}" r="${r}" fill="${color}"/>`;
  for (let i = 0; i < 8; i++) {
    const a = (i / 8) * Math.PI * 2;
    out += `<path d="M ${f(cx + Math.cos(a) * r * 1.2)} ${f(cy + Math.sin(a) * r * 1.2)} L ${f(cx + Math.cos(a) * r * 1.9)} ${f(cy + Math.sin(a) * r * 1.9)}" stroke="${color}" stroke-width="${f(r * 0.22)}" stroke-linecap="round"/>`;
  }
  return out;
}

export function palace(cx, baseY, s, color = WALL_DEEP, lit = null) {
  const win = (x, y) => lit ? `<path d="M ${x - 16} ${y} v -30 q 16 -24 32 0 v 30 Z" fill="${lit}" opacity="0.9"/>` : '';
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<rect x="-420" y="-260" width="840" height="260" fill="${color}"/>` +
    `<rect x="-470" y="-360" width="140" height="360" fill="${color}"/><rect x="330" y="-360" width="140" height="360" fill="${color}"/>` +
    `<path d="M -470 -360 h 140 l -18 -40 h -104 Z M 330 -360 h 140 l -18 -40 h -104 Z" fill="${color}"/>` +
    `<path d="M -200 -260 v -80 q 200 -140 400 0 v 80 Z" fill="${color}"/>` +
    `<path d="M -70 0 v -150 q 70 -80 140 0 v 150 Z" fill="${INK}" opacity="0.5"/>` +
    win(-300, -120) + win(-200, -120) + win(200, -120) + win(300, -120) + win(-400, -220) + win(400, -220) + `</g>`;
}

export function cradle(cx, baseY, s, wood = WOOD_LIGHT, cloth = IVORY) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -160 -120 Q -170 0 0 10 Q 170 0 160 -120 Z" fill="${wood}"/>` +
    `<path d="M -180 0 Q 0 60 180 0" stroke="${wood}" stroke-width="14" fill="none" stroke-linecap="round"/>` +
    `<path d="M -170 -140 h 340 v 26 h -340 Z" fill="${WOOD}"/>` +
    `<path d="M -130 -124 Q 0 -170 130 -124 Q 0 -80 -130 -124 Z" fill="${cloth}"/>` +
    `<path d="M -80 -134 Q 0 -160 80 -134" stroke="#4A5D8A" stroke-width="10" fill="none" stroke-linecap="round" opacity="0.6"/>` +
    `<path d="M 130 -140 q 40 -140 -20 -230" stroke="${wood}" stroke-width="10" fill="none" stroke-linecap="round"/>` +
    `<path d="M 100 -370 q 40 -20 40 20 q -10 30 -50 20" fill="${cloth}" opacity="0.8"/></g>`;
}

export function mihrab(cx, baseY, s, wall = WALL, inner = '#8A5A36', light = CREAM) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -260 0 v -420 q 260 -260 520 0 v 420 Z" fill="${DEEPGOLD}"/>` +
    `<path d="M -220 0 v -400 q 220 -220 440 0 v 400 Z" fill="${inner}"/>` +
    `<path d="M -170 0 v -360 q 170 -190 340 0 v 360 Z" fill="${light}" opacity="0.32"/>` +
    `<path d="M -220 -400 q 220 -220 440 0" stroke="${GOLD}" stroke-width="10" fill="none"/></g>`;
}

export function datePalmCluster(x, y, s) {
  let out = '';
  for (let i = 0; i < 9; i++) {
    const a = -0.4 + (i % 3) * 0.4, r = 26 + Math.floor(i / 3) * 22;
    out += `<ellipse cx="${f(x + Math.sin(a) * r)}" cy="${f(y + Math.cos(a) * r)}" rx="${f(9 * s)}" ry="${f(15 * s)}" fill="#6E3A1E"/>`;
  }
  return out;
}

export const stream = (yTop, color = SEA_LIGHT, deep = SEA) =>
  `<path d="M 0 ${yTop + 80} Q 300 ${yTop} 600 ${yTop + 60} T 1200 ${yTop + 40} T 1700 ${yTop + 60} V ${yTop + 220} Q 1300 ${yTop + 180} 900 ${yTop + 240} T 300 ${yTop + 230} T 0 ${yTop + 220} Z" fill="${color}"/>` +
  `<path d="M 0 ${yTop + 130} Q 300 ${yTop + 70} 600 ${yTop + 120} T 1200 ${yTop + 100} T 1700 ${yTop + 120} V ${yTop + 200} Q 1300 ${yTop + 160} 900 ${yTop + 210} T 300 ${yTop + 200} T 0 ${yTop + 190} Z" fill="${deep}" opacity="0.55"/>`;

// ----------------------------------------------------------- home life --
export function house(cx, baseY, s, color = WALL, lit = null, roof = WALL_DEEP) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<rect x="-240" y="-300" width="480" height="300" fill="${color}"/>` +
    `<rect x="-260" y="-320" width="520" height="30" rx="8" fill="${roof}"/>` +
    `<path d="M -60 0 v -150 q 60 -70 120 0 v 150 Z" fill="${WOOD_DARK}"/>` +
    `<path d="M -190 -130 v -70 q 40 -50 80 0 v 70 Z" fill="${lit ?? INK}" opacity="${lit ? 0.95 : 0.55}"/>` +
    `<path d="M 110 -130 v -70 q 40 -50 80 0 v 70 Z" fill="${lit ?? INK}" opacity="${lit ? 0.95 : 0.55}"/></g>`;
}

export function doorway(cx, baseY, s, wall = WALL, door = WOOD_DARK, open = false) {
  return `<g transform="translate(${cx} ${baseY}) scale(${s})">` +
    `<path d="M -190 0 v -440 q 190 -180 380 0 v 440 Z" fill="${wall}"/>` +
    `<path d="M -150 0 v -410 q 150 -150 300 0 v 410 Z" fill="${door}"/>` +
    (open ? `<path d="M -150 0 v -410 q 150 -150 300 0 v 410 Z" fill="${CREAM}" opacity="0.35"/>` : '') +
    `<path d="M -150 0 v -410 q 150 -150 300 0 v 410" stroke="${DEEPGOLD}" stroke-width="10" fill="none"/>` +
    `<circle cx="100" cy="-190" r="12" fill="${GOLD}"/></g>`;
}

export const bag = (x, gy, s, color = SAND_LIGHT) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -70 0 v -170 h 140 v 170 Z" fill="${color}"/><path d="M -36 -170 q 36 -60 72 0" stroke="${WOOD}" stroke-width="10" fill="none"/><rect x="-70" y="-170" width="140" height="22" fill="${WOOD_LIGHT}" opacity="0.6"/></g>`;

export const fruit = (x, y, s, color = '#B8683C', leaf = LEAF) =>
  `<circle cx="${x}" cy="${y}" r="${18 * s}" fill="${color}"/><path d="M ${x} ${y - 18 * s} q 10 -18 22 -12" stroke="${leaf}" stroke-width="${5 * s}" fill="none" stroke-linecap="round"/>`;

export function cup(x, baseY, s, color = '#4A5D8A', tipped = false) {
  const a = tipped ? -70 : 0;
  return `<g transform="translate(${x} ${baseY}) rotate(${a}) scale(${s})"><path d="M -40 -120 L -30 0 H 30 L 40 -120 Z" fill="${color}"/><ellipse cx="0" cy="-120" rx="40" ry="12" fill="${IVORY}" opacity="0.9"/><path d="M 40 -100 q 40 10 30 50 q -6 22 -34 24" stroke="${color}" stroke-width="12" fill="none"/></g>`;
}

export const puddle = (cx, cy, rx, ry, color = SEA_LIGHT) =>
  `<path d="M ${cx - rx} ${cy} q ${rx * 0.3} ${-ry} ${rx * 0.8} ${-ry * 0.6} q ${rx * 0.6} ${-ry * 0.3} ${rx * 1.2} ${ry * 0.4} q ${-rx * 0.4} ${ry * 0.9} ${-rx * 1.1} ${ry * 0.8} q ${-rx * 0.9} ${-ry * 0.1} ${-rx * 0.9} ${-ry * 0.6} Z" fill="${color}" opacity="0.7"/>`;

export function kitten(x, gy, s, color = '#8A7F70', tailUp = false, flip = false) {
  const tail = tailUp ? 'M 60 -40 q 50 -30 40 -110' : 'M 60 -30 q 60 10 90 -10';
  return `<g transform="translate(${x} ${gy}) scale(${flip ? -s : s} ${s})">` +
    `<ellipse cx="0" cy="-50" rx="70" ry="46" fill="${color}"/>` +
    `<circle cx="-64" cy="-90" r="36" fill="${color}"/>` +
    `<path d="M -92 -110 l -6 -34 l 28 18 Z M -36 -110 l 6 -34 l -28 18 Z" fill="${color}"/>` +
    `<rect x="-50" y="-30" width="18" height="30" rx="8" fill="${color}"/><rect x="20" y="-30" width="18" height="30" rx="8" fill="${color}"/>` +
    `<path d="${tail}" stroke="${color}" stroke-width="16" fill="none" stroke-linecap="round"/></g>`;
}

export const bowl = (cx, baseY, s, filled = false) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -80 -50 Q -70 0 0 0 Q 70 0 80 -50 Z" fill="#8A4A28"/><ellipse cx="0" cy="-50" rx="80" ry="18" fill="${filled ? SEA_LIGHT : '#6E3A1E'}"/></g>`;

export const shoes = (x, gy, s, color = INK_SOFT) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><path d="M -100 0 q 0 -40 40 -40 h 40 q 30 0 40 30 v 10 Z" fill="${color}"/><path d="M 10 0 q 0 -40 40 -40 h 40 q 30 0 40 30 v 10 Z" fill="${color}"/></g>`;

export const quranStand = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -110 0 L 0 -140 L 110 0 Z" fill="${WOOD}"/><path d="M -120 -150 L 0 -60 L 120 -150 L 0 -240 Z" fill="${IVORY}"/><path d="M -112 -150 L 0 -66 L 112 -150" stroke="${GOLD}" stroke-width="6" fill="none"/><path d="M -70 -160 l 62 46 M 70 -160 l -62 46" stroke="${DEEPGOLD}" stroke-width="4" opacity="0.5"/></g>`;

export function tray(cx, baseY, s) {
  let out = `<g transform="translate(${cx} ${baseY}) scale(${s})"><ellipse cx="0" cy="0" rx="260" ry="60" fill="${DEEPGOLD}"/><ellipse cx="0" cy="-10" rx="240" ry="50" fill="${GOLD}"/>`;
  for (let i = 0; i < 3; i++) out += `<g transform="translate(${-150 + i * 150} -30)"><ellipse cx="0" cy="0" rx="60" ry="20" fill="${IVORY}"/><ellipse cx="-16" cy="-12" rx="14" ry="9" fill="#6E3A1E"/><ellipse cx="14" cy="-14" rx="14" ry="9" fill="#6E3A1E"/><ellipse cx="0" cy="-22" rx="14" ry="9" fill="#6E3A1E"/></g>`;
  return out + `</g>`;
}

export const plateOfDates = (cx, baseY, s, n = 2) => {
  let out = `<g transform="translate(${cx} ${baseY}) scale(${s})"><ellipse cx="0" cy="0" rx="120" ry="34" fill="${IVORY}"/><ellipse cx="0" cy="-4" rx="100" ry="24" fill="${CREAM}"/>`;
  for (let i = 0; i < n; i++) out += `<ellipse cx="${-30 + i * 60}" cy="-16" rx="26" ry="14" fill="#6E3A1E"/>`;
  return out + `</g>`;
};

export const lunchbox = (cx, baseY, s, color = '#4E8A6C') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><rect x="-140" y="-110" width="280" height="110" rx="18" fill="${color}"/><rect x="-140" y="-130" width="280" height="30" rx="12" fill="${LEAF_LIGHT}"/><rect x="-40" y="-150" width="80" height="30" rx="12" fill="${LEAF_LIGHT}"/></g>`;

export const bench = (cx, baseY, s, color = WOOD) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><rect x="-360" y="-150" width="720" height="40" rx="12" fill="${color}"/><rect x="-320" y="-110" width="30" height="110" fill="${WOOD_DARK}"/><rect x="290" y="-110" width="30" height="110" fill="${WOOD_DARK}"/></g>`;

export const chair = (cx, baseY, s, color = WOOD) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><rect x="-90" y="-320" width="180" height="200" rx="20" fill="${color}"/><rect x="-100" y="-150" width="200" height="30" rx="10" fill="${color}"/><rect x="-90" y="-120" width="22" height="120" fill="${WOOD_DARK}"/><rect x="68" y="-120" width="22" height="120" fill="${WOOD_DARK}"/></g>`;

export const windowSill = (cx, cy, w, h, skyFill, frame = WOOD_DARK) =>
  `<rect x="${cx - w / 2}" y="${cy - h / 2}" width="${w}" height="${h}" fill="${skyFill}"/>` +
  `<rect x="${cx - w / 2}" y="${cy - h / 2}" width="${w}" height="${h}" fill="none" stroke="${frame}" stroke-width="22"/>` +
  `<line x1="${cx}" y1="${cy - h / 2}" x2="${cx}" y2="${cy + h / 2}" stroke="${frame}" stroke-width="14"/>` +
  `<line x1="${cx - w / 2}" y1="${cy}" x2="${cx + w / 2}" y2="${cy}" stroke="${frame}" stroke-width="14"/>` +
  `<rect x="${cx - w / 2 - 40}" y="${cy + h / 2}" width="${w + 80}" height="30" rx="8" fill="${frame}"/>`;

export const hangingClothes = (x, y, s, colors = ['#4E8A6C', '#8A4A6A']) =>
  `<g transform="translate(${x} ${y}) scale(${s})"><line x1="-260" y1="0" x2="260" y2="0" stroke="${WOOD_DARK}" stroke-width="10"/>` +
  colors.map((c, i) => `<g transform="translate(${-120 + i * 240} 0)"><path d="M -80 30 q 0 -30 80 -30 q 80 0 80 30 v 220 h -160 Z" fill="${c}"/><path d="M -30 0 q 30 -30 60 0" stroke="${WOOD_DARK}" stroke-width="6" fill="none"/></g>`).join('') + `</g>`;

export const sweets = (cx, baseY, s) =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><ellipse cx="0" cy="0" rx="150" ry="36" fill="${IVORY}"/>` +
  [-90, -40, 10, 60].map((x, i) => `<rect x="${x}" y="-46" width="44" height="36" rx="8" fill="${i % 2 ? GOLD : '#B8683C'}"/>`).join('') +
  `<ellipse cx="-60" cy="-62" rx="18" ry="12" fill="#6E3A1E"/><ellipse cx="60" cy="-62" rx="18" ry="12" fill="#6E3A1E"/></g>`;

export const soilCup = (cx, baseY, s, sprout = 0, color = '#B8683C') =>
  `<g transform="translate(${cx} ${baseY}) scale(${s})"><path d="M -70 -160 L -56 0 H 56 L 70 -160 Z" fill="${color}"/><ellipse cx="0" cy="-160" rx="70" ry="18" fill="#5A3A22"/>` +
  (sprout > 0 ? `<path d="M 0 -160 q -6 -60 4 -${100 * sprout + 60}" stroke="${LEAF}" stroke-width="10" fill="none" stroke-linecap="round"/><ellipse cx="-22" cy="${-190 - 60 * sprout}" rx="26" ry="14" fill="${LEAF_LIGHT}" transform="rotate(-30 -22 ${-190 - 60 * sprout})"/><ellipse cx="26" cy="${-200 - 70 * sprout}" rx="26" ry="14" fill="${LEAF}" transform="rotate(30 26 ${-200 - 70 * sprout})"/>` : '') +
  `</g>`;

export function blocks(cx, gy, s, fallen = false) {
  const colors = ['#4E8A6C', '#8A4A6A', GOLD, '#4A5D8A', '#B8683C'];
  let out = `<g transform="translate(${cx} ${gy}) scale(${s})">`;
  if (fallen) {
    const spots = [[-220, 0, 12], [-90, 0, -8], [40, 0, 24], [170, 0, -18], [-30, -80, 40]];
    spots.forEach(([x, y, a], i) => { out += `<rect x="${x - 50}" y="${y - 100}" width="100" height="100" rx="12" fill="${colors[i]}" transform="rotate(${a} ${x} ${y - 50})"/>`; });
  } else {
    colors.forEach((c, i) => { out += `<rect x="-50" y="${-100 * (i + 1)}" width="100" height="100" rx="12" fill="${c}"/>`; });
    out += `<rect x="-60" y="-600" width="120" height="40" rx="12" fill="${DEEPGOLD}"/>`;
  }
  return out + `</g>`;
}

export const shelfBooks = (x, y, s) =>
  `<g transform="translate(${x} ${y}) scale(${s})"><rect x="-180" y="0" width="360" height="16" rx="6" fill="${WOOD_DARK}"/>` +
  ['#4E8A6C', GOLD, '#8A4A6A', '#4A5D8A', '#B8683C'].map((c, i) => `<rect x="${-160 + i * 64}" y="${-120 - (i % 2) * 20}" width="52" height="${120 + (i % 2) * 20}" rx="6" fill="${c}"/>`).join('') + `</g>`;

export const groundShadow = (cx, cy, rx, ry, op = 0.18) =>
  `<ellipse cx="${cx}" cy="${cy}" rx="${rx}" ry="${ry}" fill="#000" opacity="${op}"/>`;

export const idolStatue = (x, gy, s, color = STONE_DARK) =>
  `<g transform="translate(${x} ${gy}) scale(${s})"><rect x="-70" y="-40" width="140" height="40" rx="8" fill="${color}"/><rect x="-44" y="-260" width="88" height="220" rx="24" fill="${color}"/><circle cx="0" cy="-300" r="44" fill="${color}"/><rect x="-90" y="-230" width="180" height="26" rx="12" fill="${color}"/></g>`;

export const unused = { sheep, bird, SKIN, LINE, STONE, GREEN, SEA_LIGHT, SAND, WALL_DEEP, WOOD_LIGHT, GREEN_DEEP };
