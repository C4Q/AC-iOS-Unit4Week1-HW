//
//  AppError.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

enum HTTPVerb: String {
    case GET //Read
    case POST //Create
    case DELETE //Delete
    case PUT //Update/Replace
    case PATCH //Update/Modify
}

//AppError for Errorhandling
enum AppError: Error {
    case badData
    case badURL
    case unauthenticated
    case codingError(rawError: Error)
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case noInternetConnection
    case badStatusCode
    case noDataReceived
    case notAnImage
    case other(rawError: Error)
}
