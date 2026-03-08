enum FastingType {
  ramadan,
  sunnah,
  qada,
  voluntary,
  other,
}

extension FastingTypeX on FastingType {
  String get label {
    switch (this) {
      case FastingType.ramadan:
        return 'Ramadan fast';
      case FastingType.sunnah:
        return 'Sunnah fast';
      case FastingType.qada:
        return 'Make-up fast (Qada)';
      case FastingType.voluntary:
        return 'Voluntary fast';
      case FastingType.other:
        return 'Other / custom';
    }
  }
}

