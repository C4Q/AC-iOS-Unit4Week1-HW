//
//  BookDetail.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation



struct BookResults: Codable{
    let items: [BookInfo]
}

struct BookInfo: Codable{
    let volumeInfo: Book
}

struct Book: Codable {
    let title: String
    let subtitle: String?
    let description: String
    let imageLinks: imageWrapper?
}

struct imageWrapper: Codable{
    let thumbnail: String
    let smallThumbnail: String
}
