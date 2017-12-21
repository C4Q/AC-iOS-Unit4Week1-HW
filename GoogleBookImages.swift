//
//  GoogleBookImages.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct GoogleBookImages: Codable {
    let items: [Items]?
}

struct Items: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let imageLinks: ImageLinks?
    let description: String
}

struct ImageLinks: Codable {
    let thumbnail: String
}

struct GoogleBookImagesAPIClient {
    private init(){}
    static let manager = GoogleBookImagesAPIClient()
    func getBestSellers(from urlStr: String,
                        completionHandler: @escaping (Items) -> Void,
                        errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL(str: urlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoThing: (Data) -> Void = {(data) in
            do {
                let allItems = try JSONDecoder().decode(GoogleBookImages.self, from: data)
                if let volumeInfo = allItems.items?.first {
                    completionHandler(volumeInfo)
                } else {
                    errorHandler(AppError.noData)
                    return
                }
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: parseDataIntoThing,
                                              errorHandler: errorHandler)
    }
}


