//
//  ContentView.swift
//  CarsheringServiceClean
//
//  Created by Roman on 03.11.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            OnBoardingView(isPresented: $authManager.isOnBoardingPresented)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthMasnager())
}
