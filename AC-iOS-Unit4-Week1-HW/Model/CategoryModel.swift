//
//  CategoryModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CategoryAPIClient {
    private init() {}
    static let manager = CategoryAPIClient()
    
    var endpointForCategoryList: String {
        var endpoint = URLComponents(string: "https://api.nytimes.com/svc/books/v3/lists/names.json?")
        endpoint?.queryItems = [
            URLQueryItem(name: "api-key", value: "8e7c1c0a260344af8ea99339ed2f16f4")
        ]
        return endpoint?.url?.absoluteString ?? ""
    }
    
    func endpointForBooksFromCategory(_ category: Category) -> String {
        let categoryName = category.listName
        let categoryWithHyphens = categoryName.replacingOccurrences(of: " ", with: "-")
        
        var endpoint = URLComponents(string: "https://api.nytimes.com/svc/books/v3/lists.json")
        endpoint?.queryItems = [
            URLQueryItem(name: "api-key", value: "8e7c1c0a260344af8ea99339ed2f16f4"),
            URLQueryItem(name: "list", value: categoryWithHyphens)
        ]
        
        return endpoint?.url?.absoluteString ?? ""
    }
    
    func getCategories(from urlStr: String, completionHandler: @escaping (CategoryResult) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let categories = try JSONDecoder().decode(CategoryResult.self, from: data)
                completionHandler(categories)
            }
            catch {
                print(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
}

struct CategoryResult: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let results: [Category]
}

struct Category: Codable {
    let listName: String
    let displayName: String
    let listNameEncoded: String
    let oldestPublishedDate: String
    let newestPublishedDate: String
    let updated: String
}

extension CategoryResult {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case numResults = "num_results"
        case results = "results"
    }
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
        case oldestPublishedDate = "oldest_published_date"
        case newestPublishedDate = "newest_published_date"
        case updated = "updated"
    }
}

