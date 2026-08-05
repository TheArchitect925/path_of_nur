class KhusuSettings {
  const KhusuSettings({
    required this.reduceVisualDistractions,
    required this.minimalInterface,
    required this.gentleReminders,
    required this.ambientMode,
  });

  final bool reduceVisualDistractions;
  final bool minimalInterface;
  final bool gentleReminders;
  final bool ambientMode;

  KhusuSettings copyWith({
    bool? reduceVisualDistractions,
    bool? minimalInterface,
    bool? gentleReminders,
    bool? ambientMode,
  }) {
    return KhusuSettings(
      reduceVisualDistractions:
          reduceVisualDistractions ?? this.reduceVisualDistractions,
      minimalInterface: minimalInterface ?? this.minimalInterface,
      gentleReminders: gentleReminders ?? this.gentleReminders,
      ambientMode: ambientMode ?? this.ambientMode,
    );
  }

  static const KhusuSettings defaults = KhusuSettings(
    reduceVisualDistractions: true,
    minimalInterface: true,
    gentleReminders: false,
    ambientMode: false,
  );
}
