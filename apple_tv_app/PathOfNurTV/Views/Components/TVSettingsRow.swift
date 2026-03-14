import SwiftUI

struct TVSettingsRow: View {
    let option: TVSettingsOption

    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 6) {
                Text(option.title)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundStyle(TVTheme.textPrimary)
                Text(option.subtitle)
                    .font(.system(size: 18, weight: .regular, design: .rounded))
                    .foregroundStyle(TVTheme.textSecondary)
            }
            Spacer()
            Text(option.valueLabel)
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .foregroundStyle(TVTheme.focus)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: TVTheme.cardRadius, style: .continuous)
                .fill(TVTheme.surface)
        )
        .tvFocusableCard()
    }
}
