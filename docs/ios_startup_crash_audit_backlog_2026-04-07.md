# iOS Startup Crash Audit Backlog

1. Verify TestFlight launch behavior after the UIScene bootstrap migration patch, especially on physical iPhone launches outside the debugger.
2. If startup crashes persist, the next escalation should be testing a non-storyboard or explicit-engine Runner startup path because the app will still retain the broader UIScene + implicit-engine + storyboard shape.
3. Keep monitoring Flutter issue #183900 and related UIScene startup fixes for Flutter 3.41.x+ before the next iOS release submission.
