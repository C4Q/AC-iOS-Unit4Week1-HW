//
//  BestSellerAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class BestSellerAPIClient: Codable {
    private init() {}
    static let manager = BestSellerAPIClient()
    private let apiKey = "f17a6f246cf34666b4ccbf18bcb00469"
    func getBestSellers(forCategory category: String, completionHandler: @escaping ([BestSeller]) -> Void, errorHandler: @escaping (Error) -> Void) {
        
        let formattedCategory = category.replacingOccurrences(of: " ", with: "-")
        
        let urlString = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(apiKey)&list=\(formattedCategory)"
        
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                do {
                    let bestSeller = try JSONDecoder().decode(BestSellerWrapper.self, from: data)
                    completionHandler(bestSeller.results)
                } catch let error {
                    errorHandler(AppError.cannotParseJSON(rawError: error))
                }
        },
            errorHandler: errorHandler)
        
    }
}
