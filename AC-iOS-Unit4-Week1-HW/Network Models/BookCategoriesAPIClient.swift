//
//  BookAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//EndPoint #1
struct BookCategories: Codable {
    let results: [Categories]
}

struct Categories: Codable {
    let genre: String
    let genreWithDashes: String
    
    enum CodingKeys: String, CodingKey {
        case genre = "display_name"
        case genreWithDashes = "list_name_encoded"
    }
}

struct BookCategoriesAPIClient { //deals with the specific structure we're working with
    private init() {}
    static let manager = BookCategoriesAPIClient()
    static let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=745b163551dc4d689f281bd639659128"
    func getCategories(with urlStr: String,
                  completionHandler: @escaping ([Categories]) -> Void,
                  errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bookCategorylist = try JSONDecoder().decode(Categories.self, from: data)
                completionHandler([bookCategorylist])
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}
