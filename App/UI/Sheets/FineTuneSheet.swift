import SwiftUI

struct FineTuneSheet: View {
    @Binding var isPresented: Bool
    @State private var value: Double = 5
    @State private var note: String = ""

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(LocalizedStringKey("FINE_TUNE")).font(.headline)
                Spacer()
                Text("\(Int(value))/10").font(.headline)
            }
            Slider(value: $value, in: 0...10, step: 1) { editing in
                if editing { Haptics.fire(.light) }
            }
            .tint(.accentColor)
            .accessibilityLabel("Mood slider")

            TextField(LocalizedStringKey("WHAT_HAPPENED"), text: $note)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                Button(LocalizedStringKey("NOTHING")) { isPresented = false }
                    .buttonStyle(.bordered)
                Button(LocalizedStringKey("SAVE")) {
                    MoodStore.shared.append(value: Int(value), note: note.isEmpty ? nil : note)
                    Haptics.fire(.success)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
        }
        .padding()
    }
}

#Preview { FineTuneSheet(isPresented: .constant(true)) }
