# Kids Picture Books — Authoring Rules

Last updated: 2026-09-04

Every kids story is a picture book: a run of spreads, one picture over one to three lines, read by a parent or by a child of six to eight on their own. This is the contract behind `lib/features/kids/bedtime_stories/data/books/` and the test `test/features/kids/bedtime_stories/kids_books_content_test.dart`, which fails a book that breaks it.

Plan and rationale: the Kids Bookshelf Rewrite artifact (2026-09-04).

## The book

- **8 to 14 spreads.** Fourteen is a full story. Eight is the short book a prophet with a line or two in the Qur'an gets.
- **A spread is one to three lines and never more than 20 words.** One picture per spread; the writer decides the page breaks, not an algorithm.
- **One refrain, three times.** Mark those spreads `isRefrain: true`. A child who cannot read yet can still say the refrain.
- **Day voice.** No "…" trailing off, no whispered pacing, no "Good night" in the text. Bedtime is a mode: put the closing spread in `bedtimeClosing` and the reader shows it only when the book is opened at bedtime (the Bedtime shelf and Tonight's pick open a story with `?bedtime=1`; the story page then says "Read tonight").
- **What the reader shows from a spread** (C2a): the refrain line in the accent colour and a heavier weight, `arabicLine` under the lines in the Qur'an face, `quranRef` as a small tappable "Qur'an s:a" chip, `tryItRoute` as a "Try it" button. Nothing else on the page.
- **The first spread names the prophet in full once** ("Prophet Yunus, peace be upon him"); the story then uses the name alone.
- **The last spread is Remember:** the lesson in the child's words, usually carrying the refrain. First Steps books end in a `tryItRoute` instead, opening a real tool.
- **`summary` and `lesson` are required.** They are what a parent reads on the story page and in About this story.
- Written for six to eight. The duʿā picture stories already cover three to five; mark a book `kidsPlus` only when its story needs it (the four-book Muhammad ﷺ series).

## What we write from

- The Qur'an's account first, then widely accepted seerah. Every prophet book carries the ayah it rests on as a structured `QuranQuoteRef`; a spread may carry its own `quranRef` as a caption.
- **No invented speech for prophets.** Only what the Qur'an reports, paraphrased for a child. Where a book fills a gap with the classical explanation, `sourceNote` says so.
- Hadith stories for children come only from Bukhari and Muslim; the reference goes in `hadithReference`.
- Honorifics once in full, then the mark (ﷺ, عليه السلام).
- A source review before a book ships, by the owner or a scholar they trust. Nothing in the tests replaces that.

## Pictures

- **Prophets are never drawn.** A prophet spread shows what the prophet saw: the ark, the well, the fish, the cave, the plant.
- Manners, First Steps and duʿā books share one cast: Safa (7), her brother Zayn (5), their cousin Amina (4), and the cat Misk. Drawn the way the salah trainer draws its figure: outline, plain face.
- Art comes from the generator pipeline under `tooling/art_src/` (SVG → WebP, 40–120 KB, both themes). No painted raster, no faces, no text baked into a picture.
- A spread borrows a `KidsBookAtlasScene` until its own `illustrationAsset` is drawn; a spread with neither shows the cover (first spread) or backdrop. Books ship before their unique scenes are finished.
- A firefly hides on every unique scene. Finding it is the reason to look at every picture twice.

## Where a book lives

- One file per book under `data/books/<shelf>/<book>.dart`, built with `kidsPictureBook(...)`, which derives `ttsText`, the duration and the scene manifest.
- **Stories from the Qur'an** (`data/books/quran_stories/`, ids `book_quran_<slug>_v1`, sortOrder 400+): each page carries a `quranRef` to the ayah it retells, the source note names the passage, and anything taken from the seerah rather than the Qur'an is said so in the note. These books may borrow scenes from the prophet books (Maryam uses Isa's, the Ant uses Sulayman's); they never use the child cast, and no person is ever drawn.
- **Friends of the Prophet ﷺ** (`data/books/friends/`, listed from `kids/seerah/data/companion_story_seed.dart` as `kKidsSeerahCompanionStories`, sortOrder 245+): companions are shown by what they saw and held (a cloak on a bed, a millstone, a shoe of water), never drawn; hadith only from Bukhari or Muslim, with the number in `hadithReference`; anything from the seerah is named as such in the source note. The first three ids (`story_companion_khadijah_support_v1`, `..._abu_bakr_friendship_v1`, `..._bilal_patience_v1`) are referenced by the seerah journey and The Call, so they never change. Stories the Prophet ﷺ told (the Thirsty Dog, the Three in the Cave) live on this shelf too.
- **Good Manners** (`data/books/manners/`, listed from `data/kids_islamic_story_seed.dart` as `kKidsIslamicStories`, sortOrder 210–300): the cast carries every story (Safa 7, Zayn 5, Amina 4, the cat Misk, and Mama, Baba, Grandma, Grandpa), drawn on the K3 scenes from `generate_kids_story_scenes.mjs`; each book keeps the id its quiz (`quizRefs`), memory deck (`memoryRefs`) and narration slot (`audioManifestRef`) were written for, so the ten ids never change. Every book cites an ayah or a Bukhari/Muslim hadith even when the source category is manners.
- **German (C6).** Every book carries its German as `de: const KidsBookTranslation(...)` in the same file: title, shortTitle, summary, lesson, refrain, bedtimeClosing and the lines of every spread, in English order and number. Pictures, ayah refs, Arabic and Try it stay on the English spreads; `BedtimeStorySeed.localized('de')` swaps the text and re-derives the read-aloud text, and `localizedBedtimeStorySeedsProvider` does that once for the app locale, so the library, the reader and the voice (`de-DE`) follow. Rules: the child is addressed as *du*; up to 24 words a spread (German runs longer); the German refrain returns three times, matched case-insensitively inside a line; no “…”, no “Gute Nacht” in the lines (the closing may say it); names stay as in English except Khadija, Fatima, Dschibril, Dschanna, Mekka, Medina, Kaaba, Quran, Haddsch. The content test fails any book without a `de` block.
- **A rewrite keeps the id of the seed it replaces** and replaces that entry in the older list (`kBedtimeProphetStories`, `kKidsIslamicStories`, `kKidsSeerahCompanionStories`). Quizzes, memory decks, progress and related-story links are all keyed on the id.
- A new book goes in `kKidsPictureBooks`; a prophet book goes in `kBedtimeProphetStories`, whose `sortOrder` values run in the order of the chain (Adam 10 … Muhammad ﷺ 140) and must stay unique. Write the book's `id:` as a literal string: the narration kit finds stories by that line.
- English now; each file is shaped so the locale-keyed seed (K6) can take it mechanically. German follows once the voice is approved.
