//
//  BookPreview.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//The cover
//The subtitle (if applicable)
//A long description

struct BookPreview: Codable {
    let items: [Volume]?
}

struct Volume: Codable {
    let volumeInfo: BookDetails
}

struct BookDetails: Codable {
    let title: String
    let subtitle: String?
    let description: String?
    let imageLinks: ImageLinks?
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

class ExpandedBookDetails {
    private init() {}
    static let manager = ExpandedBookDetails()
    static private var bookDetails: [Volume]? = []
    static func setExpandedBookDetails(from array: [Volume]?) {
        self.bookDetails = array
    }
    static func getsetExpandedBookDetails() -> [Volume]? {
        return bookDetails
    }
}
