import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/app_page_scaffold.dart';
import '../../../shared/widgets/premium_card.dart';
import '../application/editorial_content_versions_provider.dart';
import '../domain/editorial_content_version_models.dart';

class EditorialContentBrowserPage extends ConsumerStatefulWidget {
  const EditorialContentBrowserPage({super.key, required this.contentType});

  final EditorialContentType contentType;

  @override
  ConsumerState<EditorialContentBrowserPage> createState() =>
      _EditorialContentBrowserPageState();
}

class _EditorialContentBrowserPageState
    extends ConsumerState<EditorialContentBrowserPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final summaries = ref.watch(
      editorialEditableContentSummariesProvider(widget.contentType),
    );
    final query = _searchController.text.trim();
    final filtered = summaries
        .where((summary) => summary.matchesQuery(query))
        .toList(growable: false);

    return AppPageScaffold(
      title: _contentTypeLabel(l10n, widget.contentType),
      subtitle: l10n.editorialDashboardContentBrowserSubtitle,
      children: [
        PremiumCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search_rounded),
                    hintText: l10n.editorialDashboardSearchHint,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.editorialDashboardResultsCount(
                    filtered.length,
                    summaries.length,
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (filtered.isEmpty)
          PremiumCard(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(l10n.editorialDashboardEmptySubtitle),
            ),
          )
        else
          ...filtered.map(
            (summary) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: PremiumCard(
                child: ListTile(
                  title: Text(summary.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        summary.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.editorialDashboardContentVersionCount(
                          summary.versionCount,
                        ),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (summary.changeSummary != null &&
                          summary.changeSummary!.trim().isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          summary.changeSummary!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                  onTap: () => context.pushNamed(
                    'editorialContentEditor',
                    pathParameters: {
                      'contentType': editorialContentTypeRouteSegment(
                        widget.contentType,
                      ),
                    },
                    queryParameters: {'id': summary.contentId},
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

String _contentTypeLabel(AppLocalizations l10n, EditorialContentType type) {
  return switch (type) {
    EditorialContentType.quranExplanation =>
      l10n.editorialDashboardContentTypeQuranExplanation,
    EditorialContentType.hadithEntry =>
      l10n.editorialDashboardContentTypeHadithEntry,
    EditorialContentType.bedtimeStory =>
      l10n.editorialDashboardContentTypeBedtimeStory,
    EditorialContentType.kidsDuaLesson =>
      l10n.editorialDashboardContentTypeKidsDuaLesson,
  };
}

String editorialContentTypeRouteSegment(EditorialContentType type) {
  return switch (type) {
    EditorialContentType.quranExplanation => 'quran-explanations',
    EditorialContentType.hadithEntry => 'hadith-entries',
    EditorialContentType.bedtimeStory => 'bedtime-stories',
    EditorialContentType.kidsDuaLesson => 'kids-dua-lessons',
  };
}

EditorialContentType? editorialContentTypeFromRouteSegment(String raw) {
  return switch (raw) {
    'quran-explanations' => EditorialContentType.quranExplanation,
    'hadith-entries' => EditorialContentType.hadithEntry,
    'bedtime-stories' => EditorialContentType.bedtimeStory,
    'kids-dua-lessons' => EditorialContentType.kidsDuaLesson,
    _ => null,
  };
}
