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
            Image(uiImage: image).resizable()
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
    @EnvironmentObject var ani: AnimationViewModel
    
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
                        
                        var widthDisable = viewModel.imageDirection
                                                   
                        var tempWidth = 0.0
                        
                        var tempHeight = 0.0
                        
                        let originSize = viewModel.orgImage!.size
                        
                        let viewScale: CGFloat = widthDisable ? originSize.width / WIDGET_WIDTH : originSize.height / WIDGET_HEIGHT

                        let imageReal = CGSize(width: originSize.width / viewScale, height: originSize.height / viewScale)


                        withAnimation {
                            
                            if widthDisable {
                                
                                
                                tempHeight = (gestureOffset.height + currentOffset.height)
                                
                                tempHeight = (tempHeight <= -(imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale) ? -(imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale : tempHeight

                                tempHeight = tempHeight >= (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_HEIGHT / 2 + (imageReal.height - WIDGET_HEIGHT ) / 2 * currentScale : tempHeight

                            } else {
                                
                                tempWidth = (gestureOffset.width + currentOffset.width)
                                
                                tempWidth = (tempWidth <= -(imageReal.width - WIDGET_WIDTH ) / 2 * currentScale) ? -(imageReal.width - WIDGET_WIDTH ) / 2 * currentScale : tempWidth

                                tempWidth = tempWidth >= (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_WIDTH / 2 + (imageReal.width - WIDGET_WIDTH ) / 2 * currentScale : tempWidth
                                
                            }
                            
                        currentOffset = CGSize(width: tempWidth, height: tempHeight)
                            
                            viewModel.currentOffset = currentOffset
                            
                            gestureOffset = .zero
                            
                            editted = true
                        }
                    }
//
//                    let magnificationGesture = MagnificationGesture()
//                        .onChanged { val in
//                            let delta = val / gestureScale
//                            gestureScale = gestureScale * delta
//                            editted = true
//
//                        }
//                        .onEnded { val in
//                                if (gestureScale >= 2.0) {
//                                    withAnimation{
//                                        currentScale = 2.0
//                                        gestureScale = 1.0
//                                    }
//                                } else if gestureScale < 1.0 {
//                                    withAnimation{
//                                        currentScale = 1.0
//                                        gestureScale = 1.0
//                                    }
//                                }
//                            else{
//                                if (currentScale >= 2.0) {
//                                    withAnimation{
//                                        currentScale = 2.0
//                                    }
//                                } else if currentScale < 1.0 {
//                                    withAnimation{
//                                        currentScale = 1.0
//                                    }
//                                }
//                                currentScale = gestureScale * currentScale
//                                gestureScale = 1.0
//                            }
//                        }
            
            ZStack {
                Color.clear
                YomangImage(imageState: viewModel.imageState)
                    .scaledToFill()
                    .scaleEffect(gestureScale * currentScale)
                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                
                    .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                    .blur(radius: 10)
                    .gesture(dragGesture)
//                        .gesture(magnificationGesture)
                    .overlay{
                        
                        
                        
                        YomangImage(imageState: viewModel.imageState)
                            .scaledToFill()
                            .scaleEffect(gestureScale * currentScale)
//                                .frame(width: geometry.size.width, height: geometry.size.height)
                            .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                            .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                            .gesture(dragGesture)
//                                .gesture(magnificationGesture)
                            .mask{
                                RoundedRectangle(cornerRadius: 22)
                                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT
                                )
                            }.overlay{
                                RoundedRectangle(cornerRadius: 22) .strokeBorder(.white.opacity(0.5), lineWidth: 1)
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
    
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
                else {
                    return nil
                }

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
                    
                    let widthDisable = viewModel.imageDirection

                    let viewScale: CGFloat = widthDisable ? image.size.width / WIDGET_WIDTH : image.size.height / WIDGET_HEIGHT
                    
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
                        
                        NavigationLink("", destination: ImageMarkUpView(viewModel: viewModel, savedImage: $viewModel.savedImage, isPressed: $isPressed).environmentObject(ani), isActive: $cropped)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}
