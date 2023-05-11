//
//  ColorPickerView.swift
//  MarkUp
//
//  Created by GYURI PARK on 2023/05/06.
//

import SwiftUI

struct ColorPickerView: View {
    let colors =  [Color.white, Color.blue, Color.green, Color.yellow, Color.red]
    @Binding var selectedColor: Color
    
    var body: some View {
        HStack {
            ForEach(colors, id: \.self) { color in
                Image(systemName: selectedColor == color ?
                      Constants.Icons.circleCircleFill :
                        Constants.Icons.circleFill)
                .foregroundColor(color)
                .font(.system(size: 22))
                .clipShape(Circle())
                .onTapGesture {
                    selectedColor = color
                }.padding(.horizontal, 4)
            }
        }
    }
}

public func switchFontWeight(for font: Font.Weight) -> Double{
    switch font {
    case .ultraLight:
        return 1.0
    case .light:
        return 3.0
    case .medium:
        return 6.0
    case .bold:
        return 9.0
    case .black:
        return 12.0
    default:
        break
    }
    return 0
}


struct PencilWeightView: View {
    let fonts = [Font.Weight.ultraLight, Font.Weight.light, Font.Weight.medium, Font.Weight.bold, Font.Weight.black]
    
    @Binding var selectedWeight: Double
    @State var selectedIndex: Int?
    
    var body: some View {
        HStack {
            ForEach(Array(fonts.enumerated()), id: \.1) { index, font in
                ZStack {
                    // 배경
                    if index == selectedIndex {
                        Color.white.opacity(1.0)
                            .frame(width: 40, height: 40)
                            .clipShape(Rectangle())
                            .cornerRadius(10)
                        
                        Image(systemName: "scribble.variable")
                            .foregroundColor(.black)
                            .font(.system(size: 22))
                            .fontWeight(font)
                            .clipShape(Circle())
                            .onTapGesture() {
                                selectedWeight = switchFontWeight(for: font)
                                selectedIndex = index
                            }.padding(10)
                    } else{
                        Image(systemName: "scribble.variable")
                            .foregroundColor(.white)
                            .font(.system(size: 22))
                            .fontWeight(font)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedWeight = switchFontWeight(for: font)
                                selectedIndex = index
                            }.padding(10)
                    }
                }
            }
        }
    }
}


struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            
            ColorPickerView(selectedColor: .constant(.blue))
        }
    }
}

//struct PencilWeightView_Previews: PreviewProvider {
//    static var previews: some View {
//        PencilWeightView()
//    }
//}
