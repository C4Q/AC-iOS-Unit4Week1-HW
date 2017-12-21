//
//  NYTimesAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class NYTimesAPIClient {
    
    // Singleton design pattern
    private init() {}
    static let manager = NYTimesAPIClient()
    
    // My nytimes api key
    private let apiKey = "9e0a813f072146d68eb4f84b6389d9e3"
    
    // Function that takes in a completion handler and an error handler.
    // The completion handler turns data into an array of BestSellerCategory objects with Codable
    func getBestSellerCategories(completionHandler: @escaping ([BestSellerCategory]) -> Void,
                                 errorHandler: @escaping (Error) -> Void) {
        
        let bestSellerEndpoint = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(apiKey)"
        
        guard let url = URL(string: bestSellerEndpoint) else { errorHandler(AppError.badUrl); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            do {
                let json = try JSONDecoder().decode(NYTBestSellerCategories.self, from: data)
                completionHandler(json.results)
            } catch let error {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
    
    // Function that takes in a category, a completion handler, and an error handler.
    // The completion handler turns data into an array of BestSellerBook objects with Codable
    func getBestSellerBooks(from category: String,
                            completionHandler: @escaping ([BestSellerBook]) -> Void,
                            errorHandler: @escaping (Error) -> Void) {
        
        let bestSellerBooksEndpoint = "https://api.nytimes.com/svc/books/v3/lists.json?list=\(category)&api-key=\(apiKey)"
        
        guard let url = URL(string: bestSellerBooksEndpoint) else { errorHandler(AppError.badUrl); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            do {
                let json = try JSONDecoder().decode(BestSellerBooks.self, from: data)
                completionHandler(json.results)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
    
    
}
