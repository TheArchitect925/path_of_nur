import Combine
import SwiftUI

// MARK: - Palette

/// TV palettes mirror `AppAppearanceTheme` in `lib/core/theme/app_theme.dart`
/// with the exact phone hex tokens (the same set the watch carries in
/// `WatchTheme.swift`). Light rooms wear Noor Glass; after dark the living
/// room follows the phone's living-atmosphere rule and becomes Midnight.
struct TVPalette: Equatable {
  let id: String
  let isNight: Bool

  let background: Color
  let backgroundAlt: Color
  let surface: Color
  let surfaceSoft: Color
  let surfaceElevated: Color
  let onSurface: Color
  let onSurfaceSubtle: Color
  let onSurfaceMuted: Color
  let accent: Color
  let accentSoft: Color
  let edgeLight: Color
  let border: Color
  let divider: Color
  let success: Color
  let prayerCurrentFill: Color
  let prayerCurrentText: Color
  let prayerNextFill: Color
  let prayerNextText: Color
  let caution: Color

  /// Card fills follow the phone's near-opaque glass grammar.
  var cardFill: Color { surface.opacity(isNight ? 0.94 : 0.92) }
  var cardFillSoft: Color { surfaceSoft.opacity(isNight ? 0.85 : 0.88) }

  /// The night-family "gold headers" rule: serif section titles glow gold
  /// after dark and stay warm ink in the light.
  var headerColor: Color { isNight ? accent : onSurface }

  /// Deep gold reads best on cream; bright gold reads best on night glass.
  var accentEmphasis: Color { isNight ? accent : accentSoft }
  var focusRing: Color { isNight ? accent : accentSoft }

  var cardStroke: Color { edgeLight.opacity(isNight ? 0.34 : 0.55) }
  var shadow: Color { Color.black.opacity(isNight ? 0.34 : 0.10) }

  var cardBorderGradient: LinearGradient {
    LinearGradient(
      colors: [edgeLight.opacity(isNight ? 0.38 : 0.62), border.opacity(0.45)],
      startPoint: .topLeading,
      endPoint: .bottomTrailing
    )
  }

  /// Noor Glass — the phone's flagship light theme (`AppThemeMode.noorGlass`).
  static let noorGlass = TVPalette(
    id: "noorGlass",
    isNight: false,
    background: Color(hex: 0xF4EFE5),
    backgroundAlt: Color(hex: 0xE9E0CF),
    surface: Color(hex: 0xFBF6ED),
    surfaceSoft: Color(hex: 0xF3E9D9),
    surfaceElevated: Color(hex: 0xFDFAF3),
    onSurface: Color(hex: 0x3A2E22),
    onSurfaceSubtle: Color(hex: 0x655444),
    onSurfaceMuted: Color(hex: 0x85715E),
    accent: Color(hex: 0xD3B280),
    accentSoft: Color(hex: 0xAA8651),
    edgeLight: Color(hex: 0xF2DCB2),
    border: Color(hex: 0xD8C4A2),
    divider: Color(hex: 0xE4D7C0),
    success: Color(hex: 0xA7C8BE),
    prayerCurrentFill: Color(hex: 0xD3E6D2),
    prayerCurrentText: Color(hex: 0x33512F),
    prayerNextFill: Color(hex: 0xF2E0B8),
    prayerNextText: Color(hex: 0x6B4C26),
    caution: Color(hex: 0x87682F)
  )

  /// Deep Glass over the starry indigo sky (`AppThemeMode.midnight`).
  static let midnight = TVPalette(
    id: "midnight",
    isNight: true,
    background: Color(hex: 0x121423),
    backgroundAlt: Color(hex: 0x1A1F33),
    surface: Color(hex: 0x262C46),
    surfaceSoft: Color(hex: 0x1F2540),
    surfaceElevated: Color(hex: 0x2E3552),
    onSurface: Color(hex: 0xEFE8D7),
    onSurfaceSubtle: Color(hex: 0xC9C0AA),
    onSurfaceMuted: Color(hex: 0x8E8874),
    accent: Color(hex: 0xE2C177),
    accentSoft: Color(hex: 0xB99752),
    edgeLight: Color(hex: 0xE2C177),
    border: Color(hex: 0x3E4460),
    divider: Color(hex: 0x343A58),
    success: Color(hex: 0xA9C79B),
    prayerCurrentFill: Color(hex: 0xA9C79B).opacity(0.20),
    prayerCurrentText: Color(hex: 0xCBE3BF),
    prayerNextFill: Color(hex: 0xE2C177).opacity(0.16),
    prayerNextText: Color(hex: 0xE2C177),
    caution: Color(hex: 0xE0B27A)
  )

  /// Warm ember ground with the candle-glow crown (`candlelight`).
  static let candlelight = TVPalette(
    id: "candlelight",
    isNight: true,
    background: Color(hex: 0x15100B),
    backgroundAlt: Color(hex: 0x1D1610),
    surface: Color(hex: 0x2B2318),
    surfaceSoft: Color(hex: 0x241D12),
    surfaceElevated: Color(hex: 0x342B1D),
    onSurface: Color(hex: 0xEFE2C8),
    onSurfaceSubtle: Color(hex: 0xC4B394),
    onSurfaceMuted: Color(hex: 0x8F8268),
    accent: Color(hex: 0xDDBA75),
    accentSoft: Color(hex: 0xB6924E),
    edgeLight: Color(hex: 0xDDBA75),
    border: Color(hex: 0x463A26),
    divider: Color(hex: 0x3A3020),
    success: Color(hex: 0xBCC79B),
    prayerCurrentFill: Color(hex: 0xBCC79B).opacity(0.18),
    prayerCurrentText: Color(hex: 0xD5DDB8),
    prayerNextFill: Color(hex: 0xDDBA75).opacity(0.16),
    prayerNextText: Color(hex: 0xDDBA75),
    caution: Color(hex: 0xE0B27A)
  )

  /// Masjid Emerald: dome-green crowned by the golden mihrab (`jummah`).
  static let jummah = TVPalette(
    id: "jummah",
    isNight: true,
    background: Color(hex: 0x0D271E),
    backgroundAlt: Color(hex: 0x16382C),
    surface: Color(hex: 0x24443A),
    surfaceSoft: Color(hex: 0x1D3A2F),
    surfaceElevated: Color(hex: 0x2C5044),
    onSurface: Color(hex: 0xEAF2E6),
    onSurfaceSubtle: Color(hex: 0xB8C9B4),
    onSurfaceMuted: Color(hex: 0x7E907C),
    accent: Color(hex: 0xDCC07A),
    accentSoft: Color(hex: 0xB49A55),
    edgeLight: Color(hex: 0xDCC07A),
    border: Color(hex: 0x35543F),
    divider: Color(hex: 0x2C4837),
    success: Color(hex: 0x8FCBAA),
    prayerCurrentFill: Color(hex: 0x8FCBAA).opacity(0.20),
    prayerCurrentText: Color(hex: 0xBFE4CF),
    prayerNextFill: Color(hex: 0xDCC07A).opacity(0.16),
    prayerNextText: Color(hex: 0xDCC07A),
    caution: Color(hex: 0xDCB878)
  )

  /// Layali: the violet Ramadan night lit by the fanoos (`ramadan`).
  static let ramadan = TVPalette(
    id: "ramadan",
    isNight: true,
    background: Color(hex: 0x151024),
    backgroundAlt: Color(hex: 0x211A38),
    surface: Color(hex: 0x2E2749),
    surfaceSoft: Color(hex: 0x272040),
    surfaceElevated: Color(hex: 0x362E55),
    onSurface: Color(hex: 0xF0E9DA),
    onSurfaceSubtle: Color(hex: 0xC6BDAB),
    onSurfaceMuted: Color(hex: 0x8D8577),
    accent: Color(hex: 0xE9BE7B),
    accentSoft: Color(hex: 0xC29A58),
    edgeLight: Color(hex: 0xE9BE7B),
    border: Color(hex: 0x443B66),
    divider: Color(hex: 0x3A325C),
    success: Color(hex: 0xA3C79E),
    prayerCurrentFill: Color(hex: 0xA3C79E).opacity(0.20),
    prayerCurrentText: Color(hex: 0xC9E1C2),
    prayerNextFill: Color(hex: 0xE9BE7B).opacity(0.16),
    prayerNextText: Color(hex: 0xE9BE7B),
    caution: Color(hex: 0xE5B87E)
  )

  /// Night of Power: near-black violet, pale luminous gold (`laylatAlQadr`).
  static let laylatAlQadr = TVPalette(
    id: "laylatAlQadr",
    isNight: true,
    background: Color(hex: 0x0E0A1D),
    backgroundAlt: Color(hex: 0x191330),
    surface: Color(hex: 0x241C40),
    surfaceSoft: Color(hex: 0x1E1737),
    surfaceElevated: Color(hex: 0x2C234C),
    onSurface: Color(hex: 0xF2EDE0),
    onSurfaceSubtle: Color(hex: 0xC9C1AE),
    onSurfaceMuted: Color(hex: 0x8E8677),
    accent: Color(hex: 0xE9CD8F),
    accentSoft: Color(hex: 0xC2A45F),
    edgeLight: Color(hex: 0xE9CD8F),
    border: Color(hex: 0x3F3563),
    divider: Color(hex: 0x362D57),
    success: Color(hex: 0x9FC7A6),
    prayerCurrentFill: Color(hex: 0x9FC7A6).opacity(0.20),
    prayerCurrentText: Color(hex: 0xC6E2CA),
    prayerNextFill: Color(hex: 0xE9CD8F).opacity(0.16),
    prayerNextText: Color(hex: 0xE9CD8F),
    caution: Color(hex: 0xE5C288)
  )
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

// MARK: - Sky phase

/// Mirror of `NoorSkyPhase` in `lib/core/theme/living_atmosphere.dart`,
/// using the phone's hour-bucket fallback (the TV has no computed prayer
/// schedule yet).
enum TVSkyPhase: String {
  case dawn, day, maghrib, night

  static func at(_ now: Date) -> TVSkyPhase {
    let components = Calendar.current.dateComponents([.hour, .minute], from: now)
    let hour = Double(components.hour ?? 12) + Double(components.minute ?? 0) / 60
    if hour >= 21 || hour < 5 { return .night }
    if hour < 8 { return .dawn }
    if hour >= 17.5 { return .maghrib }
    return .day
  }
}

// MARK: - Appearance setting

enum TVAppearanceSetting: String, CaseIterable, Identifiable {
  case auto
  case noorGlass
  case midnight
  case candlelight
  case jummah
  case ramadan

  var id: String { rawValue }

  var titleKey: String {
    switch self {
    case .auto: return "Automatic"
    case .noorGlass: return "Noor Glass"
    case .midnight: return "Midnight"
    case .candlelight: return "Candlelight"
    case .jummah: return "Masjid Emerald"
    case .ramadan: return "Ramadan Layali"
    }
  }

  var subtitleKey: String {
    switch self {
    case .auto:
      return "Cream by day and Midnight after dark. Jumu’ah and Ramadan arrive on their own."
    case .noorGlass:
      return "Warm cream glass. Rests into Midnight after dark."
    case .midnight:
      return "Deep indigo under a night sky and moon."
    case .candlelight:
      return "A warm ember light from above."
    case .jummah:
      return "Dome green under a golden mihrab arch."
    case .ramadan:
      return "A violet night lit by a hanging fanoos."
    }
  }

  var systemImage: String {
    switch self {
    case .auto: return "wand.and.stars"
    case .noorGlass: return "sun.max.fill"
    case .midnight: return "moon.stars.fill"
    case .candlelight: return "flame.fill"
    case .jummah: return "building.columns.fill"
    case .ramadan: return "star.circle.fill"
    }
  }
}

// MARK: - Theme controller

/// Resolves the active palette the way the phone does: manual choices win,
/// and "Automatic" walks the occasion ladder (Laylat al-Qadr >
/// Ramadan > Jumu'ah) before falling back to the living-atmosphere
/// day/night rhythm. Noor Glass — manual or auto — becomes Midnight after
/// dark, exactly like the phone's living sky.
final class TVThemeController: ObservableObject {
  @Published private(set) var appearance: TVAppearanceSetting
  @Published private(set) var palette: TVPalette
  @Published private(set) var skyPhase: TVSkyPhase

  /// Identity token for the render tree; changing it repaints every screen
  /// with the new palette (theme flips are rare — dawn, dusk, Friday).
  var renderToken: String { "\(palette.id).\(skyPhase.rawValue)" }

  private let userDefaults: UserDefaults
  private var timer: Timer?
  private var forcedPaletteId: String?
  private static let appearanceStorageKey = "PathOfNurTV.appearance"

  init(userDefaults: UserDefaults = .standard, now: Date = Date()) {
    self.userDefaults = userDefaults
    var stored = TVAppearanceSetting(
      rawValue: userDefaults.string(forKey: Self.appearanceStorageKey) ?? ""
    ) ?? .auto
    #if targetEnvironment(simulator)
    if let forced = ProcessInfo.processInfo.environment["TV_SAMPLE_THEME"] {
      if let mode = TVAppearanceSetting(rawValue: forced) {
        stored = mode
      } else if forced == "laylatAlQadr" {
        forcedPaletteId = forced
      }
    }
    #endif
    appearance = stored
    let phase = Self.effectivePhase(at: now)
    skyPhase = phase
    let resolved = forcedPaletteId == "laylatAlQadr"
      ? TVPalette.laylatAlQadr
      : Self.resolvePalette(appearance: stored, phase: phase, now: now)
    palette = resolved
    TVTheme.current = resolved
    startClock()
  }

  deinit {
    timer?.invalidate()
  }

  func selectAppearance(_ setting: TVAppearanceSetting) {
    appearance = setting
    userDefaults.set(setting.rawValue, forKey: Self.appearanceStorageKey)
    refresh()
  }

  func refresh(now: Date = Date()) {
    let phase = Self.effectivePhase(at: now)
    let resolved = forcedPaletteId == "laylatAlQadr"
      ? TVPalette.laylatAlQadr
      : Self.resolvePalette(appearance: appearance, phase: phase, now: now)
    guard resolved != palette || phase != skyPhase else { return }
    skyPhase = phase
    palette = resolved
    TVTheme.current = resolved
  }

  private static func effectivePhase(at now: Date) -> TVSkyPhase {
    #if targetEnvironment(simulator)
    if let forced = ProcessInfo.processInfo.environment["TV_SAMPLE_PHASE"],
       let phase = TVSkyPhase(rawValue: forced) {
      return phase
    }
    #endif
    return TVSkyPhase.at(now)
  }

  private func startClock() {
    let timer = Timer(timeInterval: 60, repeats: true) { [weak self] _ in
      self?.refresh()
    }
    timer.tolerance = 10
    RunLoop.main.add(timer, forMode: .common)
    self.timer = timer
  }

  static func resolvePalette(
    appearance: TVAppearanceSetting,
    phase: TVSkyPhase,
    now: Date
  ) -> TVPalette {
    switch appearance {
    case .midnight: return .midnight
    case .candlelight: return .candlelight
    case .jummah: return .jummah
    case .ramadan: return .ramadan
    case .noorGlass:
      // Manual Noor Glass still wears the living sky at night, like the
      // phone's `withLivingSky` treatment of manual light modes.
      return phase == .night ? .midnight : .noorGlass
    case .auto:
      // Occasion ladder mirrors `resolveOccasionThemeMode` on the phone,
      // with the tabular hijri calendar standing in for user Ramadan dates.
      let hijri = Calendar(identifier: .islamicTabular)
        .dateComponents([.month, .day], from: now)
      if hijri.month == 9 {
        if phase == .night, let day = hijri.day, day >= 21, day % 2 == 1 {
          return .laylatAlQadr
        }
        return .ramadan
      }
      if Calendar.current.component(.weekday, from: now) == 6 {
        return .jummah
      }
      return phase == .night ? .midnight : .noorGlass
    }
  }
}

// MARK: - Static token facade

/// The token facade every TV view already speaks. Colors resolve through
/// the active palette; `TVThemeController.renderToken` on the root view
/// rebuilds the tree whenever the palette turns over.
enum TVTheme {
  static var current: TVPalette = .noorGlass

  static var backgroundTop: Color { current.backgroundAlt }
  static var backgroundBottom: Color { current.background }
  static var backgroundMeshTop: Color { current.accent }
  static var backgroundMeshBottom: Color { current.accentSoft }
  static var surface: Color { current.cardFill }
  static var surfaceSoft: Color { current.cardFillSoft }
  static var surfaceElevated: Color { current.surfaceElevated }
  static var surfaceStroke: Color { current.cardStroke }
  static var surfaceShadow: Color { current.shadow }
  static var accentSoft: Color { current.accent }
  static var accentStrong: Color { current.accentEmphasis }
  static var focus: Color { current.focusRing }
  static var headerColor: Color { current.headerColor }
  static var textPrimary: Color { current.onSurface }
  static var textSecondary: Color { current.onSurfaceSubtle }
  static var textMuted: Color { current.onSurfaceMuted }
  static var prayerCurrent: Color { current.prayerCurrentFill }
  static var prayerCurrentText: Color { current.prayerCurrentText }
  static var prayerNext: Color { current.prayerNextFill }
  static var prayerNextText: Color { current.prayerNextText }
  static var cautionText: Color { current.caution }

  static let outerPadding: CGFloat = 56
  static let sectionSpacing: CGFloat = 28
  static let blockSpacing: CGFloat = 20
  static let railSpacing: CGFloat = 18
  static let columnSpacing: CGFloat = 28
  static let cardRadius: CGFloat = 30
  static let heroRadius: CGFloat = 36
  static let cardPadding: CGFloat = 28
  static let heroPadding: CGFloat = 40
  static let focusScale: CGFloat = 1.045
  /// Room a rail leaves at its edges so the focused card can grow into it
  /// without being cut by the scroll view.
  static let railBleed: CGFloat = 16
  static let focusShadowRadius: CGFloat = 22
}
