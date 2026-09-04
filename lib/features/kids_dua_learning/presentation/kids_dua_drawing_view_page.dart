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
    return Scaffold(
      appBar: AppBar(title: Text(lesson?.title ?? l10n.kidsDuaDrawingsTitle)),
      body: Column(
        children: [
          Expanded(
            child: InteractiveViewer(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Image.file(File(drawing.imagePath)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }
}
