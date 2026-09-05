import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_icons.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/application/special_mode_provider.dart';
import '../../../../shared/widgets/premium_card.dart';
import '../../rewards/application/kids_reward_world_provider.dart';
import '../../shared/presentation/kids_page_scaffold.dart';
import '../application/kids_parent_gate_provider.dart';

/// Stands in front of every parent page while the kids UI is active.
///
/// A child sees "Grown-ups only" and a button that has to be held for a
/// moment — the ordinary grown-up gesture in children's apps, which a small
/// child does not do by accident and a parent does not need a PIN for. An
/// adult profile, where the kids UI is off, never meets the gate.
class KidsParentGate extends ConsumerWidget {
  const KidsParentGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isKids = ref.watch(specialModeProvider.select((mode) => mode.isKids));
    final gate = ref.watch(kidsParentGateProvider);
    final now = ref.watch(kidsRewardNowProvider)();
    if (!isKids || gate.isOpenAt(now)) return child;

    final l10n = AppLocalizations.of(context);
    return KidsPageScaffold(
      headerIcon: AppIcons.family,
      title: l10n.kidsParentGateTitle,
      subtitle: l10n.kidsParentGateBody,
      children: [
        // The header subtitle already says what to do; the card is the button.
        PremiumCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KidsHoldToOpenButton(
                label: l10n.kidsParentGateHoldAction,
                onOpened: () {
                  HapticFeedback.mediumImpact();
                  ref
                      .read(kidsParentGateProvider.notifier)
                      .unlock(ref.read(kidsRewardNowProvider)());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// A button that opens only when held down for [holdFor]; letting go early
/// winds it back.
class KidsHoldToOpenButton extends StatefulWidget {
  const KidsHoldToOpenButton({
    super.key,
    required this.label,
    required this.onOpened,
    this.holdFor = const Duration(milliseconds: 1400),
  });

  final String label;
  final VoidCallback onOpened;
  final Duration holdFor;

  @override
  State<KidsHoldToOpenButton> createState() => _KidsHoldToOpenButtonState();
}

class _KidsHoldToOpenButtonState extends State<KidsHoldToOpenButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _hold = AnimationController(
    vsync: this,
    duration: widget.holdFor,
    reverseDuration: const Duration(milliseconds: 250),
  )..addStatusListener(_onStatus);
  bool _opened = false;

  void _onStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_opened) {
      _opened = true;
      widget.onOpened();
    }
  }

  @override
  void dispose() {
    _hold.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final textTheme = Theme.of(context).textTheme;
    return Semantics(
      button: true,
      label: widget.label,
      child: Listener(
        onPointerDown: (_) => _hold.forward(),
        onPointerUp: (_) => _release(),
        onPointerCancel: (_) => _release(),
        child: AnimatedBuilder(
          animation: _hold,
          builder: (context, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 72,
                color: palette.surfaceSoft,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: _hold.value,
                      child: ColoredBox(
                        color: palette.accent.withValues(alpha: 0.45),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _release() {
    if (_hold.status != AnimationStatus.completed) _hold.reverse();
  }
}
