import 'dhikr_routine.dart';

/// A routine the user built: a name and an ordered list of steps. Stored as
/// JSON per data scope; ids never contain a colon because the daily-totals
/// routine entries split on one.
class DhikrCustomRoutine {
  const DhikrCustomRoutine({
    required this.id,
    required this.name,
    required this.steps,
    required this.createdAt,
  });

  final String id;
  final String name;
  final List<DhikrRoutineStep> steps;
  final DateTime createdAt;

  static const String idPrefix = 'custom-';

  static bool isCustomId(String id) => id.startsWith(idPrefix);

  static String newId(DateTime now) =>
      '$idPrefix${now.microsecondsSinceEpoch.toRadixString(36)}';

  DhikrRoutine toRoutine() => DhikrRoutine(
    id: id,
    kind: DhikrRoutineKind.custom,
    steps: steps,
    customName: name,
  );

  DhikrCustomRoutine copyWith({String? name, List<DhikrRoutineStep>? steps}) {
    return DhikrCustomRoutine(
      id: id,
      name: name ?? this.name,
      steps: steps ?? this.steps,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'name': name,
    'createdAtIso': createdAt.toIso8601String(),
    'steps': <Map<String, dynamic>>[for (final step in steps) step.toJson()],
  };

  static DhikrCustomRoutine? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    final id = json['id']?.toString() ?? '';
    if (!isCustomId(id)) return null;
    final rawSteps = json['steps'];
    final steps = <DhikrRoutineStep>[
      if (rawSteps is List)
        for (final raw in rawSteps)
          if (raw is Map)
            ?DhikrRoutineStep.fromJson(
              raw.map((key, value) => MapEntry(key.toString(), value)),
            ),
    ];
    return DhikrCustomRoutine(
      id: id,
      name: json['name']?.toString() ?? '',
      steps: steps,
      createdAt:
          DateTime.tryParse(json['createdAtIso']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }
}
