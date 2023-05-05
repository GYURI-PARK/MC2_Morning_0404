//
//  MatchingLoadingView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//

import SwiftUI

struct MatchingLoadingView: View {
    var body: some View {
        VStack{
            Text("상대와 연결 대기중")
            Text("혹시나 잘못입력하면 돌아가서 수정해야하니 back버튼 존재")
        }
    }
}

struct MatchingLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingLoadingView()
    }
}
