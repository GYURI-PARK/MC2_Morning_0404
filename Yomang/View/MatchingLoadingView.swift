//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

/* 수정할거
animation modifier 변경하기
size/opacity toggle 하나로 합쳐도 되지 않나?
뷰 정리좀 하기
 */

import SwiftUI

struct MatchingLoadingView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var colorButtonGradient1: LinearGradient = LinearGradient(
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
                    if isLinkComplete {
                        LinkCompleteView()
                    } else {
                        LoadingView()
                    }
                    Image("Image_Partners_White")
                        .opacity(0.8)
                    Spacer().frame(height: proxy.size.height * 0.08)
                    VStack(alignment: .center) {
                        Button(action: {
                                    isLinkComplete.toggle()
                        }, label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isLinkComplete ? colorButtonGradient1 : colorButtonDisabled)
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

struct LinkCompleteView: View {

    @State private var circleOpacityToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var circleSizeToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var showCheckmark = 0.0
    
    var body: some View {

        ZStack(alignment: .center) {
            ZStack(alignment: .center) {
                ForEach (0 ..< 5) { index in
                    CircleCompleteView(circleOpacityToggle: circleOpacityToggle[index], circleSizeToggle: circleSizeToggle[index], delayTime: 0.1 * Double(index))
                }
            }.frame(width: 250, height: 250)
                
            Path { path in
                path.move(to: CGPoint(x: -1, y: -1))
                       path.addCurve(to: CGPoint(x: 21, y: 26), control1: CGPoint(x: -1, y: -1), control2: CGPoint(x: 22, y: 26))
                       path.addCurve(to: CGPoint(x: 56, y: -28), control1: CGPoint(x: 20, y: 26), control2: CGPoint(x: 56, y: -28))
                path.move(to: CGPoint(x: -1, y: -1))

            }
            .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat(showCheckmark))
            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
            .foregroundColor(Color.white)
            .offset(x: 150, y: 175)
            .animation(Animation.easeInOut(duration: 0.4).delay(0.8))
            .onAppear(){
                showCheckmark = 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
                    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                    impactMed.impactOccurred()
                }
            }
    
        }//ZStack
        .frame(width: 350, height: 350)
    }
}

struct LoadingView: View {

    @State private var circleOpacityToggle: [Bool] = Array(repeating: false, count: 5)
    @State private var circleSizeToggle: [Bool] = Array(repeating: false, count: 5)
    
    var body: some View {
        ZStack(alignment: .center) {
            ForEach (0 ..< 5) { index in
                CircleLoadingView(circleOpacityToggle: circleOpacityToggle[index], circleSizeToggle: circleSizeToggle[index], delayTime: 0.2 * Double(index))
            }
        }//ZStack
        .frame(width: 350, height: 350)
    }
}

struct CircleLoadingView: View {
    
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
                    withAnimation(.easeOut(duration: 1.5).repeatForever(autoreverses: false)) {
                        circleOpacityToggle = true
                        circleSizeToggle = true
                    }
                }
            }
    }
}

struct CircleCompleteView: View {
    
    //뷰모델에서 받아올 컬러
    @State var colorButtonGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
    
    @State var circleOpacityToggle: Bool
    @State var circleSizeToggle: Bool
    let delayTime: Double
    
    var body: some View {
        Circle()
            .fill(circleOpacityToggle ? colorButtonGradient1 : colorButtonDisabled)
            .scaleEffect(circleSizeToggle ? 0.8 : 0)
            .opacity(circleOpacityToggle ? 0.1 : 0.3)
            .overlay(
                Circle()
                    .stroke(circleOpacityToggle ? colorButtonGradient1 : colorButtonDisabled, lineWidth: circleSizeToggle ? 12 : 1)
                    .scaleEffect(circleSizeToggle ? 0.8 : 0)
                    .opacity(circleOpacityToggle ? 1 : 0.2)
            )//overlay
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                    withAnimation(.easeOut(duration: 0.5)) {
                        circleOpacityToggle = true
                        circleSizeToggle = true
                    }
                }
            }
    }
}

struct MatchingLoadingBackgroundView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var colorBackgroundGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 0/255, blue: 0/255)]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(colorBackgroundGradient1)
                .opacity(0.6)
                .background(Color.black)
                .ignoresSafeArea()
        }
    }
}


