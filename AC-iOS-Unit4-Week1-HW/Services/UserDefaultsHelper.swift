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
    
    private let indexKey = "index"
    private let dateKey = "date"
    private let ranAtLeastOnceKey = "ranAtLeastOnce"

    
    func getPickerIndex() -> Int? {
        return Int(UserDefaults.standard.string(forKey: indexKey) ?? "0")
    }
    func getTomorrowDate() -> Date? {
        return UserDefaults.standard.value(forKey: dateKey) as? Date
    }
    func didItRunAtLeastOnce() -> Bool? {
        return UserDefaults.standard.bool(forKey: ranAtLeastOnceKey)
    }

    func setPickerIndex(to newIndex: String) {
        UserDefaults.standard.setValue(newIndex, forKey: indexKey)
    }
    func setTomorrowDate(to newDate: Date) {
        UserDefaults.standard.setValue(newDate, forKey: dateKey)
    }
    func setRanAtLeastOnce(to newBool: Bool) {
        UserDefaults.standard.setValue(newBool, forKey: ranAtLeastOnceKey)
    }
}
