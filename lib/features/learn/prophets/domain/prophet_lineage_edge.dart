enum LineageRelationshipType {
  fatherChild,
  descendantLine,
  familyLine,
  householdConnection,
}

class ProphetLineageEdge {
  const ProphetLineageEdge({
    required this.fromProphetId,
    required this.toProphetId,
    required this.relationshipType,
  });

  final String fromProphetId;
  final String toProphetId;
  final LineageRelationshipType relationshipType;
}
