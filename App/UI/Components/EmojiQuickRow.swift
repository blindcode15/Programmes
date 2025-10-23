import SwiftUI

struct EmojiQuickRow: View {
    var onQuick: (Int) -> Void
    var onFine: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ForEach([1,4,7,9], id: \.self) { v in
                Button(action: { withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) { onQuick(v); Haptics.fire(.light) } }) {
                    Text(emoji(v)).font(.largeTitle)
                        .frame(width: 56, height: 56)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(label(for: v))
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

    private func emoji(_ v: Int) -> String { v<3 ? "😞" : v<5 ? "😐" : v<8 ? "🙂" : "😄" }
    private func label(for v: Int) -> Text { v<3 ? Text("Плохо") : v<5 ? Text("Нейтрально") : v<8 ? Text("Нормально") : Text("Хорошо") }
}
