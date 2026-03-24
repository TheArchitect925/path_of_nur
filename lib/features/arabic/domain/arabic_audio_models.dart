class ArabicLetterAudioManifestEntry {
  const ArabicLetterAudioManifestEntry({
    required this.canonicalLetterId,
    required this.legacyQuranTeachingSeedId,
    required this.assetPath,
    required this.spokenTextAr,
    required this.kidsLabel,
    required this.adultLabel,
    this.alternateAssetPaths = const <String>[],
  });

  final String canonicalLetterId;
  final String legacyQuranTeachingSeedId;
  final String assetPath;
  final String spokenTextAr;
  final String kidsLabel;
  final String adultLabel;
  final List<String> alternateAssetPaths;
}
