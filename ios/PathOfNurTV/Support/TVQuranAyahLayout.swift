#if canImport(UIKit)
import UIKit
private typealias TVPlatformFont = UIFont
#else
// The Mac, where scripts/verify_tv_quran_library.sh runs the planner over
// every ayah.
import AppKit
private typealias TVPlatformFont = NSFont
#endif

/// The type an ayah is set in, and the room it is given.
struct TVQuranAyahMetrics: Hashable {
  var arabicSize: CGFloat = 34
  var transliterationSize: CGFloat = 18
  var translationSize: CGFloat = 20
  /// The width the text itself is given, inside the card's padding.
  var textWidth: CGFloat
  /// The width of the reading and the meaning, where it is not the Arabic's.
  var bodyWidth: CGFloat?
  /// The tallest a card may stand, its padding and heading included.
  var maxHeight: CGFloat
  /// What the card puts around the text: its padding and its heading line.
  var chrome: CGFloat = TVQuranAyahMetrics.cardChrome
  /// The space between the texts of one card.
  var gap: CGFloat = TVQuranAyahMetrics.cardSpacing

  // The measures of TVQuranAyahCard, kept here so the planner can be run
  // without the views.
  static let cardPadding: CGFloat = 24
  static let cardSpacing: CGFloat = 14
  static let headingHeight: CGFloat = 20
  static let cardChrome = cardPadding * 2 + headingHeight + cardSpacing
  /// What is kept between the tallest part and its room. The measure here
  /// and the height on screen have been found to differ by four points at
  /// most; this is three times that.
  static let margin: CGFloat = 12

  /// The tallest a card that takes the focus may stand in a room `height`
  /// tall that keeps `inset` clear at its top and bottom.
  static func tallestPart(inRoom height: CGFloat, inset: CGFloat, focusScale: CGFloat) -> CGFloat {
    max((height - inset * 2) / focusScale - margin, 240).rounded(.down)
  }

  /// How the reader sets an ayah. `pane` is the room its ayahs are read in,
  /// as wide as a card, `inset` what that room keeps clear at its top and
  /// bottom for the focused card to grow into, and `focusScale` how much it
  /// grows. No part is taller than what is left, so none runs below the pane
  /// where it cannot be reached.
  static func reader(
    pane: CGSize,
    inset: CGFloat,
    focusScale: CGFloat,
    language: String
  ) -> TVQuranAyahMetrics {
    TVQuranAyahMetrics(
      textWidth: max(pane.width - cardPadding * 2, 200).rounded(.down),
      maxHeight: tallestPart(inRoom: pane.height, inset: inset, focusScale: focusScale),
      translationLineSpacing: translationLineSpacing(forLanguage: language)
    )
  }

  /// The space between the lines of the meaning, which is wider where the
  /// meaning is in Urdu.
  var translationLineSpacing: CGFloat = TVQuranAyahMetrics.bodyLineSpacing

  var bodyTextWidth: CGFloat { bodyWidth ?? textWidth }

  // The line spacing of tvReadableArabic() and tvReadableBody().
  static let arabicLineSpacing: CGFloat = 8
  static let bodyLineSpacing: CGFloat = 3

  /// Urdu is set in Nastaliq, which hangs well below its baseline and climbs
  /// well above it: at Latin spacing its lines run into each other.
  static func translationLineSpacing(forLanguage language: String) -> CGFloat {
    language == "ur" ? 14 : bodyLineSpacing
  }
}

/// Sets an ayah in parts that each fit the room they are read in.
///
/// The television scrolls to what is in focus, and cannot scroll within it:
/// the part of a card that falls below the screen is never seen. So nothing
/// that takes the focus may be taller than the room. An ayah that fits is one
/// card, as it always was. One that does not is divided where it can be read
/// apart: the Arabic, at a pause mark where there is one near, then the
/// reading and the meaning. No word is dropped and none is moved.
final class TVQuranAyahPlanner {
  private var cache: [String: [TVQuranAyahPart]] = [:]
  private var cachedMetrics: TVQuranAyahMetrics?

  func parts(for ayah: TVQuranAyah, metrics: TVQuranAyahMetrics) -> [TVQuranAyahPart] {
    if cachedMetrics != metrics {
      cache.removeAll()
      cachedMetrics = metrics
    }
    if let parts = cache[ayah.id] {
      return parts
    }
    let parts = Self.plan(ayah, metrics: metrics)
    cache[ayah.id] = parts
    return parts
  }

  /// An ayah fitted to a room: as large as the room allows, and in parts
  /// only when the smallest type is still too tall.
  struct Fitted {
    let metrics: TVQuranAyahMetrics
    let parts: [TVQuranAyahPart]

    var isWhole: Bool { parts.count == 1 }
  }

  /// Type sizes: the Arabic, its reading, its meaning.
  typealias Sizes = (arabic: CGFloat, transliteration: CGFloat, translation: CGFloat)

  /// The sizes listening mode tries, largest first. It is read from across
  /// a room, on televisions of every size, so it starts large and comes
  /// down only as far as an ayah needs.
  static let listeningSizes: [Sizes] = [
    (84, 36, 40),
    (72, 34, 38),
    (62, 32, 36),
    (54, 30, 33),
    (47, 28, 31),
    (41, 26, 29),
    (36, 24, 27),
    (32, 23, 25),
  ]
  static let listeningStagePadding: CGFloat = 40
  static let listeningArabicWidth: CGFloat = 1640
  static let listeningBodyWidth: CGFloat = 1480

  /// The sizes Home's verse tries, largest first.
  static let homeSizes: [Sizes] = [
    (40, 18, 20),
    (34, 18, 20),
  ]

  /// Fits an ayah to a room. It is tried whole at each size in turn, in a
  /// room `room` tall with `chrome` around the text. If it is too tall at
  /// every size it is set in parts at the smallest, each no taller than
  /// `partRoom` with `partChrome` around it.
  static func fit(
    _ ayah: TVQuranAyah,
    sizes: [Sizes],
    textWidth: CGFloat,
    bodyWidth: CGFloat,
    room: CGFloat,
    chrome: CGFloat,
    gap: CGFloat,
    partRoom: CGFloat,
    partChrome: CGFloat,
    language: String
  ) -> Fitted {
    func metrics(_ size: Sizes, maxHeight: CGFloat, chrome: CGFloat) -> TVQuranAyahMetrics {
      TVQuranAyahMetrics(
        arabicSize: size.arabic,
        transliterationSize: size.transliteration,
        translationSize: size.translation,
        textWidth: max(textWidth, 200).rounded(.down),
        bodyWidth: max(bodyWidth, 200).rounded(.down),
        maxHeight: maxHeight.rounded(.down),
        chrome: chrome,
        gap: gap,
        translationLineSpacing: TVQuranAyahMetrics.translationLineSpacing(forLanguage: language)
      )
    }

    for size in sizes {
      let whole = metrics(size, maxHeight: room, chrome: chrome)
      if height(of: ayah, metrics: whole) <= whole.maxHeight {
        return Fitted(metrics: whole, parts: plan(ayah, metrics: whole))
      }
    }

    let smallest = sizes[sizes.count - 1]
    let inParts = metrics(smallest, maxHeight: partRoom, chrome: partChrome)
    return Fitted(metrics: inParts, parts: plan(ayah, metrics: inParts))
  }

  /// How listening mode sets an ayah on its stage.
  ///
  /// - Parameter inset: what the stage keeps clear at its top and bottom
  ///   for a focused part to grow into, when the ayah is in parts.
  static func listeningPlan(
    for ayah: TVQuranAyah,
    stage: CGSize,
    inset: CGFloat,
    focusScale: CGFloat,
    language: String
  ) -> Fitted {
    let width = stage.width - listeningStagePadding * 2
    return fit(
      ayah,
      sizes: listeningSizes,
      textWidth: min(width, listeningArabicWidth),
      bodyWidth: min(width, listeningBodyWidth),
      room: stage.height,
      chrome: listeningStagePadding * 2,
      gap: 28,
      partRoom: TVQuranAyahMetrics.tallestPart(
        inRoom: stage.height,
        inset: inset,
        focusScale: focusScale
      ),
      partChrome: TVQuranAyahMetrics.cardChrome,
      language: language
    )
  }

  /// How Home sets the verse of the day in its card. `screen` is the room
  /// Home scrolls in and `textWidth` the width of the card's text. A verse
  /// too long for the screen is shown from its beginning, as much as fits,
  /// and the card says that the rest is in the reader.
  static func homePlan(
    for ayah: TVQuranAyah,
    screen: CGSize,
    textWidth: CGFloat,
    chrome: CGFloat,
    inset: CGFloat,
    focusScale: CGFloat,
    language: String
  ) -> Fitted {
    let room = TVQuranAyahMetrics.tallestPart(
      inRoom: screen.height,
      inset: inset,
      focusScale: focusScale
    )
    return fit(
      ayah,
      sizes: homeSizes,
      textWidth: textWidth,
      bodyWidth: min(textWidth, 1000),
      room: room,
      chrome: chrome,
      gap: TVQuranAyahMetrics.cardSpacing,
      partRoom: room,
      partChrome: chrome,
      language: language
    )
  }

  /// How tall the ayah stands as a single card.
  static func height(of ayah: TVQuranAyah, metrics: TVQuranAyahMetrics) -> CGFloat {
    let setting = Setting(metrics)
    return metrics.chrome + setting.stack([
      setting.arabic(ayah.arabic),
      setting.transliteration(ayah.transliteration),
      setting.translation(ayah.translation),
    ])
  }

  static func plan(_ ayah: TVQuranAyah, metrics: TVQuranAyahMetrics) -> [TVQuranAyahPart] {
    let setting = Setting(metrics)
    let room = max(metrics.maxHeight - metrics.chrome, 1)

    let arabic = setting.arabic(ayah.arabic)
    let transliteration = setting.transliteration(ayah.transliteration)
    let translation = setting.translation(ayah.translation)

    var texts: [(arabic: String, transliteration: String, translation: String)] = []
    if setting.stack([arabic, transliteration, translation]) <= room {
      texts.append((ayah.arabic, ayah.transliteration, ayah.translation))
    } else {
      for piece in setting.pieces(of: ayah.arabic, as: .arabic, room: room) {
        texts.append((piece, "", ""))
      }
      if setting.stack([transliteration, translation]) <= room {
        if !ayah.transliteration.isEmpty || !ayah.translation.isEmpty {
          texts.append(("", ayah.transliteration, ayah.translation))
        }
      } else {
        for piece in setting.pieces(of: ayah.transliteration, as: .transliteration, room: room) {
          texts.append(("", piece, ""))
        }
        for piece in setting.pieces(of: ayah.translation, as: .translation, room: room) {
          texts.append(("", "", piece))
        }
      }
    }

    return texts.enumerated().map { index, text in
      TVQuranAyahPart(
        ayahID: ayah.id,
        ayahNumber: ayah.ayahNumber,
        index: index,
        count: texts.count,
        arabic: text.arabic,
        transliteration: text.transliteration,
        translation: text.translation
      )
    }
  }

  /// Measures text as the cards set it.
  private struct Setting {
    enum Kind {
      case arabic
      case transliteration
      case translation
    }

    let metrics: TVQuranAyahMetrics
    private let arabicFont: TVPlatformFont
    private let transliterationFont: TVPlatformFont
    private let translationFont: TVPlatformFont

    init(_ metrics: TVQuranAyahMetrics) {
      self.metrics = metrics
      arabicFont = TVPlatformFont(name: "AmiriQuran-Regular", size: metrics.arabicSize)
        ?? .systemFont(ofSize: metrics.arabicSize)
      transliterationFont = TVPlatformFont(name: "Figtree-Medium", size: metrics.transliterationSize)
        ?? .systemFont(ofSize: metrics.transliterationSize)
      translationFont = TVPlatformFont(name: "Figtree-Medium", size: metrics.translationSize)
        ?? .systemFont(ofSize: metrics.translationSize)
    }

    func arabic(_ text: String) -> CGFloat { height(of: text, as: .arabic) }
    func transliteration(_ text: String) -> CGFloat { height(of: text, as: .transliteration) }
    func translation(_ text: String) -> CGFloat { height(of: text, as: .translation) }

    /// The height of texts set one under another, the empty ones left out.
    func stack(_ heights: [CGFloat]) -> CGFloat {
      let present = heights.filter { $0 > 0 }
      return present.reduce(0, +) + metrics.gap * CGFloat(max(present.count - 1, 0))
    }

    func height(of text: String, as kind: Kind) -> CGFloat {
      guard !text.isEmpty else { return 0 }
      let style = NSMutableParagraphStyle()
      let font: TVPlatformFont
      switch kind {
      case .arabic:
        font = arabicFont
        style.lineSpacing = TVQuranAyahMetrics.arabicLineSpacing
        style.baseWritingDirection = .rightToLeft
      case .transliteration:
        font = transliterationFont
        style.lineSpacing = TVQuranAyahMetrics.bodyLineSpacing
      case .translation:
        font = translationFont
        style.lineSpacing = metrics.translationLineSpacing
      }
      let width = kind == .arabic ? metrics.textWidth : metrics.bodyTextWidth
      let bounds = (text as NSString).boundingRect(
        with: CGSize(width: width, height: .greatestFiniteMagnitude),
        options: [.usesLineFragmentOrigin, .usesFontLeading],
        attributes: [.font: font, .paragraphStyle: style],
        context: nil
      )
      return ceil(bounds.height)
    }

    /// The text in as few pieces as fit the room, each a run of whole words
    /// in the order they were written.
    func pieces(of text: String, as kind: Kind, room: CGFloat) -> [String] {
      guard !text.isEmpty else { return [] }
      let whole = height(of: text, as: kind)
      let words = text.split(separator: " ", omittingEmptySubsequences: false)
      guard whole > room, words.count > 1 else { return [text] }

      var count = max(2, Int((whole / room).rounded(.up)))
      while count < words.count {
        let pieces = Self.divide(words, into: count, kind: kind)
        if pieces.allSatisfy({ height(of: $0, as: kind) <= room }) {
          return pieces
        }
        count += 1
      }
      return words.map(String.init)
    }

    /// Divides into `count` runs of near equal length, moving each division
    /// to a pause in the text when one is close by.
    private static func divide(_ words: [Substring], into count: Int, kind: Kind) -> [String] {
      let reach = max(words.count / count / 3, 1)
      var starts = [0]
      for division in 1..<count {
        let ideal = words.count * division / count
        let lowest = max(starts[starts.count - 1] + 1, ideal - reach)
        let highest = min(words.count - (count - division), ideal + reach)
        var chosen = min(max(ideal, lowest), max(lowest, highest))
        if lowest <= highest {
          // Nearest first, so a pause further off never beats one at hand.
          let candidates = (lowest...highest).sorted { abs($0 - ideal) < abs($1 - ideal) }
          if let pause = candidates.first(where: { endsAtPause(words[$0 - 1], kind: kind) }) {
            chosen = pause
          }
        }
        starts.append(chosen)
      }
      return starts.enumerated().map { index, start in
        let end = index + 1 < starts.count ? starts[index + 1] : words.count
        return words[start..<end].joined(separator: " ")
      }
    }

    /// Whether a reader may pause after this word.
    private static func endsAtPause(_ word: Substring, kind: Kind) -> Bool {
      switch kind {
      case .arabic:
        // The small high signs of pause stand as words of their own.
        return !word.isEmpty && word.unicodeScalars.allSatisfy {
          (0x06D6...0x06DC).contains($0.value)
        }
      case .transliteration, .translation:
        guard let last = word.unicodeScalars.last else { return false }
        return ".;:,!?)”»۔،؛".unicodeScalars.contains(last)
      }
    }
  }
}
