import SwiftUI
import SwiftData
// import PhotosUI  // Temporarily disabled
import UIKit

struct TaskDetailView: View, Identifiable {
    var id: UUID { task.id }
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: Task
    @Query private var categories: [Category]

    @State private var repeatOn: Bool = false
    @State private var reminderOn: Bool = false
    // @State private var photoItems: [PhotosPickerItem] = []

    init(task: Task) { self.task = task; _repeatOn = State(initialValue: task.repeatRule.frequency != .none); _reminderOn = State(initialValue: task.reminderEnabled) }

    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            Form {
                TextField("Enter task name", text: $task.title)
                DatePicker("Date", selection: $task.date, displayedComponents: [.date, .hourAndMinute])
                
                Picker("Category", selection: Binding(
                    get: { task.category?.id ?? UUID() },
                    set: { id in task.category = categories.first(where: { $0.id == id }); try? context.save() }
                )) {
                    Text("None").tag(UUID())
                    ForEach(categories) { cat in
                        Label(cat.name, systemImage: cat.icon ?? "folder.fill").tag(cat.id)
                    }
                }
                
                Toggle("Repeat", isOn: Binding(get: { repeatOn }, set: { repeatOn = $0; task.repeatRule.frequency = $0 ? .daily : .none }))
                Toggle("Reminder", isOn: Binding(get: { reminderOn }, set: { reminderOn = $0; task.reminderEnabled = $0 }))
                if reminderOn {
                    Picker("Channels", selection: Binding(get: { task.reminderChannels.first ?? .appPush }, set: { task.reminderChannels = [$0]; try? context.save() })) {
                        ForEach(ReminderChannel.allCases) { ch in Text(ch.displayName).tag(ch) }
                    }
                }
                Section("Details (optional)") {
                    TextField("Notes", text: Binding(get: { task.notes ?? "" }, set: { task.notes = $0 }), axis: .vertical)
                }
            }
            .scrollContentBackground(.hidden)
            .onDisappear { try? context.save() }
        }
        .safeAreaInset(edge: .top) {
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.primary)
                }
                Spacer()
                Text("Details")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Button { try? context.save(); dismiss() } label: {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 28))
                        .foregroundStyle(.blue)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color(.systemBackground).ignoresSafeArea(edges: .top))
        }
        .navigationBarHidden(true)
    }

    // MARK: - Import (temporarily disabled)
    
    // private func importPhotos() async {
    //     for item in photoItems {
    //         if let data = try? await item.loadTransferable(type: Data.self), let img = UIImage(data: data) {
    //             if let id = ImageStore.save(img) {
    //                 task.imageIDs.append(id)
    //             }
    //         }
    //     }
    //     photoItems.removeAll()
    //     try? context.save()
    // }
}

