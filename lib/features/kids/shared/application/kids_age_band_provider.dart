import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../learn/journey/application/family_learning_provider.dart';
import '../domain/kids_age_band.dart';

/// The active child's age band. An adult, or a child profile that never set
/// one, reads as the core band, which changes nothing.
final kidsAgeBandProvider = Provider<KidsAgeBand>((ref) {
  final child = ref.watch(
    activeFamilyLearningContextProvider.select(
      (value) => value.activeChildProfile,
    ),
  );
  return child?.ageBand ?? KidsAgeBand.core;
});
