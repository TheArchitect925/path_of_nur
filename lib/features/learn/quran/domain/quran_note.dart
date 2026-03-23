class QuranNote {
  const QuranNote({
    required this.id,
    required this.surahNumber,
    required this.ayahNumber,
    required this.text,
    required this.createdAtIso,
    this.tags = const [],
    this.folder = 'General',
    this.categoryId,
    this.isHighlight = false,
    this.highlightLabel,
  });

  final String id;
  final int surahNumber;
  final int ayahNumber;
  final String text;
  final String createdAtIso;
  final List<String> tags;
  final String folder;
  final String? categoryId;
  final bool isHighlight;
  final String? highlightLabel;

  Map<String, dynamic> toJson() => {
    'id': id,
    'surahNumber': surahNumber,
    'ayahNumber': ayahNumber,
    'text': text,
    'createdAtIso': createdAtIso,
    'tags': tags,
    'folder': folder,
    'categoryId': categoryId,
    'isHighlight': isHighlight,
    'highlightLabel': highlightLabel,
  };

  static QuranNote? fromJson(dynamic json) {
    if (json is! Map) return null;
    final id = json['id']?.toString();
    final surah = json['surahNumber'];
    final ayah = json['ayahNumber'];
    final text = json['text']?.toString();
    final createdAtIso = json['createdAtIso']?.toString();
    if (id == null ||
        surah is! int ||
        ayah is! int ||
        text == null ||
        createdAtIso == null) {
      return null;
    }
    final tagsRaw = json['tags'];
    final tags = tagsRaw is List
        ? tagsRaw
              .map((item) => item.toString().trim())
              .where((item) => item.isNotEmpty)
              .toList()
        : const <String>[];
    return QuranNote(
      id: id,
      surahNumber: surah,
      ayahNumber: ayah,
      text: text,
      createdAtIso: createdAtIso,
      tags: tags,
      folder: json['folder']?.toString().trim().isNotEmpty == true
          ? json['folder'].toString().trim()
          : 'General',
      categoryId: json['categoryId']?.toString(),
      isHighlight: json['isHighlight'] == true,
      highlightLabel: json['highlightLabel']?.toString(),
    );
  }
}
