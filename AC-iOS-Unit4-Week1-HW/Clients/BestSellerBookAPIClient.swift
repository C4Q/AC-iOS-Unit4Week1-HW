//
//  BestSellerBookAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellerBookAPIClient {
    private init(){}
    static let shared = BestSellerBookAPIClient()
    func getCategories(completionHandler: @escaping ([Category]) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        let myCategoryAPIKey = "99f973e47a244b3a8ee6b95a632550ae"
        let categori = "Hardcover-Fiction" /// nah
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(myCategoryAPIKey)&list=\(category)"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr)); return
        }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let response = try JSONDecoder().decode(CategoryWrapper.self, from: data)
                completionHandler(response.results)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
