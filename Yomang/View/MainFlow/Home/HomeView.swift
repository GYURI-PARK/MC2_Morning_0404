//
//  HomeView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/08.
//

import SwiftUI

struct HomeView: View {

    let user: User?
    @State var selectedTabTag = 0
    
    var body: some View {
        NavigationView{
            ZStack {
                HomeBackground()
                TabView(selection: $selectedTabTag) {
                    MyYomangView(user: user ?? nil)
                        .tag(0)
                    YourYomangView(imageUrl: user?.imageUrl ?? nil)
                        .tag(1)
                }
                .accentColor(Color.white)
                .navigationTitle(selectedTabTag == 0 ? "나의 요망" : "너의 요망")
                .tabViewStyle(.page(indexDisplayMode:.always))
                .navigationBarTitleDisplayMode(.large)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .navigationViewStyle(.stack)
            }//ZStack
        }//NavigationView
    }
}



//Home 장면 배경_우측
struct HomeBackground: View {
    
    var body: some View {
        Rectangle()
            .fill(LinearGradient(colors: [Color.black, Color(hex: 0x221D35)], startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
    }
}
