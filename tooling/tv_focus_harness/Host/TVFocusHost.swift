import SwiftUI

/// A UI test bundle has to be built against an app. This is that app, and
/// nothing more: the tests drive Path of Nūr itself, by its bundle id.
@main
struct TVFocusHost: App {
  var body: some Scene {
    WindowGroup {
      Text("Path of Nūr focus harness")
    }
  }
}
