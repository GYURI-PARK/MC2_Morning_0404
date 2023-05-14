//
//  MyYomangView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/07.
//
<<<<<<< HEAD

import SwiftUI

struct MyYomangView: View {
    @StateObject var viewModel = YomangViewModel()
    
    var body: some View {
        NavigationView{
            
            ZStack{
                HStack{
                    Spacer()
                    //MARK: - 요망 선택하기를 클릭해 사진을 가져옵니다.
                    EditableYomangImage(viewModel: viewModel)
=======
//
import SwiftUI

struct MyYomangView: View {

    @EnvironmentObject var viewModel: YomangViewModel
    @Binding var renderedImage: Image?
//    @State var renderedImage: Image?
    
    var body: some View {
        NavigationView{

            ZStack{
                VStack{
                    Spacer()
                    if let renderedImage {
                        renderedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 338, height: 354)
                    } else {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 338, height: 354)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    //MARK: - 요망 선택하기를 클릭해 사진을 가져옵니다.
                    EditableYomangImage(viewModel: _viewModel, selected: false, cancel: false)
>>>>>>> a580a5dd2b1b11b42ac7ad812168e5ec2c8772ba
                    Spacer()
                }
            }
        }
    }
}

<<<<<<< HEAD
struct MyYomangView_Previews: PreviewProvider {
    static var previews: some View {
        MyYomangView()
    }
}
=======
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
>>>>>>> a580a5dd2b1b11b42ac7ad812168e5ec2c8772ba
