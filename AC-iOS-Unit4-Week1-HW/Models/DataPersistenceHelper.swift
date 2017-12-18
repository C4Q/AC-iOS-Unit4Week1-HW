//
//  NSKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DataPersistenceHelper {
    
    // Singleton design pattern
    private init() {}
    static let manager = DataPersistenceHelper()
    
    // File name
    private let filePath = "FavoriteBooks.plist"

    // Object to hold info to save
    struct FavoritedBook: Codable {
        let bookImagePath: String
        let title: String
        let isbn: String
        let timeSaved: Date
    }
    
    private var myBooks = [FavoritedBook]() {
        didSet {
            saveFavorites()
        }
    }
    
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistenceHelper.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    func loadFavorites() {
        var data = Data()
        do {
            data = try Data.init(contentsOf: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath))
        } catch {
            print("Error retrieving data. \(error.localizedDescription)")
        }
        
        do {
            myBooks = try PropertyListDecoder().decode([FavoritedBook].self, from: data)
        } catch {
            print("Plist decoding error. \(error.localizedDescription)")
        }
    }
    
    func getFavorites() -> [FavoritedBook] {
        return myBooks
    }
    
    private func saveFavorites() {
        var data = Data()
        
        do {
            data = try PropertyListEncoder().encode(myBooks)
        } catch {
            print("Plist encoding error. \(error.localizedDescription)")
        }

        do {
            try data.write(to: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath), options: .atomic)
        } catch {
            print("Writing to disk error. \(error.localizedDescription)")
        }
        
    }
    
    func addFavorite(isbn: String, bookTitle: String, image: UIImage) {
        let currentTime = Date()
        let imgPng = UIImagePNGRepresentation(image)!
        let imgPath = DataPersistenceHelper.manager.dataFilePath(withPathName: "\(bookTitle)\(isbn)")
        
        do {
            try imgPng.write(to: imgPath, options: .atomic)
        } catch {
            print("Error saving image. \(error.localizedDescription)")
        }
        
        let favoriteBook = FavoritedBook(bookImagePath: isbn, title: bookTitle, isbn: isbn, timeSaved: currentTime)
        
        myBooks.append(favoriteBook)
    }
    
    func deleteFavorite(book: FavoritedBook, index: Int) {
        let imageURL = DataPersistenceHelper.manager.dataFilePath(withPathName: "\(book.title)\(book.isbn)")
        
        do {
            try FileManager.default.removeItem(at: imageURL)
        } catch {
            print("error removing: \(error.localizedDescription)")
        }
        myBooks.remove(at: index)
    }
    
    
    
}

