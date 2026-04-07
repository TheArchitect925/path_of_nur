===== PHASE X PROMPT — IOS CRASH AUDIT CONFIRMATION =====

PRIMARY OBJECTIVE === RUN A FULL EVIDENCE-BASED AUDIT TO CONFIRM WHETHER THE CURRENT TESTFLIGHT / DEVICE CRASH IS AN IOS FLUTTER ENGINE STARTUP CRASH RATHER THAN A HOME OR LEARN UI CRASH

We are working in the existing Flutter codebase for Path of Nūr.

IMPORTANT CONTEXT
We now have a real iPhone crash log showing:
- `EXC_BAD_ACCESS / SIGSEGV`
- `KERN_INVALID_ADDRESS at 0x0`
- main thread crash
- stack includes:
  - `-[VSyncClient initWithTaskRunner:callback:]`
  - `-[FlutterViewController createTouchRateCorrectionVSyncClientIfNeeded]`
  - `-[FlutterViewController viewDidLoad]`

External references strongly suggest this is a known Flutter iOS crash pattern tied to the Flutter iOS engine startup path, especially around `createTouchRateCorrectionVSyncClientIfNeeded`, manual launch, and scene/storyboard/implicit-engine behavior. See Flutter issues #168582, #163828, and #153971 for matching stacks and launch patterns. Also note Flutter’s UIScene migration guidance about engine initialization and registration timing. 
Sources:
- https://github.com/flutter/flutter/issues/168582
- https://github.com/flutter/flutter/issues/163828
- https://github.com/flutter/flutter/issues/153971
- https://docs.flutter.dev/release/breaking-changes/uiscenedelegate

KNOWN INTERNAL FINDINGS ALREADY OBSERVED
- The app uses:
  - `FlutterAppDelegate`
  - `FlutterImplicitEngineDelegate`
  - `FlutterSceneDelegate`
  - `UIApplicationSceneManifest`
  - `Main.storyboard`
  - storyboard-instantiated `FlutterViewController`
  - implicit Flutter engine
- Repo-specific custom bootstrap timing mismatch was already fixed:
  - custom Flutter channel/bootstrap work was moved into `didInitializeImplicitFlutterEngine(_:)`
- Build succeeds after that fix
- However, the crash still occurs on device/TestFlight

GOAL OF THIS AUDIT
Audit the repo and confirm, with precise evidence, whether the remaining crash is most likely:
A. an upstream Flutter iOS engine / startup architecture crash
or
B. a Home / Learn page-level Flutter widget crash

Do NOT implement fixes in this pass.
Audit only.
Be evidence-driven.
Be strict.

FILES TO AUDIT
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/SceneDelegate.swift`
- `ios/Runner/Info.plist`
- `ios/Runner/Base.lproj/Main.storyboard`
- any iOS startup/bootstrap helpers under `ios/Runner/`
- `lib/app/app_router.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/learn/presentation/pages/learning_section_landing_page.dart`
- `lib/features/learn/presentation/widgets/learn_hub_page_scaffold.dart`
- `lib/shared/widgets/section_hub_scaffold.dart`
- `lib/shared/widgets/app_page_scaffold.dart`
- `lib/shared/widgets/shortcut_dock.dart`
- `lib/features/celestial/presentation/widgets/celestial_cycle_card.dart`

AUDIT TASKS

1. Confirm crash-stage timing
Determine whether the stack in the crash log places the crash before normal Flutter page rendering.
Specifically answer:
- Does `FlutterViewController viewDidLoad` happen before Home or Learn page build logic is the primary suspect?
- Based on current architecture, would a crash at this stack typically occur before page-local widget code becomes the root cause?

2. Confirm startup architecture shape
Re-state the exact current iOS startup architecture from the repo and check whether it still matches the known risky Flutter pattern:
- UIScene
- SceneDelegate
- Main.storyboard
- storyboard-created `FlutterViewController`
- implicit engine
- `CADisableMinimumFrameDurationOnPhone`
- any remaining launch-shape elements that align with the known Flutter issues

3. Check whether the repo-specific mismatch has actually been fixed
Confirm by code inspection that:
- custom Flutter channel/bootstrap work is no longer done in `application(_:didFinishLaunchingWithOptions:)`
- generated plugins and custom channels are now initialized from the implicit-engine callback
- no early `registrar(forPlugin:)` bootstrap remains in the wrong place

4. Audit Home and Learn as competing hypotheses
Audit whether Home or Learn still contain serious page-level crash risks.
Specifically inspect:
- floating overlays
- `Stack + Positioned` interactive layers
- `SingleChildScrollView + Column` heavy eager pages
- floating bottom shortcut docks
- `setState` inside expandable shortcut systems
- side effects inside `build`
- post-frame callbacks triggered from render branches

Then answer:
- Are these page-level risks real?
- Are they likely to explain THIS specific native crash stack?
- Or are they secondary issues separate from the current `.ips` crash?

5. Compare the repo evidence against the external Flutter reports
Compare our app’s current startup path and crash stack to:
- Flutter issue #168582
- Flutter issue #163828
- Flutter issue #153971
Summarize the match strength:
- weak
- moderate
- strong

6. Final root-cause judgment
Give one primary diagnosis:
- `upstream Flutter iOS startup architecture crash`
or
- `page-level Home/Learn runtime crash`
or
- `two separate crash classes are likely, and this .ips confirms the startup one`

Be explicit and rank confidence.

OUTPUT FORMAT

## 1. Crash-stage timing assessment
- explain whether the crash occurs before page-level UI is the primary suspect

## 2. Current iOS startup architecture
- exact launch shape from repo

## 3. Repo-specific migration fix verification
- what is confirmed fixed
- what is not

## 4. Home and Learn competing-hypothesis audit
- Home
- Learn
- whether they are primary or secondary relative to this `.ips`

## 5. External issue comparison
- compare against Flutter issue #168582
- compare against Flutter issue #163828
- compare against Flutter issue #153971
- overall match strength

## 6. Final root-cause judgment
- one primary diagnosis
- confidence level
- one sentence on the best next fix direction

## 7. Copy-paste evidence
Include short excerpts only for the most relevant startup files and widget-risk files.

IMPORTANT RULES
- Audit only, no code changes
- Do not guess
- If something is uncertain, say UNKNOWN
- Keep the answer precise and evidence-based
- At the very end provide one concise final summary

END GOAL
This pass should confirm whether the remaining crash is truly the known Flutter iOS startup crash shape, and whether Home/Learn issues are secondary rather than the primary cause of the `.ips` crash.
