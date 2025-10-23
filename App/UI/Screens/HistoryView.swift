import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var store: MoodStore

    var body: some View {
        List(store.entries.reversed()) { e in
            HStack(spacing: 12) {
                Text(e.emoji).font(.largeTitle)
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(e.value)/10").font(.headline)
                    if let note = e.note, !note.isEmpty { Text(note).font(.subheadline).foregroundStyle(.secondary) }
                    Text(e.date, style: .date).font(.caption).foregroundStyle(.secondary)
                }
            }
            .listRowBackground(Color.clear)
        }
    }
}
