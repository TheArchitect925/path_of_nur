import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../learn/presentation/widgets/learn_hub_page_scaffold.dart';
import '../application/kids_arabic_coloring_provider.dart';
import 'kids_arabic_localized_content.dart';
import '../../../core/theme/app_palette.dart';

class KidsArabicColoringPagesPage extends ConsumerWidget {
  const KidsArabicColoringPagesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pages = ref.watch(kidsArabicColoringPagesProvider);
    final unlockedCount = pages.where((page) => page.isUnlocked).length;

    return LearnHubPageScaffold(
      title: l10n.kidsArabicColoringPagesTitle,
      subtitle: l10n.kidsArabicColoringPagesSubtitle,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.palette.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: context.palette.surfaceSoft),
          ),
          child: Text(
            l10n.kidsArabicColoringPagesProgressValue(
              unlockedCount,
              pages.length,
            ),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: context.palette.onSurface,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pages.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.84,
          ),
          itemBuilder: (context, index) {
            final page = pages[index];
            return InkWell(
              onTap: page.isUnlocked
                  ? () => context.pushNamed(
                      'kidsArabicColoringViewer',
                      pathParameters: {'pageId': page.id},
                    )
                  : null,
              borderRadius: BorderRadius.circular(22),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: page.isUnlocked
                      ? context.palette.surface
                      : const Color(0xFFF3EFE9),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: page.isUnlocked
                        ? context.palette.surfaceSoft
                        : const Color(0xFFE6DDD2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: context.palette.surfaceSoft,
                          ),
                        ),
                        child: Icon(
                          Icons.image_outlined,
                          size: 44,
                          color: context.palette.onSurfaceSubtle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      localizedKidsArabicColoringTitle(l10n, page.titleKey),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: context.palette.onSurface,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      page.isUnlocked
                          ? l10n.kidsArabicColoringUnlockedLabel
                          : l10n.kidsArabicColoringUnlockHint,
                      style: TextStyle(
                        color: page.isUnlocked
                            ? context.palette.successInk
                            : context.palette.onSurfaceSubtle,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
