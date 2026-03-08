import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../state/shell_state.dart';
import 'global_background.dart';

class AppShellScaffold extends ConsumerWidget {
  const AppShellScaffold({
    super.key,
    required this.currentLocation,
    required this.child,
  });

  final String currentLocation;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = navTabFromLocation(currentLocation);
    final previousLocation = ref.watch(shellCurrentLocationProvider);

    if (previousLocation != currentLocation) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ref.read(shellCurrentLocationProvider.notifier).state = currentLocation;
        if (activeTab == NavTab.home) {
          ref.read(homeVerseVersionProvider.notifier).state++;
        }
      });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          const GlobalBackground(),
          GestureDetector(
            onHorizontalDragEnd: (details) {
              final nav = Navigator.of(context);
              if ((details.primaryVelocity ?? 0) < -260 && nav.canPop()) {
                nav.pop();
              }
            },
            child: child,
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context, activeTab),
    );
  }

  Widget _buildBottomBar(BuildContext context, NavTab activeTab) {
    final allTabs = NavTab.values;

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: const Color(0xFFD5BC8A).withValues(alpha: 0.58),
                width: 1.2,
              ),
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: allTabs
                    .map(
                      (tab) => Expanded(
                        child: _tabButton(context, tab, activeTab == tab),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(BuildContext context, NavTab tab, bool active) {
    final bool isHome = tab == NavTab.home;
    final Color iconColor = active
        ? const Color(0xFFFFFFFF)
        : const Color(0xFFF5F3EE).withValues(alpha: 0.9);
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
      color: iconColor,
      fontSize: isHome ? 13.5 : 12.7,
      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
      letterSpacing: 0.2,
      fontFamily: 'serif',
    );

    return InkWell(
      onTap: () => context.go(tab.path),
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _navIcon(
              tab.icon,
              isHome: isHome,
              active: active,
              iconColor: iconColor,
            ),
            const SizedBox(height: 2),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(_tabLabel(context, tab), style: textStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(
    IconData icon, {
    required bool isHome,
    required bool active,
    required Color iconColor,
  }) {
    final double size = isHome ? 30 : 24;
    if (!active) {
      return Icon(icon, size: size, color: iconColor);
    }

    return SizedBox(
      width: 42,
      height: 36,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFF6E49F).withValues(alpha: 0.62),
                  const Color(0xFFE1BD6E).withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(top: 4, right: 9, child: _sparkDot(3.2)),
          Positioned(top: 10, left: 8, child: _sparkDot(2.4)),
          Positioned(bottom: 5, right: 7, child: _sparkDot(2.6)),
          Icon(icon, size: size, color: const Color(0xFFFFFFFF)),
        ],
      ),
    );
  }

  Widget _sparkDot(double size) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFEED789),
        shape: BoxShape.circle,
      ),
    );
  }

  String _tabLabel(BuildContext context, NavTab tab) {
    switch (tab) {
      case NavTab.worship:
        return 'Worship';
      case NavTab.learn:
        return 'Learn';
      case NavTab.home:
        return 'Home';
      case NavTab.journey:
        return 'Journey';
      case NavTab.profile:
        return 'Profile';
    }
  }
}
