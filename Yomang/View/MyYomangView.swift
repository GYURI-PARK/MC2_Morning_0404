//
//  MyYomangView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/07.
//
//
import SwiftUI

struct MyYomangView: View {
    @EnvironmentObject var viewModel: YomangViewModel
    var body: some View {
        NavigationView{
            
            ZStack{
                HStack{
                    Spacer()
                    //MARK: - 요망 선택하기를 클릭해 사진을 가져옵니다.
                    EditableYomangImage(viewModel: _viewModel, selected: false, cancel: false)
                    Spacer()
                }
            }
        }
    }
}
//
//struct MyYomangView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyYomangView()
//            .environmentObject(YomangViewModel())
//    }
//}
