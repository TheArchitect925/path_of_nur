import 'dart:math' as math;

const double qiblaAlignedToleranceDegrees = 7;
const double qiblaKaabaLatitude = 21.4225;
const double qiblaKaabaLongitude = 39.8262;

double normalizeDegrees(double value) {
  final normalized = value % 360;
  return normalized < 0 ? normalized + 360 : normalized;
}

double shortestSignedAngleDelta({
  required double fromDegrees,
  required double toDegrees,
}) {
  final delta = normalizeDegrees(toDegrees - fromDegrees);
  return delta > 180 ? delta - 360 : delta;
}

double lerpAngleDegrees(double current, double target, double t) {
  final delta = shortestSignedAngleDelta(
    fromDegrees: current,
    toDegrees: target,
  );
  return normalizeDegrees(current + (delta * t));
}

double bearingToKaaba({required double latitude, required double longitude}) {
  final lat1 = _degToRad(latitude);
  final lat2 = _degToRad(qiblaKaabaLatitude);
  final deltaLongitude = _degToRad(qiblaKaabaLongitude - longitude);

  final y = math.sin(deltaLongitude) * math.cos(lat2);
  final x =
      math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(deltaLongitude);
  final bearing = math.atan2(y, x);
  return normalizeDegrees(_radToDeg(bearing));
}

double _degToRad(double degrees) => degrees * math.pi / 180;
double _radToDeg(double radians) => radians * 180 / math.pi;
