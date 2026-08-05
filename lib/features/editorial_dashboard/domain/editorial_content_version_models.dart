enum EditorialContentType {
  quranExplanation,
  hadithEntry,
  bedtimeStory,
  kidsDuaLesson,
}

class ContentVersion {
  const ContentVersion({
    required this.contentId,
    required this.contentType,
    required this.versionNumber,
    required this.updatedAtIso,
    required this.changeSummary,
    required this.contentSnapshot,
    this.updatedBy,
    this.previousVersionRef,
  });

  final String contentId;
  final EditorialContentType contentType;
  final int versionNumber;
  final String updatedAtIso;
  final String changeSummary;
  final String? updatedBy;
  final String? previousVersionRef;
  final Map<String, dynamic> contentSnapshot;

  String get versionRef => '${contentType.name}:$contentId:v$versionNumber';

  Map<String, dynamic> toJson() => <String, dynamic>{
    'contentId': contentId,
    'contentType': contentType.name,
    'versionNumber': versionNumber,
    'updatedAtIso': updatedAtIso,
    'changeSummary': changeSummary,
    'updatedBy': updatedBy,
    'previousVersionRef': previousVersionRef,
    'contentSnapshot': contentSnapshot,
  };

  static ContentVersion fromJson(Map<String, dynamic> json) {
    final typeName = json['contentType']?.toString() ?? '';
    final type = EditorialContentType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => EditorialContentType.quranExplanation,
    );
    final snapshotRaw = json['contentSnapshot'];
    return ContentVersion(
      contentId: json['contentId']?.toString() ?? '',
      contentType: type,
      versionNumber: int.tryParse(json['versionNumber']?.toString() ?? '') ?? 1,
      updatedAtIso: json['updatedAtIso']?.toString() ?? '',
      changeSummary: json['changeSummary']?.toString() ?? '',
      updatedBy: json['updatedBy']?.toString(),
      previousVersionRef: json['previousVersionRef']?.toString(),
      contentSnapshot: snapshotRaw is Map<String, dynamic>
          ? snapshotRaw
          : snapshotRaw is Map
          ? Map<String, dynamic>.from(snapshotRaw)
          : <String, dynamic>{},
    );
  }
}

class EditorialContentRecord {
  const EditorialContentRecord({
    required this.contentId,
    required this.contentType,
    required this.currentSnapshot,
    required this.versions,
  });

  final String contentId;
  final EditorialContentType contentType;
  final Map<String, dynamic> currentSnapshot;
  final List<ContentVersion> versions;

  ContentVersion? get latestVersion => versions.isEmpty ? null : versions.last;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'contentId': contentId,
    'contentType': contentType.name,
    'currentSnapshot': currentSnapshot,
    'versions': versions
        .map((version) => version.toJson())
        .toList(growable: false),
  };

  static EditorialContentRecord fromJson(Map<String, dynamic> json) {
    final typeName = json['contentType']?.toString() ?? '';
    final type = EditorialContentType.values.firstWhere(
      (value) => value.name == typeName,
      orElse: () => EditorialContentType.quranExplanation,
    );
    final versionsRaw = json['versions'] as List? ?? const <dynamic>[];
    final currentSnapshotRaw = json['currentSnapshot'];
    return EditorialContentRecord(
      contentId: json['contentId']?.toString() ?? '',
      contentType: type,
      currentSnapshot: currentSnapshotRaw is Map<String, dynamic>
          ? currentSnapshotRaw
          : currentSnapshotRaw is Map
          ? Map<String, dynamic>.from(currentSnapshotRaw)
          : <String, dynamic>{},
      versions: versionsRaw
          .whereType<Map>()
          .map((raw) => ContentVersion.fromJson(Map<String, dynamic>.from(raw)))
          .toList(growable: false),
    );
  }
}

class EditorialEditableContentSummary {
  const EditorialEditableContentSummary({
    required this.contentId,
    required this.contentType,
    required this.title,
    required this.subtitle,
    required this.searchText,
    required this.versionCount,
    required this.lastUpdatedIso,
    required this.changeSummary,
  });

  final String contentId;
  final EditorialContentType contentType;
  final String title;
  final String subtitle;
  final String searchText;
  final int versionCount;
  final String? lastUpdatedIso;
  final String? changeSummary;

  bool matchesQuery(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return searchText.contains(normalized);
  }
}
