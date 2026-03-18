class KidsArabicColoringPage {
  const KidsArabicColoringPage({
    required this.id,
    required this.letterId,
    required this.titleKey,
    required this.assetPath,
    required this.unlockRequirement,
    required this.isUnlocked,
  });

  final String id;
  final String letterId;
  final String titleKey;
  final String assetPath;
  final String unlockRequirement;
  final bool isUnlocked;

  KidsArabicColoringPage copyWith({
    String? id,
    String? letterId,
    String? titleKey,
    String? assetPath,
    String? unlockRequirement,
    bool? isUnlocked,
  }) {
    return KidsArabicColoringPage(
      id: id ?? this.id,
      letterId: letterId ?? this.letterId,
      titleKey: titleKey ?? this.titleKey,
      assetPath: assetPath ?? this.assetPath,
      unlockRequirement: unlockRequirement ?? this.unlockRequirement,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
