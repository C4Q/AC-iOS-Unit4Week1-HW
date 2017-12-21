//
//  DataModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/19/17.
//  Copyright © 2017 Tyler Zhao . All rights reserved.
//

import Foundation

class DataModel: Codable {
    
    static var selectedPickerRow: Int {
        return UserDefaults.standard.integer(forKey: "SelectedRow")
    }
    
    static let kPathname = "FavoriteList.plist"
    
    private init(){}
    static let shared = DataModel()
    
    private var lists = [Favorites]() {
        didSet {
            saveFavoritesList()
        }
    }
    
    // returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return DataModel.shared.documentsDirectory().appendingPathComponent(path)
    }
    
    // save
    private func saveFavoritesList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(withPathName: DataModel.kPathname), options: .atomic)
        } catch {
            print("error encoding items: \(error.localizedDescription)")
        }
    }
    
    // load
    public func load() {
        let path = dataFilePath(withPathName: DataModel.kPathname)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            lists = try decoder.decode([Favorites].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    // create
    public func addFavoritesItemToList(favoriteItem item: Favorites) {
        lists.append(item)
    }
    
    // read
    public func getLists() -> [Favorites] {
        return lists
    }
    
    //update
    public func updateFavoritesItem(withUpdatedItem item: Favorites) {
        if let index = lists.index(where: {$0 === item}) {
            lists[index] = item
        }
    }

    // delete
    public func removeFavoritesItemFromIndex(fromIndex index: Int) {
        lists.remove(at: index)
    }
}

