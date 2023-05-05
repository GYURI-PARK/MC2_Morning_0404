//
//  MyYomangView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/05.
//
// 너의 요망 나의 요망 뷰!

import SwiftUI
import PhotosUI

// 요망 뷰. 추후에 클레어에 의해 덮어쓰일 겁니다!
struct MyYomangView: View {
    @StateObject var viewModel = YomangModel()
    
    var body: some View {
        NavigationView {
            HStack {
                Spacer()
                EditableYomangImage(viewModel: viewModel)
                Spacer()
            }.navigationTitle("나의 요망")
        }
    }
}
