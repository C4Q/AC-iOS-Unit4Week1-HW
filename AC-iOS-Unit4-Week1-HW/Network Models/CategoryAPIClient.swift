//
//  categoryClientAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CategoryAPIClient{
    private init() {}
    static let manager = CategoryAPIClient()
    func getCategories(from urlStr: String, completionHandler: @escaping ([Categories]) -> Void, errorHandler: @escaping (AppError) -> Void){
        
        
        guard let url = URL(string: urlStr) else{
            errorHandler(.badURL)
            return
        }
        
        let completion: (Data) -> Void = {(data: Data) in
            
            do{
                let myDecoder = JSONDecoder()
                
                let categoryInfo = try myDecoder.decode(CatergoryInfo.self, from: data)
                completionHandler(categoryInfo.results)
                
            } catch{
                print("Category Has This Error: " + error.localizedDescription)
                errorHandler(.couldNotParseJSON)
                
            }
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: errorHandler)
    }
}
