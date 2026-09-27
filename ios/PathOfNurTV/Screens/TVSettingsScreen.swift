import SwiftUI

struct TVSettingsScreen: View {
  @ObservedObject var viewModel: TVSettingsViewModel
  @ObservedObject var prayerService: TVPrayerService
  @State private var isCityPickerPresented = TVSettingsScreen.opensOnCityPicker
  @EnvironmentObject private var appViewModel: TVAppViewModel
  @EnvironmentObject private var themeController: TVThemeController
  @FocusState private var focusedSection: String?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: TVTheme.sectionSpacing) {
        TVHeroCard(
          eyebrow: viewModel.hero.eyebrow,
          title: viewModel.hero.title,
          subtitle: viewModel.hero.subtitle,
          supportingLine: viewModel.hero.supportingLine
        )

        TVSectionHeader(
          title: viewModel.startupTitle,
          subtitle: ""
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: TVTheme.railSpacing) {
                ForEach(Array(TVStartupPreference.released.enumerated()), id: \.element.id) {
                  index, preference in
                  let focusID = index == 0
                      ? TVFocusSectionId.settingsStartup
                      : "settings.startup.\(preference.rawValue)"

                  Button {
                    appViewModel.selectStartupPreference(preference)
                  } label: {
                    optionCard(
                      title: tvLocalized(preference.titleKey),
                      subtitle: tvLocalized(preference.subtitleKey),
                      systemImage: preference.systemImage,
                      isSelected: viewModel.startupPreference == preference
                    )
                  }
                  .buttonStyle(TVCardButtonStyle())
                  .focused($focusedSection, equals: focusID)
                }
              }
              .padding(TVTheme.railBleed)
            }
            .tvRail()
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          detailRail
            .frame(width: 480, alignment: .top)
        }

        prayerSection

        TVSectionHeader(
          title: tvLocalized("Appearance"),
          subtitle: tvLocalized("Pick a look, or let the time of day choose.")
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(TVAppearanceSetting.allCases.enumerated()), id: \.element.id) {
              index, setting in
              let focusID = index == 0
                  ? TVFocusSectionId.settingsAppearance
                  : "settings.appearance.\(setting.rawValue)"

              Button {
                themeController.selectAppearance(setting)
              } label: {
                optionCard(
                  title: tvLocalized(setting.titleKey),
                  subtitle: tvLocalized(setting.subtitleKey),
                  systemImage: setting.systemImage,
                  isSelected: themeController.appearance == setting
                )
              }
              .buttonStyle(TVCardButtonStyle())
              .focused($focusedSection, equals: focusID)
            }
          }
          .padding(TVTheme.railBleed)
        }
        .tvRail()

        TVSectionHeader(
          title: viewModel.listeningTitle,
          subtitle: ""
        )

        VStack(alignment: .leading, spacing: 24) {
          ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: TVTheme.railSpacing) {
              ForEach(Array(TVQuranReciter.allCases.enumerated()), id: \.element.rawValue) {
                index, reciter in
                let focusID = index == 0
                    ? TVFocusSectionId.settingsListening
                    : "settings.listening.reciter.\(reciter.rawValue)"

                Button {
                  appViewModel.selectDefaultReciter(reciter)
                } label: {
                  optionCard(
                    title: reciter.displayName,
                    subtitle: tvLocalized("Reciter"),
                    systemImage: "music.note.list",
                    isSelected: viewModel.defaultReciter == reciter
                  )
                }
                .buttonStyle(TVCardButtonStyle())
                .focused($focusedSection, equals: focusID)
              }
            }
            .padding(TVTheme.railBleed)
          }
          .tvRail()

          HStack(spacing: TVTheme.railSpacing) {
            Button {
              appViewModel.setShowListeningTranslationByDefault(
                !viewModel.showListeningTranslationByDefault
              )
            } label: {
              optionCard(
                title: tvLocalized("Translation"),
                subtitle: viewModel.showListeningTranslationByDefault
                    ? tvLocalized("Shown while listening")
                    : tvLocalized("Hidden while listening"),
                systemImage: "captions.bubble.fill",
                isSelected: viewModel.showListeningTranslationByDefault
              )
            }
            .buttonStyle(TVCardButtonStyle())
            .focused($focusedSection, equals: "settings.listening.translation")

            Button {
              appViewModel.setShowListeningTransliterationByDefault(
                !viewModel.showListeningTransliterationByDefault
              )
            } label: {
              optionCard(
                title: tvLocalized("Transliteration"),
                subtitle: viewModel.showListeningTransliterationByDefault
                    ? tvLocalized("Shown while listening")
                    : tvLocalized("Hidden while listening"),
                systemImage: "textformat.abc",
                isSelected: viewModel.showListeningTransliterationByDefault
              )
            }
            .buttonStyle(TVCardButtonStyle())
            .focused($focusedSection, equals: "settings.listening.transliteration")
          }
        }

        Text(viewModel.versionLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
          .tvReadableBody()
      }
      .padding(TVTheme.outerPadding)
    }
    .onAppear {
      restorePreferredFocus()
    }
    .onChange(of: appViewModel.contentFocusRequest) { _ in
      restorePreferredFocus()
    }
    .onChange(of: focusedSection) { section in
      guard let section else { return }
      if section.hasPrefix("settings.startup") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsStartup,
          for: .settings
        )
      } else if section.hasPrefix("settings.prayer") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsPrayer,
          for: .settings
        )
      } else if section.hasPrefix("settings.appearance") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsAppearance,
          for: .settings
        )
      } else if section.hasPrefix("settings.listening") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsListening,
          for: .settings
        )
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
    .fullScreenCover(isPresented: $isCityPickerPresented) {
      TVPrayerCityPickerScreen(
        prayerService: prayerService,
        isPresented: $isCityPickerPresented
      )
      .environmentObject(themeController)
    }
  }

  @ViewBuilder
  private var prayerSection: some View {
    TVSectionHeader(
      title: tvLocalized("Prayer times"),
      subtitle: tvLocalized("Calculated for where you are, the way your phone calculates them.")
    )

    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: TVTheme.railSpacing) {
        Button {
          prayerService.useDeviceLocation()
        } label: {
          optionCard(
            title: tvLocalized("This Apple TV’s location"),
            subtitle: deviceLocationLine,
            systemImage: "location.fill",
            isSelected: prayerService.place?.source == .device
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .focused($focusedSection, equals: TVFocusSectionId.settingsPrayer)

        Button {
          isCityPickerPresented = true
        } label: {
          optionCard(
            title: tvLocalized("Choose a city"),
            subtitle: prayerService.place?.source == .city
                ? prayerService.place?.name ?? ""
                : tvLocalized("Pick from the list."),
            systemImage: "building.2.fill",
            isSelected: prayerService.place?.source == .city
          )
        }
        .buttonStyle(TVCardButtonStyle())
        .focused($focusedSection, equals: "settings.prayer.city")
      }
      .padding(TVTheme.railBleed)
    }
    .tvRail()

    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: TVTheme.railSpacing) {
        ForEach(TVPrayerMethod.allCases) { method in
          Button {
            prayerService.selectMethod(method)
          } label: {
            optionCard(
              title: tvLocalized(method.nameKey),
              subtitle: method.anglesLine,
              systemImage: method.systemImage,
              isSelected: prayerService.method == method
            )
          }
          .buttonStyle(TVCardButtonStyle())
          .focused($focusedSection, equals: "settings.prayer.method.\(method.rawValue)")
        }
      }
      .padding(TVTheme.railBleed)
    }
    .tvRail()

    ScrollView(.horizontal, showsIndicators: false) {
      HStack(spacing: TVTheme.railSpacing) {
        ForEach(TVAsrRule.allCases) { rule in
          Button {
            prayerService.selectAsr(rule)
          } label: {
            optionCard(
              title: tvLocalized(rule.nameKey),
              subtitle: tvLocalized(rule.detailKey),
              systemImage: rule.systemImage,
              isSelected: prayerService.asr == rule
            )
          }
          .buttonStyle(TVCardButtonStyle())
          .focused($focusedSection, equals: "settings.prayer.asr.\(rule.rawValue)")
        }
      }
      .padding(TVTheme.railBleed)
    }
    .tvRail()
  }

  /// Simulator-only, like TV_SAMPLE_ROUTE: open on the list of cities.
  private static var opensOnCityPicker: Bool {
    #if targetEnvironment(simulator)
    return ProcessInfo.processInfo.environment["TV_SAMPLE_CITY_PICKER"] == "1"
    #else
    return false
    #endif
  }

  private var deviceLocationLine: String {
    switch prayerService.status {
    case .locating:
      return tvLocalized("Finding this Apple TV")
    case .denied:
      return tvLocalized("Location is off for Path of Nūr. Turn it on in the Apple TV’s Settings, or choose a city.")
    case .failed:
      return tvLocalized("Couldn’t find this Apple TV. Try again, or choose a city.")
    case .unset, .ready:
      if let place = prayerService.place, place.source == .device {
        return place.name
      }
      return tvLocalized("Asks once, and stays on this Apple TV.")
    }
  }

  private var detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(viewModel.detailRailTitle)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)

      VStack(alignment: .leading, spacing: 12) {
        ForEach(
          [
            String(
              format: tvLocalized("Prayer times: %@"),
              prayerService.place?.name ?? tvLocalized("No place chosen")
            ),
            String(
              format: tvLocalized("Appearance: %@"),
              tvLocalized(themeController.appearance.titleKey)
            ),
          ] + viewModel.detailRailPoints,
          id: \.self
        ) { point in
          HStack(alignment: .top, spacing: 10) {
            Circle()
              .fill(TVTheme.focus)
              .frame(width: 8, height: 8)
              .padding(.top, 7)

            Text(point)
              .font(TVTypography.detail)
              .foregroundColor(TVTheme.textSecondary)
          }
        }
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: true)
  }

  private func optionCard(
    title: String,
    subtitle: String,
    systemImage: String,
    isSelected: Bool
  ) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      HStack(alignment: .center, spacing: 12) {
        Image(systemName: systemImage)
          .font(.system(size: 24, weight: .semibold))
          .foregroundColor(isSelected ? TVTheme.prayerCurrentText : TVTheme.focus)
          .frame(width: 44, height: 44)
          .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
              .fill(isSelected ? TVTheme.prayerCurrent : TVTheme.surfaceSoft)
          )

        Spacer(minLength: 0)

        if isSelected {
          Text(tvLocalized("Selected"))
            .font(TVTypography.detail)
            .foregroundColor(TVTheme.prayerCurrentText)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
              Capsule(style: .continuous)
                .fill(TVTheme.prayerCurrent)
            )
        }
      }

      Text(title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .lineLimit(2)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(3)
        .tvReadableBody()

      Spacer(minLength: 0)
    }
    .frame(width: 372, height: 228, alignment: .topLeading)
    .padding(TVTheme.cardPadding)
    .background(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .fill(
          isSelected ? TVTheme.surfaceElevated : TVTheme.surfaceSoft.opacity(0.9)
        )
        .overlay(
          RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
            .stroke(
              isSelected ? TVTheme.focus.opacity(0.55) : TVTheme.surfaceStroke,
              lineWidth: 1
            )
        )
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: title,
      hint: subtitle,
      value: isSelected ? tvLocalized("Selected") : nil
    )
  }

  private func restorePreferredFocus() {
    guard appViewModel.activeColumn == .content else { return }
    let preferredSection = appViewModel.preferredContentSection(for: .settings)
    DispatchQueue.main.async {
      switch preferredSection {
      case TVFocusSectionId.settingsPrayer:
        focusedSection = TVFocusSectionId.settingsPrayer
      case TVFocusSectionId.settingsAppearance:
        focusedSection = TVFocusSectionId.settingsAppearance
      case TVFocusSectionId.settingsListening:
        focusedSection = TVFocusSectionId.settingsListening
      default:
        focusedSection = TVFocusSectionId.settingsStartup
      }
    }
  }
}
