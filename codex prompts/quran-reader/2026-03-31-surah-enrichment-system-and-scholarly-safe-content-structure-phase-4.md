===== PHASE 4 PROMPT — SURAH ENRICHMENT SYSTEM + SCHOLARLY-SAFE CONTENT STRUCTURE =====

PRIMARY OBJECTIVE === BUILDING SURAH ENRICHMENT SYSTEM + SCHOLARLY-SAFE CONTENT STRUCTURE

You are working inside the existing Flutter codebase for Path of Nūr.

This is a production-ready architecture + content system pass.
Do not build placeholders.
Do not break existing Qur’an flows, main Qur’an landing page, Quran Summary page, Surah Summary Detail page, reader integration, playback, localization, theme behavior, accessibility, or shared widget systems.

IMPORTANT SAFETY + EXECUTION RULES
- Audit first before editing anything.
- Do not remove, delete, or overwrite working records, seeded content, routes, providers, widgets, or current Qur’an systems unless they are clearly and safely replaced.
- Do not go haywire and remove/delete records for no reason.
- Preserve route integrity, current feature behavior, theme reuse, localization structure, and content readability.
- Keep this phase maintainable and future-safe.
- At the very end, run a full audit and provide one clean implementation summary.

PHASE CONTEXT
Phase 1 introduced:
- Quran Summary Island on the main Qur’an page
- Quran Summary page
- 114-surah summary dataset
- search/filter
- initial Qur’an summary visual identity

Phase 2 introduced:
- Surah Summary Detail experience
- reader integration
- action surfaces such as Open in Reader / Start Reading / Resume

Phase 3 introduced:
- reusable Qur’an theme/token system
- reusable Qur’an header/hero system
- extracted shared Qur’an UI components

Now Phase 4 should enrich the actual surah content model while keeping the content structure careful, clean, and scholarly-safe.

GOAL OF THIS PHASE
Turn the Surah Summary Detail experience into a richer Qur’an discovery/study layer by introducing a proper enrichment system for each surah, without yet turning the app into a heavy tafsir platform.

The system should support for each surah:
- short summary
- key themes
- notable ayat references
- related prophets/events
- virtues / common recitation associations where appropriate
- optional reflection prompts
- content confidence / attribution safety structure

This phase is as much about CONTENT MODELING as UI.

A. AUDIT FIRST
Before making changes, audit and identify:
- where the current 114-surah summary dataset is stored
- what the current surah domain model looks like
- how the current Surah Summary Detail page is rendered
- whether there is already any Quran metadata model in the app that can be reused
- whether there are existing note/reflection/favorites/bookmark systems that future enrichment could tie into
- whether there are existing content section widgets from Learn / Qur’an / Journey that can be reused
- whether any current summary wording is too absolute, too interpretive, too verbose, or inconsistent in style
- where localization currently stops and seeded content begins
- whether there is already an attribution/content-source pattern elsewhere in the app

Before coding, identify:
- target files to modify
- new files/models/repositories to add
- whether to migrate the current summary dataset to a richer structure
- how to avoid making the data file unmaintainable
- new localization keys likely needed
- any current content quality issues that should be normalized during this pass

B. CREATE A PROPER SURAH ENRICHMENT DATA MODEL
Build a scalable typed data model for enriched surah content.

Recommended structure should support at minimum:
- surahNumber
- transliteratedName
- arabicName
- englishMeaning
- verseCount
- revelationType
- shortSummary

New enrichment fields should support:
- keyThemes: list of short, normalized theme labels
- notableAyat: list of ayah references with short labels or reasons
- relatedProphets: list of prophet identifiers/names if applicable
- relatedEvents: list of key event/story references
- virtues: optional list of careful virtue/recommendation items
- reflections: optional list of short reflection prompts
- keywords/searchAliases: optional search helpers
- contentNotes or editorialNotes: internal-use-safe structure if needed
- attributionCategory / confidenceCategory / evidenceLevel for safer content handling

Keep the structure typed and maintainable.
Do not use giant untyped nested map chaos.

C. INTRODUCE A SCHOLARLY-SAFE CONTENT STRUCTURE
This is critical.

The current summaries and future enrichments must be structured so Path of Nūr can remain careful and responsible.

Implement a content safety / confidence structure such as:
- Quran-explicit
- broadly accepted classical understanding
- widely taught thematic summary
- devotional/common recitation association
- requires-source-review
- editorial synthesis

Use a naming scheme that fits the codebase, but the idea is:
content sections can be tagged internally by confidence/evidence type so future reviews are easier.

For example:
- “Surah Yusuf tells the story of Prophet Yusuf” = high confidence
- “Often recited on Friday” = may require careful source handling depending on the surah and wording
- “Protects from X” = only include if grounded and clearly categorized

Do NOT clutter the UI with internal labels everywhere.
This is mainly for architecture, editorial quality, and future review.

D. NORMALIZE THE CONTENT STYLE
As part of this phase, normalize the content tone across all surahs.

Requirements:
- concise
- reverent
- readable
- not overly polemical
- not unnecessarily absolute where scholarly nuance is appropriate
- not excessively long
- consistent structure across surahs

Do not make every surah identical in length, but improve consistency.
Where current copy is too long, tighten it.
Where current copy is too sharp or denominationally loaded in user-facing phrasing, soften it into safer, accurate wording while preserving Islamic integrity.

Do not water down core Islamic meaning.
Do make the language app-safe, user-safe, and broadly readable.

E. ENRICH THE SURAH DETAIL EXPERIENCE
Update the Surah Summary Detail page to render enriched sections when data exists.

Recommended section order:
1. Header / Hero
2. Overview
3. Key Themes
4. Notable Ayat
5. Related Prophets / Events
6. Virtues / Recitation Notes (only where appropriate and safely grounded)
7. Reflection Prompts
8. Actions (Open in Reader, Start Reading, Resume if supported)

Each section should:
- use the reusable Qur’an design system from Phase 3
- remain readable and compact
- degrade gracefully when content is absent
- avoid giant walls of text

F. KEY THEMES SYSTEM
Implement a normalized theme system.

Examples of theme categories:
- Tawhid
- Revelation
- Guidance
- Mercy
- Judgment
- Patience
- Repentance
- Prophethood
- Resurrection
- Worship
- Law
- Community
- Gratitude
- Justice
- Signs of Creation
- Hypocrisy
- Charity
- Family
- Struggle
- Paradise and Hell

Approach:
- use concise labels
- reuse theme chips/tags across the app where possible
- prepare the system so future thematic browsing can be built on top of it

Do not overbuild theme ontology.
Start with a practical, controlled set.

G. NOTABLE AYAT MODEL
Add support for notable ayat references per surah.

Each notable ayah entry may include:
- surah number
- ayah number or ayah range
- short label
- optional short why-it-matters line

Examples:
- Ayat al-Kursi in Al-Baqarah
- Verse of Light in An-Nur
- “With hardship comes ease” in Ash-Sharh
- Laylat al-Qadr in Al-Qadr

Important:
- do not dump long verse translations unless the project already has a licensed/approved translation structure in place
- prefer references and short descriptors for now
- make these tappable in future if the reader can deep-link to an ayah
- if ayah deep linking is already safely available, structure for it now but do not break current routing

H. RELATED PROPHETS / EVENTS
For surahs with stories or historical episodes, support compact related content.

Examples:
- Prophets: Adam, Nuh, Ibrahim, Musa, Yusuf, Isa, Muhammad ﷺ, etc.
- Events: Badr, Uhud, Tabuk, Hijrah-related context, People of the Cave, Night Journey, Army of the Elephant, etc.

UI guidance:
- compact chips or concise rows
- no overload
- omit sections entirely if not applicable

Structure this so future “tap prophet” or “tap story” navigation can be added later.

I. VIRTUES / RECITATION NOTES — ONLY IF CAREFUL
Add a safe structure for virtues and recitation associations.

Important rules:
- only include where widely known / commonly taught / safely sourceable
- keep wording careful and non-sensational
- do not overstate benefits
- do not fill all surahs with speculative virtues
- if evidence is not strong enough for user-facing display, keep the structure ready internally but do not show noisy weak content

Good examples of safer framing:
- “Often recited on Fridays”
- “Commonly memorized early”
- “Widely known for its emphasis on Tawhid”
- “Frequently recited for reflection on divine protection”

Avoid:
- exaggerated promises
- unsupported miracle claims
- blanket claims without review
- sectarian or inflammatory phrasing

J. REFLECTION PROMPTS
Add optional short reflection prompts for selected surahs.

These should be:
- brief
- spiritually useful
- calm
- not preachy overload
- suitable for Path of Nūr tone

Examples:
- “What guidance am I asking Allah for most right now?”
- “Where do I need more patience and trust?”
- “What signs of Allah’s mercy am I overlooking?”
- “What worldly distraction is pulling me away from remembrance?”

Do not generate too many.
One to three concise prompts per surah is enough where supported.

K. FUTURE-READY EDITORIAL / CONTENT REPOSITORY STRUCTURE
Organize content so future editorial improvement is practical.

Suggested options depending on repo patterns:
- one enriched data file per surah group/juz range
- split files by ranges such as 1–10, 11–20, etc.
- repository/service layer returning a typed enriched model
- content registry structure for future multilingual support

Avoid:
- one massive impossible-to-maintain widget file
- mixing raw content directly into page widgets
- burying editorial content in UI logic

Structure should support future:
- localization of summaries
- scholar review pass
- simplified mode / kids mode
- deeper tafsir mode
- curated ayah highlights
- topic-based Qur’an exploration

L. SEARCH / DISCOVERY PREP
Without fully building thematic browsing yet, prepare the model so future discovery can support:
- search by theme
- search by prophet
- search by event
- search by keyword
- “surahs about patience / Musa / tawhid / judgment” style browsing

This means:
- include normalized tags/aliases where useful
- do not yet clutter the current UI with too many controls unless the page already has a natural place for them

M. UI REQUIREMENTS
Update the detail page UI to render enriched content using shared Qur’an components from Phase 3.

Requirements:
- elegant section headers
- clean chips/tags
- readable spacing
- no visual clutter
- no giant stacked card overload if a lighter section presentation fits better
- preserve accessibility and contrast

Gracefully handle missing sections.
Do not show empty headers.

N. LOCALIZATION
All new user-facing labels must be localization-ready.

Likely keys may include:
- Key Themes
- Notable Ayat
- Related Prophets
- Related Events
- Reflection Prompts
- Virtues
- Recitation Notes
- Open in Reader
- Start Reading
- Resume Reading
- No enrichment available
- Overview

At the end, report:
- new localization keys added
- locale resources updated

O. TESTING / VALIDATION
After implementation:
- run analyzer on changed files
- verify Quran Summary page still works
- verify Surah Detail page still opens correctly
- verify enriched sections appear only where valid
- verify no empty/awkward section rendering
- verify reader integration still works
- verify routing/back navigation still works
- verify data model is clean and scalable
- verify no regressions in light/dark/accessibility modes

P. DELIVERABLE REPORT
At the end provide one clean implementation summary:
1. Audit findings
2. Data model changes
3. How scholarly-safe content structure was implemented
4. How content tone/normalization was improved
5. Files changed
6. New enriched sections added to the UI
7. How notable ayat / prophets / events / virtues were modeled
8. Localization keys added
9. Analyzer/test results
10. Follow-up recommendations for Phase 5

PHASE 4 PRODUCT INTENT
By the end of this phase, Path of Nūr should have a much richer Qur’an discovery layer that remains:
- beautiful
- structured
- careful
- scalable
- editorially safer
- ready for future scholar review and multilingual expansion

The user should feel that each surah now offers:
- a concise overview
- key themes
- important ayah anchors
- relevant prophets/events
- thoughtful reflection
- a smooth path into the actual reader

IMPORTANT
Build this as a real system, not a one-off content dump.
Do not overbuild full tafsir.
Do not create messy hardcoded UI/content coupling.
Do not make unsupported claims in user-facing content.
Do not regress the current Quran Summary and reader flows.

At the very end, run a final audit and provide one complete implementation summary.
===== END PHASE 4 PROMPT =====
