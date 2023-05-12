//
//  MatchingCodeView.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/05.
//
/* 확인 해주세요!!!
 핸드폰에 직접 빌드해서 사용해보시길 권장드립니다!
 디자인 요소는 로고 변경 및 배경 변경 예정
 공유하기 버튼은 Sharelink 기능 사용함
 "연결하기" 버튼은 AlertCase 3가지이며, 조건 충족 시 Navigation Link 활성화 -> 코드를 잘못입력하였을 때 돌아와야하는 선택지가 있어야하기 때문에 내비게이션 링크 활용
 변수 뷰모델로 옮겨서 연동 예정
 */

import SwiftUI

struct MatchingCodeView: View {
    
    let user: User
    
    //View 내에서 직접 필요한 변수들
    @State private var showAlertToggle: Bool = false
    @State private var showAlert1: Bool = false
    @State private var showAlert2: Bool = false
    
    @State private var showAlertYourCodeWrong: Bool = false
    @State private var isMyCodeShared: Bool = false
    
    
    //추후 뷰모델와 모델, 그리고 서버에서 받아와서 처리하도록 변경/이동해야하는 변수들
    @State var myCode: String = " "
    @State var yourCode: String = ""
    let colorPurple: Color = Color(red: 118/255, green: 56/255, blue: 249/255)
    let colorButtonGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 139/255, blue: 255/255)]),
        startPoint: .top,
        endPoint: .bottom)
    @State var colorButtonDisabled = LinearGradient(colors: [.white.opacity(0.3)], startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView {
            ZStack {
                //MatchingCode 배경
                MatchingCodeBackgroundView()
                
                //코드생성 및 입력 영역
                VStack(alignment: .leading) {
                    
                    Spacer().frame(height: 32)
                    
                    Text("내 코드를 상대에게 공유하세요.")
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .opacity(isMyCodeShared ? 0.2 : 1)
                        .padding(.horizontal)
                        .padding(.top, 20)
                    
                    
                    ShareLink(item: myCode) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("클릭하여 상대에게 코드 보내기")
                                    .font(.caption.bold())
                                    .foregroundColor(.black.opacity(0.5))
                                    .padding(.horizontal)
                                
                                Text(myCode)
                                    .font(.body.bold())
                                    .foregroundColor(colorPurple)
                                    .lineLimit(1)
                                    .padding(.horizontal)
                            }
                            Spacer()
                            Image(systemName: "square.and.arrow.up")
                                .bold()
                                .foregroundColor(colorPurple)
                                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                                .offset(x: -8)
                        }//HStack
                        .frame(height: 60)
                        .background(.white.opacity(0.8))
                        .cornerRadius(16)
                        .padding(.horizontal)
                    }
                    .simultaneousGesture(TapGesture().onEnded() {
                        isMyCodeShared = true
                        print("HEY")
                    })
                    .onAppear {
                        self.myCode = user.userId
                    }
                    
                    
                    
                    Spacer().frame(height: 16)
                    
                    //내 코드 생성되고나면 상대방 코드 입력칸이 나옴
                    if isMyCodeShared {
                        Text("상대방의 코드를 입력해주세요.")
                            .font(.title2.bold())
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.top, 32)
                        HStack {
                            TextField("", text: $yourCode)
                                .padding(.leading, 16)
                                .multilineTextAlignment(.leading)
                                .keyboardType(.asciiCapable)//영문과 숫자만 입력하도록 함
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .font(.body.bold())
                                .foregroundColor(.white)
                                .frame(height: 60)
                            if yourCode.count == 0  {
                                //상대방 코드 입력 전 붙여넣기 버튼 활성화
                                Button(action: {
                                    if let clipboardString = UIPasteboard.general.string { yourCode = clipboardString }
                                }) { Image(systemName: "doc.on.clipboard")
                                        .foregroundColor(colorPurple)
                                        .padding()
                                }
                            } else {
                                //상대방 코드 입력 시작 시 삭제버튼 활성화
                                Button(action: { yourCode = "" }) { Image(systemName: "x.circle")
                                        .foregroundColor(colorPurple)
                                        .padding()
                                }
                            }
                        }//HStack
                        .overlay(Rectangle().frame(height: 1).foregroundColor(colorPurple), alignment: .bottom)
                        .padding(.horizontal)
                        
                        
                        //상대방 코드 입력 28자리 달성 시 키보드 자동 종료
                        .onReceive(yourCode.publisher.collect()) { characters in
                            if characters.count == 28 {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    //연결하기 버튼_조건 미충족 시 Alert, 조건 충족 시 NavigationLink 활성화
                    
                    if isMyCodeShared && yourCode.count == 28 && yourCode != myCode {
                        NavigationLink(destination: MatchingLoadingView(user: self.user)) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorButtonGradient1)
                                .frame(height: 70)
                                .padding()
                                .overlay(
                                    Text("연결하기")
                                        .font(.title3.bold())
                                        .foregroundColor(.white)
                                )}
                        .simultaneousGesture(TapGesture().onEnded{
                            AuthViewModel.shared.matchingUser(partnerId: yourCode)
                            print("Matching Code sent")
                        })
                    } else {
                        Button(action: {
                            showAlertToggle = true
                            if !isMyCodeShared {
                                showAlert1 = true
                            } else if yourCode.count == 0 || yourCode == myCode {
                                showAlert1 = false
                                showAlert2 = true
                            } else {
                                showAlert2 = false
                            }
                        }) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(colorButtonDisabled)
                                .frame(height: 70)
                                .padding()
                                .overlay(
                                    Text("연결하기")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.white.opacity(0.5))
                                )
                        }
                    }
                }//VStack
                .alert(isPresented: $showAlertToggle) {
                    //Alert Case1_내 코드 생성하지 않은 경우
                    Alert(title: Text("연결 실패"), message: Text(showAlert1 ? "내 코드를 먼저 공유하세요" : showAlert2 ? "상대방의 코드를 입력하세요" : "코드는 28자리 영문과 숫자로 구성되어 있습니다."), dismissButton: .default(Text("OK")))
                }
            }//ZStack
        }//NavigationView
        .accentColor(colorPurple)
    }
}

//프리뷰
struct MatchingCodeView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingCodeView(user: User(uuid: "", userId: "", isConnected: false))
    }
}

//MatchingCode 장면 배경
struct MatchingCodeBackgroundView: View {
    
    //뷰모델에서 선언해서 불러오기
    @State var colorBackgroundGradient1: LinearGradient = LinearGradient(
        gradient: Gradient(colors: [Color(red: 118/255, green: 56/255, blue: 249/255), Color(red: 0/255, green: 0/255, blue: 0/255)]),
        startPoint: .top,
        endPoint: .bottom)
    
    var body: some View {
        Rectangle()
            .fill(Color.black)
            .ignoresSafeArea()
    }
}
