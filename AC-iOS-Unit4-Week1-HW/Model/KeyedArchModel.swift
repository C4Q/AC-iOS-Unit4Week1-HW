//
//  KeyedArchClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class KeyedArchiverModel {
    
    static let shared = KeyedArchiverModel()
    private init() {}
    
    static let plistPathName = "FavoriteBooksTEST.plist"
    
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first!
    }
    
    func dataFilePath(pathName: String) -> URL {
        return KeyedArchiverModel.shared.documentsDirectory().appendingPathComponent(pathName)
    }
    
    var favBooks = [Book]() {
        didSet {
            saveFavorites()
        }
    }
    
    //    save
    func saveFavorites() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favBooks)
            try data.write(to: dataFilePath(pathName: KeyedArchiverModel.plistPathName), options: .atomic)
        } catch {
            print("Encoder error: \(error.localizedDescription)")
        }
    }
    
    //    load
    func loadFavorites() {
        let decoder = PropertyListDecoder()
        let path = dataFilePath(pathName: KeyedArchiverModel.plistPathName)
        do {
            let data = try Data.init(contentsOf: path)
            favBooks = try decoder.decode([Book].self, from: data)
        } catch {
            print("Decoder error: \(error.localizedDescription)")
        }
    }
    
    //    add
    func addFavBook(book: Book) {
        favBooks.append(book)
    }
    
    //    delete
    func removeFavBook(index: Int) {
        favBooks.remove(at: index)
    }
    
    //    read
    func getFavBooks() -> [Book] {
        return favBooks
    }
}
