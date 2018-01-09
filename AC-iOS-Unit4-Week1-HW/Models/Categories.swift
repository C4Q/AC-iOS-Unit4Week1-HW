//
//  Categories.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation


struct CatergoryInfo: Codable {
    let results: [Categories]
}


struct Categories: Codable{
    let categoryName: String
    let categoryKey: String
    
    
    enum CodingKeys: String, CodingKey{
        case categoryName = "display_name"
        case categoryKey = "list_name_encoded"
    }
    
}
