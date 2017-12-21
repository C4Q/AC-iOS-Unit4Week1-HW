//
//  GoogleBooksIsbnAPIClient.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit
//EndPoint #3
struct BookInfoFromGoogle: Codable {
    let items: [ItemsInfo]
}

struct ItemsInfo: Codable {
    let volumeInfo: VolumeInfoWrapper
}

struct VolumeInfoWrapper: Codable {
    let title: String
    let subtitle: String
    let description: String //long description
    let imageLinks: ImageLinksWrapper
}

struct ImageLinksWrapper: Codable {
    let smallThumbnail: String //url str
    let thumbnail: String//url str
}

struct GoogleBooksIsbnAPIClient { //deals with the specific structure we're working with
    private init() {}
    static let manager = GoogleBooksIsbnAPIClient()
    //TODO: INTERPOLATE ISBN13 AT THE END OF URL
    static let urlStr = "https://www.googleapis.com/books/v1/volumes?q=+isbn:9780525562511"
    func getCategories(with urlStr: String,
                       completionHandler: @escaping ([ItemsInfo]) -> Void,
                       errorHandler: @escaping (AppError) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(.badURL)
            return
        }
        let completion: (Data) -> Void = {(data: Data) in
            do {
                let googleBookInfolist = try JSONDecoder().decode(ItemsInfo.self, from: data)
                completionHandler([googleBookInfolist])
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

class ImageAPIClient {
    private init() {}
    static let manager = ImageAPIClient()
    func getImage(from urlStr: String,
                  completionHandler: @escaping (UIImage) -> Void,
                  errorHandler: @escaping (Error) -> Void) {
        guard let url = URL(string: urlStr) else {
            errorHandler(AppError.badURL)
            return }
        //let request = URLRequest(url: url)
        let completion: (Data) -> Void = {(data: Data) in
            guard let onlineImage = UIImage(data: data) else {
                errorHandler(AppError.notAnImage)
                return
            }
            completionHandler(onlineImage)
        }
        NetworkHelper.manager.performDataTask(with: url,
                                              completionHandler: completion,
                                              errorHandler: errorHandler)
    }
}

//note: for the completion handler {cell.bookiangeView.image = $0}








////Mark: -Image APIClient
// //API Client to decode JSON and get Image Data from online
//struct OnlineImageAPIClient {
//    //Singleton
//    private init() {}
//    static let manager = OnlineImageAPIClient()
//    //Image Helper - get images from online
//    //Method to get Data
//    func getImagesData(from urlStr: String, completionHandler: @escaping (UIImage)->Void, errorHandler: @escaping (AppError)->Void){
//        //guard URL for nil
//        guard let onlineImage = UIImage(data: data) else {errorHandler(.notAnImage); return}
//        //Create Completion
//        let completion: (Data)-> Void = {(data: Data) in
//            guard let onlineImage = UIImage(data: data) else {
//                errorHandler(AppError.notAnImage)
//                return
//            }
//            completionHandler(onlineImage)
//        }
//    }
//        //Call NetworkHelper
//        NetworkHelper.manager.performDataTask(withURL: urlStr, completionHandler: completion, errorHandler: errorHandler)
//    }


