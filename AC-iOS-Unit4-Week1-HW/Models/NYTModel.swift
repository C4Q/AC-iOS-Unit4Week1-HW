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
//(e.g Hardcover-Fiction)
//For Example - "https://api.nytimes.com/svc/books/v3/lists.json?api-key=ac1cde81fb2147a59b8fc20e10ff70b2&list=Hardcover-Fiction"



//MARK: - Endpoint 1: Books by Category
struct CategoryResultsWrapper: Codable {
    let category: [BookCategories]
}

struct BookCategories: Codable {
    let categoryName: String
    
    let listNameForInterpolationInAPICall: String
    
    var endpointURL: String {
        let key = "0c769eb094e94bffa0b35d55b222d489"
        var urlStr = ""
        urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(key)&list=\(self.listNameForInterpolationInAPICall)"
        return urlStr
    }
    
    enum CodingKeys: String, CodingKey {
        case categoryName = "list_name"
        case listNameForInterpolationInAPICall = "list_name_encoded"
    }
}

//MARK: - EndPoint 2: Best Sellers by category
struct BestSellersWrpper: Codable {
    let results: [BestSellers]
}

//already returns sorted
struct BestSellers: Codable { //BestSellersWrapper
    let displayName: String //Category to filter for NYKeyedArchiver
    let rank: Double
    let rankLastWeek: Double
    let weeksOnList: Double
    let amazonProductUrl: String
    let bookDetails: BookDetailsWrapper //[BookDetails]
    
    enum CodingKeys: String, CodingKey{
        case rank
        case displayName = "display_name"
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case amazonProductUrl = "amazon_product_url"
        case bookDetails = "book_details"
    }
}

struct BookDetailsWrapper: Codable {
    let title: String
    let shortDescription: String
    let author: String
    let primaryISBN13: String
    let primaryISBN10: String

    enum CodingKeys: String, CodingKey{
        case title
        case shortDescription = "description"
        case author
        case primaryISBN13 = "primary_isbn13"
        case primaryISBN10 = "primary_isbn10"
    }
}
















