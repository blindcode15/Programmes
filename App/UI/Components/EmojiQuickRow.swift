import SwiftUI

struct EmojiQuickRow: View {
    var onQuick: (Int, Emotion) -> Void
    var onFine: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            ForEach([Emotion.joy, .anxiety, .anger, .sadness], id: \.self) { e in
                let v = defaultValue(for: e)
                Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { onQuick(v, e); Haptics.fire(.light) } }) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: bgColors(for: e), startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: 64, height: 64)
                            .shadow(color: glow(for: e), radius: 10, x: 0, y: 6)
                        Text(emoji(for: e, value: v)).font(.title)
                        // micro animation overlay per emotion
                        MicroAnimView(kind: e)
                    }
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
        case .joy: return 92
        case .anxiety: return 55
        case .anger: return 30
        case .sadness: return 12
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

    private func bgColors(for e: Emotion) -> [Color] {
        switch e {
        case .joy: return [Color.yellow.opacity(0.9), Color.orange.opacity(0.8)]
        case .anxiety: return [Color.cyan.opacity(0.8), Color.blue.opacity(0.7)]
        case .anger: return [Color.red.opacity(0.85), Color.pink.opacity(0.75)]
        case .sadness: return [Color.indigo.opacity(0.8), Color.purple.opacity(0.7)]
        }
    }

    private func glow(for e: Emotion) -> Color {
        switch e {
        case .joy: return .orange.opacity(0.4)
        case .anxiety: return .blue.opacity(0.35)
        case .anger: return .red.opacity(0.45)
        case .sadness: return .purple.opacity(0.35)
        }
    }
}

// MARK: - Micro animations per emotion (simple SF Symbols + opacity/scale)
private struct MicroAnimView: View {
    let kind: Emotion
    @State private var trigger: Bool = false
    var body: some View {
        ZStack {
            switch kind {
            case .anger:
                Image(systemName: "flame.fill")
                    .foregroundStyle(.orange)
                    .scaleEffect(trigger ? 1.2 : 0.6)
                    .opacity(trigger ? 0.6 : 0.0)
                    .offset(y: trigger ? -28 : -10)
            case .joy:
                Image(systemName: "sparkles")
                    .foregroundStyle(.yellow)
                    .scaleEffect(trigger ? 1.1 : 0.6)
                    .opacity(trigger ? 0.7 : 0.0)
                    .offset(y: -28)
            case .anxiety:
                Image(systemName: "waveform.path.ecg")
                    .foregroundStyle(.cyan)
                    .scaleEffect(trigger ? 1.05 : 0.8)
                    .opacity(trigger ? 0.5 : 0.0)
                    .offset(y: 26)
            case .sadness:
                Image(systemName: "drop.fill")
                    .foregroundStyle(.blue)
                    .scaleEffect(trigger ? 1.15 : 0.7)
                    .opacity(trigger ? 0.6 : 0.0)
                    .offset(y: 24)
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) { trigger.toggle() }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                trigger = false
            }
        }
    }
}
