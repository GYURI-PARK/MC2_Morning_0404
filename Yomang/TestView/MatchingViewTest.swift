import SwiftUI

struct MatchingViewTest: View {
    let user: User
    
    @State var uid: String = ""
    @State var text1: String = ""
    @State var text2: String = ""
    @State var title: String = ""
    
    var body: some View {
        VStack{
            Text("\(uid)")
                .textSelection(.enabled)
            TextField("니꺼", text: $text2)
            
            Button(action: {
                AuthViewModel.shared.matchingUser(partnerId: text2)
                
            }, label: {
                Text("매칭!")
            })
            
        }.onAppear(){
            AuthViewModel.shared.registerUser() { givenUid in
                self.uid = givenUid
            }
        }
    }
}
