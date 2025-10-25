import SwiftUI

public enum Theme {
    public static let radius12: CGFloat = 12
    public static let radius16: CGFloat = 16
    public static let radius20: CGFloat = 20
}

public struct ThemePalette {
    public let accent: Color
    public let glow: Color
    public let gradient: LinearGradient
    public let state: PersistentMoodState

    public static func forMood(_ average: Double, scheme: ColorScheme) -> ThemePalette {
        let state = MoodStateMapper.fromAverage(average)
        // choose tone per scheme
        let tones = state.tone
        let colors = (scheme == .dark) ? tones.night : tones.day
        let a = colors.first ?? .accentColor
        let b = (colors.count > 1 ? colors[1] : a).opacity(0.9)
        let gradient = LinearGradient(colors: [a, b], startPoint: .topLeading, endPoint: .bottomTrailing)
        let glow = b.opacity(0.6)
        return ThemePalette(accent: a, glow: glow, gradient: gradient, state: state)
    }
}

public struct GlassCard: ViewModifier {
    let palette: ThemePalette
    public func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radius16, style: .continuous)
                    .stroke(palette.gradient.opacity(0.6), lineWidth: 1)
            )
            .shadow(color: palette.glow.opacity(0.25), radius: 10, x: 0, y: 6)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius16, style: .continuous))
    }
}

public extension View {
    func glassCard(_ palette: ThemePalette) -> some View {
        modifier(GlassCard(palette: palette))
    }
}
