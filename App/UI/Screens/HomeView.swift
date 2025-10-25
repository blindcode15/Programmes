import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: MoodStore
    @EnvironmentObject private var vm: MoodViewModel
    @Binding var showFineTune: Bool

    @State private var showUndoBar: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Card {
                    EmojiQuickRow(onQuick: { value, emotion in
                        vm.quickAdd(value: value, emotion: emotion)
                        showUndoTemporarily()
                    }, onFine: { showFineTune = true })
                }

                if let last = store.entries.last {
                    Card {
                        HStack(alignment: .center, spacing: 12) {
                            Text(last.emoji).font(.largeTitle)
                            VStack(alignment: .leading) {
                                let emo = last.emotion?.display ?? ""
                                Text("Последнее: \(last.value)/100 \(emo.isEmpty ? "" : "· \(emo)")")
                                    .font(.headline)
                                Text(last.date, style: .date)
                                    .font(.caption).foregroundStyle(.secondary)
                            }
                            Spacer()
                            if vm.undoAvailable {
                                Button("Отменить") { vm.undoLast() }
                                    .buttonStyle(.bordered)
                            }
                        }
                    }
                }

                if !store.entries.isEmpty {
                    Text("Недавние")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 4)

                    VStack(spacing: 12) {
                        ForEach(Array(store.entries.suffix(8).reversed()), id: \.id) { e in
                            Card {
                                RecentRow(entry: e)
                            }
                            .modifier(RevealOnScroll(shadowIntensity: 0.08))
                        }
                    }
                }
            }
            .padding()
        }
        .coordinateSpace(name: "scroll")
    }

    private func showUndoTemporarily() { withAnimation { showUndoBar = true } }
}

// MARK: - Recent Row
private struct RecentRow: View {
    let entry: MoodEntry
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(color(for: entry.value))
                    .frame(width: 12, height: 12)
                Circle().fill(.ultraThinMaterial)
                    .frame(width: 42, height: 42)
                Text(entry.emoji).font(.title3)
            }
            VStack(alignment: .leading, spacing: 2) {
                let emo = entry.emotion?.display ?? ""
                Text(emo)
                    .font(.subheadline)
                Text(entry.date, style: .time)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if let note = entry.note, !note.isEmpty {
                Text(note)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 6)
    }
}

// MARK: - Reveal on scroll effect
private struct RevealOnScroll: ViewModifier {
    var shadowIntensity: Double = 0.12
    @Environment(\.colorScheme) private var scheme
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            let height = proxy.size.height
            let progress = max(0, min(1, (minY + height) / (height * 2))) // 0 at far below, 1 when fully in
            content
                .opacity(progress)
                .offset(y: (1 - progress) * 24)
                .rotation3DEffect(.degrees((1 - progress) * 8), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                .shadow(color: (scheme == .dark ? Color.black : Color.gray).opacity(shadowIntensity * (1 - progress)), radius: 8, x: 0, y: 6)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
        }
        .frame(height: 64)
    }
}

// Map value 0..100 to a small color dot: cool/dark near 0 → warm/light near 100
private func color(for value: Int) -> Color {
    let clamped = max(0, min(100, value))
    // hue from blue (0.65) to warm (0.08), brightness ramps up
    let hueStart: Double = 0.65
    let hueEnd: Double = 0.08
    let t = Double(clamped) / 100.0
    let hue = hueStart + (hueEnd - hueStart) * t
    let sat = 0.6 - 0.2 * t
    let bri = 0.45 + 0.45 * t
    return Color(hue: hue, saturation: sat, brightness: bri)
}
