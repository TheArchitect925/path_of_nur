import SwiftUI

/// One phrase of the counter: what is said, how it is read and what it
/// means, and how far today's count of it has come.
struct TVDhikrPhraseCard: View {
  let phrase: TVDhikrRoutine
  /// What the card says of the day.
  let line: String
  let isDone: Bool

  static let size = CGSize(width: 380, height: 236)

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      if let step = phrase.steps.first {
        Text(step.arabic)
          .font(TVTypography.arabicBody)
          .foregroundColor(TVTheme.textPrimary)
          .lineLimit(1)
          .minimumScaleFactor(0.6)
          .tvArabicLine()
          .tvReadableArabic()

        Text(step.transliteration)
          .font(TVTypography.featureSubtitle)
          .foregroundColor(TVTheme.textSecondary)
          .lineLimit(2)
          .minimumScaleFactor(0.8)
          .tvReadableBody()

        Text(step.translation)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textPrimary)
          .lineLimit(3)
          .minimumScaleFactor(0.8)
          .tvReadableBody()
      }

      Spacer(minLength: 0)

      HStack(spacing: 8) {
        if isDone {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(TVTheme.accentStrong)
        }
        Text(line)
          .font(TVTypography.detail)
          .foregroundColor(TVTheme.textMuted)
          .lineLimit(1)
          .minimumScaleFactor(0.8)
      }
    }
    .frame(width: Self.size.width, height: Self.size.height, alignment: .leading)
    .padding(TVTheme.cardPadding)
    .tvSurfaceCard(elevated: true, emphasized: isDone)
    .tvFocusableCard()
    .tvCombinedAccessibility(
      label: phrase.title,
      hint: phrase.steps.first?.translation ?? "",
      value: line
    )
  }
}
