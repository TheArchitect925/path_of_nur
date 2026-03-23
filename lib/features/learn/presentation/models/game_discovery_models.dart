import 'package:flutter/material.dart';

import 'learn_hub_models.dart';

class GameDiscoverySection {
  const GameDiscoverySection({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.baseColor,
    required this.accentColor,
    required this.cards,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color baseColor;
  final Color accentColor;
  final List<GameDiscoveryCard> cards;
}

class GameDiscoveryCard {
  const GameDiscoveryCard({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.baseColor,
    required this.accentColor,
    required this.routeTarget,
    this.badgeLabel,
    this.searchKeywords = const <String>[],
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color baseColor;
  final Color accentColor;
  final LearnHubRouteTarget routeTarget;
  final String? badgeLabel;
  final List<String> searchKeywords;
}
