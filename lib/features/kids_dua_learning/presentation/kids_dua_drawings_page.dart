import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../application/kids_dua_creative_provider.dart';
import '../application/kids_dua_repository.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';

class KidsDuaDrawingsPage extends ConsumerWidget {
  const KidsDuaDrawingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final drawings = ref.watch(kidsDuaDrawingsProvider);
    return AppPageScaffold(
      title: l10n.kidsDuaDrawingsTitle,
      children: [
        drawings.isEmpty
            ? PremiumCard(child: Text(l10n.kidsDuaDrawingsEmpty))
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
      ],
    );
  }
}
