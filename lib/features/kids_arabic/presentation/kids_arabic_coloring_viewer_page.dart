import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_coloring_provider.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicColoringViewerPage extends ConsumerWidget {
  const KidsArabicColoringViewerPage({super.key, required this.pageId});

  final String pageId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pages = ref.watch(kidsArabicColoringPagesProvider);
    final matches = pages.where((item) => item.id == pageId);
    final page = matches.isEmpty ? null : matches.first;

    if (page == null) {
      return LearnHubPageScaffold(
        headerIcon: Icons.format_paint_rounded,
        title: l10n.kidsArabicColoringMissingTitle,
        subtitle: l10n.kidsArabicColoringMissingSubtitle,
        children: [Text(l10n.kidsArabicColoringMissingBody)],
      );
    }

    if (!page.isUnlocked) {
      return LearnHubPageScaffold(
        headerIcon: Icons.lock_outline_rounded,
        title: l10n.kidsArabicColoringLockedTitle,
        subtitle: l10n.kidsArabicColoringLockedSubtitle,
        children: [Text(l10n.kidsArabicColoringUnlockHint)],
      );
    }

    return LearnHubPageScaffold(
      headerIcon: Icons.format_paint_rounded,
      title: localizedKidsArabicColoringTitle(l10n, page.titleKey),
      subtitle: l10n.kidsArabicColoringViewerSubtitle,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.palette.surfaceSoft),
          ),
          child: AspectRatio(
            aspectRatio: 0.707,
            child: Container(
              color: Colors.white,
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: SvgPicture.asset(page.assetPath, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: page.assetPath));
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.kidsArabicColoringAssetCopiedMessage),
                ),
              );
            },
            icon: const Icon(Icons.copy_rounded),
            label: Text(l10n.kidsArabicColoringOpenAssetAction),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.kidsArabicColoringViewerHint,
          style: TextStyle(
            color: context.palette.onSurfaceSubtle,
            height: 1.35,
          ),
        ),
      ],
    );
  }
}
