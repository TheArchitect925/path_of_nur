import 'dart:ui' as ui;

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/kids_arabic_coloring_models.dart';

final kidsArabicColoringShareServiceProvider =
    Provider<KidsArabicColoringShareService>((ref) {
      return KidsArabicColoringShareService(bundle: rootBundle);
    });

/// Hands a coloring page to the platform share sheet as a printable PNG.
///
/// The pages are SVGs drawn at A4 and 150 dpi. An SVG cannot be printed from
/// the iOS share sheet or saved to Photos, so the page is rendered on white at
/// [printScale] times that size (300 dpi) first. iOS offers Print in the
/// sheet; Android offers the installed apps; a browser without the Web Share
/// API downloads the file.
class KidsArabicColoringShareService {
  const KidsArabicColoringShareService({required this.bundle});

  final AssetBundle bundle;

  static const double printScale = 2;

  Future<void> share(KidsArabicColoringPage page, {Rect? origin}) async {
    final png = await renderPng(page);
    await Share.shareXFiles(<XFile>[
      XFile.fromData(png, mimeType: 'image/png', name: fileName(page)),
    ], sharePositionOrigin: origin);
  }

  Future<Uint8List> renderPng(KidsArabicColoringPage page) async {
    final data = await bundle.load(page.assetPath);
    final svg = await vg.loadPicture(
      SvgBytesLoader(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
      ),
      null,
    );
    final width = (svg.size.width * printScale).round();
    final height = (svg.size.height * printScale).round();

    final recorder = ui.PictureRecorder();
    ui.Canvas(recorder)
      ..drawRect(
        Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
        ui.Paint()..color = Colors.white,
      )
      ..scale(printScale)
      ..drawPicture(svg.picture);
    final picture = recorder.endRecording();
    svg.picture.dispose();

    final image = await picture.toImage(width, height);
    picture.dispose();
    try {
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) {
        throw StateError('PNG encoding failed for ${page.assetPath}');
      }
      return bytes.buffer.asUint8List();
    } finally {
      image.dispose();
    }
  }

  /// `alif-coloring-page.png`: what the file is called once it leaves the app.
  static String fileName(KidsArabicColoringPage page) =>
      '${page.letterId}-coloring-page.png';
}
