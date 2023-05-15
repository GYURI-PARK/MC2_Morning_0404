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
    
    //뷰모델에서 선언예정
    @State private var connected: Bool = false
    @State private var play: Bool = false
    
    var body: some View {
        ZStack(alignment: .center) {
            
            
            if !play {
                LottieView(name: Constants.Animations.matchingLoading, loopMode: .loop, animationSpeed: 1, contentMode: .scaleAspectFill)
                    .ignoresSafeArea()
            } else {
                LottieView(name: Constants.Animations.matchingComplete, loopMode: .playOnce, animationSpeed: 1, contentMode: .scaleAspectFill)
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                
                //서버에서 매칭 완료 시 버튼 활성화
                // TODO: 현재는 서버값 없으므로 버튼 자체에 매칭완료 기능 부여함, 나중에는 다음뷰로 넘어가는 기능 부여해야함
                Button(action: {
                    connected.toggle()
                    play.toggle()
                }, label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(connected ? Color.main500 : Color.neu100)
                        .frame(height: 70)
                        .padding()
                        .overlay(
                            Text(connected ? "연결완료" : "연결중…")
                                .font(.title3)
                                .bold()
                                .foregroundColor(connected ? .white.opacity(1) : .white.opacity(0.5))
                        )
                })//Button
            }
        }//ZStack
        
    }
}
    
    
    //프리뷰
    struct MatchingLoadingView_Previews: PreviewProvider {
        static var previews: some View {
            MatchingLoadingView(user: User(uuid: "", userId: "", isConnected: false))
        }
    }
