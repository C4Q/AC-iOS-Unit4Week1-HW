//
//  NYTimesAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct NYTimesAPIClient {
    private init() {}
    static let manager = NYTimesAPIClient()
    
    private let apiKey = "191d3b557bb948828b1e94cd9516d629"
    func getBestSellerCategories(completion: @escaping ([CategoryResults]) -> Void,
                                 errorHandler: @escaping (Error) -> Void) {
        let bestSellerURL = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(apiKey)"
        // make url
        guard let url = URL(string: bestSellerURL) else { errorHandler(AppError.badURL(str: bestSellerURL)); return }
        //make url request
        let request = URLRequest(url: url)
        // make complete. needs data
        let completion: (Data) -> Void = { ( data: Data) in
            // decode
            do {
                // decode
                // then access .results
                let json = try JSONDecoder().decode(BookCategory.self, from: data)
                
                completion(json.results)
                
            } catch { // for failures. Essentially "let error = error"
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        //then call networkHelper
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
    
    func getBestSellerBooks(for category: String,
                            completion: @escaping ([Book]) -> Void,
                            errorHandler: @escaping (Error) -> Void) {
        let bestSellerBookURL = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=191d3b557bb948828b1e94cd9516d629&list=\(category)"
        guard let url = URL(string: bestSellerBookURL) else { errorHandler(AppError.badURL(str: bestSellerBookURL)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { ( data: Data) in
            do {
                let json = try JSONDecoder().decode(BestSeller.self, from: data)
                completion(json.results)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
