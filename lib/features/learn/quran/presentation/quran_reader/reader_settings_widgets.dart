part of '../quran_reader_page.dart';

class _SettingsGroupCard extends StatelessWidget {
  const _SettingsGroupCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final surface = appearance?.surfaceSoft ?? theme.colorScheme.surface;
    final foreground = appearance?.onSurface ?? theme.colorScheme.onSurface;
    final subtle =
        appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurfaceVariant;
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: accent.withValues(alpha: 0.20)),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: foreground,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, height: 1.35, color: subtle),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SettingsSubsectionLabel extends StatelessWidget {
  const _SettingsSubsectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color:
              appearance?.onSurfaceSubtle ??
              Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ScaleControl extends StatelessWidget {
  const _ScaleControl({
    required this.label,
    required this.percent,
    required this.onChanged,
  });

  final String label;
  final int percent;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label ($percent%)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color:
                appearance?.onSurfaceSubtle ??
                Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Slider(
          min: 85,
          max: 140,
          divisions: 11,
          value: percent.toDouble(),
          onChanged: (value) => onChanged(value.round()),
        ),
      ],
    );
  }
}

/// The localized display name of a reading level, shared by the chip, the
/// picker sheet, and the seeded-level toast.
String quranReaderLevelTitle(AppLocalizations l10n, QuranReaderLevel level) {
  return switch (level) {
    QuranReaderLevel.newReader => l10n.quranReaderLevelNewReaderTitle,
    QuranReaderLevel.learning => l10n.quranReaderLevelLearningTitle,
    QuranReaderLevel.fluent => l10n.quranReaderLevelFluentTitle,
  };
}

/// Header pill showing the active reading level; icon-only until a level
/// exists. Opens the level picker sheet.
class _ReaderLevelChip extends StatelessWidget {
  const _ReaderLevelChip({
    required this.level,
    required this.tooltip,
    required this.label,
    required this.onTap,
  });

  final QuranReaderLevel? level;
  final String tooltip;
  final String? label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chipLabel = label;
    if (chipLabel == null) {
      return IconButton(
        key: const ValueKey('quran-reader-level-chip'),
        tooltip: tooltip,
        onPressed: onTap,
        icon: const Icon(Icons.tune_rounded),
        color: const Color(0xFF3A3026),
      );
    }
    return Tooltip(
      message: tooltip,
      child: Material(
        key: const ValueKey('quran-reader-level-chip'),
        color: const Color(0xFFF3E8DA),
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          borderRadius: BorderRadius.circular(999),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.tune_rounded,
                  size: 15,
                  color: Color(0xFF6A5A4A),
                ),
                const SizedBox(width: 5),
                Text(
                  chipLabel,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3A3026),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// One selectable level in the picker sheet.
class _ReaderLevelOptionTile extends StatelessWidget {
  const _ReaderLevelOptionTile({
    super.key,
    required this.title,
    required this.body,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String body;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final surface = appearance?.surfaceSoft ?? theme.colorScheme.surface;
    final foreground = appearance?.onSurface ?? theme.colorScheme.onSurface;
    final subtle =
        appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurfaceVariant;
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    return Material(
      color: surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected ? accent : accent.withValues(alpha: 0.20),
          width: selected ? 1.6 : 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: foreground,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      body,
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: subtle,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected) ...[
                const SizedBox(width: 8),
                Icon(Icons.check_circle_rounded, color: accent, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
