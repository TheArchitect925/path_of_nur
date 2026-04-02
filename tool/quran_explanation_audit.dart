import 'dart:io';

import 'package:quran/quran.dart' as q;
import 'package:path_of_nur/features/learn/quran/data/seeded_quran_ayah_explanations.dart';
import 'package:path_of_nur/features/learn/quran/domain/quran_ayah_explanation_models.dart';

void main() {
  final issues = <String>[];
  final seenAyahs = <String>{};
  var simpleCount = 0;
  var standardCount = 0;
  var kidsCount = 0;
  var deepCount = 0;
  var reflectionPromptCount = 0;
  var keyLessonsCount = 0;
  var sourceRefsCount = 0;

  for (final entry in seededQuranAyahExplanations) {
    final key = entry.ayahKey;
    if (!seenAyahs.add(key)) {
      issues.add('Duplicate ayah explanation entry found for $key.');
    }

    if (!entry.hasSimpleSummary) {
      issues.add('Missing simpleSummary for $key.');
    } else {
      simpleCount += 1;
    }
    if (!entry.hasStandardExplanation) {
      issues.add('Missing standardExplanation for $key.');
    } else {
      standardCount += 1;
    }
    if (!entry.hasKidsExplanation) {
      issues.add('Missing kidsExplanation for $key.');
    } else {
      kidsCount += 1;
    }
    if (entry.hasDeepExplanation) {
      deepCount += 1;
    }
    if (entry.hasReflectionPrompt) {
      reflectionPromptCount += 1;
    }
    if (entry.hasKeyLessons) {
      keyLessonsCount += 1;
    }
    if (entry.sourceRefs.isEmpty) {
      issues.add('Missing sourceRefs for $key.');
    } else {
      sourceRefsCount += 1;
    }

    for (final source in entry.sourceRefs) {
      if (source.title.trim().isEmpty) {
        issues.add('Empty source title found for $key.');
      }
      if (source.confidence < 0 || source.confidence > 1) {
        issues.add('Invalid source confidence for $key: ${source.confidence}.');
      }
    }
  }

  final packCounts = <QuranAyahExplanationRolloutPack, int>{};
  final reviewStatusCounts = <QuranAyahExplanationReviewStatus, int>{};
  for (final entry in seededQuranAyahExplanations) {
    packCounts.update(
      entry.rolloutPack,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
    reviewStatusCounts.update(
      entry.reviewStatus,
      (value) => value + 1,
      ifAbsent: () => 1,
    );
  }

  final totalQuranAyahs = q.totalVerseCount;
  final missingSimple = totalQuranAyahs - simpleCount;
  final missingStandard = totalQuranAyahs - standardCount;
  final missingKids = totalQuranAyahs - kidsCount;
  final missingDeep = totalQuranAyahs - deepCount;

  stdout.writeln('Quran explanation audit');
  stdout.writeln('Total entries: ${seededQuranAyahExplanations.length}');
  stdout.writeln('Full Qur\'an ayah count: $totalQuranAyahs');
  stdout.writeln('');
  stdout.writeln('Coverage by layer');
  stdout.writeln(
    '- simple: $simpleCount / $totalQuranAyahs (${_percent(simpleCount, totalQuranAyahs)})',
  );
  stdout.writeln(
    '- standard: $standardCount / $totalQuranAyahs (${_percent(standardCount, totalQuranAyahs)})',
  );
  stdout.writeln(
    '- kids: $kidsCount / $totalQuranAyahs (${_percent(kidsCount, totalQuranAyahs)})',
  );
  stdout.writeln(
    '- deep: $deepCount / $totalQuranAyahs (${_percent(deepCount, totalQuranAyahs)})',
  );
  stdout.writeln('');
  stdout.writeln('Missing ayahs by layer');
  stdout.writeln('- simple missing: $missingSimple');
  stdout.writeln('- standard missing: $missingStandard');
  stdout.writeln('- kids missing: $missingKids');
  stdout.writeln('- deep missing: $missingDeep');
  stdout.writeln('');
  stdout.writeln('Optional metadata coverage');
  stdout.writeln(
    '- reflection prompts: $reflectionPromptCount / ${seededQuranAyahExplanations.length}',
  );
  stdout.writeln(
    '- key lessons: $keyLessonsCount / ${seededQuranAyahExplanations.length}',
  );
  stdout.writeln(
    '- source refs: $sourceRefsCount / ${seededQuranAyahExplanations.length}',
  );
  stdout.writeln('');
  stdout.writeln('Rollout pack counts');
  for (final entry in packCounts.entries) {
    stdout.writeln('- ${entry.key.name}: ${entry.value}');
  }
  stdout.writeln('');
  stdout.writeln('Review status counts');
  for (final entry in reviewStatusCounts.entries) {
    stdout.writeln('- ${entry.key.name}: ${entry.value}');
  }

  if (issues.isEmpty) {
    stdout.writeln('No content issues found.');
    return;
  }

  stderr.writeln('Found ${issues.length} issue(s):');
  for (final issue in issues) {
    stderr.writeln('- $issue');
  }
  exitCode = 1;
}

String _percent(int count, int total) {
  if (total == 0) return '0.0%';
  final value = ((count / total) * 100).toStringAsFixed(1);
  return '$value%';
}
