import SwiftUI

struct TVSettingsScreen: View {
  @ObservedObject var viewModel: TVSettingsViewModel
  @EnvironmentObject private var appViewModel: TVAppViewModel
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
          subtitle: viewModel.startupSubtitle
        )

        HStack(alignment: .top, spacing: TVTheme.columnSpacing) {
          VStack(alignment: .leading, spacing: 18) {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack(spacing: TVTheme.railSpacing) {
                ForEach(Array(TVStartupPreference.allCases.enumerated()), id: \.element.id) {
                  index, preference in
                  let focusID = index == 0
                      ? TVFocusSectionId.settingsStartup
                      : "settings.startup.\(preference.rawValue)"

                  Button {
                    appViewModel.selectStartupPreference(preference)
                  } label: {
                    optionCard(
                      eyebrow: tvLocalized("Startup"),
                      title: tvLocalized(preference.titleKey),
                      subtitle: tvLocalized(preference.subtitleKey),
                      supportingLine: startupSupportingLine(for: preference),
                      systemImage: preference.systemImage,
                      isSelected: viewModel.startupPreference == preference
                    )
                  }
                  .buttonStyle(.plain)
                  .focused($focusedSection, equals: focusID)
                }
              }
              .padding(.vertical, 8)
            }
          }
          .frame(maxWidth: .infinity, alignment: .leading)

          detailRail
            .frame(width: 480, alignment: .top)
        }

        TVSectionHeader(
          title: viewModel.listeningTitle,
          subtitle: viewModel.listeningSubtitle
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
                    eyebrow: tvLocalized("Default reciter"),
                    title: reciter.displayName,
                    subtitle: String(
                      format: tvLocalized("Use %@ when listening mode opens."),
                      reciter.shortLabel
                    ),
                    supportingLine: tvLocalized("This affects the starting reciter for the shared tvOS Qur'an listening flow."),
                    systemImage: "music.note.list",
                    isSelected: viewModel.defaultReciter == reciter
                  )
                }
                .buttonStyle(.plain)
                .focused($focusedSection, equals: focusID)
              }
            }
            .padding(.vertical, 8)
          }

          HStack(spacing: TVTheme.railSpacing) {
            Button {
              appViewModel.setShowListeningTranslationByDefault(
                !viewModel.showListeningTranslationByDefault
              )
            } label: {
              optionCard(
                eyebrow: tvLocalized("Listening helper"),
                title: tvLocalized("Show translation by default"),
                subtitle: viewModel.showListeningTranslationByDefault
                    ? tvLocalized("Translation appears when full-screen listening mode opens.")
                    : tvLocalized("Translation stays hidden until the room chooses to reveal it."),
                supportingLine: tvLocalized("Keep this on when the room benefits from immediate meaning during recitation."),
                systemImage: "captions.bubble.fill",
                isSelected: viewModel.showListeningTranslationByDefault
              )
            }
            .buttonStyle(.plain)
            .focused($focusedSection, equals: "settings.listening.translation")

            Button {
              appViewModel.setShowListeningTransliterationByDefault(
                !viewModel.showListeningTransliterationByDefault
              )
            } label: {
              optionCard(
                eyebrow: tvLocalized("Listening helper"),
                title: tvLocalized("Show transliteration by default"),
                subtitle: viewModel.showListeningTransliterationByDefault
                    ? tvLocalized("Transliteration appears when full-screen listening mode opens.")
                    : tvLocalized("Transliteration stays hidden until the room chooses to reveal it."),
                supportingLine: tvLocalized("Keep this on when the room needs pronunciation help without leaving the television flow."),
                systemImage: "textformat.abc",
                isSelected: viewModel.showListeningTransliterationByDefault
              )
            }
            .buttonStyle(.plain)
            .focused($focusedSection, equals: "settings.listening.transliteration")
          }
        }

        TVSectionHeader(
          title: viewModel.diagnosticsTitle,
          subtitle: viewModel.diagnosticsSubtitle
        )

        TVDiagnosticsSummaryCard(summary: viewModel.diagnosticsSummary)
          .focused($focusedSection, equals: "settings.support.diagnostics")

        TVSectionHeader(
          title: viewModel.supportTitle,
          subtitle: viewModel.supportSubtitle
        )

        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: TVTheme.railSpacing) {
            ForEach(Array(viewModel.supportCards.enumerated()), id: \.element.id) { index, item in
              supportCard(item)
                .focused(
                  $focusedSection,
                  equals: index == 0 ? TVFocusSectionId.settingsSupport : "settings.support.\(item.id)"
                )
            }
          }
          .padding(.vertical, 8)
        }
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
      } else if section.hasPrefix("settings.listening") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsListening,
          for: .settings
        )
      } else if section.hasPrefix("settings.support") {
        appViewModel.markContentSectionFocused(
          TVFocusSectionId.settingsSupport,
          for: .settings
        )
      }
    }
    .onMoveCommand { direction in
      guard direction == .left else { return }
      appViewModel.focusNavigation()
    }
  }

  private var detailRail: some View {
    VStack(alignment: .leading, spacing: 18) {
      Text(viewModel.detailRailTitle)
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)

      Text(viewModel.detailRailSubtitle)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textSecondary)

      VStack(alignment: .leading, spacing: 12) {
        ForEach(viewModel.detailRailPoints, id: \.self) { point in
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
    eyebrow: String,
    title: String,
    subtitle: String,
    supportingLine: String,
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

      Text(eyebrow.uppercased())
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)

      Text(title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(4)
        .tvReadableBody()

      Text(supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(3)
        .tvReadableBody()
    }
    .frame(width: 372, height: 294, alignment: .leading)
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
      hint: "\(subtitle) \(supportingLine)",
      value: isSelected ? tvLocalized("Selected") : nil
    )
  }

  private func supportCard(_ item: TVSettingsSupportCard) -> some View {
    VStack(alignment: .leading, spacing: 16) {
      Image(systemName: item.systemImage)
        .font(.system(size: 28, weight: .semibold))
        .foregroundColor(TVTheme.accentStrong)

      Text(item.eyebrow.uppercased())
        .font(TVTypography.heroEyebrow)
        .foregroundColor(TVTheme.focus)

      Text(item.title)
        .font(TVTypography.featureTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()

      Text(item.subtitle)
        .font(TVTypography.featureSubtitle)
        .foregroundColor(TVTheme.textSecondary)
        .lineLimit(4)
        .tvReadableBody()

      Text(item.supportingLine)
        .font(TVTypography.detail)
        .foregroundColor(TVTheme.textMuted)
        .lineLimit(4)
        .tvReadableBody()
    }
    .frame(width: 420, height: 260, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard()
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: item.title,
      hint: "\(item.subtitle) \(item.supportingLine)"
    )
  }

  private func startupSupportingLine(for preference: TVStartupPreference) -> String {
    switch preference {
    case .profiles:
      return tvLocalized("Best for shared Apple TVs where the room should choose the right household context first.")
    case .lastUsed:
      return tvLocalized("Best for households that want the strongest return path without repeated setup.")
    case .home:
      return tvLocalized("Best for prayer-first family-room use and calm daily return.")
    case .quran:
      return tvLocalized("Best for homes that reopen Apple TV mainly for recitation and listening.")
    case .prayer:
      return tvLocalized("Best for salah-centered return when the room uses Apple TV around prayer times.")
    case .learn:
      return tvLocalized("Best for study circles, family sessions, and guided evening learning.")
    }
  }

  private func restorePreferredFocus() {
    guard appViewModel.activeColumn == .content else { return }
    let preferredSection = appViewModel.preferredContentSection(for: .settings)
    DispatchQueue.main.async {
      switch preferredSection {
      case TVFocusSectionId.settingsListening:
        focusedSection = TVFocusSectionId.settingsListening
      case TVFocusSectionId.settingsSupport:
        focusedSection = TVFocusSectionId.settingsSupport
      default:
        focusedSection = TVFocusSectionId.settingsStartup
      }
    }
  }
}
