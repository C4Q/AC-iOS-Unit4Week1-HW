//
//  DataModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class DataModel {
    
    struct BookFavorites: Codable {
        let imagePath: String
        var title: String
        var isbn: String
        var description: String
    }
    
    enum SavingDataResults: String {
        case exists = "Already favorited"
        case success = "Favorite Saved"
        case error = "Bad data"
        case removed = "Removed from favorites"
    }
    
    
    private static let kPathname = "BookFavoritesCodable.plist"
    
    private init() {}
    static let manager = DataModel()
    
    private var bookFavorites = [BookFavorites]() {
        didSet {
            saveBookFavorites()
        }
    }
    
    // returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the documents directory
    private func dataFilePath(withPathName path: String) -> URL {
        return DataModel.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // save
    private func saveBookFavorites() {
        //print documents folder path
        print("Documents Path:\(documentsDirectory())")
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(bookFavorites)
            try data.write(to: dataFilePath(withPathName: DataModel.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    // load
    func loadFavoriteBooks() -> [BookFavorites] {
        let path = dataFilePath(withPathName: DataModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            bookFavorites = try decoder.decode([BookFavorites].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
        return bookFavorites
    }
    
    //check for existing favorites
    func checkForExistingFavorite(by isbn: String) -> Bool {
        let result = bookFavorites.contains(where: {$0.isbn == isbn}) ? true : false
        return result
    }
    
    // create
    func setFavorite(book: Volume?, image: UIImage) -> String {
        guard let isbn = book?.volumeInfo.industryIdentifiers[0].identifier, let description = book?.volumeInfo.description, let title = book?.volumeInfo.title else{ return SavingDataResults.error.rawValue }
        guard  checkForExistingFavorite(by: isbn) == false else { return SavingDataResults.exists.rawValue}
        let imagePath = processPNG(image: image, isbn: isbn)
        let book = BookFavorites(imagePath: imagePath, title: title, isbn: isbn, description: description)
        bookFavorites.append(book)
        return SavingDataResults.success.rawValue
    }
    
    // read
    func getbookFavorites() -> [BookFavorites] {
        return bookFavorites
    }
    
    // delete
    func removeFavoriteBook(by isbn: String) -> String {
        let url = dataFilePath(withPathName: isbn)
        do {
            try FileManager.default.removeItem(at: url)
            guard let index = bookFavorites.index(where: {$0.isbn == isbn}) else { return SavingDataResults.error.rawValue }
            bookFavorites.remove(at: index)
        } catch {
            print("Error removing favorite. \(error.localizedDescription)")
        }
         return SavingDataResults.removed.rawValue
    }
    
    private func processPNG(image: UIImage, isbn: String) -> String {
        let image = UIImagePNGRepresentation(image)
        let imagePath = DataModel.manager.dataFilePath(withPathName: "\(isbn)")
        do {
            try image?.write(to: imagePath, options: .atomic)
        } catch {
            print("Error saving image. \(error.localizedDescription)")
        }
        return imagePath.description
    }
}
