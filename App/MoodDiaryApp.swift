import SwiftUI

@main
struct MoodDiaryApp: App {
    @StateObject private var store = MoodStore.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}