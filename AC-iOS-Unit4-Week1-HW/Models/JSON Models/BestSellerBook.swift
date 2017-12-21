//
//  BestSellerBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellerBooks: Codable {
    
    let results: [BestSellerBook]
    
}

struct BestSellerBook: Codable {
    let displayName: String
    let weeksOnList: Int
    let bookDetails: [BookDetails]
    
    enum CodingKeys: String, CodingKey {
        case displayName = "display_name"
        case weeksOnList = "weeks_on_list"
        case bookDetails = "book_details"
    }
    
}

struct BookDetails: Codable {
    
    let title: String
    let description: String
    let contributor: String
    let author: String
    let publisher: String
    let isbn13: String
    let isbn10: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case contributor
        case author
        case publisher
        case isbn13 = "primary_isbn13"
        case isbn10 = "primary_isbn10"
    }
    
}
