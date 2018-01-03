//
//  FavoriteModel.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Masai Young on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

struct FavoriteModel {
    private init() {}
    static let manager = FavoriteModel()
    
    func storeImageToDisk(image: UIImage, book: Book) -> Bool {
        // packing data from image
        guard let imageData = UIImagePNGRepresentation(image) else { return false }
        guard let hashingISBN = ISBNAPIClient.manager.hashingISBN(book: book) else { return false }
        // writing and saving to documents folder
        
        // 1) save image from favorite photo
        let imageURL = KeyedArchiverModel.shared.dataFilePath(pathName: hashingISBN)
        do {
            try imageData.write(to: imageURL)
        } catch {
            print("image saving error: \(error.localizedDescription)")
        }
        return true
    }
    
    func imageFromDisk(book: Book) -> UIImage? {
        guard let hashingISBN = ISBNAPIClient.manager.hashingISBN(book: book) else { return nil }
        let imageURL = KeyedArchiverModel.shared.dataFilePath(pathName: hashingISBN)
        let docImage = UIImage(contentsOfFile: imageURL.path)
        return docImage
    }
}

