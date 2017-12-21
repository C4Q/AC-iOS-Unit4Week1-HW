//
//  BookDetail-Google.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

/// API ENDPOINT #3 - GOOGLE BOOKS WITH ISBN INPUT AND GOOGLE API KEY
/// Generic URL: https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)&key=AIzaSyB0MSiQ37Z90T23RfL19PQi7YVYoZ4Tnvk
/// Sample URL: https://www.googleapis.com/books/v1/volumes?q=isbn:0385514239&key=AIzaSyB0MSiQ37Z90T23RfL19PQi7YVYoZ4Tnvk

struct ResultsWrapper: Codable {
    let items: [BookWrapper]
}

struct BookWrapper: Codable {
    let volumeInfo: BookDetail
}

struct BookDetail: Codable {
    let title: String
    let subtitle: String?
    let authors: [String]
    let publisher: String?
    let publishedDate: String
    let description: String /// LONG DESCRIPTION
    let industryIdentifiers: [Identifier]
    let pageCount: Int
    let categories: [String]
    let averageRating: Int?
    let imageLinks: Image
}

struct Identifier: Codable {
    let type: String? // type of ISBN
    let identifier: String // actual ISBN code
}

struct Image: Codable {
    let smallThumbnail: String
    let thumbnail: String
}
