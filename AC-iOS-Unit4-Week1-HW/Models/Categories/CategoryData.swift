//
//  PersistentData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CategoryData {
    private let plistName = "Categories.plist"
    
    private init() {}
    static let manager = CategoryData()
    
    private var categories: [String] = [] {
        didSet {
            saveCategories()
        }
    }
    
    //save
    func saveCategories() {
        PersistentData.manager.saveItem(self.categories, atFileName: plistName)
    }
    
    //load
    func loadCategories() {
        guard let categories =  PersistentData.manager.loadItems(fromFileName: plistName) as? [String] else {
            return
        }
        
        self.categories = categories
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
