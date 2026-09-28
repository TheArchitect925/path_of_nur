import 'package:flutter/animation.dart';

/// Motion tokens for the whole app.
///
/// Four words describe every animation the app is allowed to make:
///
/// * **kindle** — light arriving (the startup lantern, the adhan glow);
/// * **settle** — things coming to rest (page arrival, data arriving);
/// * **breathe** — slow ambient life (the lantern, the hero's light band);
/// * **ink** — text being written (the day's ayah, the takbīr at startup).
///
/// Anything outside those four is not in the vocabulary: no bounces, no
/// elastic overshoot, no Material zoom. The durations and curves below are
/// the only ones new motion should use; `easeOutCubic` was already the house
/// curve before this file existed.
///
/// Glass rule: opacity animations over layered glass darken it under
/// Impeller (docs/impeller_glass_transition_backlog_2026-04-07.md), so a card
/// moves and clips, and only the content inside it fades. Every primitive in
/// `lib/shared/motion/` is built to that rule.
abstract final class AppMotion {
  // Durations.
  static const Duration instant = Duration.zero;
  static const Duration quick = Duration(milliseconds: 140);
  static const Duration standard = Duration(milliseconds: 220);
  static const Duration gentle = Duration(milliseconds: 320);
  static const Duration settle = Duration(milliseconds: 420);
  static const Duration slow = Duration(milliseconds: 900);

  /// One breath of the ambient lantern.
  static const Duration breath = Duration(seconds: 4);

  /// One pass of the light band across the hero card.
  static const Duration specularPeriod = Duration(seconds: 7);

  /// The shared ambient cycle: a whole number of breaths and light passes,
  /// so the one ticker never shows a seam when it loops.
  static const Duration ambientCycle = Duration(seconds: 28);

  // Curves.
  static const Curve settleCurve = Curves.easeOutCubic;
  static const Curve exitCurve = Curves.easeInCubic;
  static const Curve breathCurve = Curves.easeInOutSine;

  // Page arrival: the settle stagger.
  static const Duration staggerStep = Duration(milliseconds: 40);
  static const int staggerLimit = 6;
  static const double settleDistance = 10;
  static const Duration settleDuration = gentle;

  /// Cards that first build later than this after the page opened are below
  /// the fold or lazily built; they render at rest instead of catching up.
  static const Duration staggerWindow = Duration(milliseconds: 400);

  // Ink reveals.
  static const Duration inkReveal = Duration(milliseconds: 620);
  static const Duration inkFollow = Duration(milliseconds: 440);

  // Information arriving.
  static const Duration shimmerPeriod = Duration(milliseconds: 1400);
  static const Duration countUp = Duration(milliseconds: 700);

  // Meaning moments.
  static const Duration drawCheck = settle;
  static const Duration ringOut = Duration(milliseconds: 720);
  static const Duration glint = slow;
  static const Duration beadSlide = gentle;

  /// How long the lantern and the hero glow after a prayer comes in.
  static const Duration adhanGlow = Duration(seconds: 60);

  // Startup: the dawn sequence.
  static const Duration kindle = Duration(milliseconds: 1400);
  static const Duration startupExit = Duration(milliseconds: 400);

  /// The loading card stays at least this long so the kindle can read.
  static const Duration startupMinimum = Duration(milliseconds: 1100);

  /// No checkpoint may hold the reader longer than this.
  static const Duration checkpointCeiling = Duration(seconds: 2);

  /// Each checkpoint keeps its stage on the light-line at least this long.
  static const Duration checkpointMinimum = Duration(milliseconds: 180);
}
