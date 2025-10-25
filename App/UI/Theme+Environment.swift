import SwiftUI

private struct ThemePaletteKey: EnvironmentKey {
    static let defaultValue = ThemePalette(
        accent: .accentColor,
        glow: .accentColor.opacity(0.4),
        gradient: LinearGradient(colors: [.accentColor, .accentColor.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing)
    )
}

public extension EnvironmentValues {
    var themePalette: ThemePalette {
        get { self[ThemePaletteKey.self] }
        set { self[ThemePaletteKey.self] = newValue }
    }
}

// Mood state in environment for richer theming
private struct MoodStateKey: EnvironmentKey {
    static let defaultValue: PersistentMoodState = .neutral
}

public extension EnvironmentValues {
    var persistentMoodState: PersistentMoodState {
        get { self[MoodStateKey.self] }
        set { self[MoodStateKey.self] = newValue }
    }
}
