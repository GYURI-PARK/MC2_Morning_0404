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
            Image(uiImage: image).resizable().scaledToFit()
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

// MARK: - 0507 Jose Add
struct CropYomangView: View {
    @ObservedObject var viewModel: YomangViewModel
    
    // navigation back button
    @Environment(\.dismiss) private var dismiss
    
    @State var currentOffset = CGSize.zero
    @State var currentScale: CGFloat = 1.0
    @State var gestureOffset = CGSize.zero
    @State var gestureScale: CGFloat = 1.0
    
    @State var editted: Bool = false
    
    // navigation cancel
    @State var cancel: Bool = false
    // save image
    @State var cropped: Bool = false
    
    private let barHeightFactor = 0.15
    
    @Binding var isPressed: Bool // from MyYomangView
    
    var body: some View {
        
        GeometryReader { geometry in
            
            let dragGesture = DragGesture()
                .onChanged { value in
                    gestureOffset = value.translation
                }
                .onEnded { _ in
                    
                    
                    withAnimation {
                        
                        let tempWidth = (gestureOffset.width + currentOffset.width)
                        
                        let originSize = viewModel.orgImage!.size
                        
                        let viewScale: CGFloat = max( originSize.width / UIScreen.main.bounds.width, originSize.height / UIScreen.main.bounds.height)
                        
                        let imageReal = CGSize(width: originSize.width / viewScale, height: originSize.height / viewScale)
                        
                        
                        var currentWidth = tempWidth <= -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale ?  -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale : tempWidth
                        
                        currentWidth = currentWidth >= (currentScale - 1.0) * WIDGET_WIDTH / 2 + (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_WIDTH / 2 + (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale : currentWidth
                        
                        let tempHeight = (gestureOffset.height + currentOffset.height)
                        
                        var currentHeight = (tempHeight <= -1 * (currentScale - 1.0) * WIDGET_HEIGHT / 2 - (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale) ? -1 * (currentScale - 1.0) * WIDGET_HEIGHT / 2 - (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale : tempHeight
                        
                        currentHeight = currentHeight >= (currentScale - 1.0) * WIDGET_HEIGHT / 2 +  (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_HEIGHT / 2 + (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale : currentHeight
                        
                        currentOffset = CGSize(width: currentWidth, height: currentHeight)
                        
                        print(currentOffset)
                        
                        viewModel.currentOffset = currentOffset
                        
                        gestureOffset = .zero
                        
                        editted = true
                    }
                }
            ZStack {
                YomangImage(imageState: viewModel.imageState)
                //                        .scaleEffect(gestureScale * currentScale)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                    .blur(radius: 10)
                    .gesture(dragGesture)
                //                        .gesture(magnificationGesture)
                    .overlay{
                        Color.black.opacity(0.6)
                    }
                    .overlay{
                        
                        
                        
                        YomangImage(imageState: viewModel.imageState)
                            .scaledToFit()
                        //                                .scaleEffect(gestureScale * currentScale)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                            .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                            .gesture(dragGesture)
                        //                                .gesture(magnificationGesture)
                            .mask{
                                RoundedRectangle(cornerRadius: 22)
                                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT
                                    )
                            }
                    }
            }
            .overlay(alignment: .bottom) {
                bottomButtonsView()
                    .frame(height: geometry.size.height * self.barHeightFactor)
            }
            
            .overlay(alignment: .center)  {
                Color.clear
                    .frame(height: geometry.size.height * (1 - (self.barHeightFactor * 2)))
                    .accessibilityElement()
                    .accessibilityLabel("View Finder")
                    .accessibilityAddTraits([.isImage])
            }
            .overlay(alignment: .top) {
                topButtonsView()
                    .frame(height: geometry.size.height * self.barHeightFactor)
            }
            .background(.black)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden(true)
    }
    
    private func topButtonsView() -> some View {
        
        ZStack{
            
            if editted {
                Button(action: {
                    withAnimation {
                        currentOffset = CGSize.zero
                        currentScale = 1.0
                        gestureOffset = CGSize.zero
                        gestureScale = 1.0
                        viewModel.currentOffset = CGSize.zero
                        
                        editted = false
                    }
                }){
                    Text("재설정").foregroundColor(.yellow).font(.system(size: 14))
                }
            }
        }
    }
    
    private func cropImage(_ inputImage: UIImage?, toRect: CGRect, viewScale: CGFloat) -> UIImage? {
        
        let inputImage = inputImage!
        
        let cropZone = CGRect(origin: CGPoint(x: (toRect.origin.x - viewModel.currentOffset.width) * viewScale,
                                              y: (toRect.origin.y - viewModel.currentOffset.height) * viewScale), size: CGSize(
                                                width: WIDGET_WIDTH * viewScale,
                                                height: WIDGET_HEIGHT *  viewScale ))
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone) else { return nil }
        
        let data = UIImage(cgImage: cutImageRef, scale: inputImage.imageRendererFormat.scale, orientation: inputImage.imageOrientation)
        
        return data
    }
    
    private func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up)   {
            return img
        }
        
        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage
    }
    
    private func bottomButtonsView() -> some View {
        HStack(spacing: 60) {
            
            Button(action: {
                // back button
                viewModel.cancel = true
                dismiss()
                
            }){
                Text("취소").foregroundColor(.white).padding()
            }
            
            Spacer()
            
            ZStack{
                
                Button(action: {
                    //TODO: - 사진 저장해야 함!
                    
                    var image = fixOrientation(img: viewModel.orgImage!)
                    
                    var viewScale: CGFloat = max( image.size.width / UIScreen.main.bounds.width, image.size.height / UIScreen.main.bounds.height)
                    
                    
                    image = cropImage(image, toRect: CGRect(
                        origin: CGPoint(x: (image.size.width / viewScale - WIDGET_WIDTH) / 2 ,
                                        y: (image.size.height / viewScale - WIDGET_HEIGHT) / 2),
                        size: CGSize(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                    ), viewScale: viewScale)!
                    viewModel.savedImage = image
                    cropped = true
                }){
                    ZStack{
                        Text("꾸미기")
                            .foregroundColor(.yellow)
                            .padding()
                        
                        NavigationLink("", destination: ImageMarkUpView(viewModel: viewModel, savedImage: $viewModel.savedImage, isPressed: $isPressed), isActive: $cropped)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}
