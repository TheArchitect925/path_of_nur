enum ArabicLetterDisplayForm { isolated, initial, medial, finalForm }

class ArabicLetterJoiningBehavior {
  const ArabicLetterJoiningBehavior({
    required this.joinsToPrevious,
    required this.joinsToNext,
  });

  final bool joinsToPrevious;
  final bool joinsToNext;
}

class ArabicLetterPositionalForms {
  const ArabicLetterPositionalForms({
    required this.isolated,
    this.initial,
    this.medial,
    this.finalForm,
  });

  final String isolated;
  final String? initial;
  final String? medial;
  final String? finalForm;

  String glyphForDisplayForm(ArabicLetterDisplayForm form) {
    switch (form) {
      case ArabicLetterDisplayForm.isolated:
        return isolated;
      case ArabicLetterDisplayForm.initial:
        return initial ?? isolated;
      case ArabicLetterDisplayForm.medial:
        return medial ?? initial ?? finalForm ?? isolated;
      case ArabicLetterDisplayForm.finalForm:
        return finalForm ?? isolated;
    }
  }
}

class ArabicResolvedLetterForm {
  const ArabicResolvedLetterForm({
    required this.letterId,
    required this.isolatedGlyph,
    required this.displayGlyph,
    required this.displayForm,
    required this.joinsFromPrevious,
    required this.joinsToNext,
  });

  final String letterId;
  final String isolatedGlyph;
  final String displayGlyph;
  final ArabicLetterDisplayForm displayForm;
  final bool joinsFromPrevious;
  final bool joinsToNext;
}

class ArabicAlphabetLetter {
  const ArabicAlphabetLetter({
    required this.id,
    required this.order,
    required this.glyph,
    required this.nameAr,
    required this.kidsNameEn,
    required this.adultNameEn,
    required this.kidsTransliteration,
    required this.adultTransliteration,
    required this.soundHint,
    required this.supportsTracing,
    required this.quranTeachingSeedId,
    required this.quranTeachingAudioAssetPath,
    required this.positionalForms,
    required this.joiningBehavior,
  });

  final String id;
  final int order;
  final String glyph;
  final String nameAr;
  final String kidsNameEn;
  final String adultNameEn;
  final String kidsTransliteration;
  final String adultTransliteration;
  final String soundHint;
  final bool supportsTracing;
  final String quranTeachingSeedId;
  final String quranTeachingAudioAssetPath;
  final ArabicLetterPositionalForms positionalForms;
  final ArabicLetterJoiningBehavior joiningBehavior;
}
