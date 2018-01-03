//
//  GoogleBookData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/22/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GoogleBookData {
    private let pListName = "GoogleBooks.plist"
    
    private init() {}
    static let manager = GoogleBookData()
    
    var googleBooks: [GoogleBook] = [] {
        didSet {
            saveGoogleBook()
        }
    }
    
    //save
    func saveGoogleBook() {
        PersistentData.manager.saveItem(googleBooks, atFileName: pListName)
    }
    
    //load
    func loadGoogleBooks() {
        guard let googleBooks = PersistentData.manager.loadItems(fromFileName: pListName) as? [GoogleBook] else {
            return
        }
        
        self.googleBooks = googleBooks
    }
    
    //add
    func addGoogleBook(_ googleBook: GoogleBook) {
        googleBooks.append(googleBook)
    }
    
    //get
    func getGoogleBooks() -> [GoogleBook] {
        return googleBooks
    }
    
    //remove
    func removeGoogleBook(_ googleBook: GoogleBook) {
        if googleBooks.contains(googleBook) {
            self.googleBooks.remove(at: googleBooks.index(of: googleBook)!)
        }
    }
    
    private func pListName(ofCategory category: String) -> String {
        return category + ".plist"
    }
    
}
