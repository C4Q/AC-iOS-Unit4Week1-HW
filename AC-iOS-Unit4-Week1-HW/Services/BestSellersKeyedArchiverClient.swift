//
//  KeyedArchiverClient.swift
//  CollectionViewsMorning
//
//  Created by Richard Crichlow on 12/14/17.
//  Copyright © 2017 Richard Crichlow. All rights reserved.
//

import Foundation

class BestSellersKeyedArchiverClient {
    
    //using a singleton to manage the model
    private init() {}
    static let manager = BestSellersKeyedArchiverClient()
    
    //pathName should be the category
    //static let pathName = "BestSellersBooks.plist"
    private var aSpecificCategoryOfBestSellerArray = [BestSellers]() //{
//        didSet {
//            saveBestSellers()
//        }
//    }

//    func add(bestSeller: BestSellers) {
//        aSpecificCategoryOfBestSellerArray.append(bestSeller)
//    }
    func addBestSellersArray(BestSellers: [BestSellers]) {
        self.aSpecificCategoryOfBestSellerArray = BestSellers
    }
    
    func getBestSellers() -> [BestSellers] {//Populate the VC's array with the current array of Books
        return self.aSpecificCategoryOfBestSellerArray
    }

    func loadData(encoded category: String) {//Load Data based on the category
        let correctedPath = category + "plist"
        let path = dataFilePath(withPathName: correctedPath)
        do {
            let data = try Data(contentsOf: path)
            let books = try PropertyListDecoder().decode([BestSellers].self, from: data)
            self.aSpecificCategoryOfBestSellerArray = books
        }
        catch {
            print(error)
        }
    }

    func saveBestSellers(encoded category: String) {//Save Data with the category as the path name
        let correctedPath = category + "plist"
        let path = dataFilePath(withPathName: correctedPath)
        do {
            let data = try PropertyListEncoder().encode(aSpecificCategoryOfBestSellerArray)
            try data.write(to: path, options: .atomic)
        }
        catch {
            print(error)
        }
    }

    private func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    // returns the path for supplied name from the dcouments directory
    private func dataFilePath(withPathName path: String) -> URL {
        return BestSellersKeyedArchiverClient.manager.documentsDirectory().appendingPathComponent(path)
    }

}
