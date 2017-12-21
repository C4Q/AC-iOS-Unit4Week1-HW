//
//  Categories.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/18/17.
//  Copyright © 2017 Tyler Zhao. All rights reserved.
//

import Foundation

struct CategoriesAPIClient {
    private init() {}
    static let manager = CategoriesAPIClient()
    let key = "9001fc4817314380b77393a05f655409"
    let url = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=9001fc4817314380b77393a05f655409"
    func getCategories(from urlStr: String,
                  completionHandler: @escaping ([Categories]) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoThing: (Data) -> Void = {(data) in
            do {
                let categories = try JSONDecoder().decode(NYTBookCategories.self, from: data)
                let names = categories.results //use if JSON has arr of dict sub-tier
                completionHandler(names)
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
