//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

import SwiftUI

struct MatchingLoadingView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var colorGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
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
                        Button(action: {
                            isLinkComplete.toggle()
                        }, label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isLinkComplete ? colorGradient1 : colorButtonDisabled)
                                .frame(height: 80)
                                .overlay(
                                    Text(isLinkComplete ? "연결하기" : "연결중…")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(isLinkComplete ? .white.opacity(1) : .white.opacity(0.5))
                                )
                        })
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

    @State private var circleOpacityToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var circleSizeToggle: [Bool] = Array(repeating: false, count: 5)
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach (0 ..< 5) { index in
                CircleView(circleOpacityToggle: circleOpacityToggle[index], circleSizeToggle: circleSizeToggle[index], delayTime: 0.3 * Double(index))
            }
        }//ZStack
        .frame(width: 350, height: 350)
    }
}

struct CircleView: View {
    
    @State var circleOpacityToggle: Bool
    @State var circleSizeToggle: Bool
    let delayTime: Double
    
    var body: some View {
        Circle()
            .scaleEffect(circleSizeToggle ? 1.2 : 0)
            .foregroundColor(.white)
            .opacity(circleOpacityToggle ? 0 : 0.3)
            .overlay(
                Circle()
                    .stroke(Color.white, lineWidth: 1)
                    .scaleEffect(circleSizeToggle ? 1.2 : 0)
                    .opacity(circleOpacityToggle ? 0 : 1)
            )//overlay
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                    withAnimation(.easeOut(duration: 2).repeatForever(autoreverses: false)) {
                        circleOpacityToggle = true
                        circleSizeToggle = true
                    }
                }
            }
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


