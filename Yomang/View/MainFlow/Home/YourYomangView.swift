//
//  YourYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/04.
//

import SwiftUI

struct YourYomangView: View {
    
    let imageUrl: String?
    
    var body: some View {
        ZStack {
            if let _ = imageUrl {
                // TODO: Image
                YomangImageView()
            } else {
                YomangImageView()
                VStack (alignment: .center) {
                    Text("대기 중")
                        .font(.title)
                        .fontWeight(.bold)
                        .frame(height: 36)
                        .foregroundColor(.white)
                    
                    Text("상대의 첫 요망을 기다리고 있어요!")
                        .font(.body)
                        .fontWeight(.regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }
    }
}
