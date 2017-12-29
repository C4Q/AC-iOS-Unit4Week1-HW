//
//  FavoriteBookStore.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class FavoriteBookStore {
    
    static let kPathname = "Favorites.plist"
    
    // singleton
    private init() {}
    static let manager = FavoriteBookStore()
    
    private var favorites = [BestSellerBook]() {
        didSet {
            saveToDisk()
        }
    }
    
    // returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // /documents/Favorites.plist
    // returns the path for supplied name from the dcouments directory
    func dataFilePath(withPathName path: String) -> URL {
        return FavoriteBookStore.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save to documents directory
    // write to path: /Documents/
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            // Does the writing to disk
            try data.write(to: dataFilePath(withPathName: FavoriteBookStore.kPathname), options: .atomic)
        } catch {
            print("encoding error: \(error.localizedDescription)")
        }
        print("\n==================================================")
        print("SAVED BOOK TO DISK")
        print(documentsDirectory())
        print("===================================================\n")
    }
    
    // load from documents directory
    func load() {
        // what's the path we are reading from?
        let path = dataFilePath(withPathName: FavoriteBookStore.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([BestSellerBook].self, from: data)
        } catch {
            print("decoding error: \(error.localizedDescription)")
        }
    }
    
    func addToFavorites(book: BestSellerBook) -> Bool {
        let indexExist = favorites.index{ $0.displayName == book.displayName }
        /// how to check for uniqueness???
        //        if indexExist != nil {print("Favorite Exists"); return false }
        
        let newFavorite = BestSellerBook.init(listName: book.listName, displayName: book.displayName, weeksOnList: book.weeksOnList, isbns: book.isbns, bookDetails: book.bookDetails)
        favorites.append(newFavorite)       
        
        return true
    }
    
    
    
    
    
    
    
    
    
    
    // fetch the Favorite objects
    func getFavorites() -> [BestSellerBook] {
        return favorites
    }
    
    
    
    
    
}
