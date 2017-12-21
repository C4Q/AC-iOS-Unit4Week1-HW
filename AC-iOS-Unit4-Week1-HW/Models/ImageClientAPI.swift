//
//  ImageClientAPI.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlString: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlString) else {
            errorHandler(AppError.badImageURL(url: urlString))
            return
        }
        
        NetworkHelper.manager.performDataTask(
            with: url,
            completionHandler: { (data) in
                guard let image = UIImage(data: data) else {
                    errorHandler(AppError.badImageData)
                    return
                }
                
                completionHandler(image)
        },
            errorHandler: errorHandler)
    }
}
