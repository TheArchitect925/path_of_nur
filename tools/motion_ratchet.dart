// Counts the motion patterns the app is ratcheting down, so new code cannot
// bring back a spinner where a skeleton belongs, or fade a glass card.
//
//   dart run tools/motion_ratchet.dart                 print the counts
//   dart run tools/motion_ratchet.dart --write-baseline lock an improvement
//
// `test/app/motion_ratchet_test.dart` fails CI when a count rises above
// `tools/motion_ratchet_baseline.json`, or falls without the baseline being
// rewritten. Never raise a baseline by hand.
import 'dart:convert';
import 'dart:io';

/// What is counted, and why each one is on the list.
const Map<String, String> motionRatchetPatterns = {
  // A spinner says nothing about the shape of what is coming.
  'CircularProgressIndicator(': 'spinner',
  // Opacity animations over layered glass darken it under Impeller
  // (docs/impeller_glass_transition_backlog_2026-04-07.md).
  'AnimatedOpacity(': 'animatedOpacity',
  'FadeTransition(': 'fadeTransition',
  'AnimatedSwitcher(': 'animatedSwitcher',
};

/// Files that own the motion vocabulary: they fade content, never glass,
/// and are reviewed as a set.
const List<String> motionRatchetAllowList = [
  'lib/shared/motion/',
  'lib/features/startup/presentation/app_loading_screen.dart',
];

const String motionRatchetBaselinePath = 'tools/motion_ratchet_baseline.json';

Map<String, int> countMotionPatterns({String root = 'lib'}) {
  final counts = {for (final key in motionRatchetPatterns.values) key: 0};
  final files =
      Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))
          .where((file) => !file.path.contains('/l10n/'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  for (final file in files) {
    final path = file.path.replaceAll('\\', '/');
    if (motionRatchetAllowList.any(path.startsWith)) continue;
    final source = file.readAsStringSync();
    for (final entry in motionRatchetPatterns.entries) {
      counts[entry.value] =
          counts[entry.value]! + entry.key.allMatches(source).length;
    }
  }
  return counts;
}

Map<String, int> readMotionBaseline() {
  final file = File(motionRatchetBaselinePath);
  if (!file.existsSync()) return const {};
  final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  return (json['counts'] as Map<String, dynamic>).map(
    (key, value) => MapEntry(key, value as int),
  );
}

void writeMotionBaseline(Map<String, int> counts) {
  const encoder = JsonEncoder.withIndent('  ');
  File(
    motionRatchetBaselinePath,
  ).writeAsStringSync('${encoder.convert({'counts': counts})}\n');
}

void main(List<String> args) {
  final counts = countMotionPatterns();
  if (args.contains('--write-baseline')) {
    writeMotionBaseline(counts);
    stdout.writeln('Wrote $motionRatchetBaselinePath');
  }
  stdout.writeln(jsonEncode({'counts': counts}));
}
