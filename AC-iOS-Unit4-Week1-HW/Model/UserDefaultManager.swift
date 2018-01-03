//
//  UserDefaultManager.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct UserDefaultManager {
    private init() {}
    static let shared = UserDefaultManager()
    
    var defaults = UserDefaults.standard
    
    func setDefault(value: Category, key: String) {
        let encodedValue = try! PropertyListEncoder().encode(value)
        defaults.set(encodedValue, forKey: key)
    }
    
    func fetchDefault(key: String) -> Category? {
        if let data = defaults.data(forKey: key) {
            let category = try! PropertyListDecoder().decode(Category.self, from: data)
            return category
        }
        return nil
    }
    
}
