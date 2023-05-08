import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YomangApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ImageMarkUpView()
            //PencilWeightView(selectedWeight: .constant(Font.Weight.medium))
            //ColorPickerView()
            //PencilWeightView(selectedWeight: .constant(400.0))
        }
    }
}
