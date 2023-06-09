//
//  User.swift
//  Yomang
//
//  Created by jose Yun on 2023/05/04.
//
// User Model

import Foundation

struct User: Decodable {
    // 개인 정보
    let uuid: String
    var userId: String
    var partnerId: String?

    // 파트너와 연결되어 있음
    var isConnected: Bool

    // 본인이 설정한 이미지
    var imageUrl: String
}
