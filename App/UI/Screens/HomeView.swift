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
                        ForEach(store.entries.suffix(8).reversed(), id: \.id) { e in
                            Card {
                                RecentRow(entry: e)
                            }
                            .modifier(RevealOnScroll())
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
                Circle().fill(.ultraThinMaterial)
                    .frame(width: 42, height: 42)
                Text(entry.emoji).font(.title3)
            }
            VStack(alignment: .leading, spacing: 2) {
                let emo = entry.emotion?.display ?? ""
                Text("\(entry.value)/100 \(emo.isEmpty ? "" : "· \(emo)")")
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
                .shadow(color: (scheme == .dark ? Color.black : Color.gray).opacity(0.12 * (1 - progress)), radius: 8, y: 6)
                .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
        }
        .frame(height: 64)
    }
}
