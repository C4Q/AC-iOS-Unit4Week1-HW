//
//  GoogleAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct GoogleInfo: Codable {
    let items: [GoogleBooks]
}
struct GoogleBooks: Codable {
    let volumeInfo: Volume
}
struct Volume: Codable {
    let title: String
    let authors: [String]
    let subtitle: String?
    let description: String
    let imageLinks: Image?
    struct Image: Codable {
        let thumbnail: String
    }
    let industryIdentifiers: [Identify]
    struct Identify: Codable {
        let identifier: String
    }
}

struct GoogleAPIClient {
    private init() {}
    static let manager = GoogleAPIClient()
    func getImages(from isbn: String, completionHandler: @escaping ([GoogleBooks]?) -> Void, errorHandler: @escaping (Error) -> Void) {
        let apiKiey = "AIzaSyDfF49GohumkSxfteiRiO-79kPb6mtqXI0"
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(apiKiey)"
        let request = URLRequest(url: URL(string: urlStr)!)
        let parsedGoogleDetails: (Data) -> Void = {(data: Data) in
            do {
                let googleBook = try JSONDecoder().decode(GoogleInfo.self, from: data)
                completionHandler(googleBook.items)
            } catch {
                errorHandler(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parsedGoogleDetails, errorHandler: errorHandler)
    }
}
