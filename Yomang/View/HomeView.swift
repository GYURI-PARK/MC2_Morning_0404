//
//  HomeView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/08.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            YourYomangView()
            MyYomangView()
        }
        .tabViewStyle(.page(indexDisplayMode:.always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
