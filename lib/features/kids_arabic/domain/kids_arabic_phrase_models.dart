class KidsArabicMiniPhrase {
  const KidsArabicMiniPhrase({
    required this.id,
    required this.phraseAr,
    required this.transliteration,
  });

  final String id;
  final String phraseAr;
  final String transliteration;
}

class KidsArabicMiniPhraseProgressState {
  const KidsArabicMiniPhraseProgressState({
    required this.heardPhraseIds,
    this.lastPhraseId,
  });

  final Set<String> heardPhraseIds;
  final String? lastPhraseId;

  KidsArabicMiniPhraseProgressState copyWith({
    Set<String>? heardPhraseIds,
    String? lastPhraseId,
    bool clearLastPhraseId = false,
  }) {
    return KidsArabicMiniPhraseProgressState(
      heardPhraseIds: heardPhraseIds ?? this.heardPhraseIds,
      lastPhraseId: clearLastPhraseId ? null : (lastPhraseId ?? this.lastPhraseId),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'heardPhraseIds': heardPhraseIds.toList(growable: false),
    'lastPhraseId': lastPhraseId,
  };

  static KidsArabicMiniPhraseProgressState initial() =>
      const KidsArabicMiniPhraseProgressState(
        heardPhraseIds: <String>{},
        lastPhraseId: null,
      );

  static KidsArabicMiniPhraseProgressState fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return initial();
    }
    final heardPhraseIds = json['heardPhraseIds'] is List
        ? (json['heardPhraseIds'] as List)
              .map((item) => item.toString())
              .toSet()
        : <String>{};
    return KidsArabicMiniPhraseProgressState(
      heardPhraseIds: heardPhraseIds,
      lastPhraseId: json['lastPhraseId']?.toString(),
    );
  }
}
