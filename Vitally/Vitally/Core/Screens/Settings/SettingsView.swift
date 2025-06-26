//
//  SettingsView.swift
//  ScubaCashing
//
//  Created by andrew austin on 5/12/24.
//

import SwiftUI

struct SettingsView: View {
    @State private var isClearingData = false
    @State private var initials = "AA"
    @State private var username = "User"
    @State private var email = "user@vitally.app"
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Text(initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemTeal))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(username)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(email)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                    }
                }
                
                Section("General") {
                    
                    NavigationLink(destination: FoodPreferencesView()) {
                        HStack {
                            SettingsRowView(imageName: "takeoutbag.and.cup.and.straw", title: "Food Preferences", tintColor: Color(.systemTeal))
                            Spacer()
                        }
                    }
                    
                    HStack {
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("1.0.0")
                            .font(.headline)
                            .foregroundStyle(.gray)
                    }
                    
                }
                
                Section("Data") {
                    
                    Button {
                        isClearingData = true
                    } label: {
                        SettingsRowView(imageName: "trash", title: "Clear All Data", tintColor: .red)
                    }
                    .alert("Clear All Data", isPresented: $isClearingData) {
                        Button("Cancel", role: .cancel) { }
                        Button("Clear All", role: .destructive) {
                            // TODO: Implement clear all data functionality
                        }
                    } message: {
                        Text("This will delete all your history, lists, and preferences. This action cannot be undone.")
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
