//
//  NYTBookCategories.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Tyler Zhao on 12/18/17.
//  Copyright © 2017 Tyler Zhao. All rights reserved.
//

import Foundation

struct NYTBookCategories: Codable {
    let results: [Categories]
}

struct Categories: Codable {
    let display_name: String
    let list_name: String
}
