import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_repository.dart';

class KidsDuaDrawingsPage extends ConsumerWidget {
  const KidsDuaDrawingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final drawings = ref.watch(kidsDuaDrawingsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.kidsDuaDrawingsTitle)),
      body: drawings.isEmpty
          ? Center(child: Text(l10n.kidsDuaDrawingsEmpty))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.92,
              ),
              itemCount: drawings.length,
              itemBuilder: (context, index) {
                final drawing = drawings[index];
                final lesson = ref.watch(
                  kidsDuaLessonByIdProvider(drawing.duaId),
                );
                return InkWell(
                  onTap: () => context.pushNamed(
                    'kidsDuaDrawingViewer',
                    pathParameters: {'drawingId': drawing.id},
                  ),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE8DDD0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(drawing.imagePath),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder: (context, error, stackTrace) =>
                                  const ColoredBox(
                                    color: Color(0xFFFFF8EF),
                                    child: Center(
                                      child: Icon(Icons.brush_rounded),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          lesson?.title ?? l10n.kidsDuaDrawingsUntitled,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
