import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class QuranTeachingTheme {
  const QuranTeachingTheme._();

  static BoxDecoration borderedOptionContainer({
    required BuildContext context,
    required bool selected,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: selected
          ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
          : Colors.transparent,
      border: Border.all(
        color: selected
            ? Theme.of(context).colorScheme.primary
            : context.palette.surfaceSoft,
      ),
    );
  }

  static BoxDecoration feedbackContainer(bool correct) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      color: (correct ? Colors.green : Colors.orange).withValues(alpha: 0.10),
    );
  }
}
