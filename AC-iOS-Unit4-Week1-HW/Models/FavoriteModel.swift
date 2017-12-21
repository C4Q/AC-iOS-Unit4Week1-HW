//
//  FavoriteModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation
import UIKit

struct Favorite: Codable {
let subtitle: String?
let description: String
let identifier: String

    // computed property to return image from documents
//    var image: UIImage? {
//        set{}
//        get {
//            let imageURL = PersistentStoreManager.manager.dataFilePath(withPathName: "\(title)")
//            let docImage = UIImage(contentsOfFile: imageURL.path)
//            return docImage
//        }
//    }

}



