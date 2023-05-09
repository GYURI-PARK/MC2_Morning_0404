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
                .font(.system(size: 30))
                .clipShape(Circle())
                .onTapGesture {
                    selectedColor = color
                }.padding(.horizontal, 10)
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
        return 5.0
    case .bold:
        return 8.0
    case .heavy:
        return 9.0
    default:
        break
    }
    return 0
}


struct PencilWeightView: View {
    let fonts = [Font.Weight.ultraLight, Font.Weight.light, Font.Weight.medium, Font.Weight.bold, Font.Weight.heavy]
    
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
                            .font(.system(size: 30))
                            .fontWeight(font)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedWeight = switchFontWeight(for: font)
                                selectedIndex = index
                            }
                    } else{
                        Image(systemName: "scribble.variable")
                            .foregroundColor(.white)
                            .font(.system(size: 30))
                            .fontWeight(font)
                            .clipShape(Circle())
                            .onTapGesture {
                                selectedWeight = switchFontWeight(for: font)
                                selectedIndex = index
                            }
                    }
                }
            }
        }
    }
}


//struct ColorPickerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ColorPickerView(selectedColor: .constant(.blue))
//    }
//}

//struct PencilWeightView_Previews: PreviewProvider {
//    static var previews: some View {
//        PencilWeightView()
//    }
//}
