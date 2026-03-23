# Qur'an Reader Transport Backlog

Date: 2026-03-22

## Shipped In Phase 6

- Explicit previous ayah transport
- Explicit next ayah transport
- Explicit restart current ayah transport
- Persistent follow mode toggle
- Same-surah transport boundary handling
- Transport target resolution extracted into a shared helper

## Recommended Next Enhancements

1. Add a page-level fake-player integration harness for `QuranReaderPage`
   - Verifies transport buttons against a simulated player/index stream
   - Validates follow-on and follow-off scroll behavior directly

2. Add a temporary follow suspension policy after aggressive manual scrolling
   - Current behavior keeps follow enabled and resumes on the next ayah change
   - A future pass could temporarily suspend following until the user re-centers or re-enables it

3. Separate seek controls from ayah transport more clearly
   - The current card supports both `-15/+15` and ayah stepping
   - A later UX pass can decide whether both belong in the compact transport surface

4. Revisit repeat/range interaction with transport
   - Current transport preserves the existing repeat system
   - A future pass could clarify how previous/next/restart should interact with active loop ranges

5. Add explicit memorization-context transport QA
   - Current transport reuses the same playback pipeline safely
   - A later pass should add deeper tests around hidden/first-word reveal modes during transport
