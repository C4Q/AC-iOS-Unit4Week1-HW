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
        do {
            
        } catch {
            print("Error loading favorites. \(error.localizedDescription)")
        }
    }
    
    private func saveFavorites() {
        do {
            let data = try PropertyListEncoder().encode(myBooks)
            
        } catch {
            
        }
    }
    
    func addFavorite(isbn: String, bookTitle: String, image: UIImage) {
        let currentTime = Date()
        
        let imgPng = UIImagePNGRepresentation(image)!
        let imgPath = DataPersistenceHelper.manager.dataFilePath(withPathName: "\(bookTitle)\(isbn)")
        
        
        let favoriteBook = FavoritedBook(bookImagePath: isbn, title: bookTitle, isbn: isbn, timeSaved: currentTime)
        
        myBooks.append(favoriteBook)
        
        
    }
    
    func deleteFavorite(book: FavoritedBook) {
        
    }
    
    
    
}

