//
//  MatchingCodeViewTest.swift
//  Yomang
//
//  Created by NemoSquare on 2023/05/05.
//

import SwiftUI

struct MatchingCodeViewTest: View {
    @StateObject var matchingCodeViewModel = MatchingCodeViewModel()
    
    var body: some View {
        VStack{
            Text(matchingCodeViewModel.user.userID)
        }.onAppear(){
            matchingCodeViewModel.registerUser()
        }
    }
}

struct MatchingCodeViewTest_Previews: PreviewProvider {
    static var previews: some View {
        MatchingCodeViewTest()
    }
}
