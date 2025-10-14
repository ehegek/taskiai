import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Query private var categories: [Category]
    @State private var newCategoryName = ""
    @State private var showAddCategory = false
    @State private var selectedIcon = "folder.fill"
    
    private let availableIcons = [
        "folder.fill", "tag.fill", "briefcase.fill", "house.fill",
        "cart.fill", "heart.fill", "star.fill", "flag.fill",
        "bookmark.fill", "paperclip", "lightbulb.fill", "graduationcap.fill"
    ]
    
    var body: some View {
        ZStack {
            Color(.systemBackground).ignoresSafeArea()
            
            GeometryReader { geo in
                ScrollView {
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.top + 1, 50))
                        
                        HStack {
                            Button { dismiss() } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(.primary)
                            }
                            Spacer()
                            Text("Categories")
                                .font(.system(size: 20, weight: .bold))
                            Spacer()
                            Button { showAddCategory = true } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 28))
                                    .foregroundStyle(.blue)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(categories) { category in
                                categoryRow(category)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                        
                        Spacer()
                            .frame(height: max(geo.safeAreaInsets.bottom + 20, 40))
                    }
                }
                .scrollIndicators(.hidden)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddCategory) {
            addCategorySheet
        }
    }
    
    private func categoryRow(_ category: Category) -> some View {
        HStack(spacing: 16) {
            Image(systemName: category.icon ?? "folder.fill")
                .font(.system(size: 24))
                .foregroundStyle(.blue)
                .frame(width: 40, height: 40)
                .background(Circle().fill(Color.blue.opacity(0.1)))
            
            Text(category.name)
                .font(.system(size: 17, weight: .medium))
                .foregroundStyle(.primary)
            
            Spacer()
            
            Button {
                context.delete(category)
                try? context.save()
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 18))
                    .foregroundStyle(.red)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(.systemGray6))
        )
    }
    
    private var addCategorySheet: some View {
        NavigationView {
            VStack(spacing: 24) {
                Text("New Category")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top, 20)
                
                // Icon Picker
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 16) {
                    ForEach(availableIcons, id: \.self) { icon in
                        Button {
                            selectedIcon = icon
                        } label: {
                            Image(systemName: icon)
                                .font(.system(size: 28))
                                .foregroundStyle(selectedIcon == icon ? .white : .blue)
                                .frame(width: 60, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(selectedIcon == icon ? Color.blue : Color.blue.opacity(0.1))
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Name Input
                TextField("Category name", text: $newCategoryName)
                    .font(.system(size: 17))
                    .padding(.vertical, 14)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // Add Button
                Button {
                    guard !newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
                    let category = Category(name: newCategoryName.trimmingCharacters(in: .whitespacesAndNewlines), icon: selectedIcon)
                    context.insert(category)
                    try? context.save()
                    newCategoryName = ""
                    selectedIcon = "folder.fill"
                    showAddCategory = false
                } label: {
                    Text("Add Category")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.blue))
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        newCategoryName = ""
                        selectedIcon = "folder.fill"
                        showAddCategory = false
                    }
                }
            }
        }
    }
}
