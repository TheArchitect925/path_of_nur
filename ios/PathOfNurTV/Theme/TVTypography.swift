import SwiftUI

/// The phone's typographic voice on the big screen: Lora (serif) carries
/// display and titles, Figtree (sans) carries body and labels, and Amiri
/// Quran carries ayah text — the same bundled faces the Flutter app uses
/// (`AppFonts.latinSerif/latinSans`).
enum TVTypography {
  private static func lora(_ size: CGFloat, semibold: Bool = true) -> Font {
    .custom(semibold ? "Lora-SemiBold" : "Lora-Medium", size: size)
  }

  private static func figtree(_ size: CGFloat) -> Font {
    .custom("Figtree-Medium", size: size)
  }

  private static func figtreeSemibold(_ size: CGFloat) -> Font {
    .custom("Figtree-SemiBold", size: size)
  }

  static let heroEyebrow = figtreeSemibold(17)
  static let heroTitle = lora(64)
  static let heroSubtitle = figtree(28)
  static let heroSupporting = figtree(20)

  static let sectionTitle = lora(34)
  static let sectionSubtitle = figtree(19)

  static let featureTitle = lora(29)
  static let featureSubtitle = figtree(18)
  static let summaryTitle = lora(32)
  static let summaryLine = figtreeSemibold(20)
  static let body = figtree(20)
  static let bodySecondary = figtree(18)
  static let detail = figtreeSemibold(16)

  static let arabicListening = Font.custom("AmiriQuran-Regular", size: 56)
  static let arabicHero = Font.custom("AmiriQuran-Regular", size: 40)
  static let arabicAyah = Font.custom("AmiriQuran-Regular", size: 34)
  static let arabicSupport = Font.custom("AmiriQuran-Regular", size: 26)
  static let arabicBody = Font.custom("AmiriQuran-Regular", size: 30)

  static let numeralLarge = figtreeSemibold(36)
  static let chip = figtreeSemibold(17)
  static let badge = figtreeSemibold(14)
  static let caption = figtreeSemibold(15)
}
