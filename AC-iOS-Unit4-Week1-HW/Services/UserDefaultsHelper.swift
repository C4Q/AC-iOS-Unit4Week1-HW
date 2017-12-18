//
//  UserDefaultsHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
struct UserDefaultsHelper {
    static let manager = UserDefaultsHelper()
    private init() {}
    
    private let nameKey = "name"
    private let signKey = "sign"
    private let indexKey = "index"
    func getName() -> String? {
        return UserDefaults.standard.string(forKey: nameKey)
    }
    func getSign() -> String? {
        return UserDefaults.standard.string(forKey: signKey)
    }
    func getPickerIndex() -> Int? {
        return Int(UserDefaults.standard.string(forKey: indexKey) ?? "0")
    }
    func setName(to newName: String) {
        UserDefaults.standard.setValue(newName, forKey: nameKey)
    }
    func setSign(to newSign: String) {
        UserDefaults.standard.setValue(newSign, forKey: signKey)
    }
    func setPickerIndex(to newIndex: String) {
        UserDefaults.standard.setValue(newIndex, forKey: indexKey)
    }
}
