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
