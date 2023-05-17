//
//  YourYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/04.
//

import SwiftUI
import Kingfisher

struct YourYomangView: View {
    @EnvironmentObject var ani: AnimationViewModel
    @State var imageUrl: String?
    @State private var isBlinking: Bool = false
    @State private var isPressed: Bool = false
    
    var body: some View {
        ZStack {
            YourYomangBackgroundObject()
            YourYomangMoon().environmentObject(ani)
            
            //이미지가 들어있다면 달이 떠있다.
            if let _ = imageUrl {
                YourYomangImageView(isPressed: $isPressed, imageUrl: imageUrl)
            } else {
                YourYomangImageView(isPressed: $isPressed, imageUrl: nil)
                VStack (alignment: .center) {
                    
                    Text("상대방의 첫 요망을\n기다리고 있어요!")
                        .font(.title3)
                        .fontWeight(.light)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .offset(y: -150)
                        .opacity(isBlinking ? 1 : 0.5)
                        .opacity(isPressed ? 0 : 1)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                                isBlinking = true
                            }
                        }
                }
            }
        }//ZStack
        .onChange(of: UserDefaults.shared.string(forKey: "imageUrl")) { newUrl in
            imageUrl = newUrl
        }
    }
}

struct YourYomangImageView: View {
    
    @Binding var isPressed: Bool
    @State private var isHovering: Bool = false
    @State private var hoverSpeed: Double = 1.2
    
    let imageUrl: String?
    
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
                    .fill(LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom).opacity(isPressed ? 0 : 1))
                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color.main200))
                    .overlay {
                        if let imageUrl = imageUrl {
                            KFImage(URL(string: imageUrl))
                                .resizable()
                                .scaledToFit()
                                .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                        }
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white, lineWidth: 1)
                    }
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
                
                //이미지 눌렀을 때 저장버튼 생성
                //TODO: 기능 부여하기
//                if isPressed {
//                    Button(action: {
//                    }) {
//                        HStack {
//                            Spacer()
//
//                            RoundedRectangle(cornerRadius: 16)
//                                .fill(Color.main200)
//                                .frame(width: 100, height: 50)
//                                .padding(.horizontal)
//                                .overlay(
//                                    Text("저장")
//                                        .font(.body)
//                                        .foregroundColor(.white.opacity(1))
//                                        .padding()
//                                )
//                        }.padding(.horizontal)
//                    }
//                }
                
                Spacer().frame(height: 100)
            }//VStack
            .onAppear {
                    AuthViewModel.shared.fetchImageUrl()
            }
        }//ZStack
    }
}



//YourYomang 장면 배경오브젝트_좌측
struct YourYomangBackgroundObject: View {
    
    @State private var isChanged:Bool = false

    var body: some View {
        ZStack {
            Image("Image_Stars1")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.6 : 0.3)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                        isChanged.toggle()
                    }
                }
            
            Image("Image_Stars2")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.3 : 0.7)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                        isChanged.toggle()
                    }
                }
            
            Image("Image_Stars3")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.6 : 0.4)
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        isChanged.toggle()
                    }
                }
        }.edgesIgnoringSafeArea(.all)
    }
}

//MyYomang 달_우측화면
struct YourYomangMoon: View {
    
    @EnvironmentObject var ani: AnimationViewModel
   
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                Image("Moon2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ani.moonSize, height: ani.moonSize)
                    .offset(y: -(proxy.size.height + ani.offsetY))
                    .rotationEffect(.degrees(ani.moonAngle))
                    .offset(x: -(ani.moonSize / 2), y: proxy.size.height + ani.offsetY)
                
                Spacer()
            }//VStack
        }//GeometryReader
        .edgesIgnoringSafeArea(.all)
    }
}


