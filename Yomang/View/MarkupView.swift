//
//  MarkupView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/09.
//

import SwiftUI

struct MarkupView: View {
    @EnvironmentObject var viewModel: YomangViewModel
    var body: some View {
        VStack{
            Image(uiImage: viewModel.savedImage!)
                .resizable().scaledToFit().frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT)
                .mask{
                    RoundedRectangle(cornerRadius: 22)
                        .frame(width: WIDGET_WIDTH, height: WIDGET_HEIGHT
                    )
                }
        }
    }
}

//struct MarkupView_Previews: PreviewProvider {
//    static var previews: some View {
//        MarkupView()
//    }
//}
