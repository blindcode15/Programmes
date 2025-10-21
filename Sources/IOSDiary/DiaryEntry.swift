import Foundation

struct DiaryEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let title: String
    let content: String
    
    init(title: String, content: String, date: Date = Date()) {
        self.title = title
        self.content = content
        self.date = date
    }
}