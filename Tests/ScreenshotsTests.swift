import XCTest
import SwiftUI
@testable import MoodDiary

final class ScreenshotsTests: XCTestCase {
    override func setUp() {
        super.setUp()
        seedStore()
    }

    func testRenderScreens_All() throws {
        // iPhone 15 logical points
        let size = CGSize(width: 393, height: 852)

        // ContentView (tabs)
        writePNG(render(hosting: ContentView().environmentObject(MoodStore.shared), size: size), name: "ContentView")

        // Home
        let home = HomeView(showFineTune: .constant(false))
            .environmentObject(MoodStore.shared)
            .environmentObject(MoodViewModel())
            .environmentObject(ChartsViewModel())
        writePNG(render(hosting: home, size: size), name: "HomeView")

        // History snapshot removed (History is merged into Home). If needed, render Home's recent section instead.

        // Charts
        let charts = ChartsView()
            .environmentObject(MoodStore.shared)
            .environmentObject(ChartsViewModel())
        writePNG(render(hosting: charts, size: size), name: "ChartsView")

        // Tips
        let tips = TipsView()
            .environmentObject(MoodStore.shared)
        writePNG(render(hosting: tips, size: size), name: "TipsView")

        // Fine tune sheet
        writePNG(render(hosting: FineTuneSheet(isPresented: .constant(true)), size: size), name: "FineTuneSheet")
    }

    // MARK: - Helpers
    private func seedStore() {
        // Create ~30 days of entries with some variation and different hours for heatmap
        var items: [MoodEntry] = []
        let cal = Calendar.current
        let now = Date()
    for i in 0..<30 {
            let day = cal.date(byAdding: .day, value: -i, to: now)!
            // three entries per day at different hours
            let hours = [9, 14, 21]
            for (idx, h) in hours.enumerated() {
                var comps = cal.dateComponents([.year,.month,.day], from: day)
                comps.hour = h
                comps.minute = 10 * idx
                let d = cal.date(from: comps) ?? day
                // pseudo curve around 30..90 on 0..100 scale
                let base = 55 + Int(25 * sin(Double(i)/4.0))
                let val = max(5, min(95, base + (idx-1) * 5))
                let emotion: Emotion = (val >= 70) ? .joy : (val >= 50 ? .anxiety : (val >= 35 ? .anger : .sadness))
                items.append(MoodEntry(date: d, value: val, note: idx == 1 ? "Note \(i)" : nil, emotion: emotion))
            }
        }
        MoodStore.shared.setEntries(items)
    }

    private func render(hosting view: some View, size: CGSize) -> UIImage {
        let vc = UIHostingController(rootView: view)
        vc.view.frame = CGRect(origin: .zero, size: size)
        vc.view.bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            vc.view.drawHierarchy(in: vc.view.bounds, afterScreenUpdates: true)
        }
    }

    private func writePNG(_ image: UIImage, name: String) {
        // Prefix with MD_ to allow CI to collect only our test snapshots
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("MD_\(name).png")
        if let data = image.pngData() {
            try? data.write(to: url)
            print("SNAPSHOT: \(url.path)")
        }
    }
}