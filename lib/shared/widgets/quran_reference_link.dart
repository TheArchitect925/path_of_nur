import 'package:flutter/material.dart';

import '../../core/theme/app_palette.dart';
import '../../core/theme/app_surfaces.dart';
import '../../features/learn/quran/domain/quran_content_refs.dart';
import 'quran_navigation.dart';

class QuranReferenceLinkTile extends StatelessWidget {
  const QuranReferenceLinkTile({
    super.key,
    required this.referenceLabel,
    required this.surahNumber,
    this.verseRange,
    this.fallbackStartAyah,
    int? endAyahNumber,
    this.subtitle,
    this.onTapOverride,
    this.autoplay = false,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.borderRadius = 12,
    this.showTrailingIcon = true,
  }) : _endAyahNumber = endAyahNumber;

  QuranReferenceLinkTile.forRef({
    super.key,
    required this.referenceLabel,
    required QuranQuoteRef ref,
    this.subtitle,
    this.onTapOverride,
    this.autoplay = false,
    this.margin = const EdgeInsets.only(bottom: 8),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    this.borderRadius = 12,
    this.showTrailingIcon = true,
  }) : surahNumber = ref.surah,
       verseRange = null,
       fallbackStartAyah = ref.ayah,
       _endAyahNumber = ref.ayahEnd;

  final String referenceLabel;
  final int surahNumber;
  final String? verseRange;
  final int? fallbackStartAyah;
  final String? subtitle;
  final VoidCallback? onTapOverride;
  final bool autoplay;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final bool showTrailingIcon;
  final int? _endAyahNumber;

  @override
  Widget build(BuildContext context) {
    final canDeepLink =
        surahNumber > 0 &&
        (_endAyahNumber != null ||
            fallbackStartAyah != null ||
            (verseRange?.trim().isNotEmpty ?? false));

    return Padding(
      padding: margin,
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap:
            onTapOverride ??
            (canDeepLink
                ? () {
                    if (_endAyahNumber != null || fallbackStartAyah != null) {
                      openQuranAt(
                        context,
                        surahNumber: surahNumber,
                        ayahNumber: fallbackStartAyah!,
                        endAyahNumber: _endAyahNumber,
                        autoplay: autoplay,
                      );
                      return;
                    }
                    openQuranReferenceRange(
                      context,
                      surahNumber: surahNumber,
                      verseRange: verseRange,
                      fallbackStartAyah: fallbackStartAyah,
                      autoplay: autoplay,
                    );
                  }
                : null),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: AppSurfaceTheme.adaptiveColor(
              context,
              context.palette.surface,
              alpha: 0.25,
              solidAlphaWhenDisabled: 0.96,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppSurfaceTheme.adaptiveColor(
                context,
                context.palette.accentSoft,
                alpha: 0.28,
                solidAlphaWhenDisabled: 0.40,
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      referenceLabel,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
                      const SizedBox(height: 3),
                      Text(subtitle!),
                    ],
                  ],
                ),
              ),
              if (showTrailingIcon) ...[
                const SizedBox(width: 8),
                const Icon(Icons.open_in_new_rounded, size: 18),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
