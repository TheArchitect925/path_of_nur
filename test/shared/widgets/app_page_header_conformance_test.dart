import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// HD-0 of the header redesign (2026-09-04): a ratchet, not a cleanup.
///
/// The audit of every page header found four kinds of drift that no test was
/// holding still. (The icon-family rule moved to
/// `test/core/theme/app_icons_policy_test.dart` when HD-2 took it to zero.) Each check below carries an allow-list of today's known
/// offenders so the later phases (HD-1 primitive, HD-2 icon vocabulary,
/// HD-4 section headers) can land over several sessions without new drift
/// creeping in behind them.
///
/// Allow-lists are checked in *both* directions: an unlisted offender fails,
/// and a listed file that no longer offends also fails, so every list must
/// shrink as the phases land and can never rot into a permanent exemption.
void main() {
  test('Only landing pages put an icon in the page header', () {
    // Decision A1: pushed pages set their title and subtitle from the page
    // margin with no icon; the accent icon chip belongs to tab roots and
    // section fronts, the pages a row leads *to*, so the header and the row
    // that opened it share one language.
    //
    // A landing may pass `headerIcon`; nothing else may. Files that forward
    // the parameter unchanged (wrappers) are excluded by the pattern.
    const landings = <String>{
      'lib/features/accounts_sync/presentation/accounts_profiles_sync_page.dart',
      'lib/features/assistant/presentation/assistant_page.dart',
      'lib/features/celestial/presentation/celestial_explorer_page.dart',
      'lib/features/circles/presentation/circles_discovery_page.dart',
      'lib/features/creation_challenges/presentation/creation_challenges_page.dart',
      'lib/features/creation_explorer/presentation/creation_explorer_page.dart',
      'lib/features/editorial_dashboard/presentation/editorial_dashboard_page.dart',
      'lib/features/faq/pages/faq_landing_page.dart',
      'lib/features/garden/presentation/garden_page.dart',
      'lib/features/history/presentation/history_archive_page.dart',
      'lib/features/journal/presentation/journal_timeline_page.dart',
      'lib/features/journey/presentation/growth_browse_all_page.dart',
      'lib/features/journey/presentation/growth_habit_dashboard_page.dart',
      'lib/features/journey/presentation/growth_habits_page.dart',
      'lib/features/journey/presentation/growth_home_page.dart',
      'lib/features/journey/presentation/growth_section_pages.dart',
      'lib/features/journey/presentation/growth_tracking_dashboard_page.dart',
      'lib/features/journey/spiritual_growth/presentation/spiritual_growth_page.dart',
      'lib/features/kids/bedtime_routines/presentation/bedtime_companion_page.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_stories_page.dart',
      'lib/features/kids/bedtime_stories/presentation/bedtime_story_parent_dashboard_page.dart',
      'lib/features/kids/bedtime_stories/presentation/kids_hadith_stories_page.dart',
      'lib/features/kids/bedtime_stories/presentation/kids_story_library_page.dart',
      'lib/features/kids/seerah/presentation/seerah_journeys_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_home_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_parent_dashboard_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_landing_page.dart',
      'lib/features/learn/ayah_completion/presentation/ayah_completion_home_page.dart',
      'lib/features/learn/companion_surfaces/presentation/character_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/seerah_companion_page.dart',
      'lib/features/learn/content/presentation/learn_notes_landing_page.dart',
      'lib/features/learn/content/presentation/learn_topic_landing_page.dart',
      'lib/features/learn/crossword/presentation/crossword_home_page.dart',
      'lib/features/learn/divine_life_lessons/presentation/divine_life_lessons_page.dart',
      'lib/features/learn/dua/presentation/dua_hub_page.dart',
      'lib/features/learn/glossary/presentation/glossary_page.dart',
      'lib/features/learn/hadith/presentation/hadith_landing_page.dart',
      'lib/features/learn/hadith/presentation/kids_hadith_page.dart',
      'lib/features/learn/hadith_reflection/presentation/hadith_reflection_home_page.dart',
      'lib/features/learn/journey/presentation/learn_browse_all_page.dart',
      'lib/features/learn/journey/presentation/learning_journey_home_page.dart',
      'lib/features/learn/journey/presentation/learning_journey_island_page.dart',
      'lib/features/learn/journey/presentation/learning_path_detail_page.dart',
      'lib/features/learn/knowledge_games/daily/presentation/daily_knowledge_challenge_hub_page.dart',
      'lib/features/learn/life/baby_names/presentation/baby_names_home_page.dart',
      'lib/features/learn/matching/presentation/matching_home_page.dart',
      'lib/features/learn/presentation/pages/games_island_page.dart',
      'lib/features/learn/presentation/pages/learn_category_page.dart',
      'lib/features/learn/presentation/pages/learn_explore_all_knowledge_page.dart',
      'lib/features/learn/presentation/pages/learn_games_browse_all_page.dart',
      'lib/features/learn/presentation/pages/learn_kids_fun_learning_page.dart',
      'lib/features/learn/presentation/pages/learn_kids_games_page.dart',
      'lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart',
      'lib/features/learn/presentation/pages/learn_salah_hub_page.dart',
      'lib/features/learn/presentation/pages/learning_journey_island_hub_page.dart',
      'lib/features/learn/presentation/pages/learning_section_landing_page.dart',
      'lib/features/learn/presentation/pages/quran_app_hub_page.dart',
      'lib/features/learn/prophets/presentation/prophets_page.dart',
      'lib/features/learn/quran/presentation/kids_quran_page.dart',
      'lib/features/learn/quran/presentation/names_of_allah_page.dart',
      'lib/features/learn/quran/presentation/quran_ayah_insights_browse_page.dart',
      'lib/features/learn/quran/presentation/quran_ayah_insights_paths_page.dart',
      'lib/features/learn/quran/presentation/quran_daily_companion_page.dart',
      'lib/features/learn/quran/presentation/quran_khatm_plan_page.dart',
      'lib/features/learn/quran/presentation/quran_learning_paths_page.dart',
      'lib/features/learn/quran/presentation/quran_summary_page.dart',
      'lib/features/learn/quran/presentation/quran_surah_explorer_page.dart',
      'lib/features/learn/quran/presentation/quran_topic_explorer_page.dart',
      'lib/features/learn/quran/presentation/quran_words_page.dart',
      'lib/features/learn/quran_teaching/presentation/quran_teaching_section_page.dart',
      'lib/features/learn/quran_universe/presentation/quran_universe_page.dart',
      'lib/features/learn/trivia/presentation/trivia_home_page.dart',
      'lib/features/learn/trivia/presentation/trivia_knowledge_paths_page.dart',
      'lib/features/learn/word_search/presentation/word_search_home_page.dart',
      'lib/features/learn/world/presentation/world_landing_page.dart',
      'lib/features/ocean/presentation/ocean_dashboard_page.dart',
      'lib/features/ocean/presentation/ocean_drops_page.dart',
      'lib/features/profile/presentation/help_guide_hub_page.dart',
      'lib/features/profile/presentation/settings_page.dart',
      'lib/features/progression/presentation/learner_progression_page.dart',
      'lib/features/wallpaper/presentation/wallpaper_library_page.dart',
      'lib/features/worship/presentation/dhikr/dhikr_landing_page.dart',
      'lib/features/worship/presentation/worship_page.dart',
      'lib/features/worship/presentation/worship_section_pages.dart',
    };

    // Pushed pages that still pass an icon. HD-1 removes these; the set must
    // be empty once that phase lands and any file left in it is a bug.
    const stillToSweep = <String>{};

    final offenders = _filesMatching(
      RegExp(r'headerIcon:\s*(?!headerIcon\b|widget\.headerIcon\b)'),
      exclude: const {
        'lib/shared/widgets/app_page_scaffold.dart',
        'lib/shared/widgets/section_hub_scaffold.dart',
        'lib/features/learn/presentation/widgets/learn_hub_page_scaffold.dart',
      },
    );

    final undeclared =
        offenders.difference(landings).difference(stillToSweep).toList()
          ..sort();
    expect(
      undeclared,
      isEmpty,
      reason:
          'A pushed page passes headerIcon. Only landings carry the header '
          'chip; remove the icon, or add the file to `landings` if it really '
          'is a section front.',
    );

    final stale = stillToSweep.difference(offenders).toList()..sort();
    expect(
      stale,
      isEmpty,
      reason:
          'These files no longer pass headerIcon. Delete them from '
          '`stillToSweep` so the ratchet keeps tightening.',
    );
  });

  test('Section headers use SectionTitle, not private copies', () {
    // `SectionTitle` is the one section header: gold on the night themes,
    // theme foreground elsewhere. A private `_SectionHeader` freezes its own
    // colours and goes dark-on-dark on Midnight. HD-4 retires these.
    const allowed = <String>{
      'lib/features/kids/bedtime_routines/presentation/bedtime_companion_page.dart',
      'lib/features/kids/bedtime_stories/presentation/kids_story_library_page.dart',
      'lib/features/kids/seerah/presentation/seerah_journeys_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_home_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_practice_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_progress_map_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_rewards_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_word_lesson_page.dart',
      'lib/features/kids_arabic/presentation/kids_arabic_words_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_landing_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart',
      'lib/features/learn/companion_surfaces/presentation/character_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/daily_wisdom_companion_page.dart',
      'lib/features/learn/companion_surfaces/presentation/seerah_companion_page.dart',
      'lib/features/learn/presentation/pages/games_island_page.dart',
      'lib/features/learn/presentation/pages/learn_category_page.dart',
      'lib/features/learn/presentation/pages/learning_journey_island_hub_page.dart',
      'lib/features/learn/quran/presentation/quran_memorization_review_page.dart',
      'lib/features/worship/presentation/widgets/prayer_section.dart',
    };

    _expectRatchet(
      offenders: _filesMatching(
        RegExp(
          r'class _[A-Za-z]*(SectionHeader|SectionTitle|SectionLabel|GroupHeader)[A-Za-z]* ',
        ),
      ),
      allowed: allowed,
      reason:
          'Use SectionTitle from lib/shared/widgets/section_title.dart '
          'instead of a private section header class.',
    );
  });

  test('Pages outside Learn build on the app scaffold', () {
    // The Learn conformance test already polices lib/features/learn. This is
    // the same rule for the rest of the product: no Material Scaffold or
    // AppBar, so every page renders inside GlobalBackground with the
    // AppPageScaffold header.
    const allowed = <String>{
      // Full-screen flows that deliberately run outside the shell.
      'lib/features/onboarding/presentation/onboarding_page.dart',
      'lib/features/startup/presentation/app_loading_screen.dart',
      // Still to convert (R1 in the header audit).
      'lib/features/journey/drops/presentation/garden_image_viewer_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_category_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_drawing_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_drawing_view_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_drawings_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_lesson_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_my_day_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_parent_dashboard_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_practice_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_rewards_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_stories_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_story_browse_page.dart',
      'lib/features/kids_dua_learning/presentation/kids_dua_story_player_page.dart',
      'lib/features/salah/presentation/salah_page.dart',
    };

    _expectRatchet(
      offenders: _filesMatching(
        RegExp(r'(^|[^A-Za-z0-9_])((Sliver)?AppBar|Scaffold)\('),
        root: 'lib/features',
        exclude: const {},
        skipDir: 'lib/features/learn',
      ),
      allowed: allowed,
      reason:
          'Build on AppPageScaffold so the page gets the app background and '
          'the shared header.',
    );
  });

  test('Page titles and subtitles come from the ARB, not string literals', () {
    // HD-3 (decision C1): every header string is localized. A literal here is
    // a page German (and the other sixteen locales) will never see translated.
    final offenders = <String>[];
    for (final call in _scaffoldCalls()) {
      for (final entry in call.args.entries) {
        if (entry.key != 'title' && entry.key != 'subtitle') continue;
        final v = entry.value;
        final literal = v.startsWith("'") || v.startsWith('"');
        final template = v.startsWith("'\${") || v.startsWith('"\${');
        if (literal && !template) {
          offenders.add('${call.file}:${call.line} ${entry.key}');
        }
      }
    }
    expect(
      offenders..sort(),
      isEmpty,
      reason: 'Move the string into app_en.arb (and every other locale).',
    );
  });

  test('Status text never sits in the header', () {
    // "Route not found", "Loading…", "Unavailable" describe the body, not the
    // page. The header keeps the section title; the state renders below it.
    final en = _englishArb();
    final status = RegExp(
      r'(not found|unavailable|not available|loading|preparing|try again|'
      r'try reopening|try another|try opening|could not|no active|'
      r'no matches|not part of|not fully|\blocked\b|opens after|'
      r'finish the earlier)',
      caseSensitive: false,
    );
    final offenders = <String>[];
    for (final call in _scaffoldCalls()) {
      for (final entry in call.args.entries) {
        if (entry.key != 'title' && entry.key != 'subtitle') continue;
        final key = _arbKey(entry.value);
        final value = key == null ? null : en[key];
        if (value is String && status.hasMatch(value)) {
          offenders.add('${call.file}:${call.line} ${entry.key}: $key');
        }
      }
    }
    expect(
      offenders..sort(),
      isEmpty,
      reason: 'Keep the section title; put the state in a body card.',
    );
  });

  test('Page subtitles stay short', () {
    // One line of orientation, not the page pitch: the English copy is capped
    // at 92 characters (the audit found 34 running to three or four lines).
    final en = _englishArb();
    final offenders = <String>[];
    for (final call in _scaffoldCalls()) {
      final key = _arbKey(call.args['subtitle'] ?? '');
      final value = key == null ? null : en[key];
      if (value is String && value.length > 92) {
        offenders.add('${call.file}:${call.line} $key (${value.length})');
      }
    }
    expect(
      offenders..sort(),
      isEmpty,
      reason: 'Shorten the subtitle in app_en.arb (and de).',
    );
  });
}

Map<String, dynamic> _englishArb() =>
    jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
        as Map<String, dynamic>;

/// `l10n.someKey`, `AppLocalizations.of(context).someKey(...)` → `someKey`.
String? _arbKey(String expr) {
  final m = RegExp(r'\.([A-Za-z0-9_]+)\s*(\(|$)').firstMatch(expr.trim());
  return m?.group(1);
}

class _ScaffoldCall {
  _ScaffoldCall(this.file, this.line, this.args);
  final String file;
  final int line;

  /// The call's own named arguments (depth 0), name → value source.
  final Map<String, String> args;
}

/// Every AppPageScaffold / LearnHubPageScaffold / SectionHubScaffold call in
/// lib, with its top-level named arguments.
Iterable<_ScaffoldCall> _scaffoldCalls() sync* {
  final open = RegExp(
    r'(?<![A-Za-z0-9_])(AppPageScaffold|LearnHubPageScaffold|SectionHubScaffold)\(',
  );
  for (final file in _dartFiles()) {
    if (file.path.endsWith('_scaffold.dart')) continue;
    final src = file.readAsStringSync();
    for (final m in open.allMatches(src)) {
      final args = <String, String>{};
      var depth = 0;
      var i = m.end;
      String? quote;
      String? name;
      var valueStart = -1;
      void closeArg(int end) {
        if (name != null) args[name!] = src.substring(valueStart, end).trim();
        name = null;
      }

      while (i < src.length) {
        final c = src[i];
        if (quote != null) {
          if (c == r'\') {
            i += 2;
            continue;
          }
          if (c == quote) quote = null;
        } else if (c == "'" || c == '"') {
          quote = c;
        } else if (c == '(' || c == '[' || c == '{') {
          depth++;
        } else if (c == ')' || c == ']' || c == '}') {
          if (depth == 0) {
            closeArg(i);
            break;
          }
          depth--;
        } else if (depth == 0 && c == ',') {
          closeArg(i);
        } else if (depth == 0 && name == null) {
          final am = RegExp(r'([A-Za-z_]\w*):\s*').matchAsPrefix(src, i);
          if (am != null && (i == 0 || ' \n\t,('.contains(src[i - 1]))) {
            name = am.group(1);
            valueStart = am.end;
            i = am.end;
            continue;
          }
        }
        i++;
      }
      final line = src.substring(0, m.start).split('\n').length;
      yield _ScaffoldCall(file.path, line, args);
    }
  }
}

Iterable<File> _dartFiles({String root = 'lib', String? skipDir}) sync* {
  for (final entity in Directory(root).listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (skipDir != null && entity.path.startsWith(skipDir)) continue;
    yield entity;
  }
}

Set<String> _filesMatching(
  RegExp pattern, {
  String root = 'lib',
  Set<String> exclude = const {},
  String? skipDir,
}) {
  final matches = <String>{};
  for (final file in _dartFiles(root: root, skipDir: skipDir)) {
    if (exclude.contains(file.path)) continue;
    if (pattern.hasMatch(file.readAsStringSync())) matches.add(file.path);
  }
  return matches;
}

void _expectRatchet({
  required Set<String> offenders,
  required Set<String> allowed,
  required String reason,
}) {
  final undeclared = offenders.difference(allowed).toList()..sort();
  expect(undeclared, isEmpty, reason: 'New drift. $reason');

  final stale = allowed.difference(offenders).toList()..sort();
  expect(
    stale,
    isEmpty,
    reason:
        'These files are on the allow-list but no longer offend. Delete them '
        'from the list so the ratchet keeps tightening.',
  );
}
