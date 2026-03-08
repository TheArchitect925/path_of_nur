import 'package:flutter/material.dart';

class GlobalBackground extends StatelessWidget {
  const GlobalBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/backgrounds/bg_v1.png',
        fit: BoxFit.cover,
        color: const Color(0xFFEDE6DE).withValues(alpha: 0.65),
        colorBlendMode: BlendMode.srcATop,
        errorBuilder: (context, error, stackTrace) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEDE6DE), Color(0xFFE2D8CC)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
    );
  }
}
