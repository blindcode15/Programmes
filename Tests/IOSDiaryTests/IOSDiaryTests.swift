import XCTest
@testable import IOSDiary

final class IOSDiaryTests: XCTestCase {
    func testDiaryEntryCreation() {
        let entry = DiaryEntry(title: "Test Entry", content: "Test content")
        
        XCTAssertEqual(entry.title, "Test Entry")
        XCTAssertEqual(entry.content, "Test content")
        XCTAssertNotNil(entry.id)
    }
    
    func testDiaryEntryWithCustomDate() {
        let customDate = Date(timeIntervalSince1970: 1000)
        let entry = DiaryEntry(title: "Test", content: "Content", date: customDate)
        
        XCTAssertEqual(entry.date, customDate)
    }
}