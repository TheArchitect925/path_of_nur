import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/prayer/prayer_location_search_service.dart';
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
  final Future<List<PrayerLocationSearchResult>> Function(String query) onSearch;

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
        _error = 'Unable to find locations right now.';
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.78,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          child: PremiumCard(
            surfaceAlphaOverride: 0.96,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose location',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF32251D),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use current location',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7A5A33),
                  ),
                ),
                const SizedBox(height: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => Navigator.of(
                    context,
                  ).pop(PrayerLocationPickerSelection.device(
                    label: widget.currentLocationLabel,
                  )),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xFFF6EFE3),
                      border: Border.all(color: const Color(0x28BFAE98)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.my_location_rounded,
                          size: 18,
                          color: Color(0xFF7A5A33),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.currentLocationLabel,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF3C2F25),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Use device',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7A5A33),
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0xFF7A5A33),
                        ),
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
                    hintText: 'Search for a city or place',
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
                    fillColor: const Color(0xFFF7F2E8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.recentLocations.isNotEmpty &&
                    _searchController.text.trim().isEmpty) ...[
                  const Text(
                    'Recent places',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF7A5A33),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...widget.recentLocations.indexed.expand((entry) {
                    final index = entry.$1;
                    final recent = entry.$2;
                    return [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(
                          Icons.history_rounded,
                          color: Color(0xFF7A5A33),
                        ),
                        title: Text(recent.label),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(
                          context,
                        ).pop(PrayerLocationPickerSelection.manual(
                          label: recent.label,
                          latitude: recent.latitude,
                          longitude: recent.longitude,
                        )),
                      ),
                      if (index != widget.recentLocations.length - 1)
                        const Divider(height: 1, color: Color(0x28BFAE98)),
                    ];
                  }),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: _error != null
                      ? Center(
                          child: Text(
                            _error!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFD01919),
                            ),
                          ),
                        )
                      : _results.isEmpty
                      ? const Center(
                          child: Text(
                            'Start typing to search for a location.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6A5A4A),
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _results.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 1, color: Color(0x28BFAE98)),
                          itemBuilder: (context, index) {
                            final result = _results[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(result.label),
                              trailing: const Icon(Icons.chevron_right_rounded),
                              onTap: () => Navigator.of(
                                context,
                              ).pop(PrayerLocationPickerSelection.manual(
                                label: result.label,
                                latitude: result.latitude,
                                longitude: result.longitude,
                              )),
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
