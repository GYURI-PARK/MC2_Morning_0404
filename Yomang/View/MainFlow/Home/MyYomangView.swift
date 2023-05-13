//
//  MyYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/09.
//

import SwiftUI

struct MyYomangView: View {
    
    let user: User?
    
    var body: some View {
        ZStack {
            MyYomangBackgroundObject()
            //이미지가 들어있다면 달이 떠있다.
            if let _ = user {
                // TODO: Image
                MyYomangImageView()
                MyYomangMoon()

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
                    .fill(LinearGradient(colors: [Color.white.opacity(0.3), Color.clear], startPoint: .top, endPoint: .bottom).opacity(isPressed ? 0 : 0))
                    .frame(width: 338, height: 354)
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
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var secondsLeft: Int = 0
    @State private var offsetX: Double = -180
    @State private var isImageUploaded: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            VStack {
                
                Image("Moon1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .offset(x: offsetX)
                    .overlay(
                        VStack{
                            Text("seconds: \(secondsLeft)")
                                .foregroundColor(Color.red)
                                .font(.title3)
                            Text("offsetX: \(offsetX)")
                                .foregroundColor(Color.blue)
                                .font(.title3)
                        }
                    )
                    .onAppear {
                        calculateSecondsLeft()
                        loadSavedData()
                    }
                    .onReceive(timer) { _ in
                        calculateSecondsLeft()
                        loadSavedData()
                    if isImageUploaded {
                            withAnimation(.linear(duration: 1)) { offsetX += Double((proxy.size.width * 2.0 - 180.0)) / Double(secondsLeft/1000)
                                saveData()
                            }
                        }
                        print("offset: \(offsetX)")
                        print("second: \(secondsLeft)")
                    }
                
                Button(action: {
                    isImageUploaded = true
                    if isImageUploaded { withAnimation(.easeInOut(duration: 1)){ offsetX = 0 } }
                    saveData()
                    print(offsetX)
                }) {
                    Text("사진업로드완료")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                }
                
                Button(action: {
                    isImageUploaded = false
                    offsetX = -180
                    saveData()
                }) {
                    Text("시간다됨")
                        .foregroundColor(.white)
                        .frame(width: 100, height: 100)
                }
                
                Spacer()
            }
        }//GeometryReader
    }
    
    func calculateSecondsLeft() {
        
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: now)!)!
        let components = calendar.dateComponents([.second], from: now, to: tomorrow)

        if let seconds = components.second {
            secondsLeft = seconds
        }
    }
    
    func saveData() {
        UserDefaults.standard.set(offsetX, forKey: "offsetX")
        UserDefaults.standard.set(isImageUploaded, forKey: "isImageUploaded")
        
       }

       func loadSavedData() {
        offsetX = UserDefaults.standard.double(forKey: "offsetX")
        isImageUploaded = UserDefaults.standard.bool(forKey: "isImageUploaded")
       }
    
}



