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
            if let _ = user {
                YomangImageView()
            } else {
                YomangImageView()
                VStack (alignment: .center) {
                    Text("이곳을 눌러\n파트너와 연결해 보세요")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
