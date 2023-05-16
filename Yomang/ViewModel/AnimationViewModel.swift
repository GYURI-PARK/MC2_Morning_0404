//
//  AnimationViewModel.swift
//  Yomang
//
//  Created by 최민규 on 2023/05/14.
//
import SwiftUI

class AnimationViewModel: ObservableObject{
    
    //MyYomangView와 YourYomangView에서 공유하는 변수입니다.
    //TODO: 사진을 업로드 완료하는 버튼에 true로 변환합니다.
    @Published var isImageUploaded: Bool = false
    @Published var isBackgroundChanging: Bool = false
    //앱을 켰을 때 지정시간까지 남은 시간을 담습니다. 시작시점과 지금시점 차이를 계산해 현재 시점에 좌표가 어디인지 계산합니다.
    @Published var timeFromNow: Double = 0.0
    @Published var timeFromStart: Double = 0.0
    @Published var moonSize: Double = 120
    @Published var moonAngle: Double = -30
    @Published var limitAngle: Double = 0.0
    @Published var offsetY: Double = 180.0
    @Published var startAngle: Double = 15.0

    
    
    //지금으로부터 내일 새벽5시까지 남은 시간을 계산하여 timeFromNow변수에 저장합니다.
    func calculateTimeLeft() {
        
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(bySettingHour: 5, minute: 0, second: 0, of: calendar.date(byAdding: .day, value: 1, to: now)!)!
        let components = calendar.dateComponents([.second], from: now, to: tomorrow)
        
        if let seconds = components.second {
            timeFromNow = Double(seconds)
        }
    }
    
    func calculateMoonLimitAngle(geoWidth: Double, geoHeight: Double, moonSize: Double) {
        let a:Double = Double(geoWidth + (moonSize / 2))
        let b:Double = Double(geoHeight - (moonSize / 2) + 180)
        let limit:Double = asin(Double(a / b)) * 180 / .pi
        limitAngle = limit
    }
   
    //사진이 업로드되었는지 확인, 사진 업로드 시점의 시간, 달의 움직임값을 UserDefaults에 저장합니다.
    func saveData() {
        UserDefaults.standard.set(isImageUploaded, forKey: "isImageUploaded")
        UserDefaults.standard.set(timeFromStart, forKey: "timeFromStart")
        UserDefaults.standard.set(moonAngle, forKey: "moonAngle")
    }
    
    func loadSavedData() {
        isImageUploaded = UserDefaults.standard.bool(forKey: "isImageUploaded")
        timeFromStart = UserDefaults.standard.double(forKey: "timeFromStart")
        moonAngle = UserDefaults.standard.double(forKey: "moonAngle")
    }
    
    
    
}
