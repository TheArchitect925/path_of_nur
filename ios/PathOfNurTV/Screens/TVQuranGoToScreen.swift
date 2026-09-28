import SwiftUI

/// Ways to a place in the Qur'an other than the list of surahs: the ayahs
/// the viewer bookmarked, the 30 juz, and any ayah of the surah that is
/// open, by its number.
struct TVQuranGoToScreen: View {
  @ObservedObject var viewModel: TVQuranViewModel
  /// A place was chosen; the reader opens there.
  var onChoose: (TVQuranPlace) -> Void
  var onClose: () -> Void

  @FocusState private var focused: String?
  @State private var focusSeeker = TVFocusSeeker()

  static let prefix = "quran.goto."
  static func bookmarkID(_ place: TVQuranPlace) -> String { "\(prefix)bookmark.\(place.key)" }
  static func juzID(_ number: Int) -> String { "\(prefix)juz.\(number)" }
  static func ayahID(_ number: Int) -> String { "\(prefix)ayah.\(number)" }

  private static let juzPerRow = 6
  private static let ayahsPerRow = 12

  var body: some View {
    ZStack {
      TVCoverBackground()

      ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 34) {
          Text(tvLocalized("Go to"))
            .font(TVTypography.compactHeroTitle)
            .foregroundColor(TVTheme.textPrimary)
            .tvReadableTitle()

          bookmarksSection
          juzSection
          ayahSection
        }
        .padding(.horizontal, 90)
        .padding(.vertical, 60)
      }
    }
    .onAppear {
      let first = viewModel.bookmarks.first.map(Self.bookmarkID) ?? Self.juzID(1)
      focusSeeker.seek(first, with: $focused)
    }
    .onExitCommand {
      onClose()
    }
  }

  // MARK: - Bookmarks

  @ViewBuilder
  private var bookmarksSection: some View {
    heading(tvLocalized("Bookmarks"))
    if viewModel.bookmarks.isEmpty {
      Text(tvLocalized("Press and hold an ayah in the reader, or press the bookmark in the player, to keep it here."))
        .font(TVTypography.figtreeMedium(22))
        .foregroundColor(TVTheme.textSecondary)
        .tvReadableBody()
    } else {
      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: TVTheme.railSpacing) {
          ForEach(viewModel.bookmarks, id: \.self) { place in
            Button {
              onChoose(place)
            } label: {
              VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "bookmark.fill")
                  .font(.system(size: 26, weight: .semibold))
                  .foregroundColor(TVTheme.accentStrong)
                Text(viewModel.line(for: place))
                  .font(TVTypography.figtreeMedium(24))
                  .foregroundColor(TVTheme.textPrimary)
                  .lineLimit(1)
              }
              .padding(24)
              .frame(width: 330, alignment: .leading)
              .background(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                  .fill(TVTheme.surface)
              )
            }
            .buttonStyle(TVCardButtonStyle(shape: .rounded(24)))
            .tvFocusID($focused, Self.bookmarkID(place))
            .contextMenu {
              Button(role: .destructive) {
                if let ayah = TVSeedRepository.ayahs(for: place.surahNumber)
                  .first(where: { $0.ayahNumber == place.ayahNumber }) {
                  viewModel.toggleBookmark(ayah)
                }
              } label: {
                Label(tvLocalized("Remove bookmark"), systemImage: "bookmark.slash")
              }
            }
          }
        }
        .padding(TVTheme.railBleed)
      }
      .tvRail()
    }
  }

  // MARK: - Juz

  @ViewBuilder
  private var juzSection: some View {
    heading(tvLocalized("Juz"))
    grid(count: TVQuranData.juzStarts.count, perRow: Self.juzPerRow) { index in
      let place = TVQuranData.juzStarts[index]
      Button {
        onChoose(place)
      } label: {
        VStack(alignment: .leading, spacing: 6) {
          Text(tvLocalized("Juz %d", index + 1))
            .font(TVTypography.figtreeMedium(26))
            .foregroundColor(TVTheme.textPrimary)
          Text(viewModel.line(for: place))
            .font(TVTypography.figtreeMedium(18))
            .foregroundColor(TVTheme.textSecondary)
            .lineLimit(1)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
          RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(juzHoldsSelectedAyah(index) ? TVTheme.surface : TVTheme.surfaceSoft)
        )
      }
      .buttonStyle(TVCardButtonStyle(shape: .rounded(22)))
      .tvFocusID($focused, Self.juzID(index + 1))
    }
  }

  /// Whether the ayah in hand falls in this juz.
  private func juzHoldsSelectedAyah(_ index: Int) -> Bool {
    guard let ayah = viewModel.selectedAyah else { return false }
    let here = (ayah.surahNumber, ayah.ayahNumber)
    let starts = TVQuranData.juzStarts
    let begins = (starts[index].surahNumber, starts[index].ayahNumber)
    let next = index + 1 < starts.count
      ? (starts[index + 1].surahNumber, starts[index + 1].ayahNumber)
      : (Int.max, Int.max)
    return here >= begins && here < next
  }

  // MARK: - An ayah of the surah that is open

  @ViewBuilder
  private var ayahSection: some View {
    heading(String(
      format: tvLocalized("Ayah of %@"),
      viewModel.selectedSurah.transliteratedName
    ))
    grid(count: viewModel.selectedAyahs.count, perRow: Self.ayahsPerRow) { index in
      let isCurrent = index == viewModel.selectedAyahIndex
      Button {
        onChoose(TVQuranPlace(surahNumber: viewModel.selectedSurah.number, ayahNumber: index + 1))
      } label: {
        Text("\(index + 1)")
          .font(TVTypography.figtreeMedium(26))
          .foregroundColor(isCurrent ? TVTheme.prayerCurrentText : TVTheme.textPrimary)
          .frame(maxWidth: .infinity)
          .frame(height: 64)
          .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
              .fill(isCurrent ? TVTheme.prayerCurrent : TVTheme.surfaceSoft)
          )
      }
      .buttonStyle(TVCardButtonStyle(shape: .rounded(18)))
      .tvFocusID($focused, Self.ayahID(index + 1))
      .accessibilityLabel(tvLocalized("Ayah %d", index + 1))
    }
  }

  // MARK: - Pieces

  private func heading(_ title: String) -> some View {
    Text(title)
      .font(TVTypography.sectionTitle)
      .foregroundColor(TVTheme.textPrimary)
      .tvReadableTitle()
  }

  /// Rows that are all drawn, not drawn as they are wanted: a grid whose
  /// rows off the screen were not yet drawn could not be moved down into.
  private func grid<Cell: View>(
    count: Int,
    perRow: Int,
    @ViewBuilder cell: @escaping (Int) -> Cell
  ) -> some View {
    VStack(spacing: 16) {
      ForEach(0..<((count + perRow - 1) / perRow), id: \.self) { row in
        HStack(spacing: 16) {
          ForEach(0..<perRow, id: \.self) { column in
            let index = row * perRow + column
            if index < count {
              cell(index)
            } else {
              Color.clear.frame(maxWidth: .infinity)
            }
          }
        }
      }
    }
    .focusSection()
  }
}
