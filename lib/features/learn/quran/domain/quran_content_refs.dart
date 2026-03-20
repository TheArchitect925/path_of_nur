class QuranVerseRef {
  const QuranVerseRef({required this.surah, required this.ayah})
    : assert(surah > 0),
      assert(ayah > 0);

  final int surah;
  final int ayah;

  String get id => '$surah:$ayah';

  @override
  bool operator ==(Object other) {
    return other.runtimeType == runtimeType &&
        other is QuranVerseRef &&
        other.surah == surah &&
        other.ayah == ayah;
  }

  @override
  int get hashCode => Object.hash(runtimeType, surah, ayah);
}

class QuranQuoteRef extends QuranVerseRef {
  const QuranQuoteRef({required super.surah, required super.ayah, this.ayahEnd})
    : assert(ayahEnd == null || ayahEnd >= ayah);

  final int? ayahEnd;

  String get locationLabel {
    if (ayahEnd != null && ayahEnd != ayah) {
      return 'Qur’an $surah:$ayah-$ayahEnd';
    }
    return 'Qur’an $surah:$ayah';
  }

  @override
  bool operator ==(Object other) {
    return other is QuranQuoteRef &&
        other.surah == surah &&
        other.ayah == ayah &&
        other.ayahEnd == ayahEnd;
  }

  @override
  int get hashCode => Object.hash(runtimeType, surah, ayah, ayahEnd);
}

class QuranAudioRef extends QuranVerseRef {
  const QuranAudioRef({
    required super.surah,
    required super.ayah,
    required this.reciterId,
  }) : assert(reciterId != '');

  final String reciterId;

  @override
  bool operator ==(Object other) {
    return other is QuranAudioRef &&
        other.surah == surah &&
        other.ayah == ayah &&
        other.reciterId == reciterId;
  }

  @override
  int get hashCode => Object.hash(runtimeType, surah, ayah, reciterId);
}

class QuranQuoteContent {
  const QuranQuoteContent({
    required this.ref,
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });

  final QuranQuoteRef ref;
  final String arabic;
  final String transliteration;
  final String translation;

  String get locationLabel => ref.locationLabel;
}
