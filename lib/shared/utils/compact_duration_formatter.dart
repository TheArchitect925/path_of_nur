import 'package:intl/intl.dart';

String formatCompactDuration(
  Duration duration, {
  required String localeName,
  String hourSuffix = 'h',
  String minuteSuffix = 'm',
}) {
  final safeDuration = duration.isNegative ? Duration.zero : duration;
  final wholeNumber = NumberFormat.decimalPattern(localeName);
  final twoDigit = NumberFormat('00', localeName);
  final totalSeconds = safeDuration.inSeconds;
  if (totalSeconds == 0) {
    return '${wholeNumber.format(0)}$minuteSuffix';
  }

  final hours = totalSeconds ~/ Duration.secondsPerHour;
  final remainingSeconds = totalSeconds % Duration.secondsPerHour;
  final minutes = remainingSeconds ~/ Duration.secondsPerMinute;

  if (hours > 0 && minutes > 0) {
    return '${wholeNumber.format(hours)}$hourSuffix${twoDigit.format(minutes)}$minuteSuffix';
  }
  if (hours > 0) {
    return '${wholeNumber.format(hours)}$hourSuffix';
  }
  final minuteDisplay = minutes == 0 ? 1 : minutes;
  return '${wholeNumber.format(minuteDisplay)}$minuteSuffix';
}
