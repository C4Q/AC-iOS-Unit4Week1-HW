//
//  ImageAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL(str: "bad url"))
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(AppError.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: url, completionHandler: completion, errorHandler: {print($0)})
    }
}
