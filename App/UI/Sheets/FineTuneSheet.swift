import SwiftUI

struct FineTuneSheet: View {
    @Binding var isPresented: Bool
    @State private var value: Double = 50
    @State private var note: String = ""
    @State private var emotion: Emotion = .joy
    @State private var customEmoji: String? = nil
    @State private var showEmojiPicker: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(LocalizedStringKey("FINE_TUNE")).font(.headline)
                Spacer()
                Text("\(Int(value))/100").font(.headline)
            }
            Picker("Emotion", selection: $emotion) {
                ForEach(Emotion.allCases, id: \.self) { e in
                    Text(e.display).tag(e)
                }
            }
            .pickerStyle(.segmented)

            Slider(value: $value, in: 0...100, step: 1) { editing in
                if editing { Haptics.fire(.light) }
            }
            .tint(.accentColor)
            .accessibilityLabel("Mood slider")

            TextField(LocalizedStringKey("WHAT_HAPPENED"), text: $note)
                .textFieldStyle(.roundedBorder)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Эмодзи (необязательно)")
                    Spacer()
                    if let ce = customEmoji, !ce.isEmpty {
                        Text(ce).font(.title3)
                        Button("Очистить") { withAnimation { customEmoji = nil } }
                            .buttonStyle(.bordered)
                    }
                    Button(showEmojiPicker ? "Скрыть" : "Выбрать") { withAnimation { showEmojiPicker.toggle() } }
                        .buttonStyle(.bordered)
                }
                if showEmojiPicker {
                    EmojiPickerView(selection: $customEmoji)
                        .frame(maxHeight: 180)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }

            HStack(spacing: 12) {
                Button(LocalizedStringKey("NOTHING")) { isPresented = false }
                    .buttonStyle(.bordered)
                Button(LocalizedStringKey("SAVE")) {
                    MoodStore.shared.append(value: Int(value), note: note.isEmpty ? nil : note, emotion: emotion, customEmoji: customEmoji)
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
// Preview removed for CI stability
