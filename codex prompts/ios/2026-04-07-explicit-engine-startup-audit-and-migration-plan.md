===== PHASE X PROMPT — EXPLICIT ENGINE STARTUP AUDIT + MIGRATION PLAN =====

PRIMARY OBJECTIVE === AUDIT AND PREPARE THE SAFEST EXPLICIT-FLUTTERENGINE / NO-STORYBOARD WORKAROUND FOR THE CONFIRMED IOS STARTUP CRASH

We are working in the existing Flutter codebase for Path of Nūr.

CONFIRMED DIAGNOSIS
A completed audit has now confirmed that the `.ips` crash is primarily a startup-stage iPhone / Flutter engine crash, not a Home or Learn widget crash.

Confirmed findings:
- crash occurs in:
  - `-[VSyncClient initWithTaskRunner:callback:]`
  - `-[FlutterViewController createTouchRateCorrectionVSyncClientIfNeeded]`
  - `-[FlutterViewController viewDidLoad]`
- current startup architecture is still:
  - `FlutterAppDelegate`
  - `FlutterImplicitEngineDelegate`
  - `FlutterSceneDelegate`
  - `UIApplicationSceneManifest`
  - `Main.storyboard`
  - storyboard-instantiated `FlutterViewController`
  - implicit engine
- repo-specific bootstrap timing mismatch was already fixed
- build succeeds
- this `.ips` still strongly matches the upstream Flutter startup crash family

GOAL OF THIS PASS
Do NOT implement the migration yet unless clearly requested by the audit instructions below.
First run a full audit and produce the safest implementation plan for moving Runner off the risky implicit-engine + storyboard launch path.

We want to confirm the best production-ready architecture for:
- explicit `FlutterEngine`
- programmatic `FlutterViewController`
- no startup dependency on storyboard-instantiated Flutter root controller
- preserved URL handling, watch sync, live activities, and channel wiring

FILES TO AUDIT
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/SceneDelegate.swift`
- `ios/Runner/Info.plist`
- `ios/Runner/Base.lproj/Main.storyboard`
- any native bridge/helper files used by startup
- any deep-link or route-buffering code in Runner

AUDIT TASKS

1. Determine the cleanest explicit-engine ownership model
Answer:
- should engine ownership live in `AppDelegate`, `SceneDelegate`, or a dedicated holder?
- how should it be exposed safely to the rest of Runner?
- how do we prevent duplicate engine creation?

2. Determine the cleanest root view controller strategy
Answer:
- should `SceneDelegate` own the `UIWindow` and set a programmatic `FlutterViewController(engine:...)`?
- what exact storyboard dependencies must be removed or neutralized?
- should `Main.storyboard` be removed entirely from launch config or only stop instantiating `FlutterViewController`?

3. Determine migration impact on existing bridges
Audit and explain how to preserve:
- generated plugin registration
- custom channel setup
- live activity bridge
- navigation channel
- iCloud sync channel
- platform runtime channel
- creation image labeling channel
- watch sync channel
- route URL handling
- any buffered route delivery

4. Determine Info.plist / UIScene implications
Answer:
- can UIScene remain while switching to explicit engine?
- if yes, what exact config should remain?
- if no, what exact config must change?
- what should happen to `CADisableMinimumFrameDurationOnPhone`?

5. Determine risk of keeping current secondary UI issues separate
Briefly confirm:
- Home/Learn widget risks remain secondary relative to the `.ips`
- they should not block the startup architecture workaround

6. Provide final recommendation
Choose one best next implementation direction:
A. explicit engine + keep SceneDelegate + programmatic root VC
B. explicit engine + simplify/remove SceneDelegate usage
C. another safer Runner architecture if strongly justified

OUTPUT FORMAT

## 1. Current confirmed problem
- concise summary

## 2. Best explicit-engine ownership model
- exact recommendation

## 3. Root view controller migration plan
- exact recommendation

## 4. Runner config changes required
- AppDelegate
- SceneDelegate
- Info.plist
- Main.storyboard

## 5. Bridge preservation plan
- how each current native bridge survives the migration

## 6. Secondary UI issue separation
- confirm Home/Learn issues are separate/secondary

## 7. Final implementation recommendation
- one recommended architecture
- why it is the best next move

## 8. Final audit summary
- one concise production-ready summary

IMPORTANT RULES
- Audit first
- Do not guess
- No partial hybrid startup recommendation
- Keep the recommendation production-safe
- Keep it evidence-based
- At the end provide one full audit summary
