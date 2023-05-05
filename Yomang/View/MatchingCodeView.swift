//
//  MatchingCodeView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//
/*
 내 코드는 Text, 상대방 입력창은 TextField
 복사하기 버튼에는 클립보드로 복사하는 기능 부여되어있음
 연결하기 버튼은 내비게이션 링크임 -> 코드를 잘못입력하였을 때 돌아와야하는 선택지가 있어야하기 때문에 내비게이션 링크 활용
 연결하기 버튼은 상대방의 코드가 입력되지 않으면 비활성화되고, 입력되면 활성화됨
 */

import SwiftUI

struct MatchingCodeView: View {
    
    //View 내에서 직접 필요한 변수들
    @State private var showAlertYourCodeNil: Bool = false
    @State private var showAlertYourCodeWrong: Bool = false
    @State private var isMyCodeActive: Bool = false
    
    //추후 뷰모델와 모델, 그리고 서버에서 받아와서 처리하도록 변경/이동해야하는 변수들
    @State var myCodeServer: String = "sdfs12iso09f"
    @State var myCode: String = "클릭하여 코드 생성하기"
    @State var yourCode: String = ""
    @State var gradiant1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    
    
    var body: some View {
        GeometryReader { proxy in
            NavigationView {
                ZStack {
                    //추후 배경이 생길 수 있으므로 배경은 뷰를 분리해놓음
                    BackgroundView()
                    VStack(alignment: .center) {
                        Spacer()
                        //추후 로고로 변경
                        Text("Yomang")
                            .font(.system(size: proxy.size.width * 0.18).bold())
                            .foregroundColor(.white)
                        Spacer()
                        VStack(alignment: .leading) {
                            Text(isMyCodeActive ? "내 코드 공유하기" : "내 코드 생성")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            HStack {
                                //버튼을 클릭하면 내 코드를 서버에서 받아온다.
                                //내 코드가 생성되면서 공유하기 버튼이 활성화가 된다.
                                Button(action: { self.myCode = myCodeServer; isMyCodeActive = true }) {
                                    Text(myCode)
                                        .foregroundColor(.white)
                                        .bold(isMyCodeActive ? false : true)
                                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
                                        .frame(width: proxy.size.width * 0.88, alignment: .leading)//*고민
                                        .background(.white.opacity(0.1))//추후 CustomColor로 변경할 것
                                        .cornerRadius(20)
                                        .overlay(
                                            HStack {
                                                Spacer()
                                                //내 코드를 공유하는 ShareLink
                                                ShareLink(item: myCode) { Image(systemName: "square.and.arrow.up")
                                                        .bold()
                                                        .foregroundColor(.white)
                                                        .padding()
                                                }
                                                .opacity(isMyCodeActive ? 1 : 0)
                                            }
                                        )//overlay
                                }//Button
                            }//HStack
                            Spacer().frame(height: proxy.size.height * 0.04)
                            Text("상대방의 코드 입력")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            TextField("상대방의 코드를 입력하세요", text: $yourCode)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.asciiCapable)//영문과 숫자만 입력하도록 함
                                .autocapitalization(.none)
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
                                .background(.white.opacity(0.1))//추후 CustomColor로 변경할 것
                                .cornerRadius(20)
                                .onReceive(yourCode.publisher.collect()) { characters in
                                    if characters.count == 12 {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                                    }
                                }
                            Spacer().frame(height: proxy.size.height * 0.08)
                            //TextField에 yourCode값이 없거나, 실수로 myCode를 입력했을 경우 경고
                            if yourCode.count == 0 || yourCode == myCode {
                                Button(action: {
                                    showAlertYourCodeNil = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.3))
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(0.5))
                                        )
                                }
                                .alert(isPresented: $showAlertYourCodeNil) {
                                    Alert(title: Text("연결 실패"), message: Text("상대방의 코드를 입력하세요"), dismissButton: .default(Text("OK")))
                                }
                            }
                            
                            //TextField에 yourCode값이 12자리 이외일 경우 경고
                            else if yourCode.count != 12 {
                                Button(action: {
                                    showAlertYourCodeWrong = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.white.opacity(0.3))
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(0.5))
                                        )
                                }
                                .alert(isPresented: $showAlertYourCodeWrong) {
                                    Alert(title: Text("연결 실패"), message: Text("코드는 12자리 영문과 숫자로 구성되어 있습니다."), dismissButton: .default(Text("OK")))
                                }
                            }
                            
                            //TextField에 yourCode값이 정상적으로 들어갈 경우 내비게이션링크 활성화
                                else {
                                NavigationLink(destination: MatchingLoadingView()) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(gradiant1)
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3.bold())
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                        }//VStack
                        .frame(width: proxy.size.width * 0.88)
                    }//VStack
                }//ZStack
            }//NavigationView
        }//Geometry Reader
    }
}

struct MatchingCodeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingCodeView()
    }
}

struct BackgroundView: View {
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(.black)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

