//
//  Alert.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class Alert {
    static func createAlert(forError error: Error) -> UIAlertController {
        let message: String
        
        switch error as! AppError {
        case .badImageData:
            message = "Bad data used for image."
        case .badImageURL(let imageUrl):
            message = "Bad Image URL:\n\(imageUrl)"
        case .badResponseCode(let code):
            message = "Bad Response Code:\n\(code)"
        case .badURL(let url):
            message = "Bad URL:\n\(url)"
        case .cannotParseJSON(let rawError):
            message = "Cannot Parse JSON:\n\(rawError)"
        case .noInternet:
            message = "No Internet Connection."
        case .other(let rawError):
            message = "\(rawError)"
        }
        
        let alertController = UIAlertController(title: "ERROR", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        return alertController
    }
}
