//
//  FavoritesArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class FavoritesArchiverClient {
    private init() {}
    static let manager = FavoritesArchiverClient()
    
    static let pathName = "FavoriteBooks.plist"
    
    private var favoritesArr = [[BookWrapper]]() {
        didSet {
            
            saveFavorites()
            
        }
    }
    
    func add(favorite: [BookWrapper]) {
        favoritesArr.append(favorite)
    }
    
    func getFavorites() -> [[BookWrapper]] {
        return favoritesArr
    }
    
    func loadFavorites() {
        let path = dataFilePath(withPathName: FavoritesArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let favorites = try PropertyListDecoder().decode([[BookWrapper]].self, from: data)
            self.favoritesArr = favorites
        }
        catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    func saveFavorites() {
        //encode the categories into data so they can be saved with propertyListEncoder
        let path = dataFilePath(withPathName: FavoritesArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(favoritesArr)
            //write this data to a plist
            try data.write(to: path, options: .atomic)
            
        }
        catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    //returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        //this is finding the document folder in the app
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //return document folder url path
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        //now you can write to the file/pathName you pass in! (If the file name doesn't exsist, it will create it)
        return FavoritesArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
}

