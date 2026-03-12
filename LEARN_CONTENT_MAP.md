# Learn Content Map

Last updated: 2026-03-10

This document maps the current Learn ecosystem structure in Path of Nūr.

## 1. Learn Root

- Main tabs:
  - Qur'an
  - Life
  - World
  - Hadith
  - Notes
- Shared Learn surfaces:
  - Continue Learning
  - Suggested Next
  - Browse Themes
  - Recently Opened (collapsed section)
  - Featured item (collapsed section)
  - Overall progress summary

## 2. Qur'an Domain

### Hub surfaces

- Continue Reading
- Daily Verse
- Explorer
- Search
- Bookmarks
- Notes / Highlights
- Reading Progress / Streak
- Top Words
- Word Review
- 99 Names of الله

### Primary pages/routes

- `quranExplorer`
- `quranReader`
- `quranSearch`
- `quranBookmarks`
- `quranNotes`
- `quranTopWords`
- `quranWordReview`
- `quranNamesOfAllah`

## 3. Life Domain

### Suggested theme order

1. Family
2. Character
3. Gratitude & Reflection
4. Work, Time & Discipline
5. Community & Relationships
6. Wealth & Responsibility
7. Justice & Moral Conduct
8. Mercy, Forgiveness & Compassion
9. Hardship & Patience
10. Loss, Death & Remembrance

### Theme map

- Family
  - Parents, Elders & Family Care
  - Marriage, Children & Household Mercy
- Character
  - Intention, Integrity & Inner Work
  - Speech, Modesty & Self-Discipline
- Wealth & Responsibility
  - Lawful Earning & Responsible Spending
  - Generosity, Trust & Accountability
- Hardship & Patience
  - Inner Resilience in Trials
  - Prayer, Dua & Trust in الله
- Community & Relationships
  - Friendship, Neighbors & Belonging
  - Disagreement, Promises & Social Trust
- Work, Time & Discipline
  - Intention in Work & Excellence
  - Routine, Balance & Discipline
- Gratitude & Reflection
  - Blessings, Contentment & Presence
  - Self-Accountability & Reflection
- Justice & Moral Conduct
  - Fairness, Truth & Witness
  - Power, Responsibility & Restraint
- Mercy, Forgiveness & Compassion
  - Interpersonal Mercy
  - Forgiveness & Reconciliation
- Loss, Death & Remembrance
  - Grief, Support & Presence
  - Mortality, Accountability & Legacy

## 4. World Domain

### Suggested theme order

1. Time, Cycles & Seasons
2. Heavens, Sky & Celestial Signs
3. Water, Rain & Oceans
4. Earth, Land & Landscapes
5. Plants, Trees & Growth
6. Animals, Birds & Insects
7. Travel, Reflection & Signs in the World

### Theme map

- Time, Cycles & Seasons
  - Night, Day, Dawn & Sunset
  - Seasons, Change & Human Time
- Heavens, Sky & Celestial Signs
  - Moon & Sun
  - Stars, Sky Order & Vastness
- Water, Rain & Oceans
  - Rain, Clouds & Revival
  - Rivers, Seas & Dependence
- Earth, Land & Landscapes
  - Mountains & Terrain
  - Paths, Roads & Settlement
- Plants, Trees & Growth
  - Seeds, Crops & Cultivation
  - Fruits, Trees & Gardens
- Animals, Birds & Insects
  - Bees & Insects
  - Birds, Livestock & Wild Creatures
- Travel, Reflection & Signs in the World
  - Observing the Earth
  - History, Ruins & Lessons

## 5. Hadith Domain

### Suggested theme order

1. Character & Manners
2. Worship & Intention
3. Family & Society
4. Speech, Honesty & Trust
5. Mercy, Compassion & Service
6. Hardship, Patience & Trials
7. Gratitude, Humility & Self-Discipline
8. Community, Brotherhood & Responsibility
9. Life & World Lessons from Hadith

### Theme map

- Character & Manners
  - Honesty & Integrity
  - Gentleness & Adab
- Worship & Intention
  - Sincerity & Niyyah
  - Consistency & Remembrance
- Family & Society
  - Parents & Kinship
  - Marriage & Home Life
- Speech, Honesty & Trust
  - Guarding the Tongue
  - Promises & Trustworthiness
- Mercy, Compassion & Service
  - Care for the Vulnerable
  - Neighbors & Hospitality
- Hardship, Patience & Trials
  - Patience & Reliance
  - Emotional Resilience
- Gratitude, Humility & Self-Discipline
  - Gratitude & Contentment
  - Humility & Self-Accounting
- Community, Brotherhood & Responsibility
  - Brotherhood & Sisterhood
  - Justice & Public Responsibility
- Life & World Lessons from Hadith
  - Time & Mortality
  - Stewardship & Observation

## 6. Notes Domain

### Notes surfaces

- Learn Notes Landing
- Saved Notes
- Reflections
- Highlights

### Notes role in Learn

- Receives reflection actions from Life/World/Hadith lesson pages
- Supports resume reflection behavior in unified Learn flow

## 7. Shared Lesson Detail Template (Life/World/Hadith)

- Header metadata:
  - Theme
  - Subcategory
  - Progress status
  - Completion quality
- Primary reading flow:
  - Overview
  - Domain perspective section
  - Practical / reflective takeaway
  - Key themes
  - Reflection prompt
- Secondary (collapsed by default):
  - Comparative teachings
  - Citation panel
- Continuation/actions:
  - Related lessons
  - Cross-domain related content
  - Suggested next lesson
  - Mark in-progress / completed
  - Quality selection (not read/read/reflected/applied)
  - Add reflection CTA

## 8. Route Index (Learn-related)

- Learn root:
  - `NavTab.learn.path` (`/learn`)
- Qur'an:
  - `quranExplorer`
  - `quranReader`
  - `quranSearch`
  - `quranBookmarks`
  - `quranNotes`
  - `quranTopWords`
  - `quranWordReview`
  - `quranNamesOfAllah`
- Life:
  - `learnLifeLanding`
  - `lifeThemeDetail`
  - `lifeSubcategoryDetail`
  - `lifeLessonDetail`
  - `babyNamesHome`
- World:
  - `learnWorldLanding`
  - `worldThemeDetail`
  - `worldSubcategoryDetail`
  - `worldLessonDetail`
- Hadith:
  - `learnHadithLanding`
  - `hadithThemeDetail`
  - `hadithSubcategoryDetail`
  - `hadithLessonDetail`
  - `learnHadithImportant`
  - `learnHadithImportantDetail`
- Notes and shared:
  - `learnNotesLanding`
  - `journalTimeline`
  - `journalCreate`
  - `learnContentDetail`
  - `islamicGuides`
  - `quranLessonsMapping`

## 9. Maintenance Note

When adding new Learn content, update this file in the same PR/commit:

1. Add/adjust theme and subcategory hierarchy.
2. Add/adjust route names if new Learn pages are introduced.
3. Update "Last updated" date.
