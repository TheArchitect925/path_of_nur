class RevelationJourneyProgress {
  const RevelationJourneyProgress({
    this.startedEraIds = const <String>{},
    this.completedEraIds = const <String>{},
    this.openedProphetIds = const <String>{},
    this.completedEraQuizIds = const <String>{},
    this.lastVisitedEraId,
    this.lastVisitedProphetId,
  });

  final Set<String> startedEraIds;
  final Set<String> completedEraIds;
  final Set<String> openedProphetIds;
  final Set<String> completedEraQuizIds;
  final String? lastVisitedEraId;
  final String? lastVisitedProphetId;

  RevelationJourneyProgress copyWith({
    Set<String>? startedEraIds,
    Set<String>? completedEraIds,
    Set<String>? openedProphetIds,
    Set<String>? completedEraQuizIds,
    String? lastVisitedEraId,
    bool clearLastVisitedEra = false,
    String? lastVisitedProphetId,
    bool clearLastVisitedProphet = false,
  }) {
    return RevelationJourneyProgress(
      startedEraIds: startedEraIds ?? this.startedEraIds,
      completedEraIds: completedEraIds ?? this.completedEraIds,
      openedProphetIds: openedProphetIds ?? this.openedProphetIds,
      completedEraQuizIds: completedEraQuizIds ?? this.completedEraQuizIds,
      lastVisitedEraId: clearLastVisitedEra
          ? null
          : (lastVisitedEraId ?? this.lastVisitedEraId),
      lastVisitedProphetId: clearLastVisitedProphet
          ? null
          : (lastVisitedProphetId ?? this.lastVisitedProphetId),
    );
  }
}
