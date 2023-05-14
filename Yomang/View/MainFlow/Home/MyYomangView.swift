//
//  MyYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/09.
//

import SwiftUI

struct MyYomangView: View {
    
    let user: User?
    @EnvironmentObject var ani: AnimationViewModel
    
    var body: some View {
        ZStack {
            MyYomangBackgroundObject()
            //이미지가 들어있다면 달이 떠있다.
            if let _ = user {
                // TODO: Image
                MyYomangImageView()
                MyYomangMoon().environmentObject(ani)
                
            } else {
                MyYomangImageView()
                    .overlay(
                        Text("이곳을 눌러\n파트너와 연결해 보세요")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                    )
            }
        }//ZStack
    }
}

struct MyYomangImageView: View {
    
    @State private var isPressed: Bool = false
    @State private var isHovering: Bool = false
    @State private var hoverSpeed: Double = 1.2
    
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
                    .frame(width: 338, height: 354)
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color.main500))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .scaleEffect(isPressed ? 1 : 0.8)
                    .offset(y: isHovering ? 10 : -10)
                    .rotation3DEffect(
                        Angle(degrees: isPressed ? 0 : -10),
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
                
                //이미지 눌렀을 때 편집버튼 생성
                if isPressed {
                    Button(action: {
                    }) {
                        HStack {
                            Spacer()
                            
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.main500)
                                .frame(width: 100, height: 50)
                                .padding(.horizontal)
                                .overlay(
                                    Text("편집")
                                        .font(.body)
                                        .foregroundColor(.white.opacity(1))
                                        .padding()
                                )
                        }.padding(.horizontal)
                    }
                }
                Spacer().frame(height: 100)
            }//VStack
        }//ZStack
    }
}


//MyYomang 장면 배경오브젝트_우측
struct MyYomangBackgroundObject: View {
    
    var body: some View {
        VStack {
            Spacer()
            Text("나의 요망 배경요소들")
                .foregroundColor(.white)
        }
    }
}

//MyYomang 달_좌측화면
struct MyYomangMoon: View {
    
    //TODO: every값 조정해서 받아오는 주기 조절
    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    @EnvironmentObject var ani: AnimationViewModel
    let offsetY: Double = 180.0
    let startAngle: Double = 18.0
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                Image("Moon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ani.moonSize, height: ani.moonSize)
                    .offset(y: -(proxy.size.height + offsetY))
                    .rotationEffect(.degrees(ani.moonAngle))
                    .offset(x: proxy.size.width - ani.moonSize / 2, y: proxy.size.height + offsetY)
                    .onAppear {
                        ani.loadSavedData()
                        ani.calculateTimeLeft()
                        ani.calculateMoonLimitAngle(geoWidth: proxy.size.width, geoHeight: proxy.size.height, moonSize: ani.moonSize)
                        ani.moonAngle = (ani.timeFromStart - ani.timeFromNow) * ((ani.limitAngle * 2 - startAngle) / (ani.timeFromStart/500)) - ani.limitAngle + startAngle
                        ani.saveData()
                    }
                    .onReceive(timer) { _ in
                        if ani.isImageUploaded {
                            if ani.moonAngle < ani.limitAngle {
                                withAnimation(.linear(duration: 1)) { ani.moonAngle += (ani.limitAngle * 2 - startAngle) / (ani.timeFromStart/500)}
                            } else {
                                print("새벽5시 전송완료")
                                ani.isImageUploaded = false
                                ani.timeFromStart = 0
                                ani.moonAngle = -ani.limitAngle
                            }
                        } else {
                            print("Image 새로 업로드하기")
                        }
                        ani.saveData()
                    }
                
                Spacer()
                //TODO: 이미지업로드 확인버튼에 부여할 기능!
                Button(action: {
                    ani.loadSavedData()
                    ani.isImageUploaded = true
                    withAnimation(.easeInOut(duration: 1)){ ani.moonAngle = -ani.limitAngle + startAngle }
                    ani.calculateTimeLeft()
                    ani.timeFromStart = ani.timeFromNow
                    ani.saveData()
                }) {
                    Text("uploadedImage")
                        .foregroundColor(.gray)
                        .frame(width: 150, height: 50)
                }
                
                //TODO: 시간 5시 넘었을 때 부여할 기능!
                Button(action: {
                    ani.loadSavedData()
                    ani.isImageUploaded = false
                    ani.moonAngle = 0 - ani.limitAngle
                    ani.timeFromStart = 0.0
                    ani.saveData()
                }) {
                    Text("timeDone")
                        .foregroundColor(.gray)
                        .frame(width: 150, height: 50)
                }
                Spacer().frame(height: 100)
            }//VStack
        }//GeometryReader
        .edgesIgnoringSafeArea(.all)
    }
}



