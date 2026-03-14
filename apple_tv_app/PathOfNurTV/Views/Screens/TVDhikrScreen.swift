import SwiftUI

struct TVDhikrScreen: View {
    @ObservedObject var viewModel: TVDhikrViewModel
    @State private var count = 33

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer(minLength: 10)
            Text("Dhikr")
                .font(.system(size: 56, weight: .bold, design: .rounded))
                .foregroundStyle(TVTheme.textPrimary)
            Text(viewModel.subtitle)
                .font(.system(size: 24, weight: .medium, design: .rounded))
                .foregroundStyle(TVTheme.textSecondary)

            VStack(spacing: 18) {
                Text(viewModel.phrase)
                    .font(.system(size: 64, weight: .heavy, design: .rounded))
                    .foregroundStyle(TVTheme.focus)
                Text(viewModel.transliteration)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .foregroundStyle(TVTheme.textSecondary)
                Text(viewModel.translation)
                    .font(.system(size: 24, weight: .regular, design: .rounded))
                    .foregroundStyle(TVTheme.textPrimary)
                Text("\(count)")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(TVTheme.textPrimary)
            }
            .frame(maxWidth: .infinity)
            .padding(50)
            .background(
                RoundedRectangle(cornerRadius: 42, style: .continuous)
                    .fill(TVTheme.surface)
            )

            HStack(spacing: 18) {
                Button("Increase Count") { count += 1 }
                    .buttonStyle(.borderedProminent)
                Button("Reset") { count = 0 }
                    .buttonStyle(.bordered)
                Button("Ambient Family Mode") { }
                    .buttonStyle(.bordered)
            }
            .font(.system(size: 22, weight: .semibold, design: .rounded))

            Spacer()
        }
        .padding(TVTheme.outerPadding)
        .background(TVBackgroundView())
        .navigationTitle("Dhikr")
    }
}
