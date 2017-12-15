//
//  NYTimesModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//Endpoint 1: Categories

//https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(key)
//Endpoint 2: Best Sellers for a category
    
//https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(key)&list=\(hyphen-separated-list-name)
//(e.g Hardcover-Fiction)
//For Example - "https://api.nytimes.com/svc/books/v3/lists.json?api-key=ac1cde81fb2147a59b8fc20e10ff70b2&list=Hardcover-Fiction"
//var apikey = "ac1cde81fb2147a59b8fc20e10ff70b2"

struct CategoriesWrapper: Codable {
    var results: [Categories]
}

struct Categories: Codable {
    var listName: String
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
    }
}
//Results RETURN sorted :)
struct BestSellersWrapper: Codable {
    var results: [BestSellers]
}

struct BestSellers: Codable {
    var rank: Int
    var weeksOnList: Int
    //var isbns: [ISBNWrapper]
    var bookDetails: [BookDetails]
    
    enum CodingKeys: String, CodingKey {
        case rank = "rank"
        case weeksOnList = "weeksOnList"
        //case isbns = "isbns"
        case bookDetails = "book_details"
    }
}

//struct ISBNWrapper: Codable {
//    //This returns an array of ISBN's. Use the first index of the array - it is the isbn10 number
//    var isbn10: String
//}

struct BookDetails: Codable {
    var title: String
    var description: String
    var author: String
    var primaryISBN: String
    
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case author = "author"
        case primaryISBN = "primary_isbn10"
    }
}











