//
//  BestSellerCollectionViewCell.swift
//  AC-iOS-Unit4-Week1-HW
//
//  Created by C4Q on 12/16/17.
//  Copyright © 2017 C4Q . All rights reserved.
//

import UIKit

class BestSellerCollectionViewCell: UICollectionViewCell {
    
 
    @IBOutlet weak var bestSellerImageView: UIImageView!
    @IBOutlet weak var weeksOnListLabel: UILabel!
    @IBOutlet weak var shortDescriptionTextView: UITextView!
    
    var myGoogleBook: BookWrapper?
    
    
}
