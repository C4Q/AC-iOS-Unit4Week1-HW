//
//  CategoryKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CategoriesKeyedArchiverClient {
    private init() {}
    static let manager = CategoriesKeyedArchiverClient()
    static let pathName = "FavoriteCards.plist"
    private var categories = [CategoriesWrapper]() {
        didSet {
            saveCategories()
        }
    }
    
    func add(category: CategoriesWrapper) {
        categories.append(category)
    }
    
    func getCategories() -> [CategoriesWrapper] {
        return self.categories
    }
    
    func loadData() {
        let path = dataFilePath(withPathName: KeyedArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let categories = try PropertyListDecoder().decode([CategoriesWrapper].self, from: data)
            self.categories = categories
        }
        catch {
            print(error)
        }
    }
    
    func saveCategories() {
        let path = dataFilePath(withPathName: KeyedArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(categories)
            try data.write(to: path, options: .atomic)
        }
        catch {
            print(error)
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return CategoriesKeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
}
