# Search, Discovery & Indexing Upgrade

## Executive Summary

This pass upgrades Learn discovery from a flat title-first library search into a calmer, path-aware discovery system.

The implementation stays additive:
- the existing `learnHubKnowledgeIndexProvider` remains intact
- guided paths are now first-class discovery items
- search ranking now uses lexical matches, synonym expansion, beginner intent, and kids-safe boosts
- Explore now supports light filters, better grouping, and related next-step hints

Canonical ownership was preserved:
- Qur'an discovery routes into canonical `/quran/*` destinations where direct Qur'an results are shown
- guided Qur'an path discovery still routes into the guided path detail page as orchestration only
- kids discovery remains on kids-owned routes

## Audit Findings Before Changes

What was already working:
- Learn had a shared `learnHubKnowledgeIndexProvider`
- search reused a common `LearnHubKnowledgeItem` contract
- Explore and the Learn landing both used the same basic index
- route targets and keyword fields were already available on most entries

What was weak:
- matching was mostly substring-on-title/subtitle/summary
- guided paths were not indexed as first-class search results
- beginner intent like "how to pray" or "where do I start" was not modeled strongly
- broad hubs could outrank better beginner-safe entries
- Explore presented results mostly as a flat filtered list
- related next-step discovery was minimal

## Search / Discovery Model Changes

New additive model:
- `LearnDiscoveryIndexEntry`
- `LearnDiscoverySearchResult`
- `LearnDiscoveryBucketSection`
- `LearnDiscoveryAudience`
- `LearnDiscoveryDifficulty`
- `LearnDiscoveryContentType`
- `LearnDiscoveryBucket`

New provider layer:
- `learnDiscoveryIndexProvider`
- `learnDiscoveryFeaturedStartHereProvider`
- `searchLearnDiscoveryEntries(...)`
- `bucketLearnDiscoveryResults(...)`
- `curatedLearnDiscoverySections(...)`

## Metadata / Index Structure

The new discovery index merges:
- existing Learn knowledge items from `learnHubKnowledgeIndexProvider`
- localized guided paths from `localizedGuidedLearningPathsProvider`

Each discovery entry carries:
- stable id
- title / subtitle / summary
- route target
- category/domain ownership
- audience
- difficulty
- content type
- search terms
- related path ids
- beginner-safe / start-here hints

This keeps the old knowledge index stable while giving search a richer discovery contract.

## Path-Aware Discovery Behavior

Guided paths are now indexed as full discovery items:
- Foundations Path
- Salah Path
- Qur'an Beginner Path
- Daily Dhikr Path
- Character Path
- Stories Path
- Kids Starter Path

This allows queries like:
- `start islam`
- `how to pray`
- `start quran`
- `daily dhikr`
- `kids arabic`
- `prophets stories`

to surface guided paths alongside direct pages and lessons.

## Relevance Improvements

Ranking now uses explainable signals:
- exact and partial title matching
- subtitle and summary matching
- keyword and tag matching
- synonym expansion
- beginner-intent boosts
- kids-intent boosts
- guided-path boosts
- small penalties for broad hub/tool surfaces when the query is clearly beginner-intent

This is rule-based and deterministic, not opaque ranking.

## Filters / Facets Added

Explore now supports light filters for:
- category via the existing category wheel
- type
- audience
- difficulty

The default experience stays simple, and the filters are only surfaced inside the discovery flow.

## Result Bucketing Behavior

When search is active, Explore groups results into buckets such as:
- Best Next Match
- Guided Paths
- Kids Results
- Lessons & Pages
- You May Also Want

When no search/filter is active, Explore becomes more curated with:
- Start Here
- Guided Paths
- Kids Results
- Practice & Tools

## Related Content Behavior

Each indexed item can carry related path ids.

This is used to surface small "related" hints such as:
- Foundations -> Salah / Qur'an Beginner / Daily Dhikr
- Salah -> Daily Dhikr / Character
- Stories -> Character / Qur'an Beginner
- Kids -> Kids Starter and adjacent lanes

The behavior is intentionally subtle and maintainable.

## Beginner-Safety Choices

The discovery layer now prefers:
- guided paths
- start-here entries
- bridge pages
- focused lessons

over broad hubs when a query looks beginner-oriented.

This especially improves discoverability for:
- Foundations
- Salah
- Qur'an Beginner
- Daily Dhikr
- Kids Starter
- Stories

## Qur'an Ownership Notes

Qur'an ownership remains canonical under `/quran/*`.

Changes in this pass:
- broad Qur'an search results are canonicalized to direct Qur'an owners like `quranSummaryPage`
- the Qur'an Beginner Path remains searchable as a guided-path result, but it still acts only as orchestration into canonical Qur'an surfaces

No second Qur'an owner was introduced.

## Kids Discoverability Notes

Kids remains preserved and intentional:
- kids content still routes into kids-owned destinations
- kids intent gets safe discovery boosts
- Kids Starter Path is now first-class searchable

No kids route-family ownership changed.

## Performance Notes

The new discovery system stays lightweight:
- on-device only
- provider-based
- additive index construction
- deterministic lexical ranking
- no heavy remote search or opaque ranker

The old knowledge index is reused rather than rebuilt from scratch.

## Localization Impact

New keys added:
- `learnDiscoveryExploreTitle`
- `learnDiscoveryExploreSubtitle`
- `learnDiscoveryBestMatchTitle`
- `learnDiscoveryLessonsAndPagesTitle`
- `learnDiscoveryKidsResultsTitle`
- `learnDiscoveryRelatedContentTitle`
- `learnDiscoveryStartHereTitle`
- `learnDiscoveryPracticeAndToolsTitle`
- `learnDiscoveryRelatedLabel`
- `learnDiscoveryTypePath`
- `learnDiscoveryTypePractice`
- `learnDiscoveryTypeReflection`
- `learnDiscoveryAudienceGeneral`
- `learnDiscoveryDifficultyStartHere`
- `learnDiscoveryDifficultyGrowing`

Locale files updated:
- all `lib/l10n/app_*.arb`
- generated `app_localizations*.dart`

Translation posture:
- non-English locale files were updated with English fallback values so the pass remains localization-ready without breaking locale loading

## Test Impact

Added focused coverage in:
- `test/features/learn/presentation/application/learn_discovery_providers_test.dart`

Covered behaviors:
- guided-path discoverability
- kids-safe discovery
- canonical Qur'an result routing
- path-only filter narrowing

## Follow-Up Opportunities

- stronger snippet generation for search results
- richer related-content graphing
- path-progress-aware search chips
- profile-aware discovery ranking
- seasonal discovery boosts
- better direct mapping for advanced story/history lanes
