//
//  UserDefaultHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct UserDefaultHelper {
    private init() {}
    static let manager = UserDefaultHelper()
    private let BookKey = "Book"
    func getBook() -> Int? {
        return UserDefaults.standard.integer(forKey: BookKey)
    }
    func setBook(to newBook: Int) {
        UserDefaults.standard.setValue(newBook, forKey: BookKey)
    }
}

