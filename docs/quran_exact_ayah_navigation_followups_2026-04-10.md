## Quran Exact Ayah Navigation Follow-ups

- Add a focused integration test that launches the reader from a Qur'an-sourced dua route and asserts the target ayah card becomes visible after startup.
- Add a small router deep-link test matrix for widget and notification URLs that include `ayah`, `endAyah`, `autoplay`, and `playback`.
- Consider centralizing reader startup routing state into a tiny dedicated coordinator if future search, widgets, and notifications add more route-triggered behavior.
- When Quran search expands, keep route-targeted focus as the single startup path and avoid adding page-local jump logic in search results.
