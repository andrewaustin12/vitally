//
//  SettingsView.swift
//  ScubaCashing
//
//  Created by andrew austin on 5/12/24.
//

import SwiftUI


struct SettingsView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var isSigningOut = false
    @State private var isDeletingAccount = false // Add this state variable

    var body: some View {
        NavigationStack {
            if let user = viewModel.currentUser {
                List {
                    Section {
                        HStack {
                            Text(user.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(user.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    
                    Section("General") {
                        
                        HStack {
                            SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            Text("1.0.0")
                                .font(.headline)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                    
                    Section("Account") {
                        
                        Button {
                            isSigningOut = true
                        } label: {
                            SettingsRowView(imageName: "person.crop.circle.badge.xmark", title: "Sign out", tintColor: .blue)
                        }
                        .alert("Sign Out", isPresented: $isSigningOut) {
                            Button("Cancel", role: .cancel) { }
                            Button("Sign Out", role: .destructive) {
                                viewModel.signOut()
                            }
                        } message: {
                            Text("Are you sure you want to sign out?")
                        }


                        
                        Button {
                            isDeletingAccount = true
                        } label: {
                            SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: .red)
                        }
                    }
                }
                .alert(isPresented: $isDeletingAccount) {
                    Alert(
                        title: Text("Delete Account?"),
                        message: Text("This will delete the user and all of its data. Are you sure you want to continue?"),
                        primaryButton: .default(Text("Confirm")) {
                            Task {
                                await viewModel.deleteUser()
                            }
                        },
                        secondaryButton: .cancel(Text("Cancel"))
                    )
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
