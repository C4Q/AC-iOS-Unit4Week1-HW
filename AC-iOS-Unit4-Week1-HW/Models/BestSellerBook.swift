//
//  BestSellerBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSellerBook: Codable {
    let results: [Book]
}

struct Book: Codable {
    let display_name: String
    let weeks_on_list: Int?
    let isbns: [ISBNS]
    let book_details: [BookDetails]
}

struct ISBNS: Codable {
    let isbn10: String
}

struct BookDetails: Codable {
    let title: String
    let description: String?
}
