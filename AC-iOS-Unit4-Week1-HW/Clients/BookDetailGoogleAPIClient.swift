//
//  BookDetailGoogleAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BookDetailGoogleAPIClient {
    private init(){}
    static let shared = BookDetailGoogleAPIClient()
    func getGoogleBooks(isbn: String,
                       completionHandler: @escaping ([BookWrapper]) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        let urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)"
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr)); return
        }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let response = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                completionHandler(response.items)
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
