import XCTest
@testable import TaskiAI

final class TaskiAITests: XCTestCase {
    func testTaskInit() throws {
        let t = Task(title: "Meeting", date: Date())
        XCTAssertEqual(t.title, "Meeting")
        XCTAssertFalse(t.isCompleted)
    }
}
