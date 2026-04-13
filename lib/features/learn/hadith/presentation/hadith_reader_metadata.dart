import '../../../../l10n/app_localizations.dart';
import '../domain/hadith_foundation_models.dart';

String formatHadithReferenceForDisplay(
  AppLocalizations l10n,
  HadithEntry entry,
) {
  final reference = (entry.displaySourceReference ?? '').trim();
  if (reference.isEmpty) return '';
  if (RegExp(r'^\d+$').hasMatch(reference)) {
    return l10n.hadithReferenceHadithNumber(reference);
  }
  return reference;
}

String formatHadithSourceChapterForDisplay(
  AppLocalizations l10n,
  HadithEntry entry,
) {
  final chapterNumber = entry.normalizedSourceChapterNumber;
  final chapterTitle = entry.normalizedSourceChapterTitle?.trim();
  if (chapterNumber == null && (chapterTitle == null || chapterTitle.isEmpty)) {
    return '';
  }

  final numberLabel = chapterNumber == null
      ? null
      : l10n.hadithSourceBrowseChapterNumber(chapterNumber);
  if (numberLabel != null &&
      chapterTitle != null &&
      chapterTitle.isNotEmpty &&
      chapterTitle.toLowerCase() != numberLabel.toLowerCase()) {
    return '$numberLabel • $chapterTitle';
  }
  return chapterTitle?.isNotEmpty == true ? chapterTitle! : numberLabel ?? '';
}

String? formatHadithChapterPositionForDisplay(
  AppLocalizations l10n, {
  required int current,
  required int total,
}) {
  if (current <= 0 || total <= 0 || current > total) return null;
  return l10n.hadithReaderChapterPosition(current, total);
}

String formatHadithSourceProvenanceForDisplay(
  AppLocalizations l10n,
  HadithEntry entry,
) {
  return switch (entry.sourceMetadata.provenance) {
    HadithSourceProvenance.seeded => l10n.hadithProvenanceSeeded,
    HadithSourceProvenance.editorialOverride =>
      l10n.hadithProvenanceEditorialOverride,
    HadithSourceProvenance.imported => l10n.hadithProvenanceImported,
    HadithSourceProvenance.unknown => l10n.hadithProvenanceUnknown,
  };
}

String? formatHadithImportSourceForDisplay(
  AppLocalizations l10n,
  HadithEntry entry,
) {
  final importSource = entry.sourceMetadata.importSource?.trim();
  if (importSource == null || importSource.isEmpty) return null;
  final humanized = importSource
      .replaceAll('_', ' ')
      .replaceAll('-', ' ')
      .split(RegExp(r'\s+'))
      .where((part) => part.isNotEmpty)
      .map((part) => '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
  if (humanized.isEmpty) return null;
  return l10n.hadithProvenancePipelineValue(humanized);
}
