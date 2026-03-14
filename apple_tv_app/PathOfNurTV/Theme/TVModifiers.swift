import SwiftUI

struct TVFocusableCardModifier: ViewModifier {
    @FocusState private var isFocused: Bool

    func body(content: Content) -> some View {
        content
            .focusable(true)
            .focused($isFocused)
            .scaleEffect(isFocused ? TVTheme.focusScale : 1.0)
            .shadow(color: isFocused ? TVTheme.focus.opacity(0.45) : .clear, radius: 22)
            .overlay(
                RoundedRectangle(cornerRadius: TVTheme.cardRadius)
                    .stroke(isFocused ? TVTheme.focus : .clear, lineWidth: 2.5)
            )
            .animation(.easeOut(duration: 0.18), value: isFocused)
    }
}

extension View {
    func tvFocusableCard() -> some View {
        modifier(TVFocusableCardModifier())
    }
}
