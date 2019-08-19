//
//  CacheData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class ImageCache {
    private init() {}
    static let manager = ImageCache()
    private let sharedCache = NSCache<NSString, UIImage>()
    
    //only used if image does not exist in cache, then stores it in cache
    func processImageInBackground(withURL imageUrl: String, completionHandler: @escaping (UIImage) -> Void, errorHandler: @escaping (Error) -> Void) {
       ImageAPIClient.manager.getImage(
        from: imageUrl,
        completionHandler: { (onlineImage) in
            self.sharedCache.setObject(onlineImage, forKey: imageUrl as NSString)
            completionHandler(onlineImage)
       },
        errorHandler: errorHandler)
    }
    
    //retrieving image from cache
    func getImageFromCache(withURL imageUrl: String) -> UIImage? {
        guard let cachedImage = sharedCache.object(forKey: imageUrl as NSString) else {
            return nil
        }
        
        return cachedImage
    }
}
