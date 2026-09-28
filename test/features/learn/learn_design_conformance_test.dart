import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Phase L0 of the Learn redesign: a ratchet, not a cleanup.
///
/// The calm-navigation redesign reshaped Home, the hubs and the Learn
/// *landing*; the 155 pages one tap deeper kept the pre-redesign grammar. The
/// phases that fix them (L1 shells, L3 puzzle chrome, L4 segmented hubs, L5
/// the tail) land over many sessions, so each check below carries an explicit
/// allow-list of today's known offenders.
///
/// The allow-list is checked in *both* directions:
///  * a file that drifts and is not listed fails the test — no new drift;
///  * a listed file that no longer drifts also fails — the list must shrink as
///    each phase lands, so it can never quietly rot into a permanent exemption.
///
/// Colour is not policed here. `test/core/theme/app_palette_policy_test.dart`
/// already enforces `context.palette` over the frozen `AppColors` constants.
void main() {
  test('Learn pages build on the app scaffold, not a bare Scaffold', () {
    // A bare `Scaffold` renders no `GlobalBackground`, so the page loses the
    // living sky and glass surfaces the rest of the app has.
    const allowed = <String>{
      // Deliberately immersive: paints its own theme-aware
      // `QuranReaderAtmosphereBackground` and follows the app themes through
      // `resolveQuranReaderAtmosphere`. Belongs to the reader family, which
      // Phase 7b rebuilds.
      'lib/features/learn/quran/presentation/quran_focus_recitation_page.dart',
    };

    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])Scaffold\('),
      allowed: allowed,
      reason:
          'These build a bare Material Scaffold, so they render with no app '
          'background at all. Use AppPageScaffold (or LearnHubPageScaffold), '
          'and LearnContainedStatePage for a not-found or empty guard branch.',
    );
  });

  test('Learn pages do not raise a Material AppBar', () {
    // The product has no Material app bars; every page carries the
    // AppPageScaffold header instead.
    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])(Sliver)?AppBar\('),
      allowed: const <String>{},
      reason:
          'AppBar exists nowhere else in the product. Move the title into the '
          'scaffold title/subtitle and any action into headerActions.',
    );
  });

  test('Learn does not navigate with in-page segmented tab strips', () {
    // Decision 2 of the redesign was "one list, one search": destinations go
    // into HubListGroup rows, not behind a strip you have to re-find.
    //
    // A SegmentedPillControl is not drift by itself. It is the right widget
    // for a required one-of-N *control* — a sort order, a search scope, a
    // learning mode — where clearing the selection is not a valid state and a
    // FilterChipRow (which clears on re-tap) would be wrong. The list below is
    // split accordingly: every entry below is reviewed and kept.
    // Phase L4 unpacked the strips that were really navigation.
    const allowed = <String>{
      // --- Required one-of-N controls. Reviewed and kept. ---
      // Sort order over one lesson list.
      'lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart',
      // Search scope.
      'lib/features/learn/hadith/presentation/hadith_search_page.dart',
      // Search type and field scope.
      'lib/features/learn/quran/presentation/quran_search_page.dart',
      // Sort order over the surah list.
      'lib/features/learn/quran/presentation/quran_surah_explorer_page.dart',
      // Chooses which control panel is expanded — a required one-of-N.
      'lib/features/learn/hadith/presentation/widgets/hadith_browse_helpers.dart',
      // Stories / timeline / map — three views of the same prophets.
      'lib/features/learn/prophets/presentation/prophets_page.dart',
      // Listen / practice / memory over the same surah — a mode, not a place.
      'lib/features/learn/salah/presentation/salah_surah_detail_page.dart',
    };

    _expectNoDrift(
      pattern: RegExp('SegmentedPillControl'),
      allowed: allowed,
      reason:
          'Group destinations with HubListGroup + CompactListTile. If the '
          'strip is an optional filter over one collection, use FilterChipRow. '
          'A required one-of-N control may keep the segmented control — add it '
          'to the reviewed group in this test with a note saying why.',
    );
  });

  test('Learn draws determinate progress with the display kit ProgressBar', () {
    // ProgressBar takes a required value, so it cannot express indeterminate
    // progress. The files below show a busy bar while something loads, which
    // is the one thing a bare LinearProgressIndicator is still right for.
    const allowed = <String>{
      'lib/features/learn/quran/presentation/quran_reader_page.dart',
      'lib/features/learn/quran/presentation/quran_word_detail_page.dart',
      'lib/features/learn/quran/presentation/quran_words_page.dart',
    };

    _expectNoDrift(
      pattern: RegExp('LinearProgressIndicator'),
      allowed: allowed,
      reason:
          'Use ProgressBar from lib/shared/widgets/display/progress_bar.dart '
          'so height, radius and track colour match the rest of the app. It '
          'clips itself, so it does not need a ClipRRect around it.',
    );
  });

  test('Learn builds rows with the display kit CompactListTile', () {
    // A raw ListTile inside a PremiumCard brings its own padding, density and
    // chevron, so rows drift from the grouped lists used everywhere else.
    // Emptied by Phase L5.
    const allowed = <String>{
      'lib/features/learn/companion_surfaces/presentation/character_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/seerah_companion_page.dart',
      'lib/features/learn/content/presentation/learn_notes_landing_page.dart',
      'lib/features/learn/content/presentation/learn_topic_landing_page.dart',
      'lib/features/learn/divine_life_lessons/presentation/divine_life_lesson_detail_page.dart',
      'lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart',
      'lib/features/learn/hadith/presentation/hadith_landing_page.dart',
      'lib/features/learn/hadith/presentation/hadith_learning_path_page.dart',
      'lib/features/learn/hadith/presentation/widgets/hadith_browse_helpers.dart',
      'lib/features/learn/journey/presentation/learning_journey_home_page.dart',
      'lib/features/learn/life/baby_names/presentation/baby_names_browse_page.dart',
      'lib/features/learn/life/baby_names/presentation/baby_names_favorites_page.dart',
      'lib/features/learn/life/baby_names/presentation/baby_names_home_page.dart',
      'lib/features/learn/life/presentation/life_lesson_page.dart',
      'lib/features/learn/life/presentation/life_subcategory_page.dart',
      'lib/features/learn/life/presentation/life_theme_page.dart',
      'lib/features/learn/presentation/pages/learn_salah_hub_page.dart',
      'lib/features/learn/prophets/presentation/prophets_page.dart',
      'lib/features/learn/quran/presentation/quran_ayah_insights_browse_page.dart',
      'lib/features/learn/quran/presentation/quran_ayah_insights_paths_page.dart',
      'lib/features/learn/quran/presentation/quran_daily_companion_page.dart',
      'lib/features/learn/quran/presentation/quran_focus_recitation_page.dart',
      'lib/features/learn/quran/presentation/quran_reader/reader_search_sheet.dart',
      'lib/features/learn/quran/presentation/quran_reader_page.dart',
      'lib/features/learn/quran/presentation/quran_search_page.dart',
      'lib/features/learn/quran/presentation/quran_surah_insight_page.dart',
      'lib/features/learn/quran/presentation/widgets/quran_compact_search_results_section.dart',
      'lib/features/learn/quran/presentation/widgets/quran_learning_personalization_section.dart',
      'lib/features/learn/quran/presentation/widgets/quran_reference_viewer.dart',
      'lib/features/learn/quran_universe/presentation/quran_universe_page.dart',
      'lib/features/learn/world/presentation/pages/world_creation_lesson_page.dart',
      'lib/features/learn/world/presentation/pages/world_signs_explorer_page.dart',
      'lib/features/learn/world/presentation/world_lesson_page.dart',
      'lib/features/learn/world/presentation/world_subcategory_page.dart',
      'lib/features/learn/world/presentation/world_theme_page.dart',
    };

    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])ListTile\('),
      allowed: allowed,
      reason:
          'Use CompactListTile from '
          'lib/shared/widgets/display/compact_list_tile.dart, grouped under '
          'HubListGroup where the rows are destinations.',
    );
  });
}

/// Scans `lib/features/learn` for [pattern] and asserts the offending files
/// are exactly [allowed] — no new drift, and no stale exemptions.
void _expectNoDrift({
  required RegExp pattern,
  required Set<String> allowed,
  required String reason,
}) {
  final offenders = <String>{};
  for (final entity in Directory(
    'lib/features/learn',
  ).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (pattern.hasMatch(entity.readAsStringSync())) {
      offenders.add(entity.path);
    }
  }

  final undeclared = offenders.difference(allowed).toList()..sort();
  expect(undeclared, isEmpty, reason: 'New drift in Learn. $reason');

  final stale = allowed.difference(offenders).toList()..sort();
  expect(
    stale,
    isEmpty,
    reason:
        'These files are on the allow-list but no longer drift. Delete them '
        'from the list in this test so the ratchet keeps tightening.',
  );
}
