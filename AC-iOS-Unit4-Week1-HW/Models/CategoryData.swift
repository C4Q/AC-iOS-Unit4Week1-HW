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
        self.categories = self.categories.sorted{$0 < $1}
        userDefaults.set(self.categories, forKey: categoryKey)
    }
    
    //load
    func loadCategories() {
        if let categories = userDefaults.value(forKey: categoryKey) as? [String] {
            self.categories = categories
        }
    }
    
    //add
    func addCategory(_ newCategory: String) {
        self.categories.append(newCategory)
    }
    
    //get
    func getCategories() -> [String] {
        return self.categories
    }

}
