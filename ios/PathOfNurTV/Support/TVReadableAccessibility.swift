import SwiftUI

/// Urdu is set in Nastaliq, which hangs well below its baseline and climbs
/// well above it. Two such lines stacked at Latin spacing run into each other,
/// so in Urdu every line is given room of its own.
private enum TVScript {
  static let isNastaliq = Locale.current.languageCode == "ur"
}

extension View {
  func tvReadableTitle() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.82)
      .lineSpacing(TVScript.isNastaliq ? 10 : 2)
      .padding(.vertical, TVScript.isNastaliq ? 6 : 0)
  }

  func tvReadableBody() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.88)
      .lineSpacing(TVScript.isNastaliq ? 9 : 3)
      .padding(.vertical, TVScript.isNastaliq ? 4 : 0)
  }

  func tvReadableArabic() -> some View {
    self
      .allowsTightening(true)
      .minimumScaleFactor(0.90)
      .lineSpacing(8)
  }
}

/// Arabic begins at the right of its card whichever way the interface reads.
/// In a left-to-right interface that is the trailing edge; in Arabic and Urdu
/// the interface is already turned, and it is the leading one.
private struct TVArabicLine: ViewModifier {
  @Environment(\.layoutDirection) private var layoutDirection

  func body(content: Content) -> some View {
    let isTurned = layoutDirection == .rightToLeft
    return content
      .multilineTextAlignment(isTurned ? .leading : .trailing)
      .frame(maxWidth: .infinity, alignment: isTurned ? .leading : .trailing)
  }
}

extension View {
  func tvArabicLine() -> some View {
    modifier(TVArabicLine())
  }

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
