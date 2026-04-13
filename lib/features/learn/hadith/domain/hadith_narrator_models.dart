import 'hadith_foundation_models.dart';

enum HadithNarratorRole { companion, motherOfBelievers, scholarCompanion }

enum HadithNarratorSummaryKind {
  abuHurairah,
  aishah,
  abdullahIbnUmar,
  anasIbnMalik,
  jabirIbnAbdullah,
  abdullahIbnAbbas,
}

class HadithNarratorProfile {
  const HadithNarratorProfile({
    required this.id,
    required this.displayName,
    required this.role,
    required this.summaryKind,
    this.aliases = const <String>[],
    this.matchAliases = const <String>[],
  });

  final String id;
  final String displayName;
  final HadithNarratorRole role;
  final HadithNarratorSummaryKind summaryKind;
  final List<String> aliases;
  final List<String> matchAliases;
}

class HadithNarratorDetail {
  const HadithNarratorDetail({
    required this.id,
    required this.displayName,
    required this.profile,
    required this.entries,
    required this.aliases,
    required this.sourceTitles,
    required this.themeTitles,
    required this.collectionTitles,
  });

  final String id;
  final String displayName;
  final HadithNarratorProfile? profile;
  final List<HadithEntry> entries;
  final List<String> aliases;
  final List<String> sourceTitles;
  final List<String> themeTitles;
  final List<String> collectionTitles;

  int get hadithCount => entries.length;
  int get sourceCount => sourceTitles.length;
  int get themeCount => themeTitles.length;
  int get collectionCount => collectionTitles.length;
  bool get hasCuratedProfile => profile != null;
}
