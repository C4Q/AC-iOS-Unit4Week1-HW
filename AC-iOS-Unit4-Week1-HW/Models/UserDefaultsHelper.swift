//
//  UserDefaultsHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct UserDefaultsHelper {
    private init() { }
    static let manager = UserDefaultsHelper()
    private var defaultCategoryKey = "defaultBookCategory"
    func getDefaultBookCategory() -> String? {
        return UserDefaults.standard.string(forKey: defaultCategoryKey)
    }
    func setDefaultBookCategory(to category: String) {
        UserDefaults.standard.setValue(category, forKey: defaultCategoryKey)
    }

}

