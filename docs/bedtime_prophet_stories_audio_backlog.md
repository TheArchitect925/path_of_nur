# Bedtime Prophet Stories Audio Backlog

## Enhancement Options

- Add final narrated MP3 assets for all 14 seeded stories under `assets/audio/bedtime_stories/prophets/`.
- Add localized bedtime story content packs so seeded `title`, `lesson`, and `ttsText` can move from English-first source content into locale-aware authored resources.
- Add lightweight artwork for each prophet story under `assets/images/prophets/bedtime_stories/`.
- Add a small “Good night” completion state with a calmer end card once a story finishes.
- Add optional autoplay-next for multipart Prophet Muhammad story parts, behind a kids-safe setting.
- Add parental controls for locking longer `kidsPlus` stories until a profile age threshold is met.
- Add a bedtime streak summary surface if it can reuse the existing Journey streak model cleanly.
- Add transcript paragraph anchors to support future audio-sync highlighting without rebuilding the story model.
- Add a prophet series completion marker for finishing all four Prophet Muhammad parts.
- Add quizzes or reflection prompts after bedtime listening only if they remain optional and do not disturb the calm listening flow.

## Housekeeping

- Decide whether bedtime stories should also surface from the Kids landing page directly in addition to shared Learn search/discovery.
- Add focused controller tests for first-completion reward dedupe once the reward providers are easy to override in isolated unit tests.
- Reconcile prose-source docs and live seed data whenever new story revisions are supplied.
