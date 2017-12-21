//
//  KeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
class KeyedArchiverClient {
    private init() {}
    static let manager = KeyedArchiverClient()
    static let pathName = "FavoriteBooks.plist"
    static let defaults = UserDefaults.standard
    private var books = [Book]() {
        didSet {
            saveBooks()
        }
    }
    // returns documents directory path for app sandbox
    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return KeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
    // load
    public func load() {
        let path = dataFilePath(withPathName: KeyedArchiverClient.pathName)
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: path)
            books = try decoder.decode([Book].self, from: data)
        } catch {
            print("error decoding items: \(error.localizedDescription)")
        }
    }
    
    func saveBooks() {
        do {
            let data = try PropertyListEncoder().encode(books)
            try data.write(to: dataFilePath(withPathName: KeyedArchiverClient.pathName), options: .atomic)
        } catch {
            print(error)
        }
    }
    
    // read
    public func getBooks() -> [Book] {
        return books
    }
    
    // Add
    public func addBookToList(Card item: Book) {
        books.append(item)
    }
}
