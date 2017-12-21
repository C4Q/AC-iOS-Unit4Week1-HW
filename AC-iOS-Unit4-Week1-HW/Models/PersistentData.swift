//
//  PersistentData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

//used just for accessing stuff w/ file manager
class PersistentData {
    private init() {}
    static let manager = PersistentData()
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    //get document directory
    private func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return paths[0]
    }
    
    //get file path for name passed in
    func dataFilePath(fileName: String) -> URL {
        return documentDirectory().appendingPathComponent(fileName)
    }
    
    //save
    func saveItem(_ item: Any, atFileName fileName: String, isBestSeller: Bool = false) {
        let filePath = dataFilePath(fileName: fileName)
        
        do {
            let data: Data
            
            switch fileName {
            case "Categories.plist":
                data = try encoder.encode(item as! [String])
            case _ where isBestSeller:
                data = try encoder.encode(item as! [BestSeller])
            default:
                return
            }
            
            try data.write(to: filePath)
        } catch let error {
            print(error)
        }
    }
    
    //load
    func loadItems(fromFileName fileName: String, isBestSeller: Bool = false) -> Any? {
        let filePath = dataFilePath(fileName: fileName)
        let data: Data
        
        do {
            switch fileName {
            case "Categories.plist":
                data = try Data(contentsOf: filePath)
                let categories = try decoder.decode([String].self, from: data)
                return categories
            case _ where isBestSeller:
                data = try Data(contentsOf: filePath)
                let bestSellers = try decoder.decode([BestSeller].self, from: data)
                return bestSellers
            default:
                return nil
            }
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    //delete
    //to do for favorite books
    
}
