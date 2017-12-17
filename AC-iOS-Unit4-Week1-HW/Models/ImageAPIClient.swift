//
//  ImageAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

// it's going to the enpoint and returning the url in the type it was set (usually as a string). It grabs that url and brings it back to try and convert it into an UIImage thru UIKit. If the url is good, try and convery that url into an UIIMage
class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    
    func loadImage(from urlStr: String,
                   completionHandler: @escaping (UIImage) -> Void,
                   errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {errorHandler(AppError.badURL(url: urlStr)); return}
        let completion = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {errorHandler(AppError.invalidImage); return}
            completionHandler(onlineImage)// go ahead and turn the data into the online image
        }
        NetworkHelper.manager.performDataTask(with: URLRequest(url: url),
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

