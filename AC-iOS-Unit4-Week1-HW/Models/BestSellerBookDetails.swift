//
//  BestSellerBookDetails.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Clint Mejia on 12/17/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import Foundation

//The cover
//The subtitle (if applicable)
//A long description

struct BestSellerBookDetals: Codable {
    let items: [Volume]
}

struct Volume: Codable {
    let volumeInfo: VolumeInfo
}

struct VolumeInfo: Codable {
    let subtitle: String
    let description: String
    let imageLinks: ImageLinks
}

struct ImageLinks: Codable {
    let smallThumbnail: String
    let thumbnail: String
}

