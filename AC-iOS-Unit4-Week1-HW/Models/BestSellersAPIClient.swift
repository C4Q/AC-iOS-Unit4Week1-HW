//
//  BestSellersAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellersAPIClient {
    private init() {}
    static let manager = BestSellersAPIClient()
    func getBestSellers(from url: URL,
                       completionHandler: @escaping ([BestSellers]) -> Void,
                       errorHandler: @escaping (AppError) -> Void) {
        
        
        
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let bestSellersInfo = try JSONDecoder().decode(BestSellerInfo.self, from: data)
                completionHandler(bestSellersInfo.results)
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
