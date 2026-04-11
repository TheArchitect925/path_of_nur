import 'package:flutter/material.dart';

TextSpan buildQuranTextWithColoredHarakat(
  String text,
  TextStyle baseStyle, {
  Color? harakatColor = const Color(0xFFC22A2A),
}) {
  final spans = <InlineSpan>[];
  for (final rune in text.runes) {
    final char = String.fromCharCode(rune);
    spans.add(
      TextSpan(
        text: char,
        style: _isArabicDiacritic(rune) && harakatColor != null
            ? baseStyle.merge(TextStyle(color: harakatColor))
            : baseStyle,
      ),
    );
  }
  return TextSpan(children: spans);
}

TextSpan buildQuranTextWithColoredHarakatHighlights(
  String text,
  TextStyle baseStyle, {
  required Set<String> highlightedWords,
  Color? harakatColor = const Color(0xFFC22A2A),
  TextStyle? highlightedWordStyle,
}) {
  final words = text.split(RegExp(r'(\s+)'));
  if (highlightedWords.isEmpty || words.isEmpty) {
    return buildQuranTextWithColoredHarakat(
      text,
      baseStyle,
      harakatColor: harakatColor,
    );
  }

  final children = <InlineSpan>[];
  for (final chunk in words) {
    if (chunk.isEmpty) {
      continue;
    }
    if (chunk.trim().isEmpty) {
      children.add(TextSpan(text: chunk, style: baseStyle));
      continue;
    }
    final style = highlightedWords.contains(chunk)
        ? (highlightedWordStyle ?? baseStyle)
        : baseStyle;
    children.add(
      buildQuranTextWithColoredHarakat(
        chunk,
        style,
        harakatColor: harakatColor,
      ),
    );
  }

  return TextSpan(style: baseStyle, children: children);
}

bool _isArabicDiacritic(int rune) {
  return (rune >= 0x064B && rune <= 0x065F) ||
      rune == 0x0670 ||
      rune == 0x06D6 ||
      rune == 0x06D7 ||
      rune == 0x06D8 ||
      rune == 0x06D9 ||
      rune == 0x06DA ||
      rune == 0x06DB ||
      rune == 0x06DC ||
      rune == 0x06DF ||
      rune == 0x06E0 ||
      rune == 0x06E1 ||
      rune == 0x06E2 ||
      rune == 0x06E3 ||
      rune == 0x06E4 ||
      rune == 0x06E7 ||
      rune == 0x06E8 ||
      rune == 0x06EA ||
      rune == 0x06EB ||
      rune == 0x06EC ||
      rune == 0x06ED;
}
