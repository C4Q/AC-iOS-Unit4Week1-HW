//
//  BestSellers.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct BestSellerInfo: Codable{
    let results: [BestSeller]
}

struct BestSeller: Codable {
    let numberOfWeeks: Int
    let isbns: [ISBN]
    let bookDetail: [BookDetail]
    enum CodingKeys: String, CodingKey {
        case numberOfWeeks = "weeks_on_list"
        case isbns
        case bookDetail = "book_details"
    }
}

    struct BookDetail: Codable{
        let bestSellerDescription: String
    
        enum CodingKeys: String, CodingKey {
            case bestSellerDescription = "description"
        }
    }
    
    struct ISBN: Codable{
        let isbn13: String
        let isbn10: String
    }

