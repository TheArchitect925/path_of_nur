import 'dart:convert';

class IPhoneHomeWidgetPrayerItemPayload {
  const IPhoneHomeWidgetPrayerItemPayload({
    required this.id,
    required this.name,
    required this.arabicName,
    required this.timeIso,
    required this.timeLabel,
    required this.isCompleted,
    required this.isCurrent,
    required this.isNext,
  });

  final String id;
  final String name;
  final String arabicName;
  final String timeIso;
  final String timeLabel;
  final bool isCompleted;
  final bool isCurrent;
  final bool isNext;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'arabicName': arabicName,
    'timeIso': timeIso,
    'timeLabel': timeLabel,
    'isCompleted': isCompleted,
    'isCurrent': isCurrent,
    'isNext': isNext,
  };
}

class IPhoneNextPrayerWidgetPayload {
  const IPhoneNextPrayerWidgetPayload({
    required this.schemaVersion,
    required this.updatedAtIso,
    required this.title,
    required this.dateLine,
    required this.currentPrayerName,
    required this.currentPrayerArabicName,
    required this.currentPrayerLabel,
    required this.nextPrayerName,
    required this.nextPrayerArabicName,
    required this.nextPrayerTimeIso,
    required this.nextPrayerTimeLabel,
    required this.nextPrayerCountdownLabel,
    required this.nextPrayerLabel,
    required this.deepLinkUrl,
    required this.fallbackTitle,
    required this.fallbackBody,
  });

  final int schemaVersion;
  final String updatedAtIso;
  final String title;
  final String dateLine;
  final String? currentPrayerName;
  final String? currentPrayerArabicName;
  final String currentPrayerLabel;
  final String? nextPrayerName;
  final String? nextPrayerArabicName;
  final String? nextPrayerTimeIso;
  final String? nextPrayerTimeLabel;
  final String nextPrayerCountdownLabel;
  final String nextPrayerLabel;
  final String deepLinkUrl;
  final String fallbackTitle;
  final String fallbackBody;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'updatedAtIso': updatedAtIso,
    'title': title,
    'dateLine': dateLine,
    'currentPrayerName': currentPrayerName,
    'currentPrayerArabicName': currentPrayerArabicName,
    'currentPrayerLabel': currentPrayerLabel,
    'nextPrayerName': nextPrayerName,
    'nextPrayerArabicName': nextPrayerArabicName,
    'nextPrayerTimeIso': nextPrayerTimeIso,
    'nextPrayerTimeLabel': nextPrayerTimeLabel,
    'nextPrayerCountdownLabel': nextPrayerCountdownLabel,
    'nextPrayerLabel': nextPrayerLabel,
    'deepLinkUrl': deepLinkUrl,
    'fallbackTitle': fallbackTitle,
    'fallbackBody': fallbackBody,
  };

  String toEncodedJson() => jsonEncode(toJson());
}

class IPhonePrayerOverviewWidgetPayload {
  const IPhonePrayerOverviewWidgetPayload({
    required this.schemaVersion,
    required this.updatedAtIso,
    required this.title,
    required this.dateLine,
    required this.completedPrayerCount,
    required this.totalPrayerCount,
    required this.phaseProgressPercent,
    required this.deepLinkUrl,
    required this.items,
  });

  final int schemaVersion;
  final String updatedAtIso;
  final String title;
  final String dateLine;
  final int completedPrayerCount;
  final int totalPrayerCount;
  final int phaseProgressPercent;
  final String deepLinkUrl;
  final List<IPhoneHomeWidgetPrayerItemPayload> items;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'updatedAtIso': updatedAtIso,
    'title': title,
    'dateLine': dateLine,
    'completedPrayerCount': completedPrayerCount,
    'totalPrayerCount': totalPrayerCount,
    'phaseProgressPercent': phaseProgressPercent,
    'deepLinkUrl': deepLinkUrl,
    'items': items.map((item) => item.toJson()).toList(growable: false),
  };

  String toEncodedJson() => jsonEncode(toJson());
}

class IPhoneDhikrWidgetPayload {
  const IPhoneDhikrWidgetPayload({
    required this.schemaVersion,
    required this.updatedAtIso,
    required this.title,
    required this.dateLine,
    required this.todayCount,
    required this.targetCount,
    required this.progressPercent,
    required this.todayLabel,
    required this.targetLabel,
    required this.deepLinkUrl,
  });

  final int schemaVersion;
  final String updatedAtIso;
  final String title;
  final String dateLine;
  final int todayCount;
  final int targetCount;
  final int progressPercent;
  final String todayLabel;
  final String targetLabel;
  final String deepLinkUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'updatedAtIso': updatedAtIso,
    'title': title,
    'dateLine': dateLine,
    'todayCount': todayCount,
    'targetCount': targetCount,
    'progressPercent': progressPercent,
    'todayLabel': todayLabel,
    'targetLabel': targetLabel,
    'deepLinkUrl': deepLinkUrl,
  };

  String toEncodedJson() => jsonEncode(toJson());
}

class IPhoneJourneyWidgetPayload {
  const IPhoneJourneyWidgetPayload({
    required this.schemaVersion,
    required this.updatedAtIso,
    required this.title,
    required this.dateLine,
    required this.currentStreakDays,
    required this.currentLevel,
    required this.totalXp,
    required this.todayXp,
    required this.xpProgressPercent,
    required this.streakLabel,
    required this.levelLabel,
    required this.todayXpLabel,
    required this.deepLinkUrl,
  });

  final int schemaVersion;
  final String updatedAtIso;
  final String title;
  final String dateLine;
  final int currentStreakDays;
  final int currentLevel;
  final int totalXp;
  final int todayXp;
  final int xpProgressPercent;
  final String streakLabel;
  final String levelLabel;
  final String todayXpLabel;
  final String deepLinkUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'updatedAtIso': updatedAtIso,
    'title': title,
    'dateLine': dateLine,
    'currentStreakDays': currentStreakDays,
    'currentLevel': currentLevel,
    'totalXp': totalXp,
    'todayXp': todayXp,
    'xpProgressPercent': xpProgressPercent,
    'streakLabel': streakLabel,
    'levelLabel': levelLabel,
    'todayXpLabel': todayXpLabel,
    'deepLinkUrl': deepLinkUrl,
  };

  String toEncodedJson() => jsonEncode(toJson());
}

class IPhoneSpiritualWidgetPayload {
  const IPhoneSpiritualWidgetPayload({
    required this.schemaVersion,
    required this.updatedAtIso,
    required this.title,
    required this.dateLine,
    required this.headline,
    required this.supportingText,
    required this.footerText,
    required this.arabicText,
    required this.transliterationText,
    required this.accentText,
    required this.deepLinkUrl,
    required this.accessoryInlineText,
    required this.accessoryCircularText,
    required this.accessoryRectangularTitle,
    required this.accessoryRectangularBody,
    required this.fallbackTitle,
    required this.fallbackBody,
  });

  final int schemaVersion;
  final String updatedAtIso;
  final String title;
  final String dateLine;
  final String headline;
  final String supportingText;
  final String footerText;
  final String? arabicText;
  final String? transliterationText;
  final String? accentText;
  final String deepLinkUrl;
  final String accessoryInlineText;
  final String accessoryCircularText;
  final String accessoryRectangularTitle;
  final String accessoryRectangularBody;
  final String fallbackTitle;
  final String fallbackBody;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'schemaVersion': schemaVersion,
    'updatedAtIso': updatedAtIso,
    'title': title,
    'dateLine': dateLine,
    'headline': headline,
    'supportingText': supportingText,
    'footerText': footerText,
    'arabicText': arabicText,
    'transliterationText': transliterationText,
    'accentText': accentText,
    'deepLinkUrl': deepLinkUrl,
    'accessoryInlineText': accessoryInlineText,
    'accessoryCircularText': accessoryCircularText,
    'accessoryRectangularTitle': accessoryRectangularTitle,
    'accessoryRectangularBody': accessoryRectangularBody,
    'fallbackTitle': fallbackTitle,
    'fallbackBody': fallbackBody,
  };

  String toEncodedJson() => jsonEncode(toJson());
}
