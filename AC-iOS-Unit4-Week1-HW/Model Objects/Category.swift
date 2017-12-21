//
//  Categories.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

/// API ENDPOINT #1 - NYT CATEGORIES WITH NYT API KEY
/// Generic URL: https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=99f973e47a244b3a8ee6b95a632550ae

struct CategoryWrapper: Codable {
    let results: [Category]
}

struct Category: Codable {
    let listName: String
    let displayName: String // use this one for display
    let listNameEncoded: String
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
    }
}
