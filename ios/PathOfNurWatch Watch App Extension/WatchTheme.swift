import SwiftUI

/// Watch palettes mirror `AppAppearanceTheme` in
/// `lib/core/theme/app_theme.dart`. The watch renders on an always-dark
/// OLED ground, so the phone's light themes follow the same rule as the
/// phone's living atmosphere at night: they resolve to Midnight. The
/// night-family and dark-family themes carry their exact phone tokens.
struct WatchPalette: Equatable {
  let background: Color
  let backgroundAlt: Color
  let surface: Color
  let surfaceSoft: Color
  let onSurface: Color
  let onSurfaceSubtle: Color
  let onSurfaceMuted: Color
  let accent: Color
  let accentSoft: Color
  let edgeLight: Color
  let border: Color
  let divider: Color
  let success: Color

  /// Warm amber used for stale/pending/missed states across all palettes.
  var warning: Color { Color(hex: 0xE29A63) }

  var backgroundGradient: LinearGradient {
    LinearGradient(
      colors: [backgroundAlt, background],
      startPoint: .top,
      endPoint: .bottom
    )
  }

  var cardFill: Color { surface.opacity(0.94) }
  var cardFillSoft: Color { surfaceSoft.opacity(0.85) }

  var cardBorderGradient: LinearGradient {
    LinearGradient(
      colors: [edgeLight.opacity(0.38), border.opacity(0.45)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  /// Deep Glass over the starry indigo sky (`AppThemeMode.midnight`).
  static let midnight = WatchPalette(
    background: Color(hex: 0x121423),
    backgroundAlt: Color(hex: 0x1A1F33),
    surface: Color(hex: 0x262C46),
    surfaceSoft: Color(hex: 0x1F2540),
    onSurface: Color(hex: 0xEFE8D7),
    onSurfaceSubtle: Color(hex: 0xC9C0AA),
    onSurfaceMuted: Color(hex: 0x8E8874),
    accent: Color(hex: 0xE2C177),
    accentSoft: Color(hex: 0xB99752),
    edgeLight: Color(hex: 0xE2C177),
    border: Color(hex: 0x3E4460),
    divider: Color(hex: 0x343A58),
    success: Color(hex: 0xA9C79B)
  )

  /// Warm ember ground with the candle-glow crown (`candlelight`).
  static let candlelight = WatchPalette(
    background: Color(hex: 0x15100B),
    backgroundAlt: Color(hex: 0x1D1610),
    surface: Color(hex: 0x2B2318),
    surfaceSoft: Color(hex: 0x241D12),
    onSurface: Color(hex: 0xEFE2C8),
    onSurfaceSubtle: Color(hex: 0xC4B394),
    onSurfaceMuted: Color(hex: 0x8F8268),
    accent: Color(hex: 0xDDBA75),
    accentSoft: Color(hex: 0xB6924E),
    edgeLight: Color(hex: 0xDDBA75),
    border: Color(hex: 0x463A26),
    divider: Color(hex: 0x3A3020),
    success: Color(hex: 0xBCC79B)
  )

  /// Masjid Emerald: dome-green crowned by the golden mihrab (`jummah`).
  static let jummah = WatchPalette(
    background: Color(hex: 0x0D271E),
    backgroundAlt: Color(hex: 0x16382C),
    surface: Color(hex: 0x24443A),
    surfaceSoft: Color(hex: 0x1D3A2F),
    onSurface: Color(hex: 0xEAF2E6),
    onSurfaceSubtle: Color(hex: 0xB8C9B4),
    onSurfaceMuted: Color(hex: 0x7E907C),
    accent: Color(hex: 0xDCC07A),
    accentSoft: Color(hex: 0xB49A55),
    edgeLight: Color(hex: 0xDCC07A),
    border: Color(hex: 0x35543F),
    divider: Color(hex: 0x2C4837),
    success: Color(hex: 0x8FCBAA)
  )

  /// Layali: the violet Ramadan night lit by the fanoos (`ramadan`).
  static let ramadan = WatchPalette(
    background: Color(hex: 0x151024),
    backgroundAlt: Color(hex: 0x211A38),
    surface: Color(hex: 0x2E2749),
    surfaceSoft: Color(hex: 0x272040),
    onSurface: Color(hex: 0xF0E9DA),
    onSurfaceSubtle: Color(hex: 0xC6BDAB),
    onSurfaceMuted: Color(hex: 0x8D8577),
    accent: Color(hex: 0xE9BE7B),
    accentSoft: Color(hex: 0xC29A58),
    edgeLight: Color(hex: 0xE9BE7B),
    border: Color(hex: 0x443B66),
    divider: Color(hex: 0x3A325C),
    success: Color(hex: 0xA3C79E)
  )

  /// Night of Power: near-black violet, pale luminous gold (`laylatAlQadr`).
  static let laylatAlQadr = WatchPalette(
    background: Color(hex: 0x0E0A1D),
    backgroundAlt: Color(hex: 0x191330),
    surface: Color(hex: 0x241C40),
    surfaceSoft: Color(hex: 0x1E1737),
    onSurface: Color(hex: 0xF2EDE0),
    onSurfaceSubtle: Color(hex: 0xC9C1AE),
    onSurfaceMuted: Color(hex: 0x8E8677),
    accent: Color(hex: 0xE9CD8F),
    accentSoft: Color(hex: 0xC2A45F),
    edgeLight: Color(hex: 0xE9CD8F),
    border: Color(hex: 0x3F3563),
    divider: Color(hex: 0x362D57),
    success: Color(hex: 0x9FC7A6)
  )

  /// Noor dark glass (`noorGlassDark` tokens) for the phone's dark family.
  static let noorDark = WatchPalette(
    background: Color(hex: 0x17191D),
    backgroundAlt: Color(hex: 0x1E2228),
    surface: Color(hex: 0x252A31),
    surfaceSoft: Color(hex: 0x2D343C),
    onSurface: Color(hex: 0xF0E4D0),
    onSurfaceSubtle: Color(hex: 0xD0C0AA),
    onSurfaceMuted: Color(hex: 0xA79681),
    accent: Color(hex: 0xCFAA70),
    accentSoft: Color(hex: 0xA27E46),
    edgeLight: Color(hex: 0xDFC493),
    border: Color(hex: 0x786242),
    divider: Color(hex: 0x392E20),
    success: Color(hex: 0x8AB7A9)
  )

  /// Maps the phone's `AppThemeMode.name` (synced as
  /// `WatchSettingsPayload.watchThemeMode`) to a watch palette.
  static func palette(forPhoneThemeMode name: String?) -> WatchPalette {
    switch name {
    case "midnight":
      return .midnight
    case "candlelight":
      return .candlelight
    case "jummah":
      return .jummah
    case "ramadan":
      return .ramadan
    case "laylatAlQadr":
      return .laylatAlQadr
    case "dark", "noorGlassDark", "noGlassDark",
         "midnightManuscript", "noorMidnightManuscript":
      return .noorDark
    default:
      // Light-family phone themes (noorGlass, defaultMode, eid, kids, …)
      // render as the app's painted night, same as the phone after Isha.
      return .midnight
    }
  }
}

extension Color {
  init(hex: UInt32) {
    self.init(
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255
    )
  }
}

private struct WatchPaletteKey: EnvironmentKey {
  static let defaultValue = WatchPalette.midnight
}

extension EnvironmentValues {
  var watchPalette: WatchPalette {
    get { self[WatchPaletteKey.self] }
    set { self[WatchPaletteKey.self] = newValue }
  }
}

/// Type roles mirroring the phone's scale: Lora-style serif for display
/// and titles (New York on watchOS), plain sans for body and numerals.
enum WatchType {
  static let screenTitle = Font.system(size: 17, weight: .semibold, design: .serif)
  static let heroTitle = Font.system(size: 19, weight: .semibold, design: .serif)
  static let value = Font.system(size: 20, weight: .semibold)
  static let valueLarge = Font.system(size: 24, weight: .semibold)
  static let body = Font.system(size: 14, weight: .regular)
  static let label = Font.system(size: 12, weight: .medium)
  static let caption = Font.system(size: 11, weight: .medium)
  static let captionEmphasis = Font.system(size: 11, weight: .semibold)
}

/// Shared screen header: serif gold title (the night-family "gold headers"
/// rule) with an optional trailing view such as the sync badge.
struct WatchScreenHeader<Trailing: View>: View {
  @Environment(\.watchPalette) private var palette
  let title: String
  @ViewBuilder let trailing: Trailing

  init(_ title: String, @ViewBuilder trailing: () -> Trailing) {
    self.title = title
    self.trailing = trailing()
  }

  var body: some View {
    HStack(alignment: .firstTextBaseline) {
      Text(title)
        .font(WatchType.screenTitle)
        .foregroundStyle(palette.accent)
      Spacer(minLength: 6)
      trailing
    }
  }
}

extension WatchScreenHeader where Trailing == EmptyView {
  init(_ title: String) {
    self.init(title) { EmptyView() }
  }
}
