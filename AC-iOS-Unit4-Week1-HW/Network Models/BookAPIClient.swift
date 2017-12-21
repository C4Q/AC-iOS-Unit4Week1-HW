//
//  BookDetailAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation




struct BookAPIClient{
    private init() {}
    static let manager = BookAPIClient()
    func getGoogleBook(from urlStr: String, completionHandler: @escaping ([BookInfo]) -> Void, errorHandler: @escaping (AppError) -> Void){
        
        
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                let myDecoder = JSONDecoder()
                
                let bookInfo = try myDecoder.decode(BookResults.self, from: data)
                completionHandler(bookInfo.items)
                
            } catch{
                print(error)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
