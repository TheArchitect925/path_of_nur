import 'package:flutter/material.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../shared/widgets/display/art_header_card.dart';
import '../../../learn/presentation/widgets/learn_hub_page_scaffold.dart';

/// The page shell for everything a child opens.
///
/// It is the Learn hub scaffold (so the floating mini-player contract and
/// the header anatomy stay the app's) with one kids-specific rule: a page
/// opens on a picture, not on a paragraph. [heroAsset] paints a 16:9 scene
/// under the header before any card, and [heroTitle] rests on it. The
/// daylight palette and the rounded kids type come from the theme, which
/// `app.dart` switches to `AppThemeMode.noorKids` whenever the kids UI is
/// active, so a page built on this shell needs no colour or font of its own.
class KidsPageScaffold extends StatelessWidget {
  const KidsPageScaffold({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.headerIcon,
    this.headerActions,
    this.heroAsset,
    this.heroTitle,
    this.heroSubtitle,
    this.heroEyebrow,
    this.onHeroTap,
    this.floatingBottom,
  });

  final String title;
  final String? subtitle;
  final IconData? headerIcon;
  final List<Widget>? headerActions;

  /// A 16:9 scene from `assets/images/learn_art` or a story cover.
  final String? heroAsset;
  final String? heroTitle;
  final String? heroSubtitle;
  final String? heroEyebrow;
  final VoidCallback? onHeroTap;

  final Widget? floatingBottom;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      title: title,
      subtitle: subtitle,
      headerIcon: headerIcon,
      headerActions: headerActions,
      floatingBottom: floatingBottom,
      children: [
        if (heroAsset != null) ...[
          ArtHeaderCard(
            imageAsset: heroAsset!,
            title: heroTitle ?? title,
            subtitle: heroSubtitle,
            eyebrow: heroEyebrow,
            fallbackIcon: headerIcon ?? AppIcons.kids,
            fallbackColor: Theme.of(context).colorScheme.primary,
            aspectRatio: 16 / 9,
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            onTap: onHeroTap,
          ),
          const SizedBox(height: 14),
        ],
        ...children,
      ],
    );
  }
}
