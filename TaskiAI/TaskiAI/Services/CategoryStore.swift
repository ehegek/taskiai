import Foundation
import SwiftData

@MainActor
final class CategoryStore: ObservableObject {
    static let shared = CategoryStore()

    func ensureDefaults(in context: ModelContext) {
        let fetch = FetchDescriptor<Category>()
        if let count = try? context.fetch(fetch).count, count == 0 {
            context.insert(Category(name: "Personal", icon: "person"))
            context.insert(Category(name: "Work", icon: "briefcase"))
            try? context.save()
        }
    }

    func all(in context: ModelContext) -> [Category] {
        (try? context.fetch(FetchDescriptor<Category>())) ?? []
    }

    func add(name: String, icon: String? = nil, in context: ModelContext) -> Category {
        let c = Category(name: name, icon: icon)
        context.insert(c)
        try? context.save()
        return c
    }
}
