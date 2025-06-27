//
//  ScannerSheetView.swift
//  Vitally
//
//  Created by andrew austin on 5/15/24.
//

import SwiftUI
import SwiftData

struct ScannerSheetView: View {
    @Query(sort: \UserList.lastModified, order: .reverse) private var lists: [UserList]
    @Environment(\.modelContext) private var modelContext
    var product: Product
    var onDismiss: () -> Void
    
    @State private var showCreateList = false
    @State private var showSuccessAlert = false
    @State private var addedToListName = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Product header
                productHeader
                
                // Quick add section
                quickAddSection
                
                // Lists section
                if lists.isEmpty {
                    emptyStateView
                } else {
                    listsSection
                }
            }
            .navigationTitle("Quick Add")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onDismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showCreateList = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $showCreateList) {
                CreateListView(isPresented: $showCreateList, product: product)
            }
            .alert("Added to List", isPresented: $showSuccessAlert) {
                Button("OK") {
                    onDismiss()
                }
            } message: {
                Text("\(product.displayName) added to \(addedToListName)")
            }
        }
    }
    
    private var productHeader: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                ImageLoaderView(urlString: product.imageURL)
                    .frame(width: 80, height: 80)
                    .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(product.displayName)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Text(product.displayBrands)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                    
                    HStack(spacing: 8) {
                        Image(nutriScoreImageName(for: product.displayNutritionGrades))
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        
                        if let novaGroup = product.nutriments.novaGroup {
                            Image(novaScoreImageName(for: Int(novaGroup)))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                        
                        if let ecoscoreGrade = product.ecoscoreGrade {
                            Image(ecoScoreImageName(for: ecoscoreGrade))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 25)
                        }
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            Divider()
        }
        .background(Color(UIColor.secondarySystemBackground))
    }
    
    private var quickAddSection: some View {
        VStack(spacing: 12) {
            Text("Quick Add to Recent Lists")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(lists.prefix(3))) { list in
                        QuickAddButton(list: list) {
                            addToQuickList(list: list)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Divider()
        }
        .padding(.vertical, 8)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "list.bullet.rectangle")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Lists Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Create your first list to start organizing products")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                showCreateList = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Create First List")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
    
    private var listsSection: some View {
        List {
            ForEach(lists) { list in
                QuickListRowView(list: list) {
                    addToQuickList(list: list)
                }
            }
        }
        .listStyle(.plain)
    }
    
    private func addToQuickList(list: UserList) {
        let historyItem = UserHistory(product: product)
        list.items.append(historyItem)
        list.updateLastModified()
        
        addedToListName = list.name
        showSuccessAlert = true
    }
    
    // Helper functions for score images
    private func nutriScoreImageName(for grade: String) -> String {
        return "nutri-score-\(grade.lowercased())"
    }
    
    private func novaScoreImageName(for group: Int) -> String {
        return "nova-group-\(group)"
    }
    
    private func ecoScoreImageName(for grade: String) -> String {
        return "eco-grade-\(grade.lowercased())"
    }
}

struct QuickAddButton: View {
    let list: UserList
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .medium))
                }
                
                Text(list.name)
                    .font(.caption)
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .frame(maxWidth: 80)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        switch list.category?.lowercased() {
        case "shopping":
            return "cart"
        case "favorites":
            return "heart"
        case "meal plan":
            return "fork.knife"
        case "avoid":
            return "xmark.shield"
        default:
            return "list.bullet"
        }
    }
    
    private var iconBackgroundColor: Color {
        switch list.category?.lowercased() {
        case "shopping":
            return .blue
        case "favorites":
            return .red
        case "meal plan":
            return .green
        case "avoid":
            return .orange
        default:
            return .gray
        }
    }
}

struct QuickListRowView: View {
    let list: UserList
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            HStack(spacing: 16) {
                // List icon
                ZStack {
                    Circle()
                        .fill(iconBackgroundColor)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: iconName)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(list.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    if let description = list.listDescription, !description.isEmpty {
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    HStack {
                        if let category = list.category, !category.isEmpty {
                            Text(category)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                                .background(categoryColor(for: category))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                        
                        Text("\(list.uniqueItemCount) items")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Image(systemName: "plus.circle")
                    .foregroundColor(.blue)
                    .font(.title2)
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var iconName: String {
        switch list.category?.lowercased() {
        case "shopping":
            return "cart"
        case "favorites":
            return "heart"
        case "meal plan":
            return "fork.knife"
        case "avoid":
            return "xmark.shield"
        default:
            return "list.bullet"
        }
    }
    
    private var iconBackgroundColor: Color {
        switch list.category?.lowercased() {
        case "shopping":
            return .blue
        case "favorites":
            return .red
        case "meal plan":
            return .green
        case "avoid":
            return .orange
        default:
            return .gray
        }
    }
    
    private func categoryColor(for category: String) -> Color {
        switch category.lowercased() {
        case "shopping":
            return .blue
        case "favorites":
            return .red
        case "meal plan":
            return .green
        case "avoid":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    ScannerSheetView(product: Product.mockProduct) {
        // Dismiss action
    }
}
