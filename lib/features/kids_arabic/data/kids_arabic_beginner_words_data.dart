import 'package:flutter/material.dart';

import '../../arabic/data/arabic_beginner_content_catalog.dart';
import '../../arabic/data/arabic_alphabet_catalog.dart';
import '../application/kids_arabic_starter_tracing.dart';
import '../domain/kids_arabic_word_models.dart';

const kidsArabicBeginnerWordOrderIds = <String>['bab', 'noor', 'qalam'];

final List<KidsArabicBeginnerWord> kidsArabicBeginnerWords =
    <KidsArabicBeginnerWord>[
      KidsArabicBeginnerWord(
        id: 'bab',
        wordAr: arabicSharedBeginnerWordById('bab')!.arabicText,
        transliteration: arabicSharedBeginnerWordById('bab')!.transliteration,
        letterIds: arabicSharedBeginnerWordById('bab')!.letterIds,
        requiredCompletedLetterIds: const <String>{'ba', 'alif'},
        guide: const KidsArabicTracingGuide(
          letterId: 'bab',
          minimumEffortPoints: 52,
          completedThreshold: 0.44,
          goodThreshold: 0.66,
          excellentThreshold: 0.84,
          proximityThreshold: 0.12,
          strokes: <KidsArabicGuideStroke>[
            KidsArabicGuideStroke.path(
              points: <Offset>[
                Offset(0.82, 0.44),
                Offset(0.76, 0.50),
                Offset(0.70, 0.58),
                Offset(0.64, 0.64),
                Offset(0.60, 0.64),
                Offset(0.58, 0.52),
                Offset(0.57, 0.38),
                Offset(0.56, 0.24),
                Offset(0.55, 0.18),
                Offset(0.54, 0.34),
                Offset(0.52, 0.54),
                Offset(0.48, 0.68),
                Offset(0.42, 0.70),
                Offset(0.36, 0.70),
                Offset(0.30, 0.66),
                Offset(0.24, 0.60),
                Offset(0.18, 0.52),
              ],
            ),
            KidsArabicGuideStroke.dot(center: Offset(0.73, 0.78)),
            KidsArabicGuideStroke.dot(center: Offset(0.27, 0.78)),
          ],
        ),
        joiningExamples: _sharedJoiningExamplesForWord(const <String>[
          'ba',
          'alif',
          'ba',
        ]),
      ),
      KidsArabicBeginnerWord(
        id: 'noor',
        wordAr: arabicSharedBeginnerWordById('noor')!.arabicText,
        transliteration: arabicSharedBeginnerWordById('noor')!.transliteration,
        letterIds: arabicSharedBeginnerWordById('noor')!.letterIds,
        requiredCompletedLetterIds: const <String>{'noon'},
        guide: const KidsArabicTracingGuide(
          letterId: 'noor',
          minimumEffortPoints: 46,
          completedThreshold: 0.44,
          goodThreshold: 0.66,
          excellentThreshold: 0.84,
          proximityThreshold: 0.12,
          strokes: <KidsArabicGuideStroke>[
            KidsArabicGuideStroke.path(
              points: <Offset>[
                Offset(0.80, 0.40),
                Offset(0.74, 0.46),
                Offset(0.66, 0.54),
                Offset(0.58, 0.58),
                Offset(0.50, 0.56),
                Offset(0.46, 0.48),
                Offset(0.44, 0.40),
                Offset(0.46, 0.48),
                Offset(0.50, 0.58),
                Offset(0.46, 0.64),
                Offset(0.38, 0.66),
                Offset(0.30, 0.62),
                Offset(0.22, 0.56),
                Offset(0.16, 0.50),
              ],
            ),
            KidsArabicGuideStroke.dot(center: Offset(0.70, 0.26)),
          ],
        ),
        joiningExamples: _sharedJoiningExamplesForWord(const <String>[
          'noon',
          'waw',
          'ra',
        ]),
      ),
      KidsArabicBeginnerWord(
        id: 'qalam',
        wordAr: arabicSharedBeginnerWordById('qalam')!.arabicText,
        transliteration: arabicSharedBeginnerWordById('qalam')!.transliteration,
        letterIds: arabicSharedBeginnerWordById('qalam')!.letterIds,
        requiredCompletedLetterIds: const <String>{'lam', 'meem'},
        guide: const KidsArabicTracingGuide(
          letterId: 'qalam',
          minimumEffortPoints: 58,
          completedThreshold: 0.44,
          goodThreshold: 0.66,
          excellentThreshold: 0.84,
          proximityThreshold: 0.12,
          strokes: <KidsArabicGuideStroke>[
            KidsArabicGuideStroke.path(
              points: <Offset>[
                Offset(0.82, 0.40),
                Offset(0.76, 0.34),
                Offset(0.68, 0.34),
                Offset(0.60, 0.40),
                Offset(0.56, 0.50),
                Offset(0.58, 0.62),
                Offset(0.60, 0.50),
                Offset(0.60, 0.34),
                Offset(0.56, 0.20),
                Offset(0.52, 0.34),
                Offset(0.48, 0.54),
                Offset(0.42, 0.70),
                Offset(0.36, 0.72),
                Offset(0.30, 0.70),
                Offset(0.24, 0.66),
                Offset(0.18, 0.60),
                Offset(0.14, 0.52),
              ],
            ),
            KidsArabicGuideStroke.dot(center: Offset(0.74, 0.18)),
            KidsArabicGuideStroke.dot(center: Offset(0.64, 0.16)),
          ],
        ),
        joiningExamples: _sharedJoiningExamplesForWord(const <String>[
          'qaf',
          'lam',
          'meem',
        ]),
      ),
    ];

List<KidsArabicJoiningExample> _sharedJoiningExamplesForWord(
  List<String> letterIds,
) {
  final resolvedForms = resolveArabicLetterSequenceForms(letterIds);
  return resolvedForms
      .map(
        (item) => KidsArabicJoiningExample(
          letterId: item.letterId,
          standaloneGlyph: item.isolatedGlyph,
          joinedGlyph: item.displayGlyph,
        ),
      )
      .toList(growable: false);
}

KidsArabicBeginnerWord? kidsArabicBeginnerWordById(String id) {
  for (final word in kidsArabicBeginnerWords) {
    if (word.id == id) {
      return word;
    }
  }
  return null;
}
