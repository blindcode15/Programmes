import SwiftUI

struct DiaryEntryRow: View {
    let entry: DiaryEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.title)
                .font(.headline)
            Text(entry.content)
                .font(.body)
                .lineLimit(2)
                .foregroundColor(.secondary)
            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 2)
    }
}

struct DiaryEntryRow_Previews: PreviewProvider {
    static var previews: some View {
        DiaryEntryRow(entry: DiaryEntry(title: "Sample Entry", content: "This is a sample diary entry content."))
            .previewLayout(.sizeThatFits)
    }
}