//
//  Color+Extension.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/08.
//

import Foundation
import SwiftUI

extension Color {
//    public static let Color: Color = Color(UIColor())
    init(hex: UInt, alpha: Double = 1.0) {
            let red = Double((hex >> 16) & 0xff) / 255.0
            let green = Double((hex >> 8) & 0xff) / 255.0
            let blue = Double(hex & 0xff) / 255.0
            self.init(red: red, green: green, blue: blue, opacity: alpha)
    }
    
    static let main500 = Color(hex: 0x7638F9)
    
}
