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

// 요망 사진 로딩
struct YomangImage: View {
    let imageState: YomangModel.ImageState
    
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

// 요망 테두리 포함
struct FrameYomangImage: View {
    let imageState: YomangModel.ImageState
    
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

struct EditableYomangImage: View {
    @ObservedObject var viewModel: YomangModel
    
    var body: some View {
        
        VStack(){
            // 요망 사진 보여주기
            FrameYomangImage(imageState: viewModel.imageState)
            Spacer()
            PhotosPicker(selection: $viewModel.imageSelection,
                         matching: .images,
                         photoLibrary: .shared()) {
            // 요망 선택하기 버튼
                Text("요망 선택하기")
                    .symbolRenderingMode(.multicolor)
                    .font(.system(size: 15))
                    .foregroundColor(.accentColor)
            }
        }
    }
}
