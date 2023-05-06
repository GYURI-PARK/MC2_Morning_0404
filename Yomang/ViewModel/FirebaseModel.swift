import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

//Firebase와 User 간의 통신을 담당
class FirebaseModel: ObservableObject{
    
    @Published var user: User = User(userId: "", isConnected: false)
    
    //유저를 서버에 등록하고 (회원가입) 각 유저에게 부여되는 고유한 코드를 생성함
    func registerUser() {
        Auth.auth().signInAnonymously() { result, error in
            
            //서버에서 데이터를 받아오지 못했을 경우 별도의 작업 수행 없이 return
            if let error = error {
                //콘솔 디버깅용 코드
                print("Error : \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else { return }
            //콘솔 디버깅용 코드
            print(user.uid)
            
            //받아온 유저 고유 id를 저장
            UserDefaults.standard.set(user.uid, forKey:"userId")
            self.user.userId = user.uid
            
            let db = Firestore.firestore()
            let docref = db.collection("TestCollection").document(self.user.userId)
            
            docref.setData([
                "userId": self.user.userId,
            ])
        }
    }
    
    //유저와 매칭!
    func matchingUser(){
        let db = Firestore.firestore()
        let docref = db.collection("TestCollection").document(user.userId)
        
        docref.setData([
                "partnerId": self.user.partnerId,
                ])
        db.collection("TestCollection").document(user.partnerId!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let data = document.data()
                
                print(data?["partnerId"] as? String ?? "sans")
                                
                if(self.user.userId == (data?["partnerId"] as? String ?? "")){
                    self.user.isConnected = true
                    UserDefaults.standard.set(true, forKey: "isConnected")
                    return
                }
            }
    }
    
    //매칭을 취소하고, 상대방 코드를 날림
    func matchingCancel(){
        let db = Firestore.firestore()
        let docref = db.collection("TestCollection").document(user.userId)
        
        docref.setData([
                "partnerId": "",
                ])
        
        UserDefaults.standard.set("", forKey: "partnerId")
        
        return
    }

    init(){
        
    }
}
