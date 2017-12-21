//
//  NYTModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//Endpoint 1: Categories
//https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(key)

//Endpoint 2: Best Sellers for a category
//https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(key)&list=\(hyphen-separated-list-name)
//For Example - "https://api.nytimes.com/svc/books/v3/lists.json?api-key=ac1cde81fb2147a59b8fc20e10ff70b2&list=Hardcover-Fiction"



//MARK: - Endpoint 1: Books by Category
struct CategoryResultsWrapper: Codable {
    let category: [BookCategories]
    
    enum CodingKeys: String, CodingKey {
        case category = "results"
    }
}

struct BookCategories: Codable {
    let categoryName: String
    let listNameEndpointForAPICall: String
    
    //this is the endpoint to get the bestsellers by category
    var categoryEndpointURL: String {
        //let key = "0c769eb094e94bffa0b35d55b222d489"
        var urlStr = ""
        urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(APIKeys.NYTAPIKey)&list=\(self.listNameEndpointForAPICall)"
        return urlStr
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "list_name"
        case listNameEndpointForAPICall = "list_name_encoded"
    }
}






//MARK: - EndPoint 2: Best Sellers by category
struct BestSellersWrapper: Codable {
    let results: [BestSellers]
}

//already returns sorted!
struct BestSellers: Codable { //BestSellersWrapper
    let displayName: String //Category to filter for NYKeyedArchiver
    let rank: Double
    let rankLastWeek: Double
    let weeksOnList: Double
    let amazonProductUrl: String
    let bookDetails: [BookDetails] //array of details of ONE Book
    
    enum CodingKeys: String, CodingKey{
        case rank
        case displayName = "display_name"
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case amazonProductUrl = "amazon_product_url"
        case bookDetails = "book_details"
    }
}

struct BookDetails: Codable {
    let title: String
    let shortDescription: String
    let author: String
    let primaryISBN13: String
    let primaryISBN10: String
    
        var isbnNumbers: String {
            var urlStrForGoogleCall = ""
            urlStrForGoogleCall = "https://www.googleapis.com/books/v1/volumes?q=+\(primaryISBN13)"
            return urlStrForGoogleCall
        }
    
    enum CodingKeys: String, CodingKey{
        case title
        case shortDescription = "description"
        case author
        case primaryISBN13 = "primary_isbn13"
        case primaryISBN10 = "primary_isbn10"
    }
}
