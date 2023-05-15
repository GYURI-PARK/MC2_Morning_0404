//
//  UserDefaults+Extension.swift
//  Yomang
//
//  Created by 제나 on 2023/05/09.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
            let appGroupID = "group.youngsa.Yomang"
            return UserDefaults(suiteName: appGroupID)!
        }
}
