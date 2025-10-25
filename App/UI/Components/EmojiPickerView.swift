import SwiftUI

struct EmojiPickerView: View {
    @Binding var selection: String?
    @State private var category: Category = .faces
    enum Category: String, CaseIterable { case faces = "Лица", hearts = "Сердца", nature = "Природа", signs = "Знаки" }

    private let faces = [
        "😀","😃","😄","😁","😆","🙂","😊","😌","😉","🥲",
        "😐","😑","😶","🙃","🫠","😕","😟","😔","☹️","😢",
        "😭","😤","😠","😡","🤬","😳","😱","😨","😰","😮"
    ]
    private let hearts = ["❤️","🧡","💛","💚","💙","💜","🖤","🤍","🤎","❣️","💕","💞","💓","💗","💖","💘"]
    private let nature = ["🌿","🍀","☘️","🌸","🌼","🌻","🌺","🌞","🌧️","🌈","🔥","💧"]
    private let signs = ["✨","⚡️","💫","🌪️","🌟","🎯","🚀","🌀","🧠","🫀","🫁"]

    private var items: [String] {
        switch category {
        case .faces: return faces
        case .hearts: return hearts
        case .nature: return nature
        case .signs: return signs
        }
    }

    private let columns = [GridItem(.adaptive(minimum: 36), spacing: 8)]

    var body: some View {
        VStack(spacing: 8) {
            Picker("Категория", selection: $category) {
                ForEach(Category.allCases, id: \.self) { c in
                    Text(c.rawValue).tag(c)
                }
            }
            .pickerStyle(.segmented)

            ScrollView {
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(items, id: \.self) { e in
                        Button(action: { selection = e }) {
                            Text(e)
                                .font(.title2)
                                .frame(width: 40, height: 40)
                                .contentShape(Rectangle())
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(selection == e ? Color.accentColor.opacity(0.15) : Color.clear)
                                )
                        }
                        .buttonStyle(PressableButtonStyle())
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}
