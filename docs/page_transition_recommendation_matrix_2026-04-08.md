# Page Transition Recommendation Matrix

Date: 2026-04-08

## Recommended transition set

- `Default`
- `Gentle fade`
- `iOS-style`
- `None`
- `Reduce-motion safe`

## Recommendation by surface

### Root tabs

- Surface:
  - `/worship`
  - `/learn`
  - `/home`
  - `/journey`
  - `/quran`
- Recommended:
  - `None` or `Default`
- Safest choice:
  - `None`
- Why:
  - Root tabs behave more like section switching than drill-down navigation.
  - These surfaces already have bottom navigation and now support horizontal swipe between tabs.
  - Heavier motion here can make the app feel busy and can conflict with the feeling of “switching sections” rather than “opening a page.”

### Standard drill-down pages

- Surface:
  - Learn domain pages
  - Hadith details
  - Divine Life Lessons
  - World pages
  - Dua pages
  - Journey detail pages
- Recommended:
  - `Default` or `Gentle fade`
- Safest choice:
  - `Default`
- Best enhanced choice:
  - `Gentle fade`
- Why:
  - These pages are mostly calm reading and exploration surfaces.
  - `Gentle fade` suits the product tone without adding directional conflict.
  - `Default` remains safest for back-stack expectations and existing push/pop behavior.

### Apple drill-down navigation

- Surface:
  - iPhone and iPad push/pop pages
  - pages where native back button and swipe-back matter
- Recommended:
  - `iOS-style`
- Safest choice:
  - `iOS-style` on Apple platforms only
- Why:
  - It matches user expectation on iOS.
  - It supports back affordance and native-feeling hierarchy better than custom global motion.
  - This is especially good for content pages reached through `push`.

### Modal or setup flows

- Surface:
  - onboarding
  - setup subflows
  - temporary focused flows
  - confirmation flows that feel task-based
- Recommended:
  - `Slide up` only if explicitly needed later
  - otherwise `Gentle fade`
- Safest choice:
  - `Gentle fade`
- Why:
  - A global sheet-like motion is riskier in this app because not every setup page is truly modal.
  - `Gentle fade` keeps the flow calm and consistent.
  - If a future flow is unmistakably modal, `slide up` can be used selectively instead of globally.

### Qur’an reader and Qur’an-adjacent deep reading pages

- Surface:
  - `/quran/surah/*`
  - focused recitation
  - heavy reading/study/detail pages
- Recommended:
  - `Default` or platform-native behavior only
- Safest choice:
  - `Default`
- Why:
  - These pages already have rich gestures, playback, and deep-linking behavior.
  - They are the highest-risk area for transition conflicts.
  - Extra custom motion here would add more complexity than value.

### Games and quizzes

- Surface:
  - crossword
  - word search
  - matching
  - ayah completion
  - trivia flows
- Recommended:
  - `Default`
- Safest choice:
  - `Default`
- Why:
  - These surfaces often already use local animation and fast state changes.
  - Custom page transitions can feel redundant or interfere with game pacing.
  - Keeping route motion simple lets in-page feedback carry the experience.

### Settings and account/support pages

- Surface:
  - settings
  - notifications
  - appearance
  - learning settings
  - account/sync/support/help pages
- Recommended:
  - `Gentle fade` or `Default`
- Safest choice:
  - `Gentle fade`
- Why:
  - Settings flows benefit from calmer motion.
  - Fade is low-friction and suits utility pages better than directional motion.

## Reduce Motion policy

- When `Reduce Motion` is enabled:
  - all custom transitions should collapse to `Reduce-motion safe`
- Recommended behavior:
  - use `None` or a very short `Default`/fade equivalent
- Why:
  - this is the lowest-risk accessibility policy
  - it keeps transitions readable without making navigation feel broken

## Safest implementation policy

- Root tabs:
  - `None`
- Standard pushed content pages:
  - `Default`
- Optional enhancement on calm content/settings pages:
  - `Gentle fade`
- Apple push/pop:
  - preserve `iOS-style` feel where platform navigation already gives it
- Qur’an reader and game flows:
  - stay on `Default`
- Reduce Motion:
  - always override to `Reduce-motion safe`

## Best phased rollout

### Phase 1

- Keep root tabs as `None`
- Keep drill-down pages as `Default`
- Add only the `Reduce-motion safe` override policy

### Phase 2

- Add `Gentle fade` to:
  - settings
  - learning hub subpages
  - calm content pages

### Phase 3

- Evaluate whether any specific modal/setup flows deserve `slide up`
- Do not make `slide up` a global app setting unless product QA strongly supports it

## Final recommendation

- If only one approach is chosen now:
  - stay with `Default` everywhere except root-tab switching
- If a polished but safe system is wanted:
  - root tabs: `None`
  - calm content/settings pages: `Gentle fade`
  - Apple push/pop drill-down pages: `iOS-style` / native feel
  - Qur’an reader and games: `Default`
  - reduce motion: `Reduce-motion safe`
