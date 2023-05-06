//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

import SwiftUI

struct MatchingLoadingView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var gradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    @State var isLinkComplete: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
                ZStack(alignment: .center) {
                MatchingLoadingBackgroundView()
                    VStack(alignment: .center) {
                        Spacer()
                        LoadingAnimationView()
                        Image("Image_Partners_White")
                            .opacity(0.8)
                        Spacer().frame(height: proxy.size.height * 0.08)
                        VStack(alignment: .center) {
                            if isLinkComplete != true {
                                Button(action: {
                                    isLinkComplete = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.3))
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결중...")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(0.5))
                                        )
                                }
                            } else {
                                Button(action: {
                                    isLinkComplete = false
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(gradient1)
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(1))
                                        )
                                }
                            }
                        }//VStack
                        .frame(width: proxy.size.width * 0.88)
                    }//VStack
                }//ZStack
        }//GeometryReader
    }
}

struct MatchingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingLoadingView()
    }
}

struct LoadingAnimationView: View {
    
    @State private var circleOpacityToggle1: Bool = false
    @State private var circleSizeToggle1: Bool = false
    @State private var circleOpacityToggle2: Bool = false
    @State private var circleSizeToggle2: Bool = false
    @State private var circleOpacityToggle3: Bool = false
    @State private var circleSizeToggle3: Bool = false
    @State private var circleOpacityToggle4: Bool = false
    @State private var circleSizeToggle4: Bool = false
    @State private var circleOpacityToggle5: Bool = false
    @State private var circleSizeToggle5: Bool = false
    
    var body: some View {
            ZStack(alignment: .center) {
                //Circle1
                Circle()
                    .scaleEffect(circleSizeToggle1 ? 1.2 : 0)
                    .foregroundColor(.white)
                    .opacity(circleOpacityToggle1 ? 0 : 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .scaleEffect(circleSizeToggle1 ? 1.2 : 0)
                            .opacity(circleOpacityToggle1 ? 0 : 1)
                    )//overlay
                    .onAppear() {
                        circleOpacityToggle1 = true
                        circleSizeToggle1 = true
                    }.animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false))
                    .position(x: 175, y: 175)
                //Circle2
                Circle()
                    .scaleEffect(circleSizeToggle2 ? 1.2 : 0)
                    .foregroundColor(.white)
                    .opacity(circleOpacityToggle2 ? 0 : 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .scaleEffect(circleSizeToggle2 ? 1.2 : 0)
                            .opacity(circleOpacityToggle2 ? 0 : 1)
                    )//overlay
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            circleOpacityToggle2 = true
                            circleSizeToggle2 = true
                        }
                    }.animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false))
                    .position(x: 175, y: 175)
                //Circle3
                Circle()
                    .scaleEffect(circleSizeToggle3 ? 1.2 : 0)
                    .foregroundColor(.white)
                    .opacity(circleOpacityToggle3 ? 0 : 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .scaleEffect(circleSizeToggle3 ? 1.2 : 0)
                            .opacity(circleOpacityToggle3 ? 0 : 1)
                    )//overlay
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            circleOpacityToggle3 = true
                            circleSizeToggle3 = true
                        }
                    }.animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false))
                    .position(x: 175, y: 175)
                //Circle4
                Circle()
                    .scaleEffect(circleSizeToggle4 ? 1.2 : 0)
                    .foregroundColor(.white)
                    .opacity(circleOpacityToggle4 ? 0 : 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .scaleEffect(circleSizeToggle4 ? 1.2 : 0)
                            .opacity(circleOpacityToggle4 ? 0 : 1)
                    )//overlay
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            circleOpacityToggle4 = true
                            circleSizeToggle4 = true
                        }
                    }.animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false))
                    .position(x: 175, y: 175)
                //Circle5
                Circle()
                    .scaleEffect(circleSizeToggle5 ? 1.2 : 0)
                    .foregroundColor(.white)
                    .opacity(circleOpacityToggle5 ? 0 : 0.3)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1)
                            .scaleEffect(circleSizeToggle5 ? 1.2 : 0)
                            .opacity(circleOpacityToggle5 ? 0 : 1)
                    )//overlay
                    .onAppear() {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            circleOpacityToggle5 = true
                            circleSizeToggle5 = true
                        }
                    }.animation(Animation.easeOut(duration: 3).repeatForever(autoreverses: false))
                    .position(x: 175, y: 175)
            }//ZStack
            .frame(width: 350, height: 350)
    }
}

struct MatchingLoadingBackgroundView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var gradient2: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 0/255, blue: 0/255)]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(gradient2)
                .opacity(0.6)
                .background(Color.black)
                .ignoresSafeArea()
        }
    }
}


