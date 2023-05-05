//
//  User.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//
// User Model

import Foundation

struct User{
    // 개인 정보
    var userID: String = UserDefaults.standard.string(forKey: "userID") ?? ""
    var partnerID: String = UserDefaults.standard.string(forKey: "partnerID") ?? ""

    // 파트너와 연결되어 있음
    var connected: Bool = UserDefaults.standard.bool(forKey: "connected")

    // 본인이 설정한 이미지
    var imageURL: String = UserDefaults.standard.string(forKey: "imageURL") ?? ""
}
