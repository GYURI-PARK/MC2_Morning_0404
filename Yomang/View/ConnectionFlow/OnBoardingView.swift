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

    var body: some View {
            ZStack {
                
                ZStack {
                    Color.black
                    
                    TabView(selection: $selectedTabTag) {
                    Image("OnBoarding1")
                        .resizable()
                        .scaledToFill()
                        .tag(0)
                    
                    Image("OnBoarding2")
                        .resizable()
                        .scaledToFill()
                        .tag(1)
                    
                    Image("OnBoarding3")
                        .resizable()
                        .scaledToFill()
                        .tag(2)
                    
                    Image("OnBoarding4")
                        .resizable()
                        .scaledToFill()
                        .tag(3)
                        
                    }//TabView
                    .accentColor(Color.white)
                    .tabViewStyle(.page(indexDisplayMode:.always))
                    .navigationBarTitleDisplayMode(.large)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .navigationViewStyle(.stack)
                    
                }.ignoresSafeArea()
                
                VStack {
                    Spacer()
                    Button(action: {
                        if selectedTabTag == 3 {
                            showOnBoarding = false
                        }
                    }, label: {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTabTag == 3 ? Color.white : Color.neu200)
                            .opacity(selectedTabTag == 3 ? 1 : 0.5)
                            .frame(height: 70)
                            .padding()
                            .overlay(
                                Text("요망 시작하기")
                                    .font(.title3)
                                    .bold()
                                    .foregroundColor(selectedTabTag == 3 ? .black.opacity(1) : .black.opacity(0.5))
                            )
                            .disabled(selectedTabTag < 3)
                    })//Button
                }
        }
        
    }
}
