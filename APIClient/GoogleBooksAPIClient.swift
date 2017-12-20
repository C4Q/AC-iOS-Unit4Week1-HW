//
//  GoogleBooksAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Item: Codable {
    let items: [Book]
}

struct Book: Codable {
    let volumeInfo: Details
}

struct Details: Codable {
    let subtitle: String?
    let description: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}


struct GoogleBooksAPIClient {
    private init () {}
    static let manager = GoogleBooksAPIClient()
    
    let apiKey = "AIzaSyDZXs_qSHTfULtcWXiDTROCxnVB-pG-MIE"
    
    func getGoogleBook(isbn: String, completionHandler: @escaping (Book) -> Void , errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://www.googleapis.com/books/v1/volumes?key=\(apiKey)q=+isbn:\(isbn)"
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let googleBook = try JSONDecoder().decode(Item.self, from: data)
                completionHandler(googleBook.items[0])
            } catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}


















