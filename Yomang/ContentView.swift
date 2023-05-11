//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @EnvironmentObject var viewModel: YomangViewModel
    
    var body: some View {
        MyYomangView()
//        VStack{
//            Text("test")
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
