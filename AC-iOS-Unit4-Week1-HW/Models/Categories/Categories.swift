//
//  Categories.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct CategoryWrapper: Codable {
    let results: [Category]
}

struct Category: Codable {
    let listName: String
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
    }
}
