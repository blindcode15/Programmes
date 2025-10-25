import XCTest
@testable import IOSDiary

final class AnalyticsEngineTests: XCTestCase {
    func testAverageMedian() {
        let now = Date()
        let entries = [1,3,5,7,9].enumerated().map { i, v in
            MoodEntry(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -i, to: now)!, value: v, note: nil)
        }
        let eng = AnalyticsEngine(entries: entries)
        let avg = eng.avg(period: .week)
        XCTAssertFalse(avg.isNaN)
        XCTAssertGreaterThan(avg, 0)
        let med = eng.median(period: .week)
        XCTAssertEqual(med, 5)
    }

    func testTrend7d() {
        let now = Date()
        var entries: [MoodEntry] = []
        for i in 0..<14 {
            let val = i < 7 ? 3 : 7
            entries.append(MoodEntry(id: UUID(), date: Calendar.current.date(byAdding: .day, value: -i, to: now)!, value: val, note: nil))
        }
        let eng = AnalyticsEngine(entries: entries)
        let t = eng.trend7d()
        switch t { case .up(let d): XCTAssertGreaterThanOrEqual(d, 1.0)
        default: XCTFail("Expected up") }
    }
}
