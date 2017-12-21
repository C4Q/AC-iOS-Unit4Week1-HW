//
//  GoogleAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct GoogleAPIClient {
    private init() {}
    static let manager = GoogleAPIClient()
    
    private let apiKey = "AIzaSyC80XyOEq1teuskfejuRmfZmuw3ehKSeI4"
    func getBookDetails(for isbn: String, completion: @escaping ([Volume]?) -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        print(isbn)
        let bookDetailsURL = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(apiKey)"
        print(bookDetailsURL)
        guard let url = URL(string: bookDetailsURL) else { errorHandler(AppError.badURL(str: bookDetailsURL)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { ( data: Data) in
            do {
                let json = try JSONDecoder().decode(BookPreview.self, from: data)
                guard let myJson = json.items else { print("nil"); completion(nil); return }
                completion(myJson)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
