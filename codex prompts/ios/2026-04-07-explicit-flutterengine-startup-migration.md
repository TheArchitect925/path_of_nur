===== PHASE X PROMPT — EXPLICIT FLUTTERENGINE STARTUP MIGRATION =====

PRIMARY OBJECTIVE === REPLACE THE CURRENT IMPLICIT-ENGINE + STORYBOARD FLUTTER STARTUP PATH WITH A PRODUCTION-READY EXPLICIT-FLUTTERENGINE ARCHITECTURE

We are working in the existing Flutter codebase for Path of Nūr.

CONFIRMED CONTEXT
A completed audit has already confirmed:

- the current `.ips` crash is a startup-stage iPhone / Flutter engine crash
- it occurs in:
  - `-[VSyncClient initWithTaskRunner:callback:]`
  - `-[FlutterViewController createTouchRateCorrectionVSyncClientIfNeeded]`
  - `-[FlutterViewController viewDidLoad]`
- the current app still uses the risky shape:
  - `UIScene`
  - `FlutterSceneDelegate`
  - `Main.storyboard`
  - storyboard-instantiated `FlutterViewController`
  - implicit engine
- repo-specific bootstrap timing mismatch has already been fixed
- the best next architecture has already been audited and selected:

SELECTED TARGET ARCHITECTURE
- keep `UIScene`
- keep `SceneDelegate`
- introduce one explicit shared `FlutterEngine`
- engine owned by `AppDelegate`
- `SceneDelegate` creates the `UIWindow`
- `SceneDelegate` creates a programmatic `FlutterViewController(engine: sharedEngine, nibName: nil, bundle: nil)`
- remove `Main.storyboard` from launch configuration entirely
- preserve all current native bridge/channel behavior

THIS PASS
Implement the migration fully.
Do not leave a partial hybrid.
Do not keep implicit and explicit engine flows active together.
Do not redesign the app.
Do not remove features.
Do not add placeholders.
Build the real production-ready version.

FILES TO MODIFY
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/SceneDelegate.swift`
- `ios/Runner/Info.plist`
- `ios/Runner/Base.lproj/Main.storyboard` only if needed for cleanup / deactivation
- any native helper files that need a small update because messenger/engine access changes

FILES TO REVIEW FOR INTEGRATION
- watch sync bridge
- navigation bridge
- route buffering logic
- any channel configuration helpers
- LaunchScreen config should remain valid

IMPLEMENTATION REQUIREMENTS

## 1. Shared explicit engine
- Create exactly one shared `FlutterEngine`
- Engine must be owned or vended by `AppDelegate`
- Engine must be started exactly once
- Use a guarded startup method to prevent duplicate engine creation
- Register `GeneratedPluginRegistrant` exactly once against that engine
- Reuse the existing one-time custom channel configuration guard if appropriate

## 2. Remove implicit-engine startup path
- Remove dependency on `FlutterImplicitEngineDelegate` startup flow
- Remove implicit-engine callback-based registration/bootstrap if no longer needed
- Do not leave dead implicit-engine code paths behind

## 3. Programmatic root view controller
- `SceneDelegate` must create the `UIWindow`
- `SceneDelegate` must create `FlutterViewController(engine: sharedEngine, nibName: nil, bundle: nil)`
- assign it as `window.rootViewController`
- call `makeKeyAndVisible()`
- do not rely on storyboard-instantiated `FlutterViewController`

## 4. Keep UIScene
- keep `UIApplicationSceneManifest`
- keep `UISceneDelegateClassName`
- keep scene-based lifecycle
- do not remove `SceneDelegate`
- keep URL forwarding support working

## 5. Remove storyboard launch dependency
- remove `UISceneStoryboardFile = Main`
- remove `UIMainStoryboardFile`
- keep `UILaunchStoryboardName = LaunchScreen`
- `Main.storyboard` must no longer participate in app startup
- if it can safely remain in the repo unused, that is acceptable
- but it must not still drive startup

## 6. Preserve all current bridges and behavior
Preserve and rebind correctly:
- generated plugin registration
- live activity bridge
- navigation channel
- iCloud sync channel
- platform runtime channel
- creation image labeling channel
- watch sync channel
- route buffering
- deep link / URL handling
- `handleIncomingRouteURL(...)`
- pending route replay behavior

## 7. Messenger / channel setup
- Move all custom channel setup to use the explicit engine messenger/registrar path
- Keep channel names identical
- Keep handlers identical unless a change is required for correctness
- Avoid duplicate channel setup

## 8. URL / route buffering safety
- Keep `SceneDelegate` forwarding URLs to `AppDelegate`
- Keep buffered pending-route behavior working if the Dart side is not yet ready
- Ensure migration does not break manual launch deep links or route replay

## 9. Validation
After implementing:
- confirm there is only one engine creation path
- confirm storyboard no longer instantiates Flutter root VC
- confirm plugins register against the explicit engine
- confirm all custom channels bind against the explicit engine messenger
- confirm build succeeds
- report remaining warnings
- report whether any startup crash-risk elements still remain

OUTPUT FORMAT

## 1. Startup architecture before vs after
- concise comparison

## 2. Files changed
- list of files

## 3. Explicit engine implementation
- where engine is owned
- where it is started
- where plugins register
- where channels are configured

## 4. SceneDelegate / root VC implementation
- how window is created
- how root FlutterViewController is created
- how startup now avoids storyboard-instantiated Flutter VC

## 5. Config changes
- Info.plist changes
- storyboard changes
- launch screen status

## 6. Behavior preservation
- live activity
- watch sync
- navigation channel
- route buffering
- deep links / URL handling

## 7. Validation
- build commands run
- results
- warnings vs blockers

## 8. Residual risk assessment
- any remaining startup risk
- whether Home/Learn page issues are still secondary follow-up work

## 9. Final audit summary
- one concise production-ready summary

IMPORTANT RULES
- Do not leave a hybrid startup path
- Do not keep both implicit and explicit engine flows active
- Do not let storyboard still instantiate `FlutterViewController`
- Keep this migration narrow but complete
- Preserve existing app behavior
- At the very end provide one full audit summary

END GOAL
This pass should fully move Runner off the confirmed risky implicit-engine + storyboard startup path and onto a production-ready explicit-engine + SceneDelegate + programmatic FlutterViewController architecture.
