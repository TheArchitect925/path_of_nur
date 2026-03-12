class ProphetLineageNode {
  const ProphetLineageNode({
    required this.prophetId,
    required this.name,
    required this.arabicName,
    required this.parentIds,
    required this.childIds,
    required this.eraTitle,
    this.lineageLabel,
    this.spouseLabel,
    this.shortSummary,
    this.regionLabel,
    this.sortOrder = 0,
  });

  final String prophetId;
  final String name;
  final String arabicName;
  final String? lineageLabel;
  final List<String> parentIds;
  final List<String> childIds;
  final String? spouseLabel;
  final String? shortSummary;
  final String eraTitle;
  final String? regionLabel;
  final int sortOrder;
}

class PropheticLineageGroup {
  const PropheticLineageGroup({
    required this.id,
    required this.title,
    required this.summary,
    required this.rootProphetId,
    required this.nodeIdsInDisplayOrder,
    this.lineageLabel,
    this.isFeatured = true,
  });

  final String id;
  final String title;
  final String summary;
  final String rootProphetId;
  final List<String> nodeIdsInDisplayOrder;
  final String? lineageLabel;
  final bool isFeatured;
}
