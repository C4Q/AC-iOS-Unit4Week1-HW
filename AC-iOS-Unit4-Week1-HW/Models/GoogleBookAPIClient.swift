//
//  GoogleBookAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GoogleBookAPIClient {
    private init() {}
    static let manager = GoogleBookAPIClient()
    private let apiKey = "AIzaSyArOXpzhrDNQtJLOIGDoQFPW9cAhHGNIQ8"
    func getGoogleBooks(forISBN isbn: String, completionHandler: @escaping (GoogleBook?) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlString = "https://www.googleapis.com/books/v1/volumes?key=\(apiKey)&q=+isbn:\(isbn)"
        
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                do {
                    let results = try JSONDecoder().decode(GoogleBookWrapper.self, from: data)
                    completionHandler(results.items?.first)
                } catch let error {
                    errorHandler(AppError.cannotParseJSON(rawError: error))
                }
        },
            errorHandler: errorHandler)
    }
}
