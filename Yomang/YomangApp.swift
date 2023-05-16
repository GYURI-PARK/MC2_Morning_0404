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
            await AuthViewModel.shared.fetchImageUrl()
            notify()
        }
    }
    
    func scheduleAppRefresh() {
        let today = Calendar.current.startOfDay(for: .now)
        let noonComponent = DateComponents(hour: 1)
        let noon = Calendar.current.date(byAdding: noonComponent, to: today)
        
        let request = BGAppRefreshTaskRequest(identifier: "pos.youngsa.Yomang.updateWidget")
        request.earliestBeginDate = noon
        do {
            try BGTaskScheduler.shared.submit(request)
            print("=== DEBUG: 스케쥴러 submit")
        } catch {
            print("=== DEBUG: 스케쥴러 submit 거부")
        }
    }
    
    func notify() {
        // 현재 날짜 및 시간 가져오기
        let components = Calendar.current.dateComponents(in: TimeZone(identifier: "Asia/Seoul")!, from: Date())

        if components.hour == 5 {
            // 매일 오전 5시에만 알림
            UserDefaults.shared.set("요망이 업데이트되었습니다. 확인요망!", forKey: "notiMessage")
            let content = UNMutableNotificationContent()
            content.title = "확인요망!"
            content.body = UserDefaults.shared.string(forKey: "notiMessage") ?? "확인 요망 !"
            content.badge = 1
            content.sound = .default
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let req = UNNotificationRequest(identifier: "MSG", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(req, withCompletionHandler: nil)
        } else {
            // 매일 오전 5시에 해당하지 않는 경우 이미지 링크만 받아오고 알림은 보내지 않음
            return
        }
    }
}
