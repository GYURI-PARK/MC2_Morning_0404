//
//  MyYomangView.swift
//  Yomang
//
//  Created by GYURI PARK on 2023/05/05.
//

import SwiftUI

struct MyYomangView: View {
    var body: some View {
        NavigationView{
                    
                    ZStack{
                        HStack{
                            Spacer()
                            Text("hello world")
                            Spacer()
                        }
                    }
        }.navigationBarBackButtonHidden()
    }
}

struct MyYomangView_Previews: PreviewProvider {
    static var previews: some View {
        MyYomangView()
    }
}
