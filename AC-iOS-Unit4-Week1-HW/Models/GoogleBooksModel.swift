//
//  GoogleBooksModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct googleBookResults: Codable {
    let items: [BooksInfo]?
}

struct BooksInfo: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let subtitle: String?
    let description: String?
    let imageLinks: ImageLink?
    let title: String
    let industryIdentifiers: [BookIdentifiers]?
}

struct ImageLink: Codable {
    let thumbnail: String
}

struct BookIdentifiers: Codable {
    let identifier: String
}
