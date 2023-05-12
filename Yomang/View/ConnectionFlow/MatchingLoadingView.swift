//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

//TODO: Navigation Back Button에 매칭 취소 기능 넣기
//TODO: Matching Status 확인해서 완료 애니메이션 실행하기

import SwiftUI

struct MatchingLoadingView: View {
    
    //뷰모델에서 선언예정
    @State var colorButtonGradient1 = LinearGradient(colors: [Color(hex: 0x7538f9), Color(hex: 0x008cff)], startPoint: .top, endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
    @State var isMatchingComplete = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                
                //MatchingLoading 배경
                MatchingLoadingBackgroundView()
                
                VStack(alignment: .center) {
                    HStack(alignment: .top) {
                        Spacer()
                    }
                    Spacer()
                    
                    //로딩뷰와 매칭완료뷰 전환(애니메이션장면)
                    if isMatchingComplete {
                        CompleteView()
                    } else {
                        LoadingView()
                    }
                    
                    //파트너 일러스트 이미지
                    Image("Image_Partners_White")
                        .opacity(0.8)
                    Spacer()
                        .frame(height: proxy.size.height * 0.08)
                    
                    VStack(alignment: .center) {
                        //서버에서 매칭 완료 시 버튼 활성화
                        //현재는 서버값 없으므로 버튼 자체에 매칭완료 기능 부여함, 나중에는 다음뷰로 넘어가는 기능 부여해야함
                        Button {
                            isMatchingComplete.toggle()
                        } label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(isMatchingComplete ? colorButtonGradient1 : colorButtonDisabled)
                                .frame(height: 70)
                                .overlay(
                                    Text(isMatchingComplete ? "연결완료" : "연결중…")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(isMatchingComplete ? .white.opacity(1) : .white.opacity(0.5))
                                )//overlay
                        }//Button
                        Spacer()
                            .frame(height: proxy.size.height * 0.03)
                    }//VStack
                    .frame(width: proxy.size.width * 0.88)
                }//VStack
            }//ZStack
        }//GeometryReader
    }
}


//프리뷰
struct MatchingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingLoadingView()
    }
}

//로딩 애니메이션 뷰
struct LoadingView: View {
    //뷰 내부 변수
    @State private var circleOpacityToggle = Array(repeating: false, count: 5)
    @State private var circleSizeToggle = Array(repeating: false, count: 5)
    
    var body: some View {
        ZStack(alignment: .center) {
            //원Shape 애니메이션 배열_ 하위 뷰로 값을 넘겨줘서 표시한다
            ForEach (0 ..< 5) { index in
                CircleLoadingView(
                    circleOpacityToggle: circleOpacityToggle[index],
                    circleSizeToggle: circleSizeToggle[index],
                    delayTime: 0.2 * Double(index))
            }
        }//ZStack
        .frame(width: 350, height: 350)
    }
}

//매칭완료 애니메이션 뷰
struct CompleteView: View {
    
    //뷰 내부 변수
    @State private var circleOpacityToggle = Array(repeating: false, count: 5)
    @State private var circleSizeToggle = Array(repeating: false, count: 5)
    @State private var showCheckmark = 0.0
    
    var body: some View {
        ZStack(alignment: .center) {
            ZStack(alignment: .center) {
                
                //원Shape 애니메이션 배열_ 하위 뷰로 값을 넘겨줘서 표시한다
                ForEach (0 ..< 5) { index in
                    CircleCompleteView(circleOpacityToggle: circleOpacityToggle[index], circleSizeToggle: circleSizeToggle[index], delayTime: 0.1 * Double(index))
                }
            }//ZStack
            .frame(width: 250, height: 250)
            
            //체크Shape 애니메이션
            Path { path in
                path.move(to: CGPoint(x: -1, y: -1))
                path.addCurve(to: CGPoint(x: 21, y: 26), control1: CGPoint(x: -1, y: -1), control2: CGPoint(x: 22, y: 26))
                path.addCurve(to: CGPoint(x: 56, y: -28), control1: CGPoint(x: 20, y: 26), control2: CGPoint(x: 56, y: -28))
            }
            .trim(from: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, to: CGFloat(showCheckmark))
            .stroke(style: StrokeStyle(lineWidth: 16, lineCap: .round, lineJoin: .round))
            .foregroundColor(Color.white)
            .offset(x: 150, y: 175)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
                    withAnimation(.easeInOut(duration: 0.4).delay(0.8)) {
                        showCheckmark = 1
                    }
                }
                
                //햅틱 피드백_ 체크Shape 표시 타이밍에 작동_ 딸깍!
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

//원Shape_로딩_상위뷰에서 받아온 input에 따라 뷰 표시됨.
struct CircleLoadingView: View {
    
    @State var circleOpacityToggle: Bool
    @State var circleSizeToggle: Bool
    let delayTime: Double
    
    var body: some View {
        
        //원 Fill
        Circle()
            .scaleEffect(circleSizeToggle ? 1.2 : 0)
            .foregroundColor(.white)
            .opacity(circleOpacityToggle ? 0 : 0.3)
            .overlay(
                
                //원 Stroke
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


//원Shape_매칭완료_상위뷰에서 받아온 input에 따라 뷰 표시됨.
struct CircleCompleteView: View {
    
    //뷰모델에서 받아올 컬러
    @State var colorButtonGradient1 = LinearGradient(colors: [Color(hex: 0x7538f9), Color(hex: 0x008cff)], startPoint: .top, endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
    
    //뷰 내부 변수
    @State var circleOpacityToggle: Bool
    @State var circleSizeToggle: Bool
    let delayTime: Double
    
    var body: some View {
        
        //원 Fill
        Circle()
            .fill(circleOpacityToggle ? colorButtonGradient1 : colorButtonDisabled)
            .scaleEffect(circleSizeToggle ? 0.8 : 0)
            .opacity(circleOpacityToggle ? 0.1 : 0.3)
            .overlay(
                
                //원 Stroke
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

//MatchingLoading 장면 배경_ MatchingCode 배경과 동일하게 된다면 삭제하고 통합 가능
struct MatchingLoadingBackgroundView: View {
    
    //뷰모델에서 컬러 선언
    @State var colorBackgroundGradient1 = LinearGradient(colors: [Color(hex: 0x7538f9), .black], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        Rectangle()
            .fill(colorBackgroundGradient1)
            .opacity(0.6)
            .background(Color.black)
            .ignoresSafeArea()
    }
}


