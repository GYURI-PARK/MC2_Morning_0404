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
//        if viewModel.userSession == nil {
//            MatchingCodeView(user: User(uuid: "", userId: "", isConnected: false))
//        } else {
//            if let user = viewModel.user {
//                if !connected {
//                    MatchingCodeView(user: user)
//                        .onChange(of: user.isConnected) { _ in
//                            connected = true
//                        }
//                } else {
//                    Text("Connected!")
//                        .onAppear() {
//                            //signOut 하고싶을 때 사용하기
////                            viewModel.signOut()
//                        }
//                }
//            }
////            else {
////                Text("업성")
////            }
//        }
        HomeView(user: nil)
    }
}
