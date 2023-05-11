//
//  TestView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/05/10.
//

import SwiftUI

struct TestView: View {
    
    var body: some View {
        NavigationView{
                    ZStack{
                        HStack{
                            Spacer()
                            NavigationLink(destination: ImageMarkUpView()){
                                Text("hello world")
                            }
                            Spacer()
                        }
                    }
        }.navigationBarBackButtonHidden()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
