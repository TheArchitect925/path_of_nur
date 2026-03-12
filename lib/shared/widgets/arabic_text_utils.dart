import 'package:flutter/material.dart';

final RegExp _arabicScriptRegex = RegExp(
  r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]',
);

bool containsArabicScript(String text) {
  return _arabicScriptRegex.hasMatch(text);
}

TextDirection textDirectionForContent(
  String text, {
  TextDirection fallback = TextDirection.ltr,
}) {
  return containsArabicScript(text) ? TextDirection.rtl : fallback;
}

TextAlign textAlignForContent(
  String text, {
  TextAlign fallback = TextAlign.start,
}) {
  return containsArabicScript(text) ? TextAlign.right : fallback;
}
