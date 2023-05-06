//
//  MatchingCodeView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//
/* 확인 해주세요!!!
 핸드폰에 직접 빌드해서 사용해보시길 권장드립니다!
 디자인 요소는 로고 변경 및 배경 변경 예정
 내 코드는 Text, 상대방 입력창은 TextField
 공유하기 버튼은 Sharelink 기능 사용함
 연결하기 버튼은
 내 코드 생성 전 / 상대방 코드 미입력 시 / 상대방 코드 일정 자리수 도달하지 못하거나 / 내 코드와 같은 코드를 상대 코드에 입력 시
 위 네 가지 각 케이스에 연결하기 버튼은 회색이며, 클릭 시 각 상황에 맞는 경고메시지가 팝업됨.
 모드 조건을 충족하면 연결하기 버튼은 NavigationLink가 됨 -> 코드를 잘못입력하였을 때 돌아와야하는 선택지가 있어야하기 때문에 내비게이션 링크 활용
 */

import SwiftUI

struct MatchingCodeView: View {
    
    //View 내에서 직접 필요한 변수들
    @State private var showAlertYourCodeNil: Bool = false
    @State private var showAlertYourCodeWrong: Bool = false
    @State private var isMyCodeActive: Bool = false
    
    //추후 뷰모델와 모델, 그리고 서버에서 받아와서 처리하도록 변경/이동해야하는 변수들
    @State var myCodeServer: String = "sdfs12iso09fsdfs12iso09f9283"
    @State var myCode: String = "이곳을 클릭하여 코드를 생성"
    @State var yourCode: String = ""
    @State var colorButtonGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        
        GeometryReader { proxy in
            
            NavigationView {
            
                ZStack {
                    //추후 배경이 생길 수 있으므로 배경은 뷰를 분리해놓음
                    MatchingCodeBackgroundView()
                    
                    VStack(alignment: .center) {
                        Spacer()
                        //YOMANG텍스트_추후 로고로 변경
                        Text("Yomang")
                            .font(.system(size: proxy.size.width * 0.18).bold())
                            .foregroundColor(.white)
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text(isMyCodeActive ? "내 코드를 공유하세요" : "내 코드를 생성하세요")
                                .font(.title3.bold())
                                .foregroundColor(.white)
                            //내 코드 생성 및 공유버튼
                            
                            HStack {
                                //버튼을 클릭하면 내 코드를 서버에서 받아온다.
                                //내 코드가 생성되면서 공유하기 버튼이 활성화가 된다.
                                Button(action: {
                                    self.myCode = myCodeServer
                                    withAnimation{ isMyCodeActive = true }
                                }) {
                                    Text(myCode)
                                        .foregroundColor(.white)
                                    //                                        .bold(isMyCodeActive ? false : true)
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
                                            }//HStack
                                        )//overlay
                                }//Button
                            }//HStack
                            
                            //내 코드 생성되고나면 상대방 코드 입력칸이 나옴
                            if isMyCodeActive {
                                Spacer().frame(height: proxy.size.height * 0.04)
                                Text("상대방의 코드를 입력하세요")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                                    .transition(.push(from: .bottom))
                                TextField("이 곳을 클릭하여 코드 입력", text: $yourCode)
                                    .multilineTextAlignment(.leading)
                                    .keyboardType(.asciiCapable)//영문과 숫자만 입력하도록 함
                                    .autocapitalization(.none)
                                    .foregroundColor(.white)
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 0))
                                    .background(.white.opacity(0.1))//추후 CustomColor로 변경할 것
                                    .cornerRadius(20)
                                    .transition(.push(from: .bottom))
                                    .overlay(
                                        HStack {
                                            Spacer()
                                            //상대방 코드 입력 시작 시 삭제버튼 활성화
                                            Button(action: { yourCode = "" }) { Image(systemName: "x.circle")
                                                    .foregroundColor(.white)
                                                    .padding()
                                            }
                                            .opacity(yourCode.count != 0 ? 1 : 0)
                                        }//HStack
                                    )//overlay
                                //상대방 코드 입력 28자리 달성 시 키보드 자동 종료
                                    .onReceive(yourCode.publisher.collect()) { characters in
                                        if characters.count == 28 {
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                                        }
                                    }
                            }
                            
                            Spacer().frame(height: proxy.size.height * 0.08)
                            
                            //연결하기 버튼
                            if isMyCodeActive != true {
                                Button(action: {
                                    showAlertYourCodeNil = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorButtonDisabled)
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(0.5))
                                        )
                                }
                                .alert(isPresented: $showAlertYourCodeNil) {
                                    Alert(title: Text("연결 실패"), message: Text("내 코드를 먼저 생성하세요"), dismissButton: .default(Text("OK")))
                                }
                            }
                            //TextField에 yourCode값이 없거나, 실수로 myCode를 입력했을 경우 경고
                            else if yourCode.count == 0 || yourCode == myCode {
                                Button(action: {
                                    showAlertYourCodeNil = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorButtonDisabled)
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
                            
                            //TextField에 yourCode값이 28자리 이외일 경우 경고
                            else if yourCode.count != 28 {
                                Button(action: {
                                    showAlertYourCodeWrong = true
                                }) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorButtonDisabled)
                                        .frame(height: 80)
                                        .overlay(
                                            Text("연결하기")
                                                .font(.title3)
                                                .bold()
                                                .foregroundColor(.white.opacity(0.5))
                                        )
                                }
                                .alert(isPresented: $showAlertYourCodeWrong) {
                                    Alert(title: Text("연결 실패"), message: Text("코드는 28자리 영문과 숫자로 구성되어 있습니다."), dismissButton: .default(Text("OK")))
                                }
                            }
                            
                            //TextField에 yourCode값이 정상적으로 들어갈 경우 내비게이션링크 활성화
                            else {
                                NavigationLink(destination: MatchingLoadingView()) {
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(colorButtonGradient1)
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

struct MatchingCodeBackgroundView: View {
    
    //나중에 뷰모델에서 선언해서 불러오기
    @State var colorBackgroundGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 0/255, blue: 0/255)]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        GeometryReader { proxy in
            Rectangle()
                .fill(colorBackgroundGradient1)
                .opacity(0.6)
                .background(Color.black)
                .ignoresSafeArea()
        }
    }
}

