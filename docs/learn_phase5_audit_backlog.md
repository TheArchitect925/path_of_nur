# Learn Phase 5 Audit Backlog

Date: 2026-03-24

## Highest Priority

- Replace placeholder/scaffolded Learn categories in [learn_category_catalog.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/data/learn_category_catalog.dart) with real surfaced owners or hide them until they are lesson-backed.
- Localize seeded Learn content across:
  - [dua_seed_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/dua/data/dua_seed_data.dart)
  - [growth_seed_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/journey/application/growth_seed_data.dart) where Learn surfaces reuse it
  - [seeded_quran_learning_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/seeded_quran_learning_data.dart)
  - [quran_thematic_map_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data/quran_thematic_map_data.dart)
  - [seeded_*_ayah_enrichment_data.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran/data)
  - [quran_universe](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran_universe)
  - [baby_names](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/life/baby_names)
- Replace hardcoded English page and section copy in visible Learn surfaces such as:
  - [learn_quizzes_hub_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/learn_quizzes_hub_page.dart)
  - [learn_salah_hub_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/learn_salah_hub_page.dart)
  - [baby_names_*](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/life/baby_names/presentation)
  - [knowledge_constellation_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/quran_universe/presentation/knowledge_constellation_page.dart)

## Product / UX

- Consolidate Learn’s overlapping entry surfaces:
  - [learn_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/learn_page.dart)
  - [learning_section_landing_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/learning_section_landing_page.dart)
  - [quran_app_hub_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/quran_app_hub_page.dart)
  - [learn_quran_hub_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/presentation/pages/learn_quran_hub_page.dart)
- Decide whether some search-only or hidden catalog items should become visible or should be removed from user-facing discovery.
- Add clearer “real content vs placeholder path” treatment where the app still routes into partial lesson scaffolds.

## Search / Discoverability

- Keep Learn on the shared search/indexing system, but add locale-aware keyword/search metadata instead of relying on English-heavy seed text.
- Review whether Qur’an hub search should remain a read-only redirect field or gain richer in-hub discovery filters.
- Audit whether Baby Names, Dua, and Quran Universe searchable metadata should be normalized into the shared Learn indexing path.

## Cleanup

- Remove leftover placeholder reference scaffolding in [learn_content_detail_page.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/content/presentation/learn_content_detail_page.dart) once real references are modeled.
- Reduce page-local route sprawl in the major Learn hubs if those pages continue growing.
