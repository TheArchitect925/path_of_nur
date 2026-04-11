# Phase Fix — Stabilize Current Playing Ayah Ownership And Resume Playback Follow Mode

PRIMARY OBJECTIVE === FIX THE BROKEN CURRENT-AYAH PLAYBACK HIGHLIGHTING AND FOLLOW-SCROLL BEHAVIOR IN THE QURAN READER WITHOUT BREAKING SEARCH, ROUTING, OR PLAYBACK

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on an already completed audit.
Do not redesign the UI.
Do not rewrite the playback architecture unnecessarily.
Do not break reader routing, exact-ayāh navigation, search, localization, reciter switching, or reader-search features.

CONTEXT
The audit found two highest-confidence issues:
1. CURRENT AYAH OWNERSHIP IS UNSTABLE DURING PLAYBACK TRANSITIONS

- Reader playback ayah is derived mainly from just_audio.currentIndex
- In surah mode, when currentIndex is temporarily null, the current reader ayah resolution falls back to session index 0
- That can point the UI to the wrong ayah during transition windows

2. FOLLOW MODE SUSPENSION IS STICKY

- User scrolls and reader-search jumps can suspend follow mode
- handleUserScrollSettled() is currently empty
- There is no automatic resume path after suspension
- As a result, follow-scroll can stop working and never recover on its own

Secondary audit finding:
3. Playback highlight may be visually subtle and can be masked by route/search highlighting, but this should only be addressed after fixing ayah ownership and follow orchestration.

GOAL
Fix:
- current playing ayah resolution during playback transitions
- follow-mode suspension/resume behavior
so the currently playing ayah is correctly highlighted and the reader follows playback reliably again.

IMPLEMENT THE FOLLOWING

A. STABILIZE CURRENT PLAYING AYAH OWNERSHIP
- Audit the reader playback ayah resolution in:
- quran_reader_playback_controller.dart
- quran_reader_playback_state.dart
- Remove the unsafe surah-mode fallback that resolves a temporary null currentIndex to session index 0.
- Replace it with a safer transition strategy, such as:
- previous valid active ayah
- explicit source-state target ayah
- or another repo-grounded transition-safe ayah owner
- The reader’s playback-facing current ayah should remain stable and should not jump back to the first ayah during transient index-null windows.

B. KEEP ONE CANONICAL READER PLAYBACK AYAH
- Preserve QuranReaderPlaybackState.activeAyahKey as the canonical reader playback ayah.
- Reduce ambiguity between overlapping ayah states where possible.
- Ensure the reader UI follows the stabilized canonical playback ayah state.

C. FIX FOLLOW MODE RESUME BEHAVIOR
- Implement a clear and production-safe resume policy for follow mode after temporary suspension.
- Preferred behavior:
- user/manual scroll can suspend follow
- in-reader search jumps can suspend follow
- follow does NOT instantly yank the user back on scroll settle
- follow resumes automatically on the next ayah change during active playback
- If the repo structure suggests a slightly better grounded variant, use it, but keep the behavior calm and predictable.
- handleUserScrollSettled() should no longer remain a no-op if that is part of the fix path.

D. PRESERVE INTERACTION SAFETY
- Keep exact-ayah search navigation safe.
- Keep in-reader search next/prev safe.
- Keep autoplay and selection-loop routes safe.
- Keep manual scroll respected.
- Do not let follow mode fight the user unnecessarily.

E. VERIFY CURRENT AYAH HIGHLIGHTING
- After stabilizing ayah ownership and follow behavior, confirm whether the current ayah highlight now correctly tracks playback.
- Do not redesign the card UI yet unless the audit shows the highlight is still objectively too ambiguous after logic is fixed.
- Only make minimal visual distinction adjustments if absolutely necessary and safe.

F. VALIDATE THESE FLOWS
At minimum validate:
- manual play in reader
- autoplay route into reader
- surah playback progression
- pause/resume
- user scroll during playback, then next ayah progression
- in-reader search jump during playback, then next ayah progression
- search-result-to-reader then playback
- deeper ayah playback cases, not only first verses

G. DO NOT BREAK
- quran_navigation.dart
- canonical /quran/surah/:surahNumber route
- exact ayah landing from search
- /quran/search
- /quran/knowledge-search
- in-reader search highlighting
- reader search sheet stability
- reciter switching
- session restore
- playback retry/fallback handling
- word-sync highlighting behavior unless a separate issue is clearly found

H. KEEP THE CHANGESET TIGHT
- Fix current-ayāh ownership and follow resume behavior first.
- Do not redesign the reader UI in this pass.
- Do not refactor the entire playback stack.
- Prefer the smallest production-ready fix that solves the actual broken behavior.
