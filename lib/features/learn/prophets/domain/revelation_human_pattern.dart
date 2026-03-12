class RevelationHumanPattern {
  const RevelationHumanPattern({
    required this.id,
    required this.title,
    required this.summary,
    this.prophetIds = const <String>[],
  });

  final String id;
  final String title;
  final String summary;
  final List<String> prophetIds;
}
