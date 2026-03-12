import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/premium_card.dart';

class LearningHeader extends StatelessWidget {
  const LearningHeader({
    super.key,
    required this.title,
    this.arabicTitle,
    required this.summary,
    this.chips = const <String>[],
    this.trailing,
  });

  final String title;
  final String? arabicTitle;
  final String summary;
  final List<String> chips;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return PremiumCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    if (arabicTitle?.trim().isNotEmpty ?? false)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          arabicTitle!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: AppColors.onSurfaceSubtle),
                        ),
                      ),
                  ],
                ),
              ),
              ...(trailing == null ? const <Widget>[] : <Widget>[trailing!]),
            ],
          ),
          if (chips.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: chips.map(_chip).toList(growable: false),
            ),
          ],
          if (summary.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(summary),
          ],
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.26),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.accentGoldSoft.withValues(alpha: 0.30),
        ),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12)),
    );
  }
}
