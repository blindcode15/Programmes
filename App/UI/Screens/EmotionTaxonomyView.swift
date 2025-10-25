import SwiftUI

struct EmotionTaxonomyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Таксономия эмоций")
                    .font(.largeTitle).bold()
                Text("Разделение по функции: кратковременные импульсивные состояния и устойчивые фоновые настроения. Это абстракция, помогающая замечать общий фон и вспышки.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Разовые (импульсивные)").font(.headline)
                        ChipsGrid(items: EmotionTaxonomy.phasic)
                    }
                }
                Card {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Постоянные (фоновые)").font(.headline)
                        ChipsGrid(items: EmotionTaxonomy.tonic)
                    }
                }

                Text("Примечание: классификация упрощена и вдохновлена психо- и нейробиологическими подходами. Отслеживайте и интерпретируйте с бережностью к себе.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

private struct ChipsGrid: View {
    let items: [String]
    private var columns: [GridItem] { [GridItem(.adaptive(minimum: 100), spacing: 8)] }
    var body: some View {
        LazyVGrid(columns: columns, spacing: 8) {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(.thinMaterial)
                    .clipShape(Capsule())
            }
        }
    }
}

// Preview removed for CI stability
