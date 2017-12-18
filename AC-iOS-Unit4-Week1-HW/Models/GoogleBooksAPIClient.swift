//
//  GoogleBooksAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class GoogleBooksAPIClient {
    
    // Singleton design patter
    private init() {}
    static let manager = GoogleBooksAPIClient()
    
    // My google books api key
    private let apiKey = "AIzaSyA8tq1VTl0juBlIc8Q47ng23Y7MPX9taBI"
    
    // Function that takes in an isbn, a completion handler, and an error handler.
    // The completion handler turns data into an array of GoogleBook objects with Codable
    func getBookData(isbn: String,
                     completionHandler: @escaping ([GoogleBook]?) -> Void,
                     errorHandler: @escaping (Error) -> Void) {
        
        let endpoint = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(apiKey)"
        
        guard let url = URL(string: endpoint) else { errorHandler(AppError.badUrl); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            do {
                let json = try JSONDecoder().decode(BooksData.self, from: data)
                if let items = json.items {
                    completionHandler(items)
                } else {
                    completionHandler(nil)
                }
            } catch {
                print(endpoint)
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
    
}
