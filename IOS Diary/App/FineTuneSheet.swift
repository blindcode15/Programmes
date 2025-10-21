import SwiftUI
import CoreHaptics

struct FineTuneSheet: View {
    @Binding var isPresented: Bool
    @State private var value: Double = 5
    @State private var note: String = ""

    private let generator = UIImpactFeedbackGenerator(style: .light)

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(LocalizedStringKey("FINE_TUNE")).font(.headline)
                Spacer()
                Text("\(Int(value))/10")
                    .font(.headline)
            }
            Slider(value: $value, in: 0...10, step: 1) { _ in
                generator.impactOccurred()
            }
            .tint(.accentColor)
            .accessibilityLabel("Mood slider")

            TextField(LocalizedStringKey("WHAT_HAPPENED"), text: $note)
                .textFieldStyle(.roundedBorder)

            HStack(spacing: 12) {
                Button(LocalizedStringKey("NOTHING")) {
                    isPresented = false
                }
                .buttonStyle(.bordered)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                Button(LocalizedStringKey("SAVE")) {
                    MoodStore.shared.addQuick(value: Int(value), note: note.isEmpty ? nil : note)
                    let success = UINotificationFeedbackGenerator()
                    success.notificationOccurred(.success)
                    isPresented = false
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            }
        }
        .padding()
    }
}

#Preview {
    FineTuneSheet(isPresented: .constant(true))
}