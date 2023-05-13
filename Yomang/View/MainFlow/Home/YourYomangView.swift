//
//  YourYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/04.
//

import SwiftUI

struct YourYomangView: View {
    
    let imageUrl: String?
    
    var body: some View {
        ZStack {
            YourYomangBackgroundObject()
            
            //이미지가 들어있다면 달이 떠있다.
            if let _ = imageUrl {
//                    YourYomangMoon()
                    // TODO: Image
                VStack {
                    Spacer()
                    // TODO: 이미지 프레임 사이즈 작아짐
                    YourYomangImageView()
                }
            } else {
                YourYomangImageView()
                VStack (alignment: .center) {
                    Text("대기 중")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(height: 36)
                        .foregroundColor(.white)
                    
                    Text("상대의 첫 요망을 기다리고 있어요!")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }//ZStack
    }
}

struct YourYomangImageView: View {
    
    @State private var isPressed: Bool = false
    @State private var isHovering: Bool = false
    @State private var hoverSpeed: Double = 1.5
    
    var body: some View {
        
        ZStack {
            
            //뒷배경을 눌렀을 때 다시 작아집니다.
            Rectangle()
                .foregroundColor(Color.white.opacity(0.001))
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 1)) {
                        isPressed = false
                    }
                    withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                        isHovering = true
                    }
                }
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom))
                    .frame(width: 338, height: 354)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .scaleEffect(isPressed ? 1 : 0.8)
                    .offset(y: isHovering ? 10 : -10)
                    .rotation3DEffect(
                        Angle(degrees: isPressed ? 0 : 10),
                        axis: (x: 0.0, y: 1.0, z: -0.3),
                        anchor: .center,
                        perspective: 0.3
                    )
                //나타날 때 부터 떠다니는 애니메이션 실행됩니다.
                    .onAppear {
                        isPressed = false
                        withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                            isHovering = true
                        }
                    }
                //탭했을 때 작은 상태면 커지면서 애니메이션 중지, 큰 상태라면 작아지면서 애니메이션 실행
                    .onTapGesture {
                        if !isPressed {
                            withAnimation(.easeInOut(duration: 1)) {
                                isPressed.toggle()
                                isHovering.toggle()
                            }
                        } else {
                            withAnimation(.easeInOut(duration: 1)) {
                                isPressed.toggle()
                            }
                            withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                                isHovering = true
                            }
                        }
                    }
                
                Spacer().frame(height: 100)
            }//VStack
        }//ZStack
    }
}



//YourYomang 장면 배경오브젝트_좌측
struct YourYomangBackgroundObject: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("너의 요망 배경요소들")
                .foregroundColor(.white)
        }
    }
}

//MyYomang 달_우측화면
struct YourYomangMoon: View {
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                Image("Moon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .offset(x: -90)
                Spacer()
            }
        }//GeometryReader
    }
}

