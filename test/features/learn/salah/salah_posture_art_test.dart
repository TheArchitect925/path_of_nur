import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/learn/salah/models/salah_trainer_models.dart';
import 'package:path_of_nur/features/learn/salah/widgets/salah_posture_art.dart';

/// The guided step card leads with a posture scene, so every posture the
/// flow can show needs its file, inside the art budget, and the folder must
/// be declared or nothing ships.
void main() {
  test('every posture has a distinct scene on disk inside the budget', () {
    final seen = <String>{};
    for (final posture in PrayerPostureType.values) {
      final asset = salahPostureArtAsset(posture);
      expect(seen.add(asset), isTrue, reason: '$asset is shared');
      final file = File(asset);
      expect(file.existsSync(), isTrue, reason: '$asset is missing');
      expect(
        file.lengthSync(),
        lessThanOrEqualTo(120 * 1024),
        reason: '$asset is over the 120 KB art budget',
      );
    }
  });

  test('the folder is declared in pubspec', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    expect(pubspec, contains('- assets/images/salah_art/'));
  });
}
