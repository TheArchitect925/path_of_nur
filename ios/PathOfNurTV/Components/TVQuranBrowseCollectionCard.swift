import SwiftUI

/// A way into the list: where the viewer left off, the verse of the day, a
/// group of surahs. Set small, since it shares a column with the list itself.
struct TVQuranBrowseCollectionCard: View {
  static let width: CGFloat = 264

  let title: String
  let subtitle: String
  let systemImage: String
  let isSelected: Bool

  init(collection: TVQuranBrowseCollection, isSelected: Bool) {
    title = collection.title
    subtitle = collection.subtitle
    systemImage = collection.systemImage
    self.isSelected = isSelected
  }

  init(title: String, subtitle: String, systemImage: String, isSelected: Bool = false) {
    self.title = title
    self.subtitle = subtitle
    self.systemImage = systemImage
    self.isSelected = isSelected
  }

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      VStack(alignment: .leading, spacing: 6) {
        Text(title)
          .font(TVTypography.listTitle)
          .foregroundColor(TVTheme.textPrimary)
          .lineLimit(1)
          .minimumScaleFactor(0.8)

        Text(subtitle)
          .font(TVTypography.caption)
          .foregroundColor(TVTheme.accentStrong)
          .lineLimit(2)
      }

      Spacer(minLength: 0)

      Image(systemName: systemImage)
        .font(.system(size: 20, weight: .semibold))
        .foregroundColor(TVTheme.accentStrong)
    }
    .frame(width: Self.width, height: 78, alignment: .topLeading)
    .padding(18)
    .tvSurfaceCard(elevated: true, emphasized: isSelected)
    .tvFocusableCard()
    .tvCombinedAccessibility(label: title, value: subtitle)
  }
}
