//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var connected: Bool = false
    var body: some View {
        if viewModel.userSession == nil {
            MatchingCodeView(user: User(uuid: "", userId: "", isConnected: false))
                .onAppear {
                    viewModel.registerUser { _ in
                        
                    }
                }
        } else {
            if let user = viewModel.user {
                if !connected {
                    MatchingCodeView(user: user)
                        .onChange(of: user.isConnected) { _ in
                            connected = true
                        }
                } else {
                    Text("Connected!")
                }
            }
            else {
                Text("업성")
            }
        }
    }
}
