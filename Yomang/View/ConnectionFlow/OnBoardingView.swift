//
//  OnBoardingView.swift
//  Yomang
//
//  Created by 제나 on 2023/05/16.
//

import SwiftUI

struct OnBoardingView: View {
    
    @State private var selectedTabTag = 0
    @Binding var showOnBoarding: Bool
    @State private var isBlinking: Bool = false
    
    var body: some View {
        ZStack {
            
            ZStack {
                Rectangle()
                    .fill(LinearGradient(colors: [Color.black, Color(hex: 0x2F2745)], startPoint: .top, endPoint: .bottom))
                
                Rectangle()
                    .fill(LinearGradient(colors: [Color.black, Color(hex: 0x2F2745)], startPoint: .top, endPoint: .bottom))
                    .opacity(selectedTabTag == 0 ? 1 : 1)
                
                Rectangle()
                    .fill(LinearGradient(colors: [ Color(hex: 0x2F2745), Color(hex: 0x3F2548)], startPoint: .top, endPoint: .bottom))
                    .opacity(selectedTabTag > 0 ? 1 : 0)
                
                Rectangle()
                    .fill(LinearGradient(colors: [ Color(hex: 0x3F2548), Color(hex: 0x63446F)], startPoint: .top, endPoint: .bottom))
                    .opacity(selectedTabTag > 1 ? 1 : 0)
                
                Rectangle()
                    .fill(LinearGradient(colors: [ Color(hex: 0x63446F), Color(hex: 0xA36A88)], startPoint: .top, endPoint: .bottom))
                    .opacity(selectedTabTag > 2 ? 1 : 0)
                
                Image("Image_Stars1")
                    .resizable()
                    .scaledToFit()
                    .opacity(isBlinking ? 0.8 : 0.4)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            isBlinking = true
                        }
                    }
                Image("Image_Stars2")
                    .resizable()
                    .scaledToFit()
                    .opacity(isBlinking ? 0.4 : 0.8)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 2).repeatForever()) {
                            isBlinking = true
                        }
                    }
                
                
            }.ignoresSafeArea()
                
                
                VStack {
                    TabView(selection: $selectedTabTag) {
                        OnBoardingView1()
                            .tag(0)
                        
                        OnBoardingView2()
                            .tag(1)
                        
                        OnBoardingView3()
                            .tag(2)
                        
                        OnBoardingView4()
                            .tag(3)
                        
                    }//TabView
                    .accentColor(Color.white)
                    .tabViewStyle(.page(indexDisplayMode:.always))
                    .navigationBarTitleDisplayMode(.large)
                    .indexViewStyle(.page(backgroundDisplayMode: .interactive))
                    .navigationViewStyle(.stack)
                    .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                    
                    
                    if selectedTabTag < 3 {
                        Button(action: {
                            withAnimation(.linear(duration: 0.5)) {
                                selectedTabTag += 1 }
                        }, label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.main100)
                                .opacity(0.5)
                                .frame(height: 70)
                                .padding()
                                .overlay(
                                    Text("다음으로")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                )
                        })//Button
                    } else if selectedTabTag == 3 {
                        Button(action: {
                            showOnBoarding = false
                        }, label: {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white)
                                .opacity(0.9)
                                .frame(height: 70)
                                .padding()
                                .overlay(
                                    Text("요망 시작하기")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(Color(hex: 0xA36A88))
                                )
                        })//Button
                    }
                }.edgesIgnoringSafeArea(.top)
            }
        }
    }



struct OnBoardingView1: View {
    @State private var isHovering: Bool = false
    
    var body: some View {
        
        ZStack {
            Image("Moon2")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: -100)
                .offset(y: isHovering ? 10 : -10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        isHovering = true
                    }
                }
            
            VStack {
                Spacer().frame(height: 350)
                Text("밤 하늘의 달을 보며 나를 그릴\n**그 사람에게 요망을 보내면**")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }.ignoresSafeArea()
    }
}

struct OnBoardingView2: View {
    @State private var isHovering: Bool = false

    var body: some View {
        
        ZStack {
            Image("Widget")
                .resizable()
                .scaledToFit()
                .frame(width: 180, height: 180)
                .offset(y: -100)
                .offset(y: isHovering ? 10 : -10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        isHovering = true
                    }
                }
            
            VStack {
                Spacer().frame(height: 350)
                Text("다음날 아침 애정 가득 담긴 사진이\n**그 사람의 위젯에 떠오를 거예요!**")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }.ignoresSafeArea()
    }
}

struct OnBoardingView3: View {
    @State private var isHovering: Bool = false

    var body: some View {
        
        ZStack {
            Image("Phone")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .offset(y: -100)
                .offset(y: isHovering ? 10 : -10)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1).repeatForever()) {
                        isHovering = true
                    }
                }
            
            VStack {
                Spacer().frame(height: 350)
                Text("바탕화면을 꾹 눌러 **위젯**을 설정해두면\n**상대방이 보내온 요망이\n매일 내 화면에 나타나요.**")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            
        }.ignoresSafeArea()
    }
}

struct OnBoardingView4: View {
    @State private var isHovering: Bool = false

    var body: some View {
        
        ZStack {
            Image("Moon2")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .offset(y: -100)
                .scaleEffect(isHovering ? 1.2 : 1)
                .onAppear {
                    withAnimation(.easeInOut(duration: 2)) {
                        isHovering = true
                    }
                }
            
            VStack {
                Spacer().frame(height: 350)
                Text("매일 서로에게 기분 좋은 아침을\n선물해줄 **요망을 시작해볼까요?**")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.thin)
                    .multilineTextAlignment(.center)
                    .padding()

            }
        }.ignoresSafeArea()
    }
}

