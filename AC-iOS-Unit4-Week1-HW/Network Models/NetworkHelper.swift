//
//  NetworkHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
//my api key: 745b163551dc4d689f281bd639659128 ***

//NetworkHelper - turns URL into Data
struct NetworkHelper {
    //Singleton
    private init(){}
    static let manager = NetworkHelper()
    
    //Create an instance of a URLSession
    private let session = URLSession(configuration: .default)
    
    //use URLRequest to get Data
    func performDataTask(with url: URL,
                         completionHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping (AppError) -> Void) {
        let task = session.dataTask(with: url) {(data, response, error) in
            DispatchQueue.main.async {
                guard let data = data else {errorHandler(AppError.badData); return}
                if let error = error {
                    errorHandler(AppError.other(rawError: error))
                }
                completionHandler(data)
            }
        }
        task.resume()
    }
}

