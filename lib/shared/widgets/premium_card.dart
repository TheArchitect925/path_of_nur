import 'package:flutter/material.dart';
import 'dart:ui';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';

class PremiumCard extends StatelessWidget {
  const PremiumCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.card),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.8, sigmaY: 4.8),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(AppRadii.card),
            border: Border.all(
              color: AppColors.accentGoldSoft.withValues(alpha: 0.34),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x22000000),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
