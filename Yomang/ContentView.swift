//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = YomangViewModel()
    
    var body: some View {
        NavigationView{
            HStack{
                Spacer()
                //MARK: - 요망 선택하기를 클릭해 사진을 가져옵니다.
                EditableYomangImage(viewModel: viewModel)
                Spacer()
            }.navigationTitle("나의 요망")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
