// Islamic Trivia authoring guide
//
// IDs
// - Use stable ids like `quran_easy_001` or `prophets_med_004`.
// - Never base ids on list position alone after release.
//
// Packs
// - Add new questions inside `data/packs/...`.
// - Keep each file focused on one category or seasonal pack.
//
// Questions
// - Prefer `multipleChoiceQuestion(...)` or `trueFalseQuestion(...)`.
// - Always include a concise explanation.
// - Add `quranReference` or `sourceReference` when appropriate.
// - Use `learningNote` for gentle educational context, not for required facts.
//
// Daily quiz
// - Mark only broadly suitable, compact questions as `dailyEligible: true`.
// - Exclude niche, seasonal, or context-heavy prompts when needed.
//
// Status
// - `active` questions are playable.
// - `draft` and `archived` questions stay out of normal pools.
//
// Validation
// - The repository runs validation in debug mode using
//   `TriviaContentValidator`.
// - It checks duplicates, empty prompts, invalid categories, invalid options,
//   and broken true/false structures.
//
// Quality bar
// - Keep prompts short and clear.
// - Avoid trick wording.
// - Prefer respectful, well-known starter knowledge in public packs.
// - Use tags consistently so future filtering and curation remain reliable.
