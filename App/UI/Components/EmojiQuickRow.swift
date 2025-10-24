import SwiftUI

struct EmojiQuickRow: View {
    var onQuick: (Int, Emotion) -> Void
    var onFine: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach([Emotion.joy, .anxiety, .anger, .sadness], id: \.self) { e in
                let v = defaultValue(for: e)
                Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { onQuick(v, e); Haptics.fire(.light) } }) {
                    Text(emoji(for: e, value: v)).font(.largeTitle)
                        .frame(width: 56, height: 56)
                        .contentShape(.rect)
                }
                .buttonStyle(PressableButtonStyle(highlight: .accentColor))
                .accessibilityLabel(Text(e.display))
            }
            Button(action: { onFine(); Haptics.fire(.light) }) {
                Image(systemName: "slider.horizontal.3")
                    .font(.title2)
                    .frame(width: 56, height: 56)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Точно")
        }
    }

    private func defaultValue(for e: Emotion) -> Int {
        switch e {
        case .joy: return 85
        case .anxiety: return 45
        case .anger: return 35
        case .sadness: return 20
        }
    }

    private func emoji(for e: Emotion, value v: Int) -> String {
        switch e {
        case .joy: return "😄"
        case .anxiety: return "😟"
        case .anger: return "😠"
        case .sadness: return "😢"
        }
    }
}
