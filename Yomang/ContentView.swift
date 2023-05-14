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
            } else { // hide splash
                if !successFetchUser {
                    // TODO: 로그인때문에 지연되는 화면 필요해요
                    /// 여기서 안넘어간다면 signOut이 필요할 가능성이 높습니다
                    Text("잠시만 기다려 주세요.")
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
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
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
