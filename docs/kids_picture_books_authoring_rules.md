# Kids Picture Books — Authoring Rules

Last updated: 2026-09-04

Every kids story is a picture book: a run of spreads, one picture over one to three lines, read by a parent or by a child of six to eight on their own. This is the contract behind `lib/features/kids/bedtime_stories/data/books/` and the test `test/features/kids/bedtime_stories/kids_books_content_test.dart`, which fails a book that breaks it.

Plan and rationale: the Kids Bookshelf Rewrite artifact (2026-09-04).

## The book

- **8 to 14 spreads.** Fourteen is a full story. Eight is the short book a prophet with a line or two in the Qur'an gets.
- **A spread is one to three lines and never more than 20 words.** One picture per spread; the writer decides the page breaks, not an algorithm.
- **One refrain, three times.** Mark those spreads `isRefrain: true`. A child who cannot read yet can still say the refrain.
- **Day voice.** No "…" trailing off, no whispered pacing, no "Good night" in the text. Bedtime is a mode: put the closing spread in `bedtimeClosing` and the reader shows it only when the book is opened at bedtime.
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
- **A rewrite keeps the id of the seed it replaces** and replaces that entry in the older list (`kBedtimeProphetStories`, `kKidsIslamicStories`, `kKidsSeerahCompanionStories`). Quizzes, memory decks, progress and related-story links are all keyed on the id.
- A new book goes in `kKidsPictureBooks`.
- English now; each file is shaped so the locale-keyed seed (K6) can take it mechanically. German follows once the voice is approved.
