//
//  UserDefaults.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class Settings {
    private static let manager = UserDefaults.standard
    private static let categoryIndexKey = "categoryIndexKey"
    
    static func saveCategory(atIndex index: Int) {
        manager.set(index, forKey: categoryIndexKey)
    }
    
    static func getCategory() -> Int? {
        guard let categoryIndex = manager.value(forKey: categoryIndexKey) as? Int else {
            return nil
        }
        
        return categoryIndex
    }
}
