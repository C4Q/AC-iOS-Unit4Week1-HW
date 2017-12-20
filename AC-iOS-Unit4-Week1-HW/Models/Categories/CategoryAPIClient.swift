//
//  CategoryAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class CategoryAPIClient {
    private init() {}
    static let manager = CategoryAPIClient()
    private let apiKey = "f17a6f246cf34666b4ccbf18bcb00469"
    func getCategories(completionHandler: @escaping ([Category]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlString = "https://api.nytimes.com/svc/books/v3/lists/names.json?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                do {
                    let categories = try JSONDecoder().decode(CategoryWrapper.self, from: data)
                    completionHandler(categories.results)
                } catch let error {
                    errorHandler(AppError.cannotParseJSON(rawError: error))
                }
        },
            errorHandler: errorHandler)
    }
}
