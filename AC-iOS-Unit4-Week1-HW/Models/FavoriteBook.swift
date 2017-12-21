//
//  FavoriteBook.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Luis Calle on 12/21/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

struct FavoriteBook: Codable {
    let title: String
    let author: String?
    let subtitle: String?
    let longDescription: String
    let isbn: String
}
