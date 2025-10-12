import Foundation
import SwiftData

enum ReminderChannel: String, Codable, CaseIterable, Identifiable {
    case appPush, phoneCall, sms, chat, email
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .appPush: return "App Notification"
        case .phoneCall: return "Phone Call"
        case .sms: return "SMS"
        case .chat: return "Chat"
        case .email: return "Email"
        }
    }
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
    // Store codable values as Data to avoid transformable compiler issues on CI
    @Attribute var reminderChannelsBlob: Data? = nil
    var reminderChannels: [ReminderChannel] {
        get {
            guard let data = reminderChannelsBlob, let val = try? JSONDecoder().decode([ReminderChannel].self, from: data) else { return [] }
            return val
        }
        set {
            reminderChannelsBlob = try? JSONEncoder().encode(newValue)
        }
    }
    var reminderTime: Date?
    @Attribute var repeatRuleBlob: Data? = nil
    var repeatRule: RepeatRule {
        get {
            guard let data = repeatRuleBlob, let val = try? JSONDecoder().decode(RepeatRule.self, from: data) else { return RepeatRule() }
            return val
        }
        set {
            repeatRuleBlob = try? JSONEncoder().encode(newValue)
        }
    }
    @Attribute var imageIDsBlob: Data? = nil
    var imageIDs: [UUID] {
        get {
            guard let data = imageIDsBlob, let val = try? JSONDecoder().decode([UUID].self, from: data) else { return [] }
            return val
        }
        set {
            imageIDsBlob = try? JSONEncoder().encode(newValue)
        }
    }

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
