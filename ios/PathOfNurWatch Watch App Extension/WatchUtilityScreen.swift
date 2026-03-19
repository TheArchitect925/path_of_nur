import SwiftUI

struct WatchUtilityScreen: View {
  @EnvironmentObject private var model: WatchAppModel

  var body: some View {
    List {
      Toggle(WatchStrings.haptics, isOn: Binding(
        get: { model.hapticsEnabled },
        set: { model.setHapticsEnabled($0) }
      ))

      Picker(WatchStrings.defaultDhikrTarget, selection: Binding(
        get: { model.dhikrState.preset },
        set: { model.setDefaultDhikrPreset($0) }
      )) {
        ForEach(WatchDhikrPreset.allCases) { preset in
          Text(preset.title).tag(preset)
        }
      }

      Button(WatchStrings.syncNow) {
        Task {
          await model.syncNow()
        }
      }
    }
    .listStyle(.carousel)
    .containerBackground(WatchTheme.backgroundGradient, for: .navigation)
  }
}
