//
//  BookCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/15/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var collectionTextView: UITextView!
    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var collectionImageView: UIImageView!
    var googleBooks: GoogleBooks!
}
