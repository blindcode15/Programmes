import SwiftUI

struct TipsView: View {
    @EnvironmentObject private var store: MoodStore

    private var tipsEngine: TipsEngine {
        let url = Bundle.main.url(forResource: "PhrasesBank", withExtension: "json") ?? URL(fileURLWithPath: "")
        return TipsEngine(jsonURL: url)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let latest = store.entries.last?.value {
                    let trend = AnalyticsEngine(entries: store.entries).trend7d()
                    Text("Сегодняшний срез: \(latest)/10").font(.headline)
                    ForEach(tipsEngine.advice(latest: latest, trend: trend), id: \.self) { t in
                        Card { Text(t) }
                    }
                } else {
                    Text("Нет данных. Сначала добавьте запись.")
                }

                if let latest = store.entries.last?.value {
                    Text("Мини-фразы").font(.headline)
                    ForEach(tipsEngine.phrases(for: latest, count: 3), id: \.self) { t in
                        Card { Text(t) }
                    }
                }
            }
            .padding()
        }
    }
}
