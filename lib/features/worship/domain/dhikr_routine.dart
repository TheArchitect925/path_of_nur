/// A guided dhikr routine: an ordered list of (phrase, repeat count) steps
/// that the counter advances through on its own.
enum DhikrRoutineKind { afterSalah, morning, evening, sleep }

class DhikrRoutineStep {
  const DhikrRoutineStep({
    required this.id,
    required this.title,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    required this.count,
    required this.sourceRef,
  });

  final String id;
  final String title;
  final String arabic;
  final String transliteration;
  final String translation;
  final int count;
  final String sourceRef;

  /// Long duʿās read as a paragraph rather than a phrase; the player gives
  /// them a scrolling text block and a smaller ring.
  bool get isLongText => arabic.length > 70;
}

class DhikrRoutine {
  const DhikrRoutine({
    required this.id,
    required this.kind,
    required this.steps,
    this.sourceRef,
  });

  final String id;
  final DhikrRoutineKind kind;
  final List<DhikrRoutineStep> steps;
  final String? sourceRef;

  int get totalCount => steps.fold<int>(0, (sum, step) => sum + step.count);

  /// Rough reading time: two seconds per short phrase, twenty per long duʿā.
  int get estimatedMinutes {
    final seconds = steps.fold<int>(
      0,
      (sum, step) => sum + step.count * (step.isLongText ? 20 : 2),
    );
    final minutes = (seconds / 60).ceil();
    return minutes < 1 ? 1 : minutes;
  }

  /// Canonical English label stored on logged sessions. Display code maps it
  /// back to the localized routine title.
  String get sessionLabel {
    switch (kind) {
      case DhikrRoutineKind.afterSalah:
        return 'After-salah tasbih';
      case DhikrRoutineKind.morning:
        return 'Morning adhkar';
      case DhikrRoutineKind.evening:
        return 'Evening adhkar';
      case DhikrRoutineKind.sleep:
        return 'Before-sleep adhkar';
    }
  }
}

/// Where the user is inside a routine they started. Persisted so leaving the
/// player mid-way resumes at the same bead.
class DhikrRoutineProgress {
  const DhikrRoutineProgress({
    required this.routineId,
    required this.stepIndex,
    required this.stepCount,
    required this.startedAt,
    this.prayerId,
  });

  final String routineId;
  final int stepIndex;
  final int stepCount;
  final DateTime startedAt;

  /// For after-salah routines: which prayer this run follows.
  final String? prayerId;

  DhikrRoutineProgress copyWith({
    int? stepIndex,
    int? stepCount,
    String? prayerId,
    bool clearPrayerId = false,
  }) {
    return DhikrRoutineProgress(
      routineId: routineId,
      stepIndex: stepIndex ?? this.stepIndex,
      stepCount: stepCount ?? this.stepCount,
      startedAt: startedAt,
      prayerId: clearPrayerId ? null : prayerId ?? this.prayerId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'routineId': routineId,
    'stepIndex': stepIndex,
    'stepCount': stepCount,
    'startedAtIso': startedAt.toIso8601String(),
    if (prayerId != null) 'prayerId': prayerId,
  };

  static DhikrRoutineProgress? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final routineId = json['routineId']?.toString();
    final startedAt = DateTime.tryParse(json['startedAtIso']?.toString() ?? '');
    if (routineId == null || routineId.isEmpty || startedAt == null) {
      return null;
    }
    return DhikrRoutineProgress(
      routineId: routineId,
      stepIndex: (json['stepIndex'] as num?)?.toInt() ?? 0,
      stepCount: (json['stepCount'] as num?)?.toInt() ?? 0,
      startedAt: startedAt,
      prayerId: json['prayerId']?.toString(),
    );
  }
}
