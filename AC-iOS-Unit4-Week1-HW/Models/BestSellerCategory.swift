//
//  BestSellerCategory.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct NYTBestSellerCategories: Codable {
    var results: [BestSellerCategory]
}

struct BestSellerCategory: Codable {
    var displayName: String
    var listNameEncoded: String
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded"
    }
    
}

