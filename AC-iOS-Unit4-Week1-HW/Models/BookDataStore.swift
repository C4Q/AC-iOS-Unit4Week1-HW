//
//  BookDataStore.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class BookDataStore {
static let kPathname = "FavoriteBooks"

//singleton
private init(){}
static let manager = BookDataStore()
    
    private var favorites = [Favorite]() {
        didSet {
            saveToDisk()
        }
}

//returns documents directory path for app sandbox
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
}

    // /documents/Favorites.plist
    //returns the path for supplied name from the documents directory
    func dataFilePath(withPathName path: String) -> URL {
        return BookDataStore.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    func saveToDisk() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorites)
            //does the writing to disk
            try data.write(to: dataFilePath(withPathName: BookDataStore.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    //load
    public func load() {
        let path = dataFilePath(withPathName: BookDataStore.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            favorites = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    //does 2 tasks:
    //1. stores image in documents folder
    //2. appends favorite item to array
    func addToFavorites(book: BooksInfo, andImage image: UIImage) -> Bool {
        let indexExist = favorites.index{ $0.identifier == book.volumeInfo.industryIdentifiers.first?.identifier}
        
        if indexExist != nil {print("FAVORITE EXIST"); return false}
       
        
        // 1) save image from favorite photo
          let success = storeImageToDisk(image: image, andBook: book)
        if !success { return false }
        // 2) save favorite object
         guard let identifier = book.volumeInfo.industryIdentifiers.first else { return false }
       let newFavorite = Favorite.init(subtitle: book.volumeInfo.subtitle, description: book.volumeInfo.description, identifier: identifier.identifier)
          favorites.append(newFavorite)
        return true
    }
    
    func storeImageToDisk(image: UIImage, andBook book: BooksInfo) -> Bool {
        // packing data from image UIImagePNGrEPRESENTATION stores it as a PNG Image
        guard let imageData = UIImagePNGRepresentation(image) else {return false}
         // writing and saving to documents folder
        // 1) save image from favorite photo
        
        guard let identifier = book.volumeInfo.industryIdentifiers.first else { return false }
        
       let imageURL = BookDataStore.manager.dataFilePath(withPathName: identifier.identifier)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }
    
    func isBookInFavorites(book: BooksInfo) -> Bool {
        //checking for uniqueness
        let indexExist = favorites.index{ $0.identifier == book.volumeInfo.industryIdentifiers[0].identifier }
        if indexExist != nil {
            return true
        } else {
            return false
        }
    }
    func getImage(identifier: String) -> UIImage? {
        let imageURL = BookDataStore.manager.dataFilePath(withPathName: identifier)
        do {
          let data = try Data.init(contentsOf: imageURL)
             let image = UIImage.init(data: data)
            return image
        } catch {
            print("getting Image error: \(error.localizedDescription)")
        }
        return nil 
    }
    
    func getFavoriteWithId(identifier: String) -> Favorite? {
        let index = getFavorites().index{$0.identifier == identifier }
        guard let indexFound = index else { return nil }
         return favorites[indexFound]
    }
    
    func getFavorites() -> [Favorite] {
        return favorites
        
    }
    
    func removeFavorite(fromIndex index: Int, andBookImage favorite: Favorite) -> Bool {
        favorites.remove(at: index)
        // remove image
        let imageURL = BookDataStore.manager.dataFilePath(withPathName: favorite.identifier)
        do {
            try FileManager.default.removeItem(at: imageURL)
            print("\n==============================================================================")
            print("\(imageURL) removed")
            print("==============================================================================\n")
            return true
        } catch {
            print("error removing: \(error.localizedDescription)")
            return false
        }
    }
}



