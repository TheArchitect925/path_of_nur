import 'package:flutter/material.dart';
import 'global_background.dart';
import 'quran_quote_block.dart';

class AppPageScaffold extends StatelessWidget {
  const AppPageScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    this.quote,
    this.headerIcon,
    this.onQuoteTap,
    required this.children,
  });

  final String title;
  final String subtitle;
  final QuranQuote? quote;
  final IconData? headerIcon;
  final ValueChanged<QuranQuote>? onQuoteTap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);
    return Stack(
      children: [
        const GlobalBackground(),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                if (canPop || headerIcon != null)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (canPop)
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.chevron_left),
                          color: const Color(0xFF3A3026),
                        ),
                      if (canPop && headerIcon != null) const SizedBox(width: 4),
                      if (headerIcon != null)
                        Icon(
                          headerIcon,
                          color: const Color(0xFF3A3026),
                          size: 24,
                        ),
                      if (headerIcon != null) const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 6),
                            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 6),
                      Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                const SizedBox(height: 12),
                if (quote != null) ...[
                  const SizedBox(height: 12),
                  QuranQuoteBlock(
                    quote: quote!,
                    onTap: onQuoteTap == null
                        ? null
                        : () => onQuoteTap!(quote!),
                  ),
                ],
                const SizedBox(height: 20),
                ...children,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
