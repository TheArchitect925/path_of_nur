import SwiftUI

/// The outline a focused control is drawn in.
enum TVFocusShape {
  case card
  case rounded(CGFloat)
  case capsule

  func path(in size: CGSize) -> RoundedRectangle {
    switch self {
    case .card:
      return RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
    case .rounded(let radius):
      return RoundedRectangle(cornerRadius: radius, style: .continuous)
    case .capsule:
      return RoundedRectangle(cornerRadius: size.height / 2, style: .continuous)
    }
  }
}

private struct TVFocusRing: ViewModifier {
  let isFocused: Bool
  let shape: TVFocusShape

  func body(content: Content) -> some View {
    // The ring goes on before the scale, so it grows with the card it
    // outlines instead of staying behind at the resting size.
    content
      .brightness(isFocused ? 0.012 : 0)
      .overlay(
        GeometryReader { proxy in
          shape.path(in: proxy.size)
            .stroke(
              isFocused ? TVTheme.focus : .clear,
              lineWidth: isFocused ? 4 : 0
            )
        }
      )
      .scaleEffect(isFocused ? TVTheme.focusScale : 1.0)
      .shadow(
        color: isFocused ? TVTheme.focus.opacity(0.18) : .clear,
        radius: TVTheme.focusShadowRadius,
        x: 0,
        y: 12
      )
      .animation(.easeOut(duration: 0.18), value: isFocused)
  }
}

private struct TVInsideCardButtonKey: EnvironmentKey {
  static let defaultValue = false
}

extension EnvironmentValues {
  /// True inside a `TVCardButtonStyle` label. The button holds the focus and
  /// draws the ring, so a card inside it must not take a focus of its own.
  var tvInsideCardButton: Bool {
    get { self[TVInsideCardButtonKey.self] }
    set { self[TVInsideCardButtonKey.self] = newValue }
  }
}

/// The style for every button that wraps a card or a chip.
///
/// The system's plain style lays a pale platter behind a focused button,
/// which sits behind our rounded cards as a white rectangle. This style
/// draws the same gold ring a focusable card draws and nothing else.
struct TVCardButtonStyle: ButtonStyle {
  var shape: TVFocusShape = .card

  func makeBody(configuration: Configuration) -> some View {
    TVCardButtonBody(configuration: configuration, shape: shape)
  }
}

private struct TVCardButtonBody: View {
  let configuration: ButtonStyle.Configuration
  let shape: TVFocusShape
  @Environment(\.isFocused) private var isFocused

  var body: some View {
    configuration.label
      .environment(\.tvInsideCardButton, true)
      .modifier(TVFocusRing(isFocused: isFocused, shape: shape))
      .opacity(configuration.isPressed ? 0.86 : 1)
  }
}

private struct TVFocusableCardModifier: ViewModifier {
  @Environment(\.tvInsideCardButton) private var isInsideButton
  @FocusState private var isFocused: Bool

  func body(content: Content) -> some View {
    if isInsideButton {
      content
    } else {
      content
        .focusable(true)
        .focused($isFocused)
        .accessibilityAddTraits(isFocused ? [.isSelected] : [])
        .modifier(TVFocusRing(isFocused: isFocused, shape: .card))
    }
  }
}

/// What every scrolling row wears, outside its scroll view. Inside, the
/// content is padded by `TVTheme.railBleed`; here the row takes that room
/// back from the page, so cards line up with the headings above them.
///
/// A scroll view cuts what it holds at its own edge, and a card's shadow
/// reaches further than any margin worth leaving. Cut square, the shadows
/// of a row show as the outline of a box around it. So the row's edges are
/// feathered: shadows, and cards on their way out, fade instead of stopping.
private struct TVRail: ViewModifier {
  func body(content: Content) -> some View {
    content
      .mask(TVRailFeather(axis: .horizontal))
      .mask(TVRailFeather(axis: .vertical))
      .padding(.horizontal, -TVTheme.railBleed)
      .padding(.vertical, TVTheme.railGap - TVTheme.railBleed)
  }
}

private struct TVRailFeather: View {
  let axis: Axis

  var body: some View {
    GeometryReader { proxy in
      let length = axis == .horizontal ? proxy.size.width : proxy.size.height
      let edge = min(TVTheme.railFeather / max(length, 1), 0.5)
      LinearGradient(
        stops: [
          .init(color: .clear, location: 0),
          .init(color: .black, location: edge),
          .init(color: .black, location: 1 - edge),
          .init(color: .clear, location: 1),
        ],
        startPoint: axis == .horizontal ? .leading : .top,
        endPoint: axis == .horizontal ? .trailing : .bottom
      )
    }
  }
}

extension View {
  func tvFocusableCard() -> some View {
    modifier(TVFocusableCardModifier())
  }

  func tvRail() -> some View {
    modifier(TVRail())
  }
}
