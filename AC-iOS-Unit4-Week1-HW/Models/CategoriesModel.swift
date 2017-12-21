//
//  BooksModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct Categoriesinfo: Codable {
    let results: [AllCategories]
}

struct AllCategories: Codable {
    let categoryName: String
    let key: String
    enum CodingKeys: String, CodingKey {
        case key = "list_name_encoded"
        case categoryName = "display_name"
    }
}


