//
//  BestSeller.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellerWrapper: Codable {
    let results: [BestSeller]
}

struct BestSeller: Codable {
    let weeksOnList: Int
    let bookDetails: [BookDetails]
    
    enum CodingKeys: String, CodingKey {
        case weeksOnList = "weeks_on_list"
        case bookDetails = "book_details"
    }
}

//to do - make either BestSeller or GoogleBook conform to Equatable so you can sort and make favorites

struct BookDetails: Codable {
    let description: String?
    let isbn10: String
    let isbn13: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case isbn10 = "primary_isbn10"
        case isbn13 = "primary_isbn13"
    }
}
