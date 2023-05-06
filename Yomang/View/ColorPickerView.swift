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
                      Constants.Icons.recordCircleFill :
                        Constants.Icons.circleFill)
                .foregroundColor(color)
                .font(.system(size: 30))
                .clipShape(Circle())
                .onTapGesture {
                    selectedColor = color
                }
            }
        }
    }
}

struct ColorPickerView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPickerView(selectedColor: .constant(.blue))
    }
}
