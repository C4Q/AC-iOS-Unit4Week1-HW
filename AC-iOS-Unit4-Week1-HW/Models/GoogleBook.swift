//
//  GoogleBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct BooksData: Codable {
    let items: [GoogleBook]
}

struct GoogleBook: Codable {
    let volumeInfo: VolumeInfo
    let searchInfo: SearchInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let description: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let thumbnail: String
}

struct SearchInfo: Codable {
    let textSnippet: String
}
