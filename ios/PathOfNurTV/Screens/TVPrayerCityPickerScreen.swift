import SwiftUI

/// The list of cities, for an Apple TV that cannot say where it is.
struct TVPrayerCityPickerScreen: View {
  @ObservedObject var prayerService: TVPrayerService
  @Binding var isPresented: Bool
  @FocusState private var focusedCity: String?
  @State private var focusSeeker = TVFocusSeeker()
  @State private var scrollRequest = 0

  private let cities = TVPrayerCities.sorted
  private let columns = Array(
    repeating: GridItem(.flexible(), spacing: TVTheme.railSpacing),
    count: 3
  )

  var body: some View {
    ZStack {
      TVCoverBackground()

      VStack(alignment: .leading, spacing: TVTheme.blockSpacing) {
        HStack(alignment: .center) {
          Text(tvLocalized("Choose a city"))
            .font(TVTypography.heroTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()
            .accessibilityAddTraits(.isHeader)

          Spacer()

          Button {
            isPresented = false
          } label: {
            Label(tvLocalized("Close"), systemImage: "xmark.circle.fill")
              .font(TVTypography.chip)
              .foregroundColor(TVTheme.textPrimary)
              .padding(.horizontal, 20)
              .padding(.vertical, 14)
              .background(TVTheme.surfaceSoft, in: Capsule())
          }
          .buttonStyle(TVCardButtonStyle(shape: .capsule))
        }

        ScrollViewReader { proxy in
          ScrollView {
            LazyVGrid(columns: columns, alignment: .leading, spacing: TVTheme.railSpacing) {
              ForEach(cities) { city in
                Button {
                  prayerService.selectCity(city)
                  isPresented = false
                } label: {
                  cityCard(city)
                }
                .buttonStyle(TVCardButtonStyle())
                .tvFocusID($focusedCity, Self.focusID(city.id))
                .id(city.id)
              }
            }
            .padding(TVTheme.railBleed)
          }
          .onChange(of: scrollRequest) { _ in
            if let chosen = prayerService.place?.cityId {
              proxy.scrollTo(chosen, anchor: .center)
            }
          }
        }
        .tvRail()
      }
      .padding(TVTheme.outerPadding)
    }
    .onAppear {
      // The list opens at the city that is chosen, which may be far down
      // it and not yet built.
      guard let target = prayerService.place?.cityId ?? cities.first?.id else { return }
      focusSeeker.seek(Self.focusID(target), with: $focusedCity) {
        scrollRequest += 1
      }
    }
    .onExitCommand {
      isPresented = false
    }
  }

  private static func focusID(_ cityId: String) -> String {
    "city.\(cityId)"
  }

  private func cityCard(_ city: TVPrayerCity) -> some View {
    let isSelected = prayerService.place?.cityId == city.id

    return HStack(spacing: 14) {
      Text(city.name)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(2)
        .tvReadableBody()

      Spacer(minLength: 0)

      if isSelected {
        Image(systemName: "checkmark.circle.fill")
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(TVTheme.accentStrong)
      }
    }
    .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
    .padding(24)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected)
    .tvCombinedAccessibility(
      label: city.name,
      value: isSelected ? tvLocalized("Selected") : nil
    )
  }
}
