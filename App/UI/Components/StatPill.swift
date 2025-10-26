import SwiftUI

struct StatPill: View {
    let title: String
    let value: String
    @Environment(\.themePalette) private var palette
    var body: some View {
        HStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline)
                .foregroundStyle(palette.accent)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .overlay(
            Capsule()
                .stroke(palette.accent.opacity(0.35), lineWidth: 1)
        )
        .shadow(color: palette.glow.opacity(0.18), radius: 6, x: 0, y: 3)
        .clipShape(Capsule())
    }
}
