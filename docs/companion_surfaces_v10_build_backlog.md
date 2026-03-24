# Companion Surfaces V10 Build Backlog

Date: 2026-03-23

## Completed in V10

1. Seerah companion surface
   - canonical route `/learn/seerah` is live
   - lightweight adult/main landing surface now reuses Seerah journey progress, guided period cards, and owned Prophets / Hadith / History / Qur'an handoffs
   - focused entry states for `hijrah` and `madinah-society` are live through query-based focus

2. Character / Adab companion surface
   - canonical route `/learn/character` is live
   - trait-led landing surface now reuses the `beautiful-character` journey plus curated Divine Life / Hadith / Qur'an handoffs
   - Learn taxonomy now routes Character & Adab into the owned surface

3. Daily Wisdom / Reflection companion surface
   - canonical route `/learn/daily-wisdom` is live
   - lightweight daily wisdom page now exposes one featured reminder, a practical step, and recent owned source handoffs
   - Learn taxonomy now surfaces Daily Wisdom under Tools & Explore

## Safe remaps completed

- `seerah-journey` -> `/learn/seerah`
- `seerah-hijrah` -> `/learn/seerah?focus=hijrah`
- `seerah-madinah-society` -> `/learn/seerah?focus=madinah-society`
- `beautiful-character` -> `/learn/character`
- `wisdom-daily-quote` -> `/learn/daily-wisdom`

## Enhancement options

1. Expand Seerah companion depth
   - add more Seerah periods such as Treaty of Hudaybiyyah, Conquest of Makkah, and Farewell Hajj
   - add richer Qur'an-linked Seerah references using the shared Qur'an reference link pattern where structured references are shown
   - consider a calmer period-specific source strip when learners arrive from focused Hijrah or Madinah handoffs

2. Expand Character / Adab practical depth
   - add more scenario cards for online speech, work, apology/repair, and neighbor rights
   - curate tighter handoff filters into Divine Life / Hadith / Qur'an source owners
   - consider one lightweight “practice this today” card if product wants a stronger action layer without adding tracking

3. Expand Daily Wisdom breadth
   - grow the vetted daily wisdom entry set
   - add source-theme rotation without introducing a scheduling engine
   - consider a future Home handoff card if product review wants higher visibility

## Completed in V11

1. Seerah depth and refinement
   - period cards now include stronger why-it-matters descriptions
   - a new turning-points module now connects Seerah to the wider history owner
   - focused Hijrah / Madinah entry states now surface richer context and move the relevant card to the top

2. Character / Adab depth and refinement
   - trait cards now include practical trait explanations instead of summary-only copy
   - scenarios now include intentions and anger/self-control alongside richer daily-life descriptions
   - source handoffs now read more intentionally instead of generic owner subtitles

3. Daily Wisdom depth and refinement
   - the wisdom set is now larger and more rotation-friendly
   - the featured entry now carries a theme label plus a dedicated source-owner handoff block
   - rotation logic now walks a deterministic ordered set instead of relying on the older small-card slice

## Guardrails

- do not remove `learnLegacy` fallback until each replacement surface is live and validated
- do not duplicate Prophets, Hadith, History, or Journal ownership
- keep all new user-facing copy localization-ready
