//
//  SettingsAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct SettingsAPIClient {
    private init() {}
    static let manager = SettingsAPIClient()
    func getCategories(from url: URL,
                     completionHandler: @escaping ([AllCategories]) -> Void,
                     errorHandler: @escaping (AppError) -> Void) {
       
        
        
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let categoryInfo = try JSONDecoder().decode(Categoriesinfo.self, from: data)
                completionHandler(categoryInfo.results)
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




