//
//  YomangImageView.swift
//  Yomang
//
//  Created by 제나 on 2023/05/15.
//
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

// MARK: - 요망 사진 상태뷰
struct YomangCroppedImage: View {
    let imageCroppedState: YomangViewModel.ImageCroppedState

    var body: some View {
        switch imageCroppedState {
        case .success(let image):
            Image(uiImage: image).resizable().scaledToFit()
//            image.resizable().scaledToFit()
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
// MARK: - 요망 선택하기
struct EditableYomangImage: View {
    @ObservedObject var viewModel: YomangViewModel
    @State var selected: Bool = false
    @State var cancel: Bool = false

    var body: some View {

            ZStack{
                VStack(){
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

    @State var currentOffset = CGSize.zero
    @State var currentScale: CGFloat = 1.0
    @State var gestureOffset = CGSize.zero
    @State var gestureScale: CGFloat = 1.0

    // for 재설정
    @State var editted: Bool = false

    // navigation cancel
    @State var cancel: Bool = false

    // save image
    @State var cropped: Bool = false

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


                        var currentWidth = tempWidth < -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale ?  -(currentScale - 1.0) * WIDGET_WIDTH / 2 - (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale : tempWidth

                        currentWidth = currentWidth > (currentScale - 1.0) * WIDGET_WIDTH / 2 + (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale ? (currentScale - 1.0) * WIDGET_WIDTH / 2 + (geometry.size.width - WIDGET_WIDTH ) / 2 * currentScale : currentWidth

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
                    YomangImage(imageState: viewModel.imageState)
//                        .rotationEffect(.degrees(Double(degree)))
                        .scaleEffect(gestureScale * currentScale)
                        .frame(width: geometry.size.width, height: geometry.size.height)
//                        .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))
                        .offset(CGSize(width: gestureOffset.width + currentOffset.width, height: gestureOffset.height + currentOffset.height))
                        .blur(radius: 10)
                        .gesture(dragGesture)
                        .gesture(magnificationGesture)

                        .overlay{
                            Color.black.opacity(0.6)
                        }
                        .overlay{
                            YomangImage(imageState: viewModel.imageState)
//                                .rotationEffect(.degrees(Double(degree)))
                                .scaledToFit()
                                .scaleEffect(gestureScale * currentScale)
                                .frame(width: geometry.size.width, height: geometry.size.height)
//                                .rotation3DEffect(.degrees(flipped ? 180 : 0), axis: (x:0, y:1, z:0))
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

            if editted {
                    Button(action: {
                        withAnimation {
                            currentOffset = CGSize.zero
                            currentScale = 1.0
                            gestureOffset = CGSize.zero
                            gestureScale = 1.0

                            editted = false
                        }
                    }){
                        Text("재설정").foregroundColor(.yellow).font(.system(size: 14))
                    }
                }
            }
    }

    private func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage?
    {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)

        // Scale cropRect to handle images larger than shown-on-screen size
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)

        // Perform cropping in Core Graphics
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone)
        else {
            return nil
        }

        print("cropped")

        // Return image to UIImage
        let croppedImage: UIImage = UIImage(cgImage: cutImageRef)
        return croppedImage
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
                    //                dismiss()
                    viewModel.savedImage = cropImage(viewModel.savedImage!, toRect: CGRect(origin: CGPoint(x: (UIScreen.self.main.bounds.width - WIDGET_WIDTH) / 2, y: (UIScreen.self.main.bounds.height - WIDGET_WIDTH) / 2), size: CGSize(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)), viewWidth: UIScreen.main.bounds.width, viewHeight: UIScreen.main.bounds.height)
                    cropped = true
                }){

                    NavigationLink(destination: ImageMarkUpView(viewModel: viewModel, savedImage: $viewModel.savedImage)){
                        Text("꾸미기").foregroundColor(.yellow).padding()
                    }.accentColor(Color(hex: 0x7638F9))
                }.accentColor(Color(hex: 0x7638F9))



            }
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
}
