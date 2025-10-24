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

    public static func forMood(_ average: Double, scheme: ColorScheme) -> ThemePalette {
        // Map 0..100 -> colors; calm but expressive
        let t = max(0, min(100, Int(average)))
        let base: (Color, Color)
        if t < 30 { // low mood — cool blue-violet
            base = (Color(hue: 0.65, saturation: 0.60, brightness: scheme == .dark ? 0.8 : 0.9),
                    Color(hue: 0.75, saturation: 0.55, brightness: scheme == .dark ? 0.7 : 0.85))
        } else if t < 60 { // neutral — teal
            base = (Color(hue: 0.5, saturation: 0.45, brightness: scheme == .dark ? 0.85 : 0.95),
                    Color(hue: 0.55, saturation: 0.40, brightness: scheme == .dark ? 0.75 : 0.9))
        } else if t < 85 { // good — mint/green
            base = (Color(hue: 0.38, saturation: 0.55, brightness: scheme == .dark ? 0.9 : 1.0),
                    Color(hue: 0.33, saturation: 0.50, brightness: scheme == .dark ? 0.8 : 0.95))
        } else { // great — warm peach/gold
            base = (Color(hue: 0.10, saturation: 0.70, brightness: scheme == .dark ? 0.95 : 1.0),
                    Color(hue: 0.08, saturation: 0.65, brightness: scheme == .dark ? 0.85 : 0.95))
        }
        let gradient = LinearGradient(colors: [base.0, base.1], startPoint: .topLeading, endPoint: .bottomTrailing)
        return ThemePalette(accent: base.0, glow: base.1.opacity(0.6), gradient: gradient)
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
