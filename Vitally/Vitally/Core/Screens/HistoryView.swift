//
//  HistoryView.swift
//  Vitally
//
//  Created by andrew austin on 5/13/24.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        NavigationStack {
            List {
                
            }
        }
        .navigationTitle("History")
    }
}

#Preview {
    NavigationStack {
        HistoryView()
            .environmentObject(AuthViewModel())
    }
}
