import Foundation
import SwiftData

enum ReminderChannel: String, Codable, CaseIterable, Identifiable {
    case appPush, phoneCall, sms, chat, email
    var id: String { rawValue }
}

enum RepeatFrequency: String, Codable, CaseIterable, Identifiable {
    case none, daily, weekly, monthly, yearly
    var id: String { rawValue }
}

struct RepeatRule: Codable, Hashable {
    var frequency: RepeatFrequency = .none
    var interval: Int = 1 // every n units
    var endDate: Date? = nil // nil = never
}

@Model
final class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var icon: String?

    init(id: UUID = UUID(), name: String, icon: String? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

@Model
final class Task: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var notes: String?
    var date: Date
    var isCompleted: Bool
    var category: Category?
    var reminderEnabled: Bool
    @Attribute(.transformable) var reminderChannels: [ReminderChannel] = []
    var reminderTime: Date?
    @Attribute(.transformable) var repeatRule: RepeatRule = RepeatRule()
    @Attribute(.transformable) var imageIDs: [UUID] = []

    init(id: UUID = UUID(),
         title: String,
         notes: String? = nil,
         date: Date = .now,
         isCompleted: Bool = false,
         category: Category? = nil,
         reminderEnabled: Bool = false,
         reminderChannels: [ReminderChannel] = [],
         reminderTime: Date? = nil,
         repeatRule: RepeatRule = RepeatRule(),
         imageIDs: [UUID] = []) {
        self.id = id
        self.title = title
        self.notes = notes
        self.date = date
        self.isCompleted = isCompleted
        self.category = category
        self.reminderEnabled = reminderEnabled
        self.reminderChannels = reminderChannels
        self.reminderTime = reminderTime
        self.repeatRule = repeatRule
        self.imageIDs = imageIDs
    }
}
