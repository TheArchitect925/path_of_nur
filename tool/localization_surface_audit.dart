import 'dart:convert';
import 'dart:io';

const Map<String, List<String>> _surfacePrefixes = <String, List<String>>{
  'hadith_reader_phase3': <String>[
    'hadithProvenance',
    'hadithSourceChapter',
    'hadithReader',
    'hadithSourceBrowse',
    'hadithBrowse',
    'hadithSearch',
  ],
  'broader_hadith_quran': <String>[
    'hadithBrowse',
    'hadithSearch',
    'hadithSourceBrowse',
    'hadithReaderContinue',
    'hadithReaderBackToResults',
    'hadithReaderPrevious',
    'hadithReaderNext',
    'quranMemorization',
    'quranDailyCompanion',
    'quranCompanion',
    'quranTheme',
    'quranThemeMap',
    'quranThemeDiscovery',
    'quranTopicsTitle',
    'quranReferenceDetail',
  ],
};

const Set<String> _allowedEnglishCarryover = <String>{
  'dua',
  'hadith',
  'quran',
  "qur'an",
  'qur’an',
};

void main(List<String> args) {
  final requestedGroups = _parseGroups(args);
  if (requestedGroups.isEmpty) {
    stderr.writeln(
      'Usage: dart run tool/localization_surface_audit.dart '
      '--group <${_surfacePrefixes.keys.join('|')}> [--group ...]',
    );
    exitCode = 64;
    return;
  }

  final root = Directory('lib/l10n');
  final englishFile = File('${root.path}/app_en.arb');
  if (!englishFile.existsSync()) {
    stderr.writeln('Missing ${englishFile.path}');
    exitCode = 66;
    return;
  }

  final englishData =
      jsonDecode(englishFile.readAsStringSync()) as Map<String, dynamic>;
  final localeFiles = root
      .listSync()
      .whereType<File>()
      .where((file) {
        final name = file.uri.pathSegments.last;
        return name.startsWith('app_') &&
            name.endsWith('.arb') &&
            name != 'app_en.arb';
      })
      .toList(growable: false)
    ..sort((a, b) => a.path.compareTo(b.path));

  for (final group in requestedGroups) {
    final prefixes = _surfacePrefixes[group]!;
    final keys = englishData.keys
        .where((key) => !key.startsWith('@'))
        .where((key) => prefixes.any(key.startsWith))
        .toList(growable: false)
      ..sort();

    stdout.writeln('## $group');
    stdout.writeln('Keys: ${keys.length}');
    for (final file in localeFiles) {
      final localeData =
          jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final localeName = file.uri.pathSegments.last.replaceFirst('app_', '');
      final sameAsEnglish = <String>[];
      for (final key in keys) {
        final englishValue = englishData[key];
        final localeValue = localeData[key];
        if (englishValue is! String || localeValue is! String) continue;
        if (localeValue != englishValue) continue;
        if (_shouldIgnoreExactEnglish(englishValue)) continue;
        sameAsEnglish.add(key);
      }
      stdout.writeln('- $localeName: ${sameAsEnglish.length}');
      if (sameAsEnglish.isNotEmpty) {
        stdout.writeln('  ${sameAsEnglish.join(', ')}');
      }
    }
    stdout.writeln();
  }
}

List<String> _parseGroups(List<String> args) {
  final groups = <String>[];
  for (var i = 0; i < args.length; i += 1) {
    if (args[i] != '--group' || i + 1 >= args.length) continue;
    final group = args[i + 1];
    if (_surfacePrefixes.containsKey(group) && !groups.contains(group)) {
      groups.add(group);
    }
  }
  return groups;
}

bool _shouldIgnoreExactEnglish(String value) {
  if (_isPlaceholderOnly(value)) return true;
  final normalized = value.trim().toLowerCase();
  return _allowedEnglishCarryover.contains(normalized);
}

bool _isPlaceholderOnly(String value) {
  var stripped = value.replaceAll(RegExp(r'\{[^{}]+\}'), '');
  for (final token in <String>['•', ':', '.', ',', '،', '·', '-', '—']) {
    stripped = stripped.replaceAll(token, '');
  }
  return stripped.trim().isEmpty;
}
