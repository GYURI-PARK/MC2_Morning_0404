//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @State private var showSplash = true
    // TODO: 처음에 스플래시보이고 모달이 슥 보임
    @State private var showMatchingCode = true
    @State private var showOnBoarding = true
    @State private var successFetchUser = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var connected: Bool = false
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            if showSplash {
                SplashView()
                    .onAppear {
                        viewModel.fetchUser { registered in
                            if !registered {
                                viewModel.registerUser { _ in
                                    successFetchUser = true
                                }
                            } else {
                                successFetchUser = true
                            }
                            if let user = viewModel.user {
                                showOnBoarding = !user.isConnected
                            }
                        }
                        //                        viewModel.signOut()
                    }
            } else { // hide splash
                if !successFetchUser {
                    // TODO: 로그인때문에 지연되는 화면 필요해요
                    /// 여기서 안넘어간다면 signOut이 필요할 가능성이 높습니다
                    Text("잠시만 기다려 주세요.")
                        .foregroundColor(.white)
                } else {
                    if let user = viewModel.user {
                        HomeView(user: user, showMatchingCode: $showMatchingCode)
                            .fullScreenCover(isPresented: $showOnBoarding) {
                                OnBoardingView(showOnBoarding: $showOnBoarding)
                            }
                            .sheet(isPresented: $showMatchingCode, content: {
                                MatchingCodeView(user: user, showMatchingCode: $showMatchingCode)
                            })
                    } else {
                        // TODO: 예외처리
                        Text("잠시만 기다려 주세요.")
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                 showSplash.toggle()
            })
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
        }
    }
}

struct SplashView: View {
    
    var body: some View {
        ZStack {
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color(hex: 0x2F2745)], startPoint: .top, endPoint: .bottom))
            
            LottieView(name: Constants.Animations.splash, loopMode: .loop, animationSpeed: 1, contentMode: .scaleAspectFill)
        
            Text("Yomang")
                .font(.system(size: 48))
                .bold()
                .foregroundColor(.white)
                .offset(y: -200)
            
            Image("Moon2")
                .resizable()
                .scaledToFit()
                .frame(width: 130, height: 130)
                .offset(y: -50)
                
        }.ignoresSafeArea()
    }
}

