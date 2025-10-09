import SwiftUI
import SwiftData
// import PhotosUI  // Temporarily disabled
import UIKit

struct TaskDetailView: View, Identifiable {
    var id: UUID { task.id }
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var task: Task

    @State private var repeatOn: Bool = false
    @State private var reminderOn: Bool = false
    // @State private var photoItems: [PhotosPickerItem] = []

    init(task: Task) { self.task = task; _repeatOn = State(initialValue: task.repeatRule.frequency != .none); _reminderOn = State(initialValue: task.reminderEnabled) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(.systemBackground).ignoresSafeArea(.all, edges: .all)
                Form {
                    TextField("Enter task name", text: $task.title)
                    DatePicker("Date", selection: $task.date, displayedComponents: [.date, .hourAndMinute])
                    Toggle("Repeat", isOn: Binding(get: { repeatOn }, set: { repeatOn = $0; task.repeatRule.frequency = $0 ? .daily : .none }))
                    Toggle("Reminder", isOn: Binding(get: { reminderOn }, set: { reminderOn = $0; task.reminderEnabled = $0 }))
                    if reminderOn {
                        Picker("Channels", selection: Binding(get: { task.reminderChannels.first ?? .appPush }, set: { task.reminderChannels = [$0]; try? context.save() })) {
                            ForEach(ReminderChannel.allCases) { ch in Text(String(describing: ch.rawValue)).tag(ch) }
                        }
                    }
                    Section("Details (optional)") {
                        TextField("Notes", text: Binding(get: { task.notes ?? "" }, set: { task.notes = $0 }), axis: .vertical)
                    }
                }
                .scrollContentBackground(.hidden)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button { dismiss() } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button { try? context.save(); dismiss() } label: {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 20, weight: .semibold))
                        }
                    }
                }
                .navigationTitle("Details")
                .onDisappear { try? context.save() }
            }
            .safeAreaInset(edge: .bottom) {
                Button {
                    try? context.save();
                    dismiss()
                } label: {
                    Text("Done")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.black))
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, geo.safeAreaInsets.bottom + 8)
            }
        }
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

