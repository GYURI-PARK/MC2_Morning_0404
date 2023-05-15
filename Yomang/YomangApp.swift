import SwiftUI
import FirebaseCore
import BackgroundTasks
import FirebaseFirestore


@main
struct YomangApp: App {
    
    @Environment(\.scenePhase) private var phase
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(AuthViewModel.shared)
        }
        .onChange(of: phase) { newPhase in
                    switch newPhase {
                    case .background:
                        scheduleAppRefresh()
                    default: break
                    }
                }
        .backgroundTask(.appRefresh("pos.youngsa.Yomang.updateWidget")) {
            scheduleAppRefresh()
            await fetchImageUrl()
            notify()
        }
    }
    
    func scheduleAppRefresh() {
        let today = Calendar.current.startOfDay(for: .now)
        let noonComponent = DateComponents(second: 10)
        let noon = Calendar.current.date(byAdding: noonComponent, to: today)
        
        let request = BGAppRefreshTaskRequest(identifier: "pos.youngsa.Yomang.updateWidget")
        request.earliestBeginDate = noon
        try? BGTaskScheduler.shared.submit(request)
    }
    
    func notify() {
        let content = UNMutableNotificationContent()
        content.title = UserDefaults.shared.string(forKey: "userId") ?? "fetch"
        content.body = UserDefaults.shared.string(forKey: "imageUrl") ?? "없어 ..."
        content.badge = 3
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
    }
    
    func fetchImageUrl() async {
        
        guard let _ = UserDefaults.shared.string(forKey: "userId") else { return }
        guard let partnerId = UserDefaults.shared.string(forKey: "partnerId") else { return }
        
        Firestore.firestore().collection("TestCollection").document(partnerId).getDocument{ document, error in
            
            if let _ = error {
                UserDefaults.shared.set("에러가 발생해 이미지를 불러오지 못했습니다. DEBUG #1", forKey: "notiMessage")
            } else {

                UserDefaults.shared.set("에러가 발생해 이미지를 불러오지 못했습니다. DEBUG #2", forKey: "notiMessage")
                if let document = document {
                    if let data = document.data() {
                        if let partnerImageUrl = data["imageUrl"] as? String {
                            UserDefaults.shared.set("요망이 업데이트되었습니다. 확인요망!", forKey: "notiMessage")
                            UserDefaults.shared.set(partnerImageUrl, forKey: "imageUrl")
                            
                            /// NSData로 변환해 저장
                            guard let url = URL(string: partnerImageUrl) else { return }
                            URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil else { return }
                                self.setImageInUserDefaults(UIImage: UIImage(data: data) ?? UIImage(), "widgetImage")
                            }.resume()
                        }
                    }
                }
            }
        }
    }
    
    /// UIImage convert to NSData
    func setImageInUserDefaults(UIImage value: UIImage, _ key: String) {
            let imageData = value.jpegData(compressionQuality: 0.5)
            UserDefaults.shared.set(imageData, forKey: key)
    }
}
