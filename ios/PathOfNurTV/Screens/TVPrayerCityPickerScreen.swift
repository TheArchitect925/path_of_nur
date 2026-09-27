import SwiftUI

/// The list of cities, for an Apple TV that cannot say where it is.
struct TVPrayerCityPickerScreen: View {
  @ObservedObject var prayerService: TVPrayerService
  @Binding var isPresented: Bool
  @FocusState private var focusedCity: String?

  private let cities = TVPrayerCities.sorted
  private let columns = Array(
    repeating: GridItem(.flexible(), spacing: TVTheme.railSpacing),
    count: 3
  )

  var body: some View {
    ZStack {
      TVBackgroundView()

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
              .focused($focusedCity, equals: city.id)
            }
          }
          .padding(.vertical, 8)
          .padding(.horizontal, TVTheme.railBleed)
        }
        .padding(.horizontal, -TVTheme.railBleed)
      }
      .padding(TVTheme.outerPadding)
    }
    .onAppear {
      DispatchQueue.main.async {
        focusedCity = prayerService.place?.cityId ?? cities.first?.id
      }
    }
    .onExitCommand {
      isPresented = false
    }
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
