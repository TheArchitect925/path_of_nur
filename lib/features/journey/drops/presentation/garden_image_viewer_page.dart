import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../domain/garden_asset_paths.dart';
import '../domain/journey_drops_models.dart';
import 'widgets/garden_gallery.dart';

class GardenImageViewerPage extends StatelessWidget {
  const GardenImageViewerPage({super.key, required this.milestone});

  final GardenMilestone milestone;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final countFormat = NumberFormat.decimalPattern(locale);
    final title = gardenTitleForKey(l10n, milestone.titleKey);
    final description = gardenDescriptionForKey(l10n, milestone.descriptionKey);

    return Scaffold(
      backgroundColor: const Color(0xFF120F0C),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: const Color(0xFFF7F1E8),
        title: Text(title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(28),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Color(0xFF1E1915)),
                    child: Image.asset(
                      gardenImageAssetPath(milestone.imageAsset),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const _GardenViewerFallback();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: const Color(0xFFF7F1E8),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(
                  color: Color(0xFFD5C6B4),
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.gardenGalleryRequiresValue(
                  countFormat.format(milestone.requiredDrops),
                ),
                style: const TextStyle(
                  color: Color(0xFFF0D8A0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GardenViewerFallback extends StatelessWidget {
  const _GardenViewerFallback();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2A241D), Color(0xFF5E6E50)],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.local_florist_rounded,
          size: 72,
          color: Color(0xFFF0D8A0),
        ),
      ),
    );
  }
}
