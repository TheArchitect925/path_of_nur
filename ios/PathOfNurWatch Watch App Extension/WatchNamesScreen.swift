import SwiftUI

/// The ninety-nine names on the wrist: today's name up top, then the full
/// list. Reached from the Home tile and from the Name of the Day complication
/// (`pathofnurwatch://names`).
struct WatchNamesScreen: View {
  @Environment(\.watchPalette) private var palette

  private var today: WatchNameOfAllah {
    WatchNamesOfAllahData.nameOfTheDay(for: Date())
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          VStack(alignment: .leading, spacing: 6) {
            Text(today.arabic)
              .font(.system(size: 22, weight: .semibold, design: .serif))
              .foregroundStyle(palette.onSurface)
              .frame(maxWidth: .infinity, alignment: .center)
            Text(today.transliteration)
              .font(WatchType.value)
              .foregroundStyle(palette.accent)
            Text(today.meaning)
              .font(WatchType.caption)
              .foregroundStyle(palette.onSurfaceSubtle)
              .fixedSize(horizontal: false, vertical: true)
          }
          .padding(.vertical, 2)
          .listRowBackground(rowBackground)
        } header: {
          sectionHeader(WatchStrings.namesOfDayTitle)
        }

        Section {
          ForEach(WatchNamesOfAllahData.all) { name in
            nameRow(name)
          }
        } header: {
          sectionHeader(WatchStrings.namesAllTitle)
        }
      }
      .navigationTitle(WatchStrings.namesTitle)
      .containerBackground(palette.backgroundGradient, for: .navigation)
    }
  }

  private func nameRow(_ name: WatchNameOfAllah) -> some View {
    VStack(alignment: .leading, spacing: 3) {
      HStack(alignment: .firstTextBaseline, spacing: 6) {
        Text(name.transliteration)
          .font(WatchType.label)
          .foregroundStyle(palette.onSurface)
        Spacer(minLength: 0)
        Text(name.arabic)
          .font(.system(size: 14, weight: .semibold, design: .serif))
          .foregroundStyle(palette.accent)
      }
      Text(name.meaning)
        .font(WatchType.caption)
        .foregroundStyle(palette.onSurfaceSubtle)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(.vertical, 2)
    .listRowBackground(rowBackground)
  }

  private func sectionHeader(_ text: String) -> some View {
    Text(text)
      .font(WatchType.screenTitle)
      .foregroundStyle(palette.accent)
      .textCase(nil)
  }

  private var rowBackground: some View {
    RoundedRectangle(cornerRadius: 14, style: .continuous)
      .fill(palette.cardFillSoft)
  }
}
