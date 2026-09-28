import Foundation

/// The Qur'an the Apple TV shares with the phone through iCloud: where the
/// viewer is, the ayahs they bookmarked, the reciter and the translation.
/// Both read and write one document under one key in the key-value store
/// the phone and the television share (they are one app, one bundle id).
/// The phone's half is `quran_cloud_share.dart`; the two must agree on the
/// shape below.
struct TVQuranSharedState: Equatable {
  var place: String?
  var placeAt: Date?
  var bookmarks: [String]?
  var bookmarksAt: Date?
  var reciter: String?
  var reciterAt: Date?
  /// The phone's translation codes: "en.sahih", or "none".
  var translation: String?
  var translationAt: Date?

  static let key = "quran.shared.v1"

  init(
    place: String? = nil, placeAt: Date? = nil,
    bookmarks: [String]? = nil, bookmarksAt: Date? = nil,
    reciter: String? = nil, reciterAt: Date? = nil,
    translation: String? = nil, translationAt: Date? = nil
  ) {
    self.place = place
    self.placeAt = placeAt
    self.bookmarks = bookmarks
    self.bookmarksAt = bookmarksAt
    self.reciter = reciter
    self.reciterAt = reciterAt
    self.translation = translation
    self.translationAt = translationAt
  }

  init(json: String?) {
    self.init()
    guard
      let data = json?.data(using: .utf8),
      let object = (try? JSONSerialization.jsonObject(with: data)) as? [String: Any]
    else {
      return
    }
    func text(_ key: String) -> String? {
      (object[key] as? String).flatMap { $0.isEmpty ? nil : $0 }
    }
    func date(_ key: String) -> Date? { text(key).flatMap(Self.parse) }
    place = text("place")
    placeAt = date("placeAt")
    bookmarks = (object["bookmarks"] as? [Any])?.compactMap { $0 as? String }
    bookmarksAt = date("bookmarksAt")
    reciter = text("reciter")
    reciterAt = date("reciterAt")
    translation = text("translation")
    translationAt = date("translationAt")
  }

  var json: String {
    var object: [String: Any] = [:]
    object["place"] = place
    object["placeAt"] = placeAt.map(Self.format)
    object["bookmarks"] = bookmarks
    object["bookmarksAt"] = bookmarksAt.map(Self.format)
    object["reciter"] = reciter
    object["reciterAt"] = reciterAt.map(Self.format)
    object["translation"] = translation
    object["translationAt"] = translationAt.map(Self.format)
    let data = (try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])) ?? Data()
    return String(data: data, encoding: .utf8) ?? "{}"
  }

  /// Each field from whichever of the two changed it last.
  func merged(with other: TVQuranSharedState) -> TVQuranSharedState {
    func takesOther(_ mine: Date?, _ theirs: Date?) -> Bool {
      guard let theirs else { return false }
      guard let mine else { return true }
      return theirs > mine
    }
    var result = self
    if takesOther(placeAt, other.placeAt) {
      result.place = other.place
      result.placeAt = other.placeAt
    }
    if takesOther(bookmarksAt, other.bookmarksAt) {
      result.bookmarks = other.bookmarks
      result.bookmarksAt = other.bookmarksAt
    }
    if takesOther(reciterAt, other.reciterAt) {
      result.reciter = other.reciter
      result.reciterAt = other.reciterAt
    }
    if takesOther(translationAt, other.translationAt) {
      result.translation = other.translation
      result.translationAt = other.translationAt
    }
    return result
  }

  private static func format(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return formatter.string(from: date)
  }

  private static func parse(_ text: String) -> Date? {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = formatter.date(from: text) { return date }
    formatter.formatOptions = [.withInternetDateTime]
    if let date = formatter.date(from: text) { return date }
    // Dart writes a moment without a zone as local time; the phone always
    // writes UTC, so this is only a fallback.
    formatter.formatOptions = [.withFullDate, .withTime, .withColonSeparatorInTime]
    return formatter.date(from: text)
  }
}

/// The television's translation ids against the phone's codes.
enum TVQuranTranslationCodes {
  static let byID: [String: String] = [
    "en": "en.sahih",
    "en_clear": "en.clear",
    "fr": "fr.hamidullah",
    "ur": "ur.urdu",
    "bn": "bn.bengali",
    "id": "id.indonesian",
    "tr": "tr.saheeh",
    "fa": "fa.dari",
  ]

  static func code(for translation: TVQuranTranslation?) -> String {
    translation.flatMap { byID[$0.id] } ?? "none"
  }

  /// The translation a code names; `.some(nil)` for none, `nil` for a code
  /// the television does not carry.
  static func translation(for code: String) -> TVQuranTranslation?? {
    if code == "none" { return .some(nil) }
    guard let id = byID.first(where: { $0.value == code })?.key,
          let translation = TVQuranTranslation.withID(id) else {
      return nil
    }
    return .some(translation)
  }
}

/// Keeps the document in step on the television's side.
final class TVQuranCloudShare {
  typealias Store = TVQuranCloudStore

  /// Called with what the phone changed later than the television did.
  var onRemoteChange: ((TVQuranSharedState, TVQuranSharedState) -> Void)?

  private let store: Store
  private let userDefaults: UserDefaults
  private var applying = false
  private var writeTimer: Timer?
  private var observer: NSObjectProtocol?
  private static let localKey = "PathOfNurTV.quran.cloudShare"

  init(store: Store, userDefaults: UserDefaults) {
    self.store = store
    self.userDefaults = userDefaults
    observer = store.observeExternalChanges { [weak self] in
      self?.sync()
    }
  }

  deinit {
    writeTimer?.invalidate()
    if let observer {
      NotificationCenter.default.removeObserver(observer)
    }
  }

  var local: TVQuranSharedState {
    get { TVQuranSharedState(json: userDefaults.string(forKey: Self.localKey)) }
    set { userDefaults.set(newValue.json, forKey: Self.localKey) }
  }

  /// What the television has, as of long ago, the first time: the phone's
  /// newer choices win over it.
  func seed(place: String?, bookmarks: [String], reciter: String, translation: String) {
    var state = local
    let long = Date(timeIntervalSince1970: 946_684_800)
    if state.placeAt == nil, let place {
      state.place = place
      state.placeAt = long
    }
    if state.bookmarksAt == nil {
      state.bookmarks = bookmarks
      state.bookmarksAt = long
    }
    if state.reciterAt == nil {
      state.reciter = reciter
      state.reciterAt = long
    }
    if state.translationAt == nil {
      state.translation = translation
      state.translationAt = long
    }
    local = state
  }

  /// A change made on the television.
  func record(
    place: String? = nil,
    bookmarks: [String]? = nil,
    reciter: String? = nil,
    translation: String? = nil,
    now: Date = Date()
  ) {
    guard !applying else { return }
    var state = local
    if let place, place != state.place {
      state.place = place
      state.placeAt = now
    }
    if let bookmarks, bookmarks != state.bookmarks {
      state.bookmarks = bookmarks
      state.bookmarksAt = now
    }
    if let reciter, reciter != state.reciter {
      state.reciter = reciter
      state.reciterAt = now
    }
    if let translation, translation != state.translation {
      state.translation = translation
      state.translationAt = now
    }
    guard state != local else { return }
    local = state
    writeTimer?.invalidate()
    // A viewer moving ayah by ayah is written once they rest.
    writeTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
      self?.sync()
    }
  }

  /// Merges with the shared document: takes up what is newer there, and
  /// writes what is newer here.
  func sync() {
    let remote = TVQuranSharedState(json: store.string(forKey: TVQuranSharedState.key))
    let mine = local
    let merged = mine.merged(with: remote)
    if merged != mine {
      applying = true
      onRemoteChange?(mine, merged)
      applying = false
    }
    local = merged
    if merged != remote {
      store.put(merged.json, forKey: TVQuranSharedState.key)
    }
  }
}

/// The iCloud key-value store, or a stand-in for it.
protocol TVQuranCloudStore: AnyObject {
  func string(forKey key: String) -> String?
  func put(_ value: String, forKey key: String)
  func observeExternalChanges(_ handler: @escaping () -> Void) -> NSObjectProtocol?
}

extension NSUbiquitousKeyValueStore: TVQuranCloudStore {
  func put(_ value: String, forKey key: String) {
    set(value, forKey: key)
    synchronize()
  }

  func observeExternalChanges(_ handler: @escaping () -> Void) -> NSObjectProtocol? {
    let observer = NotificationCenter.default.addObserver(
      forName: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
      object: self,
      queue: .main
    ) { _ in handler() }
    synchronize()
    return observer
  }
}
