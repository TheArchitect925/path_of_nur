import '../../learn/presentation/models/learn_hub_models.dart';

enum EditorialRelationDomain { quran, hadith, dua, worldCreation, learnContent }

enum EditorialRelationType {
  explains,
  reinforces,
  sameTheme,
  relatedPractice,
  relatedDua,
  relatedCreationSign,
  sameLesson,
  readerFollowUp,
}

enum EditorialRelationOrigin {
  seededEditorial,
  quranGraph,
  duaSourceAnchor,
  worldVerseAnchor,
}

class EditorialRelationContentRef {
  const EditorialRelationContentRef({required this.domain, required this.id});

  const EditorialRelationContentRef.quran(this.id)
    : domain = EditorialRelationDomain.quran;

  const EditorialRelationContentRef.hadith(this.id)
    : domain = EditorialRelationDomain.hadith;

  const EditorialRelationContentRef.dua(this.id)
    : domain = EditorialRelationDomain.dua;

  const EditorialRelationContentRef.worldCreation(this.id)
    : domain = EditorialRelationDomain.worldCreation;

  const EditorialRelationContentRef.learnContent(this.id)
    : domain = EditorialRelationDomain.learnContent;

  final EditorialRelationDomain domain;
  final String id;

  String get stableKey => '${domain.name}:$id';

  @override
  bool operator ==(Object other) {
    return other is EditorialRelationContentRef &&
        other.domain == domain &&
        other.id == id;
  }

  @override
  int get hashCode => Object.hash(domain, id);
}

class EditorialRelationEntry {
  const EditorialRelationEntry({
    required this.source,
    required this.target,
    required this.type,
    required this.origin,
    this.editorialLabel,
    this.editorialNote,
    this.editorialConfidence,
  });

  final EditorialRelationContentRef source;
  final EditorialRelationContentRef target;
  final EditorialRelationType type;
  final EditorialRelationOrigin origin;
  final String? editorialLabel;
  final String? editorialNote;
  final double? editorialConfidence;

  String get id => '${source.stableKey}->${type.name}->${target.stableKey}';

  bool connects(EditorialRelationContentRef ref) {
    return source == ref || target == ref;
  }

  EditorialRelationContentRef? counterpartFor(EditorialRelationContentRef ref) {
    if (source == ref) return target;
    if (target == ref) return source;
    return null;
  }
}

class EditorialResolvedRelationLink {
  const EditorialResolvedRelationLink({
    required this.relationId,
    required this.relationType,
    required this.origin,
    required this.domain,
    required this.targetId,
    required this.title,
    required this.routeName,
    this.subtitle,
    this.pathParameters = const <String, String>{},
    this.queryParameters = const <String, String>{},
    this.referenceId,
    this.editorialLabel,
    this.editorialNote,
  });

  final String relationId;
  final EditorialRelationType relationType;
  final EditorialRelationOrigin origin;
  final EditorialRelationDomain domain;
  final String targetId;
  final String title;
  final String? subtitle;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final String? referenceId;
  final String? editorialLabel;
  final String? editorialNote;
}

class EditorialResolvedLearnTarget {
  const EditorialResolvedLearnTarget({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.routeTarget,
  });

  final String id;
  final String title;
  final String subtitle;
  final LearnHubRouteTarget routeTarget;
}
