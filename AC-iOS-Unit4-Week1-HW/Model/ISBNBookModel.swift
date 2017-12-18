//
//  ISBNBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class ISBNAPIClient {
    private init() {}
    static let manager = ISBNAPIClient()
    
    private var isbnBooks = [ISBNBook]()
    
    func addISBNbook(book: ISBNBook) {
        isbnBooks.append(book)
    }
    
    func getISBNbooks() -> [ISBNBook] {
        return isbnBooks
    }
    
    func removeISBNbooks() {
        isbnBooks = [ISBNBook]()
    }
    
    func ISBNEndpintFromBook(_ book: Book) -> String? {
        let endpointHost = "https://www.googleapis.com/books/v1/volumes?q=+isbn:"
        if let primaryISBN = book.bookDetails.first?.primaryIsbn10 {
            return endpointHost + primaryISBN
        } else if let secondaryISBN = book.isbns.first?.isbn10 {
            return endpointHost + secondaryISBN
        } else {
            return nil
        }
    }
    
    func hashingISBN(book: Book) -> String? {
        guard let isbnEndpoint = ISBNAPIClient.manager.ISBNEndpintFromBook(book),
            let isbnSubstring = String(isbnEndpoint.reversed()).split(separator: ":").first else { return nil }
        
        let isbn = String(isbnSubstring)
        return isbn
    }
    
    func fetchISBNBook(from urlStr: String, completionHandler: @escaping (ISBNBook) -> Void, errorHandler: (Error) -> Void) {
        guard let url = URL(string: urlStr) else {return}
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let book = try JSONDecoder().decode(ISBNBook.self, from: data)
                completionHandler(book)
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

struct ISBNBook: Codable {
    let kind: String
    let totalItems: Int
    let items: [Item]?
}

struct Item: Codable {
    let kind: String
    let id: String
    let etag: String
    let selfLink: String
    let volumeInfo: VolumeInfo
    let searchInfo: SearchInfo
}

struct VolumeInfo: Codable {
    let title: String
    let authors: [String]
    let description: String
    let imageLinks: ImageLinks
    let language: String
    let previewLink: String
    let infoLink: String
}


struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

struct SearchInfo: Codable {
    let textSnippet: String
}


