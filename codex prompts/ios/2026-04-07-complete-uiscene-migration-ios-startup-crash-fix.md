===== PHASE X PROMPT — COMPLETE UISCENE MIGRATION / IOS STARTUP CRASH FIX =====

PRIMARY OBJECTIVE === FIX THE IOS / TESTFLIGHT STARTUP CRASH BY COMPLETING THE UISCENE IMPLICIT-ENGINE MIGRATION CORRECTLY

We are working in the existing Flutter codebase for Path of Nūr.

Current diagnosis from the completed audit:
- The crash is not primarily a Home widget crash.
- The app architecture matches the risky Flutter iOS startup pattern:
  - `FlutterAppDelegate`
  - `FlutterImplicitEngineDelegate`
  - `FlutterSceneDelegate`
  - `Main.storyboard`
  - storyboard-instantiated `FlutterViewController`
  - implicit Flutter engine
- Generated plugin registration is already in:
  - `didInitializeImplicitFlutterEngine(_:)`
- But custom native Flutter bootstrap is still happening too early in:
  - `application(_:didFinishLaunchingWithOptions:)`
- That early bootstrap includes manual registrar access, method-channel setup, and watch sync wiring.

Known repo-specific target:
Complete the UIScene migration properly by moving all Flutter engine-dependent native bootstrap into:
- `didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge)`

DO NOT redesign the app.
DO NOT remove features.
DO NOT delete records or unrelated code.
DO NOT introduce placeholder logic.
Build this as a production-ready fix.

FILES TO MODIFY
- `ios/Runner/AppDelegate.swift`

FILES TO REVIEW FOR SAFETY / INTEGRATION
- `ios/Runner/SceneDelegate.swift`
- `ios/Runner/Info.plist`
- `ios/Runner/Base.lproj/Main.storyboard`
- any native bridge/helper files used by AppDelegate channel setup, including watch/live activity related files

PRIMARY IMPLEMENTATION GOALS

1. Move all Flutter engine-dependent startup work out of:
- `application(_:didFinishLaunchingWithOptions:)`

and into:
- `didInitializeImplicitFlutterEngine(_:)`

2. Specifically relocate anything that currently depends on:
- `self.registrar(forPlugin: ...)`
- `FlutterMethodChannel(...)`
- messenger access
- plugin-style registrar access
- watch/native bridge channel attachment
- other Flutter-engine-bound method channel bootstrap

3. In the new setup, use the implicit engine bridge correctly.
Use the engine bridge registrar / messenger path rather than AppDelegate-time registrar access.

4. Preserve all existing behavior:
- live activity bridge behavior
- watch connectivity bridge behavior
- custom native route / URL handling behavior
- existing channel names
- existing method handlers
- existing native side effects that are valid after engine init

5. Keep `application(_:didFinishLaunchingWithOptions:)` minimal.
It should only retain logic that is safe before Flutter engine initialization and belongs there.
Do not keep Flutter channel bootstrap there unless absolutely necessary and clearly justified.

6. Keep the code robust and explicit.
Avoid fragile ordering assumptions.
Avoid duplicate channel setup.
Avoid double registration.
Avoid repeated attach calls.
Avoid memory leaks / retain cycles.
Avoid null / unavailable engine assumptions.

7. Add lightweight guarding if needed.
If native bootstrap could accidentally run twice, add a safe idempotency guard.

AUDIT-FIRST REQUIREMENT

Before editing, inspect the current `AppDelegate.swift` and identify:
- every custom channel currently created in `didFinishLaunchingWithOptions`
- every custom registrar currently requested
- every helper/bridge currently attached during app launch
- what can stay in `didFinishLaunchingWithOptions`
- what must move to `didInitializeImplicitFlutterEngine`

IMPLEMENTATION DETAILS

A. Refactor AppDelegate lifecycle
- Keep:
  - `AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate`
- Keep generated plugin registration inside:
  - `didInitializeImplicitFlutterEngine(_:)`
- Move custom Flutter engine-bound setup into that same method after plugin registration, or in the safest order Codex determines from current dependencies.

B. Update messenger/registrar usage
- Replace AppDelegate-time `self.registrar(forPlugin: ...)` usage for engine-bound channels
- Use the implicit engine bridge’s registrar/messenger path instead
- Ensure each channel binds to the correct binary messenger from the initialized engine

C. Preserve non-engine app launch behavior
- If there is non-Flutter app bootstrap that genuinely belongs in `didFinishLaunchingWithOptions:`, keep it there
- But separate it clearly from Flutter engine-dependent setup

D. Maintain URL routing support
- Do not break:
  - `handleIncomingRouteURL`
  - SceneDelegate URL forwarding
- If any routing logic depends on engine readiness, make it safe and deterministic

E. Maintain watch/native bridge support
- Preserve existing watch bridge functionality
- Ensure any `attach(channel:)` or equivalent happens only after the channel is valid
- Avoid early initialization against an unavailable messenger

F. Safety checks
- Prevent duplicate setup on re-entry
- Keep implementation production safe for TestFlight / App Store use

VALIDATION TASKS

After changes, verify and report:
1. Which items were moved out of `didFinishLaunchingWithOptions`
2. Which items remain there and why
3. That all custom channels now initialize from `didInitializeImplicitFlutterEngine`
4. That no `self.registrar(forPlugin: ...)` engine bootstrap remains in `didFinishLaunchingWithOptions`
5. Analyzer / build status for the changed iOS Swift code
6. Any remaining startup architecture risks that still match the Flutter issue pattern

OUTPUT FORMAT

Return results in this exact structure:

## 1. What changed
- concise summary

## 2. Files changed
- list of files

## 3. Startup refactor details
- what moved
- what stayed
- what registrar/messenger path is now used

## 4. Safety / behavior preservation
- confirm live activity
- confirm watch bridge
- confirm URL handling
- confirm no duplicate setup

## 5. Validation
- analyzer/build result
- any warnings
- any limitations

## 6. Residual risk assessment
- state clearly whether the app still retains the broader storyboard + implicit-engine + UIScene crash shape after this patch

## 7. Final audit summary
- one concise production-focused summary

IMPORTANT RULES
- Do not refactor unrelated code
- Do not redesign startup architecture yet
- Do not switch to explicit engine startup in this pass unless absolutely required to make the build work
- Keep this pass narrow, production-ready, and reversible
- If an explicit-engine / non-storyboard workaround appears necessary, do not implement it in this pass; only flag it as the next escalation
- At the very end, provide one full audit summary so I can review everything in one place

END GOAL
This pass should fully align the app’s custom native Flutter bootstrap with the UIScene implicit-engine lifecycle and remove the clearest repo-specific startup mismatch before we consider a larger Runner startup rewrite.
