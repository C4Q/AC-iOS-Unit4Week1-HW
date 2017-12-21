//
//  DataModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class DataPersistenceModel {
    
    static let kPathname = "FavoriteBooks.plist"
    
    private init(){}
    static let shared = DataPersistenceModel()
    
    private var favoriteBooksList = [FavoriteBook]() {
        didSet {
            saveFavoriteBooksList()
        }
    }

    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    private func dataFilePath(withPathName path: String) -> URL {
        return DataPersistenceModel.shared.documentsDirectory().appendingPathComponent(path)
    }
    
    private func saveFavoriteBooksList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favoriteBooksList)
            try data.write(to: dataFilePath(withPathName: DataPersistenceModel.kPathname), options: .atomic)
        } catch {
            print("Error while trying to encode: \(error.localizedDescription)")
        }
    }
    
    public func load() {
        let path = dataFilePath(withPathName: DataPersistenceModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: path)
            favoriteBooksList = try decoder.decode([FavoriteBook].self, from: data)
        } catch {
            if favoriteBooksList.isEmpty { return }
            print("Error while trying to decode: \(error.localizedDescription)")
        }
    }
    
    public func isBookAlreadySaved(isbn: String) -> Bool {
        let favBookIndexFound = favoriteBooksList.index{ $0.isbn == isbn }
        if favBookIndexFound != nil { return true}
        else { return false }
    }
    
    public func addFavoriteBookToList(book: GoogleBook, with image: UIImage, and isbn: String) {
        guard let imageData = UIImagePNGRepresentation(image) else { return }
        let imageURL = DataPersistenceModel.shared.dataFilePath(withPathName: "\(isbn)")
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        let newFavoriteBook = FavoriteBook(title: book.volumeInfo.title, author: book.volumeInfo.authors.first, subtitle: book.volumeInfo.subtitle, longDescription: book.volumeInfo.description, isbn: isbn)
        favoriteBooksList.append(newFavoriteBook)
    }
    
    public func getFavoriteBooksList() -> [FavoriteBook] {
        return favoriteBooksList
    }
    
}
