import SwiftUI

struct TVQuranListeningModeScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  @Environment(\.dismiss) private var dismiss
  @FocusState private var focusedControl: String?

  var body: some View {
    ZStack {
      LinearGradient(
        colors: [
          TVTheme.backgroundTop,
          TVTheme.surfaceSoft,
          TVTheme.backgroundBottom,
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )
      .ignoresSafeArea()

      VStack(spacing: 28) {
        _header

        Spacer(minLength: 0)

        _ayahStage

        Spacer(minLength: 0)

        _settingsRow

        _transportCard
      }
      .padding(.horizontal, 72)
      .padding(.vertical, 42)
    }
    .onAppear {
      if !viewModel.isPlaying {
        viewModel.playSelectedAyah()
      }
      DispatchQueue.main.async {
        focusedControl = "listening.playPause"
      }
    }
  }

  private var _header: some View {
    HStack(alignment: .top, spacing: 20) {
      VStack(alignment: .leading, spacing: 10) {
        Text(tvLocalized("Listening mode"))
          .font(TVTypography.summaryTitle)
          .foregroundColor(TVTheme.textPrimary)
          .tvReadableTitle()

        Text(viewModel.listeningModeHeaderLine)
          .font(TVTypography.sectionSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()

        Text(viewModel.listeningModeStatusLine)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.accentStrong)
          .tvReadableBody()
      }

      Spacer()

      Button {
        viewModel.closeListeningMode()
        dismiss()
      } label: {
        Label(
          tvLocalized("Exit listening mode"),
          systemImage: "xmark.circle.fill"
        )
        .font(TVTypography.chip)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(TVTheme.surfaceSoft, in: Capsule())
      }
      .buttonStyle(.plain)
      .tvFocusableCard()
      .focused($focusedControl, equals: "listening.exit")
      .accessibilityLabel(tvLocalized("Exit listening mode"))
    }
  }

  private var _ayahStage: some View {
    VStack(spacing: 22) {
      Text(viewModel.listeningModeArabicText)
        .font(.system(size: 52, weight: .semibold, design: .rounded))
        .foregroundColor(TVTheme.textPrimary)
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: 1180, alignment: .trailing)
        .tvReadableArabic()

      if viewModel.showListeningTransliteration {
        Text(viewModel.listeningModeTransliterationText)
          .font(TVTypography.featureSubtitle.italic())
          .italic()
          .foregroundColor(TVTheme.textMuted)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 980)
          .tvReadableBody()
      }

      if viewModel.showListeningTranslation {
        Text(viewModel.listeningModeTranslationText)
          .font(TVTypography.body)
          .foregroundColor(TVTheme.textSecondary)
          .multilineTextAlignment(.center)
          .frame(maxWidth: 980)
          .tvReadableBody()
      }
    }
    .frame(maxWidth: .infinity)
    .padding(.horizontal, 36)
    .padding(.vertical, 28)
    .tvSurfaceCard(elevated: true, emphasized: true)
    .tvCombinedAccessibility(
      label: viewModel.listeningModeHeaderLine,
      hint: viewModel.listeningModeTransportLine,
      value: viewModel.listeningModeStatusLine
    )
  }

  private var _settingsRow: some View {
    HStack(spacing: 18) {
      _toggleChip(
        label: viewModel.repeatCurrentAyah
            ? tvLocalized("Repeat ayah on")
            : tvLocalized("Repeat ayah off"),
        focusID: "listening.repeat"
      ) {
        viewModel.toggleRepeatCurrentAyah()
      }

      _toggleChip(
        label: viewModel.showListeningTranslation
            ? tvLocalized("Translation on")
            : tvLocalized("Translation off"),
        focusID: "listening.translation"
      ) {
        viewModel.toggleListeningTranslation()
      }

      _toggleChip(
        label: viewModel.showListeningTransliteration
            ? tvLocalized("Transliteration on")
            : tvLocalized("Transliteration off"),
        focusID: "listening.transliteration"
      ) {
        viewModel.toggleListeningTransliteration()
      }
    }
  }

  private var _transportCard: some View {
    VStack(alignment: .leading, spacing: 18) {
      HStack(alignment: .top) {
        VStack(alignment: .leading, spacing: 8) {
          Text(tvLocalized("Audio controls"))
            .font(TVTypography.summaryTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          Text(viewModel.listeningModeTransportLine)
            .font(TVTypography.sectionSubtitle)
            .foregroundColor(TVTheme.textSecondary)
            .tvReadableBody()
        }

        Spacer()

        Text(viewModel.selectedReciter.displayName)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .tvReadableBody()
      }

      HStack(spacing: 16) {
        ForEach(TVQuranReciter.allCases, id: \.self) { reciter in
          Button {
            viewModel.selectReciter(reciter)
          } label: {
            Text(reciter.shortLabel)
              .font(TVTypography.chip)
              .foregroundColor(
                viewModel.selectedReciter == reciter
                    ? TVTheme.prayerCurrentText
                    : TVTheme.textPrimary
              )
              .padding(.horizontal, 18)
              .padding(.vertical, 12)
              .background(
                viewModel.selectedReciter == reciter
                    ? TVTheme.prayerCurrent
                    : TVTheme.surfaceSoft,
                in: Capsule()
              )
          }
          .buttonStyle(.plain)
          .tvFocusableCard()
          .accessibilityLabel(tvLocalized("Switch reciter to %@.", reciter.displayName))
        }
      }

      HStack(spacing: 20) {
        _transportButton(
          systemName: "backward.fill",
          focusID: "listening.previous"
        ) {
          viewModel.playPreviousAyah()
        }

        _transportButton(
          systemName: viewModel.isPlaying ? "pause.fill" : "play.fill",
          large: true,
          focusID: "listening.playPause"
        ) {
          viewModel.togglePlayback()
        }

        _transportButton(
          systemName: "forward.fill",
          focusID: "listening.next"
        ) {
          viewModel.playNextAyah()
        }
      }

      if let errorMessage = viewModel.playbackErrorMessage {
        Text(errorMessage)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.cautionText)
          .tvReadableBody()
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true)
  }

  private func _toggleChip(
    label: String,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Text(label)
        .font(TVTypography.chip)
        .foregroundColor(TVTheme.textPrimary)
        .padding(.horizontal, 18)
        .padding(.vertical, 12)
        .background(TVTheme.surfaceSoft, in: Capsule())
    }
    .buttonStyle(.plain)
    .tvFocusableCard()
    .focused($focusedControl, equals: focusID)
    .accessibilityLabel(label)
  }

  private func _transportButton(
    systemName: String,
    large: Bool = false,
    focusID: String,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      Image(systemName: systemName)
        .font(.system(size: large ? 34 : 24, weight: .bold))
        .foregroundColor(TVTheme.textPrimary)
        .frame(width: large ? 98 : 80, height: large ? 98 : 80)
        .background(
          RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(large ? TVTheme.accentSoft : TVTheme.surfaceSoft)
        )
    }
    .buttonStyle(.plain)
    .tvFocusableCard()
    .focused($focusedControl, equals: focusID)
    .accessibilityLabel(_transportAccessibilityLabel(systemName: systemName))
  }

  private func _transportAccessibilityLabel(systemName: String) -> String {
    switch systemName {
    case "backward.fill":
      return tvLocalized("Previous ayah")
    case "forward.fill":
      return tvLocalized("Next ayah")
    default:
      return viewModel.isPlaying ? tvLocalized("Pause audio") : tvLocalized("Play audio")
    }
  }
}
