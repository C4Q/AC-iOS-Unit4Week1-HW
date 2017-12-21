//
//  CategoryKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

// what is propertyListEncoder? -> Like JSONEncoder/Decoder(): object that helps you encode/decode instances of dataTypes
// what does the static mean? -> static lives in the life cyccle of the app. Lets you access the instance from the class
// why do we not use propertykeys? Used most with UserDefaults?
//what is line 110 doing?


/////////////////////////////////////

//this client will be archiving and retrieving the category data using keys

//save google and NYT API call information
class CategoriesCodableArchiverClient{
    
    //using a singleton to manage the model
    private init(){}
    static let manager = CategoriesCodableArchiverClient()
    
    //1. give your plist a name
    static let kPathName = "BookCategoriesCodable.plist"
    //2. Create an array to store the data you want to be saved
    // property observer does saving to persistence on changes
    var categories: [BookCategories] = [] {
        didSet {
            //saveDSAList()
        }
    }
    //3. locate the file path of the app's document directory, so you can add the plist there (user generated files are generally kept there)
    
    //returns URL path of the app document document folder!
    //returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        //this is finding the document folder in the app
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return document folder url path
        return paths[0]
    }
    
    //appends a pathname(ex: /Application/Document/(pathName) to the document folder
    func dataFilePath(withPathName path: String) -> URL {
        //now you can write to the file/pathName you pass in! (If the file name doesn't exsist, it will create it)
        return CategoriesCodableArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    //4. Create functions for saving, loading, adding, and removing what ever you are working with
    
    //save
    private func saveCategories() -> Bool {
        //encode the categories into data so they can be saved with propertyListEncoder
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(categories)
            //write this data to a plist
            try data.write(to: dataFilePath(withPathName: CategoriesCodableArchiverClient.kPathName), options: .atomic)
            return true
        }catch{
            print(AppError.codingError(rawError: error))
            print("error encoding items: \(error.localizedDescription)")
            print(documentsDirectory())
            return false
        }
    }
    
    //load
    func loadCategories(){//decode the data into foundation object (cards)
        
        //find the path where the plist is located
        let path = dataFilePath(withPathName: CategoriesCodableArchiverClient.kPathName)
        //decode the data into foundation object (categories)
        let decoder = PropertyListDecoder()
        do{
            //convert plist into data
            let data = try Data.init(contentsOf: path)
            //convert data into categories
            let loadedCategories = try decoder.decode([BookCategories].self, from: data)
            //load the ctegories into the cards
            categories = loadedCategories
        }catch {
            print(AppError.codingError(rawError: error))
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    //add
    func addCategories(_ newCategory: BookCategories, handler: ((Bool) -> Void)?) {
        categories.append(newCategory)
        //5. save the categories after adding a new one
        let saveCardCompletion = saveCategories()
        //use completion handler for only if you want to present alert controller in the view controller(you can passin a handler in the VC) -> gives an alert controller to appear when saving was successful or unsuccessful
        if let handler = handler {
            handler(saveCardCompletion)
        }
        /* other ways to add
         func add(category: BookCategories){
         categories.append(category)
         }
         public func addDSAItemToList(dsaItem item: DSA) {
         lists.append(item)
         }*/
    }
    
    //update
//    func updateCategories(){}
//    func updateCategory(withUpdated category: BookCategories) {
//        if let index = categories.index(where: {$0 === category}) {
//            //comparing 2 classes and their objects ex) category names, ISBN... looking for uniquness
//            categories[index] = categories
//        }
//    }
    //remove
    func removeCategories(){}
    func removeCategoryFromIndex(fromIndex index: Int) {
        categories.remove(at: index)
    }
    
    
    //In the DSA app we can delete an item from our table view. First the item must be removed from our list array then update the table view. The following datasource method is used for this action:
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        \(NAMEOFTABLEVIEW).remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }*/
    
}
