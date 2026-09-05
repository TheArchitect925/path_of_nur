import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// The legal-page goldens are rasterized on macOS and compared on macOS, but
/// sub-pixel text anti-aliasing still differs slightly between the machine
/// that generated a baseline and the CI runner: a 0.01% (366px of 2.9M)
/// difference failed the build while the same commit matched exactly
/// locally. Allow a small tolerance so that noise does not gate merges,
/// while keeping the goldens meaningful — a real layout or colour
/// regression moves whole percentages, far above this bar.
const double _goldenTolerance = 0.001; // 0.1% of pixels

class _TolerantGoldenComparator extends LocalFileComparator {
  _TolerantGoldenComparator(super.testFile);

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) async {
    final result = await GoldenFileComparator.compareLists(
      imageBytes,
      await getGoldenBytes(golden),
    );
    if (result.passed || result.diffPercent <= _goldenTolerance) {
      result.dispose();
      return true;
    }
    final error = await generateFailureOutput(result, golden, basedir);
    result.dispose();
    throw FlutterError(error);
  }
}

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  final defaultComparator = goldenFileComparator as LocalFileComparator;
  goldenFileComparator = _TolerantGoldenComparator(
    Uri.parse('${defaultComparator.basedir}test.dart'),
  );
  await testMain();
}
