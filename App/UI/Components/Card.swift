import SwiftUI

struct Card<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) { self.content = content() }
    @Environment(\.themePalette) private var palette
    var body: some View {
        content
            .glassCard(palette)
    }
}
