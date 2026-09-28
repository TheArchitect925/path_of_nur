import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// `AppColors` holds the *light* theme's literal values. Reading them in a
/// widget pins it to the cream palette, so it stops following Midnight,
/// Candlelight, Jumu'ah, Ramadan, Laylat al-Qadr and Eid — the symptom being
/// dark-brown caption text on dark glass. Widgets must go through
/// `context.palette` instead.
void main() {
  /// The only files allowed to read the raw constants.
  const allowed = <String>{
    // Defines them.
    'lib/core/theme/app_colors.dart',
    // Exposes the theme-resolved palette; falls back to the constants when
    // the appearance extension is absent.
    'lib/core/theme/app_palette.dart',
    // Documented `appearance?.x ?? AppColors.y` fallbacks.
    'lib/core/theme/app_surfaces.dart',
    // Restored after an accidental staged deletion while a parallel
    // refactor replaces it; the refactor deletes this file again and this
    // entry goes with it.
    'lib/features/worship/presentation/widgets/dhikr_section.dart',
    // Uses the constants as category hue seeds, then blends them against the
    // live theme's surface/onSurface.
    'lib/features/learn/dua/presentation/dua_category_theme.dart',
    // A static definition of the reader's *light* atmosphere, where every
    // other value is a literal too.
    'lib/features/learn/quran/presentation/quran_reader_atmosphere.dart',
  };

  test('widgets read colours through context.palette, not AppColors', () {
    final offenders = <String>[];
    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final path = entity.path;
      if (allowed.contains(path)) continue;
      final source = entity.readAsStringSync();
      if (RegExp(r'\bAppColors\.').hasMatch(source)) {
        offenders.add(path);
      }
    }

    expect(
      offenders..sort(),
      isEmpty,
      reason:
          'These files read the light-theme constants directly and will not '
          'follow the night or occasion themes. Use context.palette.<token> '
          '(lib/core/theme/app_palette.dart). If a file genuinely defines a '
          'fixed palette, add it to the allow-list in this test with a note '
          'saying why.',
    );
  });
}
