//
//  ImageMarkUpView.swift
//  MarkUp
//
//  Created by GYURI PARK on 2023/05/05.
//

import SwiftUI

struct ImageMarkUpView: View {
    
    @State private var currentLine = Line()
    @State private var deletedLines = [Line]()
    @State private var lines = [Line]()
    @State var selectedColor: Color = .white
    @State var selectedWeightDouble: Double = 4.0
    @State private var offset: CGFloat = 205.0
    @State private var pencilOpacity: CGFloat = 1.0
    @State private var showPopover: Bool = false
    @State var selectedIndex: Int = 2
    
    @ObservedObject var viewModel: YomangViewModel
    @EnvironmentObject var ani: AnimationViewModel
    @Binding var savedImage: UIImage?
    
    @State var test = true
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPressed: Bool // from MyYomangView
    
    var body: some View {
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            
            VStack(alignment: .center) {
                
                Spacer(minLength: 160)
                //  사진
                canvasImage
                    .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                    .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let newPoint = value.location
                            if value.translation.width + value.translation.height == 0 {
                                lines.append(Line(points: [newPoint], color: selectedColor, lineOpacity: pencilOpacity, fontWeight: selectedWeightDouble))
                            } else {
                                let index = lines.count - 1
                                lines[index].points.append(newPoint)
                            }
                        })
                            .onEnded({ value in
                                self.currentLine = Line(points: [], color: selectedColor, lineOpacity: pencilOpacity, fontWeight: selectedWeightDouble)
                            })
                    )
                
                Spacer(minLength: 140)
                
                ZStack{
                    Color(hex: 0x2F3031).ignoresSafeArea()
                    
                    VStack{
                        HStack{
                            Spacer()
                            ColorPickerView(selectedColor: $selectedColor)
                                .padding(.leading, 18)
                            
                            ColorPicker("", selection: $selectedColor)
                                .labelsHidden()
                                .padding(.horizontal, 7)
                            
                            Spacer()
                            
                            Image(systemName: "scribble.variable")
                                .padding()
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                                .onTapGesture {
                                    showPopover.toggle()
                                }
                                .iOSPopover(isPresented: $showPopover, arrowDirection: .down) {
                                    VStack{
                                        PencilWeightView(selectedWeight: $selectedWeightDouble, selectedIndex: $selectedIndex)
                                            .onChange(of: selectedWeightDouble) { newWeight in
                                                currentLine.fontWeight = newWeight
                                            }
                                        Spacer()
                                        CustomSliderView(offset: $offset, opacity: $pencilOpacity, selectedColor: $selectedColor).onChange(of: pencilOpacity) { newOpacity in
                                            currentLine.lineOpacity = newOpacity
                                        }
                                    }
                                    .padding(5)
                                }
                            Spacer()
                        }
                    }
                    Spacer()
                }
            }
            .navigationBarTitle("요망 꾸미기", displayMode: .inline)
            .navigationBarItems(leading:
                                    HStack{
                Button {
                    let last = lines.removeLast()
                    deletedLines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.backward.circle")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color(hex: 0xEBEBF5))
                }.padding(.trailing, 5)
                    .disabled(lines.count == 0)
                    .colorMultiply(lines.count > 0 ? Color(hex: 0x7638F9) : .gray)
                
                
                Button {
                    let last = deletedLines.removeLast()
                    lines.append(last)
                } label: {
                    Image(systemName: "arrow.uturn.forward.circle")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundColor(Color(hex: 0xEBEBF5))
                }
                .padding(.leading, 5)
                .disabled(deletedLines.count == 0)
                .colorMultiply(deletedLines.count > 0 ? Color(hex: 0x7638F9) : .gray)
            }
                                , trailing: Button(action: {
                ani.loadSavedData()
                ani.isBackgroundChanging = false
                ani.moonAngle = 0 - ani.limitAngle
                ani.timeFromStart = 0.0
                ani.isImageUploaded = true
                DispatchQueue.main.async {
                    withAnimation(.easeInOut(duration: 1)) {
                        ani.moonAngle = -ani.limitAngle + ani.startAngle
                    }
                }
                ani.calculateTimeLeft()
                ani.timeFromStart = ani.timeFromNow
                ani.saveData()
                let renderer = ImageRenderer(content: canvasImage)
                renderer.scale = 3
                if let renderedImage = renderer.uiImage {
                    isPressed = false
                    viewModel.renderedImage = Image(uiImage: renderedImage)
                    AuthViewModel.shared.uploadImage(image: renderedImage) {
                        NavigationUtil.popToRootView()
                    }
                }
            }){
                Text("완료")
                    .foregroundColor(Color(hex: 0x7638F9))
                    .font(.system(size: 17, weight: .bold))
            }
            )
            .toolbarBackground(Color(hex: 0x2F3031), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
    
    var canvasImage: some View {
        Canvas { context, size in
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context.stroke(path, with: .color(line.color.opacity(line.lineOpacity)) , style: StrokeStyle(lineWidth: line.fontWeight, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
        .background {
            if let savedImage = savedImage {
                Image(uiImage: savedImage)
                    .resizable()
                    .scaledToFill()
                    .cornerRadius(20)
            }
        }
    }
}

struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var lineOpacity: CGFloat = 1.0
    var fontWeight: Double = 0.23
}

struct CustomSliderView: View {
    
    @Binding var offset: CGFloat
    @Binding var opacity: CGFloat
    @Binding var selectedColor: Color
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [selectedColor.opacity(0.1), selectedColor]), startPoint: .leading, endPoint: .trailing)).opacity(0.7)
                .frame(width: 230, height: 22)
            
            Circle()
                .fill(Color.white)
                .frame(width: 35, height: 35)
                .offset(x: offset)
                .gesture(DragGesture().onChanged({(value) in
                    if value.location.x > 23 && value.location.x <=
                        UIScreen.main.bounds.width - 160 {
                        offset = value.location.x - 26
                        opacity = abs(offset) / 180
                        if opacity > 1.0 {
                            opacity = 1.0
                        } else if opacity < 0.15 {
                            opacity = 0.15
                        }
                    }
                }))
        })
    }
}

extension View{
    @ViewBuilder
    func iOSPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection: UIPopoverArrowDirection, @ViewBuilder content: @escaping() -> Content) -> some View {
        self.background {
            PopOverController(isPresented: isPresented, arrowDirection: arrowDirection, content: content())
        }
    }
}

struct PopOverController<Content: View>: UIViewControllerRepresentable{
    
    @Binding var isPresented: Bool
    var arrowDirection: UIPopoverArrowDirection
    var content: Content
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        controller.view.backgroundColor = .clear
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if isPresented {
            // presenting popover
            let controller = CustomHostingView(rootView: content)
            controller.view.backgroundColor =  UIColor(red: 0.149, green: 0.149, blue: 0.149, alpha: 1)
            controller.modalPresentationStyle = .popover
            controller.popoverPresentationController?.permittedArrowDirections = arrowDirection
            
            // Connecting Delegate
            controller.presentationController?.delegate = context.coordinator
            // We need to attach the source view so that it will show arrow at correct position
            controller.popoverPresentationController?.sourceView = uiViewController.view
            // Simply Presenting Popover Controller
            uiViewController.present(controller, animated: true)
        }
    }
    
    // Forcing it to show Popover using PresentationDelegate
    class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        var parent: PopOverController
        init(parent: PopOverController) {
            self.parent = parent
        }
        
        func adaptivePresentationStyle(for controller: UIPresentationController) ->
        UIModalPresentationStyle {
            return .none
        }
        
        // Observing the status of the popover
        // when it's dismissed updating the isPresented State
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
        }
    }
}

// Custom hosting controller for wrapping to it's SwiftUI view Size
class CustomHostingView<Content: View>: UIHostingController<Content>{
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredContentSize = view.intrinsicContentSize
    }
}
