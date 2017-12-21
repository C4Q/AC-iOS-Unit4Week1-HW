//
//  BooksKeyedArchiverClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class BooksKeyedArchiverClient {
    
    private init() {}
    static let manager = BooksKeyedArchiverClient()
    
    private var aSpecificBook = [BookWrapper]()
    func addSpecificBookArray(Book: [BookWrapper]) {
        self.aSpecificBook = Book
    }
    
    func getSpecificBook() -> [BookWrapper] {//Populate the VC's array with the current Book
        return self.aSpecificBook
    }
    
    func loadData(ISBN: String) {//Load Data based on the category
        let correctedPath = ISBN + ".plist"
        let path = dataFilePath(withPathName: correctedPath)
        do {
            let data = try Data(contentsOf: path)
            let books = try PropertyListDecoder().decode([BookWrapper].self, from: data)
            self.aSpecificBook = books
        }
        catch {
            print(error)
        }
    }
    
    func saveBook(ISBN: String) {//Save Data with the category as the path name
        let correctedPath = ISBN + ".plist"
        let path = dataFilePath(withPathName: correctedPath)
        do {
            let data = try PropertyListEncoder().encode(aSpecificBook)
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
        return BooksKeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }
    
}
