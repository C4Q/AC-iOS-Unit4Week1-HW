//
//  KeyedArchiverClient.swift
//  CollectionViewsMorning
//
//  Created by Richard Crichlow on 12/14/17.
//  Copyright © 2017 Richard Crichlow. All rights reserved.
//

import Foundation

//TODO
class BestSellersKeyedArchiverClient {
    private init() {}
    static let manager = BestSellersKeyedArchiverClient()
    static let pathName = "BestSellersBooks.plist"
    private var books = [BookDetails]() {
        didSet {
            saveBooks()
        }
    }

    func add(book: BookDetails) {
        books.append(book)
    }

    func getCards() -> [BookDetails] {
        return self.books
    }

    func loadData() {
        let path = dataFilePath(withPathName: BestSellersKeyedArchiverClient.pathName)
        do {
            let data = try Data(contentsOf: path)
            let books = try PropertyListDecoder().decode([BookDetails].self, from: data)
            self.books = books
        }
        catch {
            print(error)
        }
    }

    func saveBooks() {
        let path = dataFilePath(withPathName: BestSellersKeyedArchiverClient.pathName)
        do {
            let data = try PropertyListEncoder().encode(books)
            try data.write(to: path, options: .atomic)
        }
        catch {
            print(error)
        }
    }

    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return BestSellersKeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }

}
