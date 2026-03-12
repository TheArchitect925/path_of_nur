class CoreMessageItem {
  const CoreMessageItem({
    required this.id,
    required this.text,
    this.emphasisLevel = 1,
  });

  final String id;
  final String text;
  final int emphasisLevel;
}
