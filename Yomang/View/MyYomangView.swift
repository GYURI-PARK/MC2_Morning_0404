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
//                    
                    Rectangle()
                        .frame(width: 338, height: 354)
//                        .background(
//                            yomangImage != nil ? Image(uiImage: yomangImage!) : nil
//                        )
                    Spacer()
                    //MARK: - 요망 선택하기를 클릭해 사진을 가져옵니다.
                    EditableYomangImage(viewModel: _viewModel, selected: false, cancel: false)
                    Spacer()
                }
            }
        }
    }
}

// import SwiftUI

//struct MyYomangView: View {
//
//    @EnvironmentObject var viewModel: YomangViewModel
//    let user: User?
//
//    var body: some View {
//        ZStack {
//            if let _ = user {
//                EditableYomangImage(viewModel: _viewModel, selected: false, cancel: false)
//            } else {
//                EditableYomangImage(viewModel: _viewModel, selected: false, cancel: false)
//                VStack (alignment: .center) {
//                    Text("이곳을 눌러\n파트너와 연결해 보세요")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//                }
//            }
//        }
//    }
//}
