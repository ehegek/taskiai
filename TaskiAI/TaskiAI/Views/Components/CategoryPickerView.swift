import SwiftUI
import SwiftData

struct CategoryPickerView: View {
    @Environment(\.modelContext) private var context
    @Binding var selection: Category?

    @State private var showAdd = false
    @State private var newName = ""

    var body: some View {
        Menu {
            Button("All") { selection = nil }
            Divider()
            ForEach(categories) { cat in
                Button(cat.name) { selection = cat }
            }
            Divider()
            Button { showAdd = true } label: { Label("Add New", systemImage: "plus") }
        } label: {
            HStack { Text(selection?.name ?? "All"); Image(systemName: "chevron.down") }
                .padding(8)
                .background(RoundedRectangle(cornerRadius: 8).stroke())
        }
        .onAppear { CategoryStore.shared.ensureDefaults(in: context) }
        .alert("New Category", isPresented: $showAdd) {
            TextField("Name", text: $newName)
            Button("Cancel", role: .cancel) {}
            Button("Add") { if !newName.isEmpty { selection = CategoryStore.shared.add(name: newName, in: context); newName = "" } }
        }
    }

    private var categories: [Category] { CategoryStore.shared.all(in: context) }
}
