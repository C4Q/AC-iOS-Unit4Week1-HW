//
//  nytAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct ResultsWrapper: Codable {
    let results: [Categories]
}

struct Categories: Codable {
    let displayName: String
    let encodedListName: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case encodedListName = "list_name_encoded"
    }
}

struct NYTCategoriesAPIClient {
    private init () {}
    static let manager = NYTCategoriesAPIClient()
    
    private let apiKey = "6b755fc9d2e742dd9026486a459655f3"
    
    func getCategories(completionHandler: @escaping ([Categories]) -> Void, errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(apiKey)"
        guard let url = URL(string: urlStr) else { errorHandler(AppError.badURL); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { (data: Data) in
            do {
                let categoryList = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                completionHandler(categoryList.results)
            } catch {
                print(errorHandler(AppError.couldNotParseJSON(rawError: error)))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
