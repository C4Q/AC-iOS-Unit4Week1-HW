//
//  ImageFetchHelper.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct ImageFetchHelper {
    private init() {}
    static let manager = ImageFetchHelper()
    
    func getImage(from urlStr: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else { return }
        let completion: (Data) -> Void = { (data: Data) in
            guard let onlineImage = UIImage(data: data) else { return }
            completionHandler(onlineImage)
        }
        let request = URLRequest(url: url)
        NetworkHelper.manager.performDataTask(with: request, completionHandler: completion, errorHandler: errorHandler)
    }
}
