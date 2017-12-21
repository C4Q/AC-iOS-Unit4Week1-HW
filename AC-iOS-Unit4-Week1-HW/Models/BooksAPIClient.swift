//
//  BooksAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct BooksAPIClient {
    private init() {}
    static let manager = BooksAPIClient()
    private let keyUser = "UserSetting"
    private let defaults = UserDefaults.standard
    static let APIKeyNYT = "9f39668c8c0d4aadbd3e97a30c45e5c7"
    static let urlNYT = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key="
    static let urlGoogleISNB = "https://www.googleapis.com/books/v1/volumes?q=+isbn:"
    
    func saveSetting(_ category: Int) {
        defaults.set(category, forKey: keyUser)
    }
    
    func getSetting() -> Int? {
        if let userIndex = defaults.value(forKey: keyUser) as? Int {
            return userIndex
        }
        return nil
    }
    
    func getBooks(from str: String,
                   completionHandler: @escaping ([Book]) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
//        let APIKey = "9f39668c8c0d4aadbd3e97a30c45e5c7"
//        let urlStr = str + APIKey
        guard let url = URL(string: str) else {return}
        let parseDataIntoImageArr = {(data: Data) in
            do {
                let onlineBooks = try JSONDecoder().decode(AllBooks.self, from: data)
                if let result = onlineBooks.results {
                    completionHandler(result)
                } else if let result = onlineBooks.items {
                    completionHandler(result)
                }
            }
            catch let error {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: parseDataIntoImageArr, errorHandler: errorHandler)
    }
    
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(AppError.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
