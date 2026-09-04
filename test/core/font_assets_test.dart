import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// Guards against a font asset being replaced by something that is not a font.
///
/// Three of the bundled Arabic faces were once HTML error pages saved with a
/// `.ttf` extension by a failed download. Flutter bundles them without
/// complaint and silently falls back to another face at runtime, so nothing
/// but a reader of the raw bytes catches it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // sfnt wrappers Flutter accepts: TrueType outlines, the legacy Apple tag,
  // TrueType collections, and CFF outlines.
  const sfntMagics = <List<int>>[
    [0x00, 0x01, 0x00, 0x00],
    [0x74, 0x72, 0x75, 0x65], // 'true'
    [0x74, 0x74, 0x63, 0x66], // 'ttcf'
    [0x4F, 0x54, 0x54, 0x4F], // 'OTTO'
  ];

  final assets = _declaredFontAssets();

  test('pubspec declares font assets', () {
    expect(assets, isNotEmpty);
  });

  _familyLiteralGuard();

  for (final asset in assets) {
    test('$asset is a real font', () async {
      final file = File(asset);
      expect(file.existsSync(), isTrue, reason: '$asset is missing');

      final bytes = file.readAsBytesSync();
      expect(bytes.length, greaterThan(4), reason: '$asset is empty');

      final header = bytes.sublist(0, 4);
      expect(
        sfntMagics.any((magic) => _startsWith(header, magic)),
        isTrue,
        reason:
            '$asset does not begin with an sfnt signature — got '
            '${header.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}',
      );

      // Magic bytes alone would still pass on a truncated or corrupt table
      // directory, so hand the whole file to the engine's own parser.
      await ui.loadFontFromList(
        Uint8List.fromList(bytes),
        fontFamily: 'assert-parses-$asset',
      );
    });
  }
}

bool _startsWith(List<int> bytes, List<int> prefix) {
  for (var i = 0; i < prefix.length; i++) {
    if (bytes[i] != prefix[i]) return false;
  }
  return true;
}

/// Every `- asset:` path under the `flutter: fonts:` section of the pubspec.
List<String> _declaredFontAssets() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  final assets = <String>[];
  var inFonts = false;

  for (final line in lines) {
    final trimmed = line.trim();
    if (trimmed == 'fonts:' && line.startsWith('  fonts:')) {
      inFonts = true;
      continue;
    }
    if (!inFonts) continue;

    // The fonts block ends at the next key indented at or above its own level.
    if (trimmed.isNotEmpty &&
        !trimmed.startsWith('#') &&
        !trimmed.startsWith('-') &&
        !line.startsWith('   ')) {
      break;
    }

    final match = RegExp(r'-\s*asset:\s*(\S+)').firstMatch(trimmed);
    if (match != null) assets.add(match.group(1)!);
  }
  return assets;
}

/// A font family referenced by name must actually be declared in pubspec —
/// Flutter renders unknown families in the system fallback without a word.
/// 43 call sites once wrote 'AmiriQuran' where pubspec declares 'Amiri Quran'
/// and every one silently lost the Qur'an face.
void _familyLiteralGuard() {
  test('every fontFamily string literal names a declared family', () {
    final declared = _declaredFontFamilies();
    expect(declared, contains('Amiri Quran'));
    final offenders = <String>[];
    final libDir = Directory('lib');
    final pattern = RegExp("fontFamily:\\s*'([^']+)'");
    for (final entity in libDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final content = entity.readAsStringSync();
      for (final match in pattern.allMatches(content)) {
        final family = match.group(1)!;
        if (!declared.contains(family)) {
          offenders.add('${entity.path}: $family');
        }
      }
    }
    expect(
      offenders,
      isEmpty,
      reason:
          'These fontFamily literals do not match any pubspec family and '
          'will silently render in the system fallback. Use the AppFonts '
          'constants.',
    );
  });
}

Set<String> _declaredFontFamilies() {
  final lines = File('pubspec.yaml').readAsLinesSync();
  final families = <String>{};
  for (final line in lines) {
    final match = RegExp(r'-\s*family:\s*(.+)$').firstMatch(line.trim());
    if (match != null) families.add(match.group(1)!.trim());
  }
  return families;
}

