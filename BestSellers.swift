//
//  Best Sellers.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/18/17.
//  Copyright © 2017 Tyler Zhao . All rights reserved.
//

import Foundation

struct BestSellers: Codable {
    let results: [BestSellerResults]
}

struct BestSellerResults: Codable {
    let display_name: String
    let list_name: String
    let rank: Int
    let weeks_on_list: Int
    let book_details: [BookDetails]
}

struct BookDetails: Codable {
    let title: String
    let description: String
    let author: String
    let publisher: String
    let primary_isbn13: String
    let primary_isbn10: String
}

struct BestSellerAPIClient {
    private init() {}
    static let manager = BestSellerAPIClient()
    func getBestSellers(from urlStr: String,
                       completionHandler: @escaping ([BestSellerResults]) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoThing: (Data) -> Void = {(data) in
            do {
                let bestSellers = try JSONDecoder().decode(BestSellers.self, from: data)
                let results = bestSellers.results
                completionHandler(results)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoThing,
                                              errorHandler: errorHandler)
    }
}

