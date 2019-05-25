//
//  UserDefaultHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct UserDefaultHelper {
    static let manager = UserDefaultHelper()
    private init() {}
    let categoryKey = "CategoryKey"
    func getCategory() -> Int? {
        return UserDefaults.standard.integer(forKey: categoryKey)
    }
    func setCategory(to thisCategory: Int) {
        UserDefaults.standard.setValue(thisCategory, forKey: categoryKey)
    }
}
