import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:path_of_nur/features/kids_arabic/application/kids_arabic_coloring_share_service.dart';
import 'package:path_of_nur/features/kids_arabic/data/kids_arabic_coloring_pages_data.dart';

const _pngSignature = [0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A];

/// Width and height from a PNG's IHDR chunk.
(int, int) _pngSize(Uint8List png) {
  final header = ByteData.sublistView(png, 16, 24);
  return (header.getUint32(0), header.getUint32(4));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // A fresh bundle, so no widget test's fake-async asset load is shared.
  final service = KidsArabicColoringShareService(bundle: PlatformAssetBundle());

  test('every coloring page renders to an A4 PNG at 300 dpi', () async {
    for (final page in kidsArabicColoringPages) {
      final png = await service.renderPng(page);
      expect(png.sublist(0, 8), _pngSignature, reason: page.id);
      expect(_pngSize(png), (2480, 3508), reason: page.id);
    }
  });

  test('the rendered page is black line art on white', () async {
    final page = kidsArabicColoringPages.first;
    final png = await service.renderPng(page);
    final codec = await ui.instantiateImageCodec(png);
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final pixels = (await image.toByteData())!;

    int luminanceAt(int x, int y) {
      final offset = (y * image.width + x) * 4;
      return pixels.getUint8(offset) +
          pixels.getUint8(offset + 1) +
          pixels.getUint8(offset + 2);
    }

    expect(luminanceAt(0, 0), 3 * 255, reason: 'the corner is paper');
    // alif_coloring.svg strokes its letter down x = 620 from y = 360.
    expect(luminanceAt(1240, 1400), 0, reason: 'the letter is inked');
    image.dispose();
    codec.dispose();
  });

  test('the shared file is named after its letter', () {
    expect(
      kidsArabicColoringPages.map(KidsArabicColoringShareService.fileName),
      [
        'alif-coloring-page.png',
        'ba-coloring-page.png',
        'meem-coloring-page.png',
        'noon-coloring-page.png',
        'seen-coloring-page.png',
      ],
    );
  });
}
