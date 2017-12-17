//
//  BookDetail-Google.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

/// https://www.googleapis.com/books/v1/volumes?q=flowers+inauthor:keyes&key=AIzaSyB95KwMKwLmYQTorODVmOunlU-CsYnhsA4


struct ResultsWrapper: Codable {
    let items: [BookWrapper]
}

struct BookWrapper: Codable {
    let volumeInfo: BookDetail
}

struct BookDetail: Codable {
    let title: String
    let authors: [String]
    let publisher: String
    let publishedDate: String
    let description: String /// LONG DESCRIPTION
    let industryIdentifiers: [Identifier]
    let pageCount: Int
    let categories: [String]
    let averageRating: Int
    let imageLinks: Image
}

struct Identifier: Codable {
    let type: String
    let identifier: String
}

struct Image: Codable {
    let smallThumbnail: String
    let thumbnail: String
}
