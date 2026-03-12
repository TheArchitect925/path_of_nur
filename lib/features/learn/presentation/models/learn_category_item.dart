class LearnCategoryItem {
  const LearnCategoryItem({
    required this.id,
    required this.title,
    required this.iconKey,
    required this.routeName,
    required this.searchKeywords,
    required this.tags,
    required this.sectionType,
    this.pathParameters = const {},
    this.queryParameters = const {},
    this.description,
    this.accentStyle,
    this.categoryGroup = 'general',
  });

  final String id;
  final String title;
  final String iconKey;
  final String routeName;
  final Map<String, String> pathParameters;
  final Map<String, String> queryParameters;
  final List<String> searchKeywords;
  final List<String> tags;
  final String sectionType;
  final String? description;
  final String? accentStyle;
  final String categoryGroup;
}
