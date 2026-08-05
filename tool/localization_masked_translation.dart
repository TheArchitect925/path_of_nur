import 'dart:convert';
import 'dart:io';

const Map<String, List<String>> kLocalizationSurfaceGroups =
    <String, List<String>>{
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

void main(List<String> args) {
  if (args.isEmpty) {
    _printUsage();
    exitCode = 64;
    return;
  }

  switch (args.first) {
    case 'export':
      _runExport(args.sublist(1));
    case 'import':
      _runImport(args.sublist(1));
    default:
      _printUsage();
      exitCode = 64;
  }
}

void _runExport(List<String> args) {
  final englishPath = _argValue(args, '--english') ?? 'lib/l10n/app_en.arb';
  final localePath = _argValue(args, '--locale');
  final outPath = _argValue(args, '--out');
  if (localePath == null || outPath == null) {
    stderr.writeln('export requires --locale and --out');
    exitCode = 64;
    return;
  }

  final keys = _resolveTargetKeys(args, englishData: _readArbFile(englishPath));
  if (keys.isEmpty) {
    stderr.writeln('No keys selected. Provide --group and/or --key.');
    exitCode = 64;
    return;
  }

  final englishData = _readArbFile(englishPath);
  final localeData = _readArbFile(localePath);
  final payload = buildMaskedExport(
    englishData: englishData,
    localeData: localeData,
    keys: keys,
  );
  final outFile = File(outPath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(
    '${const JsonEncoder.withIndent('  ').convert(payload)}\n',
  );
  stdout.writeln(
    'Exported ${payload.length} masked entries to ${outFile.path}',
  );
}

void _runImport(List<String> args) {
  final englishPath = _argValue(args, '--english') ?? 'lib/l10n/app_en.arb';
  final localePath = _argValue(args, '--locale');
  final inputPath = _argValue(args, '--input');
  final write = args.contains('--write');
  if (localePath == null || inputPath == null) {
    stderr.writeln('import requires --locale and --input');
    exitCode = 64;
    return;
  }

  final englishData = _readArbFile(englishPath);
  final localeData = _readArbFile(localePath);
  final inputData = _readArbFile(inputPath);
  final result = applyMaskedImport(
    englishData: englishData,
    localeData: localeData,
    translatedMaskedData: inputData,
  );

  if (result.failures.isNotEmpty) {
    stderr.writeln('Import blocked by placeholder validation failures:');
    for (final failure in result.failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 65;
    return;
  }

  if (write) {
    final localeFile = File(localePath);
    localeFile.writeAsStringSync(
      '${const JsonEncoder.withIndent('  ').convert(result.updatedLocaleData)}\n',
    );
    stdout.writeln(
      'Imported ${result.updatedKeys.length} entries into ${localeFile.path}',
    );
  } else {
    stdout.writeln(
      'Validated ${result.updatedKeys.length} masked entries. Re-run with --write to apply.',
    );
  }
}

Map<String, dynamic> buildMaskedExport({
  required Map<String, dynamic> englishData,
  required Map<String, dynamic> localeData,
  required List<String> keys,
}) {
  final payload = <String, dynamic>{};
  for (final key in keys) {
    final englishValue = englishData[key];
    if (englishValue is! String) continue;
    final placeholders = expectedPlaceholdersForKey(englishData, key);
    payload[key] = <String, dynamic>{
      'english': englishValue,
      'maskedEnglish': maskPlaceholders(englishValue, placeholders),
      'currentLocaleValue': localeData[key],
      'placeholders': placeholders,
    };
  }
  return payload;
}

MaskedImportResult applyMaskedImport({
  required Map<String, dynamic> englishData,
  required Map<String, dynamic> localeData,
  required Map<String, dynamic> translatedMaskedData,
}) {
  final next = Map<String, dynamic>.from(localeData);
  final failures = <String>[];
  final updatedKeys = <String>[];

  for (final entry in translatedMaskedData.entries) {
    final key = entry.key;
    final englishValue = englishData[key];
    if (englishValue is! String) continue;
    final translatedMaskedValue = _extractMaskedValue(entry.value);
    if (translatedMaskedValue == null) {
      failures.add('$key missing translated masked value');
      continue;
    }
    final placeholders = expectedPlaceholdersForKey(englishData, key);
    final validation = validateMaskedValue(
      maskedValue: translatedMaskedValue,
      placeholders: placeholders,
    );
    if (validation != null) {
      failures.add('$key $validation');
      continue;
    }
    next[key] = unmaskPlaceholders(translatedMaskedValue, placeholders);
    updatedKeys.add(key);
  }

  return MaskedImportResult(
    updatedLocaleData: next,
    updatedKeys: updatedKeys,
    failures: failures,
  );
}

List<String> expectedPlaceholdersForKey(
  Map<String, dynamic> englishData,
  String key,
) {
  final metadata = englishData['@$key'];
  if (metadata is Map<String, dynamic>) {
    final placeholders = metadata['placeholders'];
    if (placeholders is Map<String, dynamic> && placeholders.isNotEmpty) {
      return placeholders.keys.toList(growable: false);
    }
  }
  final englishValue = englishData[key];
  if (englishValue is! String) return const <String>[];
  return RegExp(r'\{([^{}]+)\}')
      .allMatches(englishValue)
      .map((match) => match.group(1)!)
      .toList(growable: false);
}

String maskPlaceholders(String value, List<String> placeholders) {
  var masked = value;
  for (var i = 0; i < placeholders.length; i += 1) {
    masked = masked.replaceAll('{${placeholders[i]}}', _tokenForIndex(i));
  }
  return masked;
}

String unmaskPlaceholders(String value, List<String> placeholders) {
  var unmasked = value;
  for (var i = 0; i < placeholders.length; i += 1) {
    unmasked = unmasked.replaceAll(_tokenForIndex(i), '{${placeholders[i]}}');
  }
  return unmasked;
}

String? validateMaskedValue({
  required String maskedValue,
  required List<String> placeholders,
}) {
  for (var i = 0; i < placeholders.length; i += 1) {
    final token = _tokenForIndex(i);
    if (!maskedValue.contains(token)) {
      return 'is missing required placeholder token $token';
    }
  }
  final extraTokens = RegExp(r'__PH_(\d+)__')
      .allMatches(maskedValue)
      .map((match) => match.group(0)!)
      .where((token) => !_expectedTokens(placeholders.length).contains(token))
      .toSet();
  if (extraTokens.isNotEmpty) {
    return 'contains unexpected placeholder tokens: ${extraTokens.join(', ')}';
  }
  return null;
}

Map<String, dynamic> _readArbFile(String path) {
  final file = File(path);
  if (!file.existsSync()) {
    throw FileSystemException('Missing file', path);
  }
  return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
}

List<String> _resolveTargetKeys(
  List<String> args, {
  required Map<String, dynamic> englishData,
}) {
  final keys = <String>{};
  for (var i = 0; i < args.length; i += 1) {
    if (args[i] == '--group' && i + 1 < args.length) {
      final group = args[i + 1];
      final prefixes = kLocalizationSurfaceGroups[group];
      if (prefixes == null) continue;
      keys.addAll(
        englishData.keys
            .where((key) => !key.startsWith('@'))
            .where((key) => prefixes.any(key.startsWith)),
      );
    }
    if (args[i] == '--key' && i + 1 < args.length) {
      keys.add(args[i + 1]);
    }
  }
  final ordered = keys.toList(growable: false)..sort();
  return ordered;
}

String? _argValue(List<String> args, String name) {
  for (var i = 0; i < args.length - 1; i += 1) {
    if (args[i] == name) return args[i + 1];
  }
  return null;
}

String? _extractMaskedValue(dynamic raw) {
  if (raw is String) return raw;
  if (raw is Map<String, dynamic>) {
    final translated = raw['translatedMasked'];
    if (translated is String) return translated;
    final maskedEnglish = raw['maskedEnglish'];
    if (maskedEnglish is String) return maskedEnglish;
  }
  return null;
}

String _tokenForIndex(int index) => '__PH_${index}__';

Set<String> _expectedTokens(int count) => {
  for (var i = 0; i < count; i += 1) _tokenForIndex(i),
};

void _printUsage() {
  stdout.writeln(
    'Usage:\n'
    '  dart run tool/localization_masked_translation.dart export '
    '--locale <locale.arb> --out <masked.json> [--group <name>] [--key <key>]\n'
    '  dart run tool/localization_masked_translation.dart import '
    '--locale <locale.arb> --input <masked.json> [--write]',
  );
}

class MaskedImportResult {
  const MaskedImportResult({
    required this.updatedLocaleData,
    required this.updatedKeys,
    required this.failures,
  });

  final Map<String, dynamic> updatedLocaleData;
  final List<String> updatedKeys;
  final List<String> failures;
}
