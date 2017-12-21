//
//  BestSellerData.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/20/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class BestSellerData {
    private init() {}
    static let manager = BestSellerData()
    
    //save
    func saveBestSellers(_ bestSellers: [BestSeller], inCategory category: String) {
        
        PersistentData.manager.saveItem(bestSellers, atFileName: pListName(ofCategory: category))
    }
    
    //get
    func getBestSellers(inCategory category: String) -> [BestSeller]? {
        
        guard let bestSellers = PersistentData.manager.loadItems(fromFileName: pListName(ofCategory: category)) as? [BestSeller] else {
            return nil
        }
        
        return bestSellers
    }
    
    private func pListName(ofCategory category: String) -> String {
        return category + ".plist"
    }
    
}
