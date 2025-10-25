import SwiftUI

struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.92
    var highlight: Color = .accentColor
    @Environment(\.persistentMoodState) private var moodState

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .shadow(color: highlight.opacity(configuration.isPressed ? moodState.interaction.glow : 0.0), radius: 10, x: 0, y: 6)
            .animation(.spring(response: moodState.interaction.pressDuration, dampingFraction: 0.8), value: configuration.isPressed)
    }
}
