//
//  MyYomangView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/09.
//

import SwiftUI

struct MyYomangView: View {
    
    let user: User?
    @ObservedObject var viewModel: YomangViewModel
    
    var body: some View {
        ZStack {
            if let _ = user {
                NavigationLink {
                    EditableYomangImage(viewModel: viewModel)
                } label: {
                    if let renderedImage = viewModel.renderedImage {
                        renderedImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 338, height: 354)
                    } else {
                        NavigationLink {
                            EditableYomangImage(viewModel: viewModel)
                        } label: {
                            ImageTemplateView()
                        }
                    }
                }
            } else {
                ImageTemplateView()
                
                VStack (alignment: .center) {
                    Text("이곳을 눌러\n파트너와 연결해 보세요")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                }
            }
        }
        
    }
}
