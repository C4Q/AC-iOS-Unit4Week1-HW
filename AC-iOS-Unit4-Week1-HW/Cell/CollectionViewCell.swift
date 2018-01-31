//
//  CollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var collectionViewBooks: BooksInfo?
    @IBOutlet weak var shortDescription: UITextView!
    @IBOutlet weak var numberOfWeeks: UILabel!
    @IBOutlet weak var BookImage: UIImageView!
}
