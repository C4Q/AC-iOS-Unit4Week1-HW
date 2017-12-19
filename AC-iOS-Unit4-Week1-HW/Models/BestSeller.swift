//
//  BestSellers.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellersResponse: Codable {
    let num_results: Int
    let results: [BestSeller]
}

struct BestSeller: Codable {
    let list_name: String
    let display_name: String
    let bestsellers_date: String
    let published_date: String
    let rank: Int
    let rank_last_week: Int
    let weeks_on_list: Int
    let amazon_product_url: String
    let book_details: [Book]
}

struct Book: Codable {
    let title: String
    let description: String
    let contributor: String
    let author: String
    let price: Double
    let publisher: String
    let primary_isbn13: String
    let primary_isbn10: String
}

struct BestSellersAPIClient {
    private init() {}
    static let manager = BestSellersAPIClient()
    
    let apiKey = "625d90145c754087a4e16200c1bbdfb6"
    let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?"
    func getBestSellers(with category: String, completionHandler: @escaping ([BestSeller]) -> Void, errorHandler: @escaping (Error) -> Void) {
        // TODO: rename variables better
        let formattedCategory = category.replacingOccurrences(of: " ", with: "-")
        let options = "api-key=\(apiKey)&list=\(formattedCategory)"
        let fullUrl = urlStr + options
        print(fullUrl)
        guard let url = URL(string: fullUrl) else {
            errorHandler(AppError.badURL(str: fullUrl))
            return
        }
        let urlRequest = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bestSellersResponse = try JSONDecoder().decode(BestSellersResponse.self, from: data)
                completionHandler(bestSellersResponse.results)
            }
            catch {
                errorHandler(AppError.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: urlRequest, completionHandler: completion, errorHandler: errorHandler)
    }
}

