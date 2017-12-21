//
//  BookDetailAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BookDetailAPIClient {
    private init() {}
    static let manager = BookDetailAPIClient()
    func getBookDetail(from url: URL,
                       completionHandler: @escaping ([BooksInfo]) -> Void,
                       errorHandler: @escaping (AppError) -> Void) {
        
        
        
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bookDetailInfo = try JSONDecoder().decode(googleBookResults.self, from: data)
                completionHandler(bookDetailInfo.items)
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
    
}
