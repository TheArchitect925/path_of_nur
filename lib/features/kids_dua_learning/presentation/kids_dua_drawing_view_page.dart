import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_repository.dart';
import '../domain/kids_dua_models.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class KidsDuaDrawingViewPage extends ConsumerWidget {
  const KidsDuaDrawingViewPage({super.key, required this.drawingId});

  final String drawingId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    KidsDuaDrawing? drawing;
    for (final item in ref.watch(kidsDuaDrawingsProvider)) {
      if (item.id == drawingId) {
        drawing = item;
        break;
      }
    }
    if (drawing == null) {
      return AppPageScaffold(
        title: l10n.kidsDuaDrawingsTitle,
        children: [PremiumCard(child: Text(l10n.routerNotFoundTitle))],
      );
    }
    final lesson = ref.watch(kidsDuaLessonByIdProvider(drawing.duaId));
    return AppPageScaffold(
      title: lesson?.title ?? l10n.kidsDuaDrawingsTitle,
      children: [
        PremiumCard(
          padding: EdgeInsets.zero,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: SizedBox(
              height: 440,
              child: InteractiveViewer(
                child: Container(
                  // A drawing is made on white paper; the sheet keeps its
                  // own colour in every theme.
                  color: Colors.white,
                  alignment: Alignment.center,
                  child: Image.file(File(drawing.imagePath)),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await ref
                  .read(kidsDuaCreativeProvider.notifier)
                  .deleteDrawing(drawingId);
              if (context.mounted) Navigator.of(context).pop();
            },
            icon: const Icon(Icons.delete_outline_rounded),
            label: Text(l10n.kidsDuaDrawDeleteAction),
          ),
        ),
      ],
    );
  }
}
