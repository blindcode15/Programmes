import Foundation

final class ChartsViewModel: ObservableObject {
    enum Range: String, CaseIterable { case day = "Day", week = "Week", month = "Month" }
    @Published var selected: Range = .week

    var engine: AnalyticsEngine { AnalyticsEngine(entries: MoodStore.shared.entries) }

    var avg: Double { engine.avg(period: map(selected)) }
    var median: Double { engine.median(period: map(selected)) }
    var minValue: Int { engine.minValue(period: map(selected)) ?? 0 }
    var maxValue: Int { engine.maxValue(period: map(selected)) ?? 10 }

    func series() -> [MoodEntry] {
        filter(MoodStore.shared.entries, for: selected)
    }

    private func filter(_ entries: [MoodEntry], for r: Range) -> [MoodEntry] {
        let cal = Calendar.current
        let now = Date()
        let start: Date
        switch r { case .day: start = cal.startOfDay(for: now)
                   case .week: start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now))!
                   case .month: start = cal.date(byAdding: .day, value: -29, to: cal.startOfDay(for: now))! }
        return entries.filter{ $0.date >= start }
    }

    private func map(_ r: Range) -> Period { switch r { case .day: .day; case .week: .week; case .month: .month } }
}
