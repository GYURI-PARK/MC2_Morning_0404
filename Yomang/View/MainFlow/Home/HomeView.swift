//
//  HomeView.swift
//  Yomang
//
//  Created by Seohyun Bae on 2023/05/08.
//

import SwiftUI

struct HomeView: View {

    let user: User?
    @State var selectedTabTag = 0
    @StateObject var animationViewModel = AnimationViewModel()
    @ObservedObject var viewModel = YomangViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                HomeBackground().environmentObject(animationViewModel)
                TabView(selection: $selectedTabTag) {
                    MyYomangView(user: user ?? nil, viewModel: viewModel).environmentObject(animationViewModel)
                        .tag(0)
                    YourYomangView().environmentObject(animationViewModel)
                        .tag(1)
                }
                .accentColor(Color.white)
                .navigationTitle(selectedTabTag == 0 ? "나의 요망" : "너의 요망")
                .tabViewStyle(.page(indexDisplayMode:.always))
                .navigationBarTitleDisplayMode(.large)
                .indexViewStyle(.page(backgroundDisplayMode: .always))
                .navigationViewStyle(.stack)
            }//ZStack
        }//NavigationView
    }
}

//Home 장면 배경_우측
struct HomeBackground: View {
    
    @EnvironmentObject var ani: AnimationViewModel
    @State private var isChanged:Bool = false

    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(Color.black)
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color.main500], startPoint: .top, endPoint: .bottom))
                .opacity(isChanged ? 0.1 : 0.3)
                .onChange(of: ani.isImageUploaded) { isImageUploaded in
                    withAnimation(.easeInOut(duration: (ani.timeFromStart/300))) {
                        isChanged = isImageUploaded
                    }
                }
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.black, Color.white], startPoint: .top, endPoint: .bottom))
                .opacity(isChanged ? 0.4 : 0.1)
                .onChange(of: ani.isImageUploaded) { isImageUploaded in
                    withAnimation(.easeInOut(duration: (ani.timeFromStart/300))) {
                        isChanged = isImageUploaded
                    }
                }
            
            Rectangle()
                .fill(LinearGradient(colors: [Color.main200, Color.blue500], startPoint: .top, endPoint: .bottom))
                .opacity(isChanged ? 0.5 : 0)
                .onChange(of: ani.isImageUploaded) { isImageUploaded in
                    withAnimation(.easeInOut(duration: (ani.timeFromStart/300))) {
                        isChanged = isImageUploaded
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
