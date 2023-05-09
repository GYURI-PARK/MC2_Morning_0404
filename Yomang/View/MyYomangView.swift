//
//  MyYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/09.
//

import SwiftUI

struct MyYomangView: View {
    var body: some View {
        NavigationView {
            VStack {
                Rectangle()
                    .fill(.gray)
                    .frame(width: 338, height: 354)
                    .cornerRadius(22)
            }
            .navigationTitle("나의 요망")
        }
    }
}


struct MyYomangView_Previews: PreviewProvider {
    static var previews: some View {
        MyYomangView()
    }
}
