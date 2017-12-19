//
//  GoogleBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct GoogleBookResponse: Codable {
    let items: [GoogleBook]
}

struct GoogleBook: Codable {
    let volumeInfo: VolumeInfoWrapper
    let saleInfo: SaleInfoWrapper
}

struct VolumeInfoWrapper: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let description: String
    let imageLinks: ImagesWrapper
    let industryIdentifiers: [ISBNWrapper]
}

struct ImagesWrapper: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

struct SaleInfoWrapper: Codable {
    let retailPrice: PriceWrapper?
}

struct PriceWrapper: Codable {
    let amount: Double
}

struct ISBNWrapper: Codable {
    var type: String
    var identifier: String
}

struct GoogleBookAPIClient {
    private init() {}
    static let manager = GoogleBookAPIClient()
    
    let apiKey = "AIzaSyAnbRfnkNiDr6ZusJ5eT2VAnseUm0dano8"
    let urlStr = "https://www.googleapis.com/books/v1/volumes?"
    func getGoogleBook(with isbn: String, completionHandler: @escaping (GoogleBook) -> Void, errorHandler: @escaping (Error) -> Void) {
        // TODO: fix with better names
        let formattedURL = "key=\(apiKey)&q=+isbn:\(isbn)"
        let fullUrl = urlStr + formattedURL
        guard let url = URL(string: fullUrl) else {
            errorHandler(AppError.badURL(str: fullUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let googleBookResponse = try JSONDecoder().decode(GoogleBookResponse.self, from: data)
                completionHandler(googleBookResponse.items[0])
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}
