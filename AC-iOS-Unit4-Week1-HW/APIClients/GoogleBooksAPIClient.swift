//
//  GoogleBooksAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


class GoogleBooksInfoAPIClient{
    private init (){}
    static let manager = GoogleBooksInfoAPIClient()
    
    func getBookImages(from primaryISBN13: String,
                       completionHandler: @escaping ([GoogleBooks]) -> Void,
                       errorHandler: @escaping (Error) -> Void){
        
        //Endpoint to get the books by isbn
        let ISBNEndPointToCall = "https://www.googleapis.com/books/v1/volumes?q=+\(primaryISBN13)"
        
        guard let url = URL(string: ISBNEndPointToCall) else {errorHandler(AppError.badURL(url: primaryISBN13)); return}
        
        let request = URLRequest(url: url)
        
        let parseDataIntoGoogleBookInfo: (Data) -> Void = {(data) in
            do{
                let decodedBookInfo = try JSONDecoder().decode(GoogleBooksWrapper.self, from: data)
                let googleBookInfo = decodedBookInfo.items //accessing the [GoogleBooks] one lever down
                completionHandler(googleBookInfo)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoGoogleBookInfo,
                                              errorHandler: errorHandler)
    }
}
