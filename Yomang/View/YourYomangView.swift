//
//  YourYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/04.
//

import SwiftUI

struct YourYomangView: View {
    var body: some View {
        TabView {
            YourYomang()
            MyYomangView()
        }
        .tabViewStyle(.page(indexDisplayMode:.always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .navigationViewStyle(.stack)
        .navigationBarTitleDisplayMode(.inline)
        .padding(20)
    }
}


struct YourYomang: View {
    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .fill(.gray)
                    .frame(width: 338, height: 354)
                    .cornerRadius(22)
            }
            .navigationTitle("너의 요망")
        }
    }
}

struct MyYomangView: View {
    var body: some View {
        NavigationView {

                Text("dd")
                    .navigationBarTitle("skd")
                    .padding(.leading, 16)

        }
    }
}


struct YourYomangView_Previews: PreviewProvider {
    static var previews: some View {
        YourYomangView()
    }
}
