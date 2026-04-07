===== PHASE X PROMPT — IOS RUNNER / FLUTTER STARTUP CRASH AUDIT =====

PRIMARY OBJECTIVE === AUDIT IOS STARTUP PATH FOR THE TESTFLIGHT CRASH

We are troubleshooting a real iPhone/TestFlight launch crash in a Flutter app.

Known crash signature:
- EXC_BAD_ACCESS / SIGSEGV at address 0x0
- main thread
- stack includes:
  - `-[VSyncClient initWithTaskRunner:callback:]`
  - `-[FlutterViewController createTouchRateCorrectionVSyncClientIfNeeded]`
  - `-[FlutterViewController viewDidLoad]`

Important context:
This points away from the Home widget tree and toward the iOS Runner / Flutter engine startup path. There is an open Flutter iOS issue with this same stack pattern, tied to UIScene + implicit engine + storyboard launch timing. Flutter 3.41 also made UIScene support the default for iOS apps.  [oai_citation:0‡GitHub](https://github.com/flutter/flutter/issues/183900?utm_source=chatgpt.com)

TASK
Audit the iOS app startup configuration and return a precise report so I can hand the results back for diagnosis.

FILES TO INSPECT
- `ios/Runner/AppDelegate.swift`
- `ios/Runner/AppDelegate.m`
- `ios/Runner/SceneDelegate.swift`
- `ios/Runner/SceneDelegate.m`
- `ios/Runner/Info.plist`
- `ios/Runner/Base.lproj/Main.storyboard`
- `ios/Podfile`
- `pubspec.yaml`
- `flutter --version` output if available from repo/tooling context
- any custom iOS bootstrap or lifecycle files under `ios/Runner/`

WHAT TO LOOK FOR

1. Flutter / iOS lifecycle setup
- Is the app using `FlutterAppDelegate`?
- Is it using `FlutterImplicitEngineDelegate`?
- Is there a `SceneDelegate`?
- Is `UIScene` configured in `Info.plist`?
- Is `Main.storyboard` being used to instantiate the initial `FlutterViewController`?
- Is the root VC created from storyboard or programmatically?

2. Plugin registration path
- Where is `GeneratedPluginRegistrant.register(...)` called?
- Is it still in `didFinishLaunchingWithOptions`?
- Or is it moved to `didInitializeImplicitFlutterEngine` as required for UIScene-based lifecycle migration? Flutter’s UIScene migration guide explicitly says plugin registration must move to `didInitializeImplicitFlutterEngine` for the new launch sequence.  [oai_citation:1‡Flutter Documentation](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate?utm_source=chatgpt.com)

3. Engine ownership pattern
- Is the app using an implicit engine?
- Is it creating an explicit `FlutterEngine(name:)` anywhere?
- Is the `FlutterViewController` attached to an engine explicitly or implicitly?
- Is there any custom warmup/prewarm logic?

4. Info.plist and scene config
- Does `Info.plist` include `UIApplicationSceneManifest`?
- Does it include `CADisableMinimumFrameDurationOnPhone` and if so what value?
- Is there anything unusual about launch screen / storyboard / scene session config?

5. Versioning / environment
- Report the Flutter SDK version if visible
- Report whether the project appears migrated to the newer UIScene lifecycle
- Report any iOS deployment target that might matter

OUTPUT FORMAT

Return the findings in this exact structure:

## 1. Startup architecture summary
- Explain the current iOS launch path in plain English
- Example: storyboard -> SceneDelegate -> implicit Flutter engine -> FlutterViewController

## 2. File-by-file findings
For each file inspected:
- file path
- relevant classes / methods found
- exact lifecycle role
- anything suspicious

## 3. Direct answers
Answer these with YES / NO / UNKNOWN and one short explanation each:
- Uses UIScene lifecycle?
- Uses SceneDelegate?
- Uses Main.storyboard for Flutter VC?
- Uses implicit engine?
- Uses explicit FlutterEngine?
- Registers plugins in `didInitializeImplicitFlutterEngine`?
- Registers plugins only in `didFinishLaunchingWithOptions`?
- Anything custom in startup path?

## 4. Crash relevance assessment
State whether the current setup appears consistent with the known Flutter VSync / implicit-engine / scene-launch crash pattern.
Be specific.

## 5. Copy-paste evidence
Provide short code excerpts for the exact relevant sections only:
- AppDelegate lifecycle methods
- SceneDelegate lifecycle methods
- Info.plist scene manifest
- storyboard initial view controller reference
Keep excerpts short and focused.

## 6. Recommended next action
Do NOT implement fixes yet.
Only recommend the single best next fix direction based on what you found.

IMPORTANT RULES
- Audit first, no code changes.
- Do not refactor anything.
- Do not guess; if something is missing, say UNKNOWN.
- Keep the report precise and evidence-based.
- At the end, provide one concise final summary.

EXTRA
If the repo has already been migrated to UIScene, explicitly compare the implementation against Flutter’s documented migration pattern, especially plugin registration via `didInitializeImplicitFlutterEngine`.  [oai_citation:2‡Flutter Documentation](https://docs.flutter.dev/release/breaking-changes/uiscenedelegate?utm_source=chatgpt.com)
