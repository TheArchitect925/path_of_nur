import 'package:flutter/widgets.dart';

import '../domain/quran_surah_summary_background_spec.dart';

const String _kSurahSummaryBackgroundAssetBase =
    'assets/images/quran/surah_summary_backgrounds';

const Map<int, QuranSurahSummaryBackgroundSpec>
kQuranSurahSummaryBackgroundSpecs = <int, QuranSurahSummaryBackgroundSpec>{
  1: QuranSurahSummaryBackgroundSpec(
    surahNumber: 1,
    surahKey: 'al-fatiha',
    themeTitle: 'Opening Light',
    visualPrompt:
        'Soft watercolor abstract spiritual opening, first light through mist, subtle path of guidance, mercy and welcome, calm warm neutrals, gentle gold glow, parchment softness, minimal, elegant, atmospheric depth, no humans, no animals, no text, no symbols, no UI.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/001.webp',
    alignment: Alignment(0, -0.18),
    opacity: 0.16,
  ),
  2: QuranSurahSummaryBackgroundSpec(
    surahNumber: 2,
    surahKey: 'al-baqarah',
    themeTitle: 'Grounded Vastness',
    visualPrompt:
        'Soft watercolor abstract grounded landscape, vast earth tones, expansive horizon, foundation, law, protection, subtle divine light over textured earth, restrained gold warmth, calm and weighty atmosphere, minimal, elegant, no humans, no animals, no text, no literal objects.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/002.webp',
    alignment: Alignment.center,
    opacity: 0.16,
  ),
  3: QuranSurahSummaryBackgroundSpec(
    surahNumber: 3,
    surahKey: 'aal-e-imran',
    themeTitle: 'Uplifted Trust',
    visualPrompt:
        'Soft watercolor spiritual sky, uplifting light through layered clouds, faith under trial, divine help, trust, blue gray and warm gold tones, gentle upward movement, calm reflective atmosphere, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/003.webp',
    alignment: Alignment(0, -0.24),
    opacity: 0.17,
  ),
  4: QuranSurahSummaryBackgroundSpec(
    surahNumber: 4,
    surahKey: 'an-nisa',
    themeTitle: 'Balanced Dignity',
    visualPrompt:
        'Soft watercolor abstract symmetry, justice, balance, dignity, order, gentle strength, refined warm neutrals with subtle bronze lines, calm structural rhythm, restrained sacred atmosphere, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/004.webp',
    alignment: Alignment.center,
    opacity: 0.15,
  ),
  5: QuranSurahSummaryBackgroundSpec(
    surahNumber: 5,
    surahKey: 'al-maidah',
    themeTitle: 'Provision And Covenant',
    visualPrompt:
        'Soft watercolor symbolic provision and covenant, nourishment and gratitude suggested through layered circular and table-like forms without literal objects, gentle golden light, calm cream and stone tones, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/005.webp',
    alignment: Alignment(0, 0.08),
    opacity: 0.15,
  ),
  6: QuranSurahSummaryBackgroundSpec(
    surahNumber: 6,
    surahKey: 'al-anam',
    themeTitle: 'Signs Of Creation',
    visualPrompt:
        'Soft watercolor signs of creation, layered sky and earth, reflective atmosphere, divine order, subtle transitions between land and heavens, calm natural tones with restrained light, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/006.webp',
    alignment: Alignment(0, -0.1),
    opacity: 0.16,
  ),
  7: QuranSurahSummaryBackgroundSpec(
    surahNumber: 7,
    surahKey: 'al-araf',
    themeTitle: 'Threshold Horizons',
    visualPrompt:
        'Soft watercolor elevated horizon, thresholds and heights, separation, warning and hope, atmospheric distance, layered ridgelines, soft light through mist, calm editorial composition, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/007.webp',
    alignment: Alignment(0, -0.16),
    opacity: 0.17,
  ),
  8: QuranSurahSummaryBackgroundSpec(
    surahNumber: 8,
    surahKey: 'al-anfal',
    themeTitle: 'Resolved Reliance',
    visualPrompt:
        'Soft watercolor atmosphere of resolve and supported struggle, quiet strength, directional light, restrained earth and bronze tones, calm intensity, subtle sense of forward reliance without battle imagery, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/008.webp',
    alignment: Alignment(0.1, -0.06),
    opacity: 0.15,
  ),
  9: QuranSurahSummaryBackgroundSpec(
    surahNumber: 9,
    surahKey: 'at-tawbah',
    themeTitle: 'Moral Clarity',
    visualPrompt:
        'Soft watercolor moral clarity, truth cutting through haze, subtle separation of shadow and light, sincerity, repentance, return, minimal layered forms, warm neutrals with firm gold light, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/009.webp',
    alignment: Alignment(0, -0.08),
    opacity: 0.15,
  ),
  10: QuranSurahSummaryBackgroundSpec(
    surahNumber: 10,
    surahKey: 'yunus',
    themeTitle: 'Calm Return',
    visualPrompt:
        'Soft watercolor calm journey atmosphere, patience and trust after distress, subtle horizon and sea-inspired tranquility used abstractly, gentle light after heaviness, muted blue gray and warm sand tones, minimal, elegant, no humans, no animals, no text.',
    assetPath: '$_kSurahSummaryBackgroundAssetBase/010.webp',
    alignment: Alignment(0, 0.04),
    opacity: 0.17,
  ),
};

const List<int> kQuranSurahSummaryBackgroundRolloutOrder = <int>[
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
];

const Set<int> kQuranSurahSummaryBackgroundReadyNumbers = <int>{};
