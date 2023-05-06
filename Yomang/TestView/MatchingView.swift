import SwiftUI

struct MatchingView: View {
    @StateObject var matchingLoadingViewModel: MatchingLoadingViewModel = MatchingLoadingViewModel()
    
    @State var randnums: String = ""
    @State var text1: String = ""
    @State var text2: String = ""
    @State var title: String = ""
    
    var body: some View {
        VStack{
            Text("내거: " + matchingLoadingViewModel.user.userID)
            TextField("니꺼", text: $text2)
            
            Button(action: {
                matchingLoadingViewModel.user.partnerID = text2
                matchingLoadingViewModel.matchingUser()}, label: {Text("매칭!")})
            
        }.onAppear(){
            matchingLoadingViewModel.user.connected = false
            matchingLoadingViewModel.registerUser()
        }
    }
}

struct MatchingView_Previews: PreviewProvider {
    static var previews: some View {
        MatchingView()
    }
}
