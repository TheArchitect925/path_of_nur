import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('apple entitlements declare iCloud key-value capability', () {
    final files = <String>[
      'ios/Runner/Runner.entitlements',
      'macos/Runner/Release.entitlements',
    ];

    for (final path in files) {
      final content = File(path).readAsStringSync();
      expect(
        content,
        contains('com.apple.developer.ubiquity-kvstore-identifier'),
        reason: path,
      );
    }
  });
}
