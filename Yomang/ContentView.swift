//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if viewModel.userSession == nil {
            MatchingCodeView(user: User(uuid: "", userId: "", isConnected: false))
        } else if let user = viewModel.user {
                    MatchingCodeView(user: user)
        }
    }
}
