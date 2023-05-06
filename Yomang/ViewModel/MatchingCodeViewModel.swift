import SwiftUI
import FirebaseCore
import FirebaseFirestoreSwift
import FirebaseAuth

//User 모델의 정보를 담고 있고, 파이어베이스 서버와 통신하는 기능들이 있는 FirebaseModel을 상속받음
//FirebaseModel 에서 제공하는 함수를 그대로 사용할 수 있습니다.
class MatchingCodeViewModel: FirebaseModel{
    
    func savePartnerID(partnerID: String){
        UserDefaults.standard.set(partnerID, forKey:"partnerID")
        self.user.partnerID = partnerID
    }
    
    override init(){
        
    }
}
