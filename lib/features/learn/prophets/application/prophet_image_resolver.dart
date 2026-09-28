import 'package:flutter/widgets.dart';

import '../domain/prophet_entry.dart';

const Map<String, String> _prophetImageById = <String, String>{
  'adam': 'assets/images/prophets/prophet_01_adam.webp',
  'idris': 'assets/images/prophets/prophet_02_idris.webp',
  'nuh': 'assets/images/prophets/prophet_03_nuh.webp',
  'hud': 'assets/images/prophets/prophet_04_hud.webp',
  'salih': 'assets/images/prophets/prophet_05_salih.webp',
  'ibrahim': 'assets/images/prophets/prophet_06_ibrahim.webp',
  'lut': 'assets/images/prophets/prophet_07_lut.webp',
  'ismail': 'assets/images/prophets/prophet_08_ismail.webp',
  'ishaq': 'assets/images/prophets/prophet_09_ishaq.webp',
  'yaqub': 'assets/images/prophets/prophet_10_yaqub.webp',
  'yusuf': 'assets/images/prophets/prophet_11_yusuf.webp',
  'shuayb': 'assets/images/prophets/prophet_12_shuayb.webp',
  'ayyub': 'assets/images/prophets/prophet_13_ayyub.webp',
  'dhul_kifl': 'assets/images/prophets/prophet_14_dhul_kifl.webp',
  'musa': 'assets/images/prophets/prophet_15_musa.webp',
  'harun': 'assets/images/prophets/prophet_16_harun.webp',
  'dawud': 'assets/images/prophets/prophet_17_dawud.webp',
  'sulayman': 'assets/images/prophets/prophet_18_sulayman.webp',
  'ilyas': 'assets/images/prophets/prophet_19_ilyas.webp',
  'alyasa': 'assets/images/prophets/prophet_20_alyasa.webp',
  'yunus': 'assets/images/prophets/prophet_21_yunus.webp',
  'zakariya': 'assets/images/prophets/prophet_22_zakariya.webp',
  'yahya': 'assets/images/prophets/prophet_23_yahya.webp',
  'isa': 'assets/images/prophets/prophet_24_isa.webp',
  'muhammad': 'assets/images/prophets/prophet_25_muhammad.webp',
};

const Map<String, Alignment> _prophetImageAlignmentById = <String, Alignment>{
  'adam': Alignment(0, 0.08),
  'idris': Alignment(0, 0.22),
  'hud': Alignment(0, 0.22),
  'salih': Alignment(0, 0.22),
  'ibrahim': Alignment(0, 0.14),
  'lut': Alignment(0, 0.18),
  'ismail': Alignment(0, 0.14),
  'yaqub': Alignment(0, 0.22),
  'yusuf': Alignment(0, 0.72),
  'shuayb': Alignment(0, 0.22),
  'ayyub': Alignment(0, 0.22),
  // musa/harun crops were tuned before the image swap fix; values follow the
  // artwork, so they swap with it.
  'musa': Alignment(0, 0.20),
  'harun': Alignment(0, 0.28),
  'dawud': Alignment(0, 0.28),
  'sulayman': Alignment(0, 0.18),
  'ilyas': Alignment(0, 0.22),
  'alyasa': Alignment(0, 0.18),
  'yunus': Alignment(0, 0.18),
  'zakariya': Alignment(0, 0.22),
  'yahya': Alignment(0, 0.18),
  'isa': Alignment(0, 0.16),
  'muhammad': Alignment(0, 0.24),
};

String? resolveProphetImageAsset(ProphetEntry prophet) {
  if (prophet.heroAsset != null && prophet.heroAsset!.isNotEmpty) {
    return prophet.heroAsset;
  }
  return _prophetImageById[prophet.id];
}

Alignment resolveProphetImageAlignment(ProphetEntry prophet) {
  return _prophetImageAlignmentById[prophet.id] ?? const Alignment(0, 0.12);
}
