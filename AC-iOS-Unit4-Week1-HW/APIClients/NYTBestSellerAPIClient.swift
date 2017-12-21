//
//  NYTBestSellerAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class NYTBestSellersAPIClient{
    private init(){}
    static let manager = NYTBestSellersAPIClient()
    
    func getBestSellerISBN(from urlStr: String,
                           completionHandler: @escaping ([BestSellers]) -> Void,
                           errorHandler: @escaping (Error) -> Void){
        //Endpoint to get the book categories
        let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=0c769eb094e94bffa0b35d55b222d489"
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(url: urlStr)); return}

        let request = URLRequest(url: url)
        
        let parseDataIntoISBN: (Data) -> Void = {(data) in
            do{
                let bestSellerBooks = try JSONDecoder().decode([BestSellers].self, from: data)
                let bestSellers = bestSellerBooks
                completionHandler(bestSellers)
                
                for book in bestSellerBooks{
                    print(book.amazonProductUrl, book.rank, book.displayName)
                }
            }catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoISBN,
                                              errorHandler: errorHandler)
    }
}
