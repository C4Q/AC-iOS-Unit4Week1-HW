//
//  ImageAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/19/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//EndPoint #2
struct BestSellerBookInfo: Codable {
    let results: [ResultsWrapper]
}

struct ResultsWrapper: Codable {
    let bookGenre: String
    let weeksOnBestSellerList: Int
    //let isbns: [IsbnsWrapper]
    let bookDetails: [BookDetailsWrapper]
    
    enum CodingKeys: String, CodingKey {
        case bookGenre = "list_name"
        case weeksOnBestSellerList = "weeks_on_list"
        //case isbns
        case bookDetails = "book_details"
    }
}

//struct IsbnsWrapper: Codable {
//    let isbn10: String
//    let isbn13: String
//}

struct BookDetailsWrapper: Codable {
    let title: String
    let description: String
    let primaryIsbn13: String
    let primaryIsbn10: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case description
        case primaryIsbn13 = "primary_isbn13"
        case primaryIsbn10 = "primary_isbn10"
    }
}

struct BestSellersAPIClient {
    private init() {}
    static let manager = BestSellersAPIClient()
    //TODO: interpolate the genre with dashes into the end of url
    static let urlStr = "https://api.nytimes.com/svc/books/v3/lists.json?api-key=745b163551dc4d689f281bd639659128&list=paperback-nonfiction"
    func getCategories(with urlStr: String,
                       completionHandler: @escaping ([ResultsWrapper]) -> Void,
                       errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let allBookResults = try JSONDecoder().decode(ResultsWrapper.self, from: data)
                completionHandler([allBookResults])
            }
            catch {
                errorHandler(.couldNotParseJSON(rawError: error))
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

































