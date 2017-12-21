//
//  DataKey.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Favorite: Codable {
    let author: String
    let title: String
    let subtitle: String
    let description: String
    let isbn: String
}
class DataModel {
    
    static let kPathname = "BestSellerBooks.plist"
    
    // using a singleton to manage the model
    private init(){}
    static let shared = DataModel()
    
    private var favorite = [Favorite]() {
        didSet { // property observer does saving to persistence on changes
            saveDSAList()
            print(documentsDirectory())
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
    private func saveDSAList() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(favorite)
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
            favorite = try decoder.decode([Favorite].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    // create
    public func addDSAItemToList(dsaItem item: Favorite) {
        favorite.append(item)
    }
    
    // read
    public func getLists() -> [Favorite] {
        return favorite
    }
    
    // update
//    public func updateDSAItem(withUpdatedItem item: String) {
//        if let index = favorite.index(where: {$0.title == favorite }) {
//            favorite[index] = item
//        }
//    }
    
    // delete
    public func removeDSAItemFromIndex(fromIndex index: Int) {
        favorite.remove(at: index)
    }
}
