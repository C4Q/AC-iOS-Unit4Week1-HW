//
//  BookAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct BestSellerAPIClient{
    private init() {}
    static let manager = BestSellerAPIClient()
    func getBestSellers(from urlStr: String, completionHandler: @escaping ([BestSeller]) -> Void, errorHandler: @escaping (AppError) -> Void){
        
        
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                let myDecoder = JSONDecoder()
                
                let bestSellerInfo = try myDecoder.decode(BestSellerInfo.self, from: data)
                completionHandler(bestSellerInfo.results)
                
            } catch{
                print("Category Has This Error: " + error.localizedDescription)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
