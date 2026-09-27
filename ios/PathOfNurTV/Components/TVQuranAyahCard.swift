import SwiftUI

/// One part of an ayah: the whole of it for most, and for a long one as much
/// as fits the room (see `TVQuranAyahPlanner`). The reader sets it to the
/// side it is read from; listening mode sets it larger and to the middle.
struct TVQuranAyahCard: View {
  // Its measures are TVQuranAyahMetrics', which the planner counts on.
  static let padding = TVQuranAyahMetrics.cardPadding
  static let spacing = TVQuranAyahMetrics.cardSpacing
  static let headingHeight = TVQuranAyahMetrics.headingHeight

  let part: TVQuranAyahPart
  let isSelected: Bool
  let isPlaying: Bool
  var metrics: TVQuranAyahMetrics?
  var isCentered = false

  var body: some View {
    VStack(alignment: isCentered ? .center : .leading, spacing: Self.spacing) {
      HStack {
        Text(part.heading)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(1)

        Spacer()

        if isPlaying {
          Image(systemName: "speaker.wave.2.fill")
            .foregroundColor(TVTheme.accentStrong)
        } else if isSelected {
          Image(systemName: "play.circle.fill")
            .foregroundColor(TVTheme.accentStrong)
        }
      }
      .frame(height: Self.headingHeight)

      TVQuranAyahText(part: part, metrics: metrics, isCentered: isCentered)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(Self.padding)
    .tvSurfaceCard(elevated: isSelected, emphasized: isSelected || isPlaying)
    .overlay(
      RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
        .stroke(
          isPlaying
            ? TVTheme.accentStrong
            : (isSelected ? TVTheme.accentSoft : .clear),
          lineWidth: isPlaying ? 3 : (isSelected ? 1.5 : 0)
        )
    )
    .shadow(
      color: isPlaying ? TVTheme.accentStrong.opacity(0.28) : .clear,
      radius: isPlaying ? 18 : 0,
      x: 0,
      y: 6
    )
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: part.heading,
      hint: part.translation,
      value: isPlaying ? tvLocalized("Playing") : (isSelected ? tvLocalized("Selected") : nil)
    )
  }
}

/// The Arabic, its reading and its meaning, one under another, in the type
/// and the width the planner measured them at. Nothing here is shrunk or cut
/// to fit: what is measured is what is set.
struct TVQuranAyahText: View {
  let part: TVQuranAyahPart
  var metrics: TVQuranAyahMetrics?
  var isCentered = false

  var body: some View {
    VStack(alignment: isCentered ? .center : .leading, spacing: metrics?.gap ?? TVQuranAyahCard.spacing) {
      if !part.arabic.isEmpty {
        arabic
      }

      if !part.transliteration.isEmpty {
        Text(part.transliteration)
          .font(TVTypography.figtreeMedium(metrics?.transliterationSize ?? 18).italic())
          .italic()
          .foregroundColor(TVTheme.textMuted)
          .lineSpacing(TVQuranAyahMetrics.bodyLineSpacing)
          .multilineTextAlignment(isCentered ? .center : .leading)
          .frame(maxWidth: metrics?.bodyTextWidth, alignment: isCentered ? .center : .leading)
          .fixedSize(horizontal: false, vertical: true)
      }

      if !part.translation.isEmpty {
        Text(part.translation)
          .font(TVTypography.figtreeMedium(metrics?.translationSize ?? 20))
          .foregroundColor(TVTheme.textSecondary)
          .lineSpacing(metrics?.translationLineSpacing ?? TVQuranAyahMetrics.bodyLineSpacing)
          .multilineTextAlignment(isCentered ? .center : .leading)
          .frame(maxWidth: metrics?.bodyTextWidth, alignment: isCentered ? .center : .leading)
          .fixedSize(horizontal: false, vertical: true)
      }
    }
    .frame(maxWidth: .infinity, alignment: isCentered ? .center : .leading)
  }

  @ViewBuilder
  private var arabic: some View {
    let text = Text(part.arabic)
      .font(TVTypography.amiriQuran(metrics?.arabicSize ?? 34))
      .foregroundColor(TVTheme.textPrimary)
      .lineSpacing(TVQuranAyahMetrics.arabicLineSpacing)

    if isCentered {
      text
        .multilineTextAlignment(.center)
        .frame(maxWidth: metrics?.textWidth, alignment: .center)
        .fixedSize(horizontal: false, vertical: true)
    } else {
      text
        .tvArabicLine()
        .fixedSize(horizontal: false, vertical: true)
    }
  }
}
