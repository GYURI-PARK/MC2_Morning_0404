//
//  YomangImageView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/05.
//
// 요망 이미지 선택하기
// 호제가

import SwiftUI
import PhotosUI

// MARK: - 요망 사진 상태뷰
struct YomangImage: View {
    let imageState: YomangViewModel.ImageState
    
    var body: some View {
        switch imageState {
        case .success(let image):
            image.resizable()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "person.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.white)
        }
    }
}

// MARK: - 요망 테두리 포함뷰
struct FrameYomangImage: View {
    let imageState: YomangViewModel.ImageState
    
    var body: some View {
        YomangImage(imageState: imageState)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .frame(width: 300, height: 300)
            .overlay(RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.green, lineWidth: 2).frame(width: 300, height: 300))
            .shadow(color: .white, radius: 15)
    }
}

// MARK: - 요망 선택하기
struct EditableYomangImage: View {
    @StateObject var viewModel: YomangViewModel
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImageData: Data? = nil
    @State private var retrieveImage: UIImage? = nil
    
    var body: some View {
        
        VStack(){
            FrameYomangImage(imageState: viewModel.imageState)
            Spacer()
            
            Image(uiImage: viewModel.uiImage ?? UIImage()).resizable().aspectRatio(contentMode: .fit)
            
            Button(action: {
                viewModel.uploadImage(image: selectedImageData, imageName : "abc")
            }, label: {Text("파이어베이스에 저장")})
            
            Button(action: {
                viewModel.downloadImage(imageName: "abc")
            }, label: {Text("파이어베이스 불러오기")})
            
            Spacer()
            
            PhotosPicker(selection: $viewModel.imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
            //TODO: 요망 선택하기 버튼
                if selectedImageData == nil {
                    Text("요망 선택하기")
                        .symbolRenderingMode(.multicolor)
                        .font(.system(size: 15))
                        .foregroundColor(.accentColor)
                                } else {
                                    Text("요망 선택됨")
                                        .symbolRenderingMode(.multicolor)
                                        .font(.system(size: 15))
                                        .foregroundColor(.accentColor)
                                }
                //이미지가 바뀌면 포토피커 데이터를 저장
            }.onChange(of: viewModel.imageSelection) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImageData = data
                        }
                    }
                }
        }
    }
}

struct YomangImage_Previews: PreviewProvider {
    static var previews: some View {
        @StateObject var yo: YomangViewModel = YomangViewModel()
        EditableYomangImage(viewModel: yo)
    }
}

