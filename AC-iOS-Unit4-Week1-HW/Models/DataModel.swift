//
//  DataModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct FavoriteBook {
    let title: String
    let subtitle: String?
    let longDescription: String
    let bookImage: UIImage
    let imageURL: String
}

class DataModel {
    
    static let kPathname = "FavoriteBooks.plist"
    
    private init(){}
    static let shared = DataModel()
    
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
        return DataModel.shared.documentsDirectory().appendingPathComponent(path)
    }
    
    private func saveFavoriteBooksList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favoriteBooksList)
            try data.write(to: dataFilePath(withPathName: DataModel.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    public func load() {
        let path = dataFilePath(withPathName: DataModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: path)
            favoriteBooksList = try decoder.decode([FavoriteBook].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    public func addFavoriteBookToList(book item: FavoriteBook) {
        favoriteBooksList.append(item)
    }
    
    public func getLists() -> [FavoriteBook] {
        return favoriteBooksList
    }
    
//    // delete
//    public func removeDSAItemFromIndex(fromIndex index: Int) {
//        favoriteBooksLists.remove(at: index)
//    }
}
