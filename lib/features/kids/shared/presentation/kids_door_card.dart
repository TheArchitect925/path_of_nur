import 'package:flutter/material.dart';

import '../../../../shared/widgets/display/art_header_card.dart';

/// One of the doors on the kids landing: a picture a child recognises, a
/// one-word name on it, and nothing else. Two per row.
class KidsDoorCard extends StatelessWidget {
  const KidsDoorCard({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.fallbackIcon,
    required this.onTap,
    this.subtitle,
  });

  final String imageAsset;
  final String title;
  final String? subtitle;
  final IconData fallbackIcon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: subtitle == null ? title : '$title. $subtitle',
      child: ArtHeaderCard(
        imageAsset: imageAsset,
        title: title,
        subtitle: subtitle,
        fallbackIcon: fallbackIcon,
        fallbackColor: Theme.of(context).colorScheme.primary,
        aspectRatio: 1,
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        onTap: onTap,
      ),
    );
  }
}

/// The doors laid out two to a row. Content sets the height, so a grid of
/// four never leaves an empty cell.
class KidsDoorGrid extends StatelessWidget {
  const KidsDoorGrid({super.key, required this.doors});

  final List<KidsDoorCard> doors;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < doors.length; i += 2) {
      final left = doors[i];
      final right = i + 1 < doors.length ? doors[i + 1] : null;
      rows.add(
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            const SizedBox(width: 12),
            Expanded(child: right ?? const SizedBox.shrink()),
          ],
        ),
      );
      if (i + 2 < doors.length) rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}
