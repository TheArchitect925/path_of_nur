import SwiftUI

private struct TVFocusableCardModifier: ViewModifier {
  @FocusState private var isFocused: Bool

  func body(content: Content) -> some View {
    content
      .focusable(true)
      .focused($isFocused)
      .scaleEffect(isFocused ? TVTheme.focusScale : 1.0)
      .overlay(
        RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
          .stroke(isFocused ? TVTheme.focus : .clear, lineWidth: 4)
      )
      .shadow(
        color: isFocused ? TVTheme.focus.opacity(0.18) : .clear,
        radius: 18
      )
      .animation(.easeOut(duration: 0.18), value: isFocused)
  }
}

extension View {
  func tvFocusableCard() -> some View {
    modifier(TVFocusableCardModifier())
  }
}
