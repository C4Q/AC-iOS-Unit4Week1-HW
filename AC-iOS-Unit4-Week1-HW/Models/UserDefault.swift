//
//  UserDefault.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 1/3/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
class UserDefaultsHelper {
    private init() {}
    static let manager = UserDefaultsHelper()
    let selectedCategoryKey = "selectedCategory"
    
    func getPickerIndex() -> Int? {
       return UserDefaults.standard.integer(forKey: selectedCategoryKey)
        
    }
    func setPickerIndex(index: Int) {
        UserDefaults.standard.set(index, forKey: selectedCategoryKey)
    }
    
}
