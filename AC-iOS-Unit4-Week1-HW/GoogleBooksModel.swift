//
//  GoogleBooksModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//Endpoint "https://www.googleapis.com/books/v1/volumes?q=+isbn:0385514239"
//https://www.googleapis.com/books/v1/volumes?q=+isbn:0385514239
//key=API_KEY
//var apikey = "AIzaSyAA1l0upCWnuzbWRdfeltaIpGXuSDKV1Q4"


struct GoogleBooksWrapper: Codable {
    var items: [GoogleBooks]
}

struct GoogleBooks: Codable  {
    var volumeInfo: [BookInfo]
}

struct BookInfo: Codable {
    var title: String
    var subtitle: String?
    var authors: [String]
    var description: String //This is the summary
    var imageLinks: ImageWrapper
    var allAuthors: String {
        var authorString = ""
        for authors in authors {
            authorString.append(authors)
        }
        return authorString
    }
}

struct ImageWrapper: Codable {
    var smallThumbnail: String
    var thumbnail: String
}


