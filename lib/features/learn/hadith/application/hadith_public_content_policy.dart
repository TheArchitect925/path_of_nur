import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/hadith_foundation_models.dart';

class HadithPublicContentPolicy {
  const HadithPublicContentPolicy();

  bool allowsDefaultPublicSurfacing(HadithEntry entry) {
    return entry.hasSourceCollectionMetadata &&
        entry.hasSourceReferenceMetadata &&
        entry.hasGradingMetadata &&
        entry.isSourceBacked &&
        entry.hasVerifiedTranslation &&
        entry.hasVerifiedArabicMatn;
  }
}

final hadithPublicContentPolicyProvider = Provider<HadithPublicContentPolicy>(
  (_) => const HadithPublicContentPolicy(),
);
