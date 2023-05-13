//
//  ContentView.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @EnvironmentObject var viewModel: YomangViewModel
    @State var renderedImage: Image?
    
    var body: some View {
//        MyYomangView(renderedImage: $viewModel.renderedImage)
        MyYomangView(renderedImage: $renderedImage)
 //       ImageMarkUpView(viewModel: viewModel)
 //       YomangImage(imageState: viewModel.imageState)
 //       CropYomangView()
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
