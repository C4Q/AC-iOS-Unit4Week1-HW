//
//  BestSellerCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by Reiaz Gafar on 12/14/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bestSellerImageView: UIImageView!
    
    @IBOutlet weak var bestSellerTitleLabel: UILabel!
    
    @IBOutlet weak var bestSellerSummaryTextView: UITextView!
    
    @IBOutlet weak var bestSellerTimeLabel: UILabel!
    
    var gBook: GoogleBook?
    
}
