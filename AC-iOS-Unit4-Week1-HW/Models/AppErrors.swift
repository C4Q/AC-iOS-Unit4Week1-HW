//
//  AppErrors.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

enum AppError: Error {
    case goodStatusCode(num: Int)
    case unauthenticated
    case invalidJSONResponse
    case couldNotParseJSON(rawError: Error)
    case badData
    case noData
    case noInternetConnection
    case badURL(url: String)
    case noDataReceived
    case invalidImage
    case codingError(rawError: Error)
    case badStatusCode(num: Int)
    case urlError(rawError: Error)
    case otherError(rawError: Error)
}

