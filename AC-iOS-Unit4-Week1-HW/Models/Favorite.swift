//
//  Favorite.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

struct Favorite: Codable {
    let title: String
    let subtitle: String?
    let description: String
    let imagelinks: imageWrapper?
    

    
    var image: UIImage? {
        set{}
        get {
            let imageURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(title)")
            let docImage = UIImage(contentsOfFile: imageURL.path)
            return docImage
        }
    }
}



