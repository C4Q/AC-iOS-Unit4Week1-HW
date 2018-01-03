//
//  Book.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

struct BookAPIClient {
    private init() {}
    static let manager = BookAPIClient()
    func getBooks(from urlStr: String, completionHandler: @escaping (BookResult) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let books = try JSONDecoder().decode(BookResult.self, from: data)
                completionHandler(books)
            }
            catch {
                print(error)
            }
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: {print($0)})
    }
    
}


struct BookResult: Codable {
    let status: String
    let copyright: String
    let numResults: Int
    let lastModified: String
    let results: [Book]
}

struct Book: Codable {
    let listName: String
    let displayName: String
    let bestsellersDate: String
    let publishedDate: String
    let rank: Int
    let rankLastWeek: Int
    let weeksOnList: Int
    let asterisk: Int
    let dagger: Int
    let amazonProductURL: String
    var isbnSummary: String?
    let isbns: [Isbn]
    let bookDetails: [BookDetail]
    let reviews: [Review]
    var imageLinks: ImageLinks?
}

struct Review: Codable {
    let bookReviewLink: String
    let firstChapterLink: String
    let sundayReviewLink: String
    let articleChapterLink: String
}

struct Isbn: Codable {
    let isbn10: String
    let isbn13: String
}

struct BookDetail: Codable {
    let title: String
    let summary: String?
    let contributor: String
    let author: String
    let contributorNote: String
    let price: Double
    let ageGroup: String
    let publisher: String
    let primaryIsbn13: String
    let primaryIsbn10: String
}

struct BookPassedInSegue {
    let name: String
    let summary: String
    let image: UIImage?
}

extension BookResult {
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case copyright = "copyright"
        case numResults = "num_results"
        case lastModified = "last_modified"
        case results = "results"
    }
}

extension Book {
    enum CodingKeys: String, CodingKey {
        case isbnSummary
        case listName = "list_name"
        case displayName = "display_name"
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case rank = "rank"
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case asterisk = "asterisk"
        case dagger = "dagger"
        case amazonProductURL = "amazon_product_url"
        case isbns = "isbns"
        case bookDetails = "book_details"
        case reviews = "reviews"
        case imageLinks
    }
}

extension Review {
    enum CodingKeys: String, CodingKey {
        case bookReviewLink = "book_review_link"
        case firstChapterLink = "first_chapter_link"
        case sundayReviewLink = "sunday_review_link"
        case articleChapterLink = "article_chapter_link"
    }
}

extension Isbn {
    enum CodingKeys: String, CodingKey {
        case isbn10 = "isbn10"
        case isbn13 = "isbn13"
    }
}

extension BookDetail {
    enum CodingKeys: String, CodingKey {
        case title = "title"
        case summary = "description"
        case contributor = "contributor"
        case author = "author"
        case contributorNote = "contributor_note"
        case price = "price"
        case ageGroup = "age_group"
        case publisher = "publisher"
        case primaryIsbn13 = "primary_isbn13"
        case primaryIsbn10 = "primary_isbn10"
    }
}
