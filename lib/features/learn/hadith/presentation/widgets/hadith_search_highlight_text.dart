import 'package:flutter/material.dart';

import '../../application/hadith_search_support.dart';

class HadithSearchHighlightedText extends StatelessWidget {
  const HadithSearchHighlightedText({
    super.key,
    required this.text,
    required this.highlightTerms,
    this.style,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final List<String> highlightTerms;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? DefaultTextStyle.of(context).style;
    final highlightStyle = baseStyle.copyWith(
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.primary,
    );
    final parts = buildHadithSearchHighlightParts(
      text: text,
      highlightTerms: highlightTerms,
    );

    return Text.rich(
      TextSpan(
        children: parts
            .map(
              (part) => TextSpan(
                text: part.text,
                style: part.isHighlighted ? highlightStyle : baseStyle,
              ),
            )
            .toList(growable: false),
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
