//
//  BestSellerAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellerResults: Codable {
    let results: [BookResults]
}

struct BookResults: Codable {
    let weeksOnList: Int
    let bookDetails: [BookDetails]
    
    enum CodingKeys: String, CodingKey {
        case weeksOnList = "weeks_on_list"
        case bookDetails = "book_details"
    }
}

struct BookDetails: Codable {
    let title: String
    let description: String
    let author: String
    let primaryISBN13: String
    let primaryISBN10: String
    
    enum codingKeys: String, CodingKey {
        case title
        case description
        case author
        case primaryISBN13 = "primary_isbn13"
        case primaryISBN10 = "primary_isbn10"
    }
}


struct BestSellerAPIClient {
    private init () {}
    static let manager = BestSellerAPIClient()
    
    let apiKey = "6b755fc9d2e742dd9026486a459655f3"
    
    func getBestSellers(pickerViewCategory: String, completionHandler: @escaping ([BookResults]) -> Void, errorHandler: @escaping (Error) -> Void) {
    let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(apiKey)&list=\(pickerViewCategory)"
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bestsellerList = try JSONDecoder().decode(BestSellerResults.self, from: data)
                completionHandler(bestsellerList.results)
            } catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}

