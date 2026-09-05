import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Phase K0 of the kids redesign: a ratchet over the kids surface.
///
/// The kids area (three feature roots plus the kids pages that live inside
/// Learn) renders identically for an adult and a four-year-old. Phases K1–K6
/// rebuild it over several sessions, so every check below carries today's
/// known offenders and is asserted in *both* directions:
///  * a file that drifts and is not listed fails — no new drift;
///  * a listed file that no longer drifts also fails — the list must shrink
///    as each phase lands, so it can never rot into a permanent exemption.
///
/// Two checks are counts rather than sets. Raw colour literals and Material
/// icons are far too common to ban outright, so each file carries the number
/// it had when the ratchet was seeded; the number may only go down, and when
/// it does the seed must follow.
void main() {
  test('Kids pages build on the app scaffold, not a bare Scaffold', () {
    // K2 moved the drawing canvas onto the kids shell; nothing is left.
    const allowed = <String>{};
    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])Scaffold\('),
      allowed: allowed,
      reason:
          'A bare Material Scaffold renders no app background. Build on '
          'AppPageScaffold and put page actions in floatingBottom so they '
          'never sit under the tab bar.',
    );
  });

  test('Kids pages do not raise a Material AppBar', () {
    const allowed = <String>{};
    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])(Sliver)?AppBar\('),
      allowed: allowed,
      reason:
          'AppBar exists nowhere else in the product. Move the title into '
          'the scaffold title and any action into headerActions.',
    );
  });

  test('Kids pages draw determinate progress with the display kit', () {
    const allowed = <String>{
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_detail_page.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_memory_cards_page.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_quiz_page.dart',
      'lib/features/kids/seerah/presentation/seerah_journey_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_lesson_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_category_page.dart',
    };
    _expectNoDrift(
      pattern: RegExp('LinearProgressIndicator'),
      allowed: allowed,
      reason:
          'Use ProgressBar from lib/shared/widgets/display/progress_bar.dart '
          'for a determinate value.',
    );
  });

  test('Kids pages build rows with the display kit CompactListTile', () {
    const allowed = <String>{
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_full_player_sheet.dart',
      'lib/features/kids/seerah/presentation/seerah_journey_page.dart',
      'lib/features/kids/seerah/presentation/seerah_journeys_page.dart',
    };
    _expectNoDrift(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])ListTile\('),
      allowed: allowed,
      reason:
          'Use CompactListTile from '
          'lib/shared/widgets/display/compact_list_tile.dart.',
    );
  });

  test('Kids files do not gain raw colour literals', () {
    // Frozen colours are why the kids pages went unreadable on the night
    // themes: a cream card painted by hand under text that follows the
    // theme. `context.palette.*` and the text theme re-tint for free.
    const seeded = <String, int>{
      'lib/features/kids/bedtime_routines/presentation/bedtime_companion_page.dart':
          3,
      'lib/features/kids/bedtime_routines/presentation/bedtime_routine_step_card.dart':
          6,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_cover_card.dart':
          9,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_family_mode_page.dart':
          1,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart':
          1,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_question_card.dart':
          4,
      'lib/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart':
          2,
      'lib/features/kids_arabic/data/kids_arabic_letters_data.dart': 4,
      'lib/features/kids_arabic/domain/kids_arabic_achievement_models.dart': 8,
      'lib/features/kids_arabic/presentation/kids_arabic_coloring_pages_page.dart':
          2,
      'lib/features/kids_arabic/presentation/kids_arabic_home_page.dart': 27,
      'lib/features/kids_arabic/presentation/kids_arabic_lesson_page.dart': 8,
      'lib/features/kids_arabic/presentation/kids_arabic_mini_phrases_page.dart':
          6,
      'lib/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart':
          15,
      'lib/features/kids_arabic/presentation/kids_arabic_practice_page.dart':
          11,
      'lib/features/kids_arabic/presentation/kids_arabic_progress_map_page.dart':
          9,
      'lib/features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart':
          7,
      'lib/features/kids_arabic/presentation/kids_arabic_review_page.dart': 3,
      'lib/features/kids_arabic/presentation/kids_arabic_rewards_page.dart': 2,
      'lib/features/kids_arabic/presentation/kids_arabic_word_lesson_page.dart':
          5,
      'lib/features/kids_arabic/presentation/kids_arabic_words_page.dart': 11,
      'lib/features/kids_arabic/widgets/kids_arabic_audio_learning_widgets.dart':
          5,
      'lib/features/kids_arabic/widgets/kids_arabic_tracing_pad.dart': 38,
      'lib/features/kids_dua_learning/application/kids_dua_sticker_service.dart':
          8,
      'lib/features/kids_dua_learning/data/kids_dua_seed_data.dart': 8,
      'lib/features/kids_dua_learning/presentation/kids_dua_category_page.dart':
          8,
      'lib/features/kids_dua_learning/presentation/kids_dua_drawing_page.dart':
          9,
      'lib/features/kids_dua_learning/presentation/kids_dua_drawings_page.dart':
          2,
      'lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart':
          31,
      'lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart':
          7,
      'lib/features/kids_dua_learning/presentation/kids_dua_parent_dashboard_page.dart':
          3,
      'lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart':
          10,
      'lib/features/kids_dua_learning/presentation/kids_dua_read_along_view.dart':
          8,
      'lib/features/kids_dua_learning/presentation/kids_dua_rewards_page.dart':
          12,
      'lib/features/kids_dua_learning/presentation/kids_dua_stories_page.dart':
          6,
      'lib/features/kids_dua_learning/presentation/kids_dua_story_browse_page.dart':
          3,
      'lib/features/kids_dua_learning/presentation/kids_dua_tap_repeat_view.dart':
          8,
      'lib/features/learn/quran/presentation/kids_quran_page.dart': 1,
    };
    _expectCountsOnlyFall(
      pattern: RegExp(r'Color\(0x[0-9A-Fa-f]{8}\)'),
      seeded: seeded,
      what: 'raw Color(0x…) literals',
      reason:
          'Read colours through context.palette or the text theme so the '
          'kids pages stay legible on every theme.',
    );
  });

  test('Kids files do not gain Material icons', () {
    // The product has one icon vocabulary (AppIcons). Material glyphs are
    // allowed to linger where they already are, and nowhere new.
    const seeded = <String, int>{
      'lib/features/kids/bedtime_routines/presentation/bedtime_companion_page.dart':
          10,
      'lib/features/kids/bedtime_routines/presentation/bedtime_routine_step_card.dart':
          1,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_completion_banner.dart':
          2,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_cover_card.dart':
          1,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_detail_page.dart':
          6,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_family_mode_page.dart':
          5,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_full_player_sheet.dart':
          12,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_memory_cards_page.dart':
          3,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_mini_player.dart':
          4,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart':
          21,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_player_bar.dart':
          9,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_question_card.dart':
          2,
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_quiz_page.dart':
          2,
      'lib/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart':
          1,
      'lib/features/kids/seerah/presentation/seerah_journey_page.dart': 7,
      'lib/features/kids/seerah/presentation/seerah_journeys_page.dart': 1,
      'lib/features/kids/seerah/presentation/seerah_node_page.dart': 3,
      'lib/features/kids_arabic/data/kids_arabic_letters_data.dart': 4,
      'lib/features/kids_arabic/domain/kids_arabic_achievement_models.dart': 8,
      'lib/features/kids_arabic/presentation/kids_arabic_coloring_pages_page.dart':
          1,
      'lib/features/kids_arabic/presentation/kids_arabic_coloring_viewer_page.dart':
          1,
      'lib/features/kids_arabic/presentation/kids_arabic_home_page.dart': 6,
      'lib/features/kids_arabic/presentation/kids_arabic_lesson_page.dart': 1,
      'lib/features/kids_arabic/presentation/kids_arabic_mini_phrases_page.dart':
          6,
      'lib/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart':
          4,
      'lib/features/kids_arabic/presentation/kids_arabic_reading_mode_page.dart':
          6,
      'lib/features/kids_arabic/widgets/kids_arabic_audio_learning_widgets.dart':
          5,
      'lib/features/kids_arabic/widgets/kids_arabic_tracing_pad.dart': 3,
      'lib/features/kids_dua_learning/application/kids_dua_my_day_service.dart':
          4,
      'lib/features/kids_dua_learning/application/kids_dua_sticker_service.dart':
          8,
      'lib/features/kids_dua_learning/application/kids_dua_story_illustration_service.dart':
          6,
      'lib/features/kids_dua_learning/data/kids_dua_seed_data.dart': 39,
      'lib/features/kids_dua_learning/presentation/kids_dua_category_page.dart':
          1,
      'lib/features/kids_dua_learning/presentation/kids_dua_drawing_page.dart':
          3,
      'lib/features/kids_dua_learning/presentation/kids_dua_drawing_view_page.dart':
          1,
      'lib/features/kids_dua_learning/presentation/kids_dua_drawings_page.dart':
          1,
      'lib/features/kids_dua_learning/presentation/kids_dua_landing_page.dart':
          9,
      'lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart':
          13,
      'lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart':
          3,
      'lib/features/kids_dua_learning/presentation/kids_dua_parent_dashboard_page.dart':
          1,
      'lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart':
          1,
      'lib/features/kids_dua_learning/presentation/kids_dua_stories_page.dart':
          2,
      'lib/features/kids_dua_learning/presentation/kids_dua_story_player_page.dart':
          3,
      'lib/features/kids_dua_learning/presentation/kids_dua_tap_repeat_view.dart':
          2,
      'lib/features/learn/guided_paths/presentation/kids_starter_path_bridge_page.dart':
          3,
      'lib/features/learn/guided_paths/presentation/kids_starter_path_next_steps_page.dart':
          5,
      'lib/features/learn/hadith/presentation/kids_hadith_page.dart': 1,
    };
    _expectCountsOnlyFall(
      pattern: RegExp(r'(^|[^A-Za-z0-9_])Icons\.'),
      seeded: seeded,
      what: 'Material Icons.* references',
      reason: 'Use AppIcons from lib/core/theme/app_icons.dart.',
    );
  });
}

/// The three kids feature roots plus the kids pages that live inside Learn.
List<File> _kidsFiles() {
  final files = <File>[];
  for (final root in const [
    'lib/features/kids',
    'lib/features/kids_arabic',
    'lib/features/kids_dua_learning',
  ]) {
    for (final entity in Directory(root).listSync(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) files.add(entity);
    }
  }
  final learnKids = RegExp(
    r'^lib/features/learn/('
    r'presentation/pages/learn_kids_[a-z_]+\.dart|'
    r'quran/presentation/kids_quran[a-z_]*\.dart|'
    r'hadith/presentation/kids_hadith_page\.dart|'
    r'guided_paths/presentation/kids_starter_path_[a-z_]+\.dart'
    r')$',
  );
  for (final entity in Directory(
    'lib/features/learn',
  ).listSync(recursive: true)) {
    if (entity is File && learnKids.hasMatch(entity.path)) files.add(entity);
  }
  return files;
}

void _expectNoDrift({
  required RegExp pattern,
  required Set<String> allowed,
  required String reason,
}) {
  final offenders = <String>{};
  for (final file in _kidsFiles()) {
    if (pattern.hasMatch(file.readAsStringSync())) offenders.add(file.path);
  }

  final undeclared = offenders.difference(allowed).toList()..sort();
  expect(undeclared, isEmpty, reason: 'New drift in the kids area. $reason');

  final stale = allowed.difference(offenders).toList()..sort();
  expect(
    stale,
    isEmpty,
    reason:
        'These files are on the allow-list but no longer drift. Delete them '
        'from the list in this test so the ratchet keeps tightening.',
  );
}

void _expectCountsOnlyFall({
  required RegExp pattern,
  required Map<String, int> seeded,
  required String what,
  required String reason,
}) {
  final grew = <String>[];
  final fell = <String>[];
  final seen = <String>{};
  for (final file in _kidsFiles()) {
    final count = pattern.allMatches(file.readAsStringSync()).length;
    if (count == 0) continue;
    seen.add(file.path);
    final allowed = seeded[file.path] ?? 0;
    if (count > allowed) grew.add('${file.path}: $count (seeded $allowed)');
    if (count < allowed) fell.add('${file.path}: $count (seeded $allowed)');
  }
  final gone = seeded.keys.where((path) => !seen.contains(path)).toList();

  expect(grew..sort(), isEmpty, reason: 'These files gained $what. $reason');
  expect(
    [...fell, ...gone.map((path) => '$path: 0')]..sort(),
    isEmpty,
    reason:
        'These files now carry fewer $what than seeded. Lower their number '
        'in this test (or remove them) so the ratchet keeps tightening.',
  );
}
