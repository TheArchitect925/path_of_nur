# Qur'an Learning Content Audit

Date: 2026-03-22

## Scope

Audited:

- `lib/features/learn/quran/*`
- `lib/features/learn/divine_life_lessons/*`
- `lib/features/learn/world/*`
- `lib/features/learn/quran_universe/*`
- current reader `Learn More` and `QuranReferenceViewer` surfaces
- Learn Hub Qur'an category/catalog surfaces

## Current Qur'an content map

### 1. Canonical Qur'an text / reader layer

Canonical ownership:

- `lib/features/learn/quran/data/quran_repository.dart`
- `lib/features/learn/quran/data/quran_content_repository.dart`
- `lib/features/learn/quran/domain/quran_content_refs.dart`
- `lib/features/learn/quran/presentation/quran_reader_page.dart`

What it owns:

- Arabic ayah text
- translations
- transliteration
- audio source resolution
- canonical verse references and reader deep links

Important note:

- This layer is strong and should remain separate from educational commentary metadata.

### 2. Seeded Qur'an learning mini-dataset

Files:

- `lib/features/learn/quran/domain/quran_learning_models.dart`
- `lib/features/learn/quran/data/seeded_quran_learning_data.dart`
- `lib/features/learn/quran/application/quran_learning_system_service.dart`
- `lib/features/learn/presentation/pages/learn_quran_hub_page.dart`

Current size:

- `6` `QuranLearningVerse` entries
- `5` `QuranLearningPath` entries

What it contains:

- short explanation
- key lessons
- related hadith ids
- reflection prompts
- lightweight path ids
- one optional `themeTag`

Strength:

- clean starter structure
- already reused in the Qur'an Study hub

Weakness:

- too small for broad ayah coverage
- not yet the canonical source for reader `Learn More`
- theme/category depth is shallow

### 3. Divine Life Lessons dataset

Files:

- `lib/features/learn/divine_life_lessons/data/divine_life_lessons_data.dart`
- `lib/features/learn/divine_life_lessons/domain/divine_life_models.dart`
- `lib/features/learn/divine_life_lessons/presentation/*`

Current size:

- `40` `DivineLifeLesson` entries

What it contains:

- Qur'an reference range
- short summary
- reflection
- practical takeaway
- action steps
- reflection prompts
- theme and situation ids

Strength:

- strongest structured ayah-linked educational dataset in the repo
- production-usable lesson depth

Weakness:

- lives in a separate life-lessons domain
- not modeled as a reusable canonical ayah-enrichment source

### 4. World & Creation dataset

Files:

- `lib/features/learn/world/data/world_creation_data.dart`
- `lib/features/learn/world/domain/world_creation_models.dart`
- `lib/features/learn/world/presentation/*`

Current size:

- `25` `WorldCreationLesson` entries
- `12` `WorldCreationCategory` entries
- `9` `ObservationChallenge` entries

What it contains:

- Qur'an verse references
- Qur'anic observation notes
- science-lens summaries
- explicit caution notes
- reflection prompts
- related lessons and categories

Strength:

- careful scientific-signs posture already exists
- strongest existing foundation for creation / universe / nature learning

Weakness:

- separate domain model
- not previously surfaced in reader `Learn More`
- much of the value is locked inside world pages

### 5. Qur'an Universe / Knowledge Constellation data

Files:

- `lib/features/learn/quran_universe/data/seeded_quran_universe_data.dart`
- `lib/features/learn/quran_universe/domain/*`
- `lib/features/learn/quran_universe/presentation/*`

Current size:

- `8` universe themes
- `7` universe lessons
- `12` prophet lenses
- `12` verse links

What it contains:

- theme graphing
- prophet relationships
- place/location links
- verse-link exploration

Strength:

- valuable for thematic exploration

Weakness:

- mostly a separate constellation/knowledge graph experience
- not currently a canonical ayah teaching source for `Learn More`

### 6. Reader / Ayah `Learn More` today

Current powering files:

- `lib/features/learn/quran/presentation/quran_reader_page.dart`
- `lib/features/learn/quran/presentation/widgets/quran_reference_viewer.dart`
- `lib/features/learn/quran/application/quran_reference_graph_provider.dart`
- `lib/features/learn/quran/data/quran_reference_graph_data.dart`

Before this pass, `Learn More` showed:

- `QuranReferenceChip` references
- related life lessons
- related hadith
- related prophets
- related journeys

What powered it:

- a lightweight `QuranReferenceGraph`
- references seeded from:
  - `divineLifeLessons`
  - `seededQuranLearningVerses`
- topic tags and relationship links derived in `quran_reference_graph_data.dart`

Key limitation:

- it was mainly a cross-link graph, not a rich ayah learning model
- world/creation/scientific-signs material was not part of the main reader enrichment path

## Current vs target model

### Current

- Qur'an text: canonical and strong
- ayah education: split across three separate domains
- reader `Learn More`: relationship links first, direct educational content second

### Target

- Qur'an text remains canonical and separate
- one shared ayah-enrichment model references verses and stores lesson metadata
- separate source datasets can feed that model
- reader, hub, topic explorer, and future journeys all consume the same enrichment layer

## Root gaps found

### Ayah `Learn More`

- scalable enough for cross-links
- not strong enough for major content growth by itself
- lacked direct reuse of World & Creation content
- had no canonical schema for:
  - lesson type
  - content domain
  - caution / interpretation note
  - future scientific-signs grouping

### Learning Hub Qur'an content

- data already exists, but it is fragmented
- Qur'an Study hub uses a tiny seed set
- Divine Life Lessons and World & Creation hold much richer coverage than the main Qur'an Study seed set
- categories like creation, universe, and practical ayah guidance are underrepresented in the direct Qur'an Study dataset

## Categories already covered

Strong or moderate existing coverage:

- faith / guidance
- patience
- justice
- prayer
- repentance / mercy / hope
- gratitude
- trust in Allah
- character / adab
- creation / world reflection
- cosmology / heavens / night and day / water / oceans
- prophets-related cross-links

## Missing or shallow categories

Still weak or missing as canonical ayah-enrichment groups:

- tawhid as a dedicated ayah-learning track
- worship-linked ayah lessons beyond salah and tawbah
- du'a-specific ayah lesson grouping
- akhirah as a broader curated track
- character/adab grouped directly from ayahs
- animals / plants / mountains / rain / earth / human creation as first-class ayah-learning tracks
- linguistic/contextual notes
- interpretation/caution metadata as a first-class reusable field
- age/difficulty suitability
- broader related-ayah linking between creation, worship, prophets, and character tracks

## Starter expansion implemented in this pass

New shared layer:

- `lib/features/learn/quran/domain/quran_ayah_enrichment_models.dart`
- `lib/features/learn/quran/application/quran_ayah_enrichment_provider.dart`

What it does:

- introduces a reusable `QuranAyahEnrichmentEntry`
- keeps verse reference metadata separate from Qur'an text itself
- aggregates starter enrichment from:
  - `seededQuranLearningVerses`
  - `divineLifeLessons`
  - `worldCreationLessons`
- supports:
  - ayah reference
  - title
  - summary
  - body
  - domain
  - lesson type
  - category ids
  - tags
  - reflection prompts
  - source route handoff
  - caution note

UI hookup added:

- current reader `Learn More`
- `QuranReferenceViewer`

New behavior:

- both surfaces now show a lightweight `Ayah Insights` section backed by the shared enrichment provider
- this stays additive and does not replace existing related-life/hadith/prophet/journey links

## Legacy / duplicate paths still present

Intentionally still present:

- `seededQuranLearningVerses` remains a small Qur'an Study-specific starter dataset
- `divineLifeLessons` remains the canonical Life domain dataset
- `worldCreationLessons` remains the canonical World & Creation dataset
- `QuranReferenceGraph` still owns related-link discovery

What is now improved:

- these sources no longer need to stay isolated from ayah-level enrichment
- the new provider gives them one shared read path for future expansion

## Recommended canonical future structure

Use the new ayah-enrichment layer as the shared metadata spine:

- Qur'an text stays in `QuranRepository` / `QuranContentRepository`
- ayah enrichment stays in a shared Qur'an enrichment domain
- domain datasets feed enrichment entries through adapters or curated seed exports
- `Learn More`, Qur'an Study, World & Creation, and future thematic journeys consume the same enrichment layer

Recommended next canonical expansion order:

1. Creation / world / nature ayahs
2. Practical worship and character ayahs
3. Tawhid / prophets / akhirah curated tracks
4. richer related-ayah linking and topic filtering
5. interpretation-note and age/difficulty metadata

## Search / discoverability readiness

Good:

- `QuranReferenceGraph` already supports topic and keyword search
- Learn hub indexing already exposes Qur'an learning/world-related surfaces

Still needed:

- explicit indexing of ayah-enrichment entries if they become a user-facing browse/search collection
- canonical category ids should be reused instead of page-local topic matching
