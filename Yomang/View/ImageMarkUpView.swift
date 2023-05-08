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
    @State private var offset: CGFloat = 1.0
    @State private var pencilOpacity: CGFloat = 1.0
    
    var body: some View {
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            VStack(alignment: .center) {
                HStack {
                    Button(action: {
                        print("취소버튼 -> 모달창 닫힘")
                    }, label: {
                        Text("취소")
                            .foregroundColor(Color(hex: 0x7638F9))
                            .fontWeight(.semibold)
                    })
                    
                    Spacer()
                    
                    Text("요망 만들기")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Button(action: {
                        print("저장후 모달창 닫힘")
                    }, label: {
                        Text("완료")
                            .foregroundColor(Color(hex: 0x7638F9))
                            .fontWeight(.semibold)
                    })
                    
                    
                }.padding(.horizontal, 20).padding(.vertical, 30)
                
                Spacer()
                // 뒤로가기 / 앞으로가기 버튼
                
                HStack{
                    Button {
                        let last = lines.removeLast()
                        deletedLines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: 0xEBEBF5))
                    }.disabled(lines.count == 0)
                    
                    Button {
                        let last = deletedLines.removeLast()
                        lines.append(last)
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: 0xEBEBF5))
                    }.disabled(deletedLines.count == 0)
                    
                    Spacer()
                    Button {
                        lines.removeAll()
                    } label: {
                        Image(systemName: "trash.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: 0xEBEBF5))
                    }.disabled(lines.count == 0)
                    
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
            

                Spacer()
                
                
                // 색깔고르는칸
                HStack {
                    Spacer()
                    
                    HStack(alignment: .center){
                        ColorPickerView(selectedColor: $selectedColor).padding(.horizontal, 5)
                        
                        ColorPicker("", selection: $selectedColor).labelsHidden()
                            .frame(width: 30, height: 30)//.padding(.horizontal, 5)
                    }
                    Spacer()
                }.frame(width: 358, height: 72)
                Spacer(minLength: 30)
                
                
                PencilWeightView(selectedWeight: $selectedWeightDouble)
                    .onChange(of: selectedWeightDouble) { newWeight in
                        currentLine.fontWeight = newWeight
                        print("\(newWeight)")
                        print(type(of: newWeight))
                    }
                
                Spacer()
                
                // 투명도 슬라이드
//                HStack{
//                    Text("OPACITY").foregroundColor(Color(hex: 0xEBEBF5))
//
//                    Spacer()
//
//                    Slider(value: $opacity, in: 0.1...1.0) {
//                    }
//                    .frame(maxWidth: 130)
//                    .onChange(of: opacity) { newOpacity in
//                        currentLine.lineOpacity = newOpacity
//                    }
//                }.frame(width: 300)
                CustomSliderView(offset: $offset, opacity: $pencilOpacity).onChange(of: pencilOpacity) { newOpacity in
                    currentLine.lineOpacity = newOpacity
                }.padding(.bottom, 20)
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

    var body: some View {
        ZStack(alignment: Alignment(horizontal: .leading, vertical: .center), content: {
            Capsule()
                .fill(LinearGradient(gradient: Gradient(colors: [.black, .gray, .white]), startPoint: .leading, endPoint: .trailing)).opacity(0.5)
                .frame(width: 230, height: 30)

            Circle()
                .fill(Color.white)
                .frame(width: 25, height: 25)
                .offset(x: offset)
                .gesture(DragGesture().onChanged({(value) in
                    if value.location.x > 25 && value.location.x <=
                        UIScreen.main.bounds.width - 150 {
                        print("dfsfdf",value.location.x)
                        offset = value.location.x - 26
                        
                        opacity = abs(offset) / 150
                        if opacity > 1.0 {
                            opacity = 1.0
                        } else if opacity < 0.2 {
                            opacity = 0.2
                        }
                        
                        print("opacity", opacity)
                        print("offset", offset)
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

struct ImageMarkUpView_Previews: PreviewProvider {
    static var previews: some View {
        ImageMarkUpView()
    }
}
