import SwiftUI

struct TipsView: View {
    @EnvironmentObject private var store: MoodStore
    @Environment(\.persistentMoodState) private var persistentState

    private var tipsEngine: TipsEngine {
        let url = Bundle.main.url(forResource: "PhrasesBank", withExtension: "json") ?? URL(fileURLWithPath: "")
        return TipsEngine(jsonURL: url)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                NavigationLink(destination: EmotionTaxonomyView()) {
                    Card { HStack { Image(systemName: "list.bullet.rectangle"); Text("Таксономия эмоций") ; Spacer(); Image(systemName: "chevron.right").foregroundStyle(.secondary) } }
                }

                let analytics = AnalyticsEngine(entries: store.entries)
                let latest = store.entries.last?.value
                let weeklyAvg = analytics.avg(period: .week)
                let kb = PsychKnowledgeBase()
                let kbState = kb.states.first { $0.key == persistentState.rawValue }

                Group {
                    HStack(spacing: 10) {
                        Text("Сегодняшний срез:").font(.headline)
                        if let latest { StatPill(title: "Now", value: "\(latest)/100") }
                        StatPill(title: "7д среднее", value: weeklyAvg.isNaN ? "–" : String(format: "%.1f", weeklyAvg))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if !weeklyAvg.isNaN {
                        HStack(spacing: 6) {
                            Text("В среднем за неделю:")
                            CountUpText(target: weeklyAvg, format: "%.1f")
                                .font(.title3).bold()
                        }
                        .padding(.vertical, 4)
                    }
                }

                // State-aware advice (from knowledge base) on top
                if let s = kbState, !s.tips.isEmpty {
                    Text("Советы состояния").font(.headline)
                    ForEach(Array(s.tips.prefix(3)), id: \.self) { t in
                        Card { Text(t) }
                    }
                }

                // Generic advice blended with trend
                let trend = analytics.trend7d()
                let baseForPhrases = latest ?? 50
                Text("Советы").font(.headline)
                ForEach(tipsEngine.advice(latest: latest ?? 50, trend: trend), id: \.self) { t in
                    Card { Text(t) }
                }

                // Carousel phrases always-on
                Text("Мини-фразы").font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        if let s = kbState, !s.phrases.isEmpty {
                            ForEach(Array(s.phrases.prefix(8)), id: \.self) { t in
                                Card { Text(t).frame(width: 220, alignment: .leading) }
                            }
                        } else {
                            ForEach(tipsEngine.phrases(for: baseForPhrases, count: 6), id: \.self) { t in
                                Card { Text(t).frame(width: 220, alignment: .leading) }
                            }
                        }
                    }
                    .padding(.vertical, 2)
                }

                // Function distribution chips
                let dist = analytics.functionDistribution(period: .week)
                HStack(spacing: 8) {
                    StatPill(title: EmotionFunction.phasic.display, value: "\(dist[.phasic, default: 0])")
                    StatPill(title: EmotionFunction.tonic.display, value: "\(dist[.tonic, default: 0])")
                }
            }
            .padding()
        }
    }
}

// MARK: - Animated count-up number
private struct CountUpText: View {
    let target: Double
    var format: String = "%.0f"
    @State private var animate = false
    var body: some View {
        AnimatedNumber(value: animate ? target : 0, format: format)
            .onAppear { withAnimation(.easeOut(duration: 1.0)) { animate = true } }
    }
}

private struct AnimatedNumber: View, Animatable {
    var value: Double
    var format: String
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    var body: some View {
        Text(String(format: format, value))
    }
}
