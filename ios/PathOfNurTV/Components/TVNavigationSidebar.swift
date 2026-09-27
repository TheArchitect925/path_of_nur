import SwiftUI

struct TVNavigationSidebar: View {
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @FocusState private var focusedRoute: TVRoute?

  var body: some View {
    VStack(alignment: .leading, spacing: 24) {
      Text("Path of Nūr")
        .font(TVTypography.sectionTitle)
        .foregroundColor(TVTheme.focus)
        .tvReadableTitle()
        .padding(.horizontal, 20)
        .accessibilityAddTraits(.isHeader)

      // The nav list scrolls inside the rail so the shell itself never
      // exceeds the screen — otherwise tvOS pans the whole root (and the
      // fixed atmosphere along with it) to chase focus.
      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 16) {
          ForEach(appViewModel.navigationItems) { item in
            Button {
              appViewModel.navigate(to: item.route, preferredColumn: .content)
            } label: {
              _itemLabel(for: item)
            }
            .buttonStyle(TVCardButtonStyle())
            .focused($focusedRoute, equals: item.route)
          }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, TVTheme.railBleed)
      }
      .padding(.horizontal, -TVTheme.railBleed)
      .frame(maxHeight: .infinity)
    }
    .frame(width: 360, alignment: .leading)
    .padding(.horizontal, 24)
    .padding(.vertical, 36)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous)
        .fill(TVTheme.surface.opacity(0.88))
        .overlay(
          RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous)
            .stroke(TVTheme.surfaceStroke, lineWidth: 1)
        )
    )
    .onAppear {
      restoreFocusIfNeeded()
    }
    .onChange(of: appViewModel.navigationFocusRequest) { _ in
      restoreFocusIfNeeded()
    }
    .onChange(of: focusedRoute) { route in
      guard route != nil else { return }
      appViewModel.setNavigationFocused()
    }
  }

  private func _itemLabel(for item: TVNavigationItem) -> some View {
    let isSelected = appViewModel.selectedRoute == item.route

    return HStack(alignment: .center, spacing: 18) {
      Image(systemName: item.systemImage)
        .font(.system(size: 24, weight: .semibold))
        .frame(width: 46, height: 46)
        .foregroundColor(isSelected ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
        .background(
          RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(isSelected ? TVTheme.prayerCurrent : TVTheme.surfaceSoft)
        )

      VStack(alignment: .leading, spacing: 6) {
        Text(tvLocalized(item.titleKey))
          .font(TVTypography.sectionTitle)
          .foregroundColor(TVTheme.textPrimary)
          .tvReadableTitle()

        Text(tvLocalized(item.subtitleKey))
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(3)
          .tvReadableBody()
      }

      Spacer(minLength: 0)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(20)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(isSelected ? TVTheme.surfaceElevated : TVTheme.surfaceSoft.opacity(0.84))
        .overlay(
          RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
            .stroke(isSelected ? TVTheme.focus.opacity(0.5) : TVTheme.surfaceStroke, lineWidth: 1)
        )
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: tvLocalized(item.titleKey),
      hint: tvLocalized(item.subtitleKey),
      value: isSelected ? tvLocalized("Selected") : nil
    )
  }

  private func restoreFocusIfNeeded() {
    guard appViewModel.activeColumn == .navigation else { return }
    DispatchQueue.main.async {
      focusedRoute = appViewModel.selectedRoute
    }
  }
}
