//
//  GoogleBooksModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//Endpoint "https://www.googleapis.com/books/v1/volumes?q=+isbn:0385514239"
//https://www.googleapis.com/books/v1/volumes?q=+isbn:\(ISBNGOESHERE)+\(apikey)
//key=API_KEY
var apikey = "AIzaSyAA1l0upCWnuzbWRdfeltaIpGXuSDKV1Q4"

struct GoogleBooksTopLevel: Codable {
    var items: [BookInfo]
}

struct BookInfo: Codable  {
    var volumeInfo: BookWrapper
}

struct BookWrapper: Codable {
    var title: String
    var subtitle: String?
    var authors: [String]
    var description: String //This is the summary
    var imageLinks: ImageWrapper
    var allAuthors: String {
        var authorString = ""
        for authors in authors {
            authorString.append(authors)
        }
        return authorString
    }
}

struct ImageWrapper: Codable {
    var smallThumbnail: String
    var thumbnail: String
}

//MAKE GOOGLE API HERE
struct GoogleAPIClient {
    private init() {}
    static let manager = GoogleAPIClient()
    func getBookInfo(matching putISBNHere: String,
                        completionHandler: @escaping ([BookWrapper]) -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        let endpointLink = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(putISBNHere)&\(apikey)"
        guard let url = URL(string: endpointLink) else {
            errorHandler(AppError.badURL(str: putISBNHere))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoBooks: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(GoogleBooksTopLevel.self, from: data)
                let booksArray = results.items[0].volumeInfo
                completionHandler([booksArray])
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoBooks, errorHandler: errorHandler)
    }
}

