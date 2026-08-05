enum LearnDomainType { quran, life, world, hadith, notes }

enum LearnUnifiedStatus { notStarted, inProgress, completed }

enum LearnCompletionQuality { notRead, read, reflected, applied }

enum LearnTrackType { beginner, family, character, ramadan, revert }

class LearnUnifiedLessonRef {
  const LearnUnifiedLessonRef({
    required this.domain,
    required this.lessonId,
    required this.title,
    required this.subtitle,
    required this.routeName,
    required this.pathParameters,
    this.queryParameters = const <String, String>{},
    this.lastOpened,
    required this.status,
    this.quality = LearnCompletionQuality.notRead,
  });

  final LearnDomainType domain;
  final String lessonId;
  final String title;
  final String subtitle;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final DateTime? lastOpened;
  final LearnUnifiedStatus status;
  final LearnCompletionQuality quality;

  LearnUnifiedLessonRef copyWith({
    DateTime? lastOpened,
    LearnUnifiedStatus? status,
    LearnCompletionQuality? quality,
  }) {
    return LearnUnifiedLessonRef(
      domain: domain,
      lessonId: lessonId,
      title: title,
      subtitle: subtitle,
      routeName: routeName,
      pathParameters: pathParameters,
      queryParameters: queryParameters,
      lastOpened: lastOpened ?? this.lastOpened,
      status: status ?? this.status,
      quality: quality ?? this.quality,
    );
  }
}

class LearnDomainProgressSummary {
  const LearnDomainProgressSummary({
    required this.domain,
    required this.totalLessons,
    required this.inProgressLessons,
    required this.completedLessons,
  });

  final LearnDomainType domain;
  final int totalLessons;
  final int inProgressLessons;
  final int completedLessons;

  double get completionRatio {
    if (totalLessons == 0) return 0;
    return (completedLessons / totalLessons).clamp(0.0, 1.0);
  }
}

class LearnUnifiedSummary {
  const LearnUnifiedSummary({
    required this.continueItem,
    required this.suggestedNextItem,
    required this.recentItems,
    required this.featuredItems,
    required this.domainProgress,
    required this.overallTotalLessons,
    required this.overallInProgressLessons,
    required this.overallCompletedLessons,
    required this.selectedTrack,
    required this.trackTitle,
    required this.continueReason,
  });

  final LearnUnifiedLessonRef? continueItem;
  final LearnUnifiedLessonRef? suggestedNextItem;
  final List<LearnUnifiedLessonRef> recentItems;
  final List<LearnUnifiedLessonRef> featuredItems;
  final List<LearnDomainProgressSummary> domainProgress;
  final int overallTotalLessons;
  final int overallInProgressLessons;
  final int overallCompletedLessons;
  final LearnTrackType selectedTrack;
  final String trackTitle;
  final String continueReason;

  double get overallCompletionRatio {
    if (overallTotalLessons == 0) return 0;
    return (overallCompletedLessons / overallTotalLessons).clamp(0.0, 1.0);
  }
}

class LearnCitation {
  const LearnCitation({
    required this.sourceTitle,
    required this.qualityBadge,
    required this.confidenceNote,
    this.reference,
  });

  final String sourceTitle;
  final String qualityBadge;
  final String confidenceNote;
  final String? reference;
}

class LearnContentBundle {
  const LearnContentBundle({
    required this.id,
    required this.title,
    required this.description,
    required this.version,
    required this.installed,
    required this.sizeLabel,
    required this.futureRemoteCompatible,
  });

  final String id;
  final String title;
  final String description;
  final int version;
  final bool installed;
  final String sizeLabel;
  final bool futureRemoteCompatible;

  LearnContentBundle copyWith({int? version, bool? installed}) {
    return LearnContentBundle(
      id: id,
      title: title,
      description: description,
      version: version ?? this.version,
      installed: installed ?? this.installed,
      sizeLabel: sizeLabel,
      futureRemoteCompatible: futureRemoteCompatible,
    );
  }
}
