# ===== PHASE 1 PROMPT — FIX BOTTOM OVERLAY / CONTENT CLIPPING (NON-HOME PAGES ONLY) =====

PRIMARY OBJECTIVE === FIX BOTTOM NAV OVERLAP WITHOUT IMPACTING HOME

We have a UI issue where page content (especially Qur’an and other non-home pages) is being visually hidden behind the bottom navigation bar.

This includes:
- background/quote layer bleeding into nav area
- text/content partially hidden (see screenshot reference)
- extra bottom visual padding that should not exist

⚠️ CRITICAL CONSTRAINT:
- DO NOT MODIFY HOMEPAGE BEHAVIOR
- Home page must retain its current immersive/full-bleed design

⸻

ROOT CAUSE (DO NOT IGNORE)

Flutter Scaffold does NOT automatically inset body content above bottomNavigationBar in all cases

Additionally:
- SafeArea / MediaQuery padding is inconsistently applied
- Background layers are extending FULL HEIGHT instead of stopping before nav
- Some pages are likely using extendBody or similar behavior unintentionally

⸻

REQUIRED SOLUTION STRATEGY

We will implement page-level layout control using a reusable system.

⸻

STEP 1 — CREATE PAGE FLAG (GLOBAL CONTROL)

Add a layout flag:

```dart
class PageLayoutConfig {
  final bool extendBehindBottomNav;

  const PageLayoutConfig({
    this.extendBehindBottomNav = false,
  });
}
```

⸻

STEP 2 — APPLY CONFIG PER PAGE

✅ Homepage

```dart
PageLayoutConfig(extendBehindBottomNav: true)
```

❌ ALL OTHER PAGES (QURAN, LEARN, WORSHIP, etc.)

```dart
PageLayoutConfig(extendBehindBottomNav: false)
```

⸻

STEP 3 — FIX BODY LAYOUT BEHAVIOR

Where main page scaffold/body is rendered:

```dart
final bottomInset = MediaQuery.of(context).viewPadding.bottom + 88;
```

Now conditionally apply:

```dart
Widget buildPageBody(BuildContext context, Widget content, PageLayoutConfig config) {
  if (config.extendBehindBottomNav) {
    return content; // homepage untouched
  }

  return Padding(
    padding: EdgeInsets.only(bottom: bottomInset),
    child: content,
  );
}
```

⸻

STEP 4 — STOP BACKGROUND / QUOTE LAYER BLEED

⚠️ THIS IS YOUR ACTUAL VISUAL BUG

Your decorative layer (glass / ayah / gradient / quote surface) is extending behind the nav.

Fix it using clipping:

```dart
Widget buildClippedBackground(BuildContext context, Widget background, PageLayoutConfig config) {
  if (config.extendBehindBottomNav) {
    return background;
  }

  final bottomInset = MediaQuery.of(context).viewPadding.bottom + 88;

  return Positioned.fill(
    bottom: bottomInset,
    child: background,
  );
}
```

OR safer:

```dart
ClipRect(
  child: Align(
    alignment: Alignment.topCenter,
    heightFactor: 0.92,
    child: background,
  ),
)
```

⸻

STEP 5 — ENSURE NO DOUBLE SAFEAREA

Check and REMOVE patterns like:

```dart
SafeArea(
  bottom: true,
)
```

Replace with:

```dart
SafeArea(
  bottom: false,
)
```

Because:
- You are manually controlling bottom spacing now
- SafeArea can introduce unwanted extra padding

⸻

STEP 6 — VERIFY NAV HEIGHT (DO NOT HARDCODE BLINDLY)

If you have custom nav:

```dart
const kBottomNavHeight = 88.0;
```

OR derive dynamically if needed.

⸻

STEP 7 — DO NOT TOUCH
- Home hero ayah card
- Home immersive layout
- Existing homepage background behavior

⸻

EXPECTED RESULT

After implementation:

✅ Qur’an page no longer hidden behind nav
✅ Background stops cleanly above nav
✅ No awkward white/blur strip at bottom
✅ Home remains immersive and unchanged

⸻

FINAL CODEX AUDIT (MANDATORY)

At the end, Codex MUST verify:
1. No homepage layout changes occurred
2. No global Scaffold changes breaking other pages
3. No double padding (SafeArea + manual inset)
4. Background layers are clipped correctly
5. All affected pages use PageLayoutConfig

⸻

BONUS (OPTIONAL IMPROVEMENT)

Future-proof this with:

```dart
enum PageLayoutMode {
  immersive,
  standard,
}
```

⸻

ISLAMIC REMINDER

“Allah does not burden a soul beyond that it can bear.” — Qur’an 2:286

Build with balance — immersive where it adds beauty, structured where it protects usability.

⸻

If you want next step:
👉 I can audit your actual scaffold + navigation code and pinpoint EXACT file causing this (it’s likely one shared shell or wrapper).
