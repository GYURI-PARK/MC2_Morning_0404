//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI

struct ContentView: View {
    
    init() {
            UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var showSplash = true
    @State private var successFetchUser = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var connected: Bool = false
    
    var body: some View {
        ZStack {
            if showSplash {
                splashView
            } else { // hide splash
                if !successFetchUser {
                    // TODO: 로그인때문에 지연되는 화면 필요해요
                    Text("가입 중")
                        .onAppear {
                            viewModel.fetchUser { registered in
                                if !registered {
                                    viewModel.registerUser { _ in
                                        successFetchUser = true
                                    }
                                } else {
                                    successFetchUser = true
                                }
                            }
                        }
                } else {
                    if let user = viewModel.user {
                        if !user.isConnected {
                            MatchingCodeView(user: user)
                                .onChange(of: user.isConnected) { _ in
                                    connected = true
                                }
                        } else {
                            HomeView(user: user)
                        }
                    } else {
                        // TODO: 예외처리
                        Text("예외처리")
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                withAnimation(Animation.easeOut(duration: 1)) { showSplash.toggle() }
            })
        }
    }
}

extension ContentView {
    var splashView: some View {
        ZStack {
            Color(hex: 0x18181C)
                .edgesIgnoringSafeArea(.all)
            Image("moon")
        }
    }
}
