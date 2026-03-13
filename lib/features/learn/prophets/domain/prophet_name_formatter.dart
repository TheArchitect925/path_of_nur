String prophetHonorific(String name) {
  final normalized = _prophetBaseName(name).toLowerCase();
  if (normalized == 'muhammad') return 'ﷺ';
  return 'عليه السلام';
}

String prophetBaseName(String name) => _prophetBaseName(name);

String formatProphetName(String name, {bool includeTitle = false}) {
  final baseName = _prophetBaseName(name);
  final blessing = prophetHonorific(baseName);
  final formatted = '$baseName $blessing';
  if (!includeTitle) return formatted;
  return 'Prophet $formatted';
}

String formatProphetArabicName(String arabicName, String fallbackName) {
  final blessing = prophetHonorific(fallbackName);
  final normalized = arabicName
      .replaceAll('ﷺ', '')
      .replaceAll('عليه السلام', '')
      .trim();
  if (normalized.isEmpty) return blessing;
  return '$normalized $blessing';
}

String _prophetBaseName(String name) {
  return name
      .replaceAll('ﷺ', '')
      .replaceAll('عليه السلام', '')
      .replaceAll('Prophet ', '')
      .trim();
}
