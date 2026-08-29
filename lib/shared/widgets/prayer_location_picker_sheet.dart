import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../../core/prayer/prayer_location_search_service.dart';
import 'display/compact_list_tile.dart';
import 'display/hub_list_group.dart';
import 'premium_card.dart';

class PrayerLocationPickerSheet extends StatefulWidget {
  const PrayerLocationPickerSheet({
    super.key,
    required this.currentLocationLabel,
    required this.recentLocations,
    required this.onSearch,
  });

  final String currentLocationLabel;
  final List<PrayerRecentLocation> recentLocations;
  final Future<List<PrayerLocationSearchResult>> Function(String query)
  onSearch;

  @override
  State<PrayerLocationPickerSheet> createState() =>
      _PrayerLocationPickerSheetState();
}

class _PrayerLocationPickerSheetState extends State<PrayerLocationPickerSheet> {
  static const _searchDebounce = Duration(milliseconds: 350);

  late final TextEditingController _searchController;
  Timer? _searchDebounceTimer;
  bool _isLoading = false;
  String? _error;
  List<PrayerLocationSearchResult> _results = const [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _searchDebounceTimer?.cancel();
    final query = value.trim();
    if (query.length < 2) {
      setState(() {
        _results = const [];
        _error = null;
        _isLoading = false;
      });
      return;
    }
    _searchDebounceTimer = Timer(_searchDebounce, () {
      _submitSearch(query);
    });
  }

  Future<void> _submitSearch([String? overrideQuery]) async {
    final query = (overrideQuery ?? _searchController.text).trim();
    final l10n = AppLocalizations.of(context);
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await widget.onSearch(query);
      if (!mounted) return;
      setState(() => _results = results);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = const [];
        _error = l10n.worshipPrayerLocationSearchUnavailable;
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Every colour here used to be a light-theme literal, so the whole sheet
    // stayed cream on Midnight, Ramadan and the other night themes.
    final theme = Theme.of(context);
    final appearance = theme.extension<AppAppearanceTheme>();
    final accent = appearance?.accent ?? theme.colorScheme.primary;
    final onSurface = theme.colorScheme.onSurface;
    final subtle =
        appearance?.onSurfaceSubtle ?? theme.colorScheme.onSurfaceVariant;
    final divider = theme.dividerColor.withValues(alpha: 0.30);
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.78,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: PremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.worshipPrayerChooseLocationTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.worshipPrayerUseCurrentLocationTitle,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: accent,
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(context).pop(
                    PrayerLocationPickerSelection.device(
                      label: widget.currentLocationLabel,
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: accent.withValues(alpha: 0.10),
                      border: Border.all(color: accent.withValues(alpha: 0.22)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.my_location_rounded,
                          size: 18,
                          color: accent,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.currentLocationLabel,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.worshipPrayerUseDeviceAction,
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: accent,
                          ),
                        ),
                        Icon(Icons.chevron_right_rounded, color: accent),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: _onQueryChanged,
                  onSubmitted: (value) => _submitSearch(value),
                  decoration: InputDecoration(
                    hintText: l10n.worshipPrayerSearchLocationHint,
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : IconButton(
                            onPressed: _submitSearch,
                            icon: const Icon(Icons.arrow_forward_rounded),
                          ),
                    filled: true,
                    fillColor:
                        appearance?.inputSurface ??
                        theme.colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.recentLocations.isNotEmpty &&
                    _searchController.text.trim().isEmpty) ...[
                  Text(
                    l10n.worshipPrayerRecentPlacesTitle,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: accent,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ...widget.recentLocations.map(
                    (recent) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
                      child: CompactListTile(
                        title: recent.label,
                        leading: const HubLeadingIcon(Icons.history_rounded),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          size: 20,
                        ),
                        onTap: () => Navigator.of(context).pop(
                          PrayerLocationPickerSelection.manual(
                            label: recent.label,
                            latitude: recent.latitude,
                            longitude: recent.longitude,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                ],
                Expanded(
                  child: _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        )
                      : _results.isEmpty
                      ? Center(
                          child: Text(
                            l10n.worshipPrayerStartTypingToSearch,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: subtle,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _results.length,
                          separatorBuilder: (context, index) =>
                              Divider(height: 1, color: divider),
                          itemBuilder: (context, index) {
                            final result = _results[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(result.label),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => Navigator.of(context).pop(
                                PrayerLocationPickerSelection.manual(
                                  label: result.label,
                                  latitude: result.latitude,
                                  longitude: result.longitude,
                                ),
                              ),
                            );
                          },
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
