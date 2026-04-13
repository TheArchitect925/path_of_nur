import 'package:flutter/widgets.dart';

import '../domain/prophet_entry.dart';

const Map<String, String> _prophetImageById = <String, String>{
  'adam': 'assets/images/prophets/1. AdamAS.webp',
  'idris': 'assets/images/prophets/2. IdrisAS.webp',
  'nuh': 'assets/images/prophets/3. NuhAS.webp',
  'hud': 'assets/images/prophets/4. HudAS.webp',
  'salih': 'assets/images/prophets/5. SalihAS.webp',
  'ibrahim': 'assets/images/prophets/6. IbrahimAS.webp',
  'lut': 'assets/images/prophets/7.webp',
  'ismail': 'assets/images/prophets/8. IsmailAS.webp',
  'ishaq': 'assets/images/prophets/9. IshaqAS.webp',
  'yaqub': 'assets/images/prophets/10. YaqubAS.webp',
  'yusuf': 'assets/images/prophets/11. YusufAS.webp',
  'shuayb': 'assets/images/prophets/12. ShuaybAS.webp',
  'ayyub': 'assets/images/prophets/13. AyyubAS.webp',
  'dhul_kifl': 'assets/images/prophets/14. DhulKifrAS.webp',
  'musa': 'assets/images/prophets/16.webp',
  'harun': 'assets/images/prophets/15. MusaAS.webp',
  'dawud': 'assets/images/prophets/17.webp',
  'sulayman': 'assets/images/prophets/18.webp',
  'ilyas': 'assets/images/prophets/19.webp',
  'alyasa': 'assets/images/prophets/20.webp',
  'yunus': 'assets/images/prophets/21.webp',
  'zakariya': 'assets/images/prophets/22.webp',
  'yahya': 'assets/images/prophets/23.webp',
  'isa': 'assets/images/prophets/24.webp',
  'muhammad': 'assets/images/prophets/25.webp',
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
  'musa': Alignment(0, 0.28),
  'harun': Alignment(0, 0.20),
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
  return _prophetImageAlignmentById[prophet.id] ??
      const Alignment(0, 0.12);
}
