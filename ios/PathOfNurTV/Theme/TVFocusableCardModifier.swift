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

/// A pane is the rail turned on its side, with two differences.
///
/// A rail is a row in a page and takes its room back from the page above
/// and below. A pane stands under a heading, so it reaches past its own
/// edges only as far as the feather: what fades, fades in the space between
/// the pane and the heading, and what is wholly inside the pane is wholly
/// seen.
///
/// And a pane that fills the screen's height stops short of the screen's
/// own margin below. A scroll view whose edge meets that margin is given
/// the margin too: it grows to the bottom of the screen, and what takes the
/// focus is then centred in a room taller than the one that is seen.
private struct TVPane: ViewModifier {
  func body(content: Content) -> some View {
    content
      .mask(TVRailFeather(axis: .horizontal))
      .mask(TVRailFeather(axis: .vertical))
      .padding(.horizontal, -TVTheme.railBleed)
      .padding(.top, -TVTheme.railFeather)
      .padding(.bottom, -(TVTheme.railFeather - TVTheme.railGap))
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

  /// What a pane that scrolls up and down wears, outside its scroll view:
  /// the rail's feathered edges on a list that fills the height it is given.
  /// Inside, the content is padded by `TVTheme.railBleed` on every side.
  func tvPane() -> some View {
    modifier(TVPane())
  }

  /// Where the focus lands when the viewer moves into this part of the
  /// screen, in place of whatever is nearest. Before tvOS 17 the system does
  /// not take a preference for a move the viewer makes, and nearest it is.
  func tvPreferredFocus<Value: Hashable>(
    _ focus: FocusState<Value?>.Binding,
    _ value: Value?
  ) -> some View {
    modifier(TVPreferredFocus(focus: focus, value: value))
  }

  /// Gives a control its place in the focus order, and the same name to
  /// anything that looks for it by name: VoiceOver's rotor, a UI test.
  func tvFocusID(_ focus: FocusState<String?>.Binding, _ id: String) -> some View {
    focused(focus, equals: id)
      .accessibilityIdentifier(id)
  }
}

/// Asks for the focus until it lands.
///
/// A control cannot take the focus before it is on screen: a row of a lazy
/// list has to be scrolled to and built, a screen has to have appeared. A
/// lazy list places a far row by estimate, so one scroll may stop short of
/// it, and each scroll after measures more rows and stops nearer. And while
/// a list scrolls, the row that had the focus is taken away, which leaves
/// the system to put the focus on whatever is near.
///
/// So the target is brought into view and the focus asked for, again and
/// again until the focus rests on it, for two seconds at most. A later
/// request takes the place of an earlier one.
final class TVFocusSeeker {
  /// The control the focus is on its way to, until it lands.
  private(set) var pending: String?

  /// - Parameter bringIntoView: scrolls to the target, if it may be out of
  ///   view. Called before the first ask, and again while the focus has not
  ///   landed.
  func seek(
    _ target: String,
    with focus: FocusState<String?>.Binding,
    bringIntoView: (() -> Void)? = nil
  ) {
    pending = target
    bringIntoView?()
    ask(for: target, with: focus, attempt: 1, bringIntoView: bringIntoView)
  }

  private func ask(
    for target: String,
    with focus: FocusState<String?>.Binding,
    attempt: Int,
    bringIntoView: (() -> Void)?
  ) {
    DispatchQueue.main.asyncAfter(deadline: .now() + (attempt == 1 ? 0.05 : 0.15)) { [weak self] in
      guard let self, self.pending == target else { return }
      if focus.wrappedValue == target || attempt > 14 {
        self.pending = nil
        return
      }
      focus.wrappedValue = target
      // Asked and not given: on the next turn it is asked again, and on
      // the turn after that the list is scrolled again first.
      if attempt.isMultiple(of: 2) {
        DispatchQueue.main.async {
          guard self.pending == target, focus.wrappedValue != target else { return }
          bringIntoView?()
        }
      }
      self.ask(for: target, with: focus, attempt: attempt + 1, bringIntoView: bringIntoView)
    }
  }
}

private struct TVPreferredFocus<Value: Hashable>: ViewModifier {
  let focus: FocusState<Value?>.Binding
  let value: Value?

  func body(content: Content) -> some View {
    if #available(tvOS 17.0, *) {
      content.defaultFocus(focus, value, priority: .userInitiated)
    } else {
      content
    }
  }
}
