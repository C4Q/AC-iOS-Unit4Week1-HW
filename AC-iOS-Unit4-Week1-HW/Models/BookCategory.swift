//
//  BookCategory.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BookCategory: Codable {
    let results: [CategoryResults]
}

struct CategoryResults: Codable {
    var listNameEncoded: String
    var displayName: String
    
    enum CodingKeys: String, CodingKey {
        case listNameEncoded = "list_name_encoded"
        case displayName = "display_name"
    }
}



