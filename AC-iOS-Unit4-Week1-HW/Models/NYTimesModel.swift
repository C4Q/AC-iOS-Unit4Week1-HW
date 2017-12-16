//
//  NYTimesModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Richard Crichlow on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//Endpoint 1: Categories
var key = "ac1cde81fb2147a59b8fc20e10ff70b2"
var categoriesEndpoint = "https://api.nytimes.com/svc/books/v3/lists/names.json?api-key=\(key)"

//Endpoint 2: Best Sellers for a category

//https://api.nytimes.com/svc/books/v3/lists.json?api-key=\(key)&list=\(hyphen-separated-list-name)
//(e.g Hardcover-Fiction)
//For Example - "https://api.nytimes.com/svc/books/v3/lists.json?api-key=ac1cde81fb2147a59b8fc20e10ff70b2&list=Hardcover-Fiction"

struct CategoriesWrapper: Codable {
    var results: [Categories]
}

struct Categories: Codable {
    var listName: String?
    var displayName: String?
    var listNameEncoded: String?
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case displayName = "display_name"
        case listNameEncoded = "list_name_encoded" //Use for BestSeller Call
    }
}
//Results RETURN sorted :)
struct BestSellersWrapper: Codable {
    var results: [BestSellers]
}

struct BestSellers: Codable {
    var listName: String?
    var rank: Int
    var weeksOnList: Int
    //var isbns: [ISBNWrapper]
    var bookDetails: [BookDetails]
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name" //TODO: Category to filter by for the KeyedArchiver Function
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

//APIClients go here
struct CategoriesAPIClient {
    private init() {}
    static let manager = CategoriesAPIClient()
    private let urlStr = categoriesEndpoint
    func getCategories(
                  completionHandler: @escaping ([Categories]) -> Void,
                  errorHandler: @escaping (Error) -> Void) {

        let fullUrlStr = urlStr
        guard let url = URL(string: fullUrlStr) else {
            errorHandler(AppError.badURL(str: fullUrlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(CategoriesWrapper.self, from: data)
                let categoriesArray = results.results
                completionHandler(categoriesArray)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCards, errorHandler: errorHandler)
    }
}
/*
//APIClients go here
struct CategoriesAPIClient {
    private init() {}
    static let manager = CategoriesAPIClient()
    private let urlStr = categoriesEndpoint
    func getCategories(matching searchTerm: String,
                       completionHandler: @escaping ([Card]) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        guard let formattedSearchTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else {
            errorHandler(AppError.badURL(str: searchTerm))
            return
        }
        let fullUrlStr = urlStr + formattedSearchTerm
        guard let url = URL(string: fullUrlStr) else {
            errorHandler(AppError.badURL(str: fullUrlStr))
            return
        }
        let request = URLRequest(url: url)
        let parseDataIntoCards: (Data) -> Void = {(data) in
            do {
                let results = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                let cards = results.cards
                completionHandler(cards)
            }
            catch {
                errorHandler(AppError.codingError(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: request, completionHandler: parseDataIntoCards, errorHandler: errorHandler)
    }
}
*/





