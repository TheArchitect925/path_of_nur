# Qur'an User Intent Personalization Backlog

1. Decide whether the active Qur'an focus should later appear as a tiny reversible preference row inside `/quran/daily` and `/quran/paths`, or remain hub-first to avoid over-signaling personalization.
2. Evaluate whether manual reader mode switching should optionally update the saved Qur'an intent when the user repeats the same mode choice often, without turning the system into implicit behavior tracking.
3. Consider one small “Recommended for your focus” module on the Learn-side Qur'an hub after product QA confirms the new main `/quran` focus card stays helpful without crowding the surface.
4. Expand intent-aware daily companion copy only through short curated variants, especially for `understand` and `themes`, rather than introducing dynamic recommendation text.
5. Decide whether guided-path intent should later prefer the last unfinished path step across both `/quran` and `/quran/learning`, or remain scoped to the current lightweight path continuity model.
6. Expand Journey → Qur'an intent-aware routing only for explicitly mapped stages where memorization or reflection entry adds real value, rather than applying intent overrides to every Journey handoff.
7. Run on-device QA for the new intent selector on small screens, large text, and VoiceOver/TalkBack to confirm the focus chips remain readable and easy to change.
