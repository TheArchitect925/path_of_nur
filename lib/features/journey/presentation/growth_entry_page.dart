import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/growth_models.dart';
import '../application/growth_providers.dart';
import 'growth_home_page.dart';

class GrowthEntryPage extends ConsumerStatefulWidget {
  const GrowthEntryPage({
    super.key,
    required this.initialTab,
    this.focusHabitId,
  });

  final GrowthInternalTab initialTab;
  final String? focusHabitId;

  @override
  ConsumerState<GrowthEntryPage> createState() => _GrowthEntryPageState();
}

class _GrowthEntryPageState extends ConsumerState<GrowthEntryPage> {
  bool _openedHabit = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyEntryIntent());
  }

  @override
  void didUpdateWidget(covariant GrowthEntryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab ||
        oldWidget.focusHabitId != widget.focusHabitId) {
      _openedHabit = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _applyEntryIntent());
    }
  }

  void _applyEntryIntent() {
    ref
        .read(growthInternalTabProvider.notifier)
        .state = widget.initialTab;
    if (_openedHabit || widget.focusHabitId == null || !mounted) {
      return;
    }
    _openedHabit = true;
    final target = widget.focusHabitId!;
    context.pushNamed('growthHabitDetail', pathParameters: {'habitId': target});
  }

  @override
  Widget build(BuildContext context) {
    return const GrowthHomePage();
  }
}
