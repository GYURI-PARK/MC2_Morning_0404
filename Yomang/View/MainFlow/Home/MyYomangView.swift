//
//  MyYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/09.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct MyYomangView: View {
    
    let user: User
    @EnvironmentObject var ani: AnimationViewModel
    @ObservedObject var viewModel: YomangViewModel
    @Binding var showMatchingCode: Bool
    @State private var isPressed:Bool = false
    @State private var isBlinking: Bool = false
    
    var body: some View {
        ZStack {
            MyYomangBackgroundObject()
            //이미지가 들어있다면 달이 떠있다.
            
            MyYomangMoon().environmentObject(ani)
            MyYomangImageView(user: user, imageUrl: user.imageUrl.isEmpty ? nil : user.imageUrl, isPressed: $isPressed, viewModel: viewModel)
                .environmentObject(ani)
                .overlay {
                    if !user.isConnected {
                        if !isPressed {
                            Text("아래 위젯을 눌러서\n상대에게 보낼 **요망을 만들어봐요**")
                                .font(.title3)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .offset(y: -150)
                                .opacity(isBlinking ? 1 : 0.5)
                                .opacity(isPressed ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                                        isBlinking.toggle()
                                    }
                                }
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(height: 380)
                                .foregroundColor(.black)
                                .opacity(0.001)
                                .onTapGesture {
                                    showMatchingCode = true
                                }
                                .offset(y: 40)
                                .overlay(
                                    Text("아직 상대와 연결되지 않았네요!\n**위젯을 눌러 상대방과 연결해볼까요?**")
                                        .font(.title3)
                                        .fontWeight(.light)
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.white)
                                        .offset(y: -200)
                                        .opacity(isBlinking ? 1 : 0.8)
                                        .opacity(isPressed ? 1 : 0)
                                        .onAppear {
                                            withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                                                isBlinking.toggle()
                                            }
                                        }
                                )
                                .opacity(isPressed ? 1 : 0)
                               
                        }
                    } else {
                        
                        if !ani.isImageUploaded {
                            Text("아래 위젯을 눌러서\n상대에게 보낼 **요망을 만들어봐요**")
                                .font(.title3)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .offset(y: -150)
                                .opacity(isBlinking ? 1 : 0.5)
                                .opacity(isPressed ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                                        isBlinking.toggle()
                                    }
                                }
                        } else {
                            Text("")
                                .font(.title3)
                                .fontWeight(.light)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .offset(y: -150)
                                .opacity(isBlinking ? 1 : 0.5)
                                .opacity(isPressed ? 0 : 1)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)){
                                        isBlinking.toggle()
                                    }
                                }
                        }
                    }
                }
                .onAppear() {
                    showMatchingCode = false
                }
        }//ZStack
        .onAppear() {
            // MARK: 데모용 마이요망뷰에서 파트너 이미지를 fetch해옴
            AuthViewModel.shared.fetchImageUrl() { _ in }
        }
    }
}

struct MyYomangImageView: View {
    
    let user: User
    let imageUrl: String?
    
    @Binding var isPressed: Bool
    @State private var isHovering = false
    @State private var hoverSpeed = 1.2
    @State private var selected = false
    @ObservedObject var viewModel: YomangViewModel
    @EnvironmentObject var ani: AnimationViewModel
    
    var body: some View {
        
        ZStack {
//            뒷배경을 눌렀을 때 다시 작아집니다.
            Rectangle()
                .foregroundColor(Color.white.opacity(0.001))
                .onTapGesture {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1)) {
                            isPressed = false
                        }
                        withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                            isHovering = true
                        }
                    }
                }
            
            VStack {
                Spacer()
                
                RoundedRectangle(cornerRadius: 22)
                    .fill(LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom).opacity(isPressed ? 0 : 1))
                    .frame(width: 338, height: 354)
                    .background(RoundedRectangle(cornerRadius: 22).fill(Color.main500))
                    .overlay {
                        if let rendered = viewModel.renderedImage {
                            rendered
                                .resizable()
                                .scaledToFit()
                                .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                                .clipShape(RoundedRectangle(cornerRadius: 22))
                        } else {
                            if let url = imageUrl {
                                KFImage(URL(string: url))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                                    .clipShape(RoundedRectangle(cornerRadius: 22))
                            }
                        }
                        
                        
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white, lineWidth: 1)
                    }
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
                        if !isPressed {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                                    isHovering = true
                                }
                            }
                        }
                    }
                //탭했을 때 작은 상태면 커지면서 애니메이션 중지, 큰 상태라면 작아지면서 애니메이션 실행
                    .onTapGesture {
                        if !isPressed {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 1)) {
                                    isPressed = true
                                    isHovering = false
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                withAnimation(.easeInOut(duration: 1)) {
                                    isPressed = false
                                }
                                withAnimation(.easeInOut(duration: hoverSpeed).repeatForever()) {
                                    isHovering = true
                                }
                            }
                        }
                    }
                
                //이미지 눌렀을 때 편집버튼 생성
                if user.isConnected, isPressed {
                    HStack {
                        Spacer()
                        ZStack {
                            
                            PhotosPicker(selection: $viewModel.imageSelection,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.main500)
                                    .frame(width: 120, height: 50)
                                    .padding(.horizontal)
                                    .overlay(
                                        Text("요망 만들기")
                                            .font(.body)
                                            .bold()
                                            .foregroundColor(.white.opacity(1))
                                            .padding()
                                    )
                                    .offset(x: -12)
                            }
                             .onChange(of: viewModel.imageSelection){ (imageState) in
                                 selected = true
                             }
                             .photosPicker(isPresented: $viewModel.cancel, selection: $viewModel.imageSelection, matching: .images, photoLibrary: .shared())
                            NavigationLink("", destination: CropYomangView(viewModel: viewModel, isPressed: $isPressed).environmentObject(ani), isActive: $selected)
                        }
                    }
                }
                Spacer().frame(height: 100)
            }//VStack
        }//ZStack
    }
}

//MyYomang 장면 배경오브젝트_우측
struct MyYomangBackgroundObject: View {
    
    @State private var isChanged:Bool = false

    var body: some View {
        ZStack {
            Image("Image_Stars1")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.6 : 0.3)
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isChanged.toggle()
                        }
                    }
                    
                }
            
            Image("Image_Stars2")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.3 : 0.7)
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isChanged.toggle()
                        }
                    }
                }
            
            Image("Image_Stars3")
                .resizable()
                .scaledToFit()
                .opacity(isChanged ? 0.6 : 0.4)
                .onAppear {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            isChanged.toggle()
                        }
                    }
                }
        }.edgesIgnoringSafeArea(.all)
    }
}

//MyYomang 달_좌측화면
struct MyYomangMoon: View {
    
    //TODO: every값 조정해서 받아오는 주기 조절
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
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
                        .offset(x: proxy.size.width - ani.moonSize / 2, y: proxy.size.height + ani.offsetY)
                        .onAppear {
                            ani.loadSavedData()
                            ani.calculateTimeLeft()
                            ani.calculateMoonLimitAngle(geoWidth: proxy.size.width, geoHeight: proxy.size.height, moonSize: ani.moonSize)
                            ani.moonAngle = ((ani.timeFromStart - ani.timeFromNow) * ((ani.limitAngle * 2 - ani.startAngle) / (ani.timeFromStart/700))) - ani.limitAngle + ani.startAngle
                            ani.saveData()
                        }
                        .onReceive(timer) { _ in
                            if ani.isImageUploaded {
                                if ani.moonAngle < ani.limitAngle {
                                    DispatchQueue.main.async {
                                        withAnimation(.linear(duration: 1)) { ani.moonAngle += (ani.limitAngle * 2 - ani.startAngle) / (ani.timeFromStart/700)}
                                    }
                                    
                                } else {
                                    print("새벽5시 전송완료")
                                    ani.loadSavedData()
                                    ani.isImageUploaded = false
                                    ani.moonAngle = 0 - ani.limitAngle
                                    ani.timeFromStart = 0.0
                                    ani.saveData()
                                }
                            } 
                            ani.saveData()
                        }
                    
                    Spacer()
                }.edgesIgnoringSafeArea(.all)
        }//GeometryReader
        .edgesIgnoringSafeArea(.all)
    }
}



