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
            }
            .padding()
        }
    }

    private func showUndoTemporarily() { withAnimation { showUndoBar = true } }
}
