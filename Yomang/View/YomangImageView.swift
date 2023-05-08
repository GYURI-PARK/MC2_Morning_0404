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
            image.resizable().scaledToFit()
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
    @ObservedObject var viewModel: YomangViewModel
    @State var selected: Bool = false
    @State var cancel: Bool = false
    
    var body: some View {

            ZStack{
                VStack(){
//                    FrameYomangImage(imageState: viewModel.imageState)
                    Spacer()
                    PhotosPicker(selection: $viewModel.imageSelection,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        //TODO: 요망 선택하기 버튼
                        Text("요망 선택하기")
                            .symbolRenderingMode(.multicolor)
                            .font(.system(size: 15))
                            .foregroundColor(.accentColor)
                    }
                    
                    
                }.onChange(of: viewModel.imageSelection){ (imageState) in
                    selected = true
                }
                NavigationLink("", destination: CropYomangView(viewModel: viewModel), isActive: $selected)
            }.photosPicker(isPresented: $viewModel.cancel, selection: $viewModel.imageSelection, matching: .images,
                           photoLibrary: .shared())
    }
}

// MARK: - 0507 Jose Add
struct CropYomangView: View {
    @ObservedObject var viewModel: YomangViewModel
    // navigation back button
    @Environment(\.dismiss) private var dismiss
    
//    @State private var scale: CGFloat = 1.0
//    @State var currentOffset = CGSize.zero
    @State var currentOffset = CGSize.zero
    @State var currentScale: CGFloat = 1.0
    @State var gestureOffset = CGSize.zero
    @State var gestureScale: CGFloat = 1.0
    
    @State var editted: Bool = false
    
    // navigation cancel
    @State var cancel: Bool = false
    
    // rotation Effect
    @State var degree: Int = 0
    // flip Effect
    @State var flipped: Bool = false
    
    
    private let barHeightFactor = 0.15
    
    var body: some View {
        

            GeometryReader { geometry in

                
                
                let dragGesture = DragGesture()
                        .onChanged { value in
                            gestureOffset = value.translation
                            editted = true
                        }
                        .onEnded { _ in
                            withAnimation {
                                
                                let tempWidth = (gestureOffset.width + currentOffset.width)
//
//                                print("currentOffset \(currentOffset)")
//                                print("tempWidth \(tempWidth)")
//                                print("currentScale \(currentScale)")
//                                print("")
                                
//
                        var currentWidth = tempWidth < -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale ?  -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale : tempWidth
                        
                        currentWidth = currentWidth > (currentScale - 1.0) * WIDGET_WIDTH / 2 + (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_WIDTH / 2 + (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale : currentWidth
//
                        let tempHeight = (gestureOffset.height + currentOffset.height)
                                
                        var currentHeight = (tempHeight < -1 * (currentScale - 1.0) * WIDGET_HEIGHT / 2 - (geometry.size.width / 3 * 4 - WIDGET_HEIGHT ) / 2 * currentScale) ? -1 * (currentScale - 1.0) * WIDGET_HEIGHT / 2 - (geometry.size.width / 3 * 4 - WIDGET_HEIGHT ) / 2 * currentScale : tempHeight
                        
                        currentHeight = currentHeight > (currentScale - 1.0) * WIDGET_HEIGHT / 2 +  (geometry.size.width / 3 * 4 - WIDGET_HEIGHT ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_HEIGHT / 2 + (geometry.size.width / 3 * 4 - WIDGET_HEIGHT ) / 2 * currentScale : currentHeight
                        
                        currentOffset = CGSize(width: currentWidth, height: currentHeight)
                        gestureOffset = .zero
                            }
                        }

                    let magnificationGesture = MagnificationGesture()
                        .onChanged { val in
                            let delta = val / gestureScale
                            gestureScale = gestureScale * delta
                            editted = true
                            
                            
                        }
                        .onEnded { val in
                            
                                if (gestureScale >= 2.0) {
                                    withAnimation{
                                        currentScale = 2.0
                                        gestureScale = 1.0
                                    }
                                } else if gestureScale < 1.0 {
                                    withAnimation{
                                        currentScale = 1.0
                                        gestureScale = 1.0
                                    }
                                }
                            
                            else{
                                
                                if (currentScale >= 2.0) {
                                    withAnimation{
                                        currentScale = 2.0
                                        
                                    }
                                } else if currentScale < 1.0 {
                                    withAnimation{
                                        currentScale = 1.0

                                    }
                                }
                                
                                currentScale = gestureScale * currentScale
                                gestureScale = 1.0
                            }
                        }
                

                ZStack {
//                    Image("wave")
                    YomangImage(imageState: viewModel.imageState)
                        .rotationEffect(.degrees(Double(degree)))
                        .scaleEffect(gestureScale * currentScale)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))
                        .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                        .blur(radius: 10)
                        .gesture(dragGesture)
                        .gesture(magnificationGesture)
                    
                        .overlay{
                            Color.black.opacity(0.6)
                        }
                        .overlay{
//                            Image("wave")
                            YomangImage(imageState: viewModel.imageState)
                                .rotationEffect(.degrees(Double(degree)))
                                .scaledToFit()
                                .scaleEffect(gestureScale * currentScale)
                                .frame(width: geometry.size.width, height: geometry.size.height)
                                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))
                                .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                                .gesture(dragGesture)
                                .gesture(magnificationGesture)
                                .mask{
                                    RoundedRectangle(cornerRadius: 22)
                                    .frame(width: 338, height: 354)
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
            
            HStack {
                
                Button(action: {
                    
                    flipped.toggle()
                    editted = true
                    
                }){
                    Image(systemName: "arrow.left.and.right.righttriangle.left.righttriangle.right.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                }.padding()
                
                Button(action: {
                   
                    degree = degree == -270 ? 0 : degree - 90
                    editted = true
                    
                }){
                    Image(systemName: "rotate.left.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                }.padding()
                
                Spacer()
                
                Button(action: {
                    print("markup")
                }){
                    Image(systemName: "pencil.tip.crop.circle")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                    
                }.padding()
                
            }
            .buttonStyle(.plain)
            .labelStyle(.iconOnly)
            .padding()

            if editted {
                    Button(action: {
                        withAnimation {
                            currentOffset = CGSize.zero
                            currentScale = 1.0
                            gestureOffset = CGSize.zero
                            gestureScale = 1.0
                            
                        }
                        
                        flipped = false
                        degree = 0
                        
                        editted = false
                        
                    }){
                        Text("재설정").foregroundColor(.yellow).font(.system(size: 14))
                    }
                }
            }
    }
    
    
    private func bottomButtonsView() -> some View {
        HStack(spacing: 60) {
            
            
            Button(action: {
                // back button
                viewModel.cancel = true
                dismiss()
            }){
                Text("취소").foregroundColor(.white)
            }
            
            Spacer()
            
            Button(action: {
                //TODO: - 사진 저장해야 함!
                dismiss()
                
            }){
                Text("완료").foregroundColor(.yellow)
            }
        
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}


struct CropYomangView_Previews: PreviewProvider {

    static var previews: some View {
        CropYomangView(viewModel: YomangViewModel())
    }
}
