import XCTest
import SwiftUI
@testable import MoodDiary

final class ScreenshotsTests: XCTestCase {
    func testRenderScreens() throws {
        // Render ContentView and FineTuneSheet previews at iPhone 15 size and write PNGs to tmp
        let size = CGSize(width: 393, height: 852) // iPhone 15 logical points

        let cv = UIHostingController(rootView: ContentView())
        let cvImage = render(viewController: cv, size: size)
        writePNG(cvImage, name: "ContentView")

        let sheet = UIHostingController(rootView: FineTuneSheet(isPresented: .constant(true)))
        let sheetImage = render(viewController: sheet, size: size)
        writePNG(sheetImage, name: "FineTuneSheet")
    }

    private func render(viewController: UIViewController, size: CGSize) -> UIImage {
        viewController.view.frame = CGRect(origin: .zero, size: size)
        viewController.view.bounds = CGRect(origin: .zero, size: size)
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            viewController.view.drawHierarchy(in: viewController.view.bounds, afterScreenUpdates: true)
        }
    }

    private func writePNG(_ image: UIImage, name: String) {
        let url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("\(name).png")
        if let data = image.pngData() {
            try? data.write(to: url)
            print("SNAPSHOT: \(url.path)")
        }
    }
}