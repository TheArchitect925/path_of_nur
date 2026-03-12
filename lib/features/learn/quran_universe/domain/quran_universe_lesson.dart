class UniverseLesson {
  const UniverseLesson({
    required this.id,
    required this.title,
    required this.summary,
    this.relatedGrowthHabitIds = const <String>[],
  });

  final String id;
  final String title;
  final String summary;
  final List<String> relatedGrowthHabitIds;
}
