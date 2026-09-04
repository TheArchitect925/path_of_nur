import 'package:flutter/material.dart';

import '../../../../../core/theme/app_spacing.dart';

/// Body for the counter screens: a column that fills the viewport and gives
/// its flexible middle (the tap zone) whatever is left. Short viewports are
/// reported as [compact] so the fixed parts above and below shrink first;
/// the bottom padding clears the floating tab bar.
class DhikrPageBody extends StatelessWidget {
  const DhikrPageBody({super.key, required this.builder});

  /// Builds the column's children; [compact] is true when the viewport is
  /// too short for the full-size phrase header.
  final List<Widget> Function(BuildContext context, bool compact) builder;

  static const double _compactBelow = 700;

  @override
  Widget build(BuildContext context) {
    final bottomClearance =
        AppSpacing.navHeight +
        AppSpacing.xl +
        MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      bottom: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < _compactBelow;
          return Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.pagePadding,
              AppSpacing.xs,
              AppSpacing.pagePadding,
              bottomClearance,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: builder(context, compact),
            ),
          );
        },
      ),
    );
  }
}
