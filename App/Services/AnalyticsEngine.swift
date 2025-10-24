import Foundation

public enum Period {
    case day, week, month
}

public enum Trend: Equatable {
    case up(Double)
    case down(Double)
    case flat(Double)
}

public struct AnalyticsEngine {
    let entries: [MoodEntry]
    let calendar = Calendar.current

    public init(entries: [MoodEntry]) { self.entries = entries }

    public func avg(period: Period) -> Double {
        let filtered = filter(entries: entries, for: period)
        guard !filtered.isEmpty else { return .nan }
        return Double(filtered.map { $0.value }.reduce(0, +)) / Double(filtered.count)
    }

    public func median(period: Period) -> Double {
        let filtered = filter(entries: entries, for: period)
        guard !filtered.isEmpty else { return .nan }
        let sorted = filtered.map { $0.value }.sorted()
        let mid = sorted.count / 2
        if sorted.count % 2 == 0 { return Double(sorted[mid-1] + sorted[mid]) / 2.0 }
        return Double(sorted[mid])
    }

    public func minValue(period: Period) -> Int? { filter(entries: entries, for: period).map { $0.value }.min() }
    public func maxValue(period: Period) -> Int? { filter(entries: entries, for: period).map { $0.value }.max() }

    public func trend7d() -> Trend {
        let now = Date()
        let last7 = entries.filter { $0.date >= calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))! }
        let prev7 = entries.filter { $0.date < calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))! && $0.date >= calendar.date(byAdding: .day, value: -13, to: calendar.startOfDay(for: now))! }
        let a = last7.isEmpty ? .nan : Double(last7.map{ $0.value }.reduce(0,+)) / Double(last7.count)
        let b = prev7.isEmpty ? .nan : Double(prev7.map{ $0.value }.reduce(0,+)) / Double(prev7.count)
        let delta = (a.isNaN || b.isNaN) ? 0 : (a - b)
        if delta >= 5.0 { return .up(delta) } // widen threshold for 0..100 scale
        if delta <= -5.0 { return .down(delta) }
        return .flat(delta)
    }

    public func hourlyHeatmap() -> [Int: [Int: [MoodEntry]]] {
        // dayIndex -> hour -> entries
        var map: [Int: [Int: [MoodEntry]]] = [:]
        for e in entries {
            let dayDiff = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: e.date)).day ?? 0
            let hour = calendar.component(.hour, from: e.date)
            map[dayDiff, default: [:]][hour, default: []].append(e)
        }
        return map
    }

    public func functionDistribution(period: Period) -> [EmotionFunction: Int] {
        let filtered = filter(entries: entries, for: period)
        var counts: [EmotionFunction: Int] = [:]
        for e in filtered {
            if let emo = e.emotion {
                let f = emo.function
                counts[f, default: 0] += 1
            }
        }
        return counts
    }

    private func filter(entries: [MoodEntry], for period: Period) -> [MoodEntry] {
        let now = Date()
        let start: Date
        switch period {
        case .day:
            start = calendar.startOfDay(for: now)
        case .week:
            start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now))!
        case .month:
            start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: now))!
        }
        return entries.filter { $0.date >= start }
    }
}
