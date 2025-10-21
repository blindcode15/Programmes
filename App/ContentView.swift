import SwiftUI

struct ContentView: View {
    @StateObject private var store = MoodStore.shared
    @State private var showFineTune = false
    @State private var presentExport = false

    var body: some View {
        NavigationStack {
            List(store.entries.reversed()) { entry in
                HStack(spacing: 12) {
                    Text(emoji(for: entry.value))
                        .font(.largeTitle)
                    VStack(alignment: .leading) {
                        Text("\(entry.value)/10")
                            .font(.headline)
                        if let note = entry.note, !note.isEmpty {
                            Text(note)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(8)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
            .navigationTitle(LocalizedStringKey("APP_TITLE"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button(LocalizedStringKey("EXPORT_JSON")) { presentExportJSON() }
                        Button(LocalizedStringKey("EXPORT_CSV")) { presentExportCSV() }
                    } label: {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
            }
            .sheet(isPresented: $showFineTune) {
                FineTuneSheet(isPresented: $showFineTune)
                    .presentationDetents([.fraction(0.35), .medium])
                    .presentationCornerRadius(12)
            }
            .task {
                if store.consumeFineTuneFlag() {
                    showFineTune = true
                }
                _ = await NotificationHelper.requestAuthorization()
            }
        }
        .tint(Color.accentColor)
    }

    private func emoji(for value: Int) -> String {
        switch value {
        case ..<3: return "😞"
        case 3..<5: return "😐"
        case 5..<8: return "🙂"
        default: return "😄"
        }
    }

    private func presentExportJSON() {
        if let data = store.exportJSON() {
            let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("moods.json")
            try? data.write(to: tmp)
            presentExport = true
        }
    }

    private func presentExportCSV() {
        let csv = store.exportCSV()
        let tmp = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("moods.csv")
        try? csv.data(using: .utf8)?.write(to: tmp)
        presentExport = true
    }
}

#Preview {
    ContentView()
}