import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_coloring_provider.dart';
import '../application/kids_arabic_coloring_share_service.dart';
import '../domain/kids_arabic_coloring_models.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/diagnostics/app_telemetry.dart';
import '../../../core/theme/app_icons.dart';
import '../../../core/theme/app_palette.dart';
import '../../../shared/widgets/premium_card.dart';

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
        title: l10n.kidsArabicColoringPagesTitle,
        children: [
          PremiumCard(child: Text(l10n.kidsArabicColoringMissingBody)),
        ],
      );
    }

    if (!page.isUnlocked) {
      return LearnHubPageScaffold(
        title: l10n.kidsArabicColoringPagesTitle,
        children: [PremiumCard(child: Text(l10n.kidsArabicColoringUnlockHint))],
      );
    }

    return LearnHubPageScaffold(
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
        _ShareColoringPageButton(page: page),
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

class _ShareColoringPageButton extends ConsumerStatefulWidget {
  const _ShareColoringPageButton({required this.page});

  final KidsArabicColoringPage page;

  @override
  ConsumerState<_ShareColoringPageButton> createState() =>
      _ShareColoringPageButtonState();
}

class _ShareColoringPageButtonState
    extends ConsumerState<_ShareColoringPageButton> {
  bool _preparing = false;

  Future<void> _share() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    // iPad anchors the share sheet's popover to the button.
    final box = context.findRenderObject() as RenderBox?;
    final origin = box == null
        ? null
        : box.localToGlobal(Offset.zero) & box.size;
    setState(() => _preparing = true);
    try {
      await ref
          .read(kidsArabicColoringShareServiceProvider)
          .share(widget.page, origin: origin);
    } catch (error, stackTrace) {
      AppTelemetry.logError(
        'kids_arabic_coloring_share_failed',
        error: error,
        stackTrace: stackTrace,
        metadata: {'pageId': widget.page.id},
      );
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.kidsArabicColoringShareFailedMessage)),
      );
    } finally {
      if (mounted) setState(() => _preparing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        // Rendering the page takes a moment; a second tap would open a
        // second share sheet.
        onPressed: _preparing ? null : _share,
        icon: const Icon(AppIcons.export),
        label: Text(l10n.kidsArabicColoringShareAction),
      ),
    );
  }
}
