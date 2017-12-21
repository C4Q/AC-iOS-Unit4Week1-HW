//
//  PickerView.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/18/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

class PickerCategories {
    private init() {}
    static let manager = PickerCategories()
    static private var categories = [CategoryResults]()
    static func setCategories(from array: [CategoryResults]) {
        self.categories = array
    }
    static func loadCategories() -> [CategoryResults] {
        return categories
    }
}
