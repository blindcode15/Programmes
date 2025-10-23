import SwiftUI

public enum Theme {
    public static let radius12: CGFloat = 12
    public static let radius20: CGFloat = 20
}

public struct CardBackground: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radius16, style: .continuous))
    }
}

extension Theme { static let radius16: CGFloat = 16 }
