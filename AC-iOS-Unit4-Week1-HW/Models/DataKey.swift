//
//  DataKey.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    
    // using a singleton to manage the model
    private init(){}
    static let shared = DataModel()
    
    static let kPathname = "BestSellerBooks.plist"
    
    struct Favorite: Codable {
        let title: String
        let description: String
        let isbn: String
    }
    
    private var favorites = [Favorite]() {
        didSet { // property observer does saving to persistence on changes
            saveFavoriteList()
            print(documentsDirectory())
        }
    }
    
    // returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return DataModel.shared.documentsDirectory().appendingPathComponent(path)
    }
    
    func addFavorite(book: BookList, googleBook: GoogleBooks, image: UIImage) {
        let imgPng = UIImagePNGRepresentation(image)!
        let imgPath = DataModel.shared.dataFilePath(withPathName: "\(book.isbns[0].isbn10)")
        
        do {
            try imgPng.write(to: imgPath, options: .atomic)
        } catch {
            print("Error saving image. \(error.localizedDescription)")
            return
        }
        let savedBook = Favorite(title: googleBook.volumeInfo.title, description: googleBook.volumeInfo.description!, isbn: googleBook.volumeInfo.industryIdentifiers[0].identifier)
        
        favorites.append(savedBook)
        
    }
    
    // save
    private func saveFavoriteList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            try data.write(to: dataFilePath(withPathName: DataModel.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    // load
    public func load() {
        let path = dataFilePath(withPathName: DataModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    // read
    public func getLists() -> [Favorite] {
        return favorites
    }
    
    // Check
    public func favoriteCheck(with isbn: String) -> Bool {
        let index = favorites.index(where: {$0.isbn == isbn })
        if index != nil {return true}
        return false
        
    }
    
    // delete
    public func removeFavoriteItemFromIndex(fromIndex index: Int) {
        favorites.remove(at: index)
    }
}
