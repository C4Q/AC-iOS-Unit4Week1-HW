//
//  ImageHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit


enum ImageError: Error {
    case badUrl
    case badData
}

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage?) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            completionHandler(nil)
            errorHandler(ImageError.badUrl)
            return
        }
        let completion = {(data: Data) in
            let onlineImage = UIImage(data: data) ?? nil
            completionHandler(onlineImage)
        }
        let request = URLRequest(url: url)
        NetworkHelper.manager.performDataTask(with: request,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

