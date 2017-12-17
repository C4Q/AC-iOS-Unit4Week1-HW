//
//  GoogleAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//steps for API client
//private init
//static let manager
//private constant with key
//function with completion handler, errorhandler

// build URLRequest:
//set a string to url
//guard let url
//make URL Request
//create completion hander with Data,
// do
//set constant to JSONDecoder().decode
//catch
//errors
//call network helper
//resum


struct GoogleAPIClient {
    private init() {}
    static let manager = GoogleAPIClient()
    private let apiKey = "AIzaSyBrowYMrW7YUKcp6y-oOHObUzLrTWzm5sI"
    func getBookDetails(for isbn: String, completion: @escaping (VolumeInfo) -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        let bookDetailsURL = "https://www.googleapis.com/books/v1/volumes?q=+isbn:\(isbn)&key=\(apiKey)"
        guard let url = URL(string: bookDetailsURL) else { errorHandler(AppError.badURL(str: bookDetailsURL)); return }
        let request = URLRequest(url: url)
        let completion: (Data) -> Void = { ( data: Data) in
            do {
                let json = try JSONDecoder().decode(Volume.self, from: data)
                completion(json.volumeInfo)
            } catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
