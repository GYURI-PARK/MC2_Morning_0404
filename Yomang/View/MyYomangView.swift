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
            YomangImageView()
            VStack (alignment: .center) {
                Text("확인 중")
                    .font(.title)
                    .fontWeight(.bold)
                    .frame(height: 36)
                
                Text("상대가 내 요망을 확인하고 있어요.\n새로운 요망을 만들어볼까요?")
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
            }
        }
    }
}
