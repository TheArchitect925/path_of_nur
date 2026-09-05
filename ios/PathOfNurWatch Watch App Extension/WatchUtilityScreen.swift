import SwiftUI

struct WatchUtilityScreen: View {
  @EnvironmentObject private var model: WatchAppModel
  @Environment(\.watchPalette) private var palette

  var body: some View {
    List {
      Section {
        Toggle(WatchStrings.haptics, isOn: Binding(
          get: { model.hapticsEnabled },
          set: { model.setHapticsEnabled($0) }
        ))
        .tint(palette.accent)
        .listRowBackground(rowBackground)

        Picker(WatchStrings.defaultDhikrTarget, selection: Binding(
          get: { model.dhikrState.preset },
          set: { model.setDefaultDhikrPreset($0) }
        )) {
          ForEach(WatchDhikrPreset.allCases) { preset in
            Text(preset.title).tag(preset)
          }
        }
        .listRowBackground(rowBackground)

        Button(WatchStrings.syncNow) {
          Task {
            await model.syncNow()
          }
        }
        .foregroundStyle(palette.accent)
        .listRowBackground(rowBackground)
      } header: {
        Text(WatchStrings.utilityTitle)
          .font(WatchType.screenTitle)
          .foregroundStyle(palette.accent)
          .textCase(nil)
      }
    }
    .containerBackground(palette.backgroundGradient, for: .tabView)
  }

  private var rowBackground: some View {
    RoundedRectangle(cornerRadius: 14, style: .continuous)
      .fill(palette.cardFillSoft)
  }
}
