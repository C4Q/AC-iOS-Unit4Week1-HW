//
//  Book.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct AllBooks: Codable {
    let results: [Book]?
    let items: [Book]?
}

struct Book: Codable {
    let listName: String?
    let displayName: String?
    let rankLastWeek: Int?
    let bookDetails: [BookDetail]?
    let volumeInfo: VolumeInfo?
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case rankLastWeek = "rank_last_week"
        case bookDetails = "book_details"
        case volumeInfo
    }
}

//struct ISBN: Codable {
//    let isbn10: String
//    let isbn13: String
//}

struct BookDetail: Codable {
    let title: String
    let description: String
    let contributor: String
    let author: String
    let primaryISBN13: String
    let primaryISBN10: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case contributor
        case author
        case primaryISBN13 = "primary_isbn13"
        case primaryISBN10 = "primary_isbn10"
    }
}

struct VolumeInfo: Codable {
    let title: String
    let subtitle: String?
    let description: String?
    let authors: [String]
    let imageLinks: ImageLink?
}

struct ImageLink: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

