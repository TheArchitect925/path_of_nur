import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Every screen is laid out for a phone. In a wide browser window the web
/// build keeps the app at phone width, centred, instead of stretching each
/// card across the screen. Phones and native builds are left untouched.
class WebPhoneFrame extends StatelessWidget {
  const WebPhoneFrame({super.key, required this.child});

  static const double width = 480;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) return child;
    final media = MediaQuery.of(context);
    if (media.size.width <= width + 96) return child;
    final background = Theme.of(context).scaffoldBackgroundColor;
    return ColoredBox(
      color: Color.alphaBlend(
        Colors.black.withValues(alpha: 0.12),
        background.withValues(alpha: 1),
      ),
      child: Center(
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 32,
              ),
            ],
          ),
          child: ClipRect(
            child: SizedBox(
              width: width,
              child: MediaQuery(
                data: media.copyWith(size: Size(width, media.size.height)),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
