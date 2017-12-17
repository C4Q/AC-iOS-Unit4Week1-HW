//
//  NetworkHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

// This is what goes to the internet. URLSession is what allows the internet connection. Next, you run a function that goes to get the data by making a request and and running two closures that will either take in that data and do something with it, either by giving an error ot taking in data
struct NetworkHelper{
    private init(){}
    static let manager = NetworkHelper()
    let session = URLSession(configuration: .default)
    
    //func getData
    func performDataTask(with request: URLRequest,
                         completionHandler: @escaping (Data) -> Void,
                         errorHandler: @escaping(Error) -> Void){
        
        //Once you get data, make sure it is data. If not, give an appropriate error.
        //Make sure to throw back on Main Queue because the elements might be interacting with UI elements
        let myDataTask = session.dataTask(with: request){(data, response, error) in
            
            DispatchQueue.main.async {
                guard let data = data else {errorHandler(AppError.noData); return}
                if let error = error as? URLError {
                    switch error{
                    case URLError.notConnectedToInternet:
                        errorHandler(AppError.noInternetConnection)
                        return
                    default:
                        errorHandler(AppError.urlError(rawError: error))
                    }
                } else {
                    if let error = error{
                        errorHandler(AppError.otherError(rawError: error))
                    }
                }
                //optional for printing data
                if let dataStr = String(data: data, encoding: .utf8){
                    print(dataStr)
                }
                completionHandler(data)//elements being put back on Main Queue
            }
        }
        myDataTask.resume()//start on backthread
    }
}

