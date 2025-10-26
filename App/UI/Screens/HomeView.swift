import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var store: MoodStore
    @EnvironmentObject private var vm: MoodViewModel
    @Environment(\.themePalette) private var palette

    @State private var isRefineExpanded: Bool = false
    @State private var sliderValue: Double = 50
    @State private var showSavedToast: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 7-day average card
                if !store.entries.isEmpty {
                    Card {
                        HStack(spacing: 12) {
                            let eng = AnalyticsEngine(entries: store.entries)
                            let avg7 = eng.avg(period: .week)
                            let avg = avg7.isNaN ? eng.avg(period: .day) : avg7
                            let safe = avg.isNaN ? 50.0 : avg
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Среднее за 7 дней")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(String(format: "%.0f/100", safe))
                                    .font(.title3).bold()
                            }
                            Spacer()
                            MiniChartView(entries: last7Entries())
                                .frame(width: 140, height: 44)
                        }
                    }
                }

                // 4 primary emotions grid
                EmotionGrid(onSelect: { emo in
                    Haptics.fire(.light)
                    let value = fixedValue(for: emo)
                    vm.fineAdd(value: value, note: nil, emotion: emo)
                    withAnimation { showSavedToast = true }
                })

                // Refine dropdown with slider
                RefineSection(isExpanded: $isRefineExpanded, sliderValue: $sliderValue, onSave: saveCurrent)

                // Recent entries (last 3)
                if !store.entries.isEmpty {
                    VStack(spacing: 10) {
                        ForEach(Array(store.entries.suffix(3).reversed()), id: \.id) { e in
                            CompactRecentRow(entry: e)
                        }
                    }
                }
            }
            .padding()
        }
        .overlay(alignment: .top) {
            if showSavedToast {
                Text("Сохранено")
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(.ultraThinMaterial, in: Capsule())
                    .overlay(Capsule().stroke(palette.accent.opacity(0.5), lineWidth: 1))
                    .padding(.top, 8)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .onChange(of: showSavedToast) { new in
            if new {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                    withAnimation { showSavedToast = false }
                }
            }
        }
    }

    private func last7Entries() -> [MoodEntry] {
        let cal = Calendar.current
        let start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: Date()))!
        return store.entries.filter { $0.date >= start }.sorted { $0.date < $1.date }
    }

    private func saveCurrent() {
        vm.fineAdd(value: Int(sliderValue.rounded()), note: nil, emotion: nil)
        Haptics.fire(.success)
        withAnimation { showSavedToast = true }
    }

    // Fixed mapping 4 emotions -> specific 0..100 values
    private func fixedValue(for emotion: Emotion) -> Int {
        switch emotion {
        case .joy: return 95    // ярко-позитивное
        case .anxiety: return 65 // повышенное напряжение
        case .anger: return 35   // негатив в нижней половине
        case .sadness: return 5  // выраженно низкое
        }
    }
}

// MARK: - Emotion Grid (4 buttons)
private struct EmotionGrid: View {
    let onSelect: (Emotion) -> Void
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 2), spacing: 12) {
            EmotionButton(title: "Радость", systemImage: "face.smiling", color: .yellow, action: { onSelect(.joy) })
            EmotionButton(title: "Тревога", systemImage: "exclamationmark.triangle.fill", color: .orange, action: { onSelect(.anxiety) })
            EmotionButton(title: "Злость", systemImage: "flame.fill", color: .red, action: { onSelect(.anger) })
            EmotionButton(title: "Грусть", systemImage: "cloud.rain.fill", color: .blue, action: { onSelect(.sadness) })
        }
    }
}

private struct EmotionButton: View {
    let title: String
    let systemImage: String
    let color: Color
    let action: () -> Void
    @State private var pulse: Bool = false
    var body: some View {
        Button(action: {
            // Fire ripple/pulse alongside the action
            pulse = false
            withAnimation(.easeOut(duration: 0.32)) { pulse = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.36) { pulse = false }
            action()
        }) {
            HStack(spacing: 10) {
                Image(systemName: systemImage).font(.title2)
                Text(title).font(.headline)
                Spacer()
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(color.opacity(0.12))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(color.opacity(0.45), lineWidth: 1)
            )
            .overlay(alignment: .center) {
                Circle()
                    .fill(color.opacity(0.25))
                    .frame(width: 10, height: 10)
                    .scaleEffect(pulse ? 3.2 : 0.6)
                    .opacity(pulse ? 0.0 : 1.0)
                    .allowsHitTesting(false)
            }
        }
        .buttonStyle(PressableButtonStyle(scale: 0.94, highlight: color))
        .contentShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Refine Section
private struct RefineSection: View {
    @Environment(\.themePalette) private var palette
    @Binding var isExpanded: Bool
    @Binding var sliderValue: Double
    let onSave: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Button {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.9)) { isExpanded.toggle() }
            } label: {
                HStack {
                    Text("Уточнить")
                    Spacer()
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                }
                .padding(12)
            }
            .buttonStyle(PressableButtonStyle(scale: 0.97))
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(palette.accent.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(palette.accent.opacity(0.35), lineWidth: 1)
            )

            if isExpanded {
                VStack(spacing: 10) {
                    HStack {
                        Text("Точное значение")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Spacer()
                        Text("\(Int(sliderValue))/100").monospacedDigit().bold()
                    }
                    Slider(value: $sliderValue, in: 0...100, step: 1)
                    HStack {
                        Spacer()
                        Button("Сохранить") { onSave() }
                            .buttonStyle(.borderedProminent)
                    }
                }
                .padding(12)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

// MARK: - Compact Recent Row
private struct CompactRecentRow: View {
    let entry: MoodEntry
    var body: some View {
        HStack(spacing: 10) {
            Text(entry.emoji).font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.emotion?.display ?? "").font(.subheadline)
                Text(entry.date, style: .time).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Text("\(entry.value)")
                .font(.subheadline).monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .padding(10)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}

// MARK: - Tiny Sparkline (no Charts dependency)
private struct MiniChartView: View {
    @Environment(\.themePalette) private var palette
    let entries: [MoodEntry]
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let vals = entries.isEmpty ? [50.0, 50.0, 50.0] : entries.map { Double($0.value) }
            let minV = max(0.0, (vals.min() ?? 0))
            let maxV = min(100.0, (vals.max() ?? 100))
            let span = max(1.0, maxV - minV)

            // Line path
            let line = Path { p in
                for (i, v) in vals.enumerated() {
                    let x = CGFloat(Double(i) / Double(max(vals.count - 1, 1))) * w
                    let y = h - CGFloat((v - minV) / span) * h
                    if i == 0 { p.move(to: CGPoint(x: x, y: y)) } else { p.addLine(to: CGPoint(x: x, y: y)) }
                }
            }

            // Fill area beneath
            let area = Path { p in
                for (i, v) in vals.enumerated() {
                    let x = CGFloat(Double(i) / Double(max(vals.count - 1, 1))) * w
                    let y = h - CGFloat((v - minV) / span) * h
                    if i == 0 { p.move(to: CGPoint(x: x, y: y)) } else { p.addLine(to: CGPoint(x: x, y: y)) }
                }
                p.addLine(to: CGPoint(x: w, y: h))
                p.addLine(to: CGPoint(x: 0, y: h))
                p.closeSubpath()
            }

            ZStack {
                area
                    .fill(palette.state.chart.line.opacity(0.12))
                line
                    .strokedPath(.init(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .fill(palette.state.chart.line)

                // Burst markers: phasic emotions or large deltas
                let threshold: Double = 14
                ForEach(Array(entries.enumerated()), id: \.offset) { idx, e in
                    let prev = idx > 0 ? Double(entries[idx - 1].value) : nil
                    let isBurst = (e.emotion?.function == .phasic) || (prev != nil && abs(Double(e.value) - prev!) >= threshold)
                    if isBurst {
                        let x = CGFloat(Double(idx) / Double(max(vals.count - 1, 1))) * w
                        let y = h - CGFloat((Double(e.value) - minV) / span) * h
                        Circle()
                            .fill(palette.state.chart.phasic)
                            .frame(width: 6, height: 6)
                            .position(x: x, y: y)
                    }
                }
            }
        }
    }
}
