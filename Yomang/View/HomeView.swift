//
//  HomeView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/08.
//

import SwiftUI

struct HomeView: View {

    let user: User?
    @State var selectedTabTag = 1
    var body: some View {
        NavigationView{
            TabView(selection: $selectedTabTag) {
                YourYomangView(imageUrl: user?.imageURL ?? nil)
                    .tag(0)
                MyYomangView(user: user ?? nil)
                    .tag(1)
            }
            .accentColor(Color.white)
            .navigationTitle(selectedTabTag == 1 ? "나의 요망" : "너의 요망")
            .tabViewStyle(.page(indexDisplayMode:.always))
            .navigationBarTitleDisplayMode(.large)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .navigationViewStyle(.stack)
            .background(LinearGradient(colors: [Color.black, Color(hex: 0x221D35)], startPoint: .top, endPoint: .bottom))
        }
    }
}
