import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

//Firebase와 User 간의 통신을 담당
class FirebaseModel: ObservableObject{
    
    @Published var user: User = User(userID: "", isConnected: false)
    
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
            UserDefaults.standard.set(user.uid, forKey:"userID")
            self.user.userID = user.uid
            
            let db = Firestore.firestore()
            let docref = db.collection("TestCollection").document(self.user.userID)
            
            docref.setData([
                "userID": self.user.userID,
            ])
        }
    }
    
    //유저와 매칭!
    func matchingUser(){
        let db = Firestore.firestore()
        let docref = db.collection("TestCollection").document(user.userID)
        
        docref.setData([
                "partnerID": self.user.partnerID,
                ])
        db.collection("TestCollection").document(user.partnerID!)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                let data = document.data()
                
                print(data?["partnerID"] as? String ?? "sans")
                                
                if(self.user.userID == (data?["partnerID"] as? String ?? "")){
                    self.user.isConnected = true
                    UserDefaults.standard.set(true, forKey: "connected")
                    return
                }
            }
    }
    
    //매칭을 취소하고, 상대방 코드를 날림
    func matchingCancel(){
        let db = Firestore.firestore()
        let docref = db.collection("TestCollection").document(user.userID)
        
        docref.setData([
                "partnerID": "",
                ])
        
        UserDefaults.standard.set("", forKey: "partnerID")
        
        return
    }
    
    
    //만들어두긴 했는데, 이건 쓰지 않는게 나을 것 같습니다.
    //이걸 사용하면 State 어노테이션을 사용하는 것과 다르게
    //변수 값이 바뀔 때마다 자동으로 재호출이 안 되어서, View가 의도와 다르게 그려질 수 있습니다
    
    /*
    
    func getUserID() -> String {
        return self.user.userID
    }
    
    func getpartnerID() -> String {
        return self.user.partnerID
    }
    
    func getConnected() -> Bool{
        return self.user.connected
    }
    
    func imageURL() -> String {
        return self.user.imageURL
    }
    
     */
    
    init(){
        
    }
}
