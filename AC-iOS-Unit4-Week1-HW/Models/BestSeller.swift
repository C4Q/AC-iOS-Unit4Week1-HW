//
//  BestSeller.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BestSeller: Codable {
    let results: [Book]
}

struct Book: Codable {
    let display_name: String
    let weeks_on_list: Int?
    let book_details: [BriefSummary]
}

struct BriefSummary: Codable {
    let title: String
    let description: String?
    let primary_isbn13: String
}
