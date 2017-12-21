//
//  BookPreview.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

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
    let industryIdentifiers: [ISBNS]
}

struct ImageLinks: Codable {
    let smallThumbnail: String?
    let thumbnail: String?
}

struct ISBNS: Codable {
    let type: String
    let identifier: String
}
