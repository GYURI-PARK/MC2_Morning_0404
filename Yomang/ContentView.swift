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
            MatchingTest(user: User(uuid: "", userId: "", isConnected: false))
        } else {
            if let user = viewModel.user {
                if !connected {
                    MatchingTest(user: user)
                        .onChange(of: user.isConnected) { _ in
                            connected = true
                        }
                } else {
                    liveMatchingTest(user: user)
                        .onAppear() {
                            //signOut 하고싶을 때 사용하기
//                            viewModel.signOut()
                        }
                }
            }
//            else {
//                Text("업성")
//            }
        }
    }
}
