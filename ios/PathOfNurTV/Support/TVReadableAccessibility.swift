import SwiftUI

extension View {
  func tvReadableTitle() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.82)
      .lineSpacing(2)
  }

  func tvReadableBody() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.88)
      .lineSpacing(3)
  }

  func tvReadableArabic() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.90)
      .lineSpacing(8)
  }
}

extension View {
  func tvCombinedAccessibility(
    label: String? = nil,
    hint: String? = nil,
    value: String? = nil
  ) -> some View {
    self
      .accessibilityElement(children: .combine)
      .modifier(
        TVAccessibilityMetadataModifier(
          label: label,
          hint: hint,
          value: value
        )
      )
  }
}

private struct TVAccessibilityMetadataModifier: ViewModifier {
  let label: String?
  let hint: String?
  let value: String?

  func body(content: Content) -> some View {
    var view = AnyView(content)
    if let label {
      view = AnyView(view.accessibilityLabel(Text(label)))
    }
    if let hint {
      view = AnyView(view.accessibilityHint(Text(hint)))
    }
    if let value {
      view = AnyView(view.accessibilityValue(Text(value)))
    }
    return view
  }
}
