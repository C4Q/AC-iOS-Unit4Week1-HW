//
//  Favorites.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class Favorites: Codable {
    let imageUrl: String
    let title: String
    let description: String
    init(title: String, description: String, imageUrl: String) {
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
    }
}
