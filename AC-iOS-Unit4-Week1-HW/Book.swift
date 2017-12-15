//
//  Book.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

///1st Endpoint
struct BookInfo: Codable {
    let results: [BookType]
}
struct BookType: Codable {
    let name: String
    enum CodingKeys: String, CodingKey {
        case name = "list_name"
    }
}

///2nd Endpoint
struct BookWrapper: Codable {
    let results: [BookList]
}
struct BookList: Codable {
    let duration: Int
    let details: [BookDetail]
    enum CodingKeys: String, CodingKey {
        case duration = "weeks_on_list"
        case details = "book_details"
    }
}
struct BookDetail: Codable {
    let title: String
    let description: String
}

struct BookAPIClient {
    private init() {}
    static let manager = BookAPIClient()
    private let bookTypeUrl = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=ef6e801396e44409a1b28aee9dbcd7d4"
    func getBookDetail(from urlStr: String, completionHandler: @escaping ([BookList]) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr ) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let bookData: (Data) -> Void = {(data) in
            do {
                let bookResults = try JSONDecoder().decode(BookWrapper.self, from: data)
                let book = bookResults.results
                completionHandler(book)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: bookData, errorHandler: errorHandler)
    }
    func getBookType(completionHandler: @escaping ([BookType]) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: bookTypeUrl) else {
            errorHandler(AppError.badURL(str: bookTypeUrl))
            return
        }
        let request = URLRequest(url: url)
        let bookData: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(BookInfo.self, from: data)
                let book = results.results
                completionHandler(book)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: bookData, errorHandler: errorHandler)
    }
}
