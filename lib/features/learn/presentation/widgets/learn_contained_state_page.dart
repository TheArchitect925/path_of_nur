import 'package:flutter/material.dart';

import '../../../../shared/widgets/premium_card.dart';
import 'learn_hub_page_scaffold.dart';

class LearnContainedStatePage extends StatelessWidget {
  const LearnContainedStatePage({
    super.key,
    required this.headerIcon,
    required this.title,
    required this.subtitle,
    required this.body,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final IconData headerIcon;
  final String title;
  final String subtitle;
  final String body;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    return LearnHubPageScaffold(
      headerIcon: headerIcon,
      title: title,
      subtitle: subtitle,
      children: [
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                body,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.4),
              ),
              if (primaryActionLabel != null || secondaryActionLabel != null)
                const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  if (primaryActionLabel != null)
                    FilledButton.icon(
                      onPressed: onPrimaryAction,
                      icon: const Icon(Icons.menu_book_rounded),
                      label: Text(primaryActionLabel!),
                    ),
                  if (secondaryActionLabel != null)
                    FilledButton.tonalIcon(
                      onPressed: onSecondaryAction,
                      icon: const Icon(Icons.auto_stories_rounded),
                      label: Text(secondaryActionLabel!),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
