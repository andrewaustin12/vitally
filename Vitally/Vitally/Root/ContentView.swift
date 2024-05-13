//
//  ContentView.swift
//  Vitally
//
//  Created by andrew austin on 5/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authVM: AuthViewModel
    
    var body: some View {
        Group {
            if authVM.userSession != nil {
                MainTab() 
            } else {
                LoginView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(AuthViewModel())
    }
}
