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
        let summary: String
    }
    
    // Save favorites everytime it changes
    private var myBooks = [FavoritedBook]() {
        didSet {
            saveFavorites()
        }
    }
    
    // Gets the doc dir path
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // Gets the file path in doc dir
    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistenceHelper.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // Loads the favorites into this object
    func loadFavorites() {
        var data = Data()
        do {
            data = try Data.init(contentsOf: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath))
        } catch {
            print("Error retrieving data. \(error.localizedDescription)")
            return
        }
        
        do {
            myBooks = try PropertyListDecoder().decode([FavoritedBook].self, from: data)
        } catch {
            print("Plist decoding error. \(error.localizedDescription)")
        }
    }
    
    // Returns this object's array of favorites
    func getFavorites() -> [FavoritedBook] {
        return myBooks
    }
    
    // Saves current array of favorites into a plist into the doc dir
    private func saveFavorites() {
        var data = Data()
        
        do {
            data = try PropertyListEncoder().encode(myBooks)
        } catch {
            print("Plist encoding error. \(error.localizedDescription)")
            return
        }

        do {
            try data.write(to: DataPersistenceHelper.manager.dataFilePath(withPathName: filePath), options: .atomic)
            
        } catch {
            print("Writing to disk error. \(error.localizedDescription)")
        }
        
    }
    
    // Appends an object to favorite books array
    // Also saves the image in the doc dir
    func addFavorite(nytBook: BestSellerBook, googleBook: GoogleBook, image: UIImage) {
        let currentTime = Date()
        let imgPng = UIImagePNGRepresentation(image)!
        let imgPath = DataPersistenceHelper.manager.dataFilePath(withPathName: "\(nytBook.bookDetails[0].title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)\(nytBook.bookDetails[0].isbn13)")
        
        do {
            try imgPng.write(to: imgPath, options: .atomic)
        } catch {
            print("Error saving image. \(error.localizedDescription)")
            return
        }
        
        let favoriteBook = FavoritedBook(bookImagePath: imgPath.description, title: nytBook.bookDetails[0].title, isbn: nytBook.bookDetails[0].isbn13, timeSaved: currentTime, summary: (googleBook.volumeInfo.description ?? "No description"))
        
        myBooks.append(favoriteBook)
        
    }
    
    /////////////////////////////
    // TODO: - Implement delete
    /////////////////////////////
    func deleteFavorite(book: FavoritedBook, index: Int) {
        let imageURL = DataPersistenceHelper.manager.dataFilePath(withPathName: "\(book.title.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)\(book.isbn)")
        
        do {
            try FileManager.default.removeItem(at: imageURL)
            myBooks.remove(at: index)
        } catch {
            print("Error removing favorite. \(error.localizedDescription)")
            return
        }
    }
    /////////////////////////////
    
    // Checks if the book is already in the favorites
    func alreadyFavorited(isbn: String) -> Bool {
        
        let indexExist = myBooks.index{ $0.isbn == isbn }
        if indexExist != nil { return true }
        
        return false
        
    }
    
    
}

