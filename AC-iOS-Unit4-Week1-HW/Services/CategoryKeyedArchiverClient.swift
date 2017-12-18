//
//  CategoryKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//this client will be archiving and retrieving the category data using keys
class CategoriesKeyedArchiverClient {
    
    //using a singleton to manage the model
    private init() {}
    static let manager = CategoriesKeyedArchiverClient()
    
    //1. give your plist a name
    static let pathName = "Categories.plist"
    //2. Create an array to store the data you want to be saved
    // property observer does saving to persistence on changes
    private var categories = [Category]() {
        didSet {
            saveCategories()
        }
    }
    
    func add(category: Category) {
        categories.append(category)
    }
    
    func addAllCategories(allCategories: [Category]) {
        self.categories = allCategories
    }
    
    func getCategories() -> [Category] {
        return categories
    }
    
    func loadCategories() {
        let path = dataFilePath(withPathName: CategoriesKeyedArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let categories = try PropertyListDecoder().decode([Category].self, from: data)
            self.categories = categories
        }
        catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    func saveCategories() {
        //encode the categories into data so they can be saved with propertyListEncoder
        let path = dataFilePath(withPathName: CategoriesKeyedArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(categories)
            //write this data to a plist
            try data.write(to: path, options: .atomic)
            
        }
        catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    //returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        //this is finding the document folder in the app
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return document folder url path
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        //now you can write to the file/pathName you pass in! (If the file name doesn't exsist, it will create it)
        return CategoriesKeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
}
