import Foundation
// TODO: Add Firebase SDK via SPM, then uncomment
// import FirebaseFirestore

#if canImport(FirebaseFirestore)
import FirebaseFirestore

struct UserData: Codable {
    var userId: String
    var email: String?
    var name: String?
    var referralCode: String
    var referredBy: String?
    var referralCount: Int
    var streakDays: Int
    var lastTaskDate: Date?
    var hasActiveSubscription: Bool
    var createdAt: Date
    var updatedAt: Date
}

struct TaskData: Codable {
    var id: String
    var userId: String
    var title: String
    var notes: String?
    var date: Date
    var isCompleted: Bool
    var categoryName: String?
    var reminderEnabled: Bool
    var reminderChannels: [String]
    var reminderTime: Date?
    var createdAt: Date
    var updatedAt: Date
}

final class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    private let db = Firestore.firestore()
    
    private init() {}
    
    // MARK: - User Management
    
    func createUser(userId: String, email: String?, name: String?) async throws {
        let referralCode = generateReferralCode()
        let userData = UserData(
            userId: userId,
            email: email,
            name: name,
            referralCode: referralCode,
            referredBy: nil,
            referralCount: 0,
            streakDays: 0,
            lastTaskDate: nil,
            hasActiveSubscription: false,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try await db.collection("users").document(userId).setData([
            "userId": userData.userId,
            "email": userData.email ?? "",
            "name": userData.name ?? "",
            "referralCode": userData.referralCode,
            "referralCount": userData.referralCount,
            "streakDays": userData.streakDays,
            "hasActiveSubscription": userData.hasActiveSubscription,
            "createdAt": Timestamp(date: userData.createdAt),
            "updatedAt": Timestamp(date: userData.updatedAt)
        ])
    }
    
    func getUser(userId: String) async throws -> UserData? {
        let snapshot = try await db.collection("users").document(userId).getDocument()
        guard let data = snapshot.data() else { return nil }
        
        return UserData(
            userId: data["userId"] as? String ?? userId,
            email: data["email"] as? String,
            name: data["name"] as? String,
            referralCode: data["referralCode"] as? String ?? "",
            referredBy: data["referredBy"] as? String,
            referralCount: data["referralCount"] as? Int ?? 0,
            streakDays: data["streakDays"] as? Int ?? 0,
            lastTaskDate: (data["lastTaskDate"] as? Timestamp)?.dateValue(),
            hasActiveSubscription: data["hasActiveSubscription"] as? Bool ?? false,
            createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
            updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
        )
    }
    
    func updateUser(userId: String, fields: [String: Any]) async throws {
        var updatedFields = fields
        updatedFields["updatedAt"] = Timestamp(date: Date())
        try await db.collection("users").document(userId).updateData(updatedFields)
    }
    
    // MARK: - Referral System
    
    func applyReferralCode(_ code: String, toUser userId: String) async throws -> Bool {
        // Find the referrer
        let query = db.collection("users").whereField("referralCode", isEqualTo: code)
        let snapshot = try await query.getDocuments()
        
        guard let referrerDoc = snapshot.documents.first else {
            return false // Invalid referral code
        }
        
        let referrerId = referrerDoc.documentID
        
        // Update current user with referredBy
        try await updateUser(userId: userId, fields: ["referredBy": referrerId])
        
        // Increment referrer's count
        let referrerData = referrerDoc.data()
        let currentCount = referrerData["referralCount"] as? Int ?? 0
        try await updateUser(userId: referrerId, fields: ["referralCount": currentCount + 1])
        
        return true
    }
    
    func getReferralStats(userId: String) async throws -> (code: String, count: Int) {
        guard let userData = try await getUser(userId: userId) else {
            throw NSError(domain: "Firestore", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])
        }
        return (userData.referralCode, userData.referralCount)
    }
    
    // MARK: - Task Sync
    
    func syncTask(userId: String, task: TaskData) async throws {
        try await db.collection("users").document(userId)
            .collection("tasks").document(task.id).setData([
                "id": task.id,
                "userId": task.userId,
                "title": task.title,
                "notes": task.notes ?? "",
                "date": Timestamp(date: task.date),
                "isCompleted": task.isCompleted,
                "categoryName": task.categoryName ?? "",
                "reminderEnabled": task.reminderEnabled,
                "reminderChannels": task.reminderChannels,
                "reminderTime": task.reminderTime != nil ? Timestamp(date: task.reminderTime!) : NSNull(),
                "createdAt": Timestamp(date: task.createdAt),
                "updatedAt": Timestamp(date: task.updatedAt)
            ], merge: true)
    }
    
    func getTasks(userId: String) async throws -> [TaskData] {
        let snapshot = try await db.collection("users").document(userId)
            .collection("tasks").getDocuments()
        
        return snapshot.documents.compactMap { doc in
            let data = doc.data()
            return TaskData(
                id: data["id"] as? String ?? doc.documentID,
                userId: data["userId"] as? String ?? userId,
                title: data["title"] as? String ?? "",
                notes: data["notes"] as? String,
                date: (data["date"] as? Timestamp)?.dateValue() ?? Date(),
                isCompleted: data["isCompleted"] as? Bool ?? false,
                categoryName: data["categoryName"] as? String,
                reminderEnabled: data["reminderEnabled"] as? Bool ?? false,
                reminderChannels: data["reminderChannels"] as? [String] ?? [],
                reminderTime: (data["reminderTime"] as? Timestamp)?.dateValue(),
                createdAt: (data["createdAt"] as? Timestamp)?.dateValue() ?? Date(),
                updatedAt: (data["updatedAt"] as? Timestamp)?.dateValue() ?? Date()
            )
        }
    }
    
    // MARK: - Streak Management
    
    func updateStreak(userId: String, streakDays: Int, lastTaskDate: Date) async throws {
        try await updateUser(userId: userId, fields: [
            "streakDays": streakDays,
            "lastTaskDate": Timestamp(date: lastTaskDate)
        ])
    }
    
    // MARK: - Helper
    
    private func generateReferralCode() -> String {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<8).map { _ in letters.randomElement()! })
    }
}

#else

// Stub implementations when Firebase is not available
struct UserData: Codable {
    var userId: String
    var email: String?
    var name: String?
    var referralCode: String
    var referredBy: String?
    var referralCount: Int
    var streakDays: Int
    var lastTaskDate: Date?
    var hasActiveSubscription: Bool
    var createdAt: Date
    var updatedAt: Date
}

struct TaskData: Codable {
    var id: String
    var userId: String
    var title: String
    var notes: String?
    var date: Date
    var isCompleted: Bool
    var categoryName: String?
    var reminderEnabled: Bool
    var reminderChannels: [String]
    var reminderTime: Date?
    var createdAt: Date
    var updatedAt: Date
}

final class FirestoreService: ObservableObject {
    static let shared = FirestoreService()
    private init() {}
    
    func createUser(userId: String, email: String?, name: String?) async throws {}
    func getUser(userId: String) async throws -> UserData? { return nil }
    func updateUser(userId: String, fields: [String: Any]) async throws {}
    func applyReferralCode(_ code: String, toUser userId: String) async throws -> Bool { return false }
    func getReferralStats(userId: String) async throws -> (code: String, count: Int) { return ("STUB1234", 0) }
    func syncTask(userId: String, task: TaskData) async throws {}
    func getTasks(userId: String) async throws -> [TaskData] { return [] }
    func updateStreak(userId: String, streakDays: Int, lastTaskDate: Date) async throws {}
}

#endif
