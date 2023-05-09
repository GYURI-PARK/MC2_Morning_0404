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
    //@State private var isSelected: Bool = false
    
    var body: some View {
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            GeometryReader { geometry in
                VStack(alignment: .center) {
                    HStack {
                        Button(action: {
                            print("취소버튼 -> 모달창 닫힘")
                        }, label: {
                            Text("취소")
                                .foregroundColor(Color(hex: 0x7638F9))
                                .font(.system(size: 17, weight: .regular))
                            
                        })
                        
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
                            .colorMultiply(lines.count > 0 ? .white : .gray)
                        
                        
                        Button {
                            let last = deletedLines.removeLast()
                            lines.append(last)
                        } label: {
                            Image(systemName: "arrow.uturn.forward.circle")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .foregroundColor(Color(hex: 0xEBEBF5))
                        }.padding(.leading, 5)
                            .disabled(deletedLines.count == 0)
                            .colorMultiply(deletedLines.count > 0 ? .white : .gray)
                        
                        Spacer()
                        
                        Text("요망 만들기")
                            .foregroundColor(.white)
                            .font(.system(size: 17, weight: .bold))
                        //.offset(x: geometry.size.width / 2)
                        
                        Spacer(minLength: 100)
                        
                        Button(action: {
                            print("저장후 모달창 닫힘")
                        }, label: {
                            Text("완료")
                                .foregroundColor(Color(hex: 0x7638F9))
                                .font(.system(size: 17, weight: .bold))
                        })
                        
                        
                    }.padding(.horizontal, 20).padding(.vertical, 30)
                    
                    Spacer()
                    // 뒤로가기 / 앞으로가기 버튼
                    
                    HStack{
                        
                        Spacer()
                        
                        
                    }.padding(20)
                    
                    //  사진
                    Canvas { context, size in
                        for line in lines {
                            var path = Path()
                            path.addLines(line.points)
                            context.stroke(path, with: .color(line.color.opacity(line.lineOpacity)), lineWidth: line.fontWeight)
                        }
                    }.background(Color.gray).cornerRadius(20)
                        .frame(width: 338, height: 354)
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
                    
                    
                    //Spacer(minLength: 40)
                    
                    
                    // 색깔고르는칸
                    
                    HStack() {
                        Spacer()
                        
                        HStack(alignment: .center){
                            ColorPickerView(selectedColor: $selectedColor).padding(.horizontal, 5)
                            
                            ColorPicker("", selection: $selectedColor).labelsHidden()
                                .frame(width: 30, height: 30)//.padding(.horizontal, 5)
                            Spacer()
                        }
                        Spacer()
                    }.frame(width: 358, height: 72)
                    
                    Spacer(minLength: 130)
                    
                    // 모두 지우기 + scribble.variable 이미지
                    HStack{
                        Spacer()
                        Button {
                            lines.removeAll()
                        } label: {
                            Text("모두 지우기")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        .disabled(lines.count == 0)
                        .colorMultiply(lines.count > 0 ? .white : .gray)
                        
                        Spacer(minLength: 200)
                        
                        Image(systemName: "scribble.variable").colorInvert()
                            .onTapGesture {
                                showPopover.toggle()
                            }.iOSPopover(isPresented: $showPopover, arrowDirection: .down) {
                                VStack{
                                    Spacer()
                                    PencilWeightView(selectedWeight: $selectedWeightDouble)
                                        .onChange(of: selectedWeightDouble) { newWeight in
                                            currentLine.fontWeight = newWeight
                                        }
                                    Spacer()
                                    CustomSliderView(offset: $offset, opacity: $pencilOpacity, selectedColor: $selectedColor).onChange(of: pencilOpacity) { newOpacity in
                                        currentLine.lineOpacity = newOpacity
                                    }
                                }
//                                .padding(.vertical, 15).padding(.horizontal, 30).background(Rectangle() .foregroundColor(.gray).opacity(0.5)).cornerRadius(20)
                                .padding(15)
                            }
                        
                        Spacer()
                        
                    }
                }
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
                .fill(LinearGradient(gradient: Gradient(colors: [.white, selectedColor]), startPoint: .leading, endPoint: .trailing)).opacity(0.7)
                .frame(width: 230, height: 30)

            Circle()
                .fill(Color.white)
                .frame(width: 40, height: 40)
                .offset(x: offset)
                .gesture(DragGesture().onChanged({(value) in
                    if value.location.x > 25 && value.location.x <=
                        UIScreen.main.bounds.width - 200 {
                        offset = value.location.x - 26
                        
                        opacity = abs(offset) / 150
                        if opacity > 1.0 {
                            opacity = 1.0
                        } else if opacity < 0.2 {
                            opacity = 0.2
                        }
                    }
                }))
        })
    }
}



extension Color {
    init(hex: Int, alpha: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
}

extension View{
    @ViewBuilder
    func iOSPopover<Content: View>(isPresented: Binding<Bool>, arrowDirection:
                                   UIPopoverArrowDirection, @ViewBuilder content: @escaping () -> Content)->some View {
        self
            .background {
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
        if isPresented{
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



struct ImageMarkUpView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMarkUpView()
    }
}
