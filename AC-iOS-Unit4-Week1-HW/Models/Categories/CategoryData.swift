//
//  PersistentData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CategoryData {
    private init() {}
    static let manager = CategoryData()
    private let userDefaults = UserDefaults.standard
    
    private var categories: [String] = [] {
        didSet {
            saveCategories()
        }
    }
    
    private let categoryKey = "categoryKey"
    
    //save
    func saveCategories() {
        userDefaults.set(self.categories, forKey: categoryKey)
    }
    
    //load
    func loadCategories() {
        if let categories = userDefaults.value(forKey: categoryKey) as? [String] {
            self.categories = categories
        }
    }
    
    //add
    func addCategories(_ newCategories: [String]) {
        self.categories = newCategories
    }
    
    //get
    func getCategories() -> [String] {
        return self.categories
    }

}
