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
            MatchingViewTest(user: User(uuid: "", userId: "", isConnected: false))
        } else {
            if let user = viewModel.user {
                if !connected {
                    MatchingViewTest(user: user)
                        .onChange(of: user.isConnected) { _ in
                            connected = true
                        }
                } else {
                    Text("Connected!")
                }
            }
        }
    }
}
