//
//  YomangImageView.swift
//  Yomang
//
//  Created by 제나 on 2023/05/11.
//

import SwiftUI

struct ImageTemplateView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(LinearGradient(colors: [Color(hex: 0xA9AA80, alpha: 0.45), Color.clear], startPoint: .top, endPoint: .bottom))
            .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white, lineWidth: 1)
            )
    }
}
