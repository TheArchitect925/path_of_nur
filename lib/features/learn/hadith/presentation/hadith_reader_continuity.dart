import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum HadithReaderLaneKind {
  browse,
  theme,
  collection,
  narrator,
  sourceChapter,
  sourceCollection,
  path,
  search,
}

@immutable
class HadithReaderLaneContext {
  const HadithReaderLaneContext({
    required this.kind,
    required this.laneId,
    required this.laneTitle,
    required this.returnRouteName,
    this.orderedLessonIds = const <String>[],
    this.returnPathParameters = const <String, String>{},
    this.returnQueryParameters = const <String, String>{},
    this.backLabelOverride,
  });

  final HadithReaderLaneKind kind;
  final String laneId;
  final String laneTitle;
  final List<String> orderedLessonIds;
  final String returnRouteName;
  final Map<String, String> returnPathParameters;
  final Map<String, String> returnQueryParameters;
  final String? backLabelOverride;

  int indexOfLesson(String lessonId) => orderedLessonIds.indexOf(lessonId);

  bool get supportsSequence => orderedLessonIds.length > 1;

  String? previousLessonId(String lessonId) {
    final index = indexOfLesson(lessonId);
    if (index <= 0) return null;
    return orderedLessonIds[index - 1];
  }

  String? nextLessonId(String lessonId) {
    final index = indexOfLesson(lessonId);
    if (index < 0 || index >= orderedLessonIds.length - 1) return null;
    return orderedLessonIds[index + 1];
  }
}

void pushHadithLessonDetail(
  BuildContext context, {
  required String lessonId,
  HadithReaderLaneContext? laneContext,
}) {
  context.pushNamed(
    'hadithLessonDetail',
    pathParameters: {'lessonId': lessonId},
    extra: laneContext,
  );
}

void replaceHadithLessonDetail(
  BuildContext context, {
  required String lessonId,
  HadithReaderLaneContext? laneContext,
}) {
  context.pushReplacementNamed(
    'hadithLessonDetail',
    pathParameters: {'lessonId': lessonId},
    extra: laneContext,
  );
}
