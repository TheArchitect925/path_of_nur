import SwiftUI

/// The living-room atmosphere: SwiftUI ports of the phone's painted skies
/// (`lib/shared/widgets/night_sky.dart` and the Noor Glass living-sky
/// gradients). Every painting is static and deterministic — the room never
/// shimmers.
struct TVBackgroundView: View {
  @EnvironmentObject private var theme: TVThemeController

  var body: some View {
    // The painters place sky furniture in exact screen fractions, so the
    // atmosphere is pinned to explicit full-screen geometry rather than
    // letting the canvases negotiate their own size.
    GeometryReader { geo in
      ZStack {
        switch theme.palette.id {
        case TVPalette.midnight.id:
          TVMidnightSkyBackground()
        case TVPalette.candlelight.id:
          TVCandlelightBackground()
        case TVPalette.jummah.id:
          TVJummahBackground()
        case TVPalette.ramadan.id:
          TVRamadanBackground()
        case TVPalette.laylatAlQadr.id:
          TVQadrBackground()
        default:
          TVNoorGlassBackground(phase: theme.skyPhase)
        }
      }
      .frame(width: geo.size.width, height: geo.size.height)
      .clipped()
    }
    .ignoresSafeArea()
  }
}

// MARK: - The open margin

/// The rail takes one side of the screen and the cards take the middle, so
/// the moon, the lantern and a band of stars live in the margin that is left.
/// In Arabic and Urdu the rail is on the right and the open margin is on the
/// left: the furniture crosses over, and only its position. The moon is not
/// mirrored, because its lit side is the sky's and not the interface's.
private enum TVSkyMargin {
  static func x(_ fraction: CGFloat, in direction: LayoutDirection) -> CGFloat {
    direction == .rightToLeft ? 1 - fraction : fraction
  }
}

// MARK: - Noor Glass daytime skies

/// The painted daytime skies from the approved Noor Glass OS board
/// (`noorSkyGradientFor`); night is carried by Midnight, never by this view.
private struct TVNoorGlassBackground: View {
  let phase: TVSkyPhase

  private var skyColors: [Color] {
    switch phase {
    case .dawn:
      return [Color(hex: 0xF6E0CE), Color(hex: 0xF3EBDD), Color(hex: 0xEFE7D6)]
    case .maghrib:
      return [Color(hex: 0xEFC08A), Color(hex: 0xF2E3CB), Color(hex: 0xEDE3D0)]
    case .day, .night:
      return [Color(hex: 0xF8F4EA), Color(hex: 0xF1EADA)]
    }
  }

  var body: some View {
    ZStack {
      LinearGradient(
        colors: skyColors,
        startPoint: .top,
        endPoint: .bottom
      )

      Circle()
        .fill(TVTheme.accentSoft.opacity(0.22))
        .frame(width: 560, height: 560)
        .blur(radius: 100)
        .offset(x: 420, y: -260)

      Circle()
        .fill(TVTheme.accentStrong.opacity(0.10))
        .frame(width: 420, height: 420)
        .blur(radius: 96)
        .offset(x: -520, y: 280)
    }
  }
}

// MARK: - Midnight

private struct TVMidnightSkyBackground: View {
  var body: some View {
    ZStack {
      RadialGradient(
        colors: [Color(hex: 0x232A44), Color(hex: 0x1A1F33), Color(hex: 0x121423)],
        center: UnitPoint(x: 0.5, y: 0.08),
        startRadius: 0,
        endRadius: 1400
      )
      TVStarFieldCanvas()
      TVMoonCanvas(
        moonFraction: CGPoint(x: 0.9535, y: 0.10),
        shadowColor: Color(hex: 0x2C3352)
      )
    }
  }
}

// MARK: - Candlelight

private struct TVCandlelightBackground: View {
  var body: some View {
    ZStack {
      RadialGradient(
        colors: [Color(hex: 0x241C12), Color(hex: 0x1D1610), Color(hex: 0x15100B)],
        center: UnitPoint(x: 0.5, y: 0.22),
        startRadius: 0,
        endRadius: 1500
      )
      // The candle-glow crown at the top of the room.
      RadialGradient(
        colors: [Color(hex: 0xC48A3A).opacity(0.30), .clear],
        center: UnitPoint(x: 0.5, y: -0.35),
        startRadius: 0,
        endRadius: 900
      )
    }
  }
}

// MARK: - Jumu'ah

private struct TVJummahBackground: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: 0x16382C), Color(hex: 0x0D271E)],
        startPoint: .top,
        endPoint: .bottom
      )
      TVMihrabArchCanvas(glowColor: Color(hex: 0xDCC07A))
    }
  }
}

// MARK: - Ramadan

private struct TVRamadanBackground: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: 0x211A38), Color(hex: 0x151024)],
        startPoint: .top,
        endPoint: .bottom
      )
      TVStarFieldCanvas()
      TVMoonCanvas(
        moonFraction: CGPoint(x: 0.9535, y: 0.32),
        shadowColor: Color(hex: 0x3A3162)
      )
      TVFanoosCanvas()
    }
  }
}

// MARK: - Laylat al-Qadr

private struct TVQadrBackground: View {
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(hex: 0x191330), Color(hex: 0x0E0A1D)],
        startPoint: .top,
        endPoint: .bottom
      )
      TVStarFieldCanvas()
      TVQadrDescentCanvas()
      TVMoonCanvas(
        moonFraction: CGPoint(x: 0.9535, y: 0.10),
        shadowColor: Color(hex: 0x2E2650)
      )
    }
  }
}

// MARK: - Star field

/// Softly glowing stars kept to the top and bottom bands where no content
/// sits. Deterministic layout (fixed-seed LCG) so frames never shimmer.
private struct TVStarFieldCanvas: View {
  @Environment(\.layoutDirection) private var layoutDirection

  var body: some View {
    Canvas { context, size in
      var seed: UInt64 = 19
      func nextRandom() -> Double {
        seed = (seed &* 1103515245 &+ 12345) & 0x7fffffff
        return Double(seed) / Double(0x7fffffff)
      }

      struct Star {
        let center: CGPoint
        let radius: CGFloat
        let alpha: Double
        let bright: Bool
      }

      // The TV's card grid covers most of the screen, so the stars live in
      // the exposed sky bands: the strip above the content, the open margin
      // beside it, and the strip below.
      var stars: [Star] = []
      for index in 0..<64 {
        let band = nextRandom()
        let x: Double
        let y: Double
        if band < 0.55 {
          x = nextRandom() * size.width
          y = nextRandom() * size.height * 0.07
        } else if band < 0.85 {
          x = size.width * TVSkyMargin.x(0.932 + nextRandom() * 0.06, in: layoutDirection)
          y = nextRandom() * size.height * 0.62
        } else {
          x = nextRandom() * size.width
          y = size.height * (0.945 + nextRandom() * 0.05)
        }
        let radius = 1.0 + nextRandom() * 1.4
        let alpha = 0.18 + nextRandom() * 0.5
        stars.append(
          Star(
            center: CGPoint(x: x, y: y),
            radius: radius,
            alpha: alpha,
            bright: index % 7 == 0
          )
        )
      }

      let starColor = Color(hex: 0xFFF4D6)

      context.drawLayer { layer in
        layer.addFilter(.blur(radius: 4))
        for star in stars {
          let r = star.radius * (star.bright ? 3.2 : 2.4)
          layer.fill(
            Path(ellipseIn: CGRect(
              x: star.center.x - r, y: star.center.y - r,
              width: r * 2, height: r * 2
            )),
            with: .color(starColor.opacity(star.alpha * (star.bright ? 0.55 : 0.38)))
          )
        }
      }

      for star in stars {
        let r = star.radius * (star.bright ? 1.2 : 1.0)
        let alpha = star.bright ? min(star.alpha + 0.25, 1.0) : star.alpha
        context.fill(
          Path(ellipseIn: CGRect(
            x: star.center.x - r, y: star.center.y - r,
            width: r * 2, height: r * 2
          )),
          with: .color(starColor.opacity(alpha))
        )
      }
    }
    .allowsHitTesting(false)
  }
}

// MARK: - Moon

/// The moon whose lit shape tracks the real lunar phase (waxing lights the
/// right limb, waning the left) — a port of `MidnightSkyPainter._paintMoon`.
private struct TVMoonCanvas: View {
  let moonFraction: CGPoint
  let shadowColor: Color
  @Environment(\.layoutDirection) private var layoutDirection

  private static let synodicMonthDays = 29.53058867
  private static let litColor = Color(hex: 0xEDE5CE)
  private static let starColor = Color(hex: 0xFFF4D6)

  var body: some View {
    Canvas { context, size in
      let now = Date()
      let r = min(size.width, size.height) * 0.045
      let center = CGPoint(
        x: size.width * TVSkyMargin.x(moonFraction.x, in: layoutDirection),
        y: size.height * moonFraction.y
      )
      let age = Self.moonAgeDays(now)
      let phase = age / Self.synodicMonthDays
      let illuminated = (1 - cos((2 * .pi * age) / Self.synodicMonthDays)) / 2

      if illuminated > 0.02 {
        context.drawLayer { layer in
          layer.addFilter(.blur(radius: r * 1.1))
          let glowR = r * 1.35
          layer.fill(
            Path(ellipseIn: CGRect(
              x: center.x - glowR, y: center.y - glowR,
              width: glowR * 2, height: glowR * 2
            )),
            with: .color(Self.litColor.opacity(0.10 + 0.16 * illuminated))
          )
        }
      }

      // Unlit body, faintly separated from the sky.
      let disc = Path(ellipseIn: CGRect(
        x: center.x - r, y: center.y - r, width: r * 2, height: r * 2
      ))
      context.fill(disc, with: .color(shadowColor))
      context.stroke(
        disc,
        with: .color(Self.starColor.opacity(0.12)),
        lineWidth: 1
      )

      guard illuminated > 0.008 else { return }

      // Lit region: near-limb semicircle plus a half-ellipse terminator
      // whose signed half-width follows cos(2π·phase). Both curves are
      // built parametrically to keep the geometry identical to the phone.
      let terminator = r * CGFloat(cos(2 * .pi * phase))
      let waxing = phase < 0.5
      var lit = Path()
      lit.move(to: CGPoint(x: 0, y: -r))
      let steps = 48
      for i in 1...steps {
        let theta = -CGFloat.pi / 2 + .pi * CGFloat(i) / CGFloat(steps)
        lit.addLine(to: CGPoint(x: r * cos(theta), y: r * sin(theta)))
      }
      if abs(terminator) < r * 0.02 {
        lit.addLine(to: CGPoint(x: 0, y: -r))
      } else {
        // From (0, r) back to (0, -r): bulge toward the lit limb while a
        // crescent (terminator > 0), away from it once gibbous.
        let direction: CGFloat = terminator > 0 ? -1 : 1
        for i in 1...steps {
          let theta = CGFloat.pi / 2 + direction * .pi * CGFloat(i) / CGFloat(steps)
          lit.addLine(to: CGPoint(
            x: abs(terminator) * cos(theta),
            y: r * sin(theta)
          ))
        }
      }
      lit.closeSubpath()

      var transform = CGAffineTransform(translationX: center.x, y: center.y)
      if !waxing {
        transform = transform.scaledBy(x: -1, y: 1)
      }
      context.fill(
        lit.applying(transform),
        with: .color(Self.litColor.opacity(0.95))
      )
    }
    .allowsHitTesting(false)
  }

  /// Age of the moon in days (0 = new moon), same epoch as the phone.
  private static func moonAgeDays(_ date: Date) -> Double {
    let normalized = Calendar.current.startOfDay(for: date)
    var epochComponents = DateComponents()
    epochComponents.year = 2000
    epochComponents.month = 1
    epochComponents.day = 6
    epochComponents.timeZone = TimeZone(identifier: "UTC")
    var utcCalendar = Calendar(identifier: .gregorian)
    utcCalendar.timeZone = TimeZone(identifier: "UTC")!
    guard let epoch = utcCalendar.date(from: epochComponents) else { return 0 }
    let days = normalized.timeIntervalSince(epoch) / 3600 / 24
    let age = days.truncatingRemainder(dividingBy: synodicMonthDays)
    return age < 0 ? age + synodicMonthDays : age
  }
}

// MARK: - Mihrab arch

/// The golden mihrab arch that crowns Masjid Emerald: a fine arch outline
/// fading toward its base, with a soft gold radiance inside the crown.
private struct TVMihrabArchCanvas: View {
  let glowColor: Color

  var body: some View {
    Canvas { context, size in
      let archWidth = size.width * 0.58
      let left = (size.width - archWidth) / 2
      let topY = -size.height * 0.03
      let crownHeight = archWidth * 0.92
      let baseY = size.height * 0.44
      let crownCenter = CGPoint(x: left + archWidth / 2, y: topY + crownHeight / 2)
      let radiusX = archWidth / 2
      let radiusY = crownHeight / 2

      // Radiance inside the crown.
      context.fill(
        Path(CGRect(x: left, y: 0, width: archWidth, height: baseY)),
        with: .radialGradient(
          Gradient(colors: [glowColor.opacity(0.16), glowColor.opacity(0)]),
          center: CGPoint(x: crownCenter.x, y: topY + crownHeight * 0.3),
          startRadius: 0,
          endRadius: archWidth * 0.62
        )
      )

      // Arch outline: sides plus the crown's elliptical top, built
      // parametrically, stroked with a fade toward the base.
      var arch = Path()
      arch.move(to: CGPoint(x: left, y: baseY))
      arch.addLine(to: CGPoint(x: left, y: crownCenter.y))
      let steps = 64
      for i in 1...steps {
        let theta = CGFloat.pi + .pi * CGFloat(i) / CGFloat(steps)
        arch.addLine(to: CGPoint(
          x: crownCenter.x + radiusX * cos(theta),
          y: crownCenter.y + radiusY * sin(theta)
        ))
      }
      arch.addLine(to: CGPoint(x: left + archWidth, y: baseY))

      context.stroke(
        arch,
        with: .linearGradient(
          Gradient(colors: [glowColor.opacity(0.42), glowColor.opacity(0)]),
          startPoint: CGPoint(x: crownCenter.x, y: topY),
          endPoint: CGPoint(x: crownCenter.x, y: baseY)
        ),
        lineWidth: 2
      )
    }
    .allowsHitTesting(false)
  }
}

// MARK: - Fanoos lantern

/// The Ramadan fanoos hanging from the top of the screen, its glow warming
/// as iftar draws near (same hour buckets as the phone).
private struct TVFanoosCanvas: View {
  @Environment(\.layoutDirection) private var layoutDirection

  var body: some View {
    Canvas { context, size in
      let glowStrength = Self.glowStrength(Date())
      let x = size.width * TVSkyMargin.x(0.9535, in: layoutDirection)
      let unit = size.width * 0.032
      let cordEnd = size.height * 0.052
      let bodyTop = cordEnd + unit * 0.16
      let bodyRect = CGRect(
        x: x - unit * 0.39,
        y: bodyTop + unit * 0.62 - unit * 0.62,
        width: unit * 0.78,
        height: unit * 1.24
      )
      let bodyCenter = CGPoint(x: bodyRect.midX, y: bodyRect.midY)

      // Glow — scales with iftar proximity.
      let glowAlpha = 0.18 + 0.30 * glowStrength
      context.drawLayer { layer in
        layer.addFilter(.blur(radius: unit * 0.9))
        let glowR = unit * (1.4 + glowStrength * 0.7)
        layer.fill(
          Path(ellipseIn: CGRect(
            x: bodyCenter.x - glowR, y: bodyCenter.y - glowR,
            width: glowR * 2, height: glowR * 2
          )),
          with: .color(Color(hex: 0xE9BE7B).opacity(glowAlpha))
        )
      }

      // Cord.
      var cord = Path()
      cord.move(to: CGPoint(x: x, y: 0))
      cord.addLine(to: CGPoint(x: x, y: cordEnd))
      context.stroke(
        cord,
        with: .color(Color(hex: 0xF0E9DA).opacity(0.38)),
        lineWidth: 1.6
      )

      // Cap.
      context.fill(
        Path(
          roundedRect: CGRect(
            x: x - unit * 0.21,
            y: cordEnd + unit * 0.08 - unit * 0.08,
            width: unit * 0.42,
            height: unit * 0.16
          ),
          cornerRadius: unit * 0.06
        ),
        with: .color(Color(hex: 0x8E6A34))
      )

      // Body.
      context.fill(
        Path(roundedRect: bodyRect, cornerRadius: unit * 0.24),
        with: .linearGradient(
          Gradient(colors: [
            Color(hex: 0xE9BE7B),
            Color(hex: 0xD9A254),
            Color(hex: 0xB97F35),
          ]),
          startPoint: CGPoint(x: bodyRect.midX, y: bodyRect.minY),
          endPoint: CGPoint(x: bodyRect.midX, y: bodyRect.maxY)
        )
      )

      // Inner flame panel.
      let flameRect = bodyRect.insetBy(dx: unit * 0.14, dy: unit * 0.14)
      context.fill(
        Path(roundedRect: flameRect, cornerRadius: unit * 0.12),
        with: .color(Color(hex: 0xFFECBE).opacity(0.72 + 0.24 * glowStrength))
      )
    }
    .allowsHitTesting(false)
  }

  /// Mirror of `fanoosGlowStrengthFor`: soft through the day, brightening
  /// toward iftar, warm through taraweeh evenings.
  private static func glowStrength(_ now: Date) -> Double {
    let hour = Calendar.current.component(.hour, from: now)
    if hour >= 16 && hour < 20 { return 1.0 }
    if hour >= 12 && hour < 16 { return 0.55 }
    if hour >= 20 || hour < 2 { return 0.7 }
    return 0.35
  }
}

// MARK: - Laylat al-Qadr descent

/// A soft column of light descending from the top of the sky over a denser
/// star field — "peace it is, until the emergence of dawn".
private struct TVQadrDescentCanvas: View {
  var body: some View {
    Canvas { context, size in
      let lightColor = Color(hex: 0xF5E9C8)
      let starColor = Color(hex: 0xFFF4D6)

      let beamTopHalf = size.width * 0.055
      let beamBottomHalf = size.width * 0.24
      let beamBottom = size.height * 0.42
      let cx = size.width * 0.5
      var beam = Path()
      beam.move(to: CGPoint(x: cx - beamTopHalf, y: 0))
      beam.addLine(to: CGPoint(x: cx + beamTopHalf, y: 0))
      beam.addLine(to: CGPoint(x: cx + beamBottomHalf, y: beamBottom))
      beam.addLine(to: CGPoint(x: cx - beamBottomHalf, y: beamBottom))
      beam.closeSubpath()

      context.drawLayer { layer in
        layer.addFilter(.blur(radius: size.width * 0.045))
        layer.fill(
          beam,
          with: .linearGradient(
            Gradient(stops: [
              .init(color: lightColor.opacity(0.16), location: 0),
              .init(color: lightColor.opacity(0.05), location: 0.55),
              .init(color: .clear, location: 1),
            ]),
            startPoint: CGPoint(x: cx, y: 0),
            endPoint: CGPoint(x: cx, y: beamBottom)
          )
        )
      }

      // Extra stars, denser than the base field, across the upper sky.
      var seed: UInt64 = 47
      func nextRandom() -> Double {
        seed = (seed &* 1103515245 &+ 12345) & 0x7fffffff
        return Double(seed) / Double(0x7fffffff)
      }
      for _ in 0..<46 {
        let x = nextRandom() * size.width
        let y = nextRandom() * size.height * 0.40
        let r = 0.8 + nextRandom() * 1.6
        let alpha = 0.28 + nextRandom() * 0.45
        context.fill(
          Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2)),
          with: .color(starColor.opacity(alpha))
        )
      }
    }
    .allowsHitTesting(false)
  }
}
