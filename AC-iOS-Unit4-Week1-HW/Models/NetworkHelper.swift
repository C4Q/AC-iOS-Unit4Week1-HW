//
//  NetworkHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

enum AppError: Error {
    case noData
    case badUrl
    case noInternet
    case codingError(rawError: Error)
    case urlError(rawError: Error)
    case otherError(rawError: Error)
}

struct NetworkHelper {
    
    private init() {}
    static let manager = NetworkHelper()
    
    let session = URLSession(configuration: .default)
    
    func performDataTask(with request: URLRequest,
                         completionHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (Error) -> Void) {
        
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else { errorHandler(AppError.noData); return }
                if let error = error as? URLError {
                    switch error {
                    case URLError.notConnectedToInternet: errorHandler(AppError.noInternet); return
                    default: errorHandler(AppError.urlError(rawError: error))
                    }
                } else {
                    if let error = error {
                        errorHandler(AppError.otherError(rawError: error))
                    }
                }
                completionHandler(data)
            }
        }
        dataTask.resume()
    }
}
