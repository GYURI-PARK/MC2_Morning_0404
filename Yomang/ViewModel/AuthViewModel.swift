import SwiftUI
import Firebase

let db = Firestore.firestore().collection("TestCollection")

//Firebase와 User 간의 통신을 담당
class AuthViewModel: ObservableObject{
    
    static let shared = AuthViewModel()
    
    // 파이어베이스 서버 측으로부터 현재 로그인 세션 유지 중인 유저 정보가 있는지 확인
    @Published var userSession: FirebaseAuth.User?
    @Published var user: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        fetchUser()
    }
    
    func fetchUser() {
        guard let uid = userSession?.uid else { return }
        print("=== DEBUG: \(uid)")
        
        
        // TODO: 세션 내의 유저가 없다면 UserDefaults로 저장된 userId에 대한 밸류값이 있는지 확인하는 부분 추가
        
        db.document(uid).getDocument { snapshot , _ in
            guard let user = try? snapshot?.data(as: User.self) else { return }
            
            self.user = user
            print("=== DEBUG: fetch \(self.user)")
        }
    }
    
    private func getDeviceUUID() -> String? {
        return UIDevice.current.identifierForVendor?.uuidString
    }
    
    //유저를 서버에 등록하고 (회원가입) 각 유저에게 부여되는 고유한 코드를 생성함
    func registerUser() {
        let uuid = getDeviceUUID()
        
        Auth.auth().signInAnonymously() { result, error in
            
            //서버에서 데이터를 받아오지 못했을 경우 별도의 작업 수행 없이 return
            if let error = error {
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            
            //받아온 유저 고유 id를 저장
            UserDefaults.standard.set(user.uid, forKey:"userId")
            self.user?.userId = user.uid
            
            let data = ["userId": user.uid,
                        "partnerId": "",
                        "isConnected": false,
                        "imageUrl": "",
                        "uuid": uuid]
            
            db.document(user.uid).setData(data) { _ in
                print("=== DEBUG: 회원 등록 완료 \n\(data) ")
            }
        }
    }
    
    //유저와 매칭!
    func matchingUser(partnerId: String) {
        guard let uid = user?.userId else { return }
        
        // 유저가 입력한 파트너 아이디로 partnerId 세팅
        self.user?.partnerId = partnerId
        db.document(uid).updateData(["partnerId": partnerId])
        
        // 파트너가 설정한 partnerId가 현재 유저의 userId와 동일한지 확인
        db.document(partnerId).addSnapshotListener { snapshot, error in
            guard let document = snapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else { return }
            let partnersPartnerId = data["partnerId"] as! String // partner's partnerId
            
            if uid == partnersPartnerId {
                self.user?.isConnected = true
                
                // 두 유저 모두 연결된 것으로 변경
                db.document(uid).updateData(["isConnected": true])
                db.document(partnerId).updateData(["isConnected": true])
                return
            } else if partnersPartnerId.isEmpty {
                print("=== DEBUG: 대기중... \(data)")
            }
        }
    }
    
    /**
     0404에는 로그아웃에 대한 기능 명세가 없습니다. 테스트용으로 구현된 메소드이니 사용하지 마세요.
     */
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("== DEBUG: Error signing out \(error.localizedDescription)")
        }
    }
}
