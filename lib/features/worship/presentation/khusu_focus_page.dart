import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/application/special_mode_provider.dart';
import '../../../shared/content/page_description_copy.dart';
import '../../../shared/widgets/app_page_scaffold.dart';

class KhusuFocusPage extends ConsumerWidget {
  const KhusuFocusPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = Theme.of(context).extension<AppAppearanceTheme>();
    final isKidsMode = ref.watch(
      specialModeProvider.select((mode) => mode.isKids),
    );
    final foreground =
        appearance?.backgroundForeground ?? const Color(0xFF3C2F25);
    final subtleForeground =
        appearance?.backgroundForegroundSubtle ?? const Color(0xFF6A5A4A);
    return AppPageScaffold(
      headerIcon: Icons.self_improvement_rounded,
      title: 'Khusū',
      subtitle: localizedAppPageDescription(
        context,
        AppPageDescriptionKey.khusuFocus,
        kidsMode: isKidsMode,
      ),
      children: [
        const SizedBox(height: 52),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Khusū',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                  color: foreground,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'A silent and sacred space for focused presence.',
                textAlign: TextAlign.center,
                style: TextStyle(color: subtleForeground, fontSize: 16),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  'Breathe slowly. Choose intention over momentum. Keep one sentence, one invocation, one pause at a time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: subtleForeground, height: 1.45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
