import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject private var store: MoodStore
    @EnvironmentObject private var vm: ChartsViewModel

    var body: some View {
        VStack(spacing: 12) {
            Picker("Range", selection: $vm.selected) {
                ForEach(ChartsViewModel.Range.allCases, id: \.self) { r in
                    Text(r.rawValue).tag(r)
                }
            }
            .pickerStyle(.segmented)

            HStack(spacing: 8) {
                StatPill(title: "Avg", value: vm.avg.isNaN ? "–" : String(format: "%.1f", vm.avg))
                StatPill(title: "Median", value: vm.median.isNaN ? "–" : String(format: "%.1f", vm.median))
                StatPill(title: "Min", value: "\(vm.minValue)")
                StatPill(title: "Max", value: "\(vm.maxValue)")
            }

            Chart(vm.series()) {
                LineMark(
                    x: .value("Date", $0.date),
                    y: .value("Value", $0.value)
                )
                PointMark(
                    x: .value("Date", $0.date),
                    y: .value("Value", $0.value)
                )
            }
            .frame(height: 220)
            .chartYScale(domain: 0...10)

            // Heatmap stub (can be extended)
            Text("Heatmap by hour")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            HeatmapView(entries: store.entries)
                .frame(height: 180)
        }
        .padding()
    }
}

struct HeatmapView: View {
    let entries: [MoodEntry]
    var body: some View {
        let cal = Calendar.current
        let grouped = Dictionary(grouping: entries) { (e: MoodEntry) in
            (cal.component(.weekday, from: e.date), cal.component(.hour, from: e.date))
        }
        GeometryReader { geo in
            let cols = 24
            let rows = 7
            let cellW = geo.size.width / CGFloat(cols)
            let cellH = geo.size.height / CGFloat(rows)
            ZStack(alignment: .topLeading) {
                ForEach(0..<rows, id: \.self) { r in
                    ForEach(0..<cols, id: \.self) { c in
                        let key = (r+1, c) // weekday 1..7, hour 0..23
                        let vals = grouped[key]?.map{ $0.value } ?? []
                        let avg = vals.isEmpty ? 0 : Double(vals.reduce(0,+))/Double(vals.count)
                        Rectangle()
                            .fill(Color(hue: avg/10 * 0.33, saturation: 0.7, brightness: 0.8, opacity: vals.isEmpty ? 0.08 : 0.7))
                            .frame(width: cellW-2, height: cellH-2)
                            .position(x: CGFloat(c)*cellW + cellW/2, y: CGFloat(r)*cellH + cellH/2)
                    }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}
