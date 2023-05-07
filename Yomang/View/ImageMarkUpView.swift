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
    @State private var selectedColor: Color = .red
    @State private var thickness: Double = 5.0
    @State private var opacity: Double = 1.0
    
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
                
                //  사진
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        context.stroke(path, with: .color(line.color.opacity(line.lineOpacity)), lineWidth: line.lineWidth)
                    }
                }
                .frame(width: 338, height: 354)
                .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        let newPoint = value.location
                        if value.translation.width + value.translation.height == 0 {
                            lines.append(Line(points: [newPoint], color: selectedColor, lineWidth: thickness, lineOpacity: opacity))
                        } else {
                            let index = lines.count - 1
                            lines[index].points.append(newPoint)
                        }
                    })
                    .onEnded({ value in
                        self.currentLine = Line(points: [], color: selectedColor, lineWidth: thickness, lineOpacity: opacity)
                    })
                )
            
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
                }.padding(.vertical, 20).padding(.trailing, 240)
                
                // 색깔고르는칸
                HStack {
                    Spacer()
                    
                    Rectangle().frame(width: 72, height: 72).cornerRadius(10)
                        .foregroundColor(selectedColor)
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        ColorPickerView(selectedColor: $selectedColor).padding(.horizontal, 5)
                        
                        Spacer()
                        
                        ColorPicker("", selection: $selectedColor).labelsHidden()
                            .frame(width: 30, height: 30).padding(.horizontal, 7)
                    }
                    Spacer()
                }.frame(width: 358, height: 72)
                Spacer(minLength: 30)
                
                // 굵기 슬라이드
                HStack{
                    Text("THICKNESS").foregroundColor(Color(hex: 0xEBEBF5))
                    Spacer()
                    
                    Slider(value: $thickness, in: 1...20) {
                    }
                    .frame(maxWidth: 130)
                    .onChange(of: thickness) { newThickness in
                        currentLine.lineWidth = newThickness
                    }
                }.frame(width: 300)
                // 투명도 슬라이드
                HStack{
                    Text("OPACITY").foregroundColor(Color(hex: 0xEBEBF5))
                    
                    Spacer()
                    
                    Slider(value: $opacity, in: 0.1...1.0) {
                    }
                    .frame(maxWidth: 130)
                    .onChange(of: opacity) { newOpacity in
                        currentLine.lineOpacity = newOpacity
                    }
   
                }.frame(width: 300)
                Spacer(minLength: 50)
            }
        }
    }
}

struct Line {
    var points = [CGPoint]()
    var color: Color = .red
    var lineWidth: Double = 1.0
    var lineOpacity: Double = 1.0
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
