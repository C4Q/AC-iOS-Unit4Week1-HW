//
//  NYTCategoriesAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

// calling your APIendpoint and returning an array of whatever you are looking for...THATS IT!
class NYTCatogriesAPICleint {
    private init(){}
    static let manager = NYTCatogriesAPICleint()
    //Endpoint to get the book categories
    private let urlStr = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=0c769eb094e94bffa0b35d55b222d489"
    
    func getCategories(from urlStr: String,
                       completionHandler: @escaping ([BookCategories]) -> Void,
                       errorHandler: @escaping (Error) -> Void){
        
        //make sure you have a url
//        let fullUrlStr = urlStr + formattedSearchTerm
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(url: urlStr)); return}
        
        let request = URLRequest(url: url)
        
        let parseDataIntoCategories: (Data) -> Void = {(data) in
            do{
                let results = try JSONDecoder().decode(CategoryResultsWrapper.self, from: data)
                let bookCategory = results.category
                completionHandler(bookCategory)
            }catch{
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoCategories,
                                              errorHandler: errorHandler)
    }
}

