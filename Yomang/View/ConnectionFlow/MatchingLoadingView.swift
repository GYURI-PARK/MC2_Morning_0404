//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

//TODO: 매칭 취소 함수 받아서 넣기
//TODO: Matching Status 확인해서 완료 애니메이션 실행하기

import SwiftUI

struct MatchingLoadingView: View {
    
    let user: User
    @State private var isConnected = false // user가 상대방과 연결되었는지
    
    // isCompleteAnimationPlayed는 Lottie 애니메이션 실행하고, isCompleteAnimationPlayedWithDelay는 딜레이 후에 버튼과 배경바꾼다.
    @State private var isCompleteAnimationPlayed: Bool = false
    @State private var isCompleteAnimationPlayedWithDelay: Bool = false
    
    @Binding var showMatchingCode: Bool
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ZStack(alignment: .center) {
                    
                    MatchingViewBackground(isCompleteAnimationPlayedWithDelay: $isCompleteAnimationPlayedWithDelay)
                    
                    
                    Image("Moon_Half")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .opacity(isCompleteAnimationPlayedWithDelay ? 0 : 1)
                        .offset(y: -(proxy.size.height * 0.13))
                    
                    if !isCompleteAnimationPlayed {
                        LottieView(name: Constants.Animations.matchingLoading, loopMode: .loop, animationSpeed: 1, contentMode: .scaleAspectFill)
                        
                    } else {
                        LottieView(name: Constants.Animations.matchingComplete, loopMode: .playOnce, animationSpeed: 1, contentMode: .scaleAspectFill)
                        
                    }
                    
                    Image("Moon_Half")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .opacity(isCompleteAnimationPlayedWithDelay ? 0 : 0.5)
                        .offset(y: -(proxy.size.height * 0.13))
                    
                    Image("Moon_Full")
                        .resizable()
                        .frame(width: 110, height: 110)
                        .opacity(isCompleteAnimationPlayedWithDelay ? 1 : 0)
                        .offset(y: -(proxy.size.height * 0.13))
                    
                }
                // TODO: 강제 언래핑 조심
                .onChange(of: AuthViewModel.shared.user!.isConnected) { connected in
                    isConnected = connected
                    isCompleteAnimationPlayed.toggle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
                        withAnimation(Animation.easeInOut(duration: 2)) {
                            isCompleteAnimationPlayedWithDelay.toggle()
                        }
                    })
                }
            }.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                
                
                //서버에서 매칭 완료 시 버튼 활성화
                // TODO: 현재는 서버값 없으므로 버튼 자체에 매칭완료 기능 부여함, 나중에는 다음뷰로 넘어가는 기능 부여해야함
                Button(action: {
                    if isConnected {
                        showMatchingCode = false
                    }
                }, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isCompleteAnimationPlayedWithDelay ? Color.main500 : Color.neu500)
                        .frame(height: 70)
                        .padding()
                        .overlay(
                            Text(isCompleteAnimationPlayedWithDelay ? "연결완료" : "연결중…")
                                .font(.title3)
                                .bold()
                                .foregroundColor(isCompleteAnimationPlayedWithDelay ? .white.opacity(1) : .white.opacity(0.5))
                        )
                })//Button
            }
        }//ZStack
        
    }
}



struct MatchingViewBackground: View {
    
    @EnvironmentObject var ani: AnimationViewModel
    @Binding var isCompleteAnimationPlayedWithDelay: Bool
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black)
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color.main500], startPoint: .top, endPoint: .bottom))
                .opacity(isCompleteAnimationPlayedWithDelay ? 0.3 : 0.3)
            
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color.white], startPoint: .top, endPoint: .bottom))
                .opacity(isCompleteAnimationPlayedWithDelay ? 0.2 : 0.1)
            
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.main200, Color.blue500], startPoint: .top, endPoint: .bottom))
                .opacity(isCompleteAnimationPlayedWithDelay ? 0.1 : 0)
            
        }.edgesIgnoringSafeArea(.all)
        
    }
}
