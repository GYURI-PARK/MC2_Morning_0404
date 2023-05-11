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
            YomangImageView()
            
            VStack (alignment: .center) {
                if let url = imageUrl {
                    // TODO: Image
                } else {
                    Text("클릭해서\n상대방과 연결해요")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}
