import SwiftUI

/// What the recitation is heard and read with: how it repeats, which lines
/// are shown, the translation, and the reciter. It stands at the side of the
/// screen, over the player or the reader, and Menu puts it away.
struct TVQuranPlayerOptionsPanel: View {
  @ObservedObject var viewModel: TVQuranViewModel
  var onClose: () -> Void

  @FocusState private var focusedRow: String?
  @State private var focusSeeker = TVFocusSeeker()

  static let width: CGFloat = 780
  static let prefix = "player.options."

  static func repeatID(_ mode: TVQuranRepeat) -> String { "\(prefix)repeat.\(mode.rawValue)" }
  static func translationID(_ translation: TVQuranTranslation?) -> String {
    "\(prefix)translation.\(translation?.id ?? TVQuranTranslationChoice.noneValue)"
  }
  static func reciterID(_ reciter: TVQuranReciter) -> String { "\(prefix)reciter.\(reciter.rawValue)" }
  static let showTranslationID = "\(prefix)show.translation"
  static let showTransliterationID = "\(prefix)show.transliteration"

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      Text(tvLocalized("Listening options"))
        .font(TVTypography.summaryTitle)
        .foregroundColor(TVTheme.textPrimary)
        .tvReadableTitle()
        .padding(.horizontal, TVTheme.railBleed)
        .padding(.top, 36)
        .padding(.bottom, 8)

      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 10) {
          section(tvLocalized("Repeat"))
          ForEach(TVQuranRepeat.allCases) { mode in
            row(
              title: mode.title,
              isChosen: viewModel.repeatMode == mode,
              id: Self.repeatID(mode)
            ) {
              viewModel.selectRepeat(mode)
            }
          }

          section(tvLocalized("Show"))
          row(
            title: tvLocalized("Translation"),
            subtitle: viewModel.showListeningTranslation ? tvLocalized("On") : tvLocalized("Off"),
            isChosen: viewModel.showListeningTranslation,
            id: Self.showTranslationID,
            isSwitch: true
          ) {
            viewModel.toggleListeningTranslation()
          }
          row(
            title: tvLocalized("Transliteration"),
            subtitle: viewModel.showListeningTransliteration ? tvLocalized("On") : tvLocalized("Off"),
            isChosen: viewModel.showListeningTransliteration,
            id: Self.showTransliterationID,
            isSwitch: true
          ) {
            viewModel.toggleListeningTransliteration()
          }

          section(tvLocalized("Translation"))
          ForEach(TVQuranTranslation.all) { translation in
            row(
              title: translation.languageName,
              subtitle: translation.source,
              isChosen: viewModel.translation == translation,
              id: Self.translationID(translation)
            ) {
              viewModel.selectTranslation(translation)
            }
          }
          row(
            title: tvLocalized("No translation"),
            subtitle: tvLocalized("The Arabic and its reading"),
            isChosen: viewModel.translation == nil,
            id: Self.translationID(nil)
          ) {
            viewModel.selectTranslation(nil)
          }

          section(tvLocalized("Reciter"))
          ForEach(TVQuranReciter.allCases) { reciter in
            row(
              title: reciter.name,
              subtitle: reciter.styleLabel,
              isChosen: viewModel.selectedReciter == reciter,
              id: Self.reciterID(reciter)
            ) {
              viewModel.selectReciter(reciter)
            }
          }
        }
        .padding(.horizontal, TVTheme.railBleed)
        .padding(.vertical, TVTheme.railBleed)
      }
      .focusSection()
      .tvPreferredFocus($focusedRow, Self.repeatID(viewModel.repeatMode))
    }
    .frame(width: Self.width)
    .frame(maxHeight: .infinity)
    .background(
      ZStack {
        TVTheme.backgroundBottom
        TVTheme.surfaceElevated
      }
      .clipShape(RoundedRectangle(cornerRadius: TVTheme.heroRadius, style: .continuous))
      .shadow(color: TVTheme.surfaceShadow, radius: 40, x: 0, y: 12)
    )
    .onAppear {
      focusSeeker.seek(Self.repeatID(viewModel.repeatMode), with: $focusedRow)
    }
    .onExitCommand {
      onClose()
    }
  }

  private func section(_ title: String) -> some View {
    Text(title)
      .font(TVTypography.figtreeMedium(22))
      .foregroundColor(TVTheme.textSecondary)
      .textCase(nil)
      .padding(.top, 22)
      .padding(.bottom, 2)
      .accessibilityAddTraits(.isHeader)
  }

  private func row(
    title: String,
    subtitle: String = "",
    isChosen: Bool,
    id: String,
    isSwitch: Bool = false,
    action: @escaping () -> Void
  ) -> some View {
    Button(action: action) {
      HStack(spacing: 18) {
        VStack(alignment: .leading, spacing: 4) {
          Text(title)
            .font(TVTypography.figtreeMedium(26))
            .foregroundColor(TVTheme.textPrimary)
            .lineLimit(1)
          if !subtitle.isEmpty {
            Text(subtitle)
              .font(TVTypography.figtreeMedium(20))
              .foregroundColor(TVTheme.textSecondary)
              .lineLimit(1)
          }
        }
        Spacer(minLength: 12)
        Image(systemName: isSwitch
          ? (isChosen ? "checkmark.square.fill" : "square")
          : (isChosen ? "checkmark.circle.fill" : "circle"))
          .font(.system(size: 28, weight: .semibold))
          .foregroundColor(isChosen ? TVTheme.accentStrong : TVTheme.textMuted)
      }
      .padding(.horizontal, 24)
      .padding(.vertical, 16)
      .frame(maxWidth: .infinity, alignment: .leading)
      .background(
        RoundedRectangle(cornerRadius: 22, style: .continuous)
          .fill(isChosen ? TVTheme.surface : TVTheme.surfaceSoft)
      )
    }
    .buttonStyle(TVCardButtonStyle(shape: .rounded(22)))
    .tvFocusID($focusedRow, id)
    .accessibilityLabel(subtitle.isEmpty ? title : "\(title), \(subtitle)")
    .accessibilityValue(isChosen ? tvLocalized("Selected") : "")
  }
}
