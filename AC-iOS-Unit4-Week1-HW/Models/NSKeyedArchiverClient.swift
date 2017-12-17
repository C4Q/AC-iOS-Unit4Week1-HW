//
//  NSKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class NSKeyedArchiverClient {
    
    // Singleton design pattern
    private init() {}
    static let manager = NSKeyedArchiverClient()
    
    // Path name
    private let path = "FavoriteBooks.plist"
    
    struct FavoritedBook: Codable {
        let bookImagePath: String
        let title: String
        let isbn: String
    }
    
    private var myBooks = [FavoritedBook]()
    
    
    // Store objects with NSKeyedArchiver using Codable
    func storeItems() {
        do {
            let data = try PropertyListEncoder().encode(myBooks)
            if success {
                print("Successfully saved.")
            } else {
                print("Save failed.")
            }
        } catch {
            print("Save Failed. \(error.localizedDescription)")
        }
    }
    
    // Get objects with NSKeyedUnarchiver using Codable
    func getItems() {

        
        
        do {
            let items = try PropertyListDecoder().decode([FavoritedBook].self, from: data)
            return
        } catch {
            print("Decoding failed. \(error.localizedDescription)")
        }
    }
    
}

