class HadithCollectionSubcategorySummary {
  const HadithCollectionSubcategorySummary({
    required this.id,
    required this.title,
    required this.entryCount,
  });

  final String id;
  final String title;
  final int entryCount;
}

class HadithCollectionBrowseSummary {
  const HadithCollectionBrowseSummary({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.entryCount,
    required this.subcategories,
  });

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final int entryCount;
  final List<HadithCollectionSubcategorySummary> subcategories;
}
